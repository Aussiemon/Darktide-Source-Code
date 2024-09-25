-- chunkname: @scripts/ui/hud/elements/objective_progress_bar/hud_element_objective_text_settings.lua

local UIHudSettings = require("scripts/settings/ui/ui_hud_settings")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local style = table.clone(UIFontSettings.hud_body)

style.text_vertical_alignment = "center"
style.text_horizontal_alignment = "center"
style.font_type = "machine_medium"
style.font_size = 22
style.text_color = UIHudSettings.color_tint_main_1

local hud_element_objective_text_settings = {
	size = {
		720,
		32,
	},
	style = style,
}

return settings("HudElementObjectiveTextSettings", hud_element_objective_text_settings)
