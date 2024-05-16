-- chunkname: @scripts/ui/view_elements/view_element_mission_board_options/view_element_mission_board_options.lua

local definition_path = "scripts/ui/view_elements/view_element_mission_board_options/view_element_mission_board_options_definitions"
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UIWidget = require("scripts/managers/ui/ui_widget")
local WalletSettings = require("scripts/settings/wallet_settings")
local UIWidgetGrid = require("scripts/ui/widget_logic/ui_widget_grid")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local ScriptWorld = require("scripts/foundation/utilities/script_world")
local TextUtils = require("scripts/utilities/ui/text")
local DropdownPassTemplates = require("scripts/ui/pass_templates/dropdown_pass_templates")
local CheckboxPassTemplates = require("scripts/ui/pass_templates/checkbox_pass_templates")
local UIScenegraph = require("scripts/managers/ui/ui_scenegraph")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local WorldRenderUtils = require("scripts/utilities/world_render")
local ViewElemenMissionBoardOptions = class("ViewElemenMissionBoardOptions", "ViewElementBase")
local widget_update_functions = {
	dropdown = function (self, widget, input_service)
		local content = widget.content
		local entry = content.entry

		if content.close_setting then
			content.close_setting = nil
			content.exclusive_focus = false

			local hotspot = content.hotspot or content.button_hotspot

			if hotspot then
				hotspot.is_selected = false
			end

			return
		end

		local is_disabled = entry.disabled or false

		content.disabled = is_disabled

		local size = {
			400,
			50,
		}
		local using_gamepad = not Managers.ui:using_cursor_navigation()
		local offset = widget.offset
		local style = widget.style
		local options = content.options
		local options_by_id = content.options_by_id
		local num_visible_options = content.num_visible_options
		local num_options = #options
		local focused = content.exclusive_focus and not is_disabled

		if focused then
			offset[3] = 90
		else
			offset[3] = 0
		end

		local selected_index = content.selected_index
		local value, new_value
		local hotspot = content.hotspot
		local hotspot_style = style.hotspot

		if selected_index and focused then
			if using_gamepad and hotspot.on_pressed then
				new_value = options[selected_index].id
			end

			hotspot_style.on_pressed_sound = hotspot_style.on_pressed_fold_in_sound
		else
			hotspot_style.on_pressed_sound = hotspot_style.on_pressed_fold_out_sound
		end

		if entry.get_function then
			value = entry.get_function(entry)
		else
			value = content.internal_value or "<not selected>"
		end

		local localization_manager = Managers.localization
		local preview_option = options_by_id[value]
		local preview_option_id = preview_option and preview_option.id
		local preview_value = preview_option and preview_option.display_name or "loc_settings_option_unavailable"
		local ignore_localization = preview_option and preview_option.ignore_localization

		content.value_text = ignore_localization and preview_value or localization_manager:localize(preview_value)

		local always_keep_order = true
		local grow_downwards = true

		content.grow_downwards = grow_downwards

		local new_selection_index

		if not selected_index or not focused then
			for i = 1, #options do
				local option = options[i]

				if option.id == preview_option_id then
					selected_index = i

					break
				end
			end

			selected_index = selected_index or 1
		end

		if selected_index and focused then
			if input_service:get("navigate_up_continuous") then
				if grow_downwards or not grow_downwards and always_keep_order then
					new_selection_index = math.max(selected_index - 1, 1)
				else
					new_selection_index = math.min(selected_index + 1, num_options)
				end
			elseif input_service:get("navigate_down_continuous") then
				if grow_downwards or not grow_downwards and always_keep_order then
					new_selection_index = math.min(selected_index + 1, num_options)
				else
					new_selection_index = math.max(selected_index - 1, 1)
				end
			end
		end

		if new_selection_index or not content.selected_index then
			if new_selection_index then
				selected_index = new_selection_index
			end

			if num_visible_options < num_options then
				local step_size = 1 / num_options
				local new_scroll_percentage = math.min(selected_index - 1, num_options) * step_size

				content.scroll_percentage = new_scroll_percentage
				content.scroll_add = nil
			end

			content.selected_index = selected_index
		end

		local scroll_percentage = content.scroll_percentage

		if scroll_percentage then
			local step_size = 1 / (num_options - (num_visible_options - 1))

			content.start_index = math.max(1, math.ceil(scroll_percentage / step_size))
		end

		local option_hovered = false
		local option_index = 1
		local start_index = content.start_index or 1
		local end_index = math.min(start_index + num_visible_options - 1, num_options)
		local using_scrollbar = num_visible_options < num_options

		for i = start_index, end_index do
			local actual_i = i

			if not grow_downwards and always_keep_order then
				actual_i = end_index - i + start_index
			end

			local option_text_id = "option_text_" .. option_index
			local option_hotspot_id = "option_hotspot_" .. option_index
			local outline_style_id = "outline_" .. option_index
			local option_hotspot = content[option_hotspot_id]

			option_hovered = option_hovered or option_hotspot.is_hover
			option_hotspot.is_selected = actual_i == selected_index

			local option = options[actual_i]

			if option_hotspot.on_pressed then
				option_hotspot.on_pressed = nil
				new_value = option.id
				content.selected_index = actual_i
			end

			local option_display_name = option.display_name
			local option_ignore_localization = option.ignore_localization

			content[option_text_id] = option_ignore_localization and option_display_name or localization_manager:localize(option_display_name)

			local options_y = size[2] * option_index

			style[option_hotspot_id].offset[2] = grow_downwards and options_y or -options_y
			style[option_text_id].offset[2] = grow_downwards and options_y or -options_y

			local entry_length = using_scrollbar and size[1] - style.scrollbar_hotspot.size[1] or size[1]

			style[outline_style_id].size[1] = entry_length
			style[option_text_id].size[1] = size[1]
			option_index = option_index + 1
		end

		local value_changed = new_value ~= nil

		if value_changed and new_value ~= value then
			local on_activated = entry.on_activated

			on_activated(new_value, entry)
		end

		local scrollbar_hotspot = content.scrollbar_hotspot
		local scrollbar_hovered = scrollbar_hotspot.is_hover

		if (input_service:get("left_pressed") or input_service:get("confirm_pressed") or input_service:get("back")) and content.exclusive_focus and not content.wait_next_frame then
			content.wait_next_frame = true

			return
		end

		if content.wait_next_frame then
			content.wait_next_frame = nil
			content.close_setting = true

			return
		end
	end,
	checkbox = function (self, widget, input_service)
		local content = widget.content
		local entry = content.entry
		local value = entry.get_function(entry)
		local on_activated = entry.on_activated
		local pass_input = true
		local hotspot = content.hotspot
		local is_disabled = entry.disabled or false

		content.disabled = is_disabled

		local parent = self._parent
		local new_value

		if hotspot.on_pressed and not parent._navigation_column_changed_this_frame and not is_disabled then
			new_value = not value
		end

		for i = 1, 2 do
			local widget_option_id = "option_hotspot_" .. i
			local option_hotspot = content[widget_option_id]
			local is_selected = value and i == 1 or not value and i == 2

			option_hotspot.is_selected = is_selected
		end

		if new_value ~= nil and new_value ~= value then
			on_activated(new_value, entry)
		end
	end,
}

