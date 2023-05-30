local ScannerDisplayViewScanSettings = require("scripts/ui/views/scanner_display_view/scanner_display_view_scan_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local size_factor = ScannerDisplayViewScanSettings.scan_size_factor
local screen_ratio = UIWorkspaceSettings.screen.size[1] / UIWorkspaceSettings.screen.size[2]
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
	},
	segments_center_pivot = {
		vertical_alignment = "center",
		parent = "center_pivot",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			0,
			1480,
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
					255,
					0
				}
			}
		}
	}, "screen", nil, nil),
	decoration_inquisition = UIWidget.create_definition({
		{
			value = "content/ui/materials/backgrounds/scanner/scanner_decoration_inquisition",
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
					-165,
					1
				}
			}
		}
	}, "center_pivot", nil, decoration_inquisition_widget_size),
	decoration_left_mark = UIWidget.create_definition({
		{
			value = "content/ui/materials/backgrounds/scanner/scanner_decoration_left_mark",
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
					-25,
					1
				}
			}
		}
	}, "center_pivot", nil, decoration_left_mark_widget_size),
	decoration_right_mark = UIWidget.create_definition({
		{
			value = "content/ui/materials/backgrounds/scanner/scanner_decoration_right_mark",
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
					-25,
					1
				}
			}
		}
	}, "center_pivot", nil, decoration_right_mark_widget_size)
}

return {
	scan = {
		widget_definitions = widget_definitions,
		scenegraph_definition = scenegraph_definition
	}
}
