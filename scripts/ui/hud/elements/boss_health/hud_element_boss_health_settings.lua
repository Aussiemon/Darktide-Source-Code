-- chunkname: @scripts/ui/hud/elements/boss_health/hud_element_boss_health_settings.lua

local hud_element_boss_health_settings = {
	duration_health_ghost = 4.5,
	alpha_fade_delay = 2.6,
	edge_offset = 36,
	alpha_fade_duration = 0.6,
	animate_on_health_increase = false,
	health_animation_threshold = 0.05,
	duration_health = 5,
	alpha_fade_min_value = 50,
	size = {
		640,
		8
	},
	size_small = {
		305,
		8
	}
}

return settings("HudElementBossHealthSettings", hud_element_boss_health_settings)
