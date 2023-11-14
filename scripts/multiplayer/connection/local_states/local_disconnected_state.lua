local LocalDisconnectedState = class("LocalDisconnectedState")

LocalDisconnectedState.init = function (self, state_machine, shared_state)
	self._shared_state = shared_state
	local has_eac = false

	if has_eac and Managers.eac_client:in_session() then
		Managers.eac_client:end_session()
	end

	if shared_state.started_state_sync then
		Managers.mechanism:disconnect(shared_state.channel_id)
	end

	if Managers.stats then
		for _, player in pairs(Managers.player:players_at_peer(Network.peer_id())) do
			local local_player_id = player:local_player_id()

			Managers.stats:clear_session_data(local_player_id)
		end
	end

	shared_state.engine_lobby:close_channel(shared_state.channel_id)
end

LocalDisconnectedState.enter = function (self, reason)
	local shared_state = self._shared_state
	reason.peer_id = shared_state.host_peer_id
	reason.channel_id = shared_state.channel_id
	shared_state.event_list[#shared_state.event_list + 1] = {
		name = "disconnected",
		parameters = reason
	}
end

return LocalDisconnectedState
