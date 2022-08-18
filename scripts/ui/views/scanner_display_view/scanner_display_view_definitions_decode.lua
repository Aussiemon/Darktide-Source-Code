local ScannerDisplayViewSettings = require("scripts/ui/views/scanner_display_view/scanner_display_view_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local size_factor = ScannerDisplayViewSettings.size_factor
local display_size = {
	size_factor * 512,
	size_factor * 512
}
local needle_size = {
	size_factor * 240,
	size_factor * 30
}
local target_size = {
	size_factor * 37,
	size_factor * 37
}
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	grid_scene = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = display_size,
		position = {
			0,
			-10,
			1
		}
	},
	needle_scene = {
		vertical_alignment = "bottom",
		parent = "grid_scene",
		horizontal_alignment = "center",
		size = needle_size,
		position = {
			size_factor * 120,
			size_factor * -75,
			1
		}
	},
	target_scene = {
		vertical_alignment = "bottom",
		parent = "grid_scene",
		horizontal_alignment = "center",
		size = target_size,
		position = {
			size_factor * 0,
			size_factor * -75,
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
					128,
					128,
					128
				}
			}
		}
	}, "screen", nil, nil),
	scanner_grid = UIWidget.create_definition({
		{
			value = "content/ui/materials/backgrounds/scanner/scanner_background_grid",
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
	}, "grid_scene", nil, nil),
	scanner_needle = UIWidget.create_definition({
		{
			value = "content/ui/materials/backgrounds/scanner/scanner_decode_needle",
			style_id = "needle",
			pass_type = "rotated_texture",
			style = {
				angle = 0,
				hdr = true,
				pivot = {
					0,
					needle_size[2] * 0.5
				},
				color = {
					255,
					255,
					165,
					0
				}
			}
		}
	}, "needle_scene", nil, nil),
	scanner_target_one = UIWidget.create_definition({
		{
			value = "content/ui/materials/backgrounds/scanner/scanner_decode_target_1",
			style_id = "target",
			pass_type = "texture",
			style = {
				hdr = true,
				color = {
					0,
					0,
					255,
					0
				}
			}
		}
	}, "target_scene", nil, nil),
	scanner_target_two = UIWidget.create_definition({
		{
			value = "content/ui/materials/backgrounds/scanner/scanner_decode_target_2",
			style_id = "target",
			pass_type = "texture",
			style = {
				hdr = true,
				color = {
					0,
					0,
					255,
					0
				}
			}
		}
	}, "target_scene", nil, nil),
	scanner_target_three = UIWidget.create_definition({
		{
			value = "content/ui/materials/backgrounds/scanner/scanner_decode_target_3",
			style_id = "target",
			pass_type = "texture",
			style = {
				hdr = true,
				color = {
					0,
					0,
					255,
					0
				}
			}
		}
	}, "target_scene", nil, nil)
}

return {
	decode = {
		widget_definitions = widget_definitions,
		scenegraph_definition = scenegraph_definition
	}
}
