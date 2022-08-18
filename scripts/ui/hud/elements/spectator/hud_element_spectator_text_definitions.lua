local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local background_size = {
	653,
	25
}
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	bounding_box = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			background_size[1] + 70,
			background_size[2] + 20
		},
		position = {
			0,
			20,
			0
		}
	},
	spectating_text = {
		vertical_alignment = "top",
		parent = "bounding_box",
		horizontal_alignment = "center",
		size = {
			653,
			25
		},
		position = {
			0,
			100,
			1
		}
	},
	target_text = {
		vertical_alignment = "top",
		parent = "spectating_text",
		horizontal_alignment = "center",
		size = {
			653,
			25
		},
		position = {
			0,
			20,
			0
		}
	},
	next_target_text = {
		vertical_alignment = "top",
		parent = "target_text",
		horizontal_alignment = "center",
		size = {
			653,
			25
		},
		position = {
			0,
			35,
			0
		}
	}
}
local spectating_style = table.clone(UIFontSettings.hud_body)
spectating_style.text_horizontal_alignment = "center"
spectating_style.text_vertical_alignment = "top"
local name_style = table.clone(UIFontSettings.hud_body)
name_style.text_horizontal_alignment = "center"
name_style.text_vertical_alignment = "top"
local widget_definitions = {
	spectating_text = UIWidget.create_definition({
		{
			value = "You are spectating:",
			pass_type = "text",
			style = spectating_style
		}
	}, "spectating_text"),
	target_text = UIWidget.create_definition({
		{
			value_id = "text",
			pass_type = "text",
			style = name_style
		}
	}, "target_text"),
	next_target_text = UIWidget.create_definition({
		{
			value = "Press (m) to cycle targets.",
			pass_type = "text",
			style = spectating_style
		}
	}, "next_target_text")
}

return {
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition
}
