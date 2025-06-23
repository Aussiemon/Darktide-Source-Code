-- chunkname: @scripts/ui/views/end_view/end_view.lua

local Definitions = require("scripts/ui/views/end_view/end_view_definitions")
local DefaultViewInputSettings = require("scripts/settings/input/default_view_input_settings")
local EndViewSettings = require("scripts/ui/views/end_view/end_view_settings")
local EndViewTestify = GameParameters.testify and require("scripts/ui/views/end_view/end_view_testify")
local LoadingStateData = require("scripts/ui/loading_state_data")
local MasterItems = require("scripts/backend/master_items")
local Missions = require("scripts/settings/mission/mission_templates")
local ProfileUtils = require("scripts/utilities/profile_utils")
local SocialConstants = require("scripts/managers/data_service/services/social/social_constants")
local Text = require("scripts/utilities/ui/text")
local UIProfileSpawner = require("scripts/managers/ui/ui_profile_spawner")
local UISettings = require("scripts/settings/ui/ui_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorldSpawner = require("scripts/managers/ui/ui_world_spawner")
local ViewStyles = require("scripts/ui/views/end_view/end_view_styles")
local PartyStatus = SocialConstants.PartyStatus
local _math_clamp01 = math.clamp01
local _math_floor = math.floor
local _math_max = math.max
local _math_min = math.min
local _continue_button_action = "continue_end_view"
local _vote_button_action = EndViewSettings.stay_in_party_vote_button
local SUMMARY_VIEW_NAME = "end_player_view"
local STAY_IN_PARTY = table.enum("yes", "no")
local EndView = class("EndView", "BaseView")

EndView.init = function (self, settings, context)
	local definitions = Definitions

	self._context = context
	self._can_exit = context and context.can_exit
	self._can_skip = false
	self._skip_grace_time = 0
	self._round_won = context and context.round_won or false
	self._session_report = context and context.session_report
	self._end_player_view_context = {}
	self._human_spawn_point_units = {}
	self._ogryn_spawn_point_units = {}
	self._player_widget_definition = nil
	self._delay_before_summary = EndViewSettings.delay_before_summary
	self._end_time = nil
	self._reference_name = "EndView_" .. tostring(self)
	self._stay_in_party_voting_id = nil
	self._stay_in_party_voting_active = false
	self._stay_in_party = STAY_IN_PARTY.no
	self._all_in_same_party = false
	self._all_voted_yes = false
	self._num_members_in_my_party = 1
	self._has_shown_summary_view = false
	self._fetch_party_done = false

	local level, dynamic_level_package = self:select_target_level()

	self._level = level

	EndView.super.init(self, definitions, settings, context, dynamic_level_package)

	self._pass_draw = false
	self._pass_input = true
end

EndView.on_enter = function (self)
	EndView.super.on_enter(self)

	self._waiting = false
	self._widget_alpha = 0
	self._game_mode_condition_widgets = {}

	self:_create_game_mode_condition_widgets()

	local context = self._context

	if context then
		local delay_before_summary = context.delay_before_summary

		if delay_before_summary then
			self._delay_before_summary = delay_before_summary
		end

		self._end_time = context.end_time

		local played_mission = context.played_mission
		local session_report = self._session_report
		local render_scale = self._render_scale

		self:_set_mission_key(played_mission, session_report, render_scale)
	end

	local t = Managers.time:time("main")
	local server_time = Managers.backend:get_server_time(t)

	self._show_player_view_time = server_time + self._delay_before_summary * 1000

	local continue_button = self._widgets_by_name.continue_button

	continue_button.content.hotspot.pressed_callback = callback(self, "_cb_on_continue_pressed")

	self:_setup_stay_in_party_vote()
	self:_setup_background_world()
	self:_on_navigation_input_changed()
end

EndView.on_exit = function (self)
	Managers.event:trigger("event_stop_waiting")

	if Managers.ui:view_active(SUMMARY_VIEW_NAME) then
		Managers.ui:close_view(SUMMARY_VIEW_NAME)
	end

	local ui_renderer = self._ui_renderer
	local game_mode_condition_widgets = self._game_mode_condition_widgets

	if game_mode_condition_widgets then
		for i = 1, #game_mode_condition_widgets do
			local widget = game_mode_condition_widgets[i]

			if widget.content.portrait_load_id then
				self:_unload_portrait_icon(widget, ui_renderer)
			end
		end
	end

	local spawn_slots = self._spawn_slots

	if spawn_slots then
		local num_slots = #spawn_slots

		for i = 1, num_slots do
			local slot = spawn_slots[i]

			if slot.occupied then
				self:_reset_spawn_slot(slot)
			end
		end
	end

	if self._world_spawner then
		self._world_spawner:destroy()

		self._world_spawner = nil
	end

	self:_unregister_event("event_state_game_score_continue")
	self:_unregister_event("event_stay_in_party_voting_started")
	self:_unregister_event("event_stay_in_party_voting_completed")
	self:_unregister_event("event_stay_in_party_voting_aborted")
	self:_unregister_event("event_stay_in_party_vote_casted")
	EndView.super.on_exit(self)
end

EndView.can_exit = function (self)
	return self._can_exit
end

EndView.allow_close_hotkey = function (self)
	return self._can_exit
end

local _update_alpha_fade_time = EndViewSettings.alpha_fade_time

EndView.update = function (self, dt, t, input_service)
	local world_spawner = self._world_spawner

	if world_spawner then
		world_spawner:update(dt, t)
	end

	local ui_manager = Managers.ui
	local is_showing_player_view = ui_manager:view_active(SUMMARY_VIEW_NAME)
	local session_report = self._session_report
	local end_time = self._end_time
	local show_player_view_time = self._show_player_view_time
	local server_time = Managers.backend:get_server_time(t)
	local has_shown_summary_view = not show_player_view_time and not is_showing_player_view

	if has_shown_summary_view ~= self._has_shown_summary_view then
		self._has_shown_summary_view = has_shown_summary_view
		self._skip_grace_time = EndViewSettings.skip_grace_time
	end

	local grace_time = self._skip_grace_time

	if grace_time > 0 then
		grace_time = math.max(grace_time - dt, 0)
	end

	self._skip_grace_time = grace_time

	local is_waiting_for_vote_to_end = self._stay_in_party_voting_active and self._stay_in_party == STAY_IN_PARTY.yes
	local can_skip = not has_shown_summary_view or not is_waiting_for_vote_to_end

	if can_skip ~= self._can_skip and (not can_skip or grace_time == 0) then
		self._can_skip = can_skip

		self:_update_buttons()
	end

	local waiting = not session_report or not end_time

	if self._waiting ~= waiting then
		if waiting then
			Managers.event:trigger("event_start_waiting")
		else
			Managers.event:trigger("event_stop_waiting")

			self._widgets_by_name.loading.content.visible = false
		end

		self._waiting = waiting
	end

	Managers.event:trigger("event_set_waiting_state", LoadingStateData.WAIT_REASON.backend)

	if self._waiting or DevParameters.debug_load_wait_info then
		local wait_reason, wait_time, debug_opacity = Managers.ui:current_wait_info()
		local opacity_multiplier = math.clamp(wait_time - 5, 0, 1) * 255

		if DevParameters.debug_load_wait_info then
			opacity_multiplier = debug_opacity
		end

		if opacity_multiplier > 0 then
			local loading_widget = self._widgets_by_name.loading

			loading_widget.content.text = wait_reason or ""
			loading_widget.content.visible = true
			loading_widget.style.text.text_color[1] = opacity_multiplier
			loading_widget.style.icon.color[1] = opacity_multiplier
			loading_widget.style.background.color[1] = opacity_multiplier * 0.5
		end
	end

	if not session_report then
		Managers.event:trigger("event_set_waiting_state", LoadingStateData.WAIT_REASON.backend)

		local progression_manager = Managers.progression

		if progression_manager:session_report_success() then
			session_report = progression_manager:session_report()
			self._session_report = session_report

			local context = self._context

			if context then
				local played_mission = context.played_mission
				local render_scale = self._render_scale

				self:_set_mission_key(played_mission, session_report, render_scale)
			end
		end
	end

	if not end_time then
		Managers.event:trigger("event_set_waiting_state", LoadingStateData.WAIT_REASON.dedicated_server)

		end_time = Managers.progression:game_score_end_time()
		self._end_time = end_time

		if end_time then
			local min_show_player_view_time = server_time + EndViewSettings.min_delay_before_summary * 1000

			show_player_view_time = math.max(show_player_view_time, min_show_player_view_time)
			self._show_player_view_time = show_player_view_time
		end
	end

	if session_report and end_time and show_player_view_time and show_player_view_time < server_time and not is_showing_player_view then
		Managers.event:trigger("event_stop_waiting")

		local character_session_report = self._session_report.character
		local context = self._context
		local summary_view_context = self._end_player_view_context

		summary_view_context.can_exit = false
		summary_view_context.round_won = context.round_won
		summary_view_context.session_report = character_session_report

		Managers.ui:open_view(SUMMARY_VIEW_NAME, nil, nil, nil, nil, summary_view_context)

		if context.round_won then
			local debrief_circumstance = session_report.eor.mission.appliedEvent
			local debrief_video = EndViewSettings.debrief_videos[debrief_circumstance]

			if debrief_video then
				Managers.video:queue_video(debrief_video)
			end
		end

		self:_register_event("event_state_game_score_continue")

		self._show_player_view_time = nil
	end

	self._widget_alpha = _math_clamp01(self._widget_alpha + dt / _update_alpha_fade_time * (is_showing_player_view and -1 or 1))

	self:_update_player_slots(dt, t, input_service)
	self:_update_continue_button_time(end_time, server_time)
	self:_update_voting_button_visibility(dt)

	if GameParameters.testify then
		Testify:poll_requests_through_handler(EndViewTestify, self)
	end

	return EndView.super.update(self, dt, t, input_service)
end

local _draw_layer = EndViewSettings.overlay_draw_layer

EndView.draw = function (self, dt, t, input_service, layer)
	layer = _draw_layer

	EndView.super.draw(self, dt, t, input_service, layer)
end

EndView.on_resolution_modified = function (self, scale)
	EndView.super.on_resolution_modified(self, scale)

	local context = self._context
	local session_report = self._session_report

	if context and session_report then
		local played_mission = context.played_mission

		self:_set_mission_key(played_mission, session_report, scale)
	end
end

EndView._on_navigation_input_changed = function (self)
	self:_update_buttons()
end

EndView.event_register_end_of_round_camera = function (self, camera_unit)
	self:_unregister_event("end_of_round_camera")

	if self._context then
		self._context.camera_unit = camera_unit
	end

	local viewport_name = EndViewSettings.viewport_name
	local viewport_type = EndViewSettings.viewport_type
	local viewport_layer = EndViewSettings.viewport_layer
	local shading_environment = self._level.shading_environment

	self._world_spawner:create_viewport(camera_unit, viewport_name, viewport_type, viewport_layer, shading_environment)
end

EndView.event_state_game_score_continue = function (self)
	local ui_manager = Managers.ui
	local is_showing_player_view = ui_manager:view_active(SUMMARY_VIEW_NAME)

	if is_showing_player_view then
		ui_manager:close_view(SUMMARY_VIEW_NAME)
	end
end

EndView.event_stay_in_party_voting_started = function (self, voting_id)
	Log.info("STAY_IN_PARTY_VOTING", "voting_id recieved: %s", voting_id)

	self._stay_in_party_voting_id = voting_id

	self:_set_stay_in_party_voting_init_step_done()
end

EndView._set_stay_in_party_voting_init_step_done = function (self)
	if self._stay_in_party_voting_id and self._fetch_party_done then
		Log.info("STAY_IN_PARTY_VOTING", "init_done")
		self:_stay_in_party_voting_started()
	end
end

EndView._stay_in_party_voting_started = function (self)
	local voting_id = self._stay_in_party_voting_id
	local all_is_same_party = self._all_in_same_party

	Log.info("STAY_IN_PARTY_VOTING", "started")

	if all_is_same_party and voting_id then
		Managers.voting:cast_vote(voting_id, "no")
		Log.info("STAY_IN_PARTY_VOTING", "everyone is same party, voting NO to merge")

		return
	end

	self._stay_in_party_voting_active = true

	self:_sync_votes()
end

EndView.event_stay_in_party_voting_completed = function (self)
	self._stay_in_party_voting_active = false
	self._stay_in_party_voting_id = nil
end

EndView.event_stay_in_party_voting_aborted = function (self)
	self._stay_in_party_voting_active = false
	self._stay_in_party_voting_id = nil
end

EndView.event_stay_in_party_vote_casted = function (self)
	if not self._stay_in_party_voting_active then
		return
	end

	self:_sync_votes()
end

EndView._handle_input = function (self, input_service, dt, t)
	if input_service:get(_continue_button_action) then
		self:_trigger_current_presentation_skip()
	end

	if self._stay_in_party_voting_active and input_service:get(_vote_button_action) then
		self:_cb_on_stay_in_party_pressed()
	end

	return EndView.super._handle_input(self, input_service, dt, t)
end

EndView._draw_widgets = function (self, dt, t, input_service, ui_renderer, render_settings)
	EndView.super._draw_widgets(self, dt, t, input_service, ui_renderer, render_settings)

	local camera = self._world_spawner:camera()
	local inverse_scale = ui_renderer.inverse_scale
	local widget_alpha = self._widget_alpha

	if widget_alpha > 0 then
		local game_mode_condition_widgets = self._game_mode_condition_widgets

		for i = 1, #game_mode_condition_widgets do
			local widget = game_mode_condition_widgets[i]

			widget.alpha_multiplier = widget_alpha

			local widget_content = widget.content
			local boxed_position = widget_content.boxed_position

			if boxed_position then
				local position = Vector3Box.unbox(boxed_position)
				local world_to_screen = Camera.world_to_screen(camera, position)
				local widget_offset_x = world_to_screen.x * inverse_scale

				widget.offset[1] = widget_offset_x
			end

			UIWidget.draw(widget, ui_renderer)
		end
	end
end

EndView._create_game_mode_condition_widgets = function (self)
	local game_mode_condition_widget_definitions = self._definitions.game_mode_condition_widget_definitions
	local round_condition_widget_definitions = self._round_won and game_mode_condition_widget_definitions.victory or game_mode_condition_widget_definitions.defeat
	local static_widget_definitions = round_condition_widget_definitions.static
	local widgets = self._widgets

	for name, definition in pairs(static_widget_definitions) do
		widgets[#widgets + 1] = self:_create_widget(name, definition)
	end

	local dynamic_widget_definitions = round_condition_widget_definitions.dynamic
	local game_mode_condition_widgets = self._game_mode_condition_widgets
	local title_text_widget_name = "title_text"
	local title_text_widget_definition = dynamic_widget_definitions[title_text_widget_name]

	game_mode_condition_widgets[#game_mode_condition_widgets + 1] = self:_create_widget(title_text_widget_name, title_text_widget_definition)

	local player_widget_definition_name = "player_panel"

	self._player_widget_definition = dynamic_widget_definitions[player_widget_definition_name]
end

EndView._update_continue_button_time = function (self, end_time, server_time)
	local widgets_by_name = self._widgets_by_name
	local widget = widgets_by_name.continue_button
	local widget_content = widget.content
	local time = end_time and _math_max(_math_floor((end_time - server_time) / 1000) + 1, 0)

	if time ~= widget_content.time then
		widget_content.time = time

		self:_update_buttons()
	end
end

local _voting_button_fade_time = ViewStyles.voting_button_fade_time

EndView._update_voting_button_visibility = function (self, dt)
	local voting_widget = self._widgets_by_name.stay_in_party_vote
	local is_active = self._stay_in_party_voting_active
	local alpha = voting_widget.alpha_multiplier or 0

	if is_active and alpha < 1 then
		alpha = _math_min(alpha + dt / _voting_button_fade_time, 1)
	elseif not is_active and alpha > 0 then
		alpha = _math_max(alpha - dt / _voting_button_fade_time, 0)
	end

	voting_widget.alpha_multiplier = alpha
	voting_widget.visible = is_active or alpha > 0
end

EndView._update_buttons = function (self)
	local service_type = DefaultViewInputSettings.service_type
	local vote_completed = not self._stay_in_party_voting_active
	local player_voted_yes = self._stay_in_party == STAY_IN_PARTY.yes
	local all_voted_yes = self._all_voted_yes
	local already_in_party = self._num_members_in_my_party > 1
	local continue_button_widget = self._widgets_by_name.continue_button
	local continue_button_content = continue_button_widget.content
	local continue_button_loc_string = continue_button_content.loc_string
	local continue_button_action = _continue_button_action
	local can_skip = self._can_skip
	local input_legend_text_template = can_skip and Localize("loc_input_legend_text_template") or nil
	local button_text = Text.localize_with_button_hint(continue_button_action, continue_button_loc_string, nil, service_type, input_legend_text_template)
	local time = continue_button_content.time

	if time and self._has_shown_summary_view then
		local timer_text = self:_get_timer_text(time)

		button_text = button_text .. " (" .. timer_text .. ")"
	end

	continue_button_content.text = button_text
	continue_button_content.vote_completed = vote_completed and all_voted_yes
	continue_button_content.hotspot.disabled = not can_skip

	local voting_widget = self._widgets_by_name.stay_in_party_vote
	local voting_widget_content = voting_widget.content

	voting_widget_content.vote_completed = vote_completed
	voting_widget_content.voted_yes = player_voted_yes
	voting_widget_content.can_skip = can_skip
	voting_widget_content.already_in_party = already_in_party

	local loc_string = EndViewSettings.stay_in_party_vote_text
	local vote_button_action = _vote_button_action
	local vote_button_text = Text.localize_with_button_hint(vote_button_action, loc_string, nil, service_type, input_legend_text_template)

	voting_widget_content.vote_text = vote_button_text

	local voting_widget_style = voting_widget.style
	local vote_count_style = voting_widget_style.vote_count_text

	vote_count_style.text_color = all_voted_yes and vote_count_style.voted_yes_color or vote_count_style.default_text_color
end

EndView._get_timer_text = function (self, time)
	local timer_text = string.format("%.2d:%.2d", _math_floor(time / 60) % 60, time % 60)

	return timer_text
end

EndView._trigger_current_presentation_skip = function (self)
	if not self._can_skip or self._skip_grace_time > 0 then
		return
	end

	if not self._has_shown_summary_view then
		Managers.event:trigger("event_trigger_current_end_presentation_skip")
	elseif not self._can_exit then
		Managers.multiplayer_session:leave("skip_end_of_round")
	end
end

EndView._setup_stay_in_party_vote = function (self)
	self:_register_event("event_stay_in_party_voting_started")
	self:_register_event("event_stay_in_party_voting_completed")
	self:_register_event("event_stay_in_party_voting_aborted")
	self:_register_event("event_stay_in_party_vote_casted")

	local party_manager = Managers.party_immaterium
	local active_party_vote = party_manager and party_manager:active_stay_in_party_vote()

	if active_party_vote then
		self:event_stay_in_party_voting_started(active_party_vote.voting_id)
	end

	local vote_widget = self._widgets_by_name.stay_in_party_vote
	local hotspot = vote_widget.content.hotspot

	hotspot.pressed_callback = callback(self, "_cb_on_stay_in_party_pressed")
end

EndView.select_target_level = function (self)
	local level_name
	local played_mission = self._context.played_mission

	level_name = played_mission == "psykhanium" and "horde" or "default"

	local level = EndViewSettings.levels_by_id[level_name] or EndViewSettings.levels_by_id.default
	local level_packages = {
		is_level_package = true,
		name = level.level_name
	}

	return level, level_packages
end

EndView._setup_background_world = function (self)
	self:_register_event("event_register_end_of_round_camera", "event_register_end_of_round_camera")

	local max_spawn_slots = 4

	for i = 1, max_spawn_slots do
		local event_name_human = "event_register_end_of_round_spawn_point_human_" .. i
		local event_name_ogryn = "event_register_end_of_round_spawn_point_ogryn_" .. i

		self[event_name_human] = function (self, spawn_unit)
			self._human_spawn_point_units[i] = spawn_unit

			self:_unregister_event(event_name_human)

			if table.size(self._human_spawn_point_units) == max_spawn_slots and table.size(self._ogryn_spawn_point_units) == max_spawn_slots then
				Managers.data_service.social:fetch_party_members():next(callback(self, "_setup_spawn_slots"))
			end
		end
		self[event_name_ogryn] = function (self, spawn_unit)
			self._ogryn_spawn_point_units[i] = spawn_unit

			self:_unregister_event(event_name_ogryn)

			if table.size(self._human_spawn_point_units) == max_spawn_slots and table.size(self._ogryn_spawn_point_units) == max_spawn_slots then
				Managers.data_service.social:fetch_party_members():next(callback(self, "_setup_spawn_slots"))
			end
		end

		self:_register_event(event_name_human)
		self:_register_event(event_name_ogryn)
	end

	local world_name = EndViewSettings.world_name
	local world_layer = EndViewSettings.world_layer
	local world_timer_name = EndViewSettings.timer_name

	self._world_spawner = UIWorldSpawner:new(world_name, world_layer, world_timer_name, self.view_name)

	local level_name
	local target_level = self._level

	level_name = self._level.level_name

	self._world_spawner:spawn_level(level_name)
	self:_register_event("end_of_round_blur_background_world", "_end_of_round_blur_background_world")
end

EndView._setup_spawn_slots = function (self, players)
	Log.info("EndView", "_setup_spawn_slots() num players: %d", table.size(players))

	local world = self._world_spawner:world()
	local camera = self._world_spawner:camera()
	local unit_spawner = self._world_spawner:unit_spawner()
	local ignored_slots = EndViewSettings.ignored_slots
	local player_index = 0
	local spawn_slots = {}
	local is_own_party = false
	local is_other_party = false
	local members_in_my_party = 0
	local players_in_mission = 0

	for unique_id, player_info in pairs(players) do
		players_in_mission = players_in_mission + 1

		local party_status = player_info:party_status()
		local num_party_members = player_info:num_party_members()

		if party_status == PartyStatus.mine then
			is_own_party = true
			members_in_my_party = members_in_my_party + 1
		elseif num_party_members > 1 then
			is_other_party = true
		end
	end

	local more_than_one_party = is_own_party and is_other_party

	self._all_in_same_party = members_in_my_party == players_in_mission or players_in_mission == 1
	self._num_members_in_my_party = members_in_my_party
	self._num_players_in_mission = players_in_mission

	for unique_id, player_info in pairs(players) do
		player_index = player_index + 1

		local profile_spawner = UIProfileSpawner:new("EndView_" .. player_index, world, camera, unit_spawner)

		profile_spawner:disable_rotation_input()

		for j = 1, #ignored_slots do
			local slot_name = ignored_slots[j]

			profile_spawner:ignore_slot(slot_name)
		end

		local spawn_slot = {
			occupied = false,
			index = player_index,
			profile_spawner = profile_spawner,
			ogryn_spawn_point_unit = self._ogryn_spawn_point_units[player_index],
			human_spawn_point_unit = self._human_spawn_point_units[player_index]
		}

		spawn_slots[player_index] = spawn_slot

		self:_assign_player_to_slot(player_info, spawn_slot, more_than_one_party)
	end

	self._spawn_slots = spawn_slots

	self:_set_character_names()

	self._fetch_party_done = true

	Log.info("STAY_IN_PARTY_VOTING", "fetch_party_done")
	self:_set_stay_in_party_voting_init_step_done()
end

EndView._get_free_slot_id = function (self)
	local spawn_slots = self._spawn_slots

	for i = 1, #spawn_slots do
		local slot = spawn_slots[i]

		if not slot.occupied then
			return i
		end
	end
end

EndView._player_slot_id = function (self, account_id)
	local spawn_slots = self._spawn_slots

	for i = 1, #spawn_slots do
		local slot = spawn_slots[i]

		if slot.occupied and slot.account_id == account_id then
			return i
		end
	end
end

EndView._assign_player_to_slot = function (self, player_info, slot, more_than_one_party)
	local account_id = player_info:account_id()
	local profile = player_info:profile()

	if not profile then
		if not slot.player_info then
			Log.warning("EndView", "Cannot show player model for %s, %s in EoR; no valid profile.", player_info:character_name(), tostring(account_id))
		end

		slot.player_info = player_info
		slot.account_id = account_id
		slot.more_than_one_party = more_than_one_party

		return
	end

	local preview_profile = table.clone_instance(profile)
	local loadout = preview_profile.loadout
	local item_state_machine, item_animation_event, item_face_animation_event, item_wield_slot
	local end_of_round_pose_item = loadout.slot_animation_end_of_round

	if end_of_round_pose_item then
		item_state_machine = end_of_round_pose_item.state_machine
		item_animation_event = end_of_round_pose_item.animation_event
		item_face_animation_event = end_of_round_pose_item.face_animation_event

		local prop_item_key = end_of_round_pose_item.prop_item
		local prop_item = prop_item_key and prop_item_key ~= "" and MasterItems.get_item(prop_item_key)

		if prop_item then
			local prop_item_slot = prop_item.slots[1]

			loadout[prop_item_slot] = prop_item
			item_wield_slot = prop_item_slot
		end
	end

	local archetype_settings = preview_profile.archetype
	local breed_name = archetype_settings.breed
	local spawn_point_unit

	if breed_name == "ogryn" then
		spawn_point_unit = slot.ogryn_spawn_point_unit
	else
		spawn_point_unit = slot.human_spawn_point_unit
	end

	local spawn_position = Unit.world_position(spawn_point_unit, 1)
	local spawn_rotation = Unit.world_rotation(spawn_point_unit, 1)
	local profile_size = profile.personal and profile.personal.character_height
	local spawn_scale = profile_size and Vector3(profile_size, profile_size, profile_size)

	slot.boxed_position = Vector3Box(spawn_position)
	slot.boxed_rotation = QuaternionBox(spawn_rotation)

	local profile_spawner = slot.profile_spawner
	local companion_data = {
		state_machine = end_of_round_pose_item.companion_state_machine ~= nil and end_of_round_pose_item.companion_state_machine ~= "" and end_of_round_pose_item.companion_state_machine or nil,
		animation_event = end_of_round_pose_item.companion_animation_event ~= nil and end_of_round_pose_item.companion_animation_event ~= "" and end_of_round_pose_item.companion_animation_event or nil
	}
	local companion_visible = not not companion_data.state_machine

	profile_spawner:spawn_profile(preview_profile, spawn_position, spawn_rotation, spawn_scale, item_state_machine, item_animation_event, nil, item_face_animation_event, nil, nil, nil, nil, companion_data)
	profile_spawner:toggle_companion(companion_visible)

	if item_wield_slot then
		profile_spawner:wield_slot(item_wield_slot)
	end

	slot.occupied = true
	slot.player_info = player_info
	slot.account_id = account_id
	slot.widget = self:_create_player_widget(player_info, slot, more_than_one_party)
end

EndView._create_player_widget = function (self, player_info, slot, more_than_one_party)
	local widget_definition = self._player_widget_definition
	local widget_name = string.format("player_panel_%d", slot.index)
	local widget = self:_create_widget(widget_name, widget_definition)
	local widget_content = widget.content
	local profile = player_info:profile()

	widget_content.player_info = player_info
	widget_content.boxed_position = slot.boxed_position
	widget_content.character_archetype_title = ProfileUtils.character_archetype_title(profile)

	local player_title = ProfileUtils.character_title(profile)

	if player_title and player_title ~= "" then
		widget_content.character_title = player_title
	end

	widget_content.peer_id = player_info:peer_id()

	local party_status = player_info:party_status()

	if more_than_one_party then
		if party_status == PartyStatus.mine then
			widget_content.party_status = "1"
		elseif party_status == PartyStatus.other then
			widget_content.party_status = "2"
		end
	end

	local widget_style = widget.style

	widget_style.party_status.visible = player_info:num_party_members() > 1

	if player_info:is_own_player() then
		local character_name_style = widget_style.character_name

		character_name_style.text_color = character_name_style.own_player_text_color
	end

	local portrait_material_values = widget_style.character_portrait.material_values

	portrait_material_values.use_placeholder_texture = 1

	self:_load_portrait_icon(widget, profile)

	local widget_index = #self._game_mode_condition_widgets + 1

	self._game_mode_condition_widgets[widget_index] = widget

	return widget
end

EndView._end_of_round_blur_background_world = function (self, blur_amount)
	self._world_spawner:set_camera_blur(blur_amount, EndViewSettings.total_blur_duration)
end

EndView._update_player_slots = function (self, dt, t, input_service)
	local spawn_slots = self._spawn_slots

	if spawn_slots then
		for i = 1, #spawn_slots do
			local slot = spawn_slots[i]

			if slot.occupied then
				local profile_spawner = slot.profile_spawner

				profile_spawner:update(dt, t, input_service)
			elseif slot.player_info then
				self:_assign_player_to_slot(slot.player_info, slot, slot.more_than_one_party)
			end
		end
	end

	self:_set_character_names()
end

EndView._reset_spawn_slot = function (self, slot)
	local profile_spawner = slot.profile_spawner

	if profile_spawner then
		profile_spawner:destroy()
	end

	slot.account_id = nil
	slot.profile_spawner = nil
	slot.player = nil
end

EndView._set_character_names = function (self)
	local session_report = self._session_report
	local session_report_raw = session_report and session_report.eor
	local participant_reports = session_report_raw and session_report_raw.team.participants
	local experience_settings = session_report and session_report.character.experience_settings
	local spawn_slots = self._spawn_slots

	if spawn_slots then
		for i = 1, #spawn_slots do
			local slot = spawn_slots[i]
			local account_id = slot.account_id
			local report = self:_get_participant_progression(participant_reports, account_id)
			local player_info = slot.player_info
			local widget = slot.widget

			if widget then
				local widget_content = widget.content
				local character_name = player_info:character_name()

				if not report then
					widget_content.character_name = character_name
				elseif not self._has_shown_summary_view then
					local character_level = report.currentLevel

					widget_content.character_name = Text.formatted_character_name(character_name, character_level)
				elseif player_info:is_own_player() then
					local character_level = player_info:character_level()

					widget_content.character_name = Text.formatted_character_name(character_name, character_level)
				else
					local xp = report.currentXp
					local level_after_mission = self:_level_from_xp(experience_settings, xp)

					widget_content.character_name = Text.formatted_character_name(character_name, level_after_mission)
				end

				widget_content.account_name = player_info:user_display_name()
			end
		end
	end
end

EndView._set_mission_key = function (self, mission_key, session_report, render_scale)
	local mission_settings = Missions[mission_key]
	local display_name = mission_settings.mission_name
	local widget = self._widgets_by_name.title_text
	local widget_content = widget.content

	widget_content.mission_header = self:_localize(display_name)

	local team_session_report = session_report and session_report.team

	if self._round_won and team_session_report then
		local mission_time_in_sec = team_session_report.play_time_seconds
		local game_mode_completion_time_seconds = team_session_report.game_mode_completion_time_seconds or nil
		local mission_sub_header_style = widget.style.mission_sub_header
		local stats_text_color = mission_sub_header_style.stats_text_color
		local text_params = {
			total_kills = team_session_report.total_kills,
			total_deaths = team_session_report.total_deaths,
			mission_time = Text.format_time_span_long_form_localized(game_mode_completion_time_seconds or mission_time_in_sec),
			font_size = mission_sub_header_style.stats_font_size * render_scale,
			font_color = string.format("%d,%d,%d", stats_text_color[2], stats_text_color[3], stats_text_color[4])
		}

		widget_content.mission_sub_header = Localize("loc_end_view_mission_sub_header_victory", true, text_params)

		local narrative_story = mission_settings.narrative_story

		if narrative_story then
			local narrative_manager = Managers.narrative
			local story = narrative_story.story
			local chapter = narrative_story.chapter
			local current_chapter = narrative_manager:current_chapter(story)
			local current_chapter_name = current_chapter and current_chapter.name

			if chapter == current_chapter_name then
				narrative_manager:complete_current_chapter(story, chapter)
			end
		end
	end
end

EndView._get_participant_progression = function (self, participant_reports, account_id)
	if participant_reports then
		for i = 1, #participant_reports do
			local report = participant_reports[i]

			if report.accountId == account_id then
				local progression_reports = report.progression

				if progression_reports then
					for j = 1, #progression_reports do
						local progression_report = progression_reports[j]

						if progression_report.type == "character" then
							return progression_report
						end
					end
				end
			end
		end
	end

	return nil
end

EndView._level_from_xp = function (self, experience_settings, xp)
	local max_level = experience_settings.max_level
	local xp_table = experience_settings.experience_table
	local level = 0

	while level < max_level and xp >= xp_table[level + 1] do
		level = level + 1
	end

	return level
end

EndView._load_portrait_icon = function (self, widget, profile)
	if not profile then
		return
	end

	local widget_content = widget.content
	local portrait_load_id = widget_content.portrait_load_id

	if portrait_load_id then
		self:_unload_widget_portrait(widget)
	end

	local profile_icon_loaded_callback = callback(self, "_cb_set_player_icon", widget)

	widget_content.awaiting_portrait_callback = true
	widget_content.portrait_load_id = Managers.ui:load_profile_portrait(profile, profile_icon_loaded_callback)
	widget_content.portrait_character_id = profile.character_id

	local loadout = profile.loadout
	local frame_item = loadout and loadout.slot_portrait_frame
	local frame_id = frame_item and frame_item.gear_id

	widget_content.frame_id = frame_id

	if frame_item then
		local cb = callback(self, "_cb_set_player_frame", widget)

		widget_content.frame_load_id = Managers.ui:load_item_icon(frame_item, cb)
	else
		widget_content.frame_load_id = nil
	end

	local insignia_item = loadout and loadout.slot_insignia or MasterItems.find_fallback_item("slot_insignia")
	local insignia_id = insignia_item and insignia_item.name

	widget_content.insignia_id = insignia_id

	local cb = callback(self, "_cb_set_player_insignia", widget)

	widget_content.insignia_load_id = Managers.ui:load_item_icon(insignia_item, cb)
end

EndView._sync_votes = function (self)
	local voting_id = self._stay_in_party_voting_id
	local num_votes = 0
	local yes_votes = 0
	local player_vote = STAY_IN_PARTY.no

	if voting_id then
		local votes = Managers.voting:votes(voting_id)
		local local_player_peer_id = Network.peer_id()
		local game_mode_condition_widgets = self._game_mode_condition_widgets

		for i = 1, #game_mode_condition_widgets do
			local widget = game_mode_condition_widgets[i]
			local peer_id = widget.content.peer_id

			if peer_id then
				local vote = votes[peer_id]

				if vote == STAY_IN_PARTY.yes then
					yes_votes = yes_votes + 1

					if peer_id == local_player_peer_id then
						player_vote = STAY_IN_PARTY.yes
					end
				end

				num_votes = num_votes + 1

				local checkmark_style = widget.style.checkmark

				checkmark_style.visible = vote == STAY_IN_PARTY.yes
			end
		end
	end

	local num_votes_text = string.format("%d/%d", yes_votes, num_votes)
	local voting_widget = self._widgets_by_name.stay_in_party_vote
	local widget_content = voting_widget.content

	widget_content.vote_count_text = num_votes_text
	self._all_voted_yes = yes_votes == num_votes
	self._stay_in_party = player_vote

	self:_update_buttons()
end

EndView._unload_portrait_icon = function (self, widget, ui_renderer)
	UIWidget.set_visible(widget, ui_renderer, false)
	UIWidget.set_visible(widget, ui_renderer, true)

	local widget_content = widget.content
	local portrait_style = widget.style.character_portrait

	if widget_content.insignia_id then
		self:_unload_insignia(widget)
	end

	if widget_content.frame_load_id then
		self:_unload_portrait_frame(widget)
	end

	local portrait_load_id = widget_content.portrait_load_id

	if not portrait_load_id then
		return
	end

	local material_values = portrait_style.material_values

	material_values.use_placeholder_texture = 1

	Managers.ui:unload_profile_portrait(portrait_load_id)

	widget_content.portrait_load_id = nil
end

EndView._unload_portrait_frame = function (self, widget, ui_renderer)
	local frame_style = widget.style.character_portrait
	local material_values = frame_style.material_values
	local portrait_frame_texture = material_values.portrait_frame_texture

	material_values.portrait_frame_texture = UISettings.portrait_frame_default_texture

	local widget_content = widget.content

	Managers.ui:unload_item_icon(widget_content.frame_load_id)

	widget_content.frame_load_id = nil
end

EndView._unload_insignia = function (self, widget)
	local insignia_style = widget.style.character_insignia

	widget.content.character_insignia = "content/ui/materials/nameplates/insignias/default"

	local material_values = insignia_style.material_values
	local character_insignia_texture = material_values.texture_map

	material_values.texture_map = UISettings.insignia_default_texture

	local widget_content = widget.content

	Managers.ui:unload_item_icon(widget_content.insignia_load_id)

	widget_content.insignia_load_id = nil
end

EndView._cb_on_continue_pressed = function (self)
	self:_trigger_current_presentation_skip()
end

EndView._cb_on_stay_in_party_pressed = function (self)
	local voting_id = self._stay_in_party_voting_id
	local player_vote = self._stay_in_party == STAY_IN_PARTY.no and STAY_IN_PARTY.yes or STAY_IN_PARTY.no

	self._stay_in_party = player_vote

	if voting_id then
		Managers.voting:cast_vote(voting_id, player_vote)
	end

	self:_update_buttons()
end

EndView._cb_set_player_icon = function (self, widget, grid_index, rows, columns, render_target)
	local portrait_style = widget.style.character_portrait
	local material_values = portrait_style.material_values

	material_values.use_placeholder_texture = 0
	material_values.rows = rows
	material_values.columns = columns
	material_values.grid_index = grid_index - 1
	material_values.texture_icon = render_target
end

EndView._cb_set_player_frame = function (self, widget, item)
	local portrait_style = widget.style.character_portrait

	portrait_style.material_values.portrait_frame_texture = item.icon
end

EndView._cb_set_player_insignia = function (self, widget, item)
	local icon_style = widget.style.character_insignia
	local material_values = icon_style.material_values

	if item.icon_material and item.icon_material ~= "" then
		widget.content.old_character_insignia = widget.content.character_insignia
		widget.content.character_insignia = item.icon_material

		if material_values.texture_map then
			material_values.texture_map = nil
		end
	else
		if widget.content.old_character_insignia then
			widget.content.character_insignia = widget.content.old_character_insignia
			widget.content.old_character_insignia = nil
		end

		material_values.texture_map = item.icon
	end
end

EndView.can_skip = function (self)
	return self._can_skip
end

EndView.skip_grace_time = function (self)
	return self._skip_grace_time
end

return EndView
