-- chunkname: @scripts/loading/remote_states/remote_init_state.lua

local RemoteInitState = class("RemoteInitState")

RemoteInitState.init = function (self, state_machine, shared_state)
	self._shared_state = shared_state
end

RemoteInitState.update = function (self, dt)
	Log.info("RemoteInitState", "[init] LoadingTimes: Prompting client(%s) to re-request mission seed", self._shared_state.client_peer_id)
	self:_tell_client_to_request_seed()

	return "init_done"
end

RemoteInitState._tell_client_to_request_seed = function (self)
	local shared_state = self._shared_state

	RPC.rpc_resend_mission_seed_request(shared_state.client_channel_id)
	Log.info("RemoteInitState", "[_tell_client_to_request_seed] Told client(%s) to re-request mission seed", shared_state.client_peer_id)
end

return RemoteInitState
