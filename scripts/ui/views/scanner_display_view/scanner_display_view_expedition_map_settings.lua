-- chunkname: @scripts/ui/views/scanner_display_view/scanner_display_view_expedition_map_settings.lua

local render_size = 1024
local background_ring_definitions = {
	{
		pass_type = "rotated_texture",
		style_id = "highlight",
		value = "content/ui/materials/backgrounds/scanner/scanner_map_background",
		style = {
			angle = 0,
			hdr = true,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			color = {
				255,
				0,
				255,
				0,
			},
		},
	},
	{
		pass_type = "texture",
		style_id = "radar",
		value = "content/ui/materials/backgrounds/scanner/scanner_map_radar",
		style = {
			hdr = true,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			color = {
				128,
				0,
				255,
				0,
			},
		},
	},
	{
		pass_type = "texture",
		style_id = "noise",
		value = "content/ui/materials/backgrounds/scanner/scanner_noise",
		style = {
			hdr = true,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			color = {
				50,
				0,
				255,
				0,
			},
		},
	},
}
local base_color = {
	255,
	0,
	255,
	0,
}
local target_definitions = {
	{
		pass_type = "texture",
		style_id = "highlight",
		style = {
			hdr = true,
			color = base_color,
		},
	},
	{
		pass_type = "texture",
		style_id = "title",
		style = {
			hdr = true,
			visible = false,
			color = base_color,
		},
	},
}
local board_size = render_size * 0.4
local scanner_display_view_expedition_map_settings = {
	board_starting_offset_x = 0,
	board_starting_offset_y = 200,
	display_distance = 160,
	target_base_color = base_color,
	target_widget_size = {
		render_size * 0.07,
		render_size * 0.07,
	},
	target_definitions = target_definitions,
	background_rings_size = {
		board_size * 2.6,
		board_size * 2.6,
	},
	background_ring_definitions = background_ring_definitions,
	board_width = board_size,
	board_height = board_size,
}

return settings("ScannerDisplayViewExpeditionMapSettings", scanner_display_view_expedition_map_settings)
