-- chunkname: @scripts/ui/views/inventory_weapons_view/inventory_weapons_view_settings.lua

local grid_size = {
	640,
	750,
}
local grid_width = grid_size[1]
local grid_height = grid_size[2]
local grid_blur_edge_size = {
	80,
	0,
}
local mask_size = {
	grid_width + grid_blur_edge_size[1] * 2,
	grid_height + grid_blur_edge_size[2] * 2,
}
local inventory_weapons_view = {
	item_discard_anim_duration = 0.3,
	item_discard_hold_duration = 0.75,
	level_name = "content/levels/ui/inventory_weapon_view/inventory_weapon_view",
	scrollbar_width = 7,
	shading_environment = "content/shading_environments/ui/inventory",
	stats_anim_duration = 1,
	timer_name = "ui",
	total_blur_duration = 0.5,
	viewport_layer = 1,
	viewport_name = "ui_weapon_preview_viewport",
	viewport_type = "default",
	world_layer = 35,
	world_name = "ui_weapon_preview",
	grid_spacing = {
		32,
		10,
	},
	grid_size = grid_size,
	mask_size = mask_size,
	stats_size = {
		500,
		6,
	},
	info_box_size = {
		1040,
		235,
	},
}

return settings("InventoryWeaponsViewSettings", inventory_weapons_view)
