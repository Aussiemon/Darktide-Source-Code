local RemoteCreateSessionState = class("RemoteCreateSessionState")

RemoteCreateSessionState.init = function (self, state_machine, shared_state)
	self._shared_state = shared_state
end

RemoteCreateSessionState.update = function (self, dt)
	local shared_state = self._shared_state
	local game_session_manager = Managers.state.game_session

	if game_session_manager and game_session_manager:is_server() then
		game_session_manager:add_peer(shared_state.client_peer_id)

		shared_state.added_to_game_session = true

		RPC.rpc_group_loaded(shared_state.client_channel_id, shared_state.spawn_group)
		Managers.event:trigger("spawn_group_loaded")

		return "in_session"
	end
end

return RemoteCreateSessionState
