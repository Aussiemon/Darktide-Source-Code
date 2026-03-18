-- chunkname: @scripts/utilities/levels/level_grid.lua

local LevelGridUtilities = {}

LevelGridUtilities.create_level_grid = function (grid_settings)
	local grid_width = grid_settings.width
	local grid_height = grid_settings.height
	local num_rows = grid_settings.num_rows
	local num_columns = grid_settings.num_columns
	local cell_depth = grid_settings.cell_depth
	local start_pos_x = -(grid_width * 0.5)
	local start_pos_y = -(grid_height * 0.5)
	local cell_size = {
		grid_width / num_rows,
		grid_height / num_columns,
	}
	local grid, cells_per_depth = LevelGridUtilities.create_grid(num_rows, num_columns, cell_size, start_pos_x, start_pos_y, cell_depth, nil)

	grid.cells_per_depth = cells_per_depth

	return grid
end

LevelGridUtilities.create_grid = function (num_rows, num_columns, grid_slot_size, start_x, start_y, max_depth, depth_count, cells_per_depth, parent)
	depth_count = depth_count or 1

	local depth_color_name = Color.list[(10 + depth_count) % #Color.list + 1]

	cells_per_depth = cells_per_depth or {}

	local depth_cells = cells_per_depth[depth_count]

	if not depth_cells then
		local coordinates_lookup = {}

		for i = 1, num_rows do
			coordinates_lookup[i] = {}
		end

		depth_cells = {
			coordinates_lookup = coordinates_lookup,
		}
		cells_per_depth[depth_count] = depth_cells
	end

	local depth_cells_coordinates_lookup = depth_cells.coordinates_lookup
	local slot_grid = {}

	for r = 1, num_rows do
		local slot_x = grid_slot_size[1] * (r - 1) + grid_slot_size[1] * 0.5

		for c = 1, num_columns do
			local slot_y = grid_slot_size[2] * (c - 1) + grid_slot_size[2] * 0.5
			local position = {
				start_x + slot_x,
				start_y + slot_y,
				-100,
			}
			local color = {
				math.random(0, 255),
				math.random(0, 255),
				math.random(0, 255),
			}
			local color_name = Color.list[math.random(1, #Color.list)]
			local slot = {
				position = position,
				size = grid_slot_size,
				depth = depth_count,
				max_depth = max_depth,
				is_deepest_depth = depth_count == max_depth,
				debug_color = color,
				depth_color_name = depth_color_name,
				color_name = color_name,
				height = 100 + 2 * depth_count,
				row = r,
				column = c,
			}

			depth_cells[#depth_cells + 1] = slot

			local depth_cells_coordinates_lookup_row = depth_cells_coordinates_lookup[r]

			depth_cells_coordinates_lookup_row[c] = slot

			if depth_count < max_depth then
				local child_slot_size = {
					grid_slot_size[1] / num_rows,
					grid_slot_size[2] / num_columns,
				}
				local child_grid = LevelGridUtilities.create_grid(num_rows, num_columns, child_slot_size, position[1] - grid_slot_size[1] * 0.5, position[2] - grid_slot_size[2] * 0.5, max_depth, depth_count + 1, cells_per_depth, slot)

				slot.child_grid = child_grid
			end

			slot_grid[#slot_grid + 1] = slot
		end
	end

	return slot_grid, cells_per_depth
end

return LevelGridUtilities