ViewElemenMissionBoardOptions.init = function (self, parent, draw_layer, start_scale, context)
	local definitions = require(definition_path)

	ViewElemenMissionBoardOptions.super.init(self, parent, draw_layer, start_scale, definitions)

	self._context = context

	self:_create_offscreen_renderer()
	self:_create_default_gui()
	self:_create_background_gui()
	self:_enable_settings_overlay(false)

	self._widgets_by_name.button.content.hotspot.pressed_callback = callback(self, "_close_button_pressed")
end

ViewElemenMissionBoardOptions._create_offscreen_renderer = function (self)
	local view_name = self.view_name
	local world_layer = 123
	local world_name = self.__class_name .. "_ui_mission_board_options_world"
	local world = Managers.ui:create_world(world_name, world_layer, nil, view_name)
	local viewport_name = "mission_board_options_viewport"
	local viewport_type = "overlay_offscreen_3"
	local viewport_layer = 1
	local viewport = Managers.ui:create_viewport(world, viewport_name, viewport_type, viewport_layer)
	local renderer_name = self.__class_name .. "mission_board_options_renderer"

	self._offscreen_renderer = Managers.ui:create_renderer(renderer_name, world)
	self._offscreen_world = {
		name = world_name,
		world = world,
		viewport = viewport,
		viewport_name = viewport_name,
		renderer_name = renderer_name,
	}
