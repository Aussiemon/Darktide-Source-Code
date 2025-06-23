-- chunkname: @scripts/settings/character_state/character_state_netted_settings.lua

local character_state_netted_settings = {}

character_state_netted_settings.anim_settings = {
	dragged_anim_event = "netted_dragged",
	netted_1p_anim_event = "netted",
	netted_3p_anim_event = "to_netted"
}

local DEFAULT_DRAG_SPEED = 10

character_state_netted_settings.breed_specific_settings = {
	human = {
		max_slowdown_factor = 1,
		min_slowdown_factor = 0.15,
		slowdown_distance = 4,
		drag_speed = DEFAULT_DRAG_SPEED
	},
	ogryn = {
		max_slowdown_factor = 1,
		min_slowdown_factor = 0.15,
		slowdown_distance = 5,
		drag_speed = DEFAULT_DRAG_SPEED
	}
}

return settings("CharacterStateNettedSettings", character_state_netted_settings)
