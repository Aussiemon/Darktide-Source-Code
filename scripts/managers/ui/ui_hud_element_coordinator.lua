local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UIHudElementCoordinator = class("UIHudElementCoordinator")
local alignment_grid = {
	columns = {
		"left",
		"center",
		"right"
	},
	rows = {
		"top",
		"center",
		"bottom"
	}
}

UIHudElementCoordinator.init = function (self)
	self._saved_scenegraph_settings = {}
end

UIHudElementCoordinator.safe_rect = function (self)
	local safe_rect_default_value = 0

	return safe_rect_default_value * 0.01
end

UIHudElementCoordinator.update = function (self, dt, t, ui_renderer, input_service)
	local gui = ui_renderer.gui
	local cursor_name = "cursor"
	local cursor_position = input_service:get(cursor_name)
	local w = RESOLUTION_LOOKUP.width
	local h = RESOLUTION_LOOKUP.height
	local scale = RESOLUTION_LOOKUP.scale
	local inverse_scale = RESOLUTION_LOOKUP.inverse_scale
	ui_renderer.scale = scale
	ui_renderer.inverse_scale = inverse_scale
	local safe_rect = self:safe_rect()
	local safe_rect_scale = 1 - safe_rect
	local safe_rect_width = w * safe_rect * 0.5
	local safe_rect_height = h * safe_rect * 0.5
	w = w * safe_rect_scale
	h = h * safe_rect_scale
	local column_settings = alignment_grid.columns
	local row_settings = alignment_grid.rows
	local grid_cell_width = w / #column_settings
	local grid_cell_height = h / #row_settings
	local num_columns = math.ceil(w / grid_cell_width)
	local num_rows = math.ceil(h / grid_cell_height)
	local draw_layer = 998
	local line_color_table = {
		100,
		255,
		255,
		255
	}
	local line_thickness = 1

	for i = 1, num_rows + 1 do
		local x = safe_rect_width
		local y = safe_rect_height + (i - 1) * grid_cell_height - line_thickness
		local position = Vector3(x * inverse_scale, y * inverse_scale, draw_layer)
		local size = Vector2(w * inverse_scale, line_thickness)

		UIRenderer.draw_rect(ui_renderer, position, size, line_color_table)
	end

	for i = 1, num_columns + 1 do
		local x = safe_rect_width + (i - 1) * grid_cell_width
		local y = safe_rect_height
		local position = Vector3(x * inverse_scale, y * inverse_scale, draw_layer)
		local size = Vector2(line_thickness, h * inverse_scale)

		UIRenderer.draw_rect(ui_renderer, position, size, line_color_table)
	end

	if not self._draging_scenegraph_id then
		return
	end

	local grid_color_table = {
		10,
		255,
		255,
		255
	}

	for i = 1, num_columns * num_rows do
		local column = (i - 1) % num_rows + 1
		local row = math.ceil(i / num_columns)
		local area_size = Vector2(w / num_columns, h / num_rows)
		local x = safe_rect_width + area_size[1] * (column - 1)
		local y = safe_rect_height + area_size[2] * (row - 1)
		local position = Vector3(x, y, draw_layer - 1)

		if math.point_is_inside_2d_box(cursor_position, position, area_size) then
			local horizontal_alignment = column_settings[column]
			local vertical_alignment = row_settings[row]
			local pivot_x = position[1]

			if horizontal_alignment == "center" then
				pivot_x = pivot_x + area_size[1] * 0.5
			elseif horizontal_alignment == "right" then
				pivot_x = pivot_x + area_size[1]
			end

			local pivot_y = position[2]

			if vertical_alignment == "center" then
				pivot_y = pivot_y + area_size[2] * 0.5
			elseif vertical_alignment == "bottom" then
				pivot_y = pivot_y + area_size[2]
			end

			local local_x = cursor_position[1] - pivot_x
			local local_y = cursor_position[2] - pivot_y
			position[1] = position[1] * inverse_scale
			position[2] = position[2] * inverse_scale
			area_size[1] = area_size[1] * inverse_scale
			area_size[2] = area_size[2] * inverse_scale

			UIRenderer.draw_rect(ui_renderer, position, area_size, grid_color_table)

			self._hovered_grid_settings = {
				horizontal_alignment = horizontal_alignment,
				vertical_alignment = vertical_alignment,
				point_inside = {
					local_x,
					local_y
				}
			}

			return
		end
	end

	ui_renderer.scale = nil
	ui_renderer.inverse_scale = nil
end

UIHudElementCoordinator.refresh_coordinates = function (self, element, scenegraph_id)
	local scenegraph_settings = self._saved_scenegraph_settings[scenegraph_id]

	if scenegraph_settings then
		local x = scenegraph_settings.x
		local y = scenegraph_settings.y
		local horizontal_alignment = scenegraph_settings.horizontal_alignment
		local vertical_alignment = scenegraph_settings.vertical_alignment

		element:set_scenegraph_position(scenegraph_id, x, y, nil, horizontal_alignment, vertical_alignment)
	end
end

