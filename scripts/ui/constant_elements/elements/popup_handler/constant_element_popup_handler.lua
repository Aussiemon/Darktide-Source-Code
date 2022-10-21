local ConstantElementPopupHandlerSettings = require("scripts/ui/constant_elements/elements/popup_handler/constant_element_popup_handler_settings")
local Definitions = require("scripts/ui/constant_elements/elements/popup_handler/constant_element_popup_handler_definitions")
local ConstantElementPopupHandlerTestify = GameParameters.testify and require("scripts/ui/constant_elements/elements/popup_handler/constant_element_popup_handler_testify")
local ScriptWorld = require("scripts/foundation/utilities/script_world")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWidget = require("scripts/managers/ui/ui_widget")
local WorldRenderUtils = require("scripts/utilities/world_render")
local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local TextUtilities = require("scripts/utilities/ui/text")
local InputDevice = require("scripts/managers/input/input_device")
local BLUR_TIME = 0.3
local ConstantElementPopupHandler = class("ConstantElementPopupHandler", "ConstantElementBase")
ConstantElementPopupHandler.INPUT_DIR_UP = 1
ConstantElementPopupHandler.INPUT_DIR_DOWN = 2
ConstantElementPopupHandler.INPUT_DIR_LEFT = 3
ConstantElementPopupHandler.INPUT_DIR_RIGHT = 4

ConstantElementPopupHandler.init = function (self, parent, draw_layer, start_scale)
	ConstantElementPopupHandler.super.init(self, parent, draw_layer, start_scale, Definitions)

	self._button_widgets = {}
	self._total_buttons_height = 0
end

ConstantElementPopupHandler.using_input = function (self)
	return self._handling_popups
end

ConstantElementPopupHandler._push_cursor = function (self)
	local input_manager = Managers.input
	local name = self.__class_name

	input_manager:push_cursor(name)

	self._cursor_pushed = true
end

ConstantElementPopupHandler._pop_cursor = function (self)
	if self._cursor_pushed then
		local input_manager = Managers.input
		local name = self.__class_name

		input_manager:pop_cursor(name)

		self._cursor_pushed = nil
	end
end

ConstantElementPopupHandler.event_update_popup_message = function (self, popup_id, text, sound_event)
	self:_set_text(popup_id, text)
end

ConstantElementPopupHandler._destroy_default_gui = function (self)
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

ConstantElementPopupHandler._destroy_background = function (self)
	if self._ui_popup_background_renderer then
		self._ui_popup_background_renderer = nil

		Managers.ui:destroy_renderer(self.__class_name .. "_ui_popup_background_renderer")

		local world = self._background_world
		local viewport_name = self._background_viewport_name

		ScriptWorld.destroy_viewport(world, viewport_name)
		Managers.ui:destroy_world(world)

		self._background_viewport_name = nil
		self._background_world = nil
	end
end

ConstantElementPopupHandler.destroy = function (self)
	self:_destroy_default_gui()
	self:_destroy_background()

	if self._cursor_pushed then
		self:_pop_cursor()
	end

	ConstantElementPopupHandler.super.destroy(self)
end

ConstantElementPopupHandler._get_active_popup = function (self)
	local active_popups = Managers.ui:active_popups()

	return active_popups[1]
end

ConstantElementPopupHandler._setup_presentation = function (self, data, ui_renderer)
	self._popup_type = data.type
	local title_text_params = data.title_text_params
	local title_text = Localize(data.title_text, title_text_params ~= nil, title_text_params)

	self:_set_title_text(title_text)

	local description_text_params = data.description_text_params
	local description_text = Localize(data.description_text, description_text_params ~= nil, description_text_params)

	self:_set_description_text(description_text)

	local options = data.options

	if options then
		self:_create_popup_buttons(options, ui_renderer)
	else
		self._total_buttons_height = 0
	end

	local height = self:_update_popup_text_height(ui_renderer)
	local on_enter_animation_callback = nil
	local params = {
		popup_height = height
	}
	self._on_enter_anim_id = self:_start_animation("on_enter", self._widgets_by_name, params, on_enter_animation_callback)
	local enter_popup_sound = data.enter_popup_sound or UISoundEvents.system_popup_enter

	self:_play_sound(enter_popup_sound)

	if #self._button_widgets > 0 and not self._using_cursor_navigation then
		self:_select_button_index(1)
	end

	self._input_frame_delay = 1
