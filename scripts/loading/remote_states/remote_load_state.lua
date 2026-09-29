-- chunkname: @scripts/loading/remote_states/remote_load_state.lua

local MatchmakingConstants = require("scripts/settings/network/matchmaking_constants")
local RPCS = {
	"rpc_finished_loading_level"
}
local RemoteLoadState = class("RemoteLoadState")
local HOST_TYPES_PRELOAD_CINEMATIC = {
	[MatchmakingConstants.HOST_TYPES.mission_server] = true,
	[MatchmakingConstants.HOST_TYPES.singleplay_backend_session] = true
}

RemoteLoadState.init = function (self, state_machine, shared_state)
	self._shared_state = shared_state
	self._ready_to_spawn = false

	local host_type = Managers.connection:host_type()

	if HOST_TYPES_PRELOAD_CINEMATIC[host_type] then
		local extension_manager = Managers.state.extension

		if extension_manager then
			self._preload_cinematic = not Managers.state.cinematic:intro_loading_started()
		else
			self._preload_cinematic = true
		end
	else
		self._preload_cinematic = false
	end

	shared_state.network_delegate:register_connection_channel_events(self, shared_state.client_channel_id, unpack(RPCS))

	if self._preload_cinematic then
		Managers.event:register(self, "cutscene_loaded_all_clients", "_on_cutscene_loaded")
	end
end

RemoteLoadState.destroy = function (self)
	local shared_state = self._shared_state

	shared_state.network_delegate:unregister_channel_events(shared_state.client_channel_id, unpack(RPCS))
	Managers.event:unregister(self, "cutscene_loaded_all_clients")
end

RemoteLoadState.update = function (self, dt)
	if self._ready_to_spawn and (not self._preload_cinematic or self._cinematic_loaded) then
		return "load_done"
	end
end

RemoteLoadState.spawn_group_ready = function (self, spawn_group)
	if self._shared_state.spawn_group == spawn_group then
		Log.info("RemoteLoadState", "[spawn_group_ready] LoadingTimes: Peer(%s) Spawn Group Is Ready To Spawn", self._shared_state.client_peer_id)

		self._ready_to_spawn = true

		if self._preload_cinematic then
			Managers.event:trigger("preload_cinematic", spawn_group)
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

RemoteLoadState._on_cutscene_loaded = function (self, preload, id)
	if preload and self._shared_state.spawn_group == id then
		self._cinematic_loaded = true
	end
end

return RemoteLoadState
