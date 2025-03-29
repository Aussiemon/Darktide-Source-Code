-- chunkname: @scripts/settings/equipment/weapon_templates/lasguns/settings_templates/lasgun_spread_templates.lua

local spread_templates = {}
local overrides = {}

table.make_unique(spread_templates)
table.make_unique(overrides)

spread_templates.hip_lasgun_assault = {
	still = {
		max_spread = {
			pitch = 5,
			yaw = 5,
		},
		decay = {
			from_shooting_grace_time = 0.075,
			shooting = {
				pitch = 0.75,
				yaw = 0.75,
			},
			idle = {
				pitch = 1.5,
				yaw = 1.5,
			},
		},
		continuous_spread = {
			min_pitch = 1,
			min_yaw = 1,
		},
		immediate_spread = {
			num_shots_clear_time = 0.5,
			suppression_hit = {
				{
					pitch = 0.25,
					yaw = 0.25,
				},
			},
			damage_hit = {
				{
					pitch = 0.4,
					yaw = 0.4,
				},
			},
			shooting = {
				{
					pitch = 0.5,
					yaw = 0.5,
				},
				{
					pitch = 0.75,
					yaw = 0.75,
				},
				{
					pitch = 1.25,
					yaw = 1.25,
				},
				{
					pitch = 1,
					yaw = 1,
				},
				{
					pitch = 0.75,
					yaw = 0.75,
				},
				{
					pitch = 0.6,
					yaw = 0.6,
				},
			},
		},
	},
	moving = {
		inherits = {
			"hip_lasgun_assault",
			"still",
		},
		continuous_spread = {
			min_pitch = 1.5,
			min_yaw = 1.5,
		},
	},
	crouch_still = {
		inherits = {
			"hip_lasgun_assault",
			"still",
		},
		continuous_spread = {
			min_pitch = 1.15,
			min_yaw = 1.15,
		},
	},
	crouch_moving = {
		inherits = {
			"hip_lasgun_assault",
			"still",
		},
		continuous_spread = {
			min_pitch = 2,
			min_yaw = 2,
		},
	},
}

local pitch_spread = 0.8
local yaw_spread = pitch_spread * 1

spread_templates.default_lasgun_spraynpray = {
	still = {
		max_spread = {
			pitch = 10,
			yaw = 13,
		},
		decay = {
			from_shooting_grace_time = 0.025,
			shooting = {
				pitch = 0.5,
				yaw = 0.5,
			},
			idle = {
				pitch = 1.5,
				yaw = 1.5,
			},
		},
		continuous_spread = {
			min_pitch = 2,
			min_yaw = 2,
		},
		immediate_spread = {
			num_shots_clear_time = 0.25,
			suppression_hit = {
				{
					pitch = 0.25,
					yaw = 0.25,
				},
			},
			damage_hit = {
				{
					pitch = 0.4,
					yaw = 0.4,
				},
			},
			shooting = {
				{
					pitch = pitch_spread * 0.4,
					yaw = yaw_spread * 0.4,
				},
				{
					pitch = pitch_spread * 0.45,
					yaw = yaw_spread * 0.45,
				},
				{
					pitch = pitch_spread * 0.5,
					yaw = yaw_spread * 0.5,
				},
				{
					pitch = pitch_spread * 0.4,
					yaw = yaw_spread * 0.4,
				},
				{
					pitch = pitch_spread * 0.3,
					yaw = yaw_spread * 0.3,
				},
				{
					pitch = pitch_spread * 0.2,
					yaw = yaw_spread * 0.2,
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0,
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0,
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0,
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0,
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0,
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0,
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1,
				},
				{
					pitch = pitch_spread * 0.2,
					yaw = yaw_spread * 0.2,
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1,
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0,
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0,
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1,
				},
				{
					pitch = pitch_spread * 0.2,
					yaw = yaw_spread * 0.2,
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1,
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0,
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0,
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1,
				},
				{
					pitch = pitch_spread * 0.2,
					yaw = yaw_spread * 0.2,
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1,
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0,
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0,
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1,
				},
				{
					pitch = pitch_spread * 0.2,
					yaw = yaw_spread * 0.2,
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1,
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0,
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0,
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1,
				},
				{
					pitch = pitch_spread * 0.2,
					yaw = yaw_spread * 0.2,
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1,
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0,
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0,
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1,
				},
				{
					pitch = pitch_spread * 0.2,
					yaw = yaw_spread * 0.2,
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1,
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0,
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0,
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1,
				},
				{
					pitch = pitch_spread * 0.2,
					yaw = yaw_spread * 0.2,
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1,
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0,
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0,
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1,
				},
				{
					pitch = pitch_spread * 0.2,
					yaw = yaw_spread * 0.2,
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1,
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0,
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0,
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1,
				},
				{
					pitch = pitch_spread * 0.2,
					yaw = yaw_spread * 0.2,
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1,
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0,
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0,
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1,
				},
				{
					pitch = pitch_spread * 0.2,
					yaw = yaw_spread * 0.2,
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1,
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0,
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0,
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1,
				},
				{
					pitch = pitch_spread * 0.2,
					yaw = yaw_spread * 0.2,
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1,
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0,
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0,
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1,
				},
				{
					pitch = pitch_spread * 0.2,
					yaw = yaw_spread * 0.2,
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1,
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0,
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0,
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1,
				},
			},
		},
	},
	moving = {
		inherits = {
			"default_lasgun_spraynpray",
			"still",
		},
		continuous_spread = {
			min_pitch = 2.1,
			min_yaw = 2.1,
		},
		immediate_spread = {
			num_shots_clear_time = 0.25,
			suppression_hit = {
				{
					pitch = 0.25,
					yaw = 0.25,
				},
			},
			damage_hit = {
				{
					pitch = 0.4,
					yaw = 0.4,
				},
			},
			shooting = {
				{
					pitch = pitch_spread * 1,
					yaw = yaw_spread * 1,
				},
				{
					pitch = pitch_spread * 0.75,
					yaw = yaw_spread * 0.75,
				},
				{
					pitch = pitch_spread * 0.5,
					yaw = yaw_spread * 0.5,
				},
				{
					pitch = pitch_spread * 0.4,
					yaw = yaw_spread * 0.4,
				},
				{
					pitch = pitch_spread * 0.3,
					yaw = yaw_spread * 0.3,
				},
				{
					pitch = pitch_spread * 0.2,
					yaw = yaw_spread * 0.2,
				},
			},
		},
	},
	crouch_still = {
		inherits = {
			"default_lasgun_spraynpray",
			"still",
		},
	},
	crouch_moving = {
		inherits = {
			"default_lasgun_spraynpray",
			"still",
		},
	},
}

