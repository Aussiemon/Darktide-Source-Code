local ScriptGui = require("scripts/foundation/utilities/script_gui")
local PlayerInputStreamVisualizer = class("PlayerInputStreamVisualizer")
local BUFFER_BACKWARDS = 200
local BUFFER_SIZE = 256
local FRAMETIME_BUFFER_SIZE = 512

PlayerInputStreamVisualizer.init = function (self, player, peer_id)
	self._gui = Debug:debug_gui()
	local size = BUFFER_SIZE
	self._cache = Script.new_array(size)

	for i = 1, size do
		self._cache[i] = false
	end

	self._start_frame = nil
	self._end_frame = nil
	self._frame_time_buffer = Script.new_array(FRAMETIME_BUFFER_SIZE)
	self._frame_time_index = 0
	self._player = player
	self._peer_id = peer_id
end

PlayerInputStreamVisualizer._bounded_index = function (self, frame)
	if frame < self._start_frame then
		return self:_raw_index(self._start_frame), self._start_frame, -BUFFER_BACKWARDS - 1
	elseif self._end_frame < frame then
		return self:_raw_index(self._end_frame), self._end_frame, BUFFER_SIZE - 1 - BUFFER_BACKWARDS - 1
	end

	local offset = frame - self._start_frame - BUFFER_BACKWARDS - 1

	return self:_raw_index(frame), frame, offset
end

PlayerInputStreamVisualizer._raw_index = function (self, frame)
	return (frame - 1) % BUFFER_SIZE + 1
end

PlayerInputStreamVisualizer._write = function (self, cache, index, value)
	cache[index] = cache[index] or value
end

PlayerInputStreamVisualizer.frames_received = function (self, from, to)
	local index_from, from_in_range, offset = self:_bounded_index(from)
	local index_to, to_in_range, _ = self:_bounded_index(to)
	local cache = self._cache

	if from_in_range <= to and index_from <= to_in_range then
		if index_to < index_from then
			for i = index_from, BUFFER_SIZE do
				self:_write(cache, i, offset)

				offset = offset + 1
			end

			for i = 1, index_to do
				self:_write(cache, i, offset)

				offset = offset + 1
			end
		else
			for i = index_from, index_to do
				self:_write(cache, i, offset)

				offset = offset + 1
			end
		end
	end
end

PlayerInputStreamVisualizer.step_frame = function (self, frame)
	if not self._start_frame then
		self._start_frame = frame - 1 - BUFFER_BACKWARDS
		self._end_frame = frame - 1 + BUFFER_SIZE - BUFFER_BACKWARDS - 1
	end

	fassert(frame == self._start_frame + BUFFER_BACKWARDS + 1, "Trying to step more than one frame. old:%i, new:%i", self._start_frame + BUFFER_BACKWARDS, frame)

	local index = self:_raw_index(self._start_frame)
	self._cache[index] = false
	self._start_frame = self._start_frame + 1
	self._end_frame = self._end_frame + 1
end

PlayerInputStreamVisualizer._store_frame_time = function (self, dt)
	local index = self._frame_time_index % FRAMETIME_BUFFER_SIZE + 1
	self._frame_time_buffer[index] = dt
	self._frame_time_index = index
end

