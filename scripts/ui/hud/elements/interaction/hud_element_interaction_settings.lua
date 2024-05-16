-- chunkname: @scripts/ui/hud/elements/interaction/hud_element_interaction_settings.lua

local input_box_height = 40
local background_size = {
	400,
	input_box_height * 3,
}
local hud_element_interaction_settings = {
	max_spawn_distance_sq = 1000,
	progress_complete_anim_duration = 1,
	scan_delay = 0.3,
	edge_spacing = {
		22,
		10,
	},
	input_box_height = input_box_height,
	background_size = {
		background_size[1],
		background_size[2] - 20,
	},
	background_size_small = {
		background_size[1],
		40,
	},
}

return settings("HudElementInteractionSettings", hud_element_interaction_settings)
