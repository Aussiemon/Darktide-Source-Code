-- chunkname: @scripts/ui/views/custom_settings_view/custom_settings_view_settings.lua

local custom_settings_settings = {
	grid_height = 720,
	scrollbar_width = 10,
	settings_grid_width = 1000,
	grid_blur_edge_size = {
		8,
		8,
	},
}

return settings("CustomSettingsViewSettings", custom_settings_settings)
