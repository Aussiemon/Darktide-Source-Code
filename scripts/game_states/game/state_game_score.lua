local StateGameScore = class("StateGameScore")
local EndViewSettings = require("scripts/ui/views/end_view/end_view_settings")
local EndPartyViewSettings = require("scripts/ui/views/end_party_view/end_party_view_settings")
local MAX_EOR_DURATION = EndViewSettings.max_duration
local events = {
	event_state_game_score_continue = "_continue"
}

StateGameScore.on_enter = function (self, parent, params, creation_context)
	self._creation_context = creation_context
	self._current_view_index = nil
	self._played_mission = params.mission_name
	self._end_view_name = nil
	local total_presentation_time = self:_get_total_presentation_time()
	self._background_view_open = false

	if DEDICATED_SERVER then
		self._server_continue_time = Managers.time:time("main") + total_presentation_time
	elseif LEVEL_EDITOR_TEST or not Managers.ui then
		Managers.mechanism:trigger_event("game_score_done")
	else
		self._event_registered = true

		for event_name, function_name in pairs(events) do
			Managers.event:register(self, event_name, function_name)
		end

		self:_present_end_of_round_view()
	end

	Managers.presence:set_presence("end_of_round")
end

StateGameScore._present_end_of_round_view = function (self)
	local eor_view_name = "end_view"
	local end_result = Managers.mechanism:end_result()
	local round_won = end_result and end_result == "won"
	local session_report = Managers.progression:session_report()
	local view_context = {
		round_won = round_won,
		played_mission = self._played_mission,
		session_report = session_report,
		duration = self:_get_total_presentation_time(),
		delay_before_summary = EndViewSettings.delay_before_summary
	}
	self._end_view_name = eor_view_name

	Managers.ui:open_view(eor_view_name, nil, nil, nil, nil, view_context)
end

StateGameScore._get_total_presentation_time = function (self)
	local duration = 0
	duration = MAX_EOR_DURATION

	return duration
end

StateGameScore._continue = function (self)
	local done = true

	if done then
		Managers.mechanism:trigger_event("game_score_done")
	end
end

StateGameScore.update = function (self, main_dt, main_t)
	local context = self._creation_context

	context.network_receive_function(main_dt)
	context.network_transmit_function()

	if self._server_continue_time and self._server_continue_time < main_t then
		Log.info("StateGameScore", "State Done. server_continue_time: %f main_t: %f", self._server_continue_time, main_t)
		Managers.mechanism:trigger_event("game_score_done")

		self._server_continue_time = nil
	end

	return Managers.mechanism:wanted_transition()
end

StateGameScore.on_exit = function (self)
	local ui_manager = Managers.ui

	if ui_manager and (ui_manager:view_active(self._end_view_name) or self._background_view_open) then
		Log.info("StateGameScore", "State Done. Closing end view")
		ui_manager:close_view(self._end_view_name)
	end

	if self._event_registered then
		self._event_registered = nil

		for event_name, function_name in pairs(events) do
			Managers.event:unregister(self, event_name)
		end
	end
end

return StateGameScore
