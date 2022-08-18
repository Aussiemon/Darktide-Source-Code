local RPCS = {
	"rpc_request_eac_approval"
}
local RemoteEacCheckState = class("RemoteEacCheckState")

RemoteEacCheckState.init = function (self, state_machine, shared_state)
	assert(type(shared_state.event_delegate) == "table", "Event delegate required")
	assert(type(shared_state.channel_id) == "number", "Numeric channel id required")
	assert(type(shared_state.peer_id) == "string", "Peer id required")
	assert(type(shared_state.timeout) == "number", "Numeric timeout required")

	self._shared_state = shared_state
	self._time = 0
	self._got_request = false
	self._host_peer = Network.peer_id()
	local eac_server = shared_state.eac_server

	if eac_server then
		local player_sync_data = shared_state.player_sync_data
		local channel_id = shared_state.channel_id
		local account_id_array = player_sync_data.account_id_array
		local local_player_id = 1
		local account_id = account_id_array[local_player_id]

		Managers.eac_server:add_peer(channel_id, account_id)

		shared_state.eac_client_added = true
	end

	shared_state.event_delegate:register_connection_channel_events(self, shared_state.channel_id, unpack(RPCS))
end

RemoteEacCheckState.destroy = function (self)
	local shared_state = self._shared_state

	shared_state.event_delegate:unregister_channel_events(shared_state.channel_id, unpack(RPCS))
end

RemoteEacCheckState.update = function (self, dt)
	local shared_state = self._shared_state
	self._time = self._time + dt

	if shared_state.timeout < self._time then
		if self._got_request then
			Log.info("RemoteEacCheckState", "Timeout waiting for EAC result %s", shared_state.peer_id)
		else
			Log.info("RemoteEacCheckState", "Timeout waiting for rpc_request_eac_approval %s", shared_state.peer_id)
		end

		return "timeout", {
			game_reason = "timeout"
		}
	end

	local state, reason = Network.channel_state(shared_state.channel_id)

	if state == "disconnected" then
		Log.info("RemoteEacCheckState", "Connection channel disconnect %s", shared_state.peer_id)

		return "disconnected", {
			engine_reason = reason
		}
	end

	if not self._got_request then
		return
	end

	RPC.rpc_request_eac_approval_reply(shared_state.channel_id, true)

	return "eac approved"
end

RemoteEacCheckState.rpc_request_eac_approval = function (self, channel_id)
	self._got_request = true
end

return RemoteEacCheckState
