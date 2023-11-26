-- chunkname: @scripts/managers/pacing/utilities/debug_pacing_graph.lua

local ScriptGui = require("scripts/foundation/utilities/script_gui")
local DebugPacingGraph = class("DebugPacingGraph")

DebugPacingGraph.init = function (self, world, name, axis_names, position_x, position_y, graph_extents, width, height, frequency, num_value_segments)
	self._world = world
	self._gui = World.create_screen_gui(world, 0, 0, "immediate")
	self._name = name
	self._axis_names = axis_names
	self._position = Vector3Box(position_x, position_y, 0)
	self._graph_extents = graph_extents
	self._width = width
	self._height = height
	self._frequency = frequency
	self._update_time = 0
	self._num_value_segments = num_value_segments
	self._graph_entries = {}
end

DebugPacingGraph.destroy = function (self)
	World.destroy_gui(self._world, self._gui)
end

local MIN_X_EXTENT_INDEX = 1
local MAX_X_EXTENT_INDEX = 2
local MIN_Y_EXTENT_INDEX = 3
local MAX_Y_EXTENT_INDEX = 4

DebugPacingGraph.update = function (self, t, x_value, y_value, optional_annotation)
	if not optional_annotation and t < self._update_time then
		return
	end

	local max_x_extent = self._graph_extents[MAX_X_EXTENT_INDEX]
	local x_percent = math.min(x_value / max_x_extent, 1)
	local width = self._width
	local x = width * x_percent
	local max_y_extent = self._graph_extents[MAX_Y_EXTENT_INDEX]
	local y_percent = y_value / max_y_extent
	local height = self._height
	local y = -(height * y_percent)
	local origin_position = self._position:unbox()
	local new_graph_entry = {
		point = Vector3Box(origin_position + Vector3(x, y, 0)),
		annotation = optional_annotation
	}
	local graph_entries = self._graph_entries

	if x_percent >= 1 then
		for i = 2, #graph_entries do
			local point = graph_entries[i].point:unbox()
			local prev_graph_entry = graph_entries[i - 1]
			local prev_point = prev_graph_entry.point:unbox()

			prev_graph_entry.point:store(prev_point.x, point.y, 0)

			prev_graph_entry.annotation = graph_entries[i].annotation
			point.annotation = nil
		end

		graph_entries[#graph_entries] = new_graph_entry
	else
		graph_entries[#graph_entries + 1] = new_graph_entry
	end

	self._update_time = t + self._frequency
end

local AXIS_NAME_SIZE = 24
local SEGMENT_VALUE_SIZE = 12

DebugPacingGraph.draw = function (self, dt, t)
	local width = self._width
	local height = self._height
	local gui = self._gui
	local origin_position = self._position:unbox()
	local y_axis_end_position = origin_position - Vector3.forward() * height
	local x_axis_end_position = origin_position + Vector3.right() * width
	local x_axis_name = self._axis_names[1]
	local x_axis_name_position = x_axis_end_position

	ScriptGui.text(gui, x_axis_name, DevParameters.debug_text_font, AXIS_NAME_SIZE, x_axis_name_position - Vector3.forward() * AXIS_NAME_SIZE, Color.white(), Color.gray())

	local y_axis_name = self._axis_names[2]
	local y_axis_name_position = y_axis_end_position

	ScriptGui.text(gui, y_axis_name, DevParameters.debug_text_font, AXIS_NAME_SIZE, y_axis_name_position - Vector3.forward() * AXIS_NAME_SIZE, Color.white(), Color.gray())
	ScriptGui.hud_line(gui, origin_position, x_axis_end_position, 100, 1, Color.white())
	ScriptGui.hud_line(gui, origin_position, y_axis_end_position, 100, 1, Color.white())

	local num_value_segments = self._num_value_segments
	local max_x_extent = self._graph_extents[MAX_X_EXTENT_INDEX]
	local value_per_x_segment = math.floor(max_x_extent / num_value_segments)
	local width_per_segment = math.floor(width / num_value_segments)

	for i = 0, num_value_segments do
		local x = i * width_per_segment
		local segment_position = origin_position + Vector3(x, 0, 0)
		local offset_position = segment_position + Vector3(0, 20, 0)

		ScriptGui.hud_line(gui, segment_position, offset_position, 100, 4, Color.dark_gray())

		local value = i * value_per_x_segment
		local text_pos = offset_position - Vector3(0, 2, 0)

		ScriptGui.text(gui, value, DevParameters.debug_text_font, SEGMENT_VALUE_SIZE, text_pos, Color.white(), Color.gray())
	end

	local max_y_extent = self._graph_extents[MAX_Y_EXTENT_INDEX]
	local value_per_y_segment = math.floor(max_y_extent / num_value_segments)
	local height_per_segment = math.floor(height / num_value_segments)

	for i = 0, num_value_segments do
		local y = i * height_per_segment
		local segment_position = origin_position + Vector3(0, -y, 0)
		local offset_position = segment_position + Vector3(-20, 0, 0)

		ScriptGui.hud_line(gui, segment_position, offset_position, 100, 4, Color.dark_gray())

		local value = i * value_per_y_segment
		local text_pos = offset_position + Vector3(-2, 0, 0)

		ScriptGui.text(gui, value, DevParameters.debug_text_font, SEGMENT_VALUE_SIZE, text_pos, Color.white(), Color.gray())
	end

	local graph_entries = self._graph_entries

	for i = 1, #graph_entries do
		local graph_entry = graph_entries[i]
		local point = graph_entry.point:unbox()

		if i > 1 then
			local prev_point = graph_entries[i - 1].point:unbox()

			ScriptGui.hud_line(gui, point, prev_point, 100, 3, Color.white())
		end

		local point_layer = 200
		local size = Vector3(6, 6, 0)
		local position = point - size / 2

		position.z = point_layer

		local annotation = graph_entry.annotation

		Gui.rect(gui, position, size, annotation and Color.blue() or Color(255, 255, 0, 0))

		if annotation then
			ScriptGui.text(gui, annotation, DevParameters.debug_text_font, SEGMENT_VALUE_SIZE, position + Vector3.forward() * 10, Color.yellow(), Color.black())
		end
	end
end

return DebugPacingGraph
