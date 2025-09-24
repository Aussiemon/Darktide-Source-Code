-- chunkname: @scripts/ui/views/player_survey_view/player_survey_view.lua

require("scripts/ui/views/base_view")

local DummyData = require("scripts/ui/views/player_survey_view/player_survey_view_dummy_data")
local LoadingStateData = require("scripts/ui/loading_state_data")
local PlayerSurveyViewContentBlueprints = require("scripts/ui/views/player_survey_view/player_survey_view_content_blueprints")
local PlayerSurveyViewDefinitions = require("scripts/ui/views/player_survey_view/player_survey_view_definitions")
local Promise = require("scripts/foundation/utilities/promise")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local ViewElementGrid = require("scripts/ui/view_elements/view_element_grid/view_element_grid")
local ViewElementInputLegend = require("scripts/ui/view_elements/view_element_input_legend/view_element_input_legend")
local ViewElementLoadingOverlay = require("scripts/ui/view_elements/view_element_loading_overlay/view_element_loading_overlay")
local PlayerSurveyView = class("PlayerSurveyView", "BaseView")

PlayerSurveyView.open = function ()
	local context = {}

	Managers.ui:open_view("player_survey_view", nil, false, nil, nil, context, nil)
end

PlayerSurveyView.init = function (self, settings, context)
	self._dynamic_elements = {}
	self._current_question_index = 0

	PlayerSurveyView.super.init(self, PlayerSurveyViewDefinitions, settings, context)

	self._pass_draw = context.pass_draw == nil and true or context.pass_draw
end

PlayerSurveyView.on_enter = function (self)
	PlayerSurveyView.super.on_enter(self)
	self:_add_element(ViewElementLoadingOverlay, "loading_overlay", 200, {
		use_parent_renderer = true,
	})

	self._content_container_size = table.clone(self._ui_scenegraph.content_pivot.size)

	self:_setup_input_legend()

	self._widgets_by_name.submit_button.content.hotspot.pressed_callback = callback(self, "_cb_on_submit_pressed")

	Promise.delay(0):next(function ()
		self:_refresh_data(table.clone(DummyData))
	end)
end

PlayerSurveyView._on_navigation_input_changed = function (self)
	PlayerSurveyView.super._on_navigation_input_changed(self)

	if self._choice_grid == nil then
		return
	end

	if self._using_cursor_navigation then
		self._choice_grid:select_grid_index(nil)
	else
		self._choice_grid:select_first_index()
	end
end

PlayerSurveyView._handle_input = function (self, input_service, dt, t)
	if self._choice_grid == nil then
		input_service = input_service:null_service()
	end

	PlayerSurveyView.super._handle_input(self, input_service, dt, t)

	local submit_button = self._widgets_by_name.submit_button

	if input_service:get(submit_button.content.gamepad_action) and not submit_button.content.hotspot.disabled then
		self:_play_sound(UISoundEvents.default_click)
		submit_button.content.hotspot.pressed_callback()
	end
end

PlayerSurveyView._cb_on_back_pressed = function (self)
	if self._current_question_index == 0 or self._current_question_index == 1 then
		self:_close()

		return
	end

	self:_play_sound(UISoundEvents.interaction_view_internal_back)
	self:_prev_question()
end

PlayerSurveyView._clean_ui = function (self)
	self._widgets_by_name.question_title_text.content.text = ""
	self._widgets_by_name.question_subtitle_text.content.text = ""
	self._widgets_by_name.submit_button.visible = false
	self._widgets_by_name.submit_button.content.hotspot.disabled = true

	for ref_name, element in pairs(self._dynamic_elements) do
		self:_remove_element(ref_name)
	end

	self._choice_grid = nil
end

