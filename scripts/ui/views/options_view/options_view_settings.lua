-- chunkname: @scripts/ui/views/options_view/options_view_settings.lua

local options_view_settings = {
	indentation_spacing = 40,
	max_visible_dropdown_options = 5,
	scrollbar_width = 10,
	shading_environment = "content/shading_environments/ui/system_menu",
	grid_size = {
		500,
		800,
	},
	grid_spacing = {
		0,
		10,
	},
	grid_blur_edge_size = {
		8,
		8,
	},
}

return settings("OptionsViewSettings", options_view_settings)
