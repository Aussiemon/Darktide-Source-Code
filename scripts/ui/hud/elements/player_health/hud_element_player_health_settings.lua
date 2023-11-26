-- chunkname: @scripts/ui/hud/elements/player_health/hud_element_player_health_settings.lua

local UIHudSettings = require("scripts/settings/ui/ui_hud_settings")
local color_tint_0 = UIHudSettings.color_tint_0
local color_tint_1 = UIHudSettings.color_tint_1
local color_tint_2 = UIHudSettings.color_tint_2
local hud_element_player_health_settings = {
	duration_health = 5,
	alpha_fade_delay = 2.6,
	edge_offset = -50,
	alpha_fade_duration = 0.6,
	duration_health_ghost = 4.5,
	critical_health_threshold = 0.33,
	animate_on_health_increase = true,
	health_animation_threshold = 0.05,
	alpha_fade_min_value = 50,
	size = {
		400,
		16
	},
	critical_health_color = color_tint_1,
	default_health_color = color_tint_1
}

return settings("HudElementPlayerHealthSettings", hud_element_player_health_settings)
