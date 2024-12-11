-- chunkname: @scripts/ui/views/tabbed_menu_view_base.lua

local UIWorldSpawner = require("scripts/managers/ui/ui_world_spawner")
local ViewElementInputLegend = require("scripts/ui/view_elements/view_element_input_legend/view_element_input_legend")
local ViewElementMenuPanel = require("scripts/ui/view_elements/view_element_menu_panel/view_element_menu_panel")
local UIProfileSpawner = require("scripts/managers/ui/ui_profile_spawner")
local Views = require("scripts/ui/views/views")
local Breeds = require("scripts/settings/breed/breeds")
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
		self:_setup_tab_bar(definitions.tab_bar_params, definitions.additional_context, definitions.optional_start_index)
	end

	if definitions.input_legend_params then
		self:_setup_input_legend(definitions.input_legend_params)
	end
end

TabbedMenuViewBase.on_exit = function (self)
	self:_close_active_view()
	self:despawn_active_profile()

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

	if self._tab_bar_views then
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
	end

	local world_spawner = self._world_spawner

	if world_spawner then
		world_spawner:update(dt, t)

		if self._profile_spawner then
			self._profile_spawner:update(dt, t, input_service)
		end
	end

	if self._tab_bar_visibility_function then
		local visible = self._tab_bar_visibility_function(self)
		local tab_bar = self._elements and self._elements.tab_bar

		if tab_bar and tab_bar:visible() ~= visible then
			tab_bar:set_visibility(visible)
		end
	end

	return TabbedMenuViewBase.super.update(self, dt, t, input_service)
end

TabbedMenuViewBase.set_bar_visibility = function (self, visible)
	local tab_bar = self._elements and self._elements.tab_bar

	if tab_bar then
		tab_bar:set_visibility(visible)
	end
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
	local has_tab_bar_menu = self._elements and self._elements.tab_bar ~= nil and #self._tab_bar_views > 1
	local tab_bar_menu = self._elements and self._elements.tab_bar

	if tab_bar_menu then
		tab_bar_menu:set_is_handling_navigation_input(has_tab_bar_menu)
	end

	self._can_navigate = has_tab_bar_menu
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

	self:_register_event("event_register_character_spawn_point")

	local level_name = world_params.level_name

	if level_name then
		self._world_spawner:spawn_level(level_name)
	end
end

TabbedMenuViewBase.event_register_character_spawn_point = function (self, spawn_point_unit)
	self:_unregister_event("event_register_character_spawn_point")

	self._spawn_point_unit = spawn_point_unit
end

TabbedMenuViewBase.despawn_active_profile = function (self)
	if self._profile_spawner then
		self._profile_spawner:destroy()

		self._profile_spawner = nil
	end
end

TabbedMenuViewBase.spawn_profile = function (self, profile, visible_on_spawn)
	self:despawn_active_profile()

	local spawn_point_unit = self._spawn_point_unit
	local world_params = self._definitions.background_world_params
	local world = self._world_spawner:world()
	local camera = self._world_spawner:camera()
	local unit_spawner = self._world_spawner:unit_spawner()
	local name = self.__class_name

	self._profile_spawner = UIProfileSpawner:new(name, world, camera, unit_spawner)

	self._profile_spawner:set_visibility(visible_on_spawn or false)

	local spawn_position = Unit.world_position(spawn_point_unit, 1)
	local spawn_rotation = Unit.world_rotation(spawn_point_unit, 1)

	self._spawn_point_position = Vector3.to_array(spawn_position)

	self._profile_spawner:spawn_profile(profile, spawn_position, spawn_rotation)

	local archetype_settings = profile.archetype
	local archetype_name = archetype_settings.name
	local breed_name = archetype_settings.breed
	local breed_settings = Breeds[breed_name]
	local character_creation_state_machine = breed_settings.character_creation_state_machine
	local animations_per_archetype = world_params.animations_per_archetype
	local animations_settings = animations_per_archetype[archetype_name]
	local animation_event = animations_settings.initial_event

	self._profile_spawner:assign_state_machine(character_creation_state_machine, animation_event)
end

TabbedMenuViewBase.set_profile_visible = function (self, visible)
	self._profile_spawner:set_visibility(visible)
end

TabbedMenuViewBase.profile_spawner = function (self)
	return self._profile_spawner
end

TabbedMenuViewBase._setup_tab_bar = function (self, tab_bar_params, additional_context, optional_start_index)
	if self._previous_story_name then
		local play_backwards = true
		local world_spawner = self._world_spawner
		local active_story_id = world_spawner:active_story_id()
		local start_time

		if active_story_id then
			start_time = world_spawner:story_time(active_story_id)
		end

		world_spawner:play_story(self._previous_story_name, start_time, play_backwards)

		self._previous_story_name = nil
	end

	if self._elements and self._elements.tab_bar then
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

		self._tab_bar_visibility_function = tab_bar_params.visibility_function

		if self._tab_bar_visibility_function then
			tab_bar:set_visibility(false)
		end
	end

	self._tab_bar_views = tab_bar_views

	self:set_can_navigate()

	self._next_tab_index = #tab_bar_views > 0 and (optional_start_index and math.clamp(optional_start_index, 0, #tab_bar_views) or 1) or nil
