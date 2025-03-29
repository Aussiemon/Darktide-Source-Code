-- chunkname: @scripts/loading/spawn_queue_hub.lua

local SpawnQueueInterface = require("scripts/loading/spawn_queue_interface")
local SpawnQueueHub = class("SpawnQueueHub")

SpawnQueueHub.init = function (self, group_delay)
	self._delay = group_delay
	self._waiting = {}
	self._spawning = {}
	self._waiting_age = 0
	self._group_id_type_info = Network.type_info("spawn_group")
	self._group_id_counter = self._group_id_type_info.min
end

SpawnQueueHub.reset = function (self)
	table.clear(self._waiting)
	table.clear(self._spawning)

	self._waiting_age = 0
end

SpawnQueueHub.place_in_queue = function (self, peer_id, callback)
	if table.is_empty(self._waiting) then
		self._waiting_age = 0
	end

	self._waiting[peer_id] = callback
end

SpawnQueueHub.remove_from_queue = function (self, peer_id)
	self._waiting[peer_id] = nil
	self._spawning[peer_id] = nil
end

SpawnQueueHub.ready_group = function (self)
	if self._waiting_age < self._delay or table.size(self._waiting) == 0 then
		return nil
	end

	return self:_generate_group_id()
end

SpawnQueueHub.trigger_group = function (self, group_id)
	local peer_id, callback = next(self._waiting)

	self._waiting[peer_id] = nil
	self._spawning[peer_id] = group_id

	callback(group_id)

	return {
		peer_id,
	}
end

SpawnQueueHub.retire_group = function (self, group_id)
	for peer_id, spawning_group_id in pairs(self._spawning) do
		if spawning_group_id == group_id then
			self._spawning[peer_id] = nil

			return
		end
	end
end

SpawnQueueHub.set_delay_time = function (self, group_delay)
	self._delay = group_delay
end

SpawnQueueHub.update = function (self, dt)
	if table.is_empty(self._waiting) then
		return
	end

	self._waiting_age = self._waiting_age + dt
end

SpawnQueueHub._generate_group_id = function (self)
	local id = self._group_id_counter

	self._group_id_counter = self._group_id_counter + 1

	if self._group_id_counter > self._group_id_type_info.max then
		self._group_id_counter = self._group_id_type_info.min
	end

	return id
end

implements(SpawnQueueHub, SpawnQueueInterface)

return SpawnQueueHub
