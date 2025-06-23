-- chunkname: @scripts/extension_systems/behavior/utilities/draw_ai_behavior_placeholder.lua

local ScriptGui = require("scripts/foundation/utilities/script_gui")
local Utility = require("scripts/extension_systems/behavior/utilities/utility")
local SMALL_FONT_SIZE = 16
local FONT_SIZE = 26
local LAYER = 100
local RES_X, RES_Y = Application.back_buffer_size()
local NODE_HEIGHT = 0.04
local MIN_NODE_WIDTH = 160 / RES_X
local NODE_SPACING = RES_X * 1e-05
local TEXT_SPACING = 2 / RES_X
local THIN_BORDER = 5 / RES_X
local THICK_BORDER = 15 / RES_X
local FADE_TIME = 3
local state_counter = 1
local draw_timers = {}
local nodes = {}
local row_heights = {
	NODE_HEIGHT
}
local ROW_SPACING = NODE_HEIGHT * 0.5
local BORDER_SPACING = NODE_HEIGHT

DrawAiBehavior = DrawAiBehavior or {}

local DrawAiBehavior = DrawAiBehavior

DrawAiBehavior.winning_utility_value = 0
DrawAiBehavior.circle_array = {}
DrawAiBehavior.circle_array_index = 0
DrawAiBehavior.circle_max_size = 12

local function reset_circle_array()
	DrawAiBehavior.circle_array_index = 0

	table.clear(DrawAiBehavior.circle_array)

	state_counter = 1
end

local function add_item_to_circle_array(item)
	DrawAiBehavior.circle_array_index = DrawAiBehavior.circle_array_index % DrawAiBehavior.circle_max_size + 1
	DrawAiBehavior.circle_array[DrawAiBehavior.circle_array_index] = item
end

local function present_circle_array(gui, x, y)
	local a = DrawAiBehavior.circle_array
	local index = DrawAiBehavior.circle_array_index
	local max_items = DrawAiBehavior.circle_max_size
	local num_items = #a
	local x1, y1 = x, y

	ScriptGui.icrect(gui, RES_X, RES_Y, x1 - 5, y1, x1 + 300, y1 + num_items * FONT_SIZE + 10, LAYER, Color(100, 100, 100, 150))

	for i = 1, num_items do
		local text = a[index]

		ScriptGui.ictext(gui, RES_X, RES_Y, text, DevParameters.debug_text_font, FONT_SIZE, x1, y1 + FONT_SIZE * (i - 1), 400, Color(255, 220, 120))

		index = (index - 2) % max_items + 1
	end
end

local function update_node_history(blackboard, running_node, current_identifier)
	if DrawAiBehavior.last_blackboard ~= blackboard then
		DrawAiBehavior.last_blackboard = blackboard
		DrawAiBehavior.last_running_node = nil
		DrawAiBehavior.running_node_switch = true

		reset_circle_array()
	end

	if DrawAiBehavior.last_running_node ~= running_node then
		DrawAiBehavior.last_running_node = running_node
		DrawAiBehavior.running_node_switch = true

		add_item_to_circle_array(state_counter .. " " .. current_identifier)

		state_counter = state_counter + 1
	else
		DrawAiBehavior.running_node_switch = false
	end
end

local function draw_utility_info(gui, consideration_data, temp_max_value, name, pos, size, fade_factor, font_size, font_mtrl)
	local scale_text = temp_max_value or consideration_data.max_value or ""
	local scale_min, scale_max, caret = Gui.text_extents(gui, scale_text, font_mtrl, font_size)
	local scale_extents = Vector2(scale_max.x - scale_min.x, scale_max.y - scale_min.y)
	local axis_y = size.y
	local min, max, caret = Gui.text_extents(gui, name, font_mtrl, font_size)
	local offset_x = math.min(0, size.x - (max.x + scale_extents.x))
	local scale_text_pos = pos + Vector3(size.x - scale_max.x, axis_y, 10)

	if temp_max_value then
		local scale_text_pos2 = scale_text_pos + Vector3(2, -1, -1)

		ScriptGui.text(gui, scale_text, font_mtrl, font_size, scale_text_pos2, temp_max_value and Color(255, 0, 0, 0))
	end

	ScriptGui.text(gui, scale_text, font_mtrl, font_size, scale_text_pos, temp_max_value and Color(255 * fade_factor, 240, 200, 10) or Color(255 * fade_factor, 255, 255, 255))
	ScriptGui.text(gui, name, font_mtrl, font_size, pos + Vector3(offset_x, axis_y, 10), Color(255 * fade_factor, 255, 255, 255))
