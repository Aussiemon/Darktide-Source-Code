local hud_element_boss_toughness_settings = {
	duration_health_ghost = 1,
	alpha_fade_delay = 2.6,
	alpha_fade_duration = 0.6,
	animate_on_health_increase = false,
	health_animation_threshold = 0.1,
	duration_health = 5,
	alpha_fade_min_value = 50,
	size = {
		640,
		6
	},
	size_small = {
		305,
		6
	}
}

return settings("HudElementBossToughnessSettings", hud_element_boss_toughness_settings)
