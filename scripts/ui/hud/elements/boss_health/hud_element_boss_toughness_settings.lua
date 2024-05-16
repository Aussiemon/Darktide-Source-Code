-- chunkname: @scripts/ui/hud/elements/boss_health/hud_element_boss_toughness_settings.lua

local hud_element_boss_toughness_settings = {
	alpha_fade_delay = 2.6,
	alpha_fade_duration = 0.6,
	alpha_fade_min_value = 50,
	animate_on_health_increase = false,
	duration_health = 5,
	duration_health_ghost = 1,
	health_animation_threshold = 0.1,
	size = {
		640,
		6,
	},
	size_small = {
		305,
		5,
	},
}

return settings("HudElementBossToughnessSettings", hud_element_boss_toughness_settings)