end

local function draw_utility_condition(gui, action_name, consideration, pos, win_size, blackboard, utility_data, bk_color)
	local component_name = consideration.blackboard_component
	local field_name = consideration.component_field
	local value

	if component_name then
		local component = blackboard[component_name]

		value = component[field_name]
	else
		value = utility_data[field_name]
	end

	local is_inverted = consideration.invert

	if is_inverted then
		value = not value
	end

	local result = value and "true" or "false"
	local x = pos.x + win_size.x / 2 - 24
	local y = pos.y + win_size.y / 2 - 6
	local color = value and Color(255, 240, 200, 10) or Color(255, 255, 255)
	local text = result

	ScriptGui.text(gui, text, DevParameters.debug_text_font, 16, Vector3(x, y, pos.z + 1), color)
	Gui.rect(gui, pos, win_size, bk_color)
end

local function draw_utility_spline(gui, t, consideration_data, temp_max_value, name, pos, size, bk_color, fade_factor, thickness)
	local spline = consideration_data.spline
	local w = size.x
	local h = size.y
	local line_color = Color(255 * fade_factor, 255, 255, 255)

	thickness = thickness or 5

	for i = 1, #spline - 2, 2 do
		local x1 = pos.x + w * spline[i]
		local y1 = pos.y + h * (1 - spline[i + 1])
		local x2 = pos.x + w * spline[i + 2]
		local y2 = pos.y + h * (1 - spline[i + 3])

		ScriptGui.hud_line(gui, Vector2(x1, y1), Vector2(x2, y2), nil, thickness, line_color)
	end

	Gui.rect(gui, pos, size, bk_color)
end

local function draw_square(gui, t, pos, width, color, thickness)
	thickness = thickness or 5
	width = width * 0.5

	local x1 = pos.x - width
	local y1 = pos.y - width
	local x2 = pos.x + width
	local y2 = pos.y + width

	ScriptGui.hud_line(gui, Vector2(x1, y1), Vector2(x2, y1), nil, thickness, color)
	ScriptGui.hud_line(gui, Vector2(x2, y1), Vector2(x2, y2), nil, thickness, color)
	ScriptGui.hud_line(gui, Vector2(x2, y2), Vector2(x1, y2), nil, thickness, color)
	ScriptGui.hud_line(gui, Vector2(x1, y2), Vector2(x1, y1), nil, thickness, color)
end

