-- chunkname: @scripts/loading/loading_host.lua

local function _info(...)
	Log.info("LoadingHost", ...)
end

local Loader = require("scripts/loading/loader")
local LoadingHostStateMachine = require("scripts/loading/loading_host_state_machine")
local LoadingRemoteStateMachine = require("scripts/loading/loading_remote_state_machine")
local SpawnQueue = require("scripts/loading/spawn_queue")
local SpawnQueueHub = require("scripts/loading/spawn_queue_hub")
local LoadingHost = class("LoadingHost")

LoadingHost.SPAWN_QUEUE_DELAY = 10
LoadingHost.MIN_TIME_BEFORE_SPAWN_GROUP_HAS_SYNC_ISSUE = 45
LoadingHost.MAX_TIME_STEP = 0.03333333333333333
LoadingHost.NUM_SYNC_ISSUES_BEFORE_ALLOWING_SYNC_PEER_TO_BE_KICKED = 3

LoadingHost.init = function (self, network_delegate, loaders, connection_class_name)
	self._network_delegate = network_delegate
	self._loaders = loaders

	local connection_manager = Managers.connection
	local host_type = connection_manager:host_type()

	if host_type == "hub_server" then
		local spawn_queue_delay = 1

		self._spawn_queue = SpawnQueueHub:new(spawn_queue_delay)
	elseif host_type == "mission_server" then
		local spawn_queue_delay = 60

		self._spawn_queue = SpawnQueue:new(spawn_queue_delay)
	else
		local spawn_queue_delay = LoadingHost.SPAWN_QUEUE_DELAY

		self._spawn_queue = SpawnQueue:new(spawn_queue_delay)
	end

	self._mission = nil
	self._spawn_groups = Script.new_array(16)
	self._spawned_peers = Script.new_array(16)
	self._package_sync_enabled_peers = Script.new_array(16)
	self._sync_issue_history = Script.new_map(8)
	self._state = "initial_spawn"

	_info("Setting state %s", self._state)

	self._done_loading_level_func = function (spawn_group_id, peer_id)
		for _, spawn_group in ipairs(self._spawn_groups) do
			if spawn_group.id == spawn_group_id then
				spawn_group.level_loaded[peer_id] = true

				return
			end
		end
	end

	self._level_state = "unloaded"
	self._level = nil
	self._clients = {}
	self._host = nil
	self._single_player = connection_class_name == "ConnectionSingleplayer"
	self._package_synchronizer_host = Managers.package_synchronization:synchronizer_host()
	self._mission_seed = nil
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