end

ConstantElementPopupHandler._cleanup_presentation = function (self, active_popup, ui_renderer)
	if self._on_enter_anim_id then
		self:_stop_animation(self._on_enter_anim_id)

		self._on_enter_anim_id = nil
	end

	local height = self:_update_popup_text_height(ui_renderer)
	local params = {
		popup_height = height
	}
	self._on_exit_anim_id = self:_start_animation("on_exit", self._widgets_by_name, params)
	local exit_popup_sound = active_popup.data.exit_popup_sound or UISoundEvents.system_popup_exit

	if not active_popup.stop_exit_sound then
		self:_play_sound(exit_popup_sound)
	end
end

ConstantElementPopupHandler._cb_on_button_pressed = function (self, widget)
	local active_popup = self._active_popup

	if active_popup.closing then
		return
	end

	local content = widget.content
	local callback = content.callback

	if callback then
		callback()
	end

	if active_popup and content.close_on_pressed then
		local popup_id = active_popup.id
		active_popup.closing = true
		active_popup.stop_exit_sound = content.stop_exit_sound

		Managers.event:trigger("event_remove_ui_popup", popup_id)
	end
end

ConstantElementPopupHandler.trigger_widget_callback = function (self, widget)
	self:_cb_on_button_pressed(widget)
end

ConstantElementPopupHandler._create_popup_buttons = function (self, options, ui_renderer)
	local button_widgets = self._button_widgets

	for i = 1, #button_widgets do
		local widget = button_widgets[i]

		self:_unregister_widget_name(widget.name)

		button_widgets[i] = nil
	end

	local total_buttons_height = 0
	local max_row_length = ConstantElementPopupHandlerSettings.max_button_row_length
	local total_row_length = 0
	local current_row = 1
	local current_column = 0
	local widgets_on_row = 0
	local total_height_spacing = ConstantElementPopupHandlerSettings.total_height_spacing
	local options_missing_hotkeys = false
	local num_options = #options

	for i = 1, num_options do
		local option = options[i]
		local template_type = option.template_type or "terminal_button_small"
		local widget_name = "button_" .. i
		local pass_template = ButtonPassTemplates[template_type]
		local button_size = pass_template.size_function and pass_template.size_function(self, option, ui_renderer) or pass_template.size
		local widget_definitions = UIWidget.create_definition(ButtonPassTemplates[template_type], "button_pivot", nil, button_size)
		local widget = self:_create_widget(widget_name, widget_definitions)
		button_widgets[i] = widget
		local content = widget.content
		local hotkey = option.hotkey
		local text = nil
		text = hotkey and TextUtilities.localize_with_button_hint(hotkey, option.text, option.text_params) or Localize(option.text, option.text_params ~= nil, option.text_params)
		options_missing_hotkeys = not hotkey or options_missing_hotkeys
		content.text = text
		content.hotkey = option.hotkey
		content.callback = option.callback
		content.close_on_pressed = option.close_on_pressed
		content.stop_exit_sound = option.stop_exit_sound
		local hotspot = content.hotspot
		hotspot.pressed_callback = callback(self, "_cb_on_button_pressed", widget)
		local on_pressed_sound = option.on_pressed_sound

		if on_pressed_sound then
			hotspot.on_pressed_sound = on_pressed_sound
		end

		local text_style = widget.style.text
		local min_button_width = ConstantElementPopupHandlerSettings.min_button_width
		local text_length = min_button_width
		content.size[1] = text_length

		if pass_template.init then
			pass_template.init(self, widget, ui_renderer, {
				text = text
			})
		end

		local change_row = max_row_length < total_row_length + text_length and widgets_on_row > 0

		if change_row then
			local start_offset = -(total_row_length * 0.5)
			local start_index = i - widgets_on_row
			local end_index = start_index + widgets_on_row

			for j = start_index, end_index do
				local button_length = button_widgets[j].content.size[1]
				button_widgets[j].offset[1] = start_offset
				start_offset = start_offset + button_length
			end

			current_column = 1
		else
			current_column = current_column + 1
		end

		if change_row then
			current_row = current_row + 1
			widgets_on_row = 1
			total_row_length = text_length
		else
			total_row_length = total_row_length + text_length
			widgets_on_row = widgets_on_row + 1
		end

		local offset = widget.offset
		offset[2] = total_buttons_height
		content.row = current_row
		content.column = current_column
		local margin_bottom = option.margin_bottom or 0
		total_buttons_height = total_buttons_height + button_size[2] + margin_bottom

		if i == num_options then
			local start_offset = -(total_row_length * 0.5)
			local start_index = i - widgets_on_row + 1
			local end_index = num_options

			for j = start_index, end_index do
				local button_length = button_widgets[j].content.size[1]
				button_widgets[j].offset[1] = start_offset
				start_offset = start_offset + button_length
			end
		else
			total_buttons_height = total_buttons_height + total_height_spacing
		end
	end

	self._gamepad_hotkey_input = not options_missing_hotkeys
	self._total_buttons_height = total_buttons_height
