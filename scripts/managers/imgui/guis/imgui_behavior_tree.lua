local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local ImguiBehaviorTree = class("ImguiBehaviorTree")

ImguiBehaviorTree.init = function (self)
	self._window_width = 1800
	self._window_height = 900
	self._show_graph_settings = false
	self._left_panel_width = 600
	self._scrolling = {
		x = 0,
		y = 0
	}
	self._grid_size = 64
	self._zoom = 1
	self._zoom_speed = 0.1
	self._use_node_width_padding_zoom = true
	self._use_node_height_padding_zoom = true
	self._node_padding = {
		x = 20,
		y = 5
	}
	self._node_inner_padding = {
		x = 5,
		y = 5
	}
	self._node_font_size = 13
	self._node_text_distance = 0
	self._original_font_size = Imgui.get_font_size()
	self._curve_in_offset = {
		x = -50,
		y = 0
	}
	self._curve_out_offset = {
		x = 50,
		y = 0
	}
	self._last_leaf_node_run = nil
	self._max_running_leaf_history = 5
	self._history_id = 1
	self._use_history_slider = false
	self._history_stack = {}
end

ImguiBehaviorTree.update = function (self, dt, t)
	Imgui.set_window_size(self._window_width, self._window_height, "once")

	local selected_unit = Debug.selected_unit
	local previous_selected_unit = Debug.selected_unit_previous_frame

	if selected_unit ~= previous_selected_unit then
		self:_clear_history()
	end

	local behavior_extension = ScriptUnit.has_extension(selected_unit, "behavior_system")

	if behavior_extension then
		local brain = behavior_extension:brain()
		local running_leaf_node = brain._running_leaf_node

		if running_leaf_node ~= self._last_leaf_node_run then
			local behavior_tree = brain:behavior_tree()
			local blackboard = BLACKBOARDS[selected_unit]

			self:_save_history(running_leaf_node, behavior_tree, blackboard)
		end
	end

	self:_update_history_slider()
	self:_update_left_panel()
	self:_update_grid()
end

