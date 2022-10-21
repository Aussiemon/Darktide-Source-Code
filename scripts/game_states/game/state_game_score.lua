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
		if Managers.progression:fetching_session_report_not_started() then
			local session_id = Managers.connection:session_id()

			Managers.progression:fetch_session_report(session_id)
		end

		self._end_view_name = "end_view"

		self:_present_end_of_round_view()
	end

	Managers.presence:set_presence("end_of_round")
end

StateGameScore._present_end_of_round_view = function (self)
	local eor_view_name = self._end_view_name
	local game_score_end_time = Managers.progression:game_score_end_time()
	local session_report = nil

	if Managers.progression:session_report_success() then
		session_report = Managers.progression:session_report()
	end

	local end_result = Managers.mechanism:end_result()
	local round_won = end_result and end_result == "won"
	local played_mission = self._played_mission
	local view_context = {
		round_won = round_won,
		played_mission = played_mission,
		session_report = session_report,
		end_time = game_score_end_time
	}

	Managers.ui:open_view(eor_view_name, nil, nil, nil, nil, view_context)
	Log.info("StateGameScore", "_present_end_of_round_view, view_context: %s", table.tostring(view_context))
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

	if Managers.connection:is_host() then
		local game_score_done = self._game_score_done

		if not game_score_done then
			local game_score_end_time = Managers.progression:game_score_end_time()

			if game_score_end_time then
				local server_time = Managers.backend:get_server_time(main_t)

				if game_score_end_time < server_time then
					Log.info("StateGameScore", "State Done. game_score_end_time: %s server_time: %s", game_score_end_time, server_time)
					Managers.mechanism:trigger_event("game_score_done")

					self._game_score_done = true
				end
			end
		end
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
