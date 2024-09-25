-- chunkname: @scripts/ui/views/inventory_weapon_cosmetics_view/inventory_weapon_cosmetics_view_settings.lua

local inventory_weapon_cosmetics_view_settings = {
	scrollbar_width = 7,
	timer_name = "ui",
	total_blur_duration = 0.5,
	viewport_layer = 1,
	viewport_type = "default",
	weapon_spawn_depth = 1.2,
	world_layer = 35,
}

return settings("InventoryWeaponCosmeticsViewSettings", inventory_weapon_cosmetics_view_settings)
