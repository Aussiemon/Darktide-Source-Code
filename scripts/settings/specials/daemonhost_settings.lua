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
	255,
	50,
	118
}
local daemonhost_settings = {
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
		on_screen_effect = {
			particle_effect = "content/fx/particles/screenspace/screen_daemonhost_distortion",
			scalar_multiplier = 0.1,
			distance_max = 20,
			distance_min = 5
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
				distance = 7,
				threat = 1000
			}
		},
		not_passive = {
			{
				flat = 75,
				tick = 8,
				distance = 7,
				threat = 250
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

return settings("DaemonhostSettings", daemonhost_settings)
