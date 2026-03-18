-- chunkname: @scripts/ui/view_elements/view_element_mission_board_difficulty_selector/view_element_mission_board_difficulty_selector.lua

local Definitions = require("scripts/ui/view_elements/view_element_mission_board_difficulty_selector/view_element_mission_board_difficulty_selector_definitions")
local UIWidget = require("scripts/managers/ui/ui_widget")
local InputDevice = require("scripts/managers/input/input_device")
local ColorUtilities = require("scripts/utilities/ui/colors")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local Text = require("scripts/utilities/ui/text")
local Danger = require("scripts/utilities/danger")
local DangerSettings = require("scripts/settings/difficulty/danger_settings")
local StepperPassTemplates = require("scripts/ui/pass_templates/stepper_pass_templates")
local MissionBoardViewSettings = require("scripts/ui/views/mission_board_view/mission_board_view_settings")
local Dimensions = MissionBoardViewSettings.dimensions
local ViewElementMissionBoardDifficultySelector = class("ViewElementMissionBoardDifficultySelector", "ViewElementBase")

ViewElementMissionBoardDifficultySelector.init = function (self, parent, draw_layer, start_scale, context)
	self._definitions = Definitions
	self._draw_layer = draw_layer or 0
	self._parent = parent
	self._render_settings = {}
	self._event_list = {}
	self._widgets, self._widgets_by_name = {}, {}

	self:_create_widgets(Definitions, self._widgets, self._widgets_by_name)

	self._ui_sequence_animator = self:_create_sequence_animator(Definitions)

	self:set_render_scale(start_scale or RESOLUTION_LOOKUP.scale)

	self._using_cursor_navigation = Managers.ui:using_cursor_navigation()

	local ui_renderer = parent._ui_renderer

	self._ui_renderer = ui_renderer
	self._visible = false
	self._context = context
	self._initialized = false
	self._internal_selected_difficulty_index = 1
end

ViewElementMissionBoardDifficultySelector.update = function (self, dt, t, input_service)
	if not input_service or not self._visible or not self._initialized then
		return
	end

	local parent = self:parent()
	local difficulty_stepper = self._widgets_by_name.difficulty_stepper
	local current_selected_difficulty_index = 1

	if parent.get_current_selected_difficulty then
		current_selected_difficulty_index = parent:get_current_selected_difficulty()
	else
		current_selected_difficulty_index = difficulty_stepper.content.danger
	end

	local internal_selected_difficulty_index = difficulty_stepper.content.danger or 1

	if self._internal_selected_difficulty_index ~= current_selected_difficulty_index then
		self:_update_difficulty_stepper(current_selected_difficulty_index)

		self._internal_selected_difficulty_index = current_selected_difficulty_index
	end

	self:_update_threat_level_tooltip(dt, t)
end

ViewElementMissionBoardDifficultySelector.draw = function (self, dt, t, ui_renderer, render_settings, input_service)
	if not input_service or not self._visible or not self._initialized then
		return
	end

	local render_scale = self._render_scale
	local render_settings = render_settings or self._render_settings
	local ui_renderer = self._ui_renderer

	render_settings.start_layer = self._draw_layer
	render_settings.scale = render_scale
	render_settings.inverse_scale = render_scale and 1 / render_scale

	local ui_scenegraph = self._ui_scenegraph

	ViewElementMissionBoardDifficultySelector.super.draw(self, dt, t, ui_renderer, render_settings, input_service)
	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, input_service, dt, render_settings)

	if self._difficulty_indicator_widgets then
		for i = 1, #self._difficulty_indicator_widgets do
			local widget = self._difficulty_indicator_widgets[i]

			UIWidget.draw(widget, ui_renderer, render_settings)
		end
	end

	UIRenderer.end_pass(ui_renderer)
end

ViewElementMissionBoardDifficultySelector.destroy = function (self, ui_renderer)
	ViewElementMissionBoardDifficultySelector.super.destroy(self, ui_renderer)

	if self._difficulty_indicator_widgets then
		for i = 1, #self._difficulty_indicator_widgets do
			local widget = self._difficulty_indicator_widgets[i]

			UIWidget.destroy(ui_renderer, widget)
		end
	end

	self._difficulty_indicator_widgets = nil
end

ViewElementMissionBoardDifficultySelector.initialize_data = function (self, optional_difficulty_index)
	local parent = self:parent()

	self._ui_scenegraph = parent._ui_scenegraph

	self:_setup_difficulty_selector(optional_difficulty_index)
	self:_create_difficulty_stepper_indicators(optional_difficulty_index)

	local context = self._context

	if context and context.show_progress then
		self:_setup_threat_level_tooltip()
	end

	self._internal_selected_difficulty_index = optional_difficulty_index or 1
	self._initialized = true
end

