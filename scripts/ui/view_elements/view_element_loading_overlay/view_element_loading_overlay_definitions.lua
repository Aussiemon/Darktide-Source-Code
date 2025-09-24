-- chunkname: @scripts/ui/view_elements/view_element_loading_overlay/view_element_loading_overlay_definitions.lua

local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local wait_reason_style = table.clone(UIFontSettings.header_1)

wait_reason_style.font_size = 30
wait_reason_style.text_horizontal_alignment = "center"
wait_reason_style.text_vertical_alignment = "center"
wait_reason_style.offset = {
	0,
	100,
	0,
}

local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
}
local widget_definitions = {
	loading = UIWidget.create_definition({
		{
			pass_type = "rect",
			style = {
				color = Color.black(127.5, true),
			},
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/loading/loading_icon",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				size = {
					256,
					256,
				},
				offset = {
					0,
					0,
					1,
				},
			},
		},
		{
			pass_type = "text",
			style_id = "text",
			value = "",
			value_id = "text",
			style = wait_reason_style,
		},
	}, "screen"),
}

return {
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
}
