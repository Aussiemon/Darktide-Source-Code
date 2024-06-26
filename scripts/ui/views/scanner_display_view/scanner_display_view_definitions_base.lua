-- chunkname: @scripts/ui/views/scanner_display_view/scanner_display_view_definitions_base.lua

local UIWidget = require("scripts/managers/ui/ui_widget")
local screen_size = {
	1920,
	1080,
}
local screen_ratio = screen_size[1] / screen_size[2]
local decoration_inquisition_widget_size = {
	screen_ratio * 112,
	112,
}
local decoration_left_mark_widget_size = {
	screen_ratio * 112,
	224,
}
local decoration_right_mark_widget_size = {
	screen_ratio * 112,
	224,
}
local decoration_eagle_widget_size = {
	screen_ratio * 448,
	448,
}
local decoration_skull_widget_size = {
	screen_ratio * 112,
	112,
}
local scenegraph_definition = {
	scanner_base = {
		scale = "fit_width",
		size = screen_size,
		position = {
			0,
			0,
			2,
		},
	},
	center_pivot = {
		horizontal_alignment = "center",
		parent = "scanner_base",
		vertical_alignment = "center",
		size = {
			0,
			0,
		},
		position = {
			0,
			100,
			1,
		},
	},
}
local widget_definitions = {
	scanner_background = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/backgrounds/default_square",
			style = {
				hdr = true,
				color = {
					255,
					0,
					0,
					0,
				},
				offset = {
					-960,
					-540,
					-1,
				},
			},
		},
	}, "center_pivot", nil, screen_size),
	noise_background = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/backgrounds/scanner/scanner_background_noise",
			style = {
				hdr = true,
				color = {
					255,
					0,
					128,
					0,
				},
				offset = {
					-960,
					-540,
					-1,
				},
			},
		},
	}, "center_pivot", nil, screen_size),
	decoration_inquisition = UIWidget.create_definition({
		{
			pass_type = "texture",
			style_id = "highlight",
			value = "content/ui/materials/backgrounds/scanner/scanner_decoration_inquisition",
			style = {
				hdr = true,
				color = {
					255,
					0,
					255,
					0,
				},
				offset = {
					-100,
					-325,
					5,
				},
			},
		},
	}, "center_pivot", nil, decoration_inquisition_widget_size),
	decoration_left_mark = UIWidget.create_definition({
		{
			pass_type = "texture",
			style_id = "highlight",
			value = "content/ui/materials/backgrounds/scanner/scanner_decoration_left_mark",
			style = {
				hdr = true,
				color = {
					255,
					0,
					255,
					0,
				},
				offset = {
					-900,
					-100,
					5,
				},
			},
		},
	}, "center_pivot", nil, decoration_left_mark_widget_size),
	decoration_right_mark = UIWidget.create_definition({
		{
			pass_type = "texture",
			style_id = "highlight",
			value = "content/ui/materials/backgrounds/scanner/scanner_decoration_right_mark",
			style = {
				hdr = true,
				color = {
					255,
					0,
					255,
					0,
				},
				offset = {
					700,
					-100,
					5,
				},
			},
		},
	}, "center_pivot", nil, decoration_right_mark_widget_size),
	decoration_eagle = UIWidget.create_definition({
		{
			pass_type = "texture",
			style_id = "highlight",
			value = "content/ui/materials/backgrounds/scanner/scanner_decoration_eagle",
			style = {
				hdr = true,
				color = {
					255,
					0,
					255,
					0,
				},
				offset = {
					100,
					100,
					5,
				},
			},
		},
	}, "center_pivot", nil, decoration_eagle_widget_size),
	decoration_skull = UIWidget.create_definition({
		{
			pass_type = "texture",
			style_id = "highlight",
			value = "content/ui/materials/backgrounds/scanner/scanner_decoration_skull",
			style = {
				hdr = true,
				color = {
					255,
					0,
					255,
					0,
				},
				offset = {
					-500,
					250,
					5,
				},
			},
		},
	}, "center_pivot", nil, decoration_skull_widget_size),
}

return {
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
}