UIHudElementCoordinator.handle_scenegraph_coordinates = function (self, element, scenegraph_id, input_service, render_settings)
	local element_name = element.__class_name

	if self._draging_scenegraph_element_name and self._draging_scenegraph_element_name ~= element_name then
		return
	end

	if self._draging_scenegraph_id and self._draging_scenegraph_id ~= scenegraph_id then
		return
	end

	local saved_scenegraph_settings = self._saved_scenegraph_settings
	local render_scale = render_settings and render_settings.scale or RESOLUTION_LOOKUP.scale
	local render_inverse_scale = render_settings and render_settings.inverse_scale or RESOLUTION_LOOKUP.inverse_scale
	local safe_rect = self:safe_rect()
	local screen_width = RESOLUTION_LOOKUP.width
	local screen_height = RESOLUTION_LOOKUP.height
	local cursor_name = "cursor"
	local left_pressed = input_service:get("left_pressed")
	local cursor_position = input_service:get(cursor_name)
	local size = element:scenegraph_size(scenegraph_id)
	size[1] = size[1] * render_scale
	size[2] = size[2] * render_scale
	local handled = false

	if left_pressed then
		local world_position = element:scenegraph_world_position(scenegraph_id, render_scale)

		if math.point_is_inside_2d_box(cursor_position, world_position, size) then
			self._draging_scenegraph_id = scenegraph_id
			self._draging_scenegraph_element_name = element.__class_name
			self._cursor_start_coordinates = Vector3.to_array(cursor_position)
			self._cursor_box_offset = {
				cursor_position[1] - world_position[1],
				cursor_position[2] - world_position[2]
			}
		end
	end

	if self._draging_scenegraph_id then
		local cursor_box_offset = self._cursor_box_offset
		local cursor_box_offset_x = cursor_box_offset[1]
		local cursor_box_offset_y = cursor_box_offset[2]
		local scenegraph_settings = saved_scenegraph_settings[scenegraph_id]

		if not scenegraph_settings then
			local scenegraph_position = element:scenegraph_position(scenegraph_id)
			scenegraph_settings = {
				x = scenegraph_position[1],
				y = scenegraph_position[2]
			}
			saved_scenegraph_settings[scenegraph_id] = scenegraph_settings
		end

		local left_hold = input_service:get("left_hold")

		if left_hold then
			local safe_rect_width = screen_width * safe_rect * 0.5
			local safe_rect_height = screen_height * safe_rect * 0.5
			local cursor_end_coordinates = Vector3.to_array(cursor_position)
			cursor_end_coordinates[1] = math.clamp(cursor_end_coordinates[1], safe_rect_width + cursor_box_offset_x, screen_width - safe_rect_width - (size[1] - cursor_box_offset_x))
			cursor_end_coordinates[2] = math.clamp(cursor_end_coordinates[2], safe_rect_height + cursor_box_offset_y, screen_height - safe_rect_height - (size[2] - cursor_box_offset_y))
			self._cursor_end_coordinates = cursor_end_coordinates
		else
			self._draging_scenegraph_id = nil
			self._draging_scenegraph_element_name = nil
		end

		local cursor_end_coordinates = self._cursor_end_coordinates

		if cursor_end_coordinates then
			if self._draging_scenegraph_id then
				local cursor_start_coordinates = self._cursor_start_coordinates
				local diff_x = (cursor_end_coordinates[1] - cursor_start_coordinates[1]) * render_inverse_scale
				local diff_y = (cursor_end_coordinates[2] - cursor_start_coordinates[2]) * render_inverse_scale
				local final_x = scenegraph_settings.x + diff_x
				local final_y = scenegraph_settings.y + diff_y

				element:set_scenegraph_position(scenegraph_id, final_x, final_y)
			else
				local hovered_grid_settings = self._hovered_grid_settings
				local horizontal_alignment = hovered_grid_settings.horizontal_alignment
				local vertical_alignment = hovered_grid_settings.vertical_alignment
				local grid_point = hovered_grid_settings.point_inside
				local final_x = 0
				local final_y = 0

				if horizontal_alignment == "center" then
					final_x = (grid_point[1] + size[1] * 0.5 - cursor_box_offset_x) * render_inverse_scale
				elseif horizontal_alignment == "right" then
					final_x = math.min(grid_point[1] + size[1] - cursor_box_offset_x, 0) * render_inverse_scale
				elseif horizontal_alignment == "left" then
					final_x = math.max(grid_point[1] - cursor_box_offset_x, 0) * render_inverse_scale
				end

				if vertical_alignment == "center" then
					final_y = (grid_point[2] + size[2] * 0.5 - cursor_box_offset_y) * render_inverse_scale
				elseif vertical_alignment == "bottom" then
					final_y = math.min(grid_point[2] + size[2] - cursor_box_offset_y, 0) * render_inverse_scale
				elseif vertical_alignment == "top" then
					final_y = math.max(grid_point[2] - cursor_box_offset_y, 0) * render_inverse_scale
				end

				scenegraph_settings.x = final_x
				scenegraph_settings.y = final_y
				scenegraph_settings.horizontal_alignment = horizontal_alignment
				scenegraph_settings.vertical_alignment = vertical_alignment

				element:set_scenegraph_position(scenegraph_id, final_x, final_y, nil, horizontal_alignment, vertical_alignment)
			end
		end

		handled = true
	end

	return handled
end

return UIHudElementCoordinator
