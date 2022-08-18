local MinionSpawnerQueue = class("MinionSpawnerQueue")

MinionSpawnerQueue.init = function (self)
	self._queue = {}
	self._queue_id = 1
end

local function _queue_index_from_id(queue, queue_id)
	for i = 1, #queue, 1 do
		if queue[i].queue_id == queue_id then
			return i
		end
	end

	return nil
end

MinionSpawnerQueue.enqueue = function (self, breed_list, spawn_data)
	local queue_id = self._queue_id
	self._queue_id = queue_id + 1
	local queue = self._queue
	queue[#queue + 1] = {
		breed_list_index = 1,
		queue_id = queue_id,
		breed_list = breed_list,
		breed_list_size = #breed_list,
		spawn_data = table.set_readonly(spawn_data)
	}

	return queue_id
end

MinionSpawnerQueue.dequeue = function (self)
	local queue = self._queue
	local head_item = queue[1]

	if not head_item then
		return nil, nil, nil
	end

	local breed_list = head_item.breed_list
	local breed_list_index = head_item.breed_list_index
	local breed_list_size = head_item.breed_list_size
	local spawn_data = head_item.spawn_data
	local queue_id = head_item.queue_id
	local breed = breed_list[breed_list_index]

	if breed_list_index == breed_list_size then
		table.remove(queue, 1)
	else
		head_item.breed_list_index = breed_list_index + 1
	end

	return breed, spawn_data, queue_id
end

MinionSpawnerQueue.remove = function (self, queue_id)
	local queue = self._queue
	local queue_index = _queue_index_from_id(queue, queue_id)

	if queue_index then
		table.remove(queue, queue_index)
	end
end

MinionSpawnerQueue.clear = function (self)
	table.clear(self._queue)
end

MinionSpawnerQueue.is_empty = function (self)
	return #self._queue == 0
end

local debug_info = {}

MinionSpawnerQueue.get_debug_info = function (self)
	table.clear(debug_info)

	local queue = self._queue

	for i = 1, #queue, 1 do
		local item = queue[i]
		local queue_id = item.queue_id
		local breed_list = item.breed_list
		local spawn_data = item.spawn_data

		for j = item.breed_list_index, item.breed_list_size, 1 do
			local breed = breed_list[j]
			debug_info[#debug_info + 1] = {
				queue_id = queue_id,
				breed = breed,
				spawn_data = spawn_data
			}
		end
	end

	return debug_info
end

return MinionSpawnerQueue
