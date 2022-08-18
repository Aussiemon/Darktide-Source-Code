local FrameTableManager = class("FrameTableManager")

FrameTableManager.init = function (self, debug_enabled, buffer_size)
	self._current_buffer = Script.new_array(buffer_size)
	self._old_buffer = Script.new_array(buffer_size)
	self._current_counter = 0
	self._old_counter = 0
	self._buffer_size = buffer_size

	for i = 1, buffer_size, 1 do
		self._current_buffer[i] = {}
		self._old_buffer[i] = {}
	end

	self._debug = debug_enabled

	if self._debug then
		self._current_buffer.__callstacks = {}
		self._old_buffer.__callstacks = {}
	end
end

FrameTableManager.get_table = function (self)
	local new_table_index = self._current_counter + 1
	local buffer_size = self._buffer_size

	if buffer_size < new_table_index then
		Log.exception("FrameTableManager", "Requested more than %i tables the same frame.", buffer_size)

		buffer_size = buffer_size * 2

		for i = new_table_index, buffer_size, 1 do
			self._current_buffer[i] = {}
			self._old_buffer[i] = {}
		end

		self._buffer_size = buffer_size
	end

	self._current_counter = new_table_index

	return self._current_buffer[new_table_index]
end

local function _clear_buffer(buffer, counter, debug)
	for i = 1, counter, 1 do
		local t = buffer[i]

		for k, _ in pairs(t) do
			t[k] = nil
		end
	end
end

FrameTableManager.swap_buffers = function (self)
	local current = self._old_buffer

	_clear_buffer(current, self._old_counter, self._debug)

	self._old_counter = self._current_counter
	self._old_buffer = self._current_buffer
	self._current_buffer = current
	self._current_counter = 0
end

return FrameTableManager
