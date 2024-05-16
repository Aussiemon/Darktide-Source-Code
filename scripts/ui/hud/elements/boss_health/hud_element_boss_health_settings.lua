-- chunkname: @scripts/ui/hud/elements/boss_health/hud_element_boss_health_settings.lua

local hud_element_boss_health_settings = {
	alpha_fade_delay = 2.6,
	alpha_fade_duration = 0.6,
	alpha_fade_min_value = 50,
	animate_on_health_increase = false,
	duration_health = 5,
	duration_health_ghost = 4.5,
	edge_offset = 36,
	health_animation_threshold = 0.05,
	size = {
		640,
		8,
	},
	size_small = {
		305,
		8,
	},
}

return settings("HudElementBossHealthSettings", hud_element_boss_health_settings)
