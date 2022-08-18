local StateVictoryDefeat = class("StateVictoryDefeat")
local VIEW_NAME = "blank_view"

StateVictoryDefeat.on_enter = function (self, parent, params, creation_context)
	self._creation_context = creation_context

	if DEDICATED_SERVER then
		self._done = true
	else
		local session_id = params.mechanism_data.session_id

		Managers.progression:fetch_session_report(session_id)

		self._waiting_for_report = true
	end

	self._end_result = params.mechanism_data.end_result

	if Managers.ui then
		Managers.ui:open_view(VIEW_NAME, nil, nil, nil, nil, params.mechanism_data)
	end

	Managers.presence:set_presence("end_of_round")
end

StateVictoryDefeat.update = function (self, main_dt, main_t)
	local context = self._creation_context

	context.network_receive_function(main_dt)
	context.network_transmit_function()

	if self._waiting_for_report and not Managers.progression:is_fetching_session_report() then
		self._waiting_for_report = false
	end

	if not self._done and not self._waiting_for_report then
		local success = Managers.progression:session_report_success()

		Managers.mechanism:trigger_event("ready_for_game_score", Network.peer_id(), success)

		self._done = true
	end

	return Managers.mechanism:wanted_transition()
end

StateVictoryDefeat.on_exit = function (self)
	local ui_manager = Managers.ui

	if ui_manager and ui_manager:view_active(VIEW_NAME) then
		ui_manager:close_view(VIEW_NAME)
	end

	self._end_result = nil
end

StateVictoryDefeat.end_result = function (self)
	return self._end_result
end

return StateVictoryDefeat
