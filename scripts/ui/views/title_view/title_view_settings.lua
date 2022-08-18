local title_view_settings = {
	shading_environment = "content/shading_environments/ui/title_screen",
	timer_name = "ui",
	ignore_level_background = true,
	world_layer = 800,
	viewport_type = "default_with_alpha",
	viewport_name = "ui_title_screen_viewport",
	viewport_layer = 1,
	level_name = "content/levels/ui/title_screen/title_screen",
	world_name = "ui_title_screen_world"
}

return settings("TitleViewSettings", title_view_settings)