end

ConstantElementPopupHandler._set_title_text = function (self, text)
	local widgets_by_name = self._widgets_by_name
	widgets_by_name.title_text.content.text = text
end

ConstantElementPopupHandler._set_description_text = function (self, text)
	local widgets_by_name = self._widgets_by_name
	widgets_by_name.description_text.content.text = text
end

ConstantElementPopupHandler._update_popup_text_height = function (self, ui_renderer)
	local widgets_by_name = self._widgets_by_name
	local window_edge_margin_height = ConstantElementPopupHandlerSettings.window_edge_margin_height
	local total_text_height = window_edge_margin_height * 2
	local top_icon_widget = widgets_by_name.top_icon
	local popup_type_styles = Definitions.popup_type_style
	local popup_type = "default"

	if self._popup_type then
		for name, _ in pairs(popup_type_styles) do
			if self._popup_type == name then
				popup_type = name

				break
			end
		end
	end

	local top_icon_width = popup_type_styles[popup_type].icon_size[1]
	local top_icon_height = popup_type_styles[popup_type].icon_size[2]
	local top_icon_block_height = 0

	if top_icon_height > 0 then
		top_icon_block_height = top_icon_height + ConstantElementPopupHandlerSettings.top_icon_offset_height
	end

	total_text_height = total_text_height + top_icon_block_height
	local title_text_widget = widgets_by_name.title_text
	local title_text = title_text_widget.content.text
	local title_text_style = title_text_widget.style.text
	local title_height = self:_get_text_height(title_text, title_text_style, ui_renderer)
	local title_text_block_height = title_height + ConstantElementPopupHandlerSettings.title_offset_height
	total_text_height = total_text_height + title_text_block_height
	local description_text_widget = widgets_by_name.description_text
	local description_text = description_text_widget.content.text
	local description_text_style = description_text_widget.style.text
	local description_height = self:_get_text_height(description_text, description_text_style, ui_renderer)
	local description_text_block_height = description_height + ConstantElementPopupHandlerSettings.description_bottom_height_spacing
	total_text_height = total_text_height + description_text_block_height
	local button_block_height = self._total_buttons_height
	total_text_height = total_text_height + button_block_height
	local current_offset = -total_text_height * 0.5 + window_edge_margin_height

	self:set_scenegraph_position(top_icon_widget.scenegraph_id, nil, current_offset)

	current_offset = current_offset + top_icon_block_height

	self:set_scenegraph_position(title_text_widget.scenegraph_id, nil, current_offset)

	current_offset = current_offset + title_text_block_height

	self:set_scenegraph_position(description_text_widget.scenegraph_id, nil, current_offset)

	current_offset = current_offset + description_text_block_height

	self:set_scenegraph_position("button_pivot", nil, current_offset)

	return total_text_height
