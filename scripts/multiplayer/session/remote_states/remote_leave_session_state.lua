local RemoteLeaveSessionState = class("RemoteLeaveSessionState")

RemoteLeaveSessionState.init = function (self, state_machine, shared_state)
	assert(shared_state.event_list, "Event list required")
	assert(shared_state.engine_gamesession, "Game session required")
	assert(shared_state.engine_lobby, "Engine lobby required")
	assert(type(shared_state.peer_id) == "string", "Peer ID required")
	assert(type(shared_state.gameobject_callback_object) == "table", "Callback object required")

	self._shared_state = shared_state
end

RemoteLeaveSessionState.enter = function (self, reason)
	local shared_state = self._shared_state
	local channel_id = shared_state.channel_id
	reason.peer_id = shared_state.peer_id
	reason.channel_id = channel_id

	if shared_state.has_been_in_session then
		shared_state.event_list[#shared_state.event_list + 1] = {
			name = "session_left",
			parameters = reason
		}
		shared_state.has_been_in_session = false
	end

	if shared_state.peer_added_to_session then
		GameSession.remove_peer(shared_state.engine_gamesession, shared_state.channel_id, shared_state.gameobject_callback_object)

		shared_state.peer_added_to_session = false
	end

	if channel_id then
		shared_state.engine_lobby:close_channel(channel_id)
	end
end

return RemoteLeaveSessionState
