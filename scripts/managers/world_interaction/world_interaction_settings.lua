-- chunkname: @scripts/managers/world_interaction/world_interaction_settings.lua

local WorldInteractionSettings = {
	foliage = {
		default_foliage_material = "content/materials/default_foliage_deform",
		duplicate_edge_cases = false,
		local_player_multiplier = 2,
		shading_env_variable = "world_interaction_window_size",
		window_size = 30,
		default_texture_world_size = {
			1.5,
			1.5,
		},
	},
	water = {
		debug_water = false,
		default_ripple_material = "content/materials/default_water_ripple",
		default_ripple_multiplier = 6,
		default_ripple_timer = 2,
		duplicate_edge_cases = true,
		max_contributing_units = 50,
		random_ripple_size_diff = 0.5,
		ripple_sound_event = "Play_environment_water_trigger",
		ripple_sound_event_delay = 0.3,
		ripple_time_step = 0.1,
		shading_env_variable = "world_interaction_water_window_size",
		water_speed_limit = 2,
		window_size = 30,
		default_ripple_start_size = {
			0.5,
			0.5,
		},
		ripple_stretch_multiplier = {
			1,
			2,
		},
		splash = {
			default_material = "content/materials/default_water_ripple_circle",
			multiplier = 40,
			random_size_diff = 0.5,
			timer_ref = 4,
			start_size = {
				0.2,
				0.2,
			},
			stretch_multiplier = {
				1,
				1,
			},
		},
	},
}

return WorldInteractionSettings