end

TabbedMenuViewBase._setup_input_legend = function (self, input_legend_params)
	if self:_element("input_legend") then
		self:_remove_element("input_legend")
	end

	local layer = input_legend_params.layer or 10

	self._input_legend_element = self:_add_element(ViewElementInputLegend, "input_legend", layer)

	local buttons_params = input_legend_params.buttons_params

	for i = 1, #buttons_params do
		local legend_input = buttons_params[i]

		self:add_input_legend_entry(legend_input)
	end
end

TabbedMenuViewBase.add_input_legend_entry = function (self, entry_params)
	local input_legend = self:_element("input_legend")
	local press_callback
	local on_pressed_callback = entry_params.on_pressed_callback

	if on_pressed_callback then
		local callback_parent = self[on_pressed_callback] and self or nil

		if not callback_parent and self._active_view then
			local view_instance = self._active_view and Managers.ui:view_instance(self._active_view)

			callback_parent = view_instance
		end

		press_callback = callback_parent and callback(callback_parent, on_pressed_callback)
	end

	local display_name = entry_params.display_name
	local input_action = entry_params.input_action
	local visibility_function = entry_params.visibility_function
	local alignment = entry_params.alignment
	local suffix_function = entry_params.suffix_function

	return input_legend:add_entry(display_name, input_action, visibility_function, press_callback, alignment, nil, nil, nil, suffix_function)
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
	local tab_bar_menu = self._elements and self._elements.tab_bar

	if tab_bar_menu then
		tab_bar_menu:set_selected_panel_index(index)
	end

	local tab_params = self._tab_bar_views[index]
	local view = tab_params.view
	local view_function = tab_params.view_function
	local view_function_context = tab_params.view_function_context
	local view_function_on_level_story_complete = tab_params.view_function_on_level_story_complete
	local view_input_legend_buttons = tab_params.input_legend_buttons
	local current_view = self._active_view
	local ui_manager = Managers.ui

	if view ~= current_view or not current_view then
		self:_close_active_view()

		self._active_view = view

		if view then
			local context = {
				parent = self,
				hub_interaction = self._hub_interaction,
			}
			local additional_context = tab_params.context
			local context_function = tab_params.context_function

			if context_function then
				additional_context = context_function(self)
			end

			if additional_context then
				table.merge(context, additional_context)
			end

			ui_manager:open_view(view, nil, nil, nil, nil, context)

			local view_instance = ui_manager:view_instance(view)

			self:set_active_view_instance(view_instance)

			local input_legend_params = self._definitions.input_legend_params

			if input_legend_params then
				local merged_input_legend_params

				if view_input_legend_buttons then
					merged_input_legend_params = table.clone(input_legend_params)

					table.append(merged_input_legend_params.buttons_params, view_input_legend_buttons)
				end

				self:_setup_input_legend(merged_input_legend_params or input_legend_params)
			end
		end
	end

	local story_name = tab_params.level_story_event
	local story_event_speed = tab_params.level_story_event_speed or 1
	local level_story_complete_callback_time_fraction = tab_params.level_story_complete_callback_time_fraction
	local active_view_callback = callback(function ()
		self._active_view_on_enter_callback = self._active_view and view_function and callback(function ()
			if self._active_view == view then
				local view_instance = ui_manager:view_instance(self._active_view)

				if view_instance and view_instance:entered() then
					view_instance[view_function](view_instance, view_function_context)

					return true
				end
			end

			return false
		end)
	end)
	local level_story_complete_callback

	if story_name and view_function_on_level_story_complete then
		level_story_complete_callback = active_view_callback
	else
		active_view_callback()
	end

	if self._world_spawner then
		self._world_spawner:set_story_speed(story_event_speed)

		if story_name then
			if not self._previous_story_name or self._previous_story_name ~= story_name then
				self._world_spawner:play_story(story_name, nil, nil, level_story_complete_callback, level_story_complete_callback_time_fraction)

				self._previous_story_name = story_name
			end
		else
			self._previous_story_name = nil
		end
	end
end

TabbedMenuViewBase._handle_input = function (self, input_service)
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
	local tab_bar_menu = self._elements and self._elements.tab_bar

	if tab_bar_menu then
		return tab_bar_menu:selected_index()
	end
end

TabbedMenuViewBase.set_selected_panel_index = function (self, index)
	local tab_bar_menu = self._elements and self._elements.tab_bar

	if tab_bar_menu then
		tab_bar_menu:set_selected_panel_index(index)
	end
end

TabbedMenuViewBase.set_is_handling_navigation_input = function (self, is_enabled)
	local tab_bar_menu = self._elements and self._elements.tab_bar

	if tab_bar_menu then
		tab_bar_menu:set_is_handling_navigation_input(is_enabled)
	end
end

return TabbedMenuViewBase
