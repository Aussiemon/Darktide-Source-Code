local RPCS = {
	"rpc_check_version"
}
local RemoteVersionCheckState = class("RemoteVersionCheckState")

RemoteVersionCheckState.init = function (self, state_machine, shared_state)
	self._shared_state = shared_state
	self._time = 0
	self._remote_hash = nil

	shared_state.event_delegate:register_connection_channel_events(self, shared_state.channel_id, unpack(RPCS))
end

RemoteVersionCheckState.destroy = function (self)
	local shared_state = self._shared_state

	shared_state.event_delegate:unregister_channel_events(shared_state.channel_id, unpack(RPCS))
end

RemoteVersionCheckState.update = function (self, dt)
	local shared_state = self._shared_state
	self._time = self._time + dt

	if shared_state.timeout < self._time then
		Log.info("RemoteVersionCheckState", "Timeout waiting for rpc_check_version %s", shared_state.peer_id)

		return "timeout", {
			game_reason = "timeout"
		}
	end

	local state, reason = Network.channel_state(shared_state.channel_id)

	if state == "disconnected" then
		Log.info("RemoteVersionCheckState", "Connection channel disconnect %s", shared_state.peer_id)

		return "disconnected", {
			engine_reason = reason
		}
	end

	if self._remote_hash ~= nil then
		local success = self._remote_hash == shared_state.network_hash

		RPC.rpc_check_version_reply(shared_state.channel_id, success)

		if success then
			return "versions matched"
		else
			Log.info("RemoteVersionCheckState", "Version mismatch %s", shared_state.peer_id)

			return "versions mismatched", {
				game_reason = "version_mismatch"
			}
		end
	end
end

RemoteVersionCheckState.rpc_check_version = function (self, channel_id, hash)
	self._remote_hash = hash
end

return RemoteVersionCheckState
