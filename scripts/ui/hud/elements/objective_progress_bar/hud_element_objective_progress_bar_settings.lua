-- chunkname: @scripts/ui/hud/elements/objective_progress_bar/hud_element_objective_progress_bar_settings.lua

local hud_element_objective_progress_bar_settings = {
	alpha_fade_delay = 2.6,
	alpha_fade_duration = 0.6,
	alpha_fade_min_value = 50,
	animate_on_health_increase = false,
	duration_health = 5,
	duration_health_ghost = 4.5,
	edge_offset = -40,
	health_animation_threshold = 0.05,
	size = {
		800,
		12,
	},
}

return settings("HudElementObjectiveProgressBarSettings", hud_element_objective_progress_bar_settings)
