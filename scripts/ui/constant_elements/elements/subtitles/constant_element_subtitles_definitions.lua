-- chunkname: @scripts/ui/constant_elements/elements/subtitles/constant_element_subtitles_definitions.lua

local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local size = {
	800,
	100,
}
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	subtitles = {
		horizontal_alignment = "center",
		parent = "screen",
		vertical_alignment = "bottom",
		size = size,
		position = {
			0,
			-200,
			1,
		},
	},
	secondary_subtitles = {
		horizontal_alignment = "center",
		parent = "subtitles",
		vertical_alignment = "bottom",
		size = size,
		position = {
			0,
			0,
			1,
		},
	},
}
local text_style = table.clone(UIFontSettings.body)

text_style.horizontal_alignment = "center"
text_style.vertical_alignment = "center"
text_style.text_horizontal_alignment = "center"
text_style.text_vertical_alignment = "center"
text_style.offset = {
	0,
	0,
	2,
}
text_style.text_color = Color.white(255, true)
text_style.size = size

local widget_definitions = {
	subtitles = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "text",
			value = "<text>",
			value_id = "text",
			style = text_style,
		},
	}, "subtitles"),
	secondary_subtitles = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "text",
			value = "<text>",
			value_id = "text",
			style = text_style,
		},
	}, "secondary_subtitles"),
}
local letterbox_definition = UIWidget.create_definition({
	{
		pass_type = "rect",
		style_id = "rect",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			color = Color.black(255, true),
			size = size,
		},
	},
}, "subtitles")

return {
	letterbox_definition = letterbox_definition,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
}
