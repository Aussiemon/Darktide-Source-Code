-- chunkname: @scripts/ui/hud/elements/dodge_counter/hud_element_dodge_counter_settings.lua

local UIHudSettings = require("scripts/settings/ui/ui_hud_settings")
local hud_element_dodge_counter_settings = {
	center_offset = 229,
	half_distance = 1,
	max_glow_alpha = 130,
	spacing = 4,
	bar_size = {
		200,
		6,
	},
	area_size = {
		220,
		40,
	},
	DODGE_STATE_COLORS_OVERLAP_BAR = {
		hidden = {
			0,
			UIHudSettings.color_tint_alert_2[2],
			UIHudSettings.color_tint_alert_2[3],
			UIHudSettings.color_tint_alert_2[4],
		},
		inefficient_dodge = UIHudSettings.color_tint_alert_2,
	},
	DODGE_BAR_STATE_COLORS_BAR_FILL = {
		spent = {
			0,
			0,
			0,
			0,
		},
		available_on_cooldown = UIHudSettings.color_tint_main_3,
		available = UIHudSettings.color_tint_main_1,
	},
	DODGE_BAR_STATE_COLORS_BAR_BACKGROUND = {
		hidden = {
			0,
			0,
			0,
			0,
		},
		on_cooldown = {
			125,
			UIHudSettings.color_tint_0[2],
			UIHudSettings.color_tint_0[3],
			UIHudSettings.color_tint_0[4],
		},
		default = {
			125,
			UIHudSettings.color_tint_0[2],
			UIHudSettings.color_tint_0[3],
			UIHudSettings.color_tint_0[4],
		},
	},
}

return settings("HudElementDodgeCounterSettings", hud_element_dodge_counter_settings)
