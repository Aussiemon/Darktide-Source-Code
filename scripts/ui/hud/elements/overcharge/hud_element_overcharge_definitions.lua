-- chunkname: @scripts/ui/hud/elements/overcharge/hud_element_overcharge_definitions.lua

local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIHudSettings = require("scripts/settings/ui/ui_hud_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	overheat = {
		horizontal_alignment = "center",
		parent = "screen",
		vertical_alignment = "center",
		size = {
			20,
			119,
		},
		position = {
			0,
			155,
			0,
		},
	},
	warp_charge = {
		horizontal_alignment = "center",
		parent = "screen",
		vertical_alignment = "center",
		size = {
			20,
			119,
		},
		position = {
			0,
			155,
			0,
		},
	},
}
local overheat_text_style = table.clone(UIFontSettings.hud_body)

overheat_text_style.offset = {
	-30,
	0,
	3,
}
overheat_text_style.size = {
	500,
	50,
}
overheat_text_style.vertical_alignment = "top"
overheat_text_style.horizontal_alignment = "right"
overheat_text_style.text_horizontal_alignment = "right"
overheat_text_style.text_vertical_alignment = "top"
overheat_text_style.text_color = UIHudSettings.color_tint_main_2
overheat_text_style.font_type = "machine_medium"

local overheat_numeral_text_style = table.clone(UIFontSettings.hud_body)

overheat_numeral_text_style.offset = {
	-30,
	20,
	3,
}
overheat_numeral_text_style.size = {
	500,
	50,
}
overheat_numeral_text_style.vertical_alignment = "top"
overheat_numeral_text_style.horizontal_alignment = "right"
overheat_numeral_text_style.text_horizontal_alignment = "right"
overheat_numeral_text_style.text_vertical_alignment = "top"
overheat_numeral_text_style.text_color = UIHudSettings.color_tint_alert_2
overheat_numeral_text_style.font_type = "machine_medium"

local warp_charge_numeral_text_style = table.clone(overheat_numeral_text_style)

warp_charge_numeral_text_style.offset = {
	0,
	0,
	3,
}
warp_charge_numeral_text_style.vertical_alignment = "center"
warp_charge_numeral_text_style.horizontal_alignment = "center"
warp_charge_numeral_text_style.text_horizontal_alignment = "center"
warp_charge_numeral_text_style.text_vertical_alignment = "center"
warp_charge_numeral_text_style.font_size_threshold = {
	{
		animation_size_fraction = 0.25,
		font_size = 40,
		threshold = 0,
		color = Color.ui_hud_warp_charge_low(153, true),
	},
	{
		animation_size_fraction = 0.25,
		font_size = 50,
		threshold = 0.5,
		color = Color.ui_hud_warp_charge_medium(153, true),
	},
	{
		animation_size_fraction = 0.25,
		font_size = 55,
		threshold = 0.97,
		color = Color.ui_hud_warp_charge_high(153, true),
	},
}

local widget_definitions = {
	overheat = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "warning_text",
			value = "999%",
			value_id = "warning_text",
			style = warp_charge_numeral_text_style,
		},
	}, "overheat"),
	warp_charge = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "warning_text",
			value = "999%",
			value_id = "warning_text",
			style = warp_charge_numeral_text_style,
		},
	}, "warp_charge"),
}

return {
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
}
