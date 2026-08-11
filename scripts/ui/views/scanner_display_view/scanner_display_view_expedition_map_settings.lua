-- chunkname: @scripts/ui/views/scanner_display_view/scanner_display_view_expedition_map_settings.lua

local render_size = 1024
local board_size = render_size * 0.4
local base_color = {
	255,
	0,
	255,
	0,
}
local scanner_display_view_expedition_map_settings = {
	board_starting_offset_x = 0,
	board_starting_offset_y = 200,
	display_distance = 160,
	loot_alpha_multiplier = 0.4,
	target_base_color = base_color,
	target_widget_size = {
		84,
		84,
	},
	dropped_loot_settings = {
		luggable = {
			icon = "scanner_map_luggable",
			widget_size = {
				64,
				64,
			},
		},
		default = {
			icon = "scanner_map_loot_small",
			widget_size = {
				128,
				128,
			},
		},
	},
	marked_widget_size = {
		128,
		128,
	},
	cursor_widget_size = {
		128,
		128,
	},
	background_rings_size = {
		render_size,
		render_size,
	},
	board_width = board_size,
	board_height = board_size,
}

scanner_display_view_expedition_map_settings.background_ring_definitions = {
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
		platform_disable = "xbs",
		style_id = "noise",
		value = "content/ui/materials/backgrounds/scanner/scanner_lines",
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
scanner_display_view_expedition_map_settings.target_definitions = {
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
	{
		pass_type = "texture",
		style_id = "marked",
		value = "content/ui/materials/backgrounds/scanner/scanner_map_marker",
		style = {
			hdr = true,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			visible = false,
			size = scanner_display_view_expedition_map_settings.marked_widget_size,
			material_values = {
				display_mode = 1,
				part_1_color = {
					0,
					0,
					0,
					0,
				},
				part_2_color = {
					0,
					0,
					0,
					0,
				},
				part_3_color = {
					0,
					0,
					0,
					0,
				},
				part_4_color = {
					0,
					0,
					0,
					0,
				},
			},
			color = {
				255,
				255,
				255,
				255,
			},
		},
	},
}

return settings("ScannerDisplayViewExpeditionMapSettings", scanner_display_view_expedition_map_settings)
