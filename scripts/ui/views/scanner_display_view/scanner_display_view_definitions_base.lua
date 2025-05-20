-- chunkname: @scripts/ui/views/scanner_display_view/scanner_display_view_definitions_base.lua

local UIWidget = require("scripts/managers/ui/ui_widget")
local render_size = 1024
local screen_size = {
	render_size,
	render_size,
}
local decoration_inquisition_widget_size = {
	render_size * 0.1,
	render_size * 0.1,
}
local decoration_left_mark_widget_size = {
	render_size * 0.1,
	render_size * 0.2,
}
local decoration_right_mark_widget_size = {
	render_size * 0.1,
	render_size * 0.2,
}
local decoration_eagle_widget_size = {
	render_size * 0.4,
	render_size * 0.4,
}
local decoration_skull_widget_size = {
	render_size * 0.1,
	render_size * 0.1,
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
			0,
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
					0,
					0,
					-1,
				},
			},
		},
	}, "scanner_base", nil, screen_size),
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
					0,
					0,
					-1,
				},
			},
		},
	}, "scanner_base", nil, screen_size),
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
					-decoration_inquisition_widget_size[1] / 2,
					-render_size * 0.31,
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
					-render_size * 0.46,
					render_size * 0.07 - decoration_left_mark_widget_size[2] / 2,
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
					render_size * 0.46 - decoration_right_mark_widget_size[1],
					render_size * 0.07 - decoration_right_mark_widget_size[2] / 2,
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
					render_size * 0.07,
					render_size * 0.1,
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
					-render_size * 0.26,
					render_size * 0.23,
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
