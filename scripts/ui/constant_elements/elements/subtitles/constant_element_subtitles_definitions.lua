local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local size = {
	800,
	100
}
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	subtitles = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "center",
		size = size,
		position = {
			0,
			-200,
			1
		}
	}
}
local text_style = table.clone(UIFontSettings.body)
text_style.horizontal_alignment = "center"
text_style.vertical_alignment = "center"
text_style.text_horizontal_alignment = "center"
text_style.text_vertical_alignment = "center"
text_style.offset = {
	0,
	0,
	2
}
text_style.text_color = Color.white(255, true)
text_style.size = size
local widget_definitions = {
	subtitles = UIWidget.create_definition({
		{
			value_id = "text",
			style_id = "text",
			pass_type = "text",
			value = "<text>",
			style = text_style
		}
	}, "subtitles")
}
local letterbox_definition = UIWidget.create_definition({
	{
		style_id = "rect",
		pass_type = "rect",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			color = Color.black(255, true),
			size = size
		}
	}
}, "subtitles")

return {
	letterbox_definition = letterbox_definition,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition
}
