-- chunkname: @scripts/ui/views/inventory_weapon_marks_view/inventory_weapon_marks_view_settings.lua

local inventory_weapon_cosmetics_view_settings = {
	scrollbar_width = 7,
	timer_name = "ui",
	total_blur_duration = 0.5,
	viewport_name = "ui_weapon_marks_preview",
	viewport_type = "default",
	shading_environment = "content/shading_environments/ui/inventory",
	world_layer = 35,
	viewport_layer = 1,
	level_name = "content/levels/ui/inventory_weapon_details/inventory_weapon_details",
	weapon_spawn_depth = 1.2,
	world_name = "ui_weapon_marks_preview"
}

return settings("InventoryWeaponMarksViewSettings", inventory_weapon_cosmetics_view_settings)
