-- chunkname: @scripts/ui/hud/elements/player_health/hud_element_player_toughness_settings.lua

local UIHudSettings = require("scripts/settings/ui/ui_hud_settings")
local color_tint_6 = UIHudSettings.color_tint_6
local hud_element_player_toughness_settings = {
	alpha_fade_delay = 2.6,
	alpha_fade_duration = 0.6,
	alpha_fade_min_value = 50,
	animate_on_health_increase = true,
	critical_health_threshold = 0.33,
	duration_health = 5,
	duration_health_ghost = 1,
	edge_offset = -70,
	health_animation_threshold = 0.1,
	size = {
		400,
		16,
	},
	critical_health_color = color_tint_6,
	default_health_color = color_tint_6,
}

return settings("HudElementPlayerToughnessSettings", hud_element_player_toughness_settings)
