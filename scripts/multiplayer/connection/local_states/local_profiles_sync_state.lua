local ProfileUtils = require("scripts/utilities/profile_utils")
local RPCS = {
	"rpc_sync_local_profiles_reply"
}
local LocalProfilesSyncState = class("LocalProfilesSyncState")

LocalProfilesSyncState.init = function (self, state_machine, shared_state)
	assert(type(shared_state.event_delegate) == "table", "Event delegate required")
	assert(type(shared_state.channel_id) == "number", "Numeric channel id required")
	assert(type(shared_state.timeout) == "number", "Numeric timeout required")

	self._shared_state = shared_state
	self._time = 0
	self._got_reply = false
	local network_event_delegate = shared_state.event_delegate
	local channel_id = shared_state.channel_id

	network_event_delegate:register_connection_channel_events(self, channel_id, unpack(RPCS))

	local profile_synchronizer_client = shared_state.profile_synchronizer_client

	profile_synchronizer_client:register_rpcs(channel_id)

	self._profile_synchronizer_client = profile_synchronizer_client
	local peer_id = Network.peer_id()
	local players_at_peer = Managers.player:players_at_peer(peer_id)
	self._peer_id = peer_id
	self._players = players_at_peer

	RPC.rpc_ready_to_receive_local_profiles(channel_id)
end

LocalProfilesSyncState.destroy = function (self)
	local shared_state = self._shared_state

	shared_state.event_delegate:unregister_channel_events(shared_state.channel_id, unpack(RPCS))
end

LocalProfilesSyncState.update = function (self, dt)
	local shared_state = self._shared_state
	self._time = self._time + dt

	if shared_state.timeout < self._time then
		Log.info("LocalProfilesSyncState", "Timeout waiting for rpc_sync_local_profiles_reply")

		return "timeout", {
			game_reason = "timeout"
		}
	end

	local state, reason = Network.channel_state(shared_state.channel_id)

	if state == "disconnected" then
		Log.info("LocalProfilesSyncState", "Connection channel disconnected")

		return "disconnected", {
			engine_reason = reason
		}
	end

	if self._got_reply then
		return "profiles synced"
	end
end

LocalProfilesSyncState.rpc_sync_local_profiles_reply = function (self, channel_id)
	local profile_synchronizer_client = self._profile_synchronizer_client
	local peer_id = self._peer_id
	local players = self._players

	for local_player_id, player in pairs(players) do
		local profile_json = profile_synchronizer_client:player_profile_json(peer_id, local_player_id)
		local profile = ProfileUtils.unpack_profile(profile_json)

		player:set_profile(profile)
	end

	self._got_reply = true
end

return LocalProfilesSyncState
