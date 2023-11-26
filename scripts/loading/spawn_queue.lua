-- chunkname: @scripts/loading/spawn_queue.lua

local SpawnQueue = class("SpawnQueue")

SpawnQueue.init = function (self, group_delay)
	self._delay = group_delay
	self._waiting = {
		peers = {}
	}
	self._waiting_group_id = nil
	self._spawning = {
		peers = {}
	}
	self._spawning_group_id = nil
	self._spawned = {}
	self._peer_level_loaded = {}
	self._waiting_age = 0
	self._group_id_type_info = Network.type_info("spawn_group")
	self._group_id_counter = self._group_id_type_info.min
end

SpawnQueue.reset = function (self)
	table.clear(self._waiting.peers)

	self._waiting_group_id = nil

	table.clear(self._spawning.peers)

	self._spawning_group_id = nil

	table.clear(self._spawned)
	table.clear(self._peer_level_loaded)
end

SpawnQueue.place_in_queue = function (self, peer_id, callback)
	if table.is_empty(self._waiting.peers) then
		self._waiting_age = 0
	end

	self._waiting.peers[peer_id] = callback
	self._peer_level_loaded[peer_id] = false
end

SpawnQueue.remove_from_queue = function (self, peer_id)
	self._waiting.peers[peer_id] = nil
	self._spawning.peers[peer_id] = nil
	self._peer_level_loaded[peer_id] = nil

	local index = table.find(self._spawned, peer_id)

	if index then
		table.swap_delete(self._spawned, index)
	end
end

SpawnQueue.ready_group = function (self)
	return self._waiting_group_id
end

SpawnQueue.loaded_level = function (self, spawn_group, peer_id)
	self._peer_level_loaded[peer_id] = true
end

SpawnQueue.trigger_group = function (self, group_id)
	local peers = {}

	for peer, _ in pairs(self._waiting.peers) do
		peers[#peers + 1] = peer
	end

	for _, peer in ipairs(self._spawned) do
		peers[#peers + 1] = peer
	end

	self._waiting.peers, self._spawning.peers = self._spawning.peers, self._waiting.peers
	self._waiting_group_id, self._spawning_group_id = self._spawning_group_id, self._waiting_group_id

	for peer, callback in pairs(self._spawning.peers) do
		callback(self._spawning_group_id)
	end

	return peers
end

SpawnQueue.all_levels_loaded = function (self, group_id)
	for peer, _ in pairs(self._spawning.peers) do
		if not self._peer_level_loaded[peer] then
			return false
		end
	end

	return true
end

SpawnQueue.retire_group = function (self, group_id)
	for peer, _ in pairs(self._spawning.peers) do
		self._spawned[#self._spawned + 1] = peer
	end

	table.clear(self._spawning.peers)

	self._spawning_group_id = nil
end

SpawnQueue.set_delay_time = function (self, group_delay)
	self._delay = group_delay
end

SpawnQueue.update = function (self, dt)
	if table.is_empty(self._waiting.peers) then
		return
	end

	self._waiting_age = self._waiting_age + dt

	if self._spawning_group_id == nil then
		local wait_reached = self._waiting_age >= self._delay
		local is_everyone_waiting = self:_is_everyone_waiting()
		local is_game_filled = self:_is_game_filled()

		if (wait_reached or is_everyone_waiting or is_game_filled) and self._waiting_group_id == nil then
			self._waiting_group_id = self:_generate_group_id()
		end
	end
end

SpawnQueue._is_everyone_waiting = function (self)
	return table.size(self._waiting.peers) > Managers.connection:num_members()
end

SpawnQueue._is_game_filled = function (self)
	return table.size(self._waiting.peers) + #self._spawned == Managers.connection:max_members() + 1
end

SpawnQueue._generate_group_id = function (self)
	local id = self._group_id_counter

	self._group_id_counter = self._group_id_counter + 1

	if self._group_id_counter > self._group_id_type_info.max then
		self._group_id_counter = self._group_id_type_info.min
	end

	return id
end

return SpawnQueue
