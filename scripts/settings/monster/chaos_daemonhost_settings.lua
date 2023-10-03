local STAGES = {
	passive = 1,
	aggroed = 6,
	about_to_wake_up = 4,
	disturbed = 3,
	waking_up = 5,
	agitated = 2,
	death_normal = 7,
	death_leave = 8
}
local DEFAULT_LIGHT_COLOR = {
	191,
	255,
	0
}
local chaos_daemonhost_settings = {
	stages = STAGES,
	ambience = {
		light_name = "light",
		[STAGES.passive] = {
			emissive_material_intensity = 0,
			color = DEFAULT_LIGHT_COLOR,
			light_intensity = {
				multiplier = 0,
				min = 0,
				max = 0
			},
			light_radius = {
				max = 0,
				min = 0
			},
			pulse = {
				speed = 0,
				frequency = 0
			},
			sfx_distortion = {
				distance_multiplier = 1
			}
		},
		[STAGES.agitated] = {
			emissive_material_intensity = 0.5,
			color = DEFAULT_LIGHT_COLOR,
			light_intensity = {
				multiplier = 40,
				min = 3,
				max = 8
			},
			light_radius = {
				max = 15,
				min = 5
			},
			pulse = {
				speed = 2,
				frequency = 1
			},
			sfx_distortion = {
				distance_multiplier = 1
			}
		},
		[STAGES.disturbed] = {
			emissive_material_intensity = 0.75,
			color = DEFAULT_LIGHT_COLOR,
			light_intensity = {
				multiplier = 40,
				min = 4,
				max = 11
			},
			light_radius = {
				max = 15,
				min = 5
			},
			pulse = {
				speed = 3,
				frequency = 4
			},
			sfx_distortion = {
				distance_multiplier = 1
			}
		},
		[STAGES.about_to_wake_up] = {
			emissive_material_intensity = 1,
			color = DEFAULT_LIGHT_COLOR,
			light_intensity = {
				multiplier = 40,
				min = 5,
				max = 13
			},
			light_radius = {
				max = 15,
				min = 5
			},
			pulse = {
				speed = 5,
				frequency = 5
			},
			sfx_distortion = {
				distance_multiplier = 1
			}
		},
		[STAGES.waking_up] = {
			emissive_material_intensity = 1,
			color = DEFAULT_LIGHT_COLOR,
			light_intensity = {
				multiplier = 100,
				min = 6,
				max = 14
			},
			light_radius = {
				max = 15,
				min = 5
			},
			pulse = {
				speed = 5,
				frequency = 5
			},
			sfx_distortion = {
				distance_multiplier = 1
			}
		},
		[STAGES.aggroed] = {
			emissive_material_intensity = 1,
			color = DEFAULT_LIGHT_COLOR,
			light_intensity = {
				multiplier = 100,
				min = 5,
				max = 12
			},
			light_radius = {
				max = 10,
				min = 8
			},
			pulse = {
				speed = 0,
				frequency = 0
			},
			sfx_distortion = {
				distance_multiplier = 1
			}
		},
		screen_effect_distortion = {
			particle_effect = "content/fx/particles/screenspace/screen_daemonhost_distortion",
			scalar_multiplier = 0.1,
			distance_max = 20,
			distance_min = 5
		},
		screen_effect_frost = {
			particle_effect = "content/fx/particles/screenspace/player_screen_deamonhost_frost",
			passive_distance_max = 9,
			lerp_speed = 1,
			passive_distance_min = 4,
			scalar_multiplier = 1,
			waking_up_lerp_speed = 3,
			distance_max = 23,
			distance_min = 8
		},
		fog_effect = {
			particle_effect = "content/fx/particles/enemies/daemonhost/daemonhost_ambient_fog"
		}
	},
	death = {
		[STAGES.death_leave] = {
			alpha_clip = {
				delay = 3.1666666666666665,
				material_variable_key = "body",
				material_scalar_key = "hide_from_top",
				speed = 0.6
			}
		}
	},
	anger_distances = {
		passive = {
			{
				flat = 1,
				tick = 1,
				distance = 7.5,
				threat = 1000
			}
		},
		not_passive = {
			{
				flat = 100,
				sprint_flat_bonus = 100,
				distance = 3.5,
				threat = 250,
				tick = 8
			},
			{
				flat = 80,
				sprint_flat_bonus = 100,
				distance = 7,
				threat = 250,
				tick = 10
			},
			{
				flat = 50,
				tick = 6,
				distance = 12,
				threat = 100
			},
			{
				distance = 20,
				flat = 20
			}
		}
	},
	num_player_kills_for_despawn = {
		1,
		2,
		2,
		2,
		2
	}
}

return settings("ChaosDaemonhostSettings", chaos_daemonhost_settings)
