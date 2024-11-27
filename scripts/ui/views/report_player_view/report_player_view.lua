-- chunkname: @scripts/ui/views/report_player_view/report_player_view.lua

local BackendUtilities = require("scripts/foundation/managers/backend/utilities/backend_utilities")
local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local Definitions = require("scripts/ui/views/report_player_view/report_player_view_definitions")
local MissionsTemplates = require("scripts/settings/mission/mission_templates")
local ReportPlayerViewBlueprints = require("scripts/ui/views/report_player_view/report_player_view_blueprints")
local ReportPlayerViewSettings = require("scripts/ui/views/report_player_view/report_player_view_settings")
local ScriptWorld = require("scripts/foundation/utilities/script_world")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWidget = require("scripts/managers/ui/ui_widget")
local ReportPlayerView = class("ReportPlayerView", "BaseView")

ReportPlayerView.init = function (self, settings, context)
	self._context = context
	self._content_alpha_multiplier = 0
	self._using_cursor_navigation = Managers.ui:using_cursor_navigation()

	ReportPlayerView.super.init(self, Definitions, settings, context)

	self._allow_close_hotkey = true
	self._pass_draw = false
	self._selected_category = nil
end

ReportPlayerView.on_enter = function (self)
	ReportPlayerView.super.on_enter(self)

	local context = self._context

	self._reportee_account_id = context.reportee_account_id
	self._reportee_display_name = context.reportee_display_name
	self._report_details = ""
	self._selected_options = {}
	self._added_widgets = {}

	self:_setup_window_title()
	self:_initialize_report_options()
	self:_initialize_report_details()
	self:_setup_buttons_interactions()

	self._window_open_anim_id = self:_start_animation("on_enter", self._widgets_by_name, self)

	if not self._using_cursor_navigation then
		self:_set_selected_gamepad_navigation_index(1)
	end

	self:_update_report_button_state()
end

ReportPlayerView.on_exit = function (self)
	ReportPlayerView.super.on_exit(self)

	if self._ui_default_renderer then
		self._ui_default_renderer = nil

		if not self._ui_default_renderer_is_external then
			Managers.ui:destroy_renderer(self.__class_name .. "_ui_default_renderer")
		end

		if self._gui_world then
			local world = self._gui_world
			local viewport_name = self._gui_viewport_name

			ScriptWorld.destroy_viewport(world, viewport_name)
			Managers.ui:destroy_world(world)

			self._gui_viewport_name = nil
			self._gui_viewport = nil
			self._gui_world = nil
		end
	end

	Managers.ui:play_2d_sound(UISoundEvents.weapons_discard_release)
end

ReportPlayerView.trigger_on_exit_animation = function (self)
	if not self._window_close_anim_id then
		self._window_close_anim_id = self:_start_animation("on_exit", self._widgets_by_name, self)
	end
end

ReportPlayerView.on_exit_animation_done = function (self)
	return self._window_close_anim_id and self:_is_animation_completed(self._window_close_anim_id)
end

ReportPlayerView.draw = function (self, dt, t, input_service, layer)
	local render_scale = self._render_scale
	local render_settings = self._render_settings
	local ui_renderer = self._ui_renderer

	render_settings.start_layer = layer
	render_settings.scale = render_scale
	render_settings.inverse_scale = render_scale and 1 / render_scale

	local ui_scenegraph = self._ui_scenegraph

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, input_service, dt, render_settings)
	self:_draw_widgets(dt, t, input_service, ui_renderer)
	UIRenderer.end_pass(ui_renderer)
	self:_draw_elements(dt, t, ui_renderer, render_settings, input_service)
end

ReportPlayerView._draw_widgets = function (self, dt, t, input_service, ui_renderer)
	local widgets = self._added_widgets

	for j = 1, #widgets do
		local widget = widgets[j]

		UIWidget.draw(widget, ui_renderer)
	end

	ReportPlayerView.super._draw_widgets(self, dt, t, input_service, ui_renderer)
end

ReportPlayerView.update = function (self, dt, t, input_service, layer)
	if self._cached_player_icon_material_values then
		self:_cb_set_player_icon(self._cached_player_icon_material_values.grid_index, self._cached_player_icon_material_values.rows, self._cached_player_icon_material_values.columns, self._cached_player_icon_material_values.render_target)
	end

	if self._window_open_anim_id and self:_is_animation_completed(self._window_open_anim_id) then
		self:_stop_animation(self._window_open_anim_id)

		self._window_open_anim_id = nil
	end

	if not self._window_open_anim_id then
		local widgets_by_name = self._widgets_by_name
		local ui_renderer = self._ui_renderer

		ButtonPassTemplates.terminal_button_hold_small.update(self, widgets_by_name.report_button, ui_renderer, dt)
	end

	for i = 1, #self._added_widgets do
		local widget = self._added_widgets[i]
		local widget_type = widget.content.entry and widget.content.entry.widget_type
		local blueprint = widget_type and ReportPlayerViewBlueprints[widget_type]

		if blueprint and blueprint.update then
			blueprint.update(self, widget, input_service)
		end
	end

	if self._selected_widget and self._close_selected_setting then
		self:_set_exclusive_focus_on_grid_widget(nil)

		self._close_selected_setting = nil
	end

	return ReportPlayerView.super.update(self, dt, t, input_service, layer)
