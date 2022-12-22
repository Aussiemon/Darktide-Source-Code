local UIWorldSpawner = require("scripts/managers/ui/ui_world_spawner")
local ViewElementInputLegend = require("scripts/ui/view_elements/view_element_input_legend/view_element_input_legend")
local ViewElementMenuPanel = require("scripts/ui/view_elements/view_element_menu_panel/view_element_menu_panel")
local Views = require("scripts/ui/views/views")
local TabbedMenuViewBase = class("TabbedMenuViewBase", "BaseView")

TabbedMenuViewBase.init = function (self, definitions, settings, context)
	self._context = context
	self._tab_bar_views = {}
	self._active_view = nil

	TabbedMenuViewBase.super.init(self, definitions, settings, context)

	self._can_close = not context or context.can_exit
end

TabbedMenuViewBase.on_enter = function (self)
	TabbedMenuViewBase.super.on_enter(self)

	self._can_navigate = false
	self._allow_close_hotkey = false
	local definitions = self._definitions

	if definitions.background_world_params then
		self:_setup_background_world(definitions.background_world_params)
	end

	if definitions.tab_bar_params then
		self:_setup_tab_bar(definitions.tab_bar_params)
	end

	if definitions.input_legend_params then
		self:_setup_input_legend(definitions.input_legend_params)
	end
end

TabbedMenuViewBase.on_exit = function (self)
	self:_close_active_view()

	if self._world_spawner then
		self._world_spawner:destroy()

		self._world_spawner = nil
	end

	TabbedMenuViewBase.super.on_exit(self)
end

TabbedMenuViewBase.get_current_tabs = function (self)
	return self._tab_bar_views
end

TabbedMenuViewBase.update = function (self, dt, t, input_service)
	if self._active_view_on_enter_callback and self._active_view_on_enter_callback() then
		self._active_view_on_enter_callback = nil
	end

	local next_tab_index = self._next_tab_index

	if next_tab_index then
		local handle_tab_switch = true

		if self._previously_active_view and Managers.ui:is_view_closing(self._previously_active_view) then
			handle_tab_switch = false
		else
			self._previously_active_view = nil
		end

		if handle_tab_switch then
			self:_switch_tab(next_tab_index)

			self._next_tab_index = nil
		end
	end

	local world_spawner = self._world_spawner

	if world_spawner then
		world_spawner:update(dt, t)
	end

	return TabbedMenuViewBase.super.update(self, dt, t, input_service)
end

TabbedMenuViewBase._blur_fade_in = function (self, duration, anim_func)
	if self._world_spawner then
		self._world_spawner:set_camera_blur(0.75, duration, anim_func)
	end

	self._blurred = true
end

TabbedMenuViewBase._blur_fade_out = function (self, duration, anim_func)
	if self._world_spawner then
		self._world_spawner:set_camera_blur(0, duration, anim_func)
	end

	self._blurred = false
end

TabbedMenuViewBase.set_active_view_instance = function (self, view)
	self._active_view_instance = view
end

TabbedMenuViewBase.set_can_navigate = function (self, value)
	local has_tab_bar_menu = self._elements.tab_bar ~= nil and #self._tab_bar_views > 1
	self._can_navigate = value and has_tab_bar_menu
end

TabbedMenuViewBase.cb_on_close_pressed = function (self)
	self:_handle_back_pressed()
end

TabbedMenuViewBase.cb_switch_tab = function (self, index)
	if self._can_navigate then
		self._next_tab_index = index
	end
end

TabbedMenuViewBase.event_register_camera = function (self, camera_unit)
	local world_params = self._definitions.background_world_params

	self:_unregister_event(world_params.register_camera_event)

	local viewport_name = world_params.viewport_name or self.view_name .. "_viewport"
	local viewport_type = world_params.viewport_type or "default"
	local viewport_layer = world_params.viewport_layer or 1
	local shading_environment = world_params.shading_environment

	self._world_spawner:create_viewport(camera_unit, viewport_name, viewport_type, viewport_layer, shading_environment)
