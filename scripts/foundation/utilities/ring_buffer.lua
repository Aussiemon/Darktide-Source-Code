require("scripts/foundation/utilities/table")

local RingBuffer = class("RingBuffer")

RingBuffer.init = function (self, max_length)
	self._buffer = {}
	self._max_length = max_length
	self._is_full = false
	self._head_index = 0
	self._tail_index = 0
end

RingBuffer.clear = function (self)
	table.clear(self._buffer)

	self._is_full = false
	self._head_index = 0
	self._tail_index = 0
end

RingBuffer.is_empty = function (self)
	return self._head_index == 0 and self._tail_index == 0
end

RingBuffer.is_full = function (self)
	return self._is_full
end

RingBuffer.capacity = function (self)
	return self._max_length
end

RingBuffer.size = function (self)
	local size = self._max_length

	if self:is_empty() then
		size = 0
	elseif not self:is_full() then
		local head_index = self._head_index + 1
		local tail_index = self._tail_index

		if tail_index < head_index then
			size = head_index - tail_index
		else
			size = size + head_index - tail_index
		end
	end

	return size
end

RingBuffer._advance_indices = function (self)
	local max_length = self._max_length
	local tail_index = self._tail_index
	local head_index = self._head_index
	head_index = head_index == max_length and 1 or head_index + 1
	local is_full = head_index == tail_index
	local first_element_added = tail_index == 0 and head_index == 1

	if is_full or first_element_added then
		if tail_index == max_length then
			tail_index = 1
		else
			tail_index = tail_index + 1
		end
	end

	self._is_full = is_full
	self._head_index = head_index
	self._tail_index = tail_index
end

RingBuffer._retreat_index = function (self)
	local tail_index = self._tail_index
	local head_index = self._head_index
	local max_length = self._max_length

	if tail_index == head_index then
		tail_index = 0
		head_index = 0
	elseif tail_index == max_length then
		tail_index = 1
	else
		tail_index = tail_index + 1
	end

	self._is_full = false
	self._tail_index = tail_index
	self._head_index = head_index
end

RingBuffer.push = function (self, data)
	self:_advance_indices()

	self._buffer[self._head_index] = data
end

RingBuffer.pop = function (self)
	local result = nil

	if not self:is_empty() then
		result = self._buffer[self._tail_index]

		self:_retreat_index()
	end

	return result
end

RingBuffer.head = function (self)
	return self._buffer[self._head_index]
end

RingBuffer.tail = function (self)
	return self._buffer[self._tail_index]
end

return RingBuffer