end

ReportPlayerView._setup_window_title = function (self)
	local context = self._context
	local custom_title = context and context.custom_title
	local text = custom_title or Localize("loc_player_report_title")
	local widgets_by_name = self._widgets_by_name

	widgets_by_name.window_title.content.text = text

	local player_name = self._reportee_display_name or "n/a"

	widgets_by_name.player_title.content.text = player_name

	local widgets_by_name = self._widgets_by_name

	widgets_by_name.report_details_title.content.text = Localize("loc_player_report_reason_text_title")
end

ReportPlayerView._setup_buttons_interactions = function (self)
	local widgets_by_name = self._widgets_by_name

	widgets_by_name.report_button.content.size = ReportPlayerViewSettings.report_button_size

	ButtonPassTemplates.terminal_button_hold_small.init(self, widgets_by_name.report_button, self._ui_renderer, {
		ignore_gamepad_on_text = true,
		text = Localize("loc_action_interaction_send"),
		complete_function = callback(self, "_on_submit_pressed"),
		on_complete_sound = UISoundEvents.weapons_discard_complete,
		hold_sound = UISoundEvents.weapons_discard_hold,
		hold_release = UISoundEvents.weapons_discard_release,
	})

	widgets_by_name.close_button.content.hotspot.pressed_callback = callback(self, "_on_close_pressed")
	self._button_gamepad_navigation_list = {
		widgets_by_name.option_dropdown_report_type,
		widgets_by_name.input_text_report_details,
		widgets_by_name.report_button,
		widgets_by_name.close_button,
	}
end

ReportPlayerView._initialize_description_text = function (self)
	local widgets_by_name = self._widgets_by_name
	local key_value_color = Color.terminal_text_key_value(255, true)
	local text = Localize("loc_discard_items_view_favorite_info", true, {
		favorite_icon = Localize("loc_color_value_fomat_key", true, {
			value = "",
			r = key_value_color[2],
			g = key_value_color[3],
			b = key_value_color[4],
		}),
	})

	widgets_by_name.description.content.text = text
end