end

ViewElemenMissionBoardOptions._create_default_gui = function (self)
	local ui_manager = Managers.ui
	local class_name = self.__class_name
	local timer_name = "ui"
	local world_layer = 122
	local world_name = class_name .. "_ui_default_world"
	local view_name = self.view_name

	self._world = ui_manager:create_world(world_name, world_layer, timer_name, view_name)
	self._world_name = world_name
	self._world_draw_layer = world_layer
	self._world_default_layer = world_layer

	local viewport_name = class_name .. "_ui_default_world_viewport"
	local viewport_type = "overlay"
	local viewport_layer = 1

	self._viewport = ui_manager:create_viewport(self._world, viewport_name, viewport_type, viewport_layer)
	self._viewport_name = viewport_name
	self._ui_default_renderer = ui_manager:create_renderer(class_name .. "_ui_default_renderer", self._world)
end

ViewElemenMissionBoardOptions._create_background_gui = function (self)
	local ui_manager = Managers.ui
	local class_name = self.__class_name
	local timer_name = "ui"
	local world_layer = 121
	local world_name = class_name .. "_ui_background_world"
	local view_name = self.view_name

	self._background_world = ui_manager:create_world(world_name, world_layer, timer_name, view_name)
	self._background_world_name = world_name
	self._background_world_draw_layer = world_layer
	self._background_world_default_layer = world_layer

	local shading_environment = "content/shading_environments/ui/ui_popup_background"
	local shading_callback = callback(self, "cb_shading_callback")
	local viewport_name = class_name .. "_ui_background_world_viewport"
	local viewport_type = "overlay"
	local viewport_layer = 1

	self._background_viewport = ui_manager:create_viewport(self._background_world, viewport_name, viewport_type, viewport_layer, shading_environment, shading_callback)
	self._background_viewport_name = viewport_name
	self._ui_background_renderer = ui_manager:create_renderer(class_name .. "_ui_background_renderer", self._background_world)

	local max_value = 0.75

	WorldRenderUtils.enable_world_fullscreen_blur(world_name, viewport_name, max_value)
end

ViewElemenMissionBoardOptions.cb_shading_callback = function (self, world, shading_env, viewport, default_shading_environment_name)
	local gamma = Application.user_setting("gamma") or 0

	ShadingEnvironment.set_scalar(shading_env, "exposure_compensation", ShadingEnvironment.scalar(shading_env, "exposure_compensation") + gamma)

	local blur_value = World.get_data(world, "fullscreen_blur") or 0

	if blur_value > 0 then
		ShadingEnvironment.set_scalar(shading_env, "fullscreen_blur_enabled", 1)
		ShadingEnvironment.set_scalar(shading_env, "fullscreen_blur_amount", math.clamp(blur_value, 0, 1))
	else
		World.set_data(world, "fullscreen_blur", nil)
		ShadingEnvironment.set_scalar(shading_env, "fullscreen_blur_enabled", 0)
	end

	local greyscale_value = World.get_data(world, "greyscale") or 0

	if greyscale_value > 0 then
		ShadingEnvironment.set_scalar(shading_env, "grey_scale_enabled", 1)
		ShadingEnvironment.set_scalar(shading_env, "grey_scale_amount", math.clamp(greyscale_value, 0, 1))
		ShadingEnvironment.set_vector3(shading_env, "grey_scale_weights", Vector3(0.33, 0.33, 0.33))
	else
		World.set_data(world, "greyscale", nil)
		ShadingEnvironment.set_scalar(shading_env, "grey_scale_enabled", 0)
	end
