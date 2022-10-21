local UIWidget = require("scripts/managers/ui/ui_widget")
local Definitions = require("scripts/ui/view_elements/view_element_uniform_grid/view_element_uniform_grid_definitions")
local ViewElementUniformGrid = class("ViewElementUniformGrid", "ViewElementBase")
local GRID_AREA_SCENEGRAPH_ID = "grid_area"
local GRID_CELL_ID_FORMAT = "grid_cell_%i_%i"

ViewElementUniformGrid.init = function (self, parent, draw_layer, start_scale)
	self._num_cells = {
		0,
		0
	}
	self._cell_size = {
		0,
		0
	}
	self._grid_spacing = {
		0,
		0
	}
	self._focused_widget = nil
	self._last_navigation_direction = nil
	self._last_focused_widget = 0
	self._needs_grid_recalculation = false

	ViewElementUniformGrid.super.init(self, parent, draw_layer, start_scale, Definitions)
end

ViewElementUniformGrid.update = function (self, dt, t, input_service)
	if self._needs_grid_recalculation then
		self:_recalculate_grid()

		self._needs_grid_recalculation = false
	end

	if self._focused_widget then
		self:_handle_input(input_service)
	end
end

ViewElementUniformGrid.on_resolution_modified = function (self, scale)
	ViewElementUniformGrid.super.on_resolution_modified(self, scale)

	self._needs_grid_recalculation = true
end

ViewElementUniformGrid.grid_area_position = function (self)
	local position = self:scenegraph_position(GRID_AREA_SCENEGRAPH_ID)

	return position[1], position[2], position[3]
end

ViewElementUniformGrid.set_grid_area_position = function (self, position, horizontal_alignment, vertical_alignment)
	self:_set_scenegraph_position(GRID_AREA_SCENEGRAPH_ID, position[1], position[2], position[3])

	local scenegraph = self._ui_scenegraph[GRID_AREA_SCENEGRAPH_ID]

	if horizontal_alignment then
		scenegraph.horizontal_alignment = horizontal_alignment
	end

	if vertical_alignment then
		scenegraph.vertical_alignment = vertical_alignment
	end

	self._needs_grid_recalculation = true
end

ViewElementUniformGrid.grid_area_size = function (self)
	local ui_scenegraph = self._ui_scenegraph
	local scenegraph = ui_scenegraph[GRID_AREA_SCENEGRAPH_ID]
	local size = scenegraph.size

	return size[1], size[2]
end

ViewElementUniformGrid.set_grid_area_size = function (self, size)
	self:_set_scenegraph_size(GRID_AREA_SCENEGRAPH_ID, size[1], size[2])

	self._needs_grid_recalculation = true
end

ViewElementUniformGrid.grid_size = function (self)
	local num_cells = self._num_cells

	return num_cells[1], num_cells[2]
end

ViewElementUniformGrid.num_cells = function (self)
	local num_cells = self._num_cells

	return num_cells[1] * num_cells[2]
end

ViewElementUniformGrid.set_grid_size = function (self, num_columns, num_rows)
	local num_cells = self._num_cells

	if num_columns and num_columns ~= num_cells[1] then
		num_cells[1] = num_columns
		self._needs_grid_recalculation = true
	end

	if num_rows and num_rows ~= num_cells[2] then
		num_cells[2] = num_rows
		self._needs_grid_recalculation = true
	end
end

ViewElementUniformGrid.is_hexagonal = function (self)
	return self._is_hexagonal
end

ViewElementUniformGrid.set_is_hexagonal = function (self, flag)
	if flag ~= self._is_hexagonal then
		self._is_hexagonal = flag
		self._needs_grid_recalculation = true
	end
end

ViewElementUniformGrid.set_grid_spacing = function (self, column_spacing, row_spacing)
	local grid_spacing = self._grid_spacing

	if column_spacing and column_spacing ~= grid_spacing[1] then
		grid_spacing[1] = column_spacing
		self._needs_grid_recalculation = true
	end

	if row_spacing and row_spacing ~= grid_spacing[2] then
		grid_spacing[2] = row_spacing
		self._needs_grid_recalculation = true
	end