PlayerSurveyView._refresh_data = function (self, data)
	self:_clean_ui()

	self._current_data = data
	self._current_question_index = 0
	self._current_survey_response = {}

	self:_create_progress_indicator(#self._current_data.questions)
	self:_next_question()
end

PlayerSurveyView._next_question = function (self)
	self:_move_to_question_in_dir(1)
end

PlayerSurveyView._prev_question = function (self)
	self:_move_to_question_in_dir(-1)
end

PlayerSurveyView._move_to_question_in_dir = function (self, dir)
	local next_question_idx = self._current_question_index + dir

	if next_question_idx > #self._current_data.questions then
		self:_upload_survey()

		return
	end

	if next_question_idx <= 0 then
		if next_question_idx < 0 then
			Log.error("PlayerSurveyView", "next_question < 0, something went wrong")
		end

		Promise.delay(0):next(callback(self, "_close"))

		return
	end

	self:_set_question_data(next_question_idx)
end

PlayerSurveyView._set_question_data = function (self, question_idx)
	self._current_question_index = question_idx

	local question = self._current_data.questions[question_idx]

	self._widgets_by_name.submit_button.content.original_text = question_idx < #self._current_data.questions and Utf8.upper(Localize("loc_character_creator_continue")) or Utf8.upper(Localize("loc_action_interaction_send"))

	self:_set_progress_indicator(question_idx)

	if question.type == "choice" then
		self:_clean_ui()
		self:_set_choice_question_data(question)

		return
	end

	Log.warning("PlayerSurveyView", "unknown survey question type '%s' for survey '%s'", question.type, self._current_data.id)
	self:_next_question()
end

PlayerSurveyView._get_choice_subtitle_text_formatted = function (question)
	if not question.subtitle_text_localized then
		return ""
	end

	if question.choice_count_min > 0 then
		return string.format(question.subtitle_text_localized, question.choice_count_min, question.choice_count_max)
	end

	return string.format(question.subtitle_text_localized, question.choice_count_max)
end

PlayerSurveyView._setup_submit_button_for_choice = function (self, question, answer_count)
	self._widgets_by_name.submit_button.visible = true
	self._widgets_by_name.submit_button.content.hotspot.disabled = answer_count < question.choice_count_min
end

PlayerSurveyView._set_choice_question_data = function (self, question)
	local choice_grid = self:_create_choice_grid(question)

	choice_grid.question_data = question
	self._widgets_by_name.question_title_text.content.text = question.title_text_localized

	local subtitle_text = self._get_choice_subtitle_text_formatted(question)

	self._widgets_by_name.question_subtitle_text.content.text = subtitle_text

	self:_setup_submit_button_for_choice(question, #(self._current_survey_response[question.id] or {}))

	local grid_settings = choice_grid:menu_settings()
	local grid_size = table.clone(grid_settings.grid_size)

	grid_size[1] = grid_size[1] - grid_settings.grid_spacing[1]

	local layout = {}

	for i, v in ipairs(question.choices) do
		layout[i] = {
			widget_type = "choice_button",
			text = v.text_localized,
			question = question,
			choice_id = v.id,
			column_count = grid_settings.column_count,
			grid_spacing = grid_settings.grid_spacing,
			grid_size = grid_size,
			callback = callback(self, "_cb_on_choice_pressed"),
		}
	end

	choice_grid:present_grid_layout(layout, PlayerSurveyViewContentBlueprints)

	self._choice_grid = choice_grid

	local answer_count = 0

	if self._current_survey_response[question.id] then
		self:_update_choice_buttons(question, self._current_survey_response[question.id])

		answer_count = #self._current_survey_response[question.id]
	end

	self:_update_info_text_for_choice(question, answer_count)

	if not self:using_cursor_navigation() then
		choice_grid:select_first_index()
	end

	choice_grid:set_visibility(false)

	self._widgets_by_name.submit_button.visible = false

	Promise.delay(0):next(function ()
		choice_grid:set_visibility(true)
		self:_set_scenegraph_size("content_pivot", grid_size[1], grid_size[2])

		self._widgets_by_name.submit_button.visible = true
	end)
end

PlayerSurveyView._cb_on_choice_pressed = function (self, widget, is_selected)
	local current_answers = self:_set_current_question_answers(widget.question, widget.choice_id, is_selected)

	self:_update_choice_buttons(widget.question, current_answers)
	self:_setup_submit_button_for_choice(widget.question, #current_answers)
	self:_update_info_text_for_choice(widget.question, #current_answers)
end

function _add_choice_to_answers(current_answers, choice_id)
	table.insert(current_answers, choice_id)
end

function _remove_choice_from_answers(current_answers, choice_id)
	table.array_remove_if(current_answers, function (v)
		return v == choice_id
	end)
end

PlayerSurveyView._set_current_question_answers = function (self, question, choice_id, is_selected)
	local current_answers = self._current_survey_response[question.id] or {}

	if is_selected then
		if question.choice_count_max == 1 then
			current_answers = {
				choice_id,
			}
		else
			_add_choice_to_answers(current_answers, choice_id)
		end
	else
		_remove_choice_from_answers(current_answers, choice_id)
	end

	self._current_survey_response[question.id] = current_answers

	return current_answers
end

PlayerSurveyView._update_choice_buttons = function (self, question, current_answers)
	if question.choice_count_max == 1 then
		self:_update_choice_buttons_single_selection(current_answers)

		return
	end

	self:_update_choice_buttons_multi_selection(question, current_answers)
end

PlayerSurveyView._update_choice_buttons_single_selection = function (self, current_answers)
	local button_widgets = self._choice_grid:widgets()

	for _, widget in pairs(button_widgets) do
		widget.content.is_selected = table.array_contains(current_answers, widget.choice_id)
	end
end

PlayerSurveyView._update_choice_buttons_multi_selection = function (self, question, current_answers)
	local choice_max_count = question.choice_count_max
	local button_widgets = self._choice_grid:widgets()
	local answer_count = #current_answers

	for _, widget in pairs(button_widgets) do
		widget.content.is_selected = table.array_contains(current_answers, widget.choice_id)

		if not widget.content.is_selected then
			widget.content.hotspot.disabled = choice_max_count <= answer_count
		end
	end
end

PlayerSurveyView._update_info_text_for_choice = function (self, question, num_answers)
	local choice_count_max = question.choice_count_max
	local choice_count_min = question.choice_count_min

	if choice_count_max == choice_count_min and choice_count_min == 1 then
		self._widgets_by_name.question_info_text.visible = false

		return
	end

	self._widgets_by_name.question_info_text.visible = true

	local current_choice_color = num_answers == choice_count_max and PlayerSurveyViewDefinitions.colors.light_green or PlayerSurveyViewDefinitions.colors.offwhite_green
	local current_choice_string = string.format("{#color(%d,%d,%d)}%d{#reset()}", current_choice_color[2], current_choice_color[3], current_choice_color[4], num_answers)
	local max_choices_string = string.format("{#color(%d,%d,%d)}/%d{#reset()}", PlayerSurveyViewDefinitions.colors.light_green[2], PlayerSurveyViewDefinitions.colors.light_green[3], PlayerSurveyViewDefinitions.colors.light_green[4], choice_count_max)

	self._widgets_by_name.question_info_text.content.text = current_choice_string .. max_choices_string
end

PlayerSurveyView._cb_on_submit_pressed = function (self)
	self:_next_question()
end

PlayerSurveyView._create_choice_grid = function (self, question)
	local choice_count = #question.choices
	local column_count = choice_count == 3 and 3 or 2
	local row_count = math.ceil(choice_count / column_count)

	if row_count < 1 then
		row_count = 1
	end

	local grid_height = row_count * PlayerSurveyViewContentBlueprints.choice_button.height
	local scenegraph_ref = self._ui_scenegraph.content_pivot
	local grid_settings = {
		bottom_chin = 25,
		edge_padding = 0,
		enable_gamepad_scrolling = false,
		hide_background = true,
		hide_dividers = true,
		no_resource_rendering = true,
		reset_selection_on_navigation_change = false,
		title_height = 0,
		top_padding = 25,
		use_parent_ui_renderer = true,
		column_count = column_count,
		grid_spacing = {
			33,
			25,
		},
	}
	local original_size = self._content_container_size
	local grid_size = {
		original_size[1] - grid_settings.edge_padding + 25 * (1 + 1 / column_count),
		grid_settings.top_padding + grid_settings.bottom_chin + grid_height + grid_settings.grid_spacing[2] * row_count + 10,
	}

	grid_settings.grid_size = grid_size
	grid_settings.mask_size = grid_size

	local grid_layer = scenegraph_ref.world_position[3] or 1
	local ref_name = string.format("%s_element_%s", scenegraph_ref.name, question.id)
	local choice_grid = self:_add_element(ViewElementGrid, ref_name, grid_layer, grid_settings, scenegraph_ref.name)

	choice_grid.visible = false

	choice_grid:set_pivot_offset(scenegraph_ref.world_position[1], scenegraph_ref.world_position[2])

	self._dynamic_elements[ref_name] = choice_grid

	return choice_grid
end

PlayerSurveyView._setup_input_legend = function (self)
	self._input_legend_element = self:_add_element(ViewElementInputLegend, "input_legend", 10)

	local legend_inputs = self._definitions.legend_inputs

	for i = 1, #legend_inputs do
		local legend_input = legend_inputs[i]
		local on_pressed_callback = legend_input.on_pressed_callback and callback(self, legend_input.on_pressed_callback)

		self._input_legend_element:add_entry(legend_input.display_name, legend_input.input_action, legend_input.visibility_function, on_pressed_callback, legend_input.alignment)
	end
end

PlayerSurveyView._close = function (self)
	self:_clean_ui()

	local view_name = self.view_name

	Managers.ui:close_view(view_name)
	self:_play_sound(UISoundEvents.default_menu_exit)
end

PlayerSurveyView.ui_renderer = function (self)
	return self._ui_renderer
end

PlayerSurveyView._create_progress_indicator = function (self, question_count)
	local indicator_size_width = PlayerSurveyViewDefinitions.progress_widget_full_size[1] / (question_count + 1)
	local progress_widget_definition = PlayerSurveyViewDefinitions.progress_widget_definition_factory({
		indicator_size_width,
		PlayerSurveyViewDefinitions.progress_widget_full_size[2],
	})
	local progress_widgets = {}
	local indicator_offset = 10
	local total_width = 0
	local offset_x = -(question_count * indicator_size_width + (question_count - 1) * indicator_offset - indicator_size_width) * 0.5

	for i = 1, question_count do
		progress_widgets[i] = self:_create_widget("progress_widget_" .. i, progress_widget_definition)

		table.insert(self._widgets, progress_widgets[i])

		progress_widgets[i].offset[1] = offset_x
		progress_widgets[i].visible = question_count > 1
		offset_x = offset_x + indicator_size_width + indicator_offset
		total_width = total_width + indicator_size_width

		if i < question_count then
			total_width = total_width + indicator_offset
		end
	end

	self._progress_indicators = progress_widgets

	self:_set_scenegraph_size("progress_indicator_container", total_width)
end

PlayerSurveyView._set_progress_indicator = function (self, index)
	local progress_widgets = self._progress_indicators

	for i = 1, #progress_widgets do
		local widget = progress_widgets[i]

		widget.content.active = i == index
	end
end

PlayerSurveyView._upload_survey = function (self)
	self:input_disable()

	local backend_promise = Promise.delay(1)

	Managers.event:trigger("event_start_waiting", backend_promise, LoadingStateData.WAIT_REASON.backend)
	backend_promise:next(function ()
		Managers.event:trigger("event_add_notification_message", "default", Localize("loc_survey_submit_success"))
	end, function (error)
		return Promise.resolved()
	end):next(callback(self, "_close"))
end

return PlayerSurveyView
