-- chunkname: @scripts/ui/constant_elements/elements/beta_label/constant_element_beta_label_definitions.lua

local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen
}
local title_text_style = table.clone(UIFontSettings.header_2)

title_text_style.font_size = 26
title_text_style.offset = {
	20,
	20,
	900
}
title_text_style.text_color = {
	200,
	255,
	255,
	255
}
title_text_style.text_horizontal_alignment = "left"
title_text_style.text_vertical_alignment = "top"

local widget_definitions = {
	label = UIWidget.create_definition({
		{
			value_id = "text",
			pass_type = "text",
			style = title_text_style
		}
	}, "screen")
}

return {
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition
}
