local UIHudSettings = require("scripts/settings/ui/ui_hud_settings")
local color_tint_6 = UIHudSettings.color_tint_6
local hud_element_player_toughness_settings = {
	duration_health = 5,
	alpha_fade_delay = 2.6,
	edge_offset = -70,
	alpha_fade_duration = 0.6,
	duration_health_ghost = 1,
	critical_health_threshold = 0.33,
	animate_on_health_increase = true,
	health_animation_threshold = 0.1,
	alpha_fade_min_value = 50,
	size = {
		400,
		16
	},
	critical_health_color = color_tint_6,
	default_health_color = color_tint_6
}

return settings("HudElementPlayerToughnessSettings", hud_element_player_toughness_settings)
