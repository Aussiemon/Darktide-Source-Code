-- chunkname: @scripts/ui/hud/elements/boss_health/hud_element_boss_name_settings.lua

local UIHudSettings = require("scripts/settings/ui/ui_hud_settings")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local style = table.clone(UIFontSettings.hud_body)

style.text_vertical_alignment = "center"
style.text_horizontal_alignment = "center"
style.font_type = "machine_medium"
style.font_size = 22
style.text_color = UIHudSettings.color_tint_alert_2

local hud_element_boss_name_settings = {
	size = {
		720,
		32,
	},
	style = style,
}

return settings("HudElementBossNameSettings", hud_element_boss_name_settings)
