-- chunkname: @scripts/loading/loading_host.lua

local function _info(...)
	Log.info("LoadingHost", ...)
end

local Loader = require("scripts/loading/loader")
local LoadingHostStateMachine = require("scripts/loading/loading_host_state_machine")
local LoadingRemoteStateMachine = require("scripts/loading/loading_remote_state_machine")
local SpawnQueue = require("scripts/loading/spawn_queue")
local LoadingHost = class("LoadingHost")

LoadingHost.SPAWN_QUEUE_DELAY = 10

LoadingHost.init = function (self, network_delegate, loaders, connection_class_name)
	self._network_delegate = network_delegate
	self._loaders = loaders

	local spawn_queue_delay = LoadingHost.SPAWN_QUEUE_DELAY
	local connection_manager = Managers.connection
	local host_type = connection_manager:host_type()

	if host_type == "hub_server" then
		spawn_queue_delay = 1
	elseif host_type == "mission_server" then
		spawn_queue_delay = 60
	end

	self._spawn_queue = SpawnQueue:new(spawn_queue_delay)
	self._mission = nil
	self._spawn_group = nil
	self._spawn_peers = nil
	self._state = "initial_spawn"

	_info("Setting state %s", self._state)

	self._done_loading_level_func = function (spawn_group, peer_id)
		self._spawn_queue:loaded_level(spawn_group, peer_id)
	end

	self._level_state = "unloaded"
	self._level = nil
	self._clients = {}
	self._host = nil
	self._single_player = connection_class_name == "ConnectionSingleplayer"
	self._package_synchronizer_host = Managers.package_synchronization:synchronizer_host()
end

LoadingHost.destroy = function (self)
	for _, client in pairs(self._clients) do
		client:destroy()
	end

	self._clients = nil

	if self._host then
		self._host:delete()

		self._host = nil
	end

	for _, loader in ipairs(self._loaders) do
		if not loader:dont_destroy() then
			loader:cleanup()
			loader:delete()
		end
	end

	table.clear(self._loaders)
	self._spawn_queue:delete()
end

LoadingHost.update = function (self, dt)
	self._spawn_queue:update(dt)

	for _, client in pairs(self._clients) do
		client:update(dt)
	end

	if self._host then
		self._host:update(dt)
	end

	if not Managers.package_synchronization:is_ready() then
		return
	end

	if not Managers.profile_synchronization:is_ready() then
		return
	end

	local spawn_group = self._spawn_queue:ready_group()

	if spawn_group then
		local peers = self._spawn_queue:trigger_group(spawn_group)

		self._spawn_group = spawn_group
		self._spawn_peers = peers
		self._profile_loading_enabled = false
	end

	if self._spawn_group then
		local levels_loaded = self._spawn_queue:all_levels_loaded(self._spawn_group)
		local profile_loading_enabled = self._profile_loading_enabled

		if levels_loaded and not profile_loading_enabled then
			Log.info("LoadingHost", "[update] LoadingTimes: Spawn Group Finished Loading Level Breed and Hud Packages, Started Loading Player Profile Packages")
			self._package_synchronizer_host:enable_peers(self._spawn_peers)

			self._profile_loading_enabled = true
		end

		local profile_sync_host = Managers.profile_synchronization:synchronizer_host()
		local package_sync_host = self._package_synchronizer_host
		local profiles_loaded = profile_loading_enabled and profile_sync_host:profiles_synced(self._spawn_peers)
		local packages_loaded = profile_loading_enabled and package_sync_host:peers_synced(self._spawn_peers)
		local all_loaded = levels_loaded and profiles_loaded and packages_loaded

		if all_loaded then
			if self._state == "initial_spawn" then
				self._state = "wait_for_end_load"

				_info("Setting state %s", self._state)
				Log.info("LoadingHost", "[update] LoadingTimes: Spawn Group Finished Loading Required Player Profile Packages for Initial Spawn")
			elseif self._state == "hot_join" then
				self:_trigger_spawn_group()
				Log.info("LoadingHost", "[update] LoadingTimes: Spawn Group Finished Loading Required Player Profile Packages for Hot Join")
			end
		end
	end
