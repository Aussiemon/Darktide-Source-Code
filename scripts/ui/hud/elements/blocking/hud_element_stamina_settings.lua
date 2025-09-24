-- chunkname: @scripts/ui/hud/elements/blocking/hud_element_stamina_settings.lua

local UIHudSettings = require("scripts/settings/ui/ui_hud_settings")
local hud_element_stamina_settings = {
	center_offset = 210,
	half_distance = 1,
	max_glow_alpha = 130,
	spacing = 2,
	stamina_spent_delay = 0.25,
	stamina_spent_drain_speed = 1,
	stamina_spent_threshold = 0.05,
	bar_size = {
		200,
		8,
	},
	area_size = {
		220,
		40,
	},
	STAMINA_BAR_BACKGROUND_COLOR = {
		0,
		UIHudSettings.color_tint_alert_2[2],
		UIHudSettings.color_tint_alert_2[3],
		UIHudSettings.color_tint_alert_2[4],
	},
	STAMINA_NODGES_COLOR = {
		filled = Color.terminal_text_body_dark(255, true),
		empty = Color.terminal_text_body_sub_header(255, true),
	},
	STAMINA_BAR_COLOR = {
		background = {
			125,
			UIHudSettings.color_tint_0[2],
			UIHudSettings.color_tint_0[3],
			UIHudSettings.color_tint_0[4],
		},
		spent = {
			75,
			UIHudSettings.color_tint_1[2],
			UIHudSettings.color_tint_1[3],
			UIHudSettings.color_tint_1[4],
		},
		fill = UIHudSettings.color_tint_main_1,
	},
}

return settings("HudElementStaminaSettings", hud_element_stamina_settings)