end

local dummy_text_size = {
	ConstantElementPopupHandlerSettings.text_max_width,
	20
}

ConstantElementPopupHandler._get_text_height = function (self, text, text_style, ui_renderer)
	local text_options = UIFonts.get_font_options_by_style(text_style)
	local _, text_height, _, _ = UIRenderer.text_size(ui_renderer, text, text_style.font_type, text_style.font_size, dummy_text_size, text_options)

	return text_height
end

ConstantElementPopupHandler._get_text_width = function (self, text, text_style, ui_renderer)
	local text_options = UIFonts.get_font_options_by_style(text_style)
	local text_width, _, _, _ = UIRenderer.text_size(ui_renderer, text, text_style.font_type, text_style.font_size, dummy_text_size, text_options)

	return text_width
end

ConstantElementPopupHandler._find_closest_neighbour_button_index = function (self, starting_index, direction)
	local button_widgets = self._button_widgets
	local num_widgets = #button_widgets
	local current_widget = button_widgets[starting_index]
	local current_offset = current_widget.offset
	local current_content = current_widget.content
	local current_size = current_widget.size or current_content.size
	local current_row = current_content.row
	local current_coordinate_x = current_offset[1] + current_offset[1] + current_size[1] * 0.5
	local closest_index, closest_index_distance = nil
	local shortest_distance = math.huge
	local closest_widget = nil

	local function is_button_widget_closest_vertical(start_index, widget, widget_index)
		local offset = widget.offset
		local content = widget.content
		local size = widget.size or content.size
		local row = content.row
		local coordinate_x = offset[1] + offset[1] + size[1] * 0.5
		local distance = math.abs(coordinate_x - current_coordinate_x)

		if row ~= current_row and distance <= shortest_distance then
			local same_distance = distance == shortest_distance
			shortest_distance = distance

			if same_distance then
				if not closest_index_distance or math.abs(start_index - widget_index) <= closest_index_distance then
					return not closest_index_distance or widget_index < closest_index
				end
			else
				return true
			end
		end
	end

	if direction == self.INPUT_DIR_UP then
		for i = starting_index, 1, -1 do
			local widget = button_widgets[i]
			local content = widget.content

			if closest_widget and content.row < closest_widget.content.row then
				break
			end

			if content.hotspot and is_button_widget_closest_vertical(starting_index, widget, i) then
				closest_index_distance = math.abs(starting_index - i)
				closest_index = i
				closest_widget = widget
			end
		end
	elseif direction == self.INPUT_DIR_DOWN then
		for i = math.min(starting_index + 1, num_widgets), num_widgets do
			local widget = button_widgets[i]
			local content = widget.content

			if closest_widget and closest_widget.content.row < content.row then
				break
			end

			if content.hotspot and is_button_widget_closest_vertical(starting_index, widget, i) then
				closest_index_distance = math.abs(starting_index - i)
				closest_index = i
				closest_widget = widget
			end
		end
	elseif direction == self.INPUT_DIR_LEFT then
		local next_index = starting_index - 1

		if next_index > 0 then
			local widget = button_widgets[next_index]
			local content = widget.content

			if content.row == current_row then
				closest_index = next_index
			end
		end
	elseif direction == self.INPUT_DIR_RIGHT then
		local next_index = starting_index + 1

		if num_widgets >= next_index then
			local widget = button_widgets[next_index]
			local content = widget.content

			if content.row == current_row then
				closest_index = next_index
			end
		end
	end

	return closest_index
end

ConstantElementPopupHandler._select_button_index = function (self, index)
	local gamepad_active = InputDevice.gamepad_active

	if gamepad_active and self._gamepad_hotkey_input then
		return
	end

	local button_widgets = self._button_widgets

	for i = 1, #button_widgets do
		local widget = button_widgets[i]
		widget.content.hotspot.is_selected = i == index
	end

	self._selected_button_index = index
