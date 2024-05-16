-- chunkname: @scripts/ui/views/title_view/title_view_settings.lua

local title_view_settings = {
	ignore_level_background = true,
	level_name = "content/levels/ui/title_screen/title_screen",
	shading_environment = "content/shading_environments/ui/title_screen",
	timer_name = "ui",
	viewport_layer = 1,
	viewport_name = "ui_title_screen_viewport",
	viewport_type = "default_with_alpha",
	world_layer = 800,
	world_name = "ui_title_screen_world",
}

return settings("TitleViewSettings", title_view_settings)