end

ViewElemenMissionBoardOptions._set_exclusive_focus_on_grid_widget = function (self, widget_name)
	local widgets = self._grid_widgets
	local selected_widget

	for i = 1, #widgets do
		local widget = widgets[i]
		local selected = widget.name == widget_name
		local content = widget.content

		content.exclusive_focus = selected

		local hotspot = content.hotspot or content.button_hotspot

		if hotspot then
			hotspot.is_selected = selected

			if selected then
				selected_widget = widget
			end
		end
	end

	for i = 1, #self._widgets do
		local widget = self._widgets[i]

		if selected_widget and selected_widget ~= widget then
			if widget.content.hotspot then
				widget.content.hotspot.disabled = true
			end
		elseif widget.content.hotspot then
			widget.content.hotspot.disabled = false
		end
	end

	for i = 1, #widgets do
		local widget = widgets[i]

		if widget.content.hotspot then
			if selected_widget then
				widget.content.hotspot.disabled = widget ~= selected_widget
			else
				widget.content.hotspot.disabled = false
			end
		end
	end

	self._selected_widget = selected_widget

	local has_exclusive_focus = selected_widget ~= nil

	return selected_widget
end

ViewElemenMissionBoardOptions._handle_input = function (self, input_service, dt, t)
	local selected_widget = self._selected_widget

	if selected_widget then
		local close_selected_setting = false

		if input_service:get("left_pressed") or input_service:get("confirm_pressed") or input_service:get("back") then
			close_selected_setting = true
		end

		self._close_selected_setting = close_selected_setting
	elseif input_service:get("back") then
		self:_close_button_pressed()
	elseif not Managers.ui:using_cursor_navigation() then
		local selected_widget = self._selected_index or 1

		if input_service:get("navigate_down_continuous") and selected_widget < #self._grid_widgets then
			self._selected_index = selected_widget + 1

			local scroll_progress = self._grid:get_scrollbar_percentage_by_index(self._selected_index)

			self._grid:select_grid_index(self._selected_index, true, scroll_progress, true)
		elseif input_service:get("navigate_up_continuous") and selected_widget > 1 then
			self._selected_index = selected_widget - 1

			local scroll_progress = self._grid:get_scrollbar_percentage_by_index(self._selected_index)

			self._grid:select_grid_index(self._selected_index, true, scroll_progress, true)
		end
	end
end

ViewElemenMissionBoardOptions._enable_settings_overlay = function (self, enable)
	local widgets_by_name = self._widgets_by_name
	local settings_overlay_widget = widgets_by_name.settings_overlay

	settings_overlay_widget.content.visible = enable
end