end

ConstantElementPopupHandler._update_button_input = function (self, input_service)
	local input_handled = false
	local button_widgets = self._button_widgets
	local current_selected_button_index = self._selected_button_index
	local gamepad_active = InputDevice.gamepad_active

	if current_selected_button_index then
		local input_direction = nil

		if input_service:get("navigate_up_continuous") then
			input_direction = self.INPUT_DIR_UP
		elseif input_service:get("navigate_down_continuous") then
			input_direction = self.INPUT_DIR_DOWN
		elseif input_service:get("navigate_left_continuous") then
			input_direction = self.INPUT_DIR_LEFT
		elseif input_service:get("navigate_right_continuous") then
			input_direction = self.INPUT_DIR_RIGHT
		end

		local new_selection_index = nil

		if input_direction then
			new_selection_index = self:_find_closest_neighbour_button_index(current_selected_button_index, input_direction)
		end

		if new_selection_index then
			input_handled = true

			self:_select_button_index(new_selection_index)
		end
	end

	if not input_handled then
		for i = 1, #button_widgets do
			local widget = button_widgets[i]
			local content = widget.content
			local hotkey = content.hotkey

			if hotkey and input_service:get(hotkey) then
				self:_cb_on_button_pressed(widget)

				return
			end
		end
	end
end

ConstantElementPopupHandler.update = function (self, dt, t, ui_renderer, render_settings, input_service)
	if GameParameters.testify then
		Testify:poll_requests_through_handler(ConstantElementPopupHandlerTestify, self)
	end

	if self._input_frame_delay then
		input_service = input_service:null_service()
		self._input_frame_delay = self._input_frame_delay - 1

		if self._input_frame_delay < 0 then
			self._input_frame_delay = nil
		end
	end

	local using_cursor_navigation = Managers.ui:using_cursor_navigation()

	if self._using_cursor_navigation ~= using_cursor_navigation or self._using_cursor_navigation == nil then
		self._using_cursor_navigation = using_cursor_navigation

		self:_on_navigation_input_changed()
	end

	local active_popups = Managers.ui:active_popups()
	local next_active_popup = active_popups[1]

	if self._on_enter_anim_id and self:_is_animation_completed(self._on_enter_anim_id) then
		self._on_enter_anim_id = nil
	end

	if self._on_exit_anim_id and self:_is_animation_completed(self._on_exit_anim_id) then
		self._on_exit_anim_id = nil
		local button_widgets = self._button_widgets

		for i = 1, #button_widgets do
			local widget = button_widgets[i]

			self:_unregister_widget_name(widget.name)

			button_widgets[i] = nil
		end

		self._total_buttons_height = 0
	end

	if next_active_popup ~= self._active_popup then
		if self._active_popup and not self._on_exit_anim_id then
			self:_cleanup_presentation(self._active_popup, ui_renderer)

			self._active_popup = nil
		end

		if next_active_popup and not self._on_exit_anim_id then
			self:_setup_presentation(next_active_popup.data, ui_renderer)

			self._active_popup = next_active_popup
		end
	end

	local handling_popups = self._active_popup ~= nil or self._on_exit_anim_id ~= nil

	if handling_popups ~= self._handling_popups then
		self._handling_popups = handling_popups

		if handling_popups then
			self:_setup_background_gui()
			self:_setup_default_gui()

			if not self._cursor_pushed then
				self:_push_cursor()
			end
		else
			self:_destroy_default_gui()
			self:_destroy_background()

			if self._cursor_pushed then
				self:_pop_cursor()
			end
		end
	end

	if self._handling_popups then
		local ui_manager = Managers.ui
		local top_draw_layer = ui_manager:view_draw_top_layer()
		local world_draw_layer = top_draw_layer + self._world_default_layer

		if self._world and self._world_draw_layer ~= world_draw_layer then
			Managers.world:set_world_layer(self._world_name, world_draw_layer)

			self._world_draw_layer = world_draw_layer
		end

		local background_world_draw_layer = top_draw_layer + self._background_world_default_layer

		if self._background_world and background_world_draw_layer ~= self._background_world_draw_layer then
			Managers.world:set_world_layer(self._background_world_name, background_world_draw_layer)

			self._background_world_draw_layer = background_world_draw_layer
		end
	end

	if self._blur_duration then
		if self._blur_duration < 0 then
			self._blur_duration = nil
		else
			local progress = 1 - self._blur_duration / BLUR_TIME
			local anim_progress = math.easeOutCubic(progress)

			self:_set_background_blur(anim_progress)

			self._blur_duration = self._blur_duration - dt
			self._alpha_multiplier = anim_progress
		end
	end

	local handle_input = handling_popups and not self._on_exit_anim_id and not self._on_enter_anim_id

	if handle_input then
		self:_update_button_input(input_service)
	else
		input_service = input_service:null_service()
	end

	ConstantElementPopupHandler.super.update(self, dt, t, ui_renderer, render_settings, input_service)
