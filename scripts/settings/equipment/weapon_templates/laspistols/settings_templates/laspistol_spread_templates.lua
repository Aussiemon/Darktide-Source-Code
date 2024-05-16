-- chunkname: @scripts/settings/equipment/weapon_templates/laspistols/settings_templates/laspistol_spread_templates.lua

local spread_templates = {}
local overrides = {}

table.make_unique(spread_templates)
table.make_unique(overrides)

spread_templates.default_laspistol_killshot = {
	still = {
		max_spread = {
			pitch = 6,
			yaw = 6,
		},
		decay = {
			from_shooting_grace_time = 0.15,
			shooting = {
				pitch = 0.5,
				yaw = 0.5,
			},
			idle = {
				pitch = 2,
				yaw = 2,
			},
		},
		continuous_spread = {
			min_pitch = 0,
			min_yaw = 0,
		},
		immediate_spread = {
			num_shots_clear_time = 0.4,
			suppression_hit = {
				{
					pitch = 0.2,
					yaw = 0.2,
				},
			},
			damage_hit = {
				{
					pitch = 1.2,
					yaw = 1.2,
				},
			},
			shooting = {
				{
					pitch = 0,
					yaw = 0,
				},
				{
					pitch = 0,
					yaw = 0,
				},
				{
					pitch = 0.05,
					yaw = 0.05,
				},
			},
		},
		visual_spread_settings = {
			horizontal_speed = 4,
			intensity = 0.5,
			rotation_speed = 0.5,
			speed_change_frequency = 1,
			speed_variance_max = 1.25,
			speed_variance_min = 0.75,
		},
	},
	moving = {
		inherits = {
			"default_laspistol_killshot",
			"still",
		},
		continuous_spread = {
			min_pitch = 0,
			min_yaw = 0,
		},
	},
	crouch_still = {
		inherits = {
			"default_laspistol_killshot",
			"still",
		},
		continuous_spread = {
			min_pitch = 0,
			min_yaw = 0,
		},
	},
	crouch_moving = {
		inherits = {
			"default_laspistol_killshot",
			"still",
		},
		continuous_spread = {
			min_pitch = 0,
			min_yaw = 0,
		},
	},
}

local spread_multi = 0.65

spread_templates.default_laspistol_assault = {
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
				lerp_basic = 1,
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
			suppression_hit = {
				{
					pitch = {
						lerp_basic = 0.5,
						lerp_perfect = 0.25,
					},
					yaw = {
						lerp_basic = 0.5,
						lerp_perfect = 0.25,
					},
				},
			},
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
			"default_laspistol_assault",
			"still",
		},
		continuous_spread = {
			min_pitch = {
				lerp_basic = 1.2,
				lerp_perfect = 0.7,
			},
			min_yaw = {
				lerp_basic = 1.2,
				lerp_perfect = 0.7,
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
			"default_laspistol_assault",
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
			"default_laspistol_assault",
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
