local grid_size = {
	500,
	700
}
local grid_width = grid_size[1]
local grid_height = grid_size[2]
local grid_content_edge_margin = 40
local grid_blur_edge_size = {
	80,
	0
}
local mask_size = {
	grid_width + grid_blur_edge_size[1] * 2,
	grid_height + grid_blur_edge_size[2] * 2
}
local inventory_weapon_details_view_settings = {
	weapon_spawn_depth = 1.2,
	scrollbar_width = 7,
	trait_spacing = -10,
	stats_anim_duration = 2,
	shading_environment = "content/shading_environments/ui/ui_item_preview",
	grid_spacing = {
		0,
		10
	},
	grid_size = grid_size,
	mask_size = mask_size,
	grid_content_edge_margin = grid_content_edge_margin,
	stats_size = {
		grid_size[1] - grid_content_edge_margin * 3,
		6
	},
	trait_size = {
		64,
		64
	},
	trait_size_big = {
		128,
		128
	}
}

return settings("InventoryWeaponDetailsViewSettings", inventory_weapon_details_view_settings)