local temp_peers_array = Script.new_array(32)
local temp_peers_filter_map = Script.new_map(32)
local temp_peers_with_sync_issues_map = Script.new_map(32)

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

	local spawn_queue = self._spawn_queue
	local spawn_groups = self._spawn_groups
	local allow_multiple_spawn_groups = self._state == "hot_join"
	local can_add_more_groups = allow_multiple_spawn_groups or #spawn_groups == 0
	local next_spawn_group_id = can_add_more_groups and spawn_queue:ready_group()

	while next_spawn_group_id do
		Log.info("LoadingHost", "[update] LoadingTimes: Spawn Group (%d), Start processing", next_spawn_group_id)

		local group_peers = spawn_queue:trigger_group(next_spawn_group_id)
		local spawn_group = {
			state = "wait_for_level",
			sync_issue_timer = 0,
			id = next_spawn_group_id,
			peers = group_peers,
			level_loaded = Script.new_map(#group_peers),
		}

		spawn_groups[#spawn_groups + 1] = spawn_group

		if not allow_multiple_spawn_groups then
			break
		end

		next_spawn_group_id = spawn_queue:ready_group()
	end

	local peers_to_enable = temp_peers_array

	for _, spawn_group in ipairs(spawn_groups) do
		if spawn_group.state == "wait_for_level" then
			local levels_loaded = table.size(spawn_group.level_loaded) == #spawn_group.peers

			if levels_loaded then
				Log.info("LoadingHost", "[update] LoadingTimes: Spawn Group (%d) Finished Loading Level Packages (%s)", spawn_group.id, self._state)
				table.append(peers_to_enable, spawn_group.peers)

				spawn_group.state = "wait_for_sync"
			end
		end
	end

	local package_sync_enabled_peers = self._package_sync_enabled_peers
	local package_sync_host = self._package_synchronizer_host

	if #peers_to_enable > 0 then
		Log.info("LoadingHost", "[update] LoadingTimes: Enable %d new peers in PackageSynchronizerHost", #peers_to_enable)
		table.append(package_sync_enabled_peers, peers_to_enable)
		package_sync_host:enable_peers(package_sync_enabled_peers)
		table.clear(peers_to_enable)
	end

	local spawned_peers = self._spawned_peers
	local time_step = math.min(dt, LoadingHost.MAX_TIME_STEP)
	local has_spawn_group_to_remove = false
	local has_sync_issues = false
	local sync_issue_history = self._sync_issue_history
	local spawning_peers_with_sync_issues = temp_peers_with_sync_issues_map
	local profile_sync_host = Managers.profile_synchronization:synchronizer_host()

	for _, spawn_group in ipairs(spawn_groups) do
		if spawn_group.state == "wait_for_sync" then
			local spawn_group_and_spawned_peers = temp_peers_array

			table.append(spawn_group_and_spawned_peers, spawn_group.peers)
			table.append(spawn_group_and_spawned_peers, spawned_peers)

			local sync_peers_filter = temp_peers_filter_map

			table.set(spawn_group_and_spawned_peers, sync_peers_filter)

			local profiles_synced = profile_sync_host:profiles_synced(spawn_group_and_spawned_peers, sync_peers_filter)
			local packages_synced = package_sync_host:peers_synced(spawn_group.peers, sync_peers_filter)

			if profiles_synced and packages_synced then
				Log.info("LoadingHost", "[update] LoadingTimes: Spawn Group (%d) Finished Loading Profile Packages (%s)", spawn_group.id, self._state)

				if self._state == "initial_spawn" then
					self._state = "wait_for_end_load"

					_info("Setting state %s", self._state)

					spawn_group.state = "wait_for_end_load"
				elseif self._state == "hot_join" then
					self:_finish_spawn_group(spawn_group)
					table.append(spawned_peers, spawn_group.peers)

					for _, peer_id in ipairs(spawn_group_and_spawned_peers) do
						sync_issue_history[peer_id] = nil
					end

					for _, other_spawn_group in ipairs(spawn_groups) do
						if other_spawn_group ~= spawn_group then
							other_spawn_group.sync_issue_timer = 0
						end
					end

					spawn_group.state = "ready_to_remove"
					has_spawn_group_to_remove = true
				end
			else
				spawn_group.sync_issue_timer = spawn_group.sync_issue_timer + time_step

				if spawn_group.sync_issue_timer > LoadingHost.MIN_TIME_BEFORE_SPAWN_GROUP_HAS_SYNC_ISSUE then
					Log.info("LoadingHost", "[update] LoadingTimes: Spawn Group (%d) Detecting Sync Issues", spawn_group.id)

					if self:_determine_spawn_group_sync_issues(spawn_group, sync_peers_filter, spawning_peers_with_sync_issues) then
						has_sync_issues = true
					end

					spawn_group.sync_issue_timer = 0
				end
			end

			table.clear(sync_peers_filter)
			table.clear(spawn_group_and_spawned_peers)
		end
	end

	if has_sync_issues then
		local host_peer_id = Network.peer_id()
		local peers_to_kick = Script.new_map(4)

		for peer_id, non_synced_peer_ids in pairs(spawning_peers_with_sync_issues) do
			for sync_peer_id, _ in pairs(non_synced_peer_ids) do
				local num_sync_issues = sync_issue_history[sync_peer_id] or 0

				if sync_peer_id == host_peer_id then
					Log.warning("LoadingHost", "[update] Peer %s failed to sync with host, kick peer", peer_id)

					peers_to_kick[peer_id] = "sync_host"
				elseif num_sync_issues >= LoadingHost.NUM_SYNC_ISSUES_BEFORE_ALLOWING_SYNC_PEER_TO_BE_KICKED then
					peers_to_kick[sync_peer_id] = "sync_spawning"
				else
					peers_to_kick[peer_id] = "sync_other"
				end
			end
		end

		local kick_reason = "loading_host_sync_error"

		for peer_id, kick_details in pairs(peers_to_kick) do
			Managers.connection:kick(peer_id, kick_reason, kick_details)
		end

		table.clear(spawning_peers_with_sync_issues)
	end

	if has_spawn_group_to_remove then
		for i = #spawn_groups, 1, -1 do
			local spawn_group = spawn_groups[i]

			if spawn_group.state == "ready_to_remove" then
				table.remove(spawn_groups, i)
			end
		end
	end
end

LoadingHost._determine_spawn_group_sync_issues = function (self, spawn_group, sync_peers_filter, spawning_peers_with_sync_issues)
	local package_sync_host = self._package_synchronizer_host
	local profile_sync_host = Managers.profile_synchronization:synchronizer_host()
	local sync_issue_history = self._sync_issue_history
	local has_sync_issues = false

	for _, peer_id in ipairs(spawn_group.peers) do
		local non_synced_peer_ids = Script.new_map(4)
		local non_synced_peers = {
			Profile = {
				profile_sync_host:peers_not_synced_with(peer_id, sync_peers_filter),
			},
			Package = {
				package_sync_host:peers_not_synced_with(peer_id, sync_peers_filter),
			},
		}

		for sync_type, peers in pairs(non_synced_peers) do
			local peer_to_others = peers[1]
			local others_to_peer = peers[2]

			for _, sync_peer_id in ipairs(peer_to_others) do
				Log.info("LoadingHost", "[sync_issue] LoadingTimes: Spawn Group (%d) Issue Syncing %s Peer %s -> Other %s", spawn_group.id, sync_type, peer_id, sync_peer_id)

				non_synced_peer_ids[sync_peer_id] = true

				local num_sync_issues = (sync_issue_history[peer_id] or 0) + 1

				sync_issue_history[peer_id] = num_sync_issues
			end

			for _, sync_peer_id in ipairs(others_to_peer) do
				Log.info("LoadingHost", "[sync_issue] LoadingTimes: Spawn Group (%d) Issue Syncing %s Other %s -> Peer %s", spawn_group.id, sync_type, sync_peer_id, peer_id)

				non_synced_peer_ids[sync_peer_id] = true

				local num_sync_issues = (sync_issue_history[sync_peer_id] or 0) + 1

				sync_issue_history[sync_peer_id] = num_sync_issues
			end
		end

		if table.size(non_synced_peer_ids) > 0 then
			spawning_peers_with_sync_issues[peer_id] = non_synced_peer_ids
			has_sync_issues = true
		end
	end

	return has_sync_issues
end

LoadingHost.add = function (self, client_channel_id)
	Profiler.send_message(string.format("[LoadingHost][add] client_channel_id: %s", tostring(client_channel_id)))

	local client = LoadingRemoteStateMachine:new(self._network_delegate, client_channel_id, self._spawn_queue, self._done_loading_level_func, self._mission_seed)

	self._clients[client_channel_id] = client
end

LoadingHost.remove = function (self, client_channel_id)
	Profiler.send_message(string.format("[LoadingHost][remove] client_channel_id: %s", tostring(client_channel_id)))

	local client = self._clients[client_channel_id]
	local client_peer_id = client:peer_id()

	client:delete()

	self._clients[client_channel_id] = nil

	self._spawn_queue:remove_from_queue(client_peer_id)

	for group_index, spawn_group in ipairs(self._spawn_groups) do
		local peer_index = table.find(spawn_group.peers, client_peer_id)

		if peer_index then
			table.remove(spawn_group.peers, peer_index)

			if table.is_empty(spawn_group.peers) then
				self._spawn_queue:retire_group(spawn_group.id)
				table.remove(self._spawn_groups, group_index)
			end

			break
		end
	end

	self._sync_issue_history[client_peer_id] = nil

	local peer_index = table.find(self._spawned_peers, client_peer_id)

	if peer_index then
		table.remove(self._spawned_peers, peer_index)
	end

	peer_index = table.find(self._package_sync_enabled_peers, client_peer_id)

	if peer_index then
		table.remove(self._package_sync_enabled_peers, peer_index)
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

local SESSION_MAX_SEED = 2147483647

LoadingHost.generate_mission_seed = function (self)
	local override

	override = tonumber(DevParameters.mission_seed)

	if override then
		self._mission_seed = override
	else
		self._mission_seed = math.random(SESSION_MAX_SEED)
	end
end

LoadingHost.load_mission = function (self, loading_context)
	local mission = loading_context.mission_name

	self:generate_mission_seed()
	self:stop_load_mission()

	self._mission = mission
	self._host = LoadingHostStateMachine:new(loading_context, loading_context.level_name, self._spawn_queue, self._loaders, self._done_loading_level_func, self._single_player, self._mission_seed)

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
		local client = LoadingRemoteStateMachine:new(self._network_delegate, channel_id, self._spawn_queue, self._done_loading_level_func, self._mission_seed)

		self._clients[channel_id] = client
	end

	self._state = "initial_spawn"

	_info("Setting state %s", self._state)
end

LoadingHost.first_group_ready = function (self)
	return self._state == "wait_for_end_load"
end

LoadingHost.end_load = function (self)
	local spawn_groups = self._spawn_groups
	local spawn_group = table.remove(spawn_groups, 1)

	self:_finish_spawn_group(spawn_group)
	table.append(self._spawned_peers, spawn_group.peers)
end

LoadingHost._finish_spawn_group = function (self, spawn_group)
	Log.info("LoadingHost", "LoadingTimes: Spawn Group (%d) ready", spawn_group.id)

	for _, peer_id in ipairs(spawn_group.peers) do
		for _, client in pairs(self._clients) do
			if client:peer_id() == peer_id then
				client:spawn_group_ready(spawn_group.id)
			end
		end
	end

	self._spawn_queue:retire_group(spawn_group.id)

	if self._state == "hot_join" then
		return
	end

	local spawn_queue_delay = 1

	self._spawn_queue:set_delay_time(spawn_queue_delay)

	self._state = "hot_join"

	_info("Setting state %s", self._state)
end

return LoadingHost
