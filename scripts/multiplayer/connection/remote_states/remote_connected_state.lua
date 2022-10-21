local RPCS = {
	"rpc_client_entered_connected_state"
}
local RemoteConnectedState = class("RemoteConnectedState")

RemoteConnectedState.init = function (self, state_machine, shared_state)
	self._shared_state = shared_state

	shared_state.event_list[#shared_state.event_list + 1] = function ()
		shared_state.reserved_peers = nil
		shared_state.reserved_player_slots = nil

		Log.info("RemoteConnectedState", "[init] LoadingTimes: Peer(%s) Connected", shared_state.peer_id)

		self._game_has_been_notified = true

		return {
			name = "connected",
			parameters = {
				peer_id = Network.peer_id(shared_state.channel_id),
				channel_id = shared_state.channel_id,
				player_sync_data = shared_state.player_sync_data
			}
		}
	end

	self._host_peer = Network.peer_id()
	self._client_peer = Network.peer_id(shared_state.channel_id)
	self._has_eac = shared_state.eac_server ~= nil
	self._game_has_been_notified = false
	self._reply_has_been_sent = false

	shared_state.event_delegate:register_connection_channel_events(self, shared_state.channel_id, unpack(RPCS))
end

RemoteConnectedState.destroy = function (self)
	local shared_state = self._shared_state

	shared_state.event_delegate:unregister_channel_events(shared_state.channel_id, unpack(RPCS))
end

RemoteConnectedState.update = function (self, dt)
	local shared_state = self._shared_state
	local state, reason = Network.channel_state(shared_state.channel_id)

	if state == "disconnected" then
		Log.info("RemoteConnectedState", "Connection channel disconnected %s", shared_state.peer_id)

		return "disconnected", {
			engine_reason = reason
		}
	end

	if not self._reply_has_been_sent and self._game_has_been_notified then
		RPC.rpc_check_connected_reply(shared_state.channel_id)

		self._reply_has_been_sent = true
	end
end

RemoteConnectedState.rpc_client_entered_connected_state = function (self, channel_id)
	local shared_state = self._shared_state
	shared_state.client_entered_connected_state = true
end

return RemoteConnectedState
