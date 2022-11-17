local grid_size = {
	620,
	350
}
grid_size = {
	620,
	640
}
local grid_width = grid_size[1]
local grid_height = grid_size[2]
local grid_blur_edge_size = {
	80,
	20
}
local mask_size = {
	grid_width + grid_blur_edge_size[1] * 2,
	grid_height + grid_blur_edge_size[2] * 2
}
local inventory_view_settings = {
	scrollbar_width = 7,
	wallet_sync_delay = 15,
	grid_spacing = {
		10,
		10
	},
	grid_size = grid_size,
	mask_size = mask_size
}

return settings("InventoryViewSettings", inventory_view_settings)
