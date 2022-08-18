local HudElementTacticalOverlaySettings = require("scripts/ui/hud/elements/tactical_overlay/hud_element_tactical_overlay_settings")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIHudSettings = require("scripts/settings/ui/ui_hud_settings")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen
}
local text_style = table.clone(UIFontSettings.header_1)
text_style.text_horizontal_alignment = "center"
text_style.text_vertical_alignment = "center"
local widget_definitions = {
	background = UIWidget.create_definition({
		{
			value = "content/ui/materials/frames/locations/background",
			style_id = "glow",
			pass_type = "texture",
			style = {
				offset = {
					0,
					0,
					0
				},
				color = UIHudSettings.color_tint_main_3
			}
		},
		{
			value_id = "text",
			style_id = "text",
			pass_type = "text",
			value = "Tactical Overlay WIP",
			style = text_style
		}
	}, "screen")
}
local shield = nil

return {
	shield_definition = shield,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition
}
