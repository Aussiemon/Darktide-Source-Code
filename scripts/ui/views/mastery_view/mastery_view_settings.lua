-- chunkname: @scripts/ui/views/mastery_view/mastery_view_settings.lua

local ContentBlueprints = require("scripts/ui/views/mastery_view/mastery_view_blueprints")
local trait_size = ContentBlueprints.trait_new.size
local window_size = {
	1400,
	500
}
local image_size = {
	window_size[1] * 0.5,
	window_size[2] + 200
}
local content_size = {
	window_size[1] * 0.5,
	window_size[2]
}
local column_offset = trait_size[1] + 8
local row_offset = trait_size[2] + 8
local total_rows = 2
local total_columns = 6

local function _generate_trait_positions()
	local positions = {}
	local row = 1
	local column = 1

	while column <= total_columns do
		local column_start_row_offset = 0

		positions[#positions + 1] = {
			column_offset * (column - 1) + column_start_row_offset,
			row_offset * (row - 1)
		}
		column = column + 1

		if column > total_columns and row < total_rows then
			row = row + 1
			column = 1
		end
	end

	return positions
end

local mastery_view = {
	total_blur_duration = 0.5,
	window_size = window_size,
	image_size = image_size,
	content_size = content_size,
	trait_positions = _generate_trait_positions(),
	trait_grid_settings = {
		total_rows,
		total_columns
	}
}

return settings("MasteryViewSettings", mastery_view)