end

ViewElementUniformGrid.cell_size = function (self)
	local cell_size = self._cell_size

	return cell_size[1], cell_size[2]
end

ViewElementUniformGrid.force_grid_recalculation = function (self)
	self:_recalculate_grid()

	self._needs_grid_recalculation = false
end

ViewElementUniformGrid.add_widget_to_grid = function (self, column, row, widget_name, widget_blueprint, init_callback, ...)
	local scenegraph_id = string.format(GRID_CELL_ID_FORMAT, column, row)
	local widget_pass_template = widget_blueprint.pass_template
	local size = widget_blueprint.size
	local widget_definition = UIWidget.create_definition(widget_pass_template, scenegraph_id, widget_blueprint.content_overrides, size, widget_blueprint.style)
	local widget = self:_create_widget(widget_name, widget_definition)

	if widget_blueprint.offset then
		widget.offset[1] = widget_blueprint.offset[1]
		widget.offset[2] = widget_blueprint.offset[2]
		widget.offset[3] = widget_blueprint.offset[3]
	end

	local content = widget.content
	content.column = column
	content.row = row

	self:_clear_navigation_history()

	local widgets = self._widgets

	self:_insert_widget_widget_in_grid(widget, column, row, 1, #widgets)

	init_callback = init_callback or widget_blueprint.init

	if init_callback then
		init_callback(widget, ...)
	end

	return widget
end

ViewElementUniformGrid.remove_widget = function (self, widget)
	local widgets = self._widgets
	local focused_widget = self._focused_widget

	for i = 1, #widgets do
		if widgets[i] == widget then
			self:_unregister_widget_name(widget.name)
			table.remove(widgets, i)
			self:_clear_navigation_history()

			if widget == focused_widget then
				local content = widget.content
				local next_widget = self:_find_next_cell(content.column, content.row)

				self:set_focused_grid_widget(next_widget)
			end

			break
		end
	end
end

ViewElementUniformGrid.grid_widget = function (self, column, row)
	local widgets = self._widgets

	for i = 1, #widgets do
		local widget = widgets[i]
		local content = widget.content

		if content.column == column and content.row == row then
			return widget
		elseif row < content.row then
			return nil
		end
	end

	return nil
end

ViewElementUniformGrid.focused_cell = function (self)
	local focused_widget = self._focused_widget

	if focused_widget then
		local widget_content = focused_widget.content

		return widget_content.column, widget_content.row
	end

	return nil
end

ViewElementUniformGrid.set_focused_grid_cell = function (self, column, row)
	self._focused_widget = nil

	self:_clear_navigation_history()

	local widgets = self._widgets

	for i = 1, #widgets do
		local widget = widgets[i]
		local content = widget.content
		local hotspot = content.hotspot or content.button_hotspot

		if hotspot and not hotspot.disabled then
			local is_focused = content.column == column and content.row == row
			hotspot.is_focused = is_focused

			if is_focused then
				self._focused_widget = widget
				local focused_callback = hotspot.focused_callback

				if focused_callback then
					focused_callback()
				end
			end
		end
	end
end

ViewElementUniformGrid.focused_grid_widget = function (self)
	return self._focused_widget
end

ViewElementUniformGrid.set_focused_grid_widget = function (self, widget_to_focus)
	if self._focused_widget == widget_to_focus then
		return
	end

	self._focused_widget = nil

	self:_clear_navigation_history()

	local widgets = self._widgets

	for i = 1, #widgets do
		local widget = widgets[i]
		local content = widget.content
		local hotspot = content.hotspot or content.button_hotspot

		if hotspot then
			local is_focused = widget == widget_to_focus
			hotspot.is_focused = is_focused

			if is_focused then
				self._focused_widget = widget_to_focus
				local focused_callback = hotspot.focused_callback

				if focused_callback then
					focused_callback()
				end
			end
		end
	end
end

ViewElementUniformGrid.grid_cell_world_position = function (self, column, row, scale)
	local scenegraph_id = string.format(GRID_CELL_ID_FORMAT, column, row)
	local position = self:scenegraph_world_position(scenegraph_id, scale or 1)

	return position[1], position[2], position[3]
end

ViewElementUniformGrid.focus_first_index = function (self, start_column, start_row)
	start_column = start_column or 1
	start_row = start_row or 1
	local widget = self:_find_next_cell(start_column, start_row)

	self:set_focused_grid_widget(widget)
end

ViewElementUniformGrid.select_first_index = function (self, start_column, start_row)
	start_column = start_column or 1
	start_row = start_row or 1
	local widget = self:_find_next_cell(start_column, start_row)

	self:select_grid_widget(widget)
end

ViewElementUniformGrid._handle_input = function (self, input_service)
	local focused_widget = self._focused_widget
	local widget_content = focused_widget.content
	local start_column = widget_content.column
	local start_row = widget_content.row
	local nav_direction, opposite_direction = nil

	if input_service:get("navigate_up_continuous") then
		nav_direction = "up"
		opposite_direction = "down"
	elseif input_service:get("navigate_down_continuous") then
		nav_direction = "down"
		opposite_direction = "up"
	elseif input_service:get("navigate_left_continuous") then
		nav_direction = "left"
		opposite_direction = "right"
	elseif input_service:get("navigate_right_continuous") then
		nav_direction = "right"
		opposite_direction = "left"
	end

	if nav_direction then
		local next_widget = nil

		if opposite_direction == self._last_navigation_direction then
			next_widget = self._last_focused_widget
		else
			next_widget = self:_find_next_cell(start_column, start_row, nav_direction)
		end

		if next_widget then
			self:set_focused_grid_widget(next_widget)

			self._last_focused_widget = focused_widget
			self._last_navigation_direction = nav_direction
		end
	end
end

ViewElementUniformGrid._find_next_cell = function (self, start_column, start_row, direction)
	local is_hexagonal = self._is_hexagonal
	local column_padding = is_hexagonal and 0.5 or 0
	local row_offset = is_hexagonal and math.sqrt(3) / 2 or 1
	start_column = start_column + start_row % 2 * column_padding
	start_row = start_row * row_offset
	local orthogonal_weight_primary = 0.5
	local orthogonal_weight_secondary = 1
	local horizontal_primary_orthogonal_direction = "down"
	local vertical_primary_orthogonal_direction = "right"
	local widgets = self._widgets
	local closest_distance = math.huge
	local closest_widget = nil

	for i = 1, #widgets do
		local widget = widgets[i]
		local content = widget.content
		local hotspot = content.hotspot

		if hotspot and not hotspot.disabled then
			local column = content.column
			local row = content.row
			local column_offset = row % 2 * column_padding
			local horizontal_distance = column - start_column + column_offset
			local vertical_distance = row * row_offset - start_row

			if direction == "up" or direction == "down" then
				if horizontal_distance > 0 then
					horizontal_distance = vertical_primary_orthogonal_direction == "right" and horizontal_distance + orthogonal_weight_primary or horizontal_distance + orthogonal_weight_secondary
				elseif horizontal_distance < 0 then
					horizontal_distance = vertical_primary_orthogonal_direction == "left" and horizontal_distance - orthogonal_weight_primary or horizontal_distance - orthogonal_weight_secondary
				end
			elseif direction == "left" or direction == "right" then
				if vertical_distance > 0 then
					vertical_distance = horizontal_primary_orthogonal_direction == "up" and vertical_distance + orthogonal_weight_primary or vertical_distance + orthogonal_weight_secondary
				elseif vertical_distance < 0 then
					vertical_distance = horizontal_primary_orthogonal_direction == "down" and vertical_distance - orthogonal_weight_primary or vertical_distance - orthogonal_weight_secondary
				end
			end

			local distance_squared = horizontal_distance^2 + vertical_distance^2

			if closest_distance > distance_squared and (not direction or direction == "left" and horizontal_distance < 0 or direction == "right" and horizontal_distance > 0 or direction == "up" and vertical_distance < 0 or direction == "down" and vertical_distance > 0) then
				closest_distance = distance_squared
				closest_widget = widget
			end
		end
	end

	return closest_widget
end

ViewElementUniformGrid._recalculate_grid = function (self)
	local grid_width, grid_height = self:_scenegraph_size(GRID_AREA_SCENEGRAPH_ID)
	local num_cells = self._num_cells
	local cell_size = self._cell_size
	local grid_spacing = self._grid_spacing
	local is_hexagonal = self._is_hexagonal
	local column_padding = is_hexagonal and 0.5 or 0
	local row_extra_offset = is_hexagonal and math.sqrt(3) / 2 or 1
	local num_vertical_gutters = num_cells[1] - 1
	cell_size[1] = (grid_width - grid_spacing[1] * num_vertical_gutters) / (num_cells[1] + column_padding)
	local num_horizontal_gutters = num_cells[2] - 1
	cell_size[2] = (grid_height - grid_spacing[2] * num_horizontal_gutters) / (num_cells[2] * row_extra_offset)
	local definitions = self._definitions
	local grid_cell_blueprint = definitions.grid_cell_scenegraph_blueprint
	local new_scenegraph_definition = table.clone(definitions.scenegraph_definition)
	local old_grid_area_definition = self._ui_scenegraph[GRID_AREA_SCENEGRAPH_ID]
	local new_grid_area_definition = new_scenegraph_definition[GRID_AREA_SCENEGRAPH_ID]
	new_grid_area_definition.size = table.clone(old_grid_area_definition.size)
	new_grid_area_definition.position = table.clone(old_grid_area_definition.position)
	new_grid_area_definition.horizontal_alignment = old_grid_area_definition.horizontal_alignment
	new_grid_area_definition.vertical_alignment = old_grid_area_definition.vertical_alignment

	for row = 1, num_cells[2] do
		local column_extra_offset = row % 2 == 1 and cell_size[1] * column_padding or 0
		local row_offset = (row - 1) * (cell_size[2] + grid_spacing[2]) * row_extra_offset

		for column = 1, num_cells[1] do
			local new_scenegraph_id = string.format(GRID_CELL_ID_FORMAT, column, row)
			local new_node_definition = table.clone(grid_cell_blueprint)
			local position = new_node_definition.position
			position[1] = (column - 1) * (cell_size[1] + grid_spacing[1]) + column_extra_offset
			position[2] = row_offset
			local size = new_node_definition.size
			size[1] = cell_size[1]
			size[2] = cell_size[2]
			new_scenegraph_definition[new_scenegraph_id] = new_node_definition
		end
	end

	local new_definitions = {
		scenegraph_definition = new_scenegraph_definition
	}
	self._ui_scenegraph = self:_create_scenegraph(new_definitions)
end

ViewElementUniformGrid._clear_navigation_history = function (self)
	self._last_focused_widget = nil
	self._last_navigation_direction = nil
end

ViewElementUniformGrid._insert_widget_widget_in_grid = function (self, widget, column, row, start_index, end_index)
	local num_in_range = end_index - start_index + 1

	if num_in_range < 1 then
		table.insert(self._widgets, start_index, widget)

		return
	end

	local mid_index = start_index + math.floor(num_in_range / 2)
	local widgets = self._widgets
	local mid_widget = widgets[mid_index]
	local mid_widget_content = mid_widget.content
	local mid_widget_column = mid_widget_content.column
	local mid_widget_row = mid_widget_content.row

	if row < mid_widget_row or mid_widget_row == row and column < mid_widget_column then
		self:_insert_widget_widget_in_grid(widget, column, row, start_index, mid_index - 1)
	else
		self:_insert_widget_widget_in_grid(widget, column, row, mid_index + 1, end_index)
	end
end

return ViewElementUniformGrid
