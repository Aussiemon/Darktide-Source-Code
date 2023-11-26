-- chunkname: @scripts/ui/views/scanner_display_view/scanner_display_view_definitions_decode_symbols.lua

local ScannerDisplayViewDecodeSymbolsSettings = require("scripts/ui/views/scanner_display_view/scanner_display_view_decode_symbols_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local size_factor = ScannerDisplayViewDecodeSymbolsSettings.decode_symbols_size_factor
local screen_ratio = UIWorkspaceSettings.screen.size[1] / UIWorkspaceSettings.screen.size[2]
local symbol_widget_size = {
	screen_ratio * size_factor * 60,
	size_factor * 60
}
local decoration_inquisition_widget_size = {
	screen_ratio * size_factor * 64,
	size_factor * 64
}
local decoration_left_mark_widget_size = {
	screen_ratio * size_factor * 64,
	size_factor * 128
}
local decoration_right_mark_widget_size = {
	screen_ratio * size_factor * 64,
	size_factor * 128
}
local decoration_eagle_widget_size = {
	screen_ratio * size_factor * 256,
	size_factor * 256
}
local decoration_skull_widget_size = {
	screen_ratio * size_factor * 64,
	size_factor * 64
}
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	center_pivot = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			0,
			100,
			1
		}
	}
}
local widget_definitions = {
	scanner_background = UIWidget.create_definition({
		{
			value = "content/ui/materials/backgrounds/default_square",
			pass_type = "texture",
			style = {
				hdr = true,
				color = {
					255,
					0,
					0,
					0
				}
			}
		}
	}, "screen", nil, nil),
	noise_background = UIWidget.create_definition({
		{
			value = "content/ui/materials/backgrounds/scanner/scanner_background_noise",
			pass_type = "texture",
			style = {
				hdr = true,
				color = {
					255,
					0,
					128,
					0
				}
			}
		}
	}, "screen", nil, nil),
	symbol_frame = UIWidget.create_definition({
		{
			value = "content/ui/materials/backgrounds/scanner/scanner_decode_symbol_frame",
			style_id = "frame",
			pass_type = "texture",
			style = {
				hdr = true,
				color = {
					255,
					0,
					0,
					0
				}
			}
		}
	}, "center_pivot", nil, symbol_widget_size),
	symbol_highlight = UIWidget.create_definition({
		{
			value = "content/ui/materials/backgrounds/scanner/scanner_decode_symbol_highlight",
			style_id = "highlight",
			pass_type = "texture",
			style = {
				hdr = true,
				color = {
					255,
					0,
					0,
					0
				}
			}
		}
	}, "center_pivot", nil, symbol_widget_size),
	decoration_inquisition = UIWidget.create_definition({
		{
			value = "content/ui/materials/backgrounds/scanner/scanner_decoration_inquisition",
			style_id = "highlight",
			pass_type = "texture",
			style = {
				hdr = true,
				color = {
					255,
					0,
					255,
					0
				},
				offset = {
					-100,
					-325,
					1
				}
			}
		}
	}, "center_pivot", nil, decoration_inquisition_widget_size),
	decoration_left_mark = UIWidget.create_definition({
		{
			value = "content/ui/materials/backgrounds/scanner/scanner_decoration_left_mark",
			style_id = "highlight",
			pass_type = "texture",
			style = {
				hdr = true,
				color = {
					255,
					0,
					255,
					0
				},
				offset = {
					-900,
					-100,
					1
				}
			}
		}
	}, "center_pivot", nil, decoration_left_mark_widget_size),
	decoration_right_mark = UIWidget.create_definition({
		{
			value = "content/ui/materials/backgrounds/scanner/scanner_decoration_right_mark",
			style_id = "highlight",
			pass_type = "texture",
			style = {
				hdr = true,
				color = {
					255,
					0,
					255,
					0
				},
				offset = {
					700,
					-100,
					1
				}
			}
		}
	}, "center_pivot", nil, decoration_right_mark_widget_size),
	decoration_eagle = UIWidget.create_definition({
		{
			value = "content/ui/materials/backgrounds/scanner/scanner_decoration_eagle",
			style_id = "highlight",
			pass_type = "texture",
			style = {
				hdr = true,
				color = {
					255,
					0,
					255,
					0
				},
				offset = {
					200,
					100,
					1
				}
			}
		}
	}, "center_pivot", nil, decoration_eagle_widget_size),
	decoration_skull = UIWidget.create_definition({
		{
			value = "content/ui/materials/backgrounds/scanner/scanner_decoration_skull",
			style_id = "highlight",
			pass_type = "texture",
			style = {
				hdr = true,
				color = {
					255,
					0,
					255,
					0
				},
				offset = {
					-500,
					250,
					1
				}
			}
		}
	}, "center_pivot", nil, decoration_skull_widget_size)
}

return {
	decode_symbols = {
		widget_definitions = widget_definitions,
		scenegraph_definition = scenegraph_definition
	}
}