ImguiBehaviorTree._clear_history = function (self)
	table.clear_array(self._history_stack, #self._history_stack)

	self._last_leaf_node_run = nil
	self._history_id = 1
end

ImguiBehaviorTree._save_history = function (self, running_leaf_node, behavior_tree, blackboard)
	local index = 1
	local node = running_leaf_node
	local running_hierarchy = {}

	while node ~= nil do
		running_hierarchy[index] = node
		node = node.parent
		index = index + 1
	end

	local new_history_entry = {
		behavior_tree = behavior_tree,
		running_hierarchy = running_hierarchy,
		blackboard_component_config = Blackboard.component_config(blackboard),
		blackboard_data = table.clone(blackboard.__data)
	}
	self._history_stack[#self._history_stack + 1] = new_history_entry
	self._last_leaf_node_run = running_leaf_node
end

ImguiBehaviorTree._update_history_slider = function (self)
	local history_stack = self._history_stack
	local history_stack_size = #history_stack

	Imgui.begin_child_window("History Slider", 500, 25, false)

	self._use_history_slider = Imgui.checkbox("Use History Slider", self._use_history_slider)

	Imgui.same_line(10)

	self._history_id = Imgui.slider_int("###History Slider", self._history_id, 1, history_stack_size)

	Imgui.end_child_window()

	if not self._use_history_slider and history_stack_size > 0 then
		self._history_id = history_stack_size
	end
end

local MIN_ZOOM = 0.1

ImguiBehaviorTree._update_left_panel = function (self)
	Imgui.begin_child_window("Left Panel", self._left_panel_width, 0, true)

	self._show_graph_settings = Imgui.checkbox("Show Settings", self._show_graph_settings)

	if self._show_graph_settings then
		self._left_panel_width = Imgui.input_int("Panel width", self._left_panel_width)
		self._zoom = math.max(Imgui.input_float("Zoom", self._zoom), MIN_ZOOM)
		self._zoom_speed = Imgui.input_float("Zoom speed", self._zoom_speed)
		self._use_node_width_padding_zoom = Imgui.checkbox("Use node width padding zoom", self._use_node_width_padding_zoom)
		self._use_node_height_padding_zoom = Imgui.checkbox("Use node height padding zoom", self._use_node_height_padding_zoom)
		self._max_running_leaf_history = Imgui.input_int("Max leaf node history", self._max_running_leaf_history)
		self._node_font_size = Imgui.input_int("Node font size", self._node_font_size)
		self._node_text_distance = Imgui.input_int("Node text distance", self._node_text_distance)
		self._node_padding.x, self._node_padding.y = Imgui.input_int_2("Node padding", self._node_padding.x, self._node_padding.y)
		self._node_inner_padding.x, self._node_inner_padding.y = Imgui.input_int_2("Node inner padding", self._node_inner_padding.x, self._node_inner_padding.y)
	end

	Imgui.text_colored("---------------------------------------------------------------------------------------", 255, 51, 204, 255)
	Imgui.text_colored("Leaf Node History:", 255, 51, 204, 255)
	Imgui.indent(10)

	local history_stack = self._history_stack
	local history_index = self._history_id

	for i = 1, self._max_running_leaf_history, 1 do
		local text = ""
		local history_entry = history_stack[history_index]

		if history_entry then
			local running_leaf_node = history_entry.running_hierarchy[1]
			text = running_leaf_node.identifier
			history_index = history_index - 1
		end

		Imgui.text_colored(text, 250, 250, 250, 250)
	end

	Imgui.unindent(10)
	Imgui.text_colored("---------------------------------------------------------------------------------------", 255, 51, 204, 255)
	Imgui.text_colored("Blackboard:", 255, 51, 204, 255)

	local history_stack_size = #history_stack

	if history_stack_size > 0 then
		local selected_history = history_stack[self._history_id]

		self:_draw_blackboard_values(selected_history.blackboard_data, selected_history.blackboard_component_config)
	end

	Imgui.end_child_window()
end

local TEMP_COMPONENT_KEYS = {}
local TEMP_FIELD_KEYS = {}

ImguiBehaviorTree._draw_blackboard_values = function (self, data, config)
	for component_name, fields in table.sorted(config, TEMP_COMPONENT_KEYS) do
		Imgui.text_colored(component_name, 255, 153, 102, 255)
		Imgui.indent(10)

		local component_data = data[component_name]

		for field_name, field_type in table.sorted(fields, TEMP_FIELD_KEYS) do
			local value = component_data[field_name]
			local value_text = nil

			if field_type == "Vector3Box" then
				value_text = string.format("%s : X: %.2f Y: %.2f Z %.2f", field_name, value.x, value.y, value.z)
			else
				value_text = string.format("%s : %s", field_name, tostring(value))
			end

			Imgui.text(value_text)
		end

		Imgui.unindent(10)
		table.clear_array(TEMP_FIELD_KEYS, #TEMP_FIELD_KEYS)
	end

	table.clear_array(TEMP_COMPONENT_KEYS, #TEMP_COMPONENT_KEYS)
end

ImguiBehaviorTree._update_grid = function (self)
	Imgui.same_line(10)
	Imgui.begin_child_window("Grid", 0, 0, true)
	Imgui.channel_split(2)

	local window_pos_x, window_pos_y = Imgui.get_window_pos()
	local window_width, window_height = Imgui.get_window_size()

	self:_draw_grid(window_pos_x, window_pos_y, window_width, window_height)

	local history_stack = self._history_stack

	if #history_stack > 0 then
		local selected_history = history_stack[self._history_id]
		local behavior_tree = selected_history.behavior_tree
		local running_hierarchy = selected_history.running_hierarchy

		self:_draw_behavior_tree(window_pos_x, window_pos_y, behavior_tree, running_hierarchy)
	end

	if Imgui.is_window_hovered() then
		if Imgui.is_mouse_dragging(2, 0) then
			local delta_x, delta_y = Imgui.get_mouse_delta()
			self._scrolling.x = self._scrolling.x + delta_x
			self._scrolling.y = self._scrolling.y + delta_y
		end

		local mouse_wheel = Imgui.get_mouse_wheel_value()

		if mouse_wheel ~= 0 then
			local new_zoom = self._zoom + mouse_wheel * self._zoom_speed
			self._zoom = math.max(new_zoom, MIN_ZOOM)
		end
	end

	Imgui.channels_merge()
	Imgui.end_child_window()
end

ImguiBehaviorTree._draw_grid = function (self, position_x, position_y, width, height)
	local grid_color = Color(255, 100, 100, 100)
	local grid_thickness = 1
	local scrolling = self._scrolling
	local grid_size_zoomed = self._grid_size * self._zoom
	local column_y_start = position_y
	local column_y_end = position_y + height
	local temp_x_grid = scrolling.x % grid_size_zoomed

	while width > temp_x_grid do
		local column_x = position_x + temp_x_grid

		Imgui.add_line(column_x, column_y_start, column_x, column_y_end, grid_color, grid_thickness)

		temp_x_grid = temp_x_grid + grid_size_zoomed
	end

	local row_x_start = position_x
	local row_x_end = width + position_x
	local temp_y_grid = scrolling.y % grid_size_zoomed

	while height > temp_y_grid do
		local row_y = position_y + temp_y_grid

		Imgui.add_line(row_x_start, row_y, row_x_end, row_y, grid_color, grid_thickness)

		temp_y_grid = temp_y_grid + grid_size_zoomed
	end
end

local TEMP_FORMATTING_CONFIG = {}

ImguiBehaviorTree._draw_behavior_tree = function (self, position_x, position_y, behavior_tree, running_hierarchy)
	local zoom = self._zoom
	local font_size = self._node_font_size * zoom
	local font_scale = font_size / self._original_font_size

	Imgui.set_window_font_scale(font_scale)

	local node_padding_x = self._node_padding.x
	local node_padding_y = self._node_padding.y
	local curve_out_offset = self._curve_out_offset
	local curve_in_offset = self._curve_in_offset
	TEMP_FORMATTING_CONFIG.font_size = font_size
	TEMP_FORMATTING_CONFIG.text_distance = self._node_text_distance * zoom
	TEMP_FORMATTING_CONFIG.width_padding = (self._use_node_width_padding_zoom and node_padding_x * zoom) or node_padding_x
	TEMP_FORMATTING_CONFIG.height_padding = (self._use_node_height_padding_zoom and node_padding_y * zoom) or node_padding_y
	TEMP_FORMATTING_CONFIG.curve_out_offset_x = curve_out_offset.x * zoom
	TEMP_FORMATTING_CONFIG.curve_out_offset_y = curve_out_offset.y * zoom
	TEMP_FORMATTING_CONFIG.curve_in_offset_x = curve_in_offset.x * zoom
	TEMP_FORMATTING_CONFIG.curve_in_offset_y = curve_in_offset.y * zoom
	local root_node = behavior_tree:root()
	local node_start_x = position_x + self._scrolling.x
	local node_start_y = position_y + self._scrolling.y

	self:_draw_nodes(root_node, running_hierarchy, node_start_x, node_start_y, TEMP_FORMATTING_CONFIG)
end

ImguiBehaviorTree._draw_nodes = function (self, node, running_hierarchy, x, y, formatting_config, link_out_x, link_out_y)
	local node_width, node_height, new_link_out_x, new_link_out_y = self:_draw_node(node, running_hierarchy, x, y, formatting_config, link_out_x, link_out_y)
	local children = node._children

	if children then
		x = x + node_width + formatting_config.width_padding
		local iterator_func = (#children > 0 and ipairs) or pairs

		for _, child_node in iterator_func(children) do
			y = self:_draw_nodes(child_node, running_hierarchy, x, y, formatting_config, new_link_out_x, new_link_out_y)
		end
	else
		y = y + node_height + formatting_config.height_padding
	end

	return y
end

ImguiBehaviorTree._draw_node = function (self, node, running_hierarchy, x, y, formatting_config, link_out_x, link_out_y)
	local node_class_text_color = Color(500, 255, 255, 255)
	local node_name_text_color = Color(255, 0, 0, 0)
	local node_condition_text_color = Color(255, 0, 0, 200)
	local node_color = Color(255, 100, 100, 100)
	local node_outline_color = Color(255, 255, 255, 255)
	local line_color = Color(255, 255, 255, 255)
	local running_node_color = Color(255, 240, 130, 10)
	local line_thickness = 1
	local node_outline_thickness = 1
	local node_rounding_radius = 5

	if table.array_contains(running_hierarchy, node) then
		line_thickness = 4
		line_color = running_node_color
		node_color = running_node_color
	end

	local class_name = node.__class_name
	local node_name = node.identifier
	local condition_name = node.condition_name
	local text_distance = formatting_config.text_distance
	local text_width, text_height, class_name_height, node_name_height, _ = self:_calculate_node_text_extents(class_name, node_name, condition_name, text_distance)
	local txt_start_x = x
	local txt_start_y = y
	local txt_end_x = txt_start_x + text_width
	local txt_end_y = txt_start_y + text_height
	local node_inner_padding_x = self._node_inner_padding.x
	local node_inner_padding_y = self._node_inner_padding.y
	local rect_start_x = txt_start_x - node_inner_padding_x
	local rect_start_y = txt_start_y - node_inner_padding_y
	local rect_end_x = txt_end_x + node_inner_padding_x
	local rect_end_y = txt_end_y + node_inner_padding_y

	Imgui.channel_set_current(0)
	Imgui.add_rect_filled(rect_start_x, rect_start_y, rect_end_x, rect_end_y, node_color, node_rounding_radius)
	Imgui.add_rect(rect_start_x, rect_start_y, rect_end_x, rect_end_y, node_outline_color, node_rounding_radius, node_outline_thickness)
	Imgui.channel_set_current(1)

	local txt_y = txt_start_y
	local font_size = formatting_config.font_size

	Imgui.add_text(class_name, txt_start_x, txt_y, node_class_text_color, font_size)

	txt_y = txt_y + class_name_height + text_distance

	Imgui.add_text(node_name, txt_start_x, txt_y, node_name_text_color, font_size)

	txt_y = txt_y + node_name_height + text_distance

	Imgui.add_text(condition_name, txt_start_x, txt_y, node_condition_text_color, font_size)

	local node_height = rect_end_y - rect_start_y
	local link_in_y = rect_start_y + node_height * 0.5

	if link_out_x ~= nil then
		local link_in_x = rect_start_x
		local curve_out_offset_x = formatting_config.curve_out_offset_x
		local curve_out_offset_y = formatting_config.curve_out_offset_y
		local curve_in_offset_x = formatting_config.curve_in_offset_x
		local curve_in_offset_y = formatting_config.curve_in_offset_y

		Imgui.add_bezier_curve(link_out_x, link_out_y, link_in_x, link_in_y, curve_out_offset_x, curve_out_offset_y, curve_in_offset_x, curve_in_offset_y, line_color, line_thickness)
	end

	local node_width = rect_end_x - rect_start_x
	local next_link_out_x = rect_end_x
	local next_link_out_y = link_in_y

	return node_width, node_height, next_link_out_x, next_link_out_y
end

ImguiBehaviorTree._calculate_node_text_extents = function (self, class_name, node_name, condition_name, text_distance)
	local class_name_width, class_name_height = Imgui.calculate_text_size(class_name)
	local node_name_width, node_name_height = Imgui.calculate_text_size(node_name)
	local condition_name_width, condition_name_height = Imgui.calculate_text_size(condition_name)
	local node_width = math.max(class_name_width, node_name_width, condition_name_width)
	local node_height = class_name_height + node_name_height + condition_name_height + 2 * text_distance

	return node_width, node_height, class_name_height, node_name_height, condition_name_height
end

return ImguiBehaviorTree