end

LoadingHost.add = function (self, client_channel_id)
	Profiler.send_message(string.format("[LoadingHost][add] client_channel_id: %s", tostring(client_channel_id)))

	local client = LoadingRemoteStateMachine:new(self._network_delegate, client_channel_id, self._spawn_queue, self._done_loading_level_func)

	self._clients[client_channel_id] = client
end

LoadingHost.remove = function (self, client_channel_id)
	Profiler.send_message(string.format("[LoadingHost][remove] client_channel_id: %s", tostring(client_channel_id)))

	local client = self._clients[client_channel_id]
	local client_peer_id = client:peer_id()

	client:delete()

	self._clients[client_channel_id] = nil

	self._spawn_queue:remove_from_queue(client_peer_id)

	if self._spawn_peers then
		local spawn_peer_index = table.find(self._spawn_peers, client_peer_id)

		if spawn_peer_index then
			table.remove(self._spawn_peers, spawn_peer_index)
		end

		if table.size(self._spawn_peers) == 1 then
			local _, remaining_peer_id = next(self._spawn_peers)

			if DEDICATED_SERVER and remaining_peer_id == Network.peer_id() then
				self._spawn_queue:retire_group(self._spawn_group)

				self._spawn_group = nil
				self._spawn_peers = nil
			end
		end
	end
end

LoadingHost.failed = function (self, failed_peers)
	for channel_id, client in pairs(self._clients) do
		if client:state() == "failed" then
			failed_peers[#failed_peers + 1] = Network.peer_id(channel_id)
		end
	end
end

LoadingHost.take_ownership_of_level = function (self)
	if self._host then
		return self._host:take_ownership_of_level()
	end
end

LoadingHost.mission = function (self)
	return self._mission
end

LoadingHost.load_mission = function (self, mission, level_editor_level, circumstance_name)
	self:stop_load_mission()

	self._mission = mission
	self._host = LoadingHostStateMachine:new(mission, level_editor_level, circumstance_name, self._spawn_queue, self._loaders, self._done_loading_level_func, self._single_player)

	self._package_synchronizer_host:set_mission_name(mission)
end

LoadingHost.load_mission = function (self, mission, level_editor_level, circumstance_name, havoc_data)
	self:stop_load_mission()

	self._mission = mission
	self._host = LoadingHostStateMachine:new(mission, level_editor_level, circumstance_name, self._spawn_queue, self._loaders, self._done_loading_level_func, self._single_player, havoc_data)

	self._package_synchronizer_host:set_mission_name(mission)
end

LoadingHost.stop_load_mission = function (self)
	self._spawn_queue:reset()

	self._mission = nil

	local old_channels = {}

	for channel_id, client in pairs(self._clients) do
		old_channels[#old_channels + 1] = channel_id

		client:destroy()
	end

	table.clear(self._clients)

	if self._host then
		self._host:delete()

		self._host = nil
	end

	for _, channel_id in ipairs(old_channels) do
		local client = LoadingRemoteStateMachine:new(self._network_delegate, channel_id, self._spawn_queue, self._done_loading_level_func)

		self._clients[channel_id] = client
	end

	self._state = "initial_spawn"

	_info("Setting state %s", self._state)
end

LoadingHost.first_group_ready = function (self)
	return self._state == "wait_for_end_load"
end

LoadingHost.end_load = function (self)
	self:_trigger_spawn_group()
end

LoadingHost._trigger_spawn_group = function (self)
	for _, client in pairs(self._clients) do
		client:spawn_group_ready(self._spawn_group)
	end

	self._spawn_queue:retire_group(self._spawn_group)

	self._spawn_group = nil
	self._spawn_peers = nil

	local state = self._state

	if state ~= "hot_join" then
		local spawn_queue_delay = 1

		self._spawn_queue:set_delay_time(spawn_queue_delay)
	end

	self._state = "hot_join"

	_info("Setting state %s", self._state)
end

return LoadingHost
