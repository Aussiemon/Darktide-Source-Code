-- chunkname: @scripts/ui/view_elements/view_element_inventory_weapon_preview/view_element_inventory_weapon_preview_settings.lua

local view_element_inventory_weapon_preview_settings = {
	shading_environment = "content/shading_environments/ui/ui_item_preview",
	weapon_spawn_depth = 1.2,
	stats_size = {
		300,
		50,
	},
	trait_size = {
		90,
		90,
	},
}

return settings("ViewElementInventoryWeaponPreviewSettings", view_element_inventory_weapon_preview_settings)
