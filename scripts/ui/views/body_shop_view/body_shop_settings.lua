-- chunkname: @scripts/ui/views/body_shop_view/body_shop_settings.lua

local body_shop_settings = {
	level_name = "content/levels/ui/character_create/character_create",
	shading_environment = "content/shading_environments/ui/character_create",
	timer_name = "ui",
	total_blur_duration = 0.5,
	viewport_layer = 1,
	viewport_name = "ui_crafting_view_world_viewport",
	viewport_type = "default",
	world_layer = 1,
	world_name = "ui_crafting_view_world",
}

return settings("BodyShopSettings", body_shop_settings)