ViewElementMissionBoardDifficultySelector._setup_difficulty_selector = function (self, optional_difficulty_index)
	local difficulty_selector = self._widgets_by_name.difficulty_stepper

	if difficulty_selector then
		local content = difficulty_selector.content
		local parent = self:parent()
		local context = self._context
		local callbacks = context and context.callbacks

		if callbacks then
			content.left_pressed_callback = callback(parent, callbacks.on_left_pressed)
			content.right_pressed_callback = callback(parent, callbacks.on_right_pressed)
		end

		content.show_progress = context and context.show_progress

		if optional_difficulty_index then
			content.danger = optional_difficulty_index
		end
	end
end

ViewElementMissionBoardDifficultySelector._create_difficulty_stepper_indicators = function (self, optional_difficulty_index)
	local parent = self:parent()
	local context = self._context
	local difficulty_settings = parent.get_difficulty_settings and parent:get_difficulty_settings() or DangerSettings
	local current_selected_index = parent.get_current_selected_difficulty and parent:get_current_selected_difficulty() or optional_difficulty_index or 1
	local num_settings = difficulty_settings and #difficulty_settings or 0
	local stepper_indicators = {}
	local context = self._context
	local callbacks = context and context.callbacks

	for i = 1, num_settings do
		local difficulty_data = difficulty_settings[i]
		local danger_settings = DangerSettings[i]

		if parent.get_current_selected_difficulty_name then
			danger_settings = self:_get_difficulty_data_by_name(parent:get_current_selected_difficulty_name())
		end

		local indicator_pass_templates = StepperPassTemplates.difficulty_stepper_indicator.passes
		local is_difficulty_unlocked = true

		if difficulty_data and difficulty_data.is_unlocked ~= nil then
			is_difficulty_unlocked = difficulty_data.is_unlocked
		end

		local content_overrides = {
			icon = difficulty_settings and difficulty_settings[i].icon or danger_settings.digital_icon,
			internal_selected_difficulty = i,
			current_selected_difficulty = current_selected_index,
			is_unlocked = is_difficulty_unlocked,
			active = i == current_selected_index,
		}
		local indicator = UIWidget.create_definition(indicator_pass_templates, "difficulty_stepper_indicators", content_overrides)
		local widget = UIWidget.init("difficulty_indicator_" .. i, indicator)
		local stepper_width = self._ui_scenegraph.difficulty_stepper.size[1]

		widget.offset[1] = 28 + (i - 1) * ((stepper_width - 56) / num_settings)

		local content = widget.content

		content.hotspot.pressed_callback = callbacks and callback(parent, callbacks.on_indicator_pressed, i) or function ()
			self._widgets_by_name.difficulty_stepper.content.danger = i
		end
		stepper_indicators[#stepper_indicators + 1] = widget
	end

	self._difficulty_indicator_widgets = stepper_indicators

	self:_update_difficulty_stepper(current_selected_index)
end

ViewElementMissionBoardDifficultySelector._update_difficulty_stepper = function (self, difficulty_index)
	difficulty_index = difficulty_index or 1

	local parent = self:parent()
	local difficulty_settings = parent.get_difficulty_settings and parent:get_difficulty_settings() or DangerSettings
	local difficulty_setting = difficulty_settings and difficulty_settings[difficulty_index]
	local difficulty_selector = self._widgets_by_name.difficulty_stepper
	local content = difficulty_selector.content

	content.danger = difficulty_index
	content.difficulty_text = Text.localize_to_upper(difficulty_setting.loc_name or difficulty_setting.display_name)

	local target_color = difficulty_setting and difficulty_setting.color or DangerSettings[difficulty_index].color

	content.target_color = target_color

	local current_difficulty_index = difficulty_index
	local difficulty_indicators = self._difficulty_indicator_widgets

	if not difficulty_indicators then
		return
	end

	for i = 1, #difficulty_indicators do
		local indicator = difficulty_indicators[i]
		local indicator_content = indicator.content

		indicator_content.current_selected_difficulty = current_difficulty_index
		indicator_content.active = i == current_difficulty_index
		indicator_content.target_color = difficulty_settings and difficulty_settings[difficulty_index].color or DangerSettings[difficulty_index].color
	end

	local next_difficulty = difficulty_settings[difficulty_index + 1]
	local next_difficulty_unlocked = true

	if next_difficulty and next_difficulty.is_unlocked ~= nil then
		next_difficulty_unlocked = next_difficulty.is_unlocked
	end

	content.next_page_unlocked = next_difficulty_unlocked

	self:_update_threat_level_progress(difficulty_index, target_color)
end

ViewElementMissionBoardDifficultySelector._setup_threat_level_tooltip = function (self)
	local difficulty_selector = self._widgets_by_name.difficulty_stepper

	if not difficulty_selector then
		return
	end

	local parent = self:parent()
	local difficulty_progress_data = parent:get_threat_level_progress()

	if not difficulty_progress_data or table.is_empty(difficulty_progress_data) then
		difficulty_selector.style.tooltip_frame.visible = false
		difficulty_selector.style.tooltip_background.visible = false
		difficulty_selector.style.tooltip_text.visible = false

		return
	end

	local content = difficulty_selector.content
	local current_difficulty = difficulty_progress_data.current_difficulty
	local next_difficulty = difficulty_progress_data.next_difficulty
	local current_exp = difficulty_progress_data.current or 0
	local next_exp = difficulty_progress_data.target or 0
	local current_difficulty_data = self:_get_difficulty_data_by_name(current_difficulty)
	local next_difficulty_data = self:_get_difficulty_data_by_name(next_difficulty)

	if not current_difficulty_data or not next_difficulty_data then
		difficulty_selector.style.tooltip_frame.visible = false
		difficulty_selector.style.tooltip_background.visible = false
		difficulty_selector.style.tooltip_text.visible = false

		return
	end

	local formatted_tooltip_text = Localize("loc_mission_board_current_threat_level_progress_tooltip", true, {
		current_difficulty = Localize(current_difficulty_data.display_name),
		next_difficulty = Localize(next_difficulty_data.display_name),
		current = current_exp,
		target = next_exp,
	})

	content.tooltip_text = formatted_tooltip_text
	difficulty_selector.style.tooltip_frame.visible = true
	difficulty_selector.style.tooltip_background.visible = true
	difficulty_selector.style.tooltip_text.visible = true
end

ViewElementMissionBoardDifficultySelector._update_threat_level_tooltip = function (self, dt, t)
	local stepper_widget = self._widgets_by_name.difficulty_stepper

	if not stepper_widget then
		return
	end

	local content = stepper_widget.content
	local hotspot = content.tooltip_hotspot

	if not hotspot then
		return
	end

	local style = stepper_widget.style

	if InputDevice.gamepad_active then
		local gamepad_anim_progress = content.gamepad_anim_progress or 0

		if self._threat_level_tooltip_visible then
			gamepad_anim_progress = math.clamp(gamepad_anim_progress + dt * 2, 0, 1)
		else
			gamepad_anim_progress = math.clamp(gamepad_anim_progress - dt * 2, 0, 1)
		end

		style.tooltip_text.text_color[1] = 255 * gamepad_anim_progress
		style.tooltip_background.color[1] = 255 * gamepad_anim_progress
		style.tooltip_frame.color[1] = 255 * gamepad_anim_progress
		content.gamepad_anim_progress = gamepad_anim_progress
	else
		local hover_progress = hotspot.anim_hover_progress or 0

		style.tooltip_text.text_color[1] = 255 * hover_progress
		style.tooltip_background.color[1] = 255 * hover_progress
		style.tooltip_frame.color[1] = 255 * hover_progress
	end
end

ViewElementMissionBoardDifficultySelector._update_threat_level_progress = function (self, difficulty_index, target_color)
	if not self._context or not self._context.show_progress then
		return
	end

	local widget = self._widgets_by_name.difficulty_stepper

	if not difficulty_index or not target_color then
		widget.visible = false

		return
	end

	local content = widget.content
	local style = widget.style
	local parent = self:parent()
	local difficulty_progress_data = parent:get_threat_level_progress()

	if not difficulty_progress_data or table.is_empty(difficulty_progress_data) then
		widget.visible = false

		return
	end

	local progress = 0
	local current_unlocked_difficulty = difficulty_progress_data.current_difficulty
	local current_unlocked_difficulty_data = current_unlocked_difficulty ~= "n/a" and self:_get_difficulty_data_by_name(difficulty_progress_data.current_difficulty)

	if current_unlocked_difficulty_data then
		local current_unlocked_difficulty_index = current_unlocked_difficulty_data.index

		if parent.get_current_selected_difficulty_name then
			local selected_difficulty_data = self:_get_difficulty_data_by_name(parent:get_current_selected_difficulty_name())

			difficulty_index = selected_difficulty_data and selected_difficulty_data.index or difficulty_index
		end

		progress = difficulty_index < current_unlocked_difficulty_index and 1 or difficulty_progress_data.progress or 0
	end

	content.progress = progress
	content.target_color = target_color
end

ViewElementMissionBoardDifficultySelector._get_difficulty_data_by_name = function (self, difficulty_name)
	for i = 1, #DangerSettings do
		local difficulty_data = DangerSettings[i]

		if difficulty_data.name == difficulty_name then
			return difficulty_data
		end
	end
end

ViewElementMissionBoardDifficultySelector.get_current_selected_difficulty = function (self)
	return self._internal_selected_difficulty_index
end

return ViewElementMissionBoardDifficultySelector
