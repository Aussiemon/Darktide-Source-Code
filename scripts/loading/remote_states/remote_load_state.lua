local RPCS = {
	"rpc_finished_loading_level"
}
local RemoteLoadState = class("RemoteLoadState")

RemoteLoadState.init = function (self, state_machine, shared_state)
	self._shared_state = shared_state
	self._ready_to_spawn = false
	local extension_manager = Managers.state.extension

	if extension_manager then
		local cinematic_scene_system = Managers.state.extension:system("cinematic_scene_system")
		self._preload_cinematic = not cinematic_scene_system:intro_played()
	else
		self._preload_cinematic = true
	end

	shared_state.network_delegate:register_connection_channel_events(self, shared_state.client_channel_id, unpack(RPCS))
	Managers.event:register(self, "cutscene_loaded_all_clients", "_on_cutscene_loaded")
end

RemoteLoadState.destroy = function (self)
	local shared_state = self._shared_state

	shared_state.network_delegate:unregister_channel_events(shared_state.client_channel_id, unpack(RPCS))
	Managers.event:unregister(self, "cutscene_loaded_all_clients")
end

RemoteLoadState.update = function (self, dt)
	if self._ready_to_spawn and self._cinematic_loaded then
		return "load_done"
	end
end

RemoteLoadState.spawn_group_ready = function (self, spawn_group)
	if self._shared_state.spawn_group == spawn_group then
		self._ready_to_spawn = true

		Log.info("RemoteLoadState", "[spawn_group_ready] LoadingTimes: Peer(%s) Spawn Group Is Ready To Spawn", self._shared_state.client_peer_id)

		if self._preload_cinematic then
			Managers.event:trigger("preload_cinematic")
		else
			self._cinematic_loaded = true
		end
	end
end

RemoteLoadState.rpc_finished_loading_level = function (self, channel_id, spawn_group)
	local shared_state = self._shared_state

	shared_state.done_loading_level_func(spawn_group, shared_state.client_peer_id)
	Log.info("RemoteLoadState", "[rpc_finished_loading_level] LoadingTimes: Peer (%s) Finished Loading Level Breed and Hud Packages", shared_state.client_peer_id)
end

RemoteLoadState._on_cutscene_loaded = function (self)
	if self._preload_cinematic then
		self._cinematic_loaded = true
	end
end

return RemoteLoadState
