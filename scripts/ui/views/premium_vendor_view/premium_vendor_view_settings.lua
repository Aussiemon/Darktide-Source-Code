local grid_size = {
	640,
	700
}
local grid_width = grid_size[1]
local grid_height = grid_size[2]
local grid_blur_edge_size = {
	80,
	25
}
local mask_size = {
	grid_width + grid_blur_edge_size[1] * 2,
	grid_height + grid_blur_edge_size[2] * 2
}
local premium_vendor_view = {
	stats_spacing = 30,
	scrollbar_width = 7,
	wallet_sync_delay = 30,
	stats_anim_duration = 1,
	weapon_spawn_depth = 1.2,
	shading_environment = "content/debug/quality_assurance/shadings/green",
	grid_spacing = {
		32,
		10
	},
	grid_size = grid_size,
	mask_size = mask_size,
	stats_size = {
		440,
		6
	}
}

return settings("PremiumVendorViewSettings", premium_vendor_view)
