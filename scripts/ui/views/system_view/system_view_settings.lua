-- chunkname: @scripts/ui/views/system_view/system_view_settings.lua

local legend_height = 50
local grid_buffer = 120
local system_view_settings = {
	grid_buffer = grid_buffer,
	grid_size = {
		500,
		1080 - legend_height - 2 * grid_buffer,
	},
}

return settings("SystemViewSettings", system_view_settings)
