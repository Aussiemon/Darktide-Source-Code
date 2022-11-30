local StateVictoryDefeat = class("StateVictoryDefeat")
local EOR_VIEW_NAME = "end_view"

StateVictoryDefeat.on_enter = function (self, parent, params, creation_context)
	self._creation_context = creation_context

	if DEDICATED_SERVER then
		self._done = true
	else
		self._waiting_for_report = true

		if Managers.progression:fetching_session_report_not_started() then
			local session_id = params.mechanism_data.session_id

			Managers.progression:fetch_session_report(session_id)
		end
	end

	self._end_result = params.mechanism_data.end_result
end

StateVictoryDefeat.update = function (self, main_dt, main_t)
	local context = self._creation_context

	context.network_receive_function(main_dt)
	context.network_transmit_function()

	local fail = Managers.progression:session_report_fail()
	local success = Managers.progression:session_report_success()
	local result = fail or success

	if self._waiting_for_report and result then
		self._waiting_for_report = false
	end

	if not self._done and result then
		Managers.mechanism:trigger_event("ready_for_game_score", Network.peer_id(), success)

		self._done = true
		local ui_manager = Managers.ui

		if fail and ui_manager and ui_manager:view_active(EOR_VIEW_NAME) then
			ui_manager:close_view(EOR_VIEW_NAME)
		end
	end

	return Managers.mechanism:wanted_transition()
end

StateVictoryDefeat.on_exit = function (self)
	self._end_result = nil
end

StateVictoryDefeat.end_result = function (self)
	return self._end_result
end

return StateVictoryDefeat