end

TabbedMenuViewBase._setup_background_world = function (self, world_params)
	if world_params.register_camera_event then
		self:_register_event(world_params.register_camera_event, "event_register_camera")
	end

	local world_name = world_params.world_name or self.view_name .. "_world"
	local world_layer = world_params.world_layer or 1
	local world_timer_name = world_params.timer_name or "ui"
	self._world_spawner = UIWorldSpawner:new(world_name, world_layer, world_timer_name, self.view_name)

	if self._context then
		self._context.background_world_spawner = self._world_spawner
	end

	local level_name = world_params.level_name

	if level_name then
		self._world_spawner:spawn_level(level_name)
	end
end

TabbedMenuViewBase._setup_tab_bar = function (self, tab_bar_params, additional_context)
	if self._previous_story_name then
		local play_backwards = true
		local world_spawner = self._world_spawner
		local active_story_id = world_spawner:active_story_id()
		local start_time = nil

		if active_story_id then
			start_time = world_spawner:story_time(active_story_id)
		end

		world_spawner:play_story(self._previous_story_name, start_time, play_backwards)

		self._previous_story_name = nil
	end

	if self._elements.tab_bar then
		self:_remove_element("tab_bar")
	end

	local tab_bar_views = table.clone_instance(tab_bar_params.tabs_params)

	for i = 1, #tab_bar_views do
		local tab_view = tab_bar_views[i]
		local context = tab_view.context or {}

		if additional_context then
			table.merge(context, additional_context)
		end

		tab_view.context = context
	end

	local use_tab_bar = #tab_bar_views > 0 and not tab_bar_params.hide_tabs

	if use_tab_bar then
		local layer = tab_bar_params.layer or 10
		local tab_bar = self:_add_element(ViewElementMenuPanel, "tab_bar", layer)

		for i = 1, #tab_bar_views do
			local tab_params = tab_bar_views[i]
			local show_tab = true

			if show_tab then
				local view = tab_params.view
				local title_loc_key = tab_params.display_name

				if not title_loc_key then
					local view_settings = Views[view]
					title_loc_key = view_settings.display_name
				end

				local title = Localize(title_loc_key)
				local callback = callback(self, "cb_switch_tab", i)
				local update_function = tab_params.update

				tab_bar:add_entry(title, callback, update_function)
			end
		end
	end

	self._tab_bar_views = tab_bar_views

	self:set_can_navigate(not tab_bar_params.hide_tabs)

	self._next_tab_index = #tab_bar_views > 0 and 1 or nil
end

TabbedMenuViewBase._setup_input_legend = function (self, input_legend_params)
	if self:_element("input_legend") then
		self:_remove_element("input_legend")
	end

	local layer = input_legend_params.layer or 10

	self:_add_element(ViewElementInputLegend, "input_legend", layer)

	local buttons_params = input_legend_params.buttons_params

	for i = 1, #buttons_params do
		local legend_input = buttons_params[i]

		self:add_input_legend_entry(legend_input)
	end
end

TabbedMenuViewBase.add_input_legend_entry = function (self, entry_params)
	local input_legend = self:_element("input_legend")
	local press_callback = nil
	local on_pressed_callback = entry_params.on_pressed_callback

	if on_pressed_callback then
		local callback_parent = self[on_pressed_callback] and self or nil

		if not callback_parent and self._active_view then
			local view_instance = self._active_view and Managers.ui:view_instance(self._active_view)
			callback_parent = view_instance
		end

		press_callback = callback_parent and callback(callback_parent, on_pressed_callback)
	end

	return input_legend:add_entry(entry_params.display_name, entry_params.input_action, entry_params.visibility_function, press_callback, entry_params.alignment)
end

TabbedMenuViewBase.remove_input_legend_entry = function (self, id)
	local input_legend = self:_element("input_legend")

	return input_legend and input_legend:remove_entry(id)