ReportPlayerView._initialize_report_options = function (self)
	local report_options = {
		{
			display_name = "loc_player_report_bad_username",
			value = "bad-username",
		},
		{
			display_name = "loc_player_report_abuse",
			value = "abuse",
		},
		{
			display_name = "loc_player_report_griefing",
			value = "griefing",
		},
		{
			display_name = "loc_player_report_cheating",
			value = "cheating",
		},
		{
			display_name = "loc_player_report_afk",
			value = "afk",
		},
	}
	local blueprint_name = "dropdown"
	local blueprint = ReportPlayerViewBlueprints[blueprint_name]
	local num_options = table.size(report_options)
	local dropdown_size = blueprint.size
	local pass_template = blueprint.pass_template_function(dropdown_size, num_options)
	local widget_definition = UIWidget.create_definition(pass_template, "option_dropdown_report_type", nil, dropdown_size)
	local new_widget = self:_create_widget("option_dropdown_report_type", widget_definition)
	local element = {
		display_name = "loc_player_report_reason_title",
		id = "report_player",
		widget_type = "dropdown",
		on_activated = function (value, template)
			self._selected_category = report_options[value].value
		end,
		get_function = function (template)
			local options = template.options_function()

			for i = 1, #options do
				local option = options[i]

				if option.value == self._selected_category then
					return option.id
				end
			end

			return 1
		end,
		options_function = function (template)
			local options = report_options

			for i = 1, #options do
				local option = options[i]

				option.id = i
			end

			table.sort(options, function (a, b)
				return a.id < b.id
			end)

			return options
		end,
		on_changed = function (value)
			self._selected_category = report_options[value].value
		end,
	}

	blueprint.init(self, new_widget, element)

	self._added_widgets[#self._added_widgets + 1] = new_widget
end

ReportPlayerView._initialize_report_details = function (self)
	local initial_text = Localize("loc_player_report_reason_text_title")
	local blueprint_name = "comment_input_text"
	local blueprint = ReportPlayerViewBlueprints[blueprint_name]
	local pass_template = blueprint.pass_template_function(blueprint.size)
	local widget_definition = UIWidget.create_definition(pass_template, "input_text_report_details", nil, blueprint.size)
	local new_widget = self:_create_widget("input_text_report_details", widget_definition)
	local element = {
		widget_type = "comment_input_text",
	}

	blueprint.init(self, new_widget, initial_text, element)

	self._added_widgets[#self._added_widgets + 1] = new_widget
end

ReportPlayerView._on_option_button_pressed = function (self, widget, index)
	widget.content.checked = not widget.content.checked
	self._selected_options[index] = widget.content.checked

	self:_update_report_button_state()
end

ReportPlayerView._update_report_button_state = function (self)
	local can_submit = false

	for i = 1, #self._selected_options do
		if self._selected_options[i] then
			can_submit = true

			break
		end
	end

	self._widgets_by_name.report_button.content.hotspot.disabled = not can_submit
end

ReportPlayerView._get_server_type = function (self)
	local game_mode_manager = Managers.state.game_mode

	if not game_mode_manager then
		return "none"
	end

	local game_mode_name = game_mode_manager:game_mode_name()

	if game_mode_name == "hub" then
		return "hub"
	elseif game_mode_name == "coop_complete_objective" then
		return "mission"
	end

	return "none"
end

ReportPlayerView._get_reporter_id = function (self)
	local player = self:_player()

	return player:account_id()
end

ReportPlayerView._get_session_id = function (self)
	local player = self:_player()
	local session_id = player:telemetry_game_session()

	if session_id == nil then
		Log.warning("ReportPlayerView", "[_send_report] Invalid Session ID (nil).")

		session_id = "aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee"
	end

	return session_id
end

ReportPlayerView._send_report = function (self)
	local session_id = self:_get_session_id()
	local reporter_id = self:_get_reporter_id()
	local reportee_id = self._reportee_account_id
	local category = self._selected_category
	local message = self._report_details
	local server_type = self:_get_server_type()

	return Managers.backend:authenticate():next(function (account)
		local request_body = {
			sessionId = session_id,
			reporterId = reporter_id,
			reporteeId = reportee_id,
			category = category,
			message = message,
			partyMemberIds = {},
			serverType = server_type,
		}
		local builder = BackendUtilities.url_builder():path("/playerreports")
		local options = {
			method = "POST",
			body = request_body,
		}

		return Managers.backend:title_request(builder:to_string(), options)
	end)
end

ReportPlayerView._on_submit_pressed = function (self)
	self:_update_report_button_state()
	self:_send_report()
	Managers.ui:close_view(self.view_name)
	Managers.event:trigger("event_add_notification_message", "default", Localize("loc_player_report_sent"))
end

ReportPlayerView._on_close_pressed = function (self)
	Managers.ui:close_view(self.view_name)
end

ReportPlayerView._on_navigation_input_changed = function (self)
	ReportPlayerView.super._on_navigation_input_changed(self)

	if self._using_cursor_navigation then
		if self._selected_gamepad_navigation_index then
			self:_set_selected_gamepad_navigation_index(nil)
		end
	elseif not self._selected_gamepad_navigation_index then
		self:_set_selected_gamepad_navigation_index(1)
	end
end

ReportPlayerView._set_selected_gamepad_navigation_index = function (self, index)
	self._selected_gamepad_navigation_index = index

	local button_gamepad_navigation_list = self._button_gamepad_navigation_list

	for i = 1, #button_gamepad_navigation_list do
		local widget = button_gamepad_navigation_list[i]

		widget.content.hotspot.is_selected = i == index
	end
end

ReportPlayerView._handle_button_gamepad_navigation = function (self, input_service)
	local selected_widget = self._selected_widget

	if selected_widget then
		local close_selected_setting = false

		if input_service:get("left_pressed") or input_service:get("confirm_pressed") or input_service:get("back") then
			close_selected_setting = true
		end

		self._close_selected_setting = close_selected_setting
	else
		local selected_gamepad_navigation_index = self._selected_gamepad_navigation_index

		if not selected_gamepad_navigation_index then
			return
		end

		local button_gamepad_navigation_list = self._button_gamepad_navigation_list
		local new_index

		if input_service:get("navigate_up_continuous") then
			new_index = math.max(selected_gamepad_navigation_index - 1, 1)
		elseif input_service:get("navigate_down_continuous") then
			new_index = math.min(selected_gamepad_navigation_index + 1, #button_gamepad_navigation_list)
		end

		if new_index and new_index ~= selected_gamepad_navigation_index then
			self:_set_selected_gamepad_navigation_index(new_index)
			self:_play_sound(UISoundEvents.default_mouse_hover)
		end
	end
end

ReportPlayerView._handle_input = function (self, input_service, dt, t)
	if not self._window_open_anim_id and not self._window_close_anim_id then
		self:_handle_button_gamepad_navigation(input_service)
	end
end

ReportPlayerView._set_exclusive_focus_on_grid_widget = function (self, widget_name)
	local widgets = self._added_widgets
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

return ReportPlayerView
