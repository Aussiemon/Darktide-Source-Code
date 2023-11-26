-- chunkname: @scripts/ui/views/scanner_display_view/scanner_display_view_definitions_none.lua

local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen
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
	}, "screen", nil, nil)
}

return {
	none = {
		widget_definitions = widget_definitions,
		scenegraph_definition = scenegraph_definition
	}
}
