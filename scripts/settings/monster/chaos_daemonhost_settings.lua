-- chunkname: @scripts/settings/monster/chaos_daemonhost_settings.lua

local STAGES = {
	about_to_wake_up = 4,
	aggroed = 6,
	agitated = 2,
	death_leave = 8,
	death_normal = 7,
	disturbed = 3,
	passive = 1,
	waking_up = 5,
}
local DEFAULT_LIGHT_COLOR = {
	191,
	255,
	0,
}
local chaos_daemonhost_settings = {
	stages = STAGES,
	ambience = {
		light_name = "light",
		[STAGES.passive] = {
			emissive_material_intensity = 0,
			color = DEFAULT_LIGHT_COLOR,
			light_intensity = {
				max = 0,
				min = 0,
				multiplier = 0,
			},
			light_radius = {
				max = 0,
				min = 0,
			},
			pulse = {
				frequency = 0,
				speed = 0,
			},
			sfx_distortion = {
				distance_multiplier = 1,
			},
		},
		[STAGES.agitated] = {
			emissive_material_intensity = 0.5,
			color = DEFAULT_LIGHT_COLOR,
			light_intensity = {
				max = 8,
				min = 3,
				multiplier = 40,
			},
			light_radius = {
				max = 15,
				min = 5,
			},
			pulse = {
				frequency = 1,
				speed = 2,
			},
			sfx_distortion = {
				distance_multiplier = 1,
			},
		},
		[STAGES.disturbed] = {
			emissive_material_intensity = 0.75,
			color = DEFAULT_LIGHT_COLOR,
			light_intensity = {
				max = 11,
				min = 4,
				multiplier = 40,
			},
			light_radius = {
				max = 15,
				min = 5,
			},
			pulse = {
				frequency = 4,
				speed = 3,
			},
			sfx_distortion = {
				distance_multiplier = 1,
			},
		},
		[STAGES.about_to_wake_up] = {
			emissive_material_intensity = 1,
			color = DEFAULT_LIGHT_COLOR,
			light_intensity = {
				max = 13,
				min = 5,
				multiplier = 40,
			},
			light_radius = {
				max = 15,
				min = 5,
			},
			pulse = {
				frequency = 5,
				speed = 5,
			},
			sfx_distortion = {
				distance_multiplier = 1,
			},
		},
		[STAGES.waking_up] = {
			emissive_material_intensity = 1,
			color = DEFAULT_LIGHT_COLOR,
			light_intensity = {
				max = 14,
				min = 6,
				multiplier = 100,
			},
			light_radius = {
				max = 15,
				min = 5,
			},
			pulse = {
				frequency = 5,
				speed = 5,
			},
			sfx_distortion = {
				distance_multiplier = 1,
			},
		},
		[STAGES.aggroed] = {
			emissive_material_intensity = 1,
			color = DEFAULT_LIGHT_COLOR,
			light_intensity = {
				max = 12,
				min = 5,
				multiplier = 100,
			},
			light_radius = {
				max = 10,
				min = 8,
			},
			pulse = {
				frequency = 0,
				speed = 0,
			},
			sfx_distortion = {
				distance_multiplier = 1,
			},
		},
		screen_effect_distortion = {
			distance_max = 20,
			distance_min = 5,
			particle_effect = "content/fx/particles/screenspace/screen_daemonhost_distortion",
			scalar_multiplier = 0.1,
		},
		screen_effect_frost = {
			distance_max = 23,
			distance_min = 8,
			lerp_speed = 1,
			particle_effect = "content/fx/particles/screenspace/player_screen_deamonhost_frost",
			passive_distance_max = 9,
			passive_distance_min = 4,
			scalar_multiplier = 1,
			waking_up_lerp_speed = 3,
		},
		fog_effect = {
			particle_effect = "content/fx/particles/enemies/daemonhost/daemonhost_ambient_fog",
		},
	},
	death = {
		[STAGES.death_leave] = {
			alpha_clip = {
				delay = 3.1666666666666665,
				material_scalar_key = "hide_from_top",
				material_variable_key = "body",
				speed = 0.6,
			},
		},
	},
	anger_distances = {
		passive = {
			{
				distance = 7.5,
				flat = 1,
				threat = 1000,
				tick = 1,
			},
		},
		not_passive = {
			{
				distance = 3.5,
				flat = 100,
				sprint_flat_bonus = 100,
				threat = 250,
				tick = 8,
			},
			{
				distance = 7,
				flat = 80,
				sprint_flat_bonus = 100,
				threat = 250,
				tick = 10,
			},
			{
				distance = 12,
				flat = 50,
				threat = 100,
				tick = 6,
			},
			{
				distance = 20,
				flat = 20,
			},
		},
	},
	num_player_kills_for_despawn = {
		1,
		1,
		1,
		1,
		1,
	},
}

return settings("ChaosDaemonhostSettings", chaos_daemonhost_settings)
