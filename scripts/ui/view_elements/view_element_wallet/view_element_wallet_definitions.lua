-- chunkname: @scripts/ui/view_elements/view_element_wallet/view_element_wallet_definitions.lua

local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local ViewElementWalletSettings = require("scripts/ui/view_elements/view_element_wallet/view_element_wallet_settings")
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	wallet_area = {
		horizontal_alignment = "left",
		parent = "screen",
		vertical_alignment = "top",
		size = {
			0,
			0,
		},
		position = {
			0,
			0,
			0,
		},
	},
}
local wallet_text_font_style = table.clone(UIFontSettings.currency_title)

wallet_text_font_style.text_horizontal_alignment = "right"
wallet_text_font_style.text_vertical_alignment = "center"
wallet_text_font_style.offset = {
	ViewElementWalletSettings.icon_size[1] + ViewElementWalletSettings.text_margin,
	0,
	1,
}
wallet_text_font_style.font_size = 18

local widget_definitions = {}
local wallet_definitions = UIWidget.create_definition({
	{
		pass_type = "texture",
		style_id = "texture",
		value_id = "texture",
		style = {
			horizontal_alignment = "right",
			vertical_alignment = "center",
			size = ViewElementWalletSettings.icon_size,
			offset = {
				0,
				0,
				1,
			},
		},
		visibility_function = function (content, style)
			return not not content.texture
		end,
	},
	{
		pass_type = "text",
		style_id = "text",
		value = "",
		value_id = "text",
		style = wallet_text_font_style,
	},
}, "wallet_area")

return {
	widget_definitions = widget_definitions,
	wallet_definitions = wallet_definitions,
	scenegraph_definition = scenegraph_definition,
}
