local options_view_settings = {
	scrollbar_width = 10,
	max_visible_dropdown_options = 5,
	indentation_spacing = 40,
	shading_environment = "content/shading_environments/ui/system_menu",
	grid_size = {
		500,
		800
	},
	grid_spacing = {
		0,
		10
	},
	grid_blur_edge_size = {
		8,
		8
	}
}

return settings("OptionsViewSettings", options_view_settings)
