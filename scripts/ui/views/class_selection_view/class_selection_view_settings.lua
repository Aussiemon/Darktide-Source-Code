local scrollbar_width = 10
local class_selection_view_settings = {
	timer_name = "ui",
	viewport_name = "ui_class_selection_viewport",
	viewport_type = "default",
	world_layer = 3,
	archetype_select_spacing = 80,
	shading_environment = "content/shading_environments/ui/class_selection",
	class_option_expanded_size_fraction = 0.25,
	archetype_option_spacing = 25,
	viewport_layer = 1,
	class_select_spacing = 120,
	world_name = "ui_class_selection_world",
	grid_spacing = {
		10,
		0
	},
	grid_size = {
		640,
		840
	},
	scrollbar_width = scrollbar_width,
	class_option_icon_size = {
		306,
		630
	},
	class_size = {
		640,
		680
	},
	class_details_size = {
		600,
		560
	},
	archetype_option_icon_size = {
		128,
		263
	}
}

return settings("ClassSelectionViewSettings", class_selection_view_settings)