end

TabbedMenuViewBase.input_legend_entry_set_display_name = function (self, entry_id, display_name, suffix)
	local input_legend = self:_element("input_legend")

	if input_legend then
		input_legend:set_display_name(entry_id, display_name, suffix)
	end
end

TabbedMenuViewBase._switch_tab = function (self, index)
	local tab_bar_menu = self._elements.tab_bar

	if tab_bar_menu then
		tab_bar_menu:set_selected_panel_index(index)
	end

	local tab_params = self._tab_bar_views[index]
	local view = tab_params.view
	local view_function = tab_params.view_function
	local view_input_legend_buttons = tab_params.input_legend_buttons
	local current_view = self._active_view
	local ui_manager = Managers.ui

	if view ~= current_view or not current_view then
		self:_close_active_view()

		self._active_view = view

		if view then
			local context = {
				parent = self
			}
			local additional_context = tab_params.context
			local context_function = tab_params.context_function

			if context_function then
				additional_context = context_function()
			end

			if additional_context then
				table.merge(context, additional_context)
			end

			ui_manager:open_view(view, nil, nil, nil, nil, context)

			local input_legend_params = self._definitions.input_legend_params

			if input_legend_params then
				local merged_input_legend_params = nil

				if view_input_legend_buttons then
					merged_input_legend_params = table.clone(input_legend_params)

					table.append(merged_input_legend_params.buttons_params, view_input_legend_buttons)
				end

				self:_setup_input_legend(merged_input_legend_params or input_legend_params)
			end
		end
	end

	self._active_view_on_enter_callback = self._active_view and view_function and callback(function ()
		if self._active_view == view then
			local view_instance = ui_manager:view_instance(self._active_view)

			if view_instance and view_instance:entered() then
				view_instance[view_function](view_instance)

				return true
			end
		end

		return false
	end)
	local story_name = tab_params.level_story_event

	if story_name then
		if not self._previous_story_name or self._previous_story_name ~= story_name then
			self._world_spawner:play_story(story_name)

			self._previous_story_name = story_name
		end
	else
		self._previous_story_name = nil
	end
end

TabbedMenuViewBase._handle_input = function (self, input_service)
	local tab_bar_menu = self._elements.tab_bar
	local can_navigate = self._can_navigate

	if tab_bar_menu then
		tab_bar_menu:set_is_handling_navigation_input(can_navigate)
	end

	if input_service:get("back") then
		self:_handle_back_pressed()
	end
end

TabbedMenuViewBase._handle_back_pressed = function (self)
	local active_view_instance = self._active_view_instance
	local handled_by_active_view_instance = active_view_instance and active_view_instance.on_back_pressed and active_view_instance:on_back_pressed()

	if not handled_by_active_view_instance then
		local view_name = self.view_name

		Managers.ui:close_view(view_name)
	end
end

TabbedMenuViewBase._close_active_view = function (self)
	local ui_manager = Managers.ui
	local active_view_name = self._active_view

	if active_view_name and ui_manager:view_active(active_view_name) then
		ui_manager:close_view(active_view_name)
	end

	self._previously_active_view = self._active_view
	self._active_view_instance = nil
	self._active_view = nil
end

TabbedMenuViewBase.selected_index = function (self)
	local tab_bar_menu = self._elements.tab_bar

	if tab_bar_menu then
		return tab_bar_menu:selected_index()
	end
end

TabbedMenuViewBase.set_selected_panel_index = function (self, index)
	local tab_bar_menu = self._elements.tab_bar

	if tab_bar_menu then
		tab_bar_menu:set_selected_panel_index(index)
	end
end

TabbedMenuViewBase.set_is_handling_navigation_input = function (self, is_enabled)
	local tab_bar_menu = self._elements.tab_bar

	if tab_bar_menu then
		tab_bar_menu:set_is_handling_navigation_input(is_enabled)
	end
end

return TabbedMenuViewBase