ViewElemenMissionBoardOptions.present = function (self, presentation_data)
	local widgets = {}
	local alignments = {}
	local size = {
		800,
		50,
	}

	for i = 1, #presentation_data do
		local data = presentation_data[i]
		local type = data.widget_type
		local id = data.id

		if type == "dropdown" then
			local max_visible_options = 5
			local DEFAULT_NUM_DECIMALS = 0
			local options = data.options or data.options_function and data.options_function()
			local num_options = #options
			local num_visible_options = math.min(num_options, max_visible_options)
			local widget_definition = UIWidget.create_definition(DropdownPassTemplates.settings_dropdown(size[1], size[2], size[1] - 400, num_visible_options, true), "options_grid_content_pivot", nil, size)
			local widget = self:_create_widget(id, widget_definition)
			local content = widget.content
			local display_name = data.display_name or "loc_settings_option_unavailable"

			content.text = Localize(display_name)
			content.entry = data

			local has_options_function = data.options_function ~= nil
			local has_dynamic_contents = data.has_dynamic_contents

			content.num_visible_options = num_visible_options

			local optional_num_decimals = data.optional_num_decimals
			local number_format = string.format("%%.%sf", optional_num_decimals or DEFAULT_NUM_DECIMALS)
			local options_by_id = {}

			for index, option in pairs(options) do
				options_by_id[option.id] = option
			end

			content.number_format = number_format
			content.options_by_id = options_by_id
			content.options = options

			content.hotspot.pressed_callback = function ()
				local is_disabled = data.disabled or false

				if is_disabled then
					return
				end

				local selected_widget
				local selected = true

				content.exclusive_focus = selected

				local hotspot = content.hotspot or content.button_hotspot

				if hotspot then
					hotspot.is_selected = selected
				end

				if not data.ignore_focus then
					local widget_name = widget.name

					selected_widget = self:_set_exclusive_focus_on_grid_widget(widget_name)
					selected_widget.offset[3] = selected_widget and 90 or 0
				end
			end

			content.area_length = size[2] * num_visible_options

			local scroll_length = math.max(size[2] * num_options - content.area_length, 0)

			content.scroll_length = scroll_length

			local spacing = 0
			local scroll_amount = scroll_length > 0 and (size[2] + spacing) / scroll_length or 0

			content.scroll_amount = scroll_amount

			data.changed_callback = function (changed_value)
				data:on_changed(changed_value, data)
			end

			widgets[#widgets + 1] = widget
			alignments[#alignments + 1] = widget
		elseif type == "checkbox" then
			local start_value = data.start_value
			local widget_definition = UIWidget.create_definition(CheckboxPassTemplates.settings_checkbox(size[1], size[2], size[1] - 400, 2, true), "options_grid_content_pivot", nil, size)
			local widget = self:_create_widget(id, widget_definition)
			local content = widget.content
			local display_name = data.display_name or "loc_settings_option_unavailable"

			content.text = Managers.localization:localize(display_name)
			content.entry = data

			for i = 1, 2 do
				local widget_option_id = "option_" .. i

				content[widget_option_id] = i == 1 and Managers.localization:localize("loc_setting_checkbox_on") or Managers.localization:localize("loc_setting_checkbox_off")
			end

			data.changed_callback = function (changed_value)
				data:on_changed(changed_value, data)
			end

			widgets[#widgets + 1] = widget
			alignments[#alignments + 1] = widget
		end
	end

	local scrollbar_widget = self._widgets_by_name.options_grid_scrollbar
	local grid_content_scenegraph_id = "options_grid_content_pivot"
	local interaction_scenegraph_id = "options_grid_interaction"
	local grid = UIWidgetGrid:new(widgets, alignments, self._ui_scenegraph, "options_grid", "down", {
		0,
		40,
	})

	grid:assign_scrollbar(scrollbar_widget, grid_content_scenegraph_id, interaction_scenegraph_id)
	grid:set_scrollbar_progress(0)

	self._grid_widgets = widgets
	self._grid = grid

	self:_setup_presentation()
	self:_on_navigation_input_changed()
end

ViewElemenMissionBoardOptions.update = function (self, dt, t, input_service)
	if self._on_enter_anim_id and self:_is_animation_completed(self._on_enter_anim_id) then
		self._on_enter_anim_id = nil
	end

	local grid = self._grid

	if grid then
		grid:update(dt, t, input_service)
	end

	for i = 1, #self._grid_widgets do
		local widget = self._grid_widgets[i]
		local widget_type = widget.content.entry and widget.content.entry.widget_type

		if widget_update_functions[widget_type] then
			widget_update_functions[widget_type](self, widget, input_service)
		end
	end

	if self._on_exit_anim_id and self:_is_animation_completed(self._on_exit_anim_id) then
		self._on_exit_anim_id = nil

		if self._context and self._context.on_destroy_callback then
			self._context.on_destroy_callback()
		end
	end

	if self._tooltip_data and self._tooltip_data.widget then
		local content = self._tooltip_data.widget.content
		local hotspot = content.hotspot
		local is_active = hotspot.is_focused or hotspot.is_selected or hotspot.is_hover or content.exclusive_focus

		if not is_active then
			self._tooltip_data = {}
			self._widgets_by_name.tooltip.content.visible = false
		end
	end

	if self._selected_widget and self._close_selected_setting then
		self:_set_exclusive_focus_on_grid_widget(nil)

		self._close_selected_setting = nil
	end

	self:_handle_input(input_service, dt, t)

	return ViewElemenMissionBoardOptions.super.update(self, dt, t, input_service)
end

ViewElemenMissionBoardOptions.draw = function (self, dt, t, ui_renderer, render_settings, input_service)
	local ui_renderer = self._ui_default_renderer
	local ui_scenegraph = self._ui_scenegraph
	local previous_alpha_multiplier = render_settings.alpha_multiplier

	render_settings.alpha_multiplier = self._animated_alpha_multiplier or 1

	ViewElemenMissionBoardOptions.super.draw(self, dt, t, ui_renderer, render_settings, input_service)

	render_settings.alpha_multiplier = previous_alpha_multiplier

	if self._offscreen_renderer then
		UIRenderer.begin_pass(self._offscreen_renderer, ui_scenegraph, input_service, dt, render_settings)

		local widgets = self._grid_widgets

		if widgets then
			for i = 1, #widgets do
				local widget = widgets[i]
				local grid = self._grid
				local interaction_widget = self._widgets_by_name.options_grid_interaction
				local is_grid_hovered = not Managers.ui:using_cursor_navigation() or interaction_widget.content.hotspot.is_hover or false

				if grid:is_widget_visible(widget) then
					local hotspot = widget.content.hotspot

					if hotspot then
						hotspot.force_disabled = not is_grid_hovered

						local is_active = hotspot.is_focused or hotspot.is_selected or hotspot.is_hover or widget.content.exclusive_focus

						if is_active and widget.content.entry and widget.content.entry.tooltip_text then
							self:_set_tooltip_data(widget)
						end
					end
				end

				UIWidget.draw(widget, self._offscreen_renderer)
			end
		end

		UIRenderer.end_pass(self._offscreen_renderer)
	end
end

ViewElemenMissionBoardOptions._setup_presentation = function (self)
	local height = 800
	local on_enter_animation_callback
	local params = {
		popup_height = height,
		additional_widgets = self._grid_widgets,
	}

	self._on_enter_anim_id = self:_start_animation("on_enter", self._widgets_by_name, params, on_enter_animation_callback)

	local enter_popup_sound = UISoundEvents.system_popup_enter

	self:_play_sound(enter_popup_sound)
end

ViewElemenMissionBoardOptions._cleanup_presentation = function (self)
	if self._on_enter_anim_id then
		self:_stop_animation(self._on_enter_anim_id)

		self._on_enter_anim_id = nil
	end

	local height = 800
	local params = {
		popup_height = height,
		additional_widgets = self._grid_widgets,
	}

	self._on_exit_anim_id = self:_start_animation("on_exit", self._widgets_by_name, params)

	self:_play_sound(UISoundEvents.system_popup_exit)
end

ViewElemenMissionBoardOptions._destroy_offscreen_renderer = function (self)
	local world_data = self._offscreen_world

	if world_data then
		Managers.ui:destroy_renderer(world_data.renderer_name)
		ScriptWorld.destroy_viewport(world_data.world, world_data.viewport_name)
		Managers.ui:destroy_world(world_data.world)

		world_data = nil
	end
end

ViewElemenMissionBoardOptions._close_button_pressed = function (self)
	self:_cleanup_presentation()
end

ViewElemenMissionBoardOptions._destroy_background = function (self)
	if self._ui_background_renderer then
		self._ui_background_renderer = nil

		Managers.ui:destroy_renderer(self.__class_name .. "_ui_background_renderer")

		local world = self._background_world
		local viewport_name = self._background_viewport_name

		ScriptWorld.destroy_viewport(world, viewport_name)
		Managers.ui:destroy_world(world)

		self._background_viewport_name = nil
		self._background_world = nil
	end
end

ViewElemenMissionBoardOptions._destroy_default_gui = function (self)
	if self._ui_default_renderer then
		self._ui_default_renderer = nil

		Managers.ui:destroy_renderer(self.__class_name .. "_ui_default_renderer")

		local world = self._world
		local viewport_name = self._viewport_name

		ScriptWorld.destroy_viewport(world, viewport_name)
		Managers.ui:destroy_world(world)

		self._viewport_name = nil
		self._world = nil
	end
end

ViewElemenMissionBoardOptions.destroy = function (self, ui_renderer)
	if self._offscreen_renderer then
		self:_destroy_offscreen_renderer()

		self._offscreen_renderer = nil
	end

	self:_destroy_background()
	ViewElemenMissionBoardOptions.super.destroy(self, self._ui_default_renderer)
	self:_destroy_default_gui()
end

ViewElemenMissionBoardOptions._scenegraph_world_position = function (self, id, scale)
	local ui_scenegraph = self._ui_scenegraph

	return UIScenegraph.world_position(ui_scenegraph, id, scale)
end

ViewElemenMissionBoardOptions._set_tooltip_data = function (self, widget)
	local current_widget = self._tooltip_data and self._tooltip_data.widget
	local localized_text
	local tooltip_text = widget.content.entry.tooltip_text

	if tooltip_text then
		if type(tooltip_text) == "function" then
			localized_text = tooltip_text()
		else
			localized_text = Localize(tooltip_text)
		end
	end

	local starting_point = self:_scenegraph_world_position("options_grid_content_pivot")
	local current_y = self._widgets_by_name.tooltip.offset[2]
	local scroll_addition = self._grid:length_scrolled()
	local new_y = starting_point[2] + widget.offset[2] - scroll_addition

	if current_widget ~= widget or current_widget == widget and new_y ~= current_y then
		self._tooltip_data = {
			widget = widget,
			text = localized_text,
		}
		self._widgets_by_name.tooltip.content.text = localized_text

		local text_style = self._widgets_by_name.tooltip.style.text
		local x_pos = starting_point[1] + widget.offset[1]
		local width = widget.content.size[1] * 0.5
		local text_options = UIFonts.get_font_options_by_style(text_style)
		local _, text_height = UIRenderer.text_size(self._ui_default_renderer, localized_text, text_style.font_type, text_style.font_size, {
			width,
			0,
		}, text_options)
		local height = text_height

		self._widgets_by_name.tooltip.content.visible = true
	end
end

ViewElemenMissionBoardOptions._on_navigation_input_changed = function (self)
	self._selected_index = self._grid:selected_grid_index() or 1

	if not Managers.ui:using_cursor_navigation() then
		local scroll_progress = self._grid:get_scrollbar_percentage_by_index(self._selected_index)

		self._grid:select_grid_index(self._selected_index, scroll_progress, true, true)
	else
		local scroll_progress = self._grid:get_scrollbar_percentage_by_index(self._selected_index)

		self._grid:select_grid_index(nil, scroll_progress, true, true)
	end
end

return ViewElemenMissionBoardOptions
