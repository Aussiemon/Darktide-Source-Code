-- chunkname: @scripts/settings/equipment/weapon_templates/phosphor_pistol/settings_templates/phosphor_pistol_spread_templates.lua

local spread_templates = {}
local overrides = {}

table.make_unique(spread_templates)
table.make_unique(overrides)

spread_templates.phosphor_pistol_p1_m1_spread_hip = {
	still = {
		max_spread = {
			pitch = 5,
			yaw = 5,
		},
		decay = {
			from_shooting_grace_time = 0.075,
			shooting = {
				pitch = 0.15,
				yaw = 0.15,
			},
			idle = {
				pitch = 4.5,
				yaw = 4.5,
			},
		},
		randomized_spread = {
			first_shot_min_ratio = 0.3,
			first_shot_random_ratio = 0.6,
			min_ratio = 0.15,
			random_ratio = 0.5,
		},
		continuous_spread = {
			min_pitch = 1.5,
			min_yaw = 1.5,
		},
		immediate_spread = {
			num_shots_clear_time = 0.5,
			damage_hit = {
				{
					pitch = 0.4,
					yaw = 0.4,
				},
			},
			shooting = {
				{
					pitch = 7.5,
					yaw = 7.5,
				},
			},
		},
	},
	moving = {
		inherits = {
			"phosphor_pistol_p1_m1_spread_hip",
			"still",
		},
		continuous_spread = {
			min_pitch = 2.35,
			min_yaw = 2.35,
		},
	},
	crouch_still = {
		inherits = {
			"phosphor_pistol_p1_m1_spread_hip",
			"still",
		},
		continuous_spread = {
			min_pitch = 1.45,
			min_yaw = 1.45,
		},
	},
	crouch_moving = {
		inherits = {
			"phosphor_pistol_p1_m1_spread_hip",
			"still",
		},
		continuous_spread = {
			min_pitch = 2,
			min_yaw = 2,
		},
	},
}

local spread_multi = 0.65

spread_templates.phosphor_pistol_p1_m1_spread_ads = {
	still = {
		max_spread = {
			pitch = {
				lerp_basic = 6.25,
				lerp_perfect = 6,
			},
			yaw = {
				lerp_basic = 6.25,
				lerp_perfect = 6,
			},
		},
		decay = {
			from_shooting_grace_time = 0.15,
			shooting = {
				pitch = {
					lerp_basic = 0.15,
					lerp_perfect = 0.3,
				},
				yaw = {
					lerp_basic = 0.15,
					lerp_perfect = 0.3,
				},
			},
			idle = {
				pitch = {
					lerp_basic = 1,
					lerp_perfect = 2,
				},
				yaw = {
					lerp_basic = 1,
					lerp_perfect = 2,
				},
			},
		},
		continuous_spread = {
			min_pitch = {
				lerp_basic = 0.8,
				lerp_perfect = 0.5,
			},
			min_yaw = {
				lerp_basic = 1,
				lerp_perfect = 0.5,
			},
		},
		randomized_spread = {
			first_shot_min_ratio = 0.05,
			first_shot_random_ratio = 0.5,
			max_pitch_delta = 0.95,
			max_yaw_delta = 0.95,
			min_ratio = 0.4,
			random_ratio = 0.07,
		},
		immediate_spread = {
			num_shots_clear_time = 0.5,
			damage_hit = {
				{
					pitch = {
						lerp_basic = 1.5,
						lerp_perfect = 1,
					},
					yaw = {
						lerp_basic = 1.5,
						lerp_perfect = 1,
					},
				},
			},
			shooting = {
				{
					pitch = {
						lerp_perfect = 0.25,
						lerp_basic = 0.75 * spread_multi,
					},
					yaw = {
						lerp_perfect = 0.25,
						lerp_basic = 0.75 * spread_multi,
					},
				},
				{
					pitch = {
						lerp_perfect = 0.35,
						lerp_basic = 0.85 * spread_multi,
					},
					yaw = {
						lerp_perfect = 0.35,
						lerp_basic = 0.85 * spread_multi,
					},
				},
				{
					pitch = {
						lerp_perfect = 0.45,
						lerp_basic = 0.95 * spread_multi,
					},
					yaw = {
						lerp_perfect = 0.45,
						lerp_basic = 0.95 * spread_multi,
					},
				},
				{
					pitch = {
						lerp_perfect = 0.475,
						lerp_basic = 1 * spread_multi,
					},
					yaw = {
						lerp_perfect = 0.475,
						lerp_basic = 1 * spread_multi,
					},
				},
				{
					pitch = {
						lerp_perfect = 0.5,
						lerp_basic = 1.1 * spread_multi,
					},
					yaw = {
						lerp_perfect = 0.5,
						lerp_basic = 1.1 * spread_multi,
					},
				},
				{
					pitch = {
						lerp_perfect = 0.5,
						lerp_basic = 1.2 * spread_multi,
					},
					yaw = {
						lerp_perfect = 0.5,
						lerp_basic = 1.2 * spread_multi,
					},
				},
				{
					pitch = {
						lerp_perfect = 0.25,
						lerp_basic = 1.15 * spread_multi,
					},
					yaw = {
						lerp_perfect = 0.25,
						lerp_basic = 1.15 * spread_multi,
					},
				},
			},
		},
	},
	moving = {
		inherits = {
			"phosphor_pistol_p1_m1_spread_ads",
			"still",
		},
		continuous_spread = {
			min_pitch = {
				lerp_basic = 1,
				lerp_perfect = 0.5,
			},
			min_yaw = {
				lerp_basic = 1,
				lerp_perfect = 0.5,
			},
		},
		decay = {
			from_shooting_grace_time = 0.15,
			shooting = {
				pitch = {
					lerp_basic = 0.25,
					lerp_perfect = 1.5,
				},
				yaw = {
					lerp_basic = 0.25,
					lerp_perfect = 1.5,
				},
			},
			idle = {
				pitch = {
					lerp_basic = 1.5,
					lerp_perfect = 2.5,
				},
				yaw = {
					lerp_basic = 1.5,
					lerp_perfect = 2.5,
				},
			},
		},
	},
	crouch_still = {
		inherits = {
			"phosphor_pistol_p1_m1_spread_ads",
			"still",
		},
		continuous_spread = {
			min_pitch = {
				lerp_basic = 0.8,
				lerp_perfect = 0.4,
			},
			min_yaw = {
				lerp_basic = 0.8,
				lerp_perfect = 0.4,
			},
		},
	},
	crouch_moving = {
		inherits = {
			"phosphor_pistol_p1_m1_spread_ads",
			"still",
		},
		continuous_spread = {
			min_pitch = {
				lerp_basic = 0.8,
				lerp_perfect = 0.4,
			},
			min_yaw = {
				lerp_basic = 0.8,
				lerp_perfect = 0.4,
			},
		},
	},
}

return {
	base_templates = spread_templates,
	overrides = overrides,
}