end

ConstantElementPopupHandler.using_cursor_navigation = function (self)
	return self._using_cursor_navigation
end

ConstantElementPopupHandler._on_navigation_input_changed = function (self)
	if self._handling_popups and #self._button_widgets > 0 then
		if self._using_cursor_navigation then
			if self._selected_button_index then
				self:_select_button_index(nil)
			end
		elseif not self._selected_button_index then
			self:_select_button_index(1)
		end
	end
end

ConstantElementPopupHandler.draw = function (self, dt, t, ui_renderer, render_settings, input_service)
	if not self._handling_popups then
		return
	end

	local disable_input = self._on_exit_anim_id ~= nil or self._input_frame_delay

	if disable_input then
		input_service = input_service:null_service()
	end

	ConstantElementPopupHandler.super.draw(self, dt, t, ui_renderer, render_settings, input_service)
end

ConstantElementPopupHandler._draw_widgets = function (self, dt, t, input_service, ui_renderer, render_settings)
	local previous_alpha_multiplier = render_settings.alpha_multiplier
	render_settings.alpha_multiplier = self._animated_alpha_multiplier or 1

	ConstantElementPopupHandler.super._draw_widgets(self, dt, t, input_service, ui_renderer, render_settings)

	local button_widgets = self._button_widgets

	for i = 1, #button_widgets do
		local widget = button_widgets[i]

		UIWidget.draw(widget, ui_renderer)
	end

	render_settings.alpha_multiplier = previous_alpha_multiplier
end

ConstantElementPopupHandler._setup_default_gui = function (self)
	local ui_manager = Managers.ui
	local class_name = self.__class_name
	local timer_name = "ui"
	local world_layer = 200
	local world_name = class_name .. "_ui_default_world"
	self._world = ui_manager:create_world(world_name, world_layer, timer_name)
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

ConstantElementPopupHandler._setup_background_gui = function (self)
	local ui_manager = Managers.ui
	local class_name = self.__class_name
	local timer_name = "ui"
	local world_layer = 199
	local world_name = class_name .. "_ui_background_world"
	self._background_world = ui_manager:create_world(world_name, world_layer, timer_name)
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
	self._ui_popup_background_renderer = ui_manager:create_renderer(class_name .. "_ui_popup_background_renderer", self._background_world)
	self._blur_duration = BLUR_TIME
end

ConstantElementPopupHandler.cb_shading_callback = function (self, world, shading_env, viewport, default_shading_environment_name)
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

ConstantElementPopupHandler._set_background_blur = function (self, fraction)
	local max_value = ConstantElementPopupHandlerSettings.background_max_blur_value
	local class_name = self.__class_name
	local world_name = class_name .. "_ui_background_world"
	local viewport_name = class_name .. "_ui_background_world_viewport"

	WorldRenderUtils.enable_world_fullscreen_blur(world_name, viewport_name, max_value * fraction)
end

return ConstantElementPopupHandler
