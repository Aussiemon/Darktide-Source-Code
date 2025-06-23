-- chunkname: @scripts/multiplayer/connection/local_states/local_version_check_state.lua

local RPCS = {
	"rpc_check_version_reply"
}
local LocalVersionCheckState = class("LocalVersionCheckState")

LocalVersionCheckState.init = function (self, state_machine, shared_state)
	self._shared_state = shared_state
	self._time = 0
	self._approved = nil

	RPC.rpc_check_version(shared_state.channel_id, shared_state.network_hash)
	shared_state.event_delegate:register_connection_channel_events(self, shared_state.channel_id, unpack(RPCS))
end

LocalVersionCheckState.destroy = function (self)
	local shared_state = self._shared_state

	shared_state.event_delegate:unregister_channel_events(shared_state.channel_id, unpack(RPCS))
end

LocalVersionCheckState.update = function (self, dt)
	local shared_state = self._shared_state

	self._time = self._time + dt

	if self._time > shared_state.timeout then
		Log.info("LocalVersionCheckState", "Timeout waiting for rpc_check_version_reply")

		return "timeout", {
			game_reason = "timeout"
		}
	end

	local state, reason = Network.channel_state(shared_state.channel_id)

	if state == "disconnected" then
		Log.info("LocalVersionCheckState", "Connection channel disconnected")

		return "disconnected", {
			engine_reason = reason
		}
	end

	if self._approved ~= nil then
		if self._approved then
			return "versions matched"
		else
			Log.info("LocalVersionCheckState", "Version mismatch")

			return "versions mismatched", {
				game_reason = "version_mismatch"
			}
		end
	end
end

LocalVersionCheckState.rpc_check_version_reply = function (self, channel_id, success)
	self._approved = success
end

return LocalVersionCheckState