local SPREAD_MULTI = 0.8

spread_templates.hip_lasgun_killshot = {
	still = {
		max_spread = {
			pitch = {
				lerp_basic = 3.25,
				lerp_perfect = 3,
			},
			yaw = {
				lerp_basic = 3.25,
				lerp_perfect = 3,
			},
		},
		decay = {
			from_shooting_grace_time = 0.15,
			shooting = {
				pitch = {
					lerp_basic = 0.15,
					lerp_perfect = 0.25,
				},
				yaw = {
					lerp_basic = 0.15,
					lerp_perfect = 0.25,
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
		continuous_spread = {
			min_pitch = {
				lerp_basic = 1.5,
				lerp_perfect = 1,
			},
			min_yaw = {
				lerp_basic = 1.5,
				lerp_perfect = 1,
			},
		},
		randomized_spread = {
			first_shot_min_ratio = 0.3,
			first_shot_random_ratio = 0.8,
			max_pitch_delta = 0.8,
			max_yaw_delta = 0.8,
			min_ratio = 0.15,
			random_ratio = 0.85,
		},
		immediate_spread = {
			num_shots_clear_time = 0.5,
			suppression_hit = {
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
						lerp_perfect = 0.75,
						lerp_basic = 2 * SPREAD_MULTI,
					},
					yaw = {
						lerp_perfect = 0.5,
						lerp_basic = 2 * SPREAD_MULTI,
					},
				},
				{
					pitch = {
						lerp_perfect = 0.5,
						lerp_basic = 1.75 * SPREAD_MULTI,
					},
					yaw = {
						lerp_perfect = 0.5,
						lerp_basic = 1.75 * SPREAD_MULTI,
					},
				},
				{
					pitch = {
						lerp_perfect = 0.5,
						lerp_basic = 1.5 * SPREAD_MULTI,
					},
					yaw = {
						lerp_perfect = 0.5,
						lerp_basic = 1.5 * SPREAD_MULTI,
					},
				},
				{
					pitch = {
						lerp_perfect = 0.5,
						lerp_basic = 1.375 * SPREAD_MULTI,
					},
					yaw = {
						lerp_perfect = 0.5,
						lerp_basic = 1.375 * SPREAD_MULTI,
					},
				},
				{
					pitch = {
						lerp_perfect = 0.5,
						lerp_basic = 1.3 * SPREAD_MULTI,
					},
					yaw = {
						lerp_perfect = 0.5,
						lerp_basic = 1.3 * SPREAD_MULTI,
					},
				},
				{
					pitch = {
						lerp_perfect = 0.5,
						lerp_basic = 1.3 * SPREAD_MULTI,
					},
					yaw = {
						lerp_perfect = 0.5,
						lerp_basic = 1.3 * SPREAD_MULTI,
					},
				},
				{
					pitch = {
						lerp_perfect = 0.5,
						lerp_basic = 1.15 * SPREAD_MULTI,
					},
					yaw = {
						lerp_perfect = 0.5,
						lerp_basic = 1.15 * SPREAD_MULTI,
					},
				},
			},
		},
	},
	moving = {
		inherits = {
			"hip_lasgun_killshot",
			"still",
		},
		continuous_spread = {
			min_pitch = {
				lerp_basic = 2.5,
				lerp_perfect = 1.8,
			},
			min_yaw = {
				lerp_basic = 2.25,
				lerp_perfect = 2,
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
		immediate_spread = {
			num_shots_clear_time = 0.5,
			suppression_hit = {
				{
					pitch = {
						lerp_basic = 1.5,
						lerp_perfect = 0.5,
					},
					yaw = {
						lerp_basic = 1.5,
						lerp_perfect = 0.5,
					},
				},
			},
			damage_hit = {
				{
					pitch = {
						lerp_basic = 1.5,
						lerp_perfect = 1.25,
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
						lerp_basic = 2,
						lerp_perfect = 0.5,
					},
					yaw = {
						lerp_basic = 2,
						lerp_perfect = 0.5,
					},
				},
				{
					pitch = {
						lerp_basic = 1.65,
						lerp_perfect = 0.4,
					},
					yaw = {
						lerp_basic = 1.65,
						lerp_perfect = 0.4,
					},
				},
				{
					pitch = {
						lerp_basic = 1.35,
						lerp_perfect = 0.5,
					},
					yaw = {
						lerp_basic = 1.35,
						lerp_perfect = 0.5,
					},
				},
			},
		},
	},
	crouch_still = {
		inherits = {
			"hip_lasgun_killshot",
			"still",
		},
		continuous_spread = {
			min_pitch = {
				lerp_basic = 1.4,
				lerp_perfect = 0.7,
			},
			min_yaw = {
				lerp_basic = 1.3,
				lerp_perfect = 0.8,
			},
		},
	},
	crouch_moving = {
		inherits = {
			"hip_lasgun_killshot",
			"still",
		},
		continuous_spread = {
			min_pitch = {
				lerp_basic = 2.15,
				lerp_perfect = 2.3,
			},
			min_yaw = {
				lerp_basic = 2.15,
				lerp_perfect = 2.3,
			},
		},
	},
}
spread_templates.hip_lasgun_killshot_p1_m2 = {
	still = {
		max_spread = {
			pitch = {
				lerp_basic = 3.25,
				lerp_perfect = 3,
			},
			yaw = {
				lerp_basic = 3.25,
				lerp_perfect = 3,
			},
		},
		decay = {
			from_shooting_grace_time = 0.15,
			shooting = {
				pitch = {
					lerp_basic = 0.15,
					lerp_perfect = 0.4,
				},
				yaw = {
					lerp_basic = 0.15,
					lerp_perfect = 0.4,
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
		continuous_spread = {
			min_pitch = {
				lerp_basic = 1.25,
				lerp_perfect = 1,
			},
			min_yaw = {
				lerp_basic = 1.25,
				lerp_perfect = 1,
			},
		},
		randomized_spread = {
			first_shot_min_ratio = 0.2,
			first_shot_random_ratio = 0.6,
			max_pitch_delta = 0.5,
			max_yaw_delta = 0.5,
			min_ratio = 0.1,
			random_ratio = 0.9,
		},
		immediate_spread = {
			num_shots_clear_time = 0.5,
			suppression_hit = {
				{
					pitch = {
						lerp_basic = 1.5,
						lerp_perfect = 0.75,
					},
					yaw = {
						lerp_basic = 1.5,
						lerp_perfect = 0.75,
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
						lerp_perfect = 0.5,
						lerp_basic = 2 * SPREAD_MULTI,
					},
					yaw = {
						lerp_perfect = 0.5,
						lerp_basic = 2 * SPREAD_MULTI,
					},
				},
				{
					pitch = {
						lerp_perfect = 0.25,
						lerp_basic = 1.75 * SPREAD_MULTI,
					},
					yaw = {
						lerp_perfect = 0.25,
						lerp_basic = 1.75 * SPREAD_MULTI,
					},
				},
				{
					pitch = {
						lerp_perfect = 0.15,
						lerp_basic = 1.5 * SPREAD_MULTI,
					},
					yaw = {
						lerp_perfect = 0.15,
						lerp_basic = 1.5 * SPREAD_MULTI,
					},
				},
				{
					pitch = {
						lerp_perfect = 0.175,
						lerp_basic = 1.375 * SPREAD_MULTI,
					},
					yaw = {
						lerp_perfect = 0.175,
						lerp_basic = 1.375 * SPREAD_MULTI,
					},
				},
				{
					pitch = {
						lerp_perfect = 0.2,
						lerp_basic = 1.3 * SPREAD_MULTI,
					},
					yaw = {
						lerp_perfect = 0.2,
						lerp_basic = 1.3 * SPREAD_MULTI,
					},
				},
				{
					pitch = {
						lerp_perfect = 0.2,
						lerp_basic = 1.3 * SPREAD_MULTI,
					},
					yaw = {
						lerp_perfect = 0.2,
						lerp_basic = 1.3 * SPREAD_MULTI,
					},
				},
				{
					pitch = {
						lerp_perfect = 0.25,
						lerp_basic = 1.15 * SPREAD_MULTI,
					},
					yaw = {
						lerp_perfect = 0.25,
						lerp_basic = 1.15 * SPREAD_MULTI,
					},
				},
			},
		},
	},
	moving = {
		inherits = {
			"hip_lasgun_killshot_p1_m2",
			"still",
		},
		continuous_spread = {
			min_pitch = {
				lerp_basic = 1.5,
				lerp_perfect = 1.25,
			},
			min_yaw = {
				lerp_basic = 1.5,
				lerp_perfect = 1.25,
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
		immediate_spread = {
			num_shots_clear_time = 1.2,
			suppression_hit = {
				{
					pitch = {
						lerp_basic = 1,
						lerp_perfect = 0.5,
					},
					yaw = {
						lerp_basic = 1,
						lerp_perfect = 0.5,
					},
				},
			},
			damage_hit = {
				{
					pitch = {
						lerp_basic = 1.5,
						lerp_perfect = 1.25,
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
						lerp_basic = 2,
						lerp_perfect = 0.5,
					},
					yaw = {
						lerp_basic = 2,
						lerp_perfect = 0.5,
					},
				},
				{
					pitch = {
						lerp_basic = 1.65,
						lerp_perfect = 0.4,
					},
					yaw = {
						lerp_basic = 1.65,
						lerp_perfect = 0.4,
					},
				},
				{
					pitch = {
						lerp_basic = 1.35,
						lerp_perfect = 0.5,
					},
					yaw = {
						lerp_basic = 1.35,
						lerp_perfect = 0.5,
					},
				},
			},
		},
	},
	crouch_still = {
		inherits = {
			"hip_lasgun_killshot_p1_m2",
			"still",
		},
		continuous_spread = {
			min_pitch = {
				lerp_basic = 0.8,
				lerp_perfect = 0.5,
			},
			min_yaw = {
				lerp_basic = 0.8,
				lerp_perfect = 0.5,
			},
		},
	},
	crouch_moving = {
		inherits = {
			"hip_lasgun_killshot_p1_m2",
			"still",
		},
		continuous_spread = {
			min_pitch = {
				lerp_basic = 1,
				lerp_perfect = 0.7,
			},
			min_yaw = {
				lerp_basic = 1,
				lerp_perfect = 0.7,
			},
		},
	},
}
spread_templates.hip_lasgun_killshot_p1_m3 = {
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
					lerp_perfect = 0.4,
				},
				yaw = {
					lerp_basic = 0.15,
					lerp_perfect = 0.4,
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
		continuous_spread = {
			min_pitch = {
				lerp_basic = 2.5,
				lerp_perfect = 1.5,
			},
			min_yaw = {
				lerp_basic = 2.5,
				lerp_perfect = 1.5,
			},
		},
		randomized_spread = {
			first_shot_min_ratio = 0.17,
			first_shot_random_ratio = 0.5,
			max_pitch_delta = 0.8,
			max_yaw_delta = 0.8,
			min_ratio = 0.25,
			random_ratio = 0.18,
		},
		immediate_spread = {
			num_shots_clear_time = 0.5,
			suppression_hit = {
				{
					pitch = {
						lerp_basic = 1.5,
						lerp_perfect = 0.75,
					},
					yaw = {
						lerp_basic = 1.5,
						lerp_perfect = 0.75,
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
						lerp_perfect = 0.5,
						lerp_basic = 2 * SPREAD_MULTI,
					},
					yaw = {
						lerp_perfect = 0.5,
						lerp_basic = 2 * SPREAD_MULTI,
					},
				},
				{
					pitch = {
						lerp_perfect = 0.25,
						lerp_basic = 1.75 * SPREAD_MULTI,
					},
					yaw = {
						lerp_perfect = 0.25,
						lerp_basic = 1.75 * SPREAD_MULTI,
					},
				},
				{
					pitch = {
						lerp_perfect = 0.15,
						lerp_basic = 1.5 * SPREAD_MULTI,
					},
					yaw = {
						lerp_perfect = 0.15,
						lerp_basic = 1.5 * SPREAD_MULTI,
					},
				},
				{
					pitch = {
						lerp_perfect = 0.175,
						lerp_basic = 1.375 * SPREAD_MULTI,
					},
					yaw = {
						lerp_perfect = 0.175,
						lerp_basic = 1.375 * SPREAD_MULTI,
					},
				},
				{
					pitch = {
						lerp_perfect = 0.2,
						lerp_basic = 1.3 * SPREAD_MULTI,
					},
					yaw = {
						lerp_perfect = 0.2,
						lerp_basic = 1.3 * SPREAD_MULTI,
					},
				},
				{
					pitch = {
						lerp_perfect = 0.2,
						lerp_basic = 1.3 * SPREAD_MULTI,
					},
					yaw = {
						lerp_perfect = 0.2,
						lerp_basic = 1.3 * SPREAD_MULTI,
					},
				},
				{
					pitch = {
						lerp_perfect = 0.25,
						lerp_basic = 1.15 * SPREAD_MULTI,
					},
					yaw = {
						lerp_perfect = 0.25,
						lerp_basic = 1.15 * SPREAD_MULTI,
					},
				},
			},
		},
	},
	moving = {
		inherits = {
			"hip_lasgun_killshot_p1_m3",
			"still",
		},
		continuous_spread = {
			min_pitch = {
				lerp_basic = 3,
				lerp_perfect = 2.5,
			},
			min_yaw = {
				lerp_basic = 3,
				lerp_perfect = 2.5,
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
		immediate_spread = {
			num_shots_clear_time = 1.2,
			suppression_hit = {
				{
					pitch = {
						lerp_basic = 1,
						lerp_perfect = 0.5,
					},
					yaw = {
						lerp_basic = 1,
						lerp_perfect = 0.5,
					},
				},
			},
			damage_hit = {
				{
					pitch = {
						lerp_basic = 1.5,
						lerp_perfect = 1.25,
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
						lerp_basic = 2,
						lerp_perfect = 0.5,
					},
					yaw = {
						lerp_basic = 2,
						lerp_perfect = 0.5,
					},
				},
				{
					pitch = {
						lerp_basic = 1.65,
						lerp_perfect = 0.4,
					},
					yaw = {
						lerp_basic = 1.65,
						lerp_perfect = 0.4,
					},
				},
				{
					pitch = {
						lerp_basic = 1.35,
						lerp_perfect = 0.5,
					},
					yaw = {
						lerp_basic = 1.35,
						lerp_perfect = 0.5,
					},
				},
			},
		},
	},
	crouch_still = {
		inherits = {
			"hip_lasgun_killshot_p1_m3",
			"still",
		},
		continuous_spread = {
			min_pitch = {
				lerp_basic = 2.3,
				lerp_perfect = 1.3,
			},
			min_yaw = {
				lerp_basic = 2.6,
				lerp_perfect = 1.3,
			},
		},
	},
	crouch_moving = {
		inherits = {
			"hip_lasgun_killshot_p1_m3",
			"still",
		},
		continuous_spread = {
			min_pitch = {
				lerp_basic = 2.85,
				lerp_perfect = 2.3,
			},
			min_yaw = {
				lerp_basic = 2.85,
				lerp_perfect = 2.3,
			},
		},
	},
}

local P2_SPREAD_MULTI = 1

spread_templates.hip_lasgun_killshot_p2_m1 = {
	charge_scale = {
		max_pitch = 0.5,
		max_yaw = 0.5,
	},
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
					lerp_perfect = 0.4,
				},
				yaw = {
					lerp_basic = 0.15,
					lerp_perfect = 0.4,
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
		continuous_spread = {
			min_pitch = {
				lerp_basic = 3,
				lerp_perfect = 2.25,
			},
			min_yaw = {
				lerp_basic = 3,
				lerp_perfect = 2.25,
			},
		},
		randomized_spread = {
			first_shot_min_ratio = 0.2,
			first_shot_random_ratio = 0.4,
			min_ratio = 0.25,
			random_ratio = 0.65,
		},
		immediate_spread = {
			num_shots_clear_time = 0.5,
			suppression_hit = {
				{
					pitch = {
						lerp_basic = 1.5,
						lerp_perfect = 0.75,
					},
					yaw = {
						lerp_basic = 1.5,
						lerp_perfect = 0.75,
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
						lerp_perfect = 0.5,
						lerp_basic = 2 * P2_SPREAD_MULTI,
					},
					yaw = {
						lerp_perfect = 0.5,
						lerp_basic = 2 * P2_SPREAD_MULTI,
					},
				},
				{
					pitch = {
						lerp_perfect = 0.25,
						lerp_basic = 1.75 * P2_SPREAD_MULTI,
					},
					yaw = {
						lerp_perfect = 0.25,
						lerp_basic = 1.75 * P2_SPREAD_MULTI,
					},
				},
				{
					pitch = {
						lerp_perfect = 0.15,
						lerp_basic = 1.5 * P2_SPREAD_MULTI,
					},
					yaw = {
						lerp_perfect = 0.15,
						lerp_basic = 1.5 * P2_SPREAD_MULTI,
					},
				},
			},
		},
	},
	moving = {
		inherits = {
			"hip_lasgun_killshot_p2_m1",
			"still",
		},
		continuous_spread = {
			min_pitch = {
				lerp_basic = 4,
				lerp_perfect = 2.5,
			},
			min_yaw = {
				lerp_basic = 4,
				lerp_perfect = 2.5,
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
		immediate_spread = {
			num_shots_clear_time = 1.2,
			suppression_hit = {
				{
					pitch = {
						lerp_basic = 1,
						lerp_perfect = 0.5,
					},
					yaw = {
						lerp_basic = 1,
						lerp_perfect = 0.5,
					},
				},
			},
			damage_hit = {
				{
					pitch = {
						lerp_basic = 1.5,
						lerp_perfect = 1.25,
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
						lerp_basic = 2,
						lerp_perfect = 0.5,
					},
					yaw = {
						lerp_basic = 2,
						lerp_perfect = 0.5,
					},
				},
				{
					pitch = {
						lerp_basic = 1.65,
						lerp_perfect = 0.4,
					},
					yaw = {
						lerp_basic = 1.65,
						lerp_perfect = 0.4,
					},
				},
				{
					pitch = {
						lerp_basic = 1.35,
						lerp_perfect = 0.5,
					},
					yaw = {
						lerp_basic = 1.35,
						lerp_perfect = 0.5,
					},
				},
			},
		},
	},
	crouch_still = {
		inherits = {
			"hip_lasgun_killshot_p2_m1",
			"still",
		},
		continuous_spread = {
			min_pitch = {
				lerp_basic = 2.3,
				lerp_perfect = 1.3,
			},
			min_yaw = {
				lerp_basic = 2.6,
				lerp_perfect = 1.3,
			},
		},
	},
	crouch_moving = {
		inherits = {
			"hip_lasgun_killshot_p2_m1",
			"still",
		},
		continuous_spread = {
			min_pitch = {
				lerp_basic = 2.85,
				lerp_perfect = 2.3,
			},
			min_yaw = {
				lerp_basic = 2.85,
				lerp_perfect = 2.3,
			},
		},
	},
}
spread_templates.hip_lasgun_killshot_p2_m2 = table.clone(spread_templates.hip_lasgun_killshot_p2_m1)
spread_templates.hip_lasgun_killshot_p2_m2.still.continuous_spread = {
	min_pitch = {
		lerp_basic = 3,
		lerp_perfect = 2,
	},
	min_yaw = {
		lerp_basic = 3,
		lerp_perfect = 2,
	},
}
spread_templates.hip_lasgun_killshot_p2_m2.moving.continuous_spread = {
	min_pitch = {
		lerp_basic = 4.5,
		lerp_perfect = 3,
	},
	min_yaw = {
		lerp_basic = 4.5,
		lerp_perfect = 3,
	},
}
spread_templates.hip_lasgun_killshot_p2_m2.crouch_still.continuous_spread = {
	min_pitch = {
		lerp_basic = 2.8,
		lerp_perfect = 1.8,
	},
	min_yaw = {
		lerp_basic = 2.8,
		lerp_perfect = 1.8,
	},
}
spread_templates.hip_lasgun_killshot_p2_m2.crouch_moving.continuous_spread = {
	min_pitch = {
		lerp_basic = 3.35,
		lerp_perfect = 2.8,
	},
	min_yaw = {
		lerp_basic = 3.35,
		lerp_perfect = 2.8,
	},
}
spread_templates.ads_lasgun_killshot_p2_m1 = {
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
					lerp_perfect = 0.4,
				},
				yaw = {
					lerp_basic = 0.15,
					lerp_perfect = 0.4,
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
		continuous_spread = {
			min_pitch = {
				lerp_basic = 2.5,
				lerp_perfect = 1.5,
			},
			min_yaw = {
				lerp_basic = 2.5,
				lerp_perfect = 1.5,
			},
		},
		randomized_spread = {
			first_shot_min_ratio = 0.017,
			first_shot_random_ratio = 0.05,
			max_pitch_delta = 0.8,
			max_yaw_delta = 0.8,
			min_ratio = 0.25,
			random_ratio = 0.18,
		},
		immediate_spread = {
			num_shots_clear_time = 2,
			suppression_hit = {
				{
					pitch = {
						lerp_basic = 1.5,
						lerp_perfect = 0.75,
					},
					yaw = {
						lerp_basic = 1.5,
						lerp_perfect = 0.75,
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
						lerp_perfect = 0.5,
						lerp_basic = 2 * SPREAD_MULTI,
					},
					yaw = {
						lerp_perfect = 0.5,
						lerp_basic = 2 * SPREAD_MULTI,
					},
				},
				{
					pitch = {
						lerp_perfect = 0.25,
						lerp_basic = 1.75 * SPREAD_MULTI,
					},
					yaw = {
						lerp_perfect = 0.25,
						lerp_basic = 1.75 * SPREAD_MULTI,
					},
				},
				{
					pitch = {
						lerp_perfect = 0.15,
						lerp_basic = 1.5 * SPREAD_MULTI,
					},
					yaw = {
						lerp_perfect = 0.15,
						lerp_basic = 1.5 * SPREAD_MULTI,
					},
				},
			},
		},
	},
	moving = {
		inherits = {
			"ads_lasgun_killshot_p2_m1",
			"still",
		},
		continuous_spread = {
			min_pitch = {
				lerp_basic = 3,
				lerp_perfect = 2.5,
			},
			min_yaw = {
				lerp_basic = 3,
				lerp_perfect = 2.5,
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
		immediate_spread = {
			num_shots_clear_time = 1.2,
			suppression_hit = {
				{
					pitch = {
						lerp_basic = 1,
						lerp_perfect = 0.5,
					},
					yaw = {
						lerp_basic = 1,
						lerp_perfect = 0.5,
					},
				},
			},
			damage_hit = {
				{
					pitch = {
						lerp_basic = 1.5,
						lerp_perfect = 1.25,
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
						lerp_basic = 2,
						lerp_perfect = 0.5,
					},
					yaw = {
						lerp_basic = 2,
						lerp_perfect = 0.5,
					},
				},
				{
					pitch = {
						lerp_basic = 1.65,
						lerp_perfect = 0.4,
					},
					yaw = {
						lerp_basic = 1.65,
						lerp_perfect = 0.4,
					},
				},
				{
					pitch = {
						lerp_basic = 1.35,
						lerp_perfect = 0.5,
					},
					yaw = {
						lerp_basic = 1.35,
						lerp_perfect = 0.5,
					},
				},
			},
		},
	},
	crouch_still = {
		inherits = {
			"ads_lasgun_killshot_p2_m1",
			"still",
		},
		continuous_spread = {
			min_pitch = {
				lerp_basic = 2.3,
				lerp_perfect = 1.3,
			},
			min_yaw = {
				lerp_basic = 2.6,
				lerp_perfect = 1.3,
			},
		},
	},
	crouch_moving = {
		inherits = {
			"ads_lasgun_killshot_p2_m1",
			"still",
		},
		continuous_spread = {
			min_pitch = {
				lerp_basic = 2.85,
				lerp_perfect = 2.3,
			},
			min_yaw = {
				lerp_basic = 2.85,
				lerp_perfect = 2.3,
			},
		},
	},
}
spread_templates.default_lasgun_killshot = {
	still = {
		max_spread = {
			pitch = 2.5,
			yaw = 2.5,
		},
		decay = {
			crouch_transition_grace_time = 0.5,
			enter_alternate_fire_grace_time = 0.5,
			from_shooting_grace_time = 0.15,
			shooting = {
				pitch = {
					lerp_basic = 0.5,
					lerp_perfect = 0.8,
				},
				yaw = {
					lerp_basic = 0.5,
					lerp_perfect = 0.8,
				},
			},
			idle = {
				pitch = {
					lerp_basic = 1.5,
					lerp_perfect = 2,
				},
				yaw = {
					lerp_basic = 1.5,
					lerp_perfect = 2,
				},
			},
			player_event = {
				pitch = {
					lerp_basic = 40,
					lerp_perfect = 50,
				},
				yaw = {
					lerp_basic = 40,
					lerp_perfect = 50,
				},
			},
		},
		continuous_spread = {
			min_pitch = {
				lerp_basic = 0,
				lerp_perfect = 0,
			},
			min_yaw = {
				lerp_basic = 0,
				lerp_perfect = 0,
			},
		},
		immediate_spread = {
			num_shots_clear_time = 1,
			alternate_fire_start = {
				{
					pitch = {
						lerp_basic = 0,
						lerp_perfect = 0,
					},
					yaw = {
						lerp_basic = 0,
						lerp_perfect = 0,
					},
				},
			},
			crouching_transition = {
				{
					pitch = {
						lerp_basic = 0,
						lerp_perfect = 0,
					},
					yaw = {
						lerp_basic = 0,
						lerp_perfect = 0,
					},
				},
			},
			suppression_hit = {
				{
					pitch = {
						lerp_basic = 0,
						lerp_perfect = 0,
					},
					yaw = {
						lerp_basic = 0,
						lerp_perfect = 0,
					},
				},
			},
			damage_hit = {
				{
					pitch = {
						lerp_basic = 0,
						lerp_perfect = 0,
					},
					yaw = {
						lerp_basic = 0,
						lerp_perfect = 0,
					},
				},
			},
			shooting = {
				{
					pitch = {
						lerp_basic = 0,
						lerp_perfect = 0,
					},
					yaw = {
						lerp_basic = 0,
						lerp_perfect = 0,
					},
				},
			},
		},
	},
	moving = {
		inherits = {
			"default_lasgun_killshot",
			"still",
		},
		continuous_spread = {
			min_pitch = 0,
			min_yaw = 0,
		},
	},
	crouch_still = {
		inherits = {
			"default_lasgun_killshot",
			"still",
		},
		continuous_spread = {
			min_pitch = 0,
			min_yaw = 0,
		},
	},
	crouch_moving = {
		inherits = {
			"default_lasgun_killshot",
			"still",
		},
	},
	continuous_spread = {
		min_pitch = 0,
		min_yaw = 0,
	},
}
spread_templates.lasgun_heavy_killshot = {
	still = {
		max_spread = {
			pitch = 2.5,
			yaw = 2.5,
		},
		decay = {
			crouch_transition_grace_time = 0.5,
			enter_alternate_fire_grace_time = 0.5,
			from_shooting_grace_time = 0.15,
			shooting = {
				pitch = {
					lerp_basic = 0.5,
					lerp_perfect = 0.8,
				},
				yaw = {
					lerp_basic = 0.5,
					lerp_perfect = 0.8,
				},
			},
			idle = {
				pitch = {
					lerp_basic = 1.5,
					lerp_perfect = 2,
				},
				yaw = {
					lerp_basic = 1.5,
					lerp_perfect = 2,
				},
			},
			player_event = {
				pitch = {
					lerp_basic = 40,
					lerp_perfect = 50,
				},
				yaw = {
					lerp_basic = 40,
					lerp_perfect = 50,
				},
			},
		},
		continuous_spread = {
			min_pitch = {
				lerp_basic = 0,
				lerp_perfect = 0,
			},
			min_yaw = {
				lerp_basic = 0,
				lerp_perfect = 0,
			},
		},
		immediate_spread = {
			num_shots_clear_time = 1,
			alternate_fire_start = {
				{
					pitch = {
						lerp_basic = 0,
						lerp_perfect = 0,
					},
					yaw = {
						lerp_basic = 0,
						lerp_perfect = 0,
					},
				},
			},
			crouching_transition = {
				{
					pitch = {
						lerp_basic = 0,
						lerp_perfect = 0,
					},
					yaw = {
						lerp_basic = 0,
						lerp_perfect = 0,
					},
				},
			},
			suppression_hit = {
				{
					pitch = {
						lerp_basic = 0,
						lerp_perfect = 0,
					},
					yaw = {
						lerp_basic = 0,
						lerp_perfect = 0,
					},
				},
			},
			damage_hit = {
				{
					pitch = {
						lerp_basic = 0,
						lerp_perfect = 0,
					},
					yaw = {
						lerp_basic = 0,
						lerp_perfect = 0,
					},
				},
			},
			shooting = {
				{
					pitch = {
						lerp_basic = 0,
						lerp_perfect = 0,
					},
					yaw = {
						lerp_basic = 0,
						lerp_perfect = 0,
					},
				},
			},
		},
	},
	moving = {
		inherits = {
			"default_lasgun_killshot",
			"still",
		},
		continuous_spread = {
			min_pitch = 0,
			min_yaw = 0,
		},
	},
	crouch_still = {
		inherits = {
			"default_lasgun_killshot",
			"still",
		},
		continuous_spread = {
			min_pitch = 0,
			min_yaw = 0,
		},
	},
	crouch_moving = {
		inherits = {
			"default_lasgun_killshot",
			"still",
		},
	},
	continuous_spread = {
		min_pitch = 0,
		min_yaw = 0,
	},
}
spread_templates.default_lasgun_bfg = {
	charge_scale = {
		max_pitch = 0.25,
		max_yaw = 0.25,
	},
	still = {
		max_spread = {
			pitch = 20,
			yaw = 20,
		},
		decay = {
			from_shooting_grace_time = 0.2,
			shooting = {
				pitch = 0.5,
				yaw = 0.5,
			},
			idle = {
				pitch = 1,
				yaw = 1,
			},
		},
		continuous_spread = {
			min_pitch = 2.5,
			min_yaw = 2.5,
		},
		immediate_spread = {
			num_shots_clear_time = 0.35,
			suppression_hit = {
				{
					pitch = 0.5,
					yaw = 0.5,
				},
			},
			damage_hit = {
				{
					pitch = 0.4,
					yaw = 0.4,
				},
			},
			shooting = {
				{
					pitch = 2.5,
					yaw = 2.5,
				},
			},
		},
	},
	moving = {
		inherits = {
			"default_lasgun_bfg",
			"still",
		},
	},
	crouch_still = {
		inherits = {
			"default_lasgun_bfg",
			"still",
		},
	},
	crouch_moving = {
		inherits = {
			"default_lasgun_bfg",
			"still",
		},
	},
}
spread_templates.hip_lasgun_p3_m1 = {
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
					lerp_perfect = 0.4,
				},
				yaw = {
					lerp_basic = 0.15,
					lerp_perfect = 0.4,
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
		continuous_spread = {
			min_pitch = {
				lerp_basic = 1.8,
				lerp_perfect = 1.5,
			},
			min_yaw = {
				lerp_basic = 1.8,
				lerp_perfect = 1.5,
			},
		},
		randomized_spread = {
			first_shot_min_ratio = 0.2,
			first_shot_random_ratio = 0.6,
			max_pitch_delta = 0.5,
			max_yaw_delta = 0.5,
			min_ratio = 0.1,
			random_ratio = 0.9,
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
						lerp_basic = 0.5,
						lerp_perfect = 0.25,
					},
					yaw = {
						lerp_basic = 0.5,
						lerp_perfect = 0.25,
					},
				},
			},
			shooting = {
				{
					pitch = {
						lerp_basic = 0.1,
						lerp_perfect = 0.075,
					},
					yaw = {
						lerp_basic = 0.1,
						lerp_perfect = 0.075,
					},
				},
			},
		},
	},
	moving = {
		inherits = {
			"hip_lasgun_p3_m1",
			"still",
		},
		continuous_spread = {
			min_pitch = {
				lerp_basic = 1.9,
				lerp_perfect = 1.7,
			},
			min_yaw = {
				lerp_basic = 1.9,
				lerp_perfect = 1.7,
			},
		},
	},
	crouch_still = {
		inherits = {
			"hip_lasgun_p3_m1",
			"still",
		},
		continuous_spread = {
			min_pitch = {
				lerp_basic = 1.8,
				lerp_perfect = 1.5,
			},
			min_yaw = {
				lerp_basic = 1.8,
				lerp_perfect = 1.5,
			},
		},
	},
	crouch_moving = {
		inherits = {
			"hip_lasgun_p3_m1",
			"still",
		},
		continuous_spread = {
			min_pitch = {
				lerp_basic = 1.8,
				lerp_perfect = 1.6,
			},
			min_yaw = {
				lerp_basic = 1.8,
				lerp_perfect = 1.6,
			},
		},
	},
}

return {
	base_templates = spread_templates,
	overrides = overrides,
}