local function get_utility_from_spline(spline, x)
	for i = 3, #spline, 2 do
		local x2 = spline[i]

		if x <= x2 then
			local x1 = spline[i - 2]
			local y1 = spline[i - 1]
			local y2 = spline[i + 1]
			local m = (y2 - y1) / (x2 - x1)
			local y = y1 + m * (x - x1)

			return y
		end
	end

	return spline[#spline]
end

local function draw_realtime_utility(gui, action_name, consideration, pos, win_size, blackboard, utility_data, t)
	local value
	local component_name = consideration.blackboard_component
	local field_name = consideration.component_field

	if component_name then
		local component = blackboard[component_name]

		value = component[field_name]
	else
		value = utility_data[field_name]
	end

	local current_value = consideration.time_diff and t - value or value
	local min_value = consideration.min_value or 0
	local max_value = consideration.max_value
	local normalized_value = math.clamp((current_value - min_value) / (max_value - min_value), 0, 1)
	local x = pos.x + win_size.x * normalized_value
	local y1 = pos.y
	local y2 = pos.y + win_size.y
	local yellow = Color(255, 240, 200, 10)

	ScriptGui.hud_line(gui, Vector2(x, y1), Vector2(x, y2), pos.z, 1, yellow)

	local y = (1 - get_utility_from_spline(consideration.spline, normalized_value)) * win_size.y + y1

	draw_square(gui, 0, Vector3(x, y, pos.z + 1), 14, yellow, 4)

	local text = string.format("%.1f", normalized_value * max_value)

	ScriptGui.text(gui, text, DevParameters.debug_text_font, 16, Vector3(x + 10, y, pos.z + 1), yellow)

	return y
end

local function draw_utility_nodes(gui, blackboard, utility_data, running, action_data, text, considerations, x1, y1, extra_height, t)
	local yellow = Color(255, 240, 200, 10)
	local size = Vector2(160, 100)
	local step_y = size.y + 40
	local pos_y = 40
	local pos = Vector3(x1 * RES_X, (y1 + NODE_HEIGHT - extra_height) * RES_Y, LAYER + 10)
	local num = 0

	for name, consideration_data in pairs(considerations) do
		if type(consideration_data) == "table" then
			local npos = pos + Vector3(0, pos_y, 0)

			draw_utility_info(gui, consideration_data, nil, name, npos, size, 1, 16, DevParameters.debug_text_font)

			if consideration_data.is_condition then
				draw_utility_condition(gui, text, consideration_data, npos, size, blackboard, utility_data, Color(92, 28, 128, 44))
			else
				draw_utility_spline(gui, t, consideration_data, nil, name, npos, size, Color(92, 28, 128, 44), 1, 2)
				draw_realtime_utility(gui, text, consideration_data, npos, size, blackboard, utility_data, t)
			end

			pos_y = pos_y + step_y
			num = num + 1
		end
	end

	local utility = Utility.get_action_utility(action_data, blackboard, t, utility_data)

	if running and DrawAiBehavior.running_node_switch then
		DrawAiBehavior.winning_utility_value = utility
	end

	local sum_text

	if running then
		sum_text = string.format("sum: %.1f, (%.1f)", utility, DrawAiBehavior.winning_utility_value)
	else
		sum_text = string.format("sum: %.1f", utility)
	end

	ScriptGui.text(gui, sum_text, DevParameters.debug_text_font, SMALL_FONT_SIZE, pos + Vector3(0, 40 - SMALL_FONT_SIZE * 1.5, 0), yellow)

	local extra_utility_height = num * 0.1

	return extra_utility_height
end

local function draw_hook_box(gui, node, node_width, extra_height, header_text, hook_id, x1, bottom_y, box_color)
	local text_height = SMALL_FONT_SIZE / RES_Y
	local start_y = bottom_y
	local pos_x = x1
	local hook_name = hook_id

	if type(hook_id) == "table" then
		hook_name = hook_id.hook
	end

	bottom_y = start_y

	ScriptGui.itext(gui, RES_X, RES_Y, header_text, DevParameters.debug_text_font, SMALL_FONT_SIZE, pos_x, bottom_y, LAYER + 11, Color(255, 255, 255, 255))

	bottom_y = bottom_y + text_height

	ScriptGui.itext(gui, RES_X, RES_Y, hook_name, DevParameters.debug_text_font, SMALL_FONT_SIZE, pos_x, bottom_y, LAYER + 11, Color(255, 255, 255, 255))

	bottom_y = bottom_y + text_height + THICK_BORDER

	ScriptGui.irect(gui, RES_X, RES_Y, pos_x, start_y, pos_x + node_width, bottom_y, LAYER + 10, box_color)

	local box_height = bottom_y - start_y

	return bottom_y, box_height
end

local function draw_node(gui, node, text, running, x1, y1, node_width, extra_height, dt, tcolor)
	local color

	if running then
		color = Color(200, 242, 152, 7)

		if draw_timers[node] ~= FADE_TIME then
			for id, timer in pairs(draw_timers) do
				draw_timers[id] = timer * 0.9
			end

			draw_timers[node] = FADE_TIME
		end
	else
		local green = 60
		local timer = draw_timers[node]

		if timer then
			timer = timer - dt

			if timer <= 0 then
				draw_timers[node] = nil
			else
				green = math.lerp(60, 255, timer / FADE_TIME)
				draw_timers[node] = timer
			end
		end

		if node._children then
			color = Color(200, 130, 170, green)
		else
			color = Color(200, 30, 170, green)
		end
	end

	local identifier = node.identifier
	local last_identifier = DrawAiBehavior.last_running_node

	if identifier == last_identifier then
		ScriptGui.irect(gui, RES_X, RES_Y, x1 - THIN_BORDER, y1 - THIN_BORDER, x1 + node_width + THIN_BORDER, y1 + NODE_HEIGHT + extra_height + THIN_BORDER, LAYER - 1, Color(255, 242, 152, 7))
	end

	ScriptGui.itext(gui, RES_X, RES_Y, node.__class_name, DevParameters.debug_text_font, SMALL_FONT_SIZE, x1 + TEXT_SPACING, y1, LAYER + 1, tcolor)

	local bottom_y, box_height = y1 + NODE_HEIGHT + extra_height

	ScriptGui.irect(gui, RES_X, RES_Y, x1, y1, x1 + node_width, bottom_y, LAYER, color)
	ScriptGui.itext(gui, RES_X, RES_Y, text, DevParameters.debug_text_font, FONT_SIZE, x1 + TEXT_SPACING, y1 + NODE_HEIGHT * 0.15, LAYER + 1, tcolor)

	local enter_hook = node.tree_node.enter_hook

	if enter_hook then
		bottom_y, box_height = draw_hook_box(gui, node, node_width, extra_height, "ENTER_HOOK:", enter_hook, x1, bottom_y, Color(200, 100, 100, 150))
		extra_height = extra_height + box_height
	end

	local leave_hook = node.tree_node.leave_hook

	if leave_hook then
		bottom_y, box_height = draw_hook_box(gui, node, node_width, extra_height, "LEAVE_HOOK:", leave_hook, x1, bottom_y, Color(200, 150, 100, 150))
		extra_height = extra_height + box_height
	end

	return extra_height
end

local function draw_node_children(bt, gui, node, node_children, blackboard, running_node, row, x1, y1, node_width, extra_node_height, total_width, extra_utility_height, t, dt, node_data)
	local row_height = row_heights[row] or 0
	local child_y = y1 + row_height + ROW_SPACING
	local start_x, start_y

	if node.__class_name == "BtSequenceNode" then
		start_x = x1
		start_y = child_y + extra_utility_height
	else
		start_x = x1 - total_width * 0.5 + node_width * 0.5
		start_y = child_y
	end

	local cx, cy = start_x, start_y
	local next_row = row + 1
	local draw_utility = node.__class_name == "BtRandomUtilityNode"
	local line_color_normal = Color(150, 100, 255, 100)
	local line_color_sequence = Color(150, 100, 50, 200)
	local line_layer = LAYER - 1
	local line_x = x1 + node_width * 0.5
	local line_y1 = y1 + NODE_HEIGHT
	local line_width_sequence = 6
	local line_width_normal = 2
	local max_child_extra_total_width = 0
	local max_child_width = 0
	local max_child_extra_height = 0
	local max_child_extra_total_height = 0

	for k, child in pairs(node_children) do
		local child_identifier = child.identifier
		local child_default_width = nodes[child_identifier].w
		local child_default_total_width = nodes[child_identifier].total_w or 0

		if node.__class_name ~= "BtSequenceNode" then
			cx = cx + child_default_total_width * 0.5
		end

		local child_extra_total_width, child_extra_total_height, child_extra_height, child_width = DrawAiBehavior.draw_tree(bt, gui, child, blackboard, running_node, next_row, dt, t, cx, cy, draw_utility, nil, node_data)

		max_child_extra_total_width = math.max(max_child_extra_total_width, child_extra_total_width)
		max_child_extra_height = math.max(max_child_extra_height, child_extra_height)
		max_child_width = math.max(max_child_width, child_width)
		max_child_extra_total_height = math.max(max_child_extra_total_height, child_extra_total_height)

		if node.__class_name == "BtSequenceNode" then
			local line_y2 = cy
			local p1 = Vector2(line_x, line_y1)
			local p2 = Vector2(line_x, line_y2)

			ScriptGui.hud_iline(gui, RES_X, RES_Y, p1, p2, line_layer, line_width_sequence, line_color_sequence)

			line_y1 = line_y2 + NODE_HEIGHT + child_extra_height
			cy = cy + NODE_HEIGHT * 1.5 + child_extra_height + child_extra_total_height
			line_width_sequence = line_width_normal
		else
			local p1 = Vector2(x1 + node_width * 0.5, y1 + NODE_HEIGHT)
			local p2 = Vector2(cx + child_default_width * 0.5, child_y)

			ScriptGui.hud_iline(gui, RES_X, RES_Y, p1, p2, line_layer, line_width_normal, line_color_normal)

			cx = cx + child_default_total_width * 0.5 + child_extra_total_width
			cx = cx + child_default_width + NODE_SPACING
		end
	end

	row_heights[next_row] = NODE_HEIGHT + max_child_extra_height

	local xb = 5 / RES_X
	local yb = 5 / RES_Y
	local ocolor = Color(70, 55, 155, 200)
	local bounding_box_x1 = start_x - xb
	local bounding_box_y1 = child_y - yb
	local bounding_box_x2, bounding_box_y2

	if node.__class_name == "BtSequenceNode" then
		bounding_box_x2 = start_x + max_child_width + xb
		bounding_box_y2 = cy + yb - NODE_HEIGHT * 0.5
		ocolor = Color(70, 150, 50, 200)
	else
		bounding_box_x2 = cx + xb - NODE_SPACING
		bounding_box_y2 = cy + NODE_HEIGHT + max_child_extra_height + yb
	end

	ScriptGui.irect(gui, RES_X, RES_Y, bounding_box_x1, bounding_box_y1, bounding_box_x2, bounding_box_y2, line_layer, ocolor)

	local total_extra_height

	if node.__class_name == "BtSequenceNode" then
		total_extra_height = cy - child_y
	else
		total_extra_height = cy - line_y1 + max_child_extra_total_height + NODE_HEIGHT
	end

	return max_child_extra_total_width, total_extra_height
end

DrawAiBehavior.tree_width = function (gui, node)
	local id = node.identifier
	local name = node.__class_name
	local id_min, id_max = Gui.text_extents(gui, id, DevParameters.debug_text_font, FONT_SIZE)
	local name_min, name_max = Gui.text_extents(gui, name, DevParameters.debug_text_font, SMALL_FONT_SIZE)
	local id_width = (id_max.x - id_min.x) / RES_X + TEXT_SPACING
	local name_width = (name_max.x - name_min.x) / RES_X + TEXT_SPACING
	local text_width = math.max(MIN_NODE_WIDTH, id_width, name_width)

	nodes[id] = {
		w = text_width
	}

	local node_children = node._children

	if node_children then
		local n, w = 0, 0

		for _, child in pairs(node_children) do
			local amount, width = DrawAiBehavior.tree_width(gui, child)

			n = n + amount

			if node.__class_name ~= "BtSequenceNode" then
				w = w + width
			end
		end

		nodes[id].total_w = w

		return n, w
	else
		return 1, text_width
	end
end

DrawAiBehavior.draw_tree = function (bt, gui, node, blackboard, running_node, row, dt, t, x, y, draw_utility, extra_info, node_data)
	local identifier = node.identifier
	local running = running_node == node

	if running then
		update_node_history(blackboard, running_node, identifier)
		present_circle_array(gui, 20, 400)
	end

	local nodes = nodes
	local node_width = nodes[identifier].w
	local total_width = nodes[identifier].total_w
	local x1 = x
	local y1 = y

	if row == 1 then
		y1 = y1 + BORDER_SPACING
	end

	local text = identifier
	local tcolor = Color(240, 255, 255, 255)
	local extra_height = 0
	local extra_utility_height = 0
	local tree_node = node.tree_node
	local action_data = tree_node and tree_node.action_data
	local considerations = action_data and action_data.considerations

	if draw_utility and tree_node and action_data and considerations then
		local utility_node_data = node_data[node.parent.identifier].utility_node_data
		local utility_data = utility_node_data[node.identifier]

		extra_utility_height = draw_utility_nodes(gui, blackboard, utility_data, running, action_data, text, considerations, x1, y1, extra_height, t)
	end

	extra_height = draw_node(gui, node, text, running, x1, y1, node_width, extra_height, dt, tcolor)

	local max_child_extra_width = 0
	local max_child_extra_height = 0
	local node_children = node._children

	if node_children then
		max_child_extra_width, max_child_extra_height = draw_node_children(bt, gui, node, node_children, blackboard, running_node, row, x1, y1, node_width, extra_height, total_width, extra_utility_height, t, dt, node_data)
	end

	local current_node_extra_width = node_width - nodes[identifier].w
	local extra_width = math.max(current_node_extra_width, max_child_extra_width)

	return extra_width, max_child_extra_height, extra_height, node_width
end

return DrawAiBehavior
