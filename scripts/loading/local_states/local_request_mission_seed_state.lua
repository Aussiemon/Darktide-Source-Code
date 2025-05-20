-- chunkname: @scripts/loading/local_states/local_request_mission_seed_state.lua

local LocalRequestMissionSeedState = class("LocalRequestMissionSeedState")

LocalRequestMissionSeedState.init = function (self, state_machine, shared_state)
	self._shared_state = shared_state
	self._seed_received = false

	shared_state.network_delegate:register_connection_channel_events(self, shared_state.host_channel_id, "rpc_set_mission_seed", "rpc_resend_mission_seed_request")
	RPC.rpc_request_mission_seed(self._shared_state.host_channel_id)
end

LocalRequestMissionSeedState.destroy = function (self)
	self._shared_state.network_delegate:unregister_channel_events(self._shared_state.host_channel_id, "rpc_set_mission_seed", "rpc_resend_mission_seed_request")
end

LocalRequestMissionSeedState.update = function (self, dt)
	if self._shared_state.mission_seed then
		return "mission_seed_received"
	end
end

LocalRequestMissionSeedState.rpc_set_mission_seed = function (self, channel_id, mission_seed)
	local shared_state = self._shared_state

	shared_state.mission_seed = mission_seed

	Log.info("LocalRequestMissionSeedState", "[rpc_set_mission_seed] Received mission seed from host")
end

LocalRequestMissionSeedState.rpc_resend_mission_seed_request = function (self, channel_id)
	Log.info("LocalRequestMissionSeedState", "[rpc_resend_mission_seed_request] Host requested we re-request the mission seed")
	RPC.rpc_request_mission_seed(self._shared_state.host_channel_id)
end

return LocalRequestMissionSeedState
