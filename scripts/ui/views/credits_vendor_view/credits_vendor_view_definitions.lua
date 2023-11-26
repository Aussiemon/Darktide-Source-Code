-- chunkname: @scripts/ui/views/credits_vendor_view/credits_vendor_view_definitions.lua

local title_height = 70
local edge_padding = 44
local grid_width = 640
local grid_height = 860
local grid_size = {
	grid_width - edge_padding,
	grid_height
}
local mask_size = {
	grid_width + 40,
	grid_height
}
local grid_settings = {
	scrollbar_vertical_margin = 35,
	scrollbar_vertical_offset = -10,
	grid_size = grid_size,
	mask_size = mask_size,
	title_height = title_height,
	edge_padding = edge_padding
}
local weapon_stats_grid_settings = {
	use_parent_world = true,
	resource_renderer_background = true
}
local scenegraph_definition = {
	item_grid_pivot = {
		vertical_alignment = "top",
		parent = "canvas",
		horizontal_alignment = "left",
		size = {
			grid_width,
			grid_height
		},
		position = {
			100,
			84,
			1
		}
	}
}
local widget_definitions = {}
local animations = {}

return {
	animations = animations,
	grid_settings = grid_settings,
	weapon_stats_grid_settings = weapon_stats_grid_settings,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition
}
