-- chunkname: @scripts/ui/views/inventory_weapon_marks_view/inventory_weapon_marks_view_settings.lua

local inventory_weapon_cosmetics_view_settings = {
	level_name = "content/levels/ui/inventory_weapon_details/inventory_weapon_details",
	scrollbar_width = 7,
	shading_environment = "content/shading_environments/ui/inventory",
	timer_name = "ui",
	total_blur_duration = 0.5,
	viewport_layer = 1,
	viewport_name = "ui_weapon_marks_preview",
	viewport_type = "default",
	weapon_spawn_depth = 1.2,
	world_layer = 35,
	world_name = "ui_weapon_marks_preview",
}

return settings("InventoryWeaponMarksViewSettings", inventory_weapon_cosmetics_view_settings)
