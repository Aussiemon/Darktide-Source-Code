local RPCS = {
	"rpc_finished_loading_level"
}
local RemoteLoadState = class("RemoteLoadState")

RemoteLoadState.init = function (self, state_machine, shared_state)
	fassert(type(shared_state.network_delegate) == "table", "Network delegate required")
	fassert(type(shared_state.client_channel_id) == "number", "Client channel required")
	fassert(type(shared_state.spawn_queue) == "table", "Spawn queue required")
	fassert(type(shared_state.spawn_group) == "number", "Spawn group required")

	self._shared_state = shared_state
	self._ready_to_spawn = false

	shared_state.network_delegate:register_connection_channel_events(self, shared_state.client_channel_id, unpack(RPCS))
end

RemoteLoadState.destroy = function (self)
	local shared_state = self._shared_state

	shared_state.network_delegate:unregister_channel_events(shared_state.client_channel_id, unpack(RPCS))
end

RemoteLoadState.update = function (self, dt)
	if self._ready_to_spawn then
		return "load_done"
	end
end

RemoteLoadState.spawn_group_ready = function (self, spawn_group)
	if self._shared_state.spawn_group == spawn_group then
		self._ready_to_spawn = true

		Log.info("RemoteLoadState", "[spawn_group_ready] LoadingTimes: Peer(%s) Spawn Group Is Ready To Spawn", self._shared_state.client_peer_id)
	end
end

RemoteLoadState.rpc_finished_loading_level = function (self, channel_id, spawn_group)
	local shared_state = self._shared_state

	shared_state.done_loading_level_func(spawn_group, shared_state.client_peer_id)
	Log.info("RemoteLoadState", "[rpc_finished_loading_level] LoadingTimes: Peer (%s) Finished Loading Level Breed and Hud Packages", shared_state.client_peer_id)
end

return RemoteLoadState
