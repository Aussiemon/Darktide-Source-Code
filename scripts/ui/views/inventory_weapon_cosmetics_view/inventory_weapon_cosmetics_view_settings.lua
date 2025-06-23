-- chunkname: @scripts/ui/views/inventory_weapon_cosmetics_view/inventory_weapon_cosmetics_view_settings.lua

local inventory_weapon_cosmetics_view_settings = {
	scrollbar_width = 7,
	timer_name = "ui",
	total_blur_duration = 0.5,
	weapon_spawn_depth = 1.2,
	viewport_type = "default",
	world_layer = 35,
	viewport_layer = 1
}

return settings("InventoryWeaponCosmeticsViewSettings", inventory_weapon_cosmetics_view_settings)