PlayerInputStreamVisualizer._draw_frame_time = function (self, gui, x_origo, y_origo, x_step, y_step, layer, size)
	local start_index = self._frame_time_index
	local index = start_index
	local buffer = self._frame_time_buffer
	local time = 0
	local color = Color.red()

	repeat
		local dt = buffer[index]
		local pos = Vector3(x_origo + time * x_step, y_origo + dt * y_step, layer)

		Gui.rect(gui, pos, size, color)

		time = time + dt
		index = (index - 2) % FRAMETIME_BUFFER_SIZE + 1
	until index == start_index or not buffer[index]

	local fps = #buffer / time
	local str = string.format("fps:%.1f dt:%.3f", fps, time / #buffer)

	ScriptGui.text(gui, str, DevParameters.debug_text_font, 12, Vector3(x_origo + 1, y_origo - 12, layer + 1), color, Color.black())
end

local TIME_INDICATORS = {
	-0.3,
	-0.2,
	-0.1,
	0,
	0.1,
	0.2,
	0.3
}

PlayerInputStreamVisualizer.draw = function (self, dt, index, server_clock_offset)
	self:_store_frame_time(dt)

	if not self._start_frame then
		return
	end

	local gui = self._gui
	local cache = self._cache
	local width = 5
	local height = 4
	local grid_height = 200
	local y_offset = 0 + (index - 1) * grid_height
	local y_0 = y_offset + grid_height * 0.5
	local layer = 500
	local late_color = Color.red()
	local in_time_color = Color.white()
	local frame_perfect_color = Color.yellow()
	local time_step = GameParameters.fixed_time_step

	for i = 1, BUFFER_SIZE do
		local cache_index = self:_raw_index(self._start_frame + i - 1)
		local value = cache[cache_index]

		if value then
			local pos, size, color = nil

			if value == 0 then
				pos = Vector3(i * width, y_0 - height * 0.5, layer)
				size = Vector2(width, height)
				color = frame_perfect_color
			else
				pos = Vector3(i * width, y_0, layer)
				size = Vector2(width, value * height)
				color = value < 0 and late_color or in_time_color
			end

			Gui.rect(gui, pos, size, color)
		elseif i < BUFFER_BACKWARDS then
			local pos = Vector3(i * width + math.floor(width * 0.5), y_offset, layer)
			local size = Vector2(1, (y_0 - y_offset) * 2)

			Gui.rect(gui, pos, size, late_color)
		end
	end

	local x_0 = BUFFER_BACKWARDS * width + math.floor(width * 0.5)
	local pos = Vector3(x_0, y_offset, layer)

	Gui.rect(gui, pos, Vector2(1, (y_0 - y_offset) * 2), Color.black())

	local num_frames = server_clock_offset / time_step
	local x = x_0 + num_frames * width
	local y = y_0
	local layer = layer + 1

	Gui.rect(gui, Vector3(x, y, layer), Vector2(1, 5), Color.red())
	ScriptGui.text(gui, "Name: " .. self._player:name(), DevParameters.debug_text_font, 12, Vector3(x_0, y + 15, layer), Color.red(), Color.black())
	ScriptGui.text(gui, "Peer id: " .. self._peer_id, DevParameters.debug_text_font, 12, Vector3(x_0, y + 30, layer), Color.red(), Color.black())
	ScriptGui.text(gui, string.format("Average ping: %ims", Network.ping(self._peer_id) * 1000), DevParameters.debug_text_font, 12, Vector3(x_0, y + 45, layer), Color.red(), Color.black())

	local str = string.format("Clock offset: %ims", server_clock_offset * 1000)

	ScriptGui.text(gui, str, DevParameters.debug_text_font, 12, Vector3(x_0, y + 60, layer), Color.red(), Color.black())

	if DevParameters.visualize_input_packets_with_ping then
		local x_step = -width / time_step
		local y_step = height / time_step
		local box_size = Vector2(width * 0.5, height * 0.5)

		self:_draw_frame_time(gui, x_0, y_0, x_step, y_step, layer + 1, box_size)
	end

	local frame_lines_color = Color.black(25)

	for i = -25, 25 do
		local pos = Vector3(0, y_0 + i * height, layer)
		local size = Vector2(BUFFER_SIZE * width, 1)

		Gui.rect(gui, pos, size, frame_lines_color)
	end

	local time_indicators_color = Color.dim_gray(125)

	for i = 1, #TIME_INDICATORS do
		local ms = TIME_INDICATORS[i]
		local pos = Vector3(0, math.floor(y_0 + ms * height / time_step), layer)
		local size = Vector2(BUFFER_SIZE * width, 1)

		Gui.rect(gui, pos, size, time_indicators_color)
	end

	local alpha = 100
	local buffer_max_size = 32768
	local buffer_size = Network.reliable_send_buffer_left(self._peer_id)
	local w, h = Gui.resolution()
	local x_size = math.min(500, w - 4 - x_0)
	local y_size = 50
	local pos = Vector3(x_0 + 2, y_0 - 20 - y_size, layer + 2)
	local t_val = buffer_size / buffer_max_size
	local size = Vector2(x_size * (1 - t_val), y_size)
	local color = Color(alpha, 255 * (1 - t_val), 255 * t_val, 0)

	Gui.rect(gui, pos, size, color)
	Gui.rect(gui, pos - Vector3(1, 1, 1), Vector2(x_size + 2, y_size), Color.citadel_dawnstone(alpha))

	local font_size = 12

	Gui.slug_text(gui, "Reliable send buffer", DevParameters.debug_text_font, font_size, pos - Vector3(0, font_size, 0), nil, Color.red(), "shadow", Color.black())
end

return PlayerInputStreamVisualizer
