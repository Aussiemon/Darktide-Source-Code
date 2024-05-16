-- chunkname: @scripts/foundation/utilities/priority_queue.lua

local PriorityQueue = class("PriorityQueue")

local function _get_left_child(index)
	return 2 * index
end

local function _get_right_child(index)
	return 2 * index + 1
end

local function _get_parent(index)
	return math.floor(index / 2)
end

PriorityQueue._swap = function (self, i, j)
	local keys, data = self._keys, self._data

	keys[i], keys[j] = keys[j], keys[i]
	data[i], data[j] = data[j], data[i]
end

PriorityQueue.init = function (self)
	self._size = 0
	self._keys = {}
	self._data = {}
end

PriorityQueue.peek = function (self)
	return self._keys[1], self._data[1]
end

PriorityQueue.size = function (self)
	return self._size
end

PriorityQueue.empty = function (self)
	return self:size() == 0
end

PriorityQueue.pop = function (self)
	local return_key, return_data = self:peek()

	self:_swap(1, self._size)

	self._keys[self._size], self._data[self._size] = nil
	self._size = self._size - 1

	local key, size = self._keys[1], self._size
	local index, child_index = 1, 2

	while child_index <= size do
		if size >= child_index + 1 and self._keys[child_index + 1] < self._keys[child_index] then
			child_index = child_index + 1
		end

		if not (key > self._keys[child_index]) then
			break
		end

		self:_swap(index, child_index)

		index, child_index = child_index, _get_left_child(child_index)
	end

	return return_key, return_data
end

PriorityQueue.push = function (self, key, data)
	self._size = self._size + 1

	local index = self._size

	self._keys[index], self._data[index] = key, data

	local parent_index = _get_parent(index)

	while parent_index > 0 and key < self._keys[parent_index] do
		self:_swap(index, parent_index)

		parent_index, index = _get_parent(parent_index), parent_index
	end
end

PriorityQueue.clear = function (self)
	self._size = 0

	table.clear(self._keys)
	table.clear(self._data)
end

return PriorityQueue
