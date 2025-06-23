-- chunkname: @scripts/managers/world_interaction/world_interaction_settings.lua

local world_interaction_settings = {
	foliage = {
		local_player_multiplier = 2,
		duplicate_edge_cases = false,
		shading_env_variable = "world_interaction_window_size",
		window_size = 30,
		default_foliage_material = "content/materials/default_foliage_deform",
		default_texture_world_size = {
			1.5,
			1.5
		}
	},
	water = {
		default_ripple_timer = 2,
		random_ripple_size_diff = 0.5,
		default_ripple_multiplier = 6,
		default_ripple_material = "content/materials/default_water_ripple",
		duplicate_edge_cases = true,
		water_speed_limit = 2,
		ripple_sound_event_delay = 0.3,
		max_contributing_units = 50,
		ripple_time_step = 0.1,
		shading_env_variable = "world_interaction_water_window_size",
		debug_water = false,
		window_size = 30,
		ripple_sound_event = "Play_environment_water_trigger",
		default_ripple_start_size = {
			0.5,
			0.5
		},
		ripple_stretch_multiplier = {
			1,
			2
		},
		splash = {
			timer_ref = 4,
			multiplier = 40,
			default_material = "content/materials/default_water_ripple_circle",
			random_size_diff = 0.5,
			start_size = {
				0.2,
				0.2
			},
			stretch_multiplier = {
				1,
				1
			}
		}
	}
}

return settings("WorldInteractionSettings", world_interaction_settings)
