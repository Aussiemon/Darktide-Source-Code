-- chunkname: @scripts/settings/equipment/weapon_templates/thumpers/settings_templates/thumper_spread_templates.lua

local spread_templates = {}
local overrides = {}

table.make_unique(spread_templates)
table.make_unique(overrides)

spread_templates.default_thumper_assault = {
	still = {
		randomized_spread = {
			first_shot_min_ratio = 0.15,
			first_shot_random_ratio = 0.3,
			max_pitch_delta = 1,
			max_yaw_delta = 1,
			min_ratio = 0.2,
			random_ratio = 0.3,
		},
		max_spread = {
			pitch = 20,
			yaw = 20,
		},
		decay = {
			from_shooting_grace_time = 0.15,
			shooting = {
				pitch = 0.25,
				yaw = 0.25,
			},
			idle = {
				pitch = 1,
				yaw = 1,
			},
		},
		continuous_spread = {
			min_pitch = 5,
			min_yaw = 6.25,
		},
		start_spread = {
			start_pitch = 5,
			start_yaw = 6.25,
		},
		immediate_spread = {
			num_shots_clear_time = 0.75,
			damage_hit = {
				{
					pitch = 1.5,
					yaw = 1.5,
				},
			},
			shooting = {
				{
					pitch = 1,
					yaw = 1.25,
				},
			},
		},
	},
	moving = {
		inherits = {
			"default_thumper_assault",
			"still",
		},
	},
	crouch_still = {
		inherits = {
			"default_thumper_assault",
			"still",
		},
	},
	crouch_moving = {
		inherits = {
			"default_thumper_assault",
			"still",
		},
	},
}
spread_templates.thumper_shotgun_hip_assault = {
	still = {
		randomized_spread = {
			first_shot_min_ratio = 0.1,
			first_shot_random_ratio = 0.2,
			min_ratio = 0.1,
			random_ratio = 0.2,
		},
		max_spread = {
			pitch = 20,
			yaw = 20,
		},
		decay = {
			from_shooting_grace_time = 0.15,
			shooting = {
				pitch = 0.25,
				yaw = 0.25,
			},
			idle = {
				pitch = 1,
				yaw = 1,
			},
		},
		continuous_spread = {
			min_pitch = 6,
			min_yaw = 9,
		},
		immediate_spread = {
			num_shots_clear_time = 0.75,
			damage_hit = {
				{
					pitch = 1.5,
					yaw = 1.5,
				},
			},
			shooting = {
				{
					pitch = 1,
					yaw = 1.25,
				},
			},
		},
	},
	moving = {
		inherits = {
			"thumper_shotgun_hip_assault",
			"still",
		},
	},
	crouch_still = {
		inherits = {
			"thumper_shotgun_hip_assault",
			"still",
		},
	},
	crouch_moving = {
		inherits = {
			"thumper_shotgun_hip_assault",
			"still",
		},
	},
}
spread_templates.thumper_shotgun_aim = {
	still = {
		randomized_spread = {
			first_shot_min_ratio = 0.001,
			first_shot_random_ratio = 0.002,
			min_ratio = 0.001,
			random_ratio = 0.002,
		},
		max_spread = {
			pitch = 20,
			yaw = 20,
		},
		decay = {
			from_shooting_grace_time = 0.15,
			shooting = {
				pitch = 0.25,
				yaw = 0.25,
			},
			idle = {
				pitch = 1,
				yaw = 1,
			},
		},
		continuous_spread = {
			min_pitch = 4,
			min_yaw = 6,
		},
		immediate_spread = {
			num_shots_clear_time = 0.75,
			damage_hit = {
				{
					pitch = 1.5,
					yaw = 1.5,
				},
			},
			shooting = {
				{
					pitch = 1,
					yaw = 1.25,
				},
			},
		},
	},
	moving = {
		inherits = {
			"thumper_shotgun_aim",
			"still",
		},
	},
	crouch_still = {
		inherits = {
			"thumper_shotgun_aim",
			"still",
		},
	},
	crouch_moving = {
		inherits = {
			"thumper_shotgun_aim",
			"still",
		},
	},
}
spread_templates.thumper_hip_assault = {
	still = {
		randomized_spread = {
			first_shot_min_ratio = 0.15,
			first_shot_random_ratio = 0.45,
			max_pitch_delta = 1,
			max_yaw_delta = 1,
			min_ratio = 0.2,
			random_ratio = 0.8,
		},
		max_spread = {
			pitch = 1,
			yaw = 1,
		},
		decay = {
			from_shooting_grace_time = 0.15,
			shooting = {
				pitch = 0.25,
				yaw = 0.25,
			},
			idle = {
				pitch = 1,
				yaw = 1,
			},
		},
		continuous_spread = {
			min_pitch = 3,
			min_yaw = 4.25,
		},
		start_spread = {
			start_pitch = 3,
			start_yaw = 4.25,
		},
		immediate_spread = {
			num_shots_clear_time = 0.75,
			damage_hit = {
				{
					pitch = 1.5,
					yaw = 1.5,
				},
			},
			shooting = {
				{
					pitch = 1,
					yaw = 1.25,
				},
			},
		},
	},
	moving = {
		inherits = {
			"thumper_hip_assault",
			"still",
		},
	},
	crouch_still = {
		inherits = {
			"thumper_hip_assault",
			"still",
		},
	},
	crouch_moving = {
		inherits = {
			"thumper_hip_assault",
			"still",
		},
	},
}
spread_templates.thumper_aim_demolition = {
	still = {
		randomized_spread = {
			first_shot_min_ratio = 0.1,
			first_shot_random_ratio = 1,
			max_pitch_delta = 1,
			max_yaw_delta = 1,
			min_ratio = 0.2,
			random_ratio = 0.8,
		},
		max_spread = {
			pitch = 20,
			yaw = 20,
		},
		decay = {
			from_shooting_grace_time = 0.15,
			shooting = {
				pitch = 0.25,
				yaw = 0.25,
			},
			idle = {
				pitch = 1,
				yaw = 1,
			},
		},
		continuous_spread = {
			min_pitch = 0,
			min_yaw = 0,
		},
		immediate_spread = {
			num_shots_clear_time = 0.75,
			damage_hit = {
				{
					pitch = 1.5,
					yaw = 1.5,
				},
			},
			shooting = {
				{
					pitch = 5,
					yaw = 5.25,
				},
			},
		},
	},
	moving = {
		inherits = {
			"thumper_aim_demolition",
			"still",
		},
	},
	crouch_still = {
		inherits = {
			"thumper_aim_demolition",
			"still",
		},
	},
	crouch_moving = {
		inherits = {
			"thumper_aim_demolition",
			"still",
		},
	},
}
spread_templates.thumper_m3_aim = {
	still = {
		randomized_spread = {
			first_shot_min_ratio = 0.5,
			first_shot_random_ratio = 0.5,
			max_pitch_delta = 1,
			max_yaw_delta = 1,
			min_ratio = 0.25,
			random_ratio = 0.75,
		},
		max_spread = {
			pitch = {
				lerp_basic = 4,
				lerp_perfect = 3,
			},
			yaw = {
				lerp_basic = 4,
				lerp_perfect = 3,
			},
		},
		decay = {
			from_shooting_grace_time = 0.2,
			shooting = {
				pitch = 0.05,
				yaw = 0.05,
			},
			idle = {
				pitch = 1,
				yaw = 1,
			},
		},
		continuous_spread = {
			min_pitch = {
				lerp_basic = 1.5,
				lerp_perfect = 0.25,
			},
			min_yaw = {
				lerp_basic = 1.5,
				lerp_perfect = 0.25,
			},
		},
		immediate_spread = {
			num_shots_clear_time = 0.25,
			damage_hit = {
				{
					pitch = {
						lerp_basic = 0.5,
						lerp_perfect = 0.3,
					},
					yaw = {
						lerp_basic = 0.5,
						lerp_perfect = 0.3,
					},
				},
			},
			shooting = {
				{
					pitch = {
						lerp_basic = 4,
						lerp_perfect = 1.25,
					},
					yaw = {
						lerp_basic = 4,
						lerp_perfect = 1.25,
					},
				},
			},
		},
	},
	moving = {
		inherits = {
			"thumper_m3_hip",
			"still",
		},
		continuous_spread = {
			min_pitch = {
				lerp_basic = 1.5,
				lerp_perfect = 1,
			},
			min_yaw = {
				lerp_basic = 2,
				lerp_perfect = 1.5,
			},
		},
	},
	crouch_still = {
		inherits = {
			"thumper_m3_hip",
			"still",
		},
		continuous_spread = {
			min_pitch = {
				lerp_basic = 1,
				lerp_perfect = 0.1,
			},
			min_yaw = {
				lerp_basic = 1.5,
				lerp_perfect = 0.4,
			},
		},
	},
	crouch_moving = {
		inherits = {
			"thumper_m3_hip",
			"still",
		},
	},
}
spread_templates.thumper_m3_hip = {
	still = {
		max_spread = {
			pitch = 5,
			yaw = 5,
		},
		randomized_spread = {
			first_shot_min_ratio = 0.3,
			first_shot_random_ratio = 0.5,
			min_ratio = 0.25,
			random_ratio = 0.75,
		},
		decay = {
			from_shooting_grace_time = 0.3,
			shooting = {
				pitch = 0.5,
				yaw = 0.5,
			},
			idle = {
				pitch = 1.75,
				yaw = 1.75,
			},
		},
		continuous_spread = {
			min_pitch = {
				lerp_basic = 2.3,
				lerp_perfect = 1.4,
			},
			min_yaw = {
				lerp_basic = 2.3,
				lerp_perfect = 1.4,
			},
		},
		immediate_spread = {
			damage_hit = {
				{
					pitch = 0.4,
					yaw = 0.4,
				},
			},
			shooting = {
				{
					pitch = {
						lerp_basic = 4,
						lerp_perfect = 1.25,
					},
					yaw = {
						lerp_basic = 4,
						lerp_perfect = 1.25,
					},
				},
			},
			num_shots_clear_time = {
				lerp_basic = 0.1,
				lerp_perfect = 0.1,
			},
		},
	},
	moving = {
		inherits = {
			"thumper_m3_aim",
			"still",
		},
		continuous_spread = {
			min_pitch = {
				lerp_basic = 3.5,
				lerp_perfect = 2,
			},
			min_yaw = {
				lerp_basic = 3.5,
				lerp_perfect = 2,
			},
		},
	},
	crouch_still = {
		inherits = {
			"thumper_m3_aim",
			"still",
		},
		continuous_spread = {
			min_pitch = {
				lerp_basic = 1.6,
				lerp_perfect = 1.25,
			},
			min_yaw = {
				lerp_basic = 1.6,
				lerp_perfect = 1.25,
			},
		},
	},
	crouch_moving = {
		inherits = {
			"thumper_m3_aim",
			"still",
		},
		continuous_spread = {
			min_pitch = {
				lerp_basic = 3,
				lerp_perfect = 2.1,
			},
			min_yaw = {
				lerp_basic = 3,
				lerp_perfect = 2.1,
			},
		},
	},
}

return {
	base_templates = spread_templates,
	overrides = overrides,
}
