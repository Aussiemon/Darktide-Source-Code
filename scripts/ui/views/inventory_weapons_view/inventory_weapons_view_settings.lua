-- chunkname: @scripts/ui/views/inventory_weapons_view/inventory_weapons_view_settings.lua

local grid_size = {
	640,
	750
}
local grid_width = grid_size[1]
local grid_height = grid_size[2]
local grid_blur_edge_size = {
	80,
	0
}
local mask_size = {
	grid_width + grid_blur_edge_size[1] * 2,
	grid_height + grid_blur_edge_size[2] * 2
}
local inventory_weapons_view = {
	total_blur_duration = 0.5,
	timer_name = "ui",
	viewport_type = "default",
	world_layer = 35,
	scrollbar_width = 7,
	item_discard_hold_duration = 0.75,
	item_discard_anim_duration = 0.3,
	shading_environment = "content/shading_environments/ui/inventory",
	viewport_name = "ui_weapon_preview_viewport",
	viewport_layer = 1,
	stats_anim_duration = 1,
	level_name = "content/levels/ui/cosmetics_preview/cosmetics_preview",
	world_name = "ui_weapon_preview",
	grid_spacing = {
		32,
		10
	},
	grid_size = grid_size,
	mask_size = mask_size,
	stats_size = {
		500,
		6
	},
	info_box_size = {
		1040,
		235
	}
}

return settings("InventoryWeaponsViewSettings", inventory_weapons_view)
