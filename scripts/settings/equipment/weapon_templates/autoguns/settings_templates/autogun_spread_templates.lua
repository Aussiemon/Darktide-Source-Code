-- chunkname: @scripts/settings/equipment/weapon_templates/autoguns/settings_templates/autogun_spread_templates.lua

local spread_templates = {}
local overrides = {}

table.make_unique(spread_templates)
table.make_unique(overrides)

spread_templates.default_autogun_assault = {
	still = {
		max_spread = {
			pitch = 8,
			yaw = 8,
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
				lerp_basic = 2,
				lerp_perfect = 1.4,
			},
			min_yaw = {
				lerp_basic = 2,
				lerp_perfect = 1.4,
			},
		},
		immediate_spread = {
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
					pitch = {
						lerp_basic = 0.45,
						lerp_perfect = 0.25,
					},
					yaw = {
						lerp_basic = 0.45,
						lerp_perfect = 0.25,
					},
				},
				{
					pitch = {
						lerp_basic = 0.25,
						lerp_perfect = 0.15,
					},
					yaw = {
						lerp_basic = 0.25,
						lerp_perfect = 0.15,
					},
				},
				{
					pitch = {
						lerp_basic = 0.45,
						lerp_perfect = 0.25,
					},
					yaw = {
						lerp_basic = 0.45,
						lerp_perfect = 0.25,
					},
				},
				{
					pitch = {
						lerp_basic = 0.6,
						lerp_perfect = 0.4,
					},
					yaw = {
						lerp_basic = 0.6,
						lerp_perfect = 0.4,
					},
				},
				{
					pitch = {
						lerp_basic = 0.35,
						lerp_perfect = 0.2,
					},
					yaw = {
						lerp_basic = 0.35,
						lerp_perfect = 0.2,
					},
				},
				{
					pitch = {
						lerp_basic = 0.3,
						lerp_perfect = 0.15,
					},
					yaw = {
						lerp_basic = 0.3,
						lerp_perfect = 0.15,
					},
				},
				{
					pitch = {
						lerp_basic = 0.3,
						lerp_perfect = 0.15,
					},
					yaw = {
						lerp_basic = 0.3,
						lerp_perfect = 0.15,
					},
				},
				{
					pitch = {
						lerp_basic = 0.3,
						lerp_perfect = 0.15,
					},
					yaw = {
						lerp_basic = 0.3,
						lerp_perfect = 0.15,
					},
				},
				{
					pitch = {
						lerp_basic = 0.3,
						lerp_perfect = 0.15,
					},
					yaw = {
						lerp_basic = 0.3,
						lerp_perfect = 0.15,
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
			"default_autogun_assault",
			"still",
		},
		continuous_spread = {
			min_pitch = {
				lerp_basic = 2.9,
				lerp_perfect = 2.05,
			},
			min_yaw = {
				lerp_basic = 2.9,
				lerp_perfect = 2.05,
			},
		},
	},
	crouch_still = {
		inherits = {
			"default_autogun_assault",
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
			"default_autogun_assault",
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

local p1_m1_multi = 1.25

spread_templates.autogun_assault_p1_m1 = {
	still = {
		max_spread = {
			pitch = 8,
			yaw = 8,
		},
		randomized_spread = {
			first_shot_min_ratio = 0.3,
			first_shot_random_ratio = 0.5,
			min_ratio = 0.15,
			random_ratio = 0.75,
		},
		decay = {
			from_shooting_grace_time = 0.3,
			shooting = {
				pitch = 0.35,
				yaw = 0.35,
			},
			idle = {
				pitch = 1.75,
				yaw = 1.75,
			},
		},
		continuous_spread = {
			min_pitch = {
				lerp_basic = 2,
				lerp_perfect = 1.4,
			},
			min_yaw = {
				lerp_basic = 2,
				lerp_perfect = 1.4,
			},
		},
		immediate_spread = {
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
					pitch = {
						lerp_basic = 0.45 * p1_m1_multi,
						lerp_perfect = 0.25 * p1_m1_multi,
					},
					yaw = {
						lerp_basic = 0.45 * p1_m1_multi,
						lerp_perfect = 0.25 * p1_m1_multi,
					},
				},
				{
					pitch = {
						lerp_basic = 0.25 * p1_m1_multi,
						lerp_perfect = 0.15 * p1_m1_multi,
					},
					yaw = {
						lerp_basic = 0.25 * p1_m1_multi,
						lerp_perfect = 0.15 * p1_m1_multi,
					},
				},
				{
					pitch = {
						lerp_basic = 0.45 * p1_m1_multi,
						lerp_perfect = 0.25 * p1_m1_multi,
					},
					yaw = {
						lerp_basic = 0.45 * p1_m1_multi,
						lerp_perfect = 0.25 * p1_m1_multi,
					},
				},
				{
					pitch = {
						lerp_basic = 0.6 * p1_m1_multi,
						lerp_perfect = 0.4 * p1_m1_multi,
					},
					yaw = {
						lerp_basic = 0.6 * p1_m1_multi,
						lerp_perfect = 0.4 * p1_m1_multi,
					},
				},
				{
					pitch = {
						lerp_basic = 0.35 * p1_m1_multi,
						lerp_perfect = 0.2 * p1_m1_multi,
					},
					yaw = {
						lerp_basic = 0.35 * p1_m1_multi,
						lerp_perfect = 0.2 * p1_m1_multi,
					},
				},
				{
					pitch = {
						lerp_basic = 0.3 * p1_m1_multi,
						lerp_perfect = 0.15 * p1_m1_multi,
					},
					yaw = {
						lerp_basic = 0.3 * p1_m1_multi,
						lerp_perfect = 0.15 * p1_m1_multi,
					},
				},
				{
					pitch = {
						lerp_basic = 0.3 * p1_m1_multi,
						lerp_perfect = 0.15 * p1_m1_multi,
					},
					yaw = {
						lerp_basic = 0.3 * p1_m1_multi,
						lerp_perfect = 0.15 * p1_m1_multi,
					},
				},
				{
					pitch = {
						lerp_basic = 0.3 * p1_m1_multi,
						lerp_perfect = 0.15 * p1_m1_multi,
					},
					yaw = {
						lerp_basic = 0.3 * p1_m1_multi,
						lerp_perfect = 0.15 * p1_m1_multi,
					},
				},
				{
					pitch = {
						lerp_basic = 0.3 * p1_m1_multi,
						lerp_perfect = 0.15 * p1_m1_multi,
					},
					yaw = {
						lerp_basic = 0.3 * p1_m1_multi,
						lerp_perfect = 0.15 * p1_m1_multi,
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
			"default_autogun_assault",
			"still",
		},
		continuous_spread = {
			min_pitch = {
				lerp_basic = 2.9,
				lerp_perfect = 2.05,
			},
			min_yaw = {
				lerp_basic = 2.9,
				lerp_perfect = 2.05,
			},
		},
	},
	crouch_still = {
		inherits = {
			"default_autogun_assault",
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
			"default_autogun_assault",
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

local p1_m2_multi = 1

spread_templates.autogun_assault_p1_m2 = {
	still = {
		max_spread = {
			pitch = 8,
			yaw = 8,
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
				pitch = 0.75,
				yaw = 0.75,
			},
			idle = {
				pitch = 2.25,
				yaw = 2.25,
			},
		},
		continuous_spread = {
			min_pitch = {
				lerp_basic = 2,
				lerp_perfect = 1.4,
			},
			min_yaw = {
				lerp_basic = 2,
				lerp_perfect = 1.4,
			},
		},
		immediate_spread = {
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
					pitch = {
						lerp_basic = 0.45 * p1_m2_multi,
						lerp_perfect = 0.25 * p1_m2_multi,
					},
					yaw = {
						lerp_basic = 0.45 * p1_m2_multi,
						lerp_perfect = 0.25 * p1_m2_multi,
					},
				},
				{
					pitch = {
						lerp_basic = 0.25 * p1_m2_multi,
						lerp_perfect = 0.15 * p1_m2_multi,
					},
					yaw = {
						lerp_basic = 0.25 * p1_m2_multi,
						lerp_perfect = 0.15 * p1_m2_multi,
					},
				},
				{
					pitch = {
						lerp_basic = 0.45 * p1_m2_multi,
						lerp_perfect = 0.25 * p1_m2_multi,
					},
					yaw = {
						lerp_basic = 0.45 * p1_m2_multi,
						lerp_perfect = 0.25 * p1_m2_multi,
					},
				},
				{
					pitch = {
						lerp_basic = 0.6 * p1_m2_multi,
						lerp_perfect = 0.4 * p1_m2_multi,
					},
					yaw = {
						lerp_basic = 0.6 * p1_m2_multi,
						lerp_perfect = 0.4 * p1_m2_multi,
					},
				},
				{
					pitch = {
						lerp_basic = 0.35 * p1_m2_multi,
						lerp_perfect = 0.2 * p1_m2_multi,
					},
					yaw = {
						lerp_basic = 0.35 * p1_m2_multi,
						lerp_perfect = 0.2 * p1_m2_multi,
					},
				},
				{
					pitch = {
						lerp_basic = 0.3 * p1_m2_multi,
						lerp_perfect = 0.15 * p1_m2_multi,
					},
					yaw = {
						lerp_basic = 0.3 * p1_m2_multi,
						lerp_perfect = 0.15 * p1_m2_multi,
					},
				},
				{
					pitch = {
						lerp_basic = 0.3 * p1_m2_multi,
						lerp_perfect = 0.15 * p1_m2_multi,
					},
					yaw = {
						lerp_basic = 0.3 * p1_m2_multi,
						lerp_perfect = 0.15 * p1_m2_multi,
					},
				},
				{
					pitch = {
						lerp_basic = 0.3 * p1_m2_multi,
						lerp_perfect = 0.15 * p1_m2_multi,
					},
					yaw = {
						lerp_basic = 0.3 * p1_m2_multi,
						lerp_perfect = 0.15 * p1_m2_multi,
					},
				},
				{
					pitch = {
						lerp_basic = 0.3 * p1_m2_multi,
						lerp_perfect = 0.15 * p1_m2_multi,
					},
					yaw = {
						lerp_basic = 0.3 * p1_m2_multi,
						lerp_perfect = 0.15 * p1_m2_multi,
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
			"default_autogun_assault",
			"still",
		},
		continuous_spread = {
			min_pitch = {
				lerp_basic = 2.5,
				lerp_perfect = 2.05,
			},
			min_yaw = {
				lerp_basic = 2.5,
				lerp_perfect = 2.05,
			},
		},
	},
	crouch_still = {
		inherits = {
			"default_autogun_assault",
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
			"default_autogun_assault",
			"still",
		},
		continuous_spread = {
			min_pitch = {
				lerp_basic = 2.75,
				lerp_perfect = 2.1,
			},
			min_yaw = {
				lerp_basic = 2.75,
				lerp_perfect = 2.1,
			},
		},
	},
}
spread_templates.default_autogun_burst = {
	still = {
		max_spread = {
			pitch = 8,
			yaw = 8,
		},
		randomized_spread = {
			first_shot_min_ratio = 0.05,
			first_shot_random_ratio = 0.05,
			min_ratio = 0.35,
			random_ratio = 0.65,
		},
		decay = {
			from_shooting_grace_time = 0.25,
			shooting = {
				pitch = 0.05,
				yaw = 0.05,
			},
			idle = {
				pitch = 0.75,
				yaw = 0.75,
			},
		},
		continuous_spread = {
			min_pitch = {
				lerp_basic = 2,
				lerp_perfect = 1.2,
			},
			min_yaw = {
				lerp_basic = 2,
				lerp_perfect = 1.2,
			},
		},
		immediate_spread = {
			num_shots_clear_time = 0.75,
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
					pitch = 0.1,
					yaw = 0.1,
				},
				{
					pitch = 0.15,
					yaw = 0.15,
				},
				{
					pitch = 0.2,
					yaw = 0.2,
				},
			},
		},
	},
	moving = {
		inherits = {
			"default_autogun_burst",
			"still",
		},
		continuous_spread = {
			min_pitch = {
				lerp_basic = 2.2,
				lerp_perfect = 1.4,
			},
			min_yaw = {
				lerp_basic = 2.2,
				lerp_perfect = 1.4,
			},
		},
	},
	crouch_still = {
		inherits = {
			"default_autogun_burst",
			"still",
		},
		continuous_spread = {
			min_pitch = {
				lerp_basic = 1.4,
				lerp_perfect = 1,
			},
			min_yaw = {
				lerp_basic = 1.4,
				lerp_perfect = 1,
			},
		},
	},
	crouch_moving = {
		inherits = {
			"default_autogun_burst",
			"still",
		},
		continuous_spread = {
			min_pitch = {
				lerp_basic = 2,
				lerp_perfect = 1.2,
			},
			min_yaw = {
				lerp_basic = 2,
				lerp_perfect = 1.2,
			},
		},
	},
}
spread_templates.default_autogun_burst_p3_m2 = {
	still = {
		max_spread = {
			pitch = 8,
			yaw = 8,
		},
		randomized_spread = {
			first_shot_min_ratio = 0.05,
			first_shot_random_ratio = 0.05,
			min_ratio = 0.35,
			random_ratio = 0.65,
		},
		decay = {
			from_shooting_grace_time = 0.25,
			shooting = {
				pitch = 0.05,
				yaw = 0.05,
			},
			idle = {
				pitch = 0.75,
				yaw = 0.75,
			},
		},
		continuous_spread = {
			min_pitch = {
				lerp_basic = 2,
				lerp_perfect = 1.2,
			},
			min_yaw = {
				lerp_basic = 2,
				lerp_perfect = 1.2,
			},
		},
		immediate_spread = {
			num_shots_clear_time = 0.75,
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
					pitch = 0.15,
					yaw = 0.15,
				},
				{
					pitch = 0.2,
					yaw = 0.2,
				},
			},
		},
	},
	moving = {
		inherits = {
			"default_autogun_burst",
			"still",
		},
		continuous_spread = {
			min_pitch = {
				lerp_basic = 2.2,
				lerp_perfect = 1.4,
			},
			min_yaw = {
				lerp_basic = 2.2,
				lerp_perfect = 1.4,
			},
		},
	},
	crouch_still = {
		inherits = {
			"default_autogun_burst",
			"still",
		},
		continuous_spread = {
			min_pitch = {
				lerp_basic = 1.4,
				lerp_perfect = 1,
			},
			min_yaw = {
				lerp_basic = 1.4,
				lerp_perfect = 1,
			},
		},
	},
	crouch_moving = {
		inherits = {
			"default_autogun_burst",
			"still",
		},
		continuous_spread = {
			min_pitch = {
				lerp_basic = 2,
				lerp_perfect = 1.2,
			},
			min_yaw = {
				lerp_basic = 2,
				lerp_perfect = 1.2,
			},
		},
	},
}
spread_templates.default_autogun_killshot = {
	still = {
		max_spread = {
			pitch = 8,
			yaw = 8,
		},
		decay = {
			from_shooting_grace_time = 0.1,
			shooting = {
				pitch = 0.25,
				yaw = 0.25,
			},
			idle = {
				pitch = 1.25,
				yaw = 1.25,
			},
		},
		continuous_spread = {
			min_pitch = 0,
			min_yaw = 0,
		},
		immediate_spread = {
			num_shots_clear_time = 0.35,
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
					pitch = 0,
					yaw = 0,
				},
				{
					pitch = 0,
					yaw = 0,
				},
				{
					pitch = 0,
					yaw = 0,
				},
				{
					pitch = 0.001,
					yaw = 0.001,
				},
				{
					pitch = 0.001,
					yaw = 0.001,
				},
				{
					pitch = 0.001,
					yaw = 0.001,
				},
				{
					pitch = 0.002,
					yaw = 0.002,
				},
			},
		},
	},
	moving = {
		inherits = {
			"default_autogun_killshot",
			"still",
		},
		continuous_spread = {
			min_pitch = 0,
			min_yaw = 0,
		},
	},
	crouch_still = {
		inherits = {
			"default_autogun_killshot",
			"still",
		},
		continuous_spread = {
			min_pitch = 0,
			min_yaw = 0,
		},
	},
	crouch_moving = {
		inherits = {
			"default_autogun_killshot",
			"still",
		},
		continuous_spread = {
			min_pitch = 0,
			min_yaw = 0,
		},
	},
}
spread_templates.default_autogun_alternate_fire_killshot = {
	still = {
		max_spread = {
			pitch = 8,
			yaw = 8,
		},
		decay = {
			from_shooting_grace_time = 0.1,
			shooting = {
				pitch = 0.25,
				yaw = 0.25,
			},
			idle = {
				pitch = 1.25,
				yaw = 1.25,
			},
		},
		continuous_spread = {
			min_pitch = 0,
			min_yaw = 0,
		},
		start_spread = {
			start_pitch = 0,
			start_yaw = 0,
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
					pitch = 0,
					yaw = 0,
				},
				{
					pitch = 0,
					yaw = 0,
				},
				{
					pitch = 0,
					yaw = 0,
				},
			},
		},
		visual_spread_settings = {
			horizontal_speed = 1,
			intensity = 0.4,
			rotation_speed = 0.5,
			speed_change_frequency = 1,
			speed_variance_max = 1.25,
			speed_variance_min = 0.75,
		},
	},
	moving = {
		inherits = {
			"default_autogun_alternate_fire_killshot",
			"still",
		},
		continuous_spread = {
			min_pitch = 0,
			min_yaw = 0,
		},
	},
	crouch_still = {
		inherits = {
			"default_autogun_alternate_fire_killshot",
			"still",
		},
		continuous_spread = {
			min_pitch = 0,
			min_yaw = 0,
		},
	},
	crouch_moving = {
		inherits = {
			"default_autogun_alternate_fire_killshot",
			"still",
		},
		continuous_spread = {
			min_pitch = 0,
			min_yaw = 0,
		},
	},
}
spread_templates.default_autogun_spraynpray = {
	still = {
		max_spread = {
			pitch = 12,
			yaw = 14,
		},
		randomized_spread = {
			first_shot_min_ratio = 0.1,
			first_shot_random_ratio = 0.65,
			max_pitch_delta = 0.35,
			max_yaw_delta = 0.45,
			min_ratio = 0.35,
			random_ratio = 0.35,
		},
		decay = {
			from_shooting_grace_time = 0.3,
			shooting = {
				pitch = 1.75,
				yaw = 0.15,
			},
			idle = {
				pitch = 2,
				yaw = 1.75,
			},
		},
		continuous_spread = {
			min_pitch = 1.5,
			min_yaw = 3.5,
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
					pitch = 0.6,
					yaw = 0.6,
				},
				{
					pitch = 0.75,
					yaw = 0.75,
				},
				{
					pitch = 0.6,
					yaw = 0.6,
				},
				{
					pitch = 0.45,
					yaw = 0.525,
				},
				{
					pitch = 0.3,
					yaw = 0.45,
				},
				{
					pitch = 0.2,
					yaw = 0.3,
				},
				{
					pitch = 0.15,
					yaw = 0.225,
				},
				{
					pitch = 0,
					yaw = 0,
				},
				{
					pitch = 0,
					yaw = 0,
				},
				{
					pitch = 0,
					yaw = 0,
				},
				{
					pitch = 0.2,
					yaw = 0.3,
				},
				{
					pitch = 0.15,
					yaw = 0.225,
				},
				{
					pitch = 0,
					yaw = 0,
				},
				{
					pitch = 0,
					yaw = 0,
				},
				{
					pitch = 0,
					yaw = 0,
				},
				{
					pitch = 0.4,
					yaw = 0.6,
				},
				{
					pitch = 0.15,
					yaw = 0.225,
				},
				{
					pitch = 0,
					yaw = 0,
				},
				{
					pitch = 0,
					yaw = 0,
				},
				{
					pitch = 0,
					yaw = 0,
				},
				{
					pitch = 0.2,
					yaw = 0.3,
				},
				{
					pitch = 0.15,
					yaw = 0.225,
				},
				{
					pitch = 0,
					yaw = 0,
				},
				{
					pitch = 0,
					yaw = 0,
				},
				{
					pitch = 0,
					yaw = 0,
				},
				{
					pitch = 0.4,
					yaw = 0.6,
				},
				{
					pitch = 0.15,
					yaw = 0.225,
				},
				{
					pitch = 0,
					yaw = 0,
				},
				{
					pitch = 0,
					yaw = 0,
				},
				{
					pitch = 0,
					yaw = 0,
				},
				{
					pitch = 0.2,
					yaw = 0.3,
				},
				{
					pitch = 0.15,
					yaw = 0.225,
				},
				{
					pitch = 0,
					yaw = 0,
				},
				{
					pitch = 0,
					yaw = 0,
				},
				{
					pitch = 0,
					yaw = 0,
				},
				{
					pitch = 0.4,
					yaw = 0.6,
				},
				{
					pitch = 0.15,
					yaw = 0.225,
				},
				{
					pitch = 0,
					yaw = 0,
				},
				{
					pitch = 0,
					yaw = 0,
				},
				{
					pitch = 0,
					yaw = 0,
				},
				{
					pitch = 0.2,
					yaw = 0.3,
				},
				{
					pitch = 0.15,
					yaw = 0.225,
				},
				{
					pitch = 0,
					yaw = 0,
				},
				{
					pitch = 0,
					yaw = 0,
				},
				{
					pitch = 0,
					yaw = 0,
				},
				{
					pitch = 0.4,
					yaw = 0.6,
				},
				{
					pitch = 0.15,
					yaw = 0.225,
				},
				{
					pitch = 0,
					yaw = 0,
				},
				{
					pitch = 0,
					yaw = 0,
				},
				{
					pitch = 0,
					yaw = 0,
				},
				{
					pitch = 0.2,
					yaw = 0.3,
				},
				{
					pitch = 0.15,
					yaw = 0.225,
				},
				{
					pitch = 0,
					yaw = 0,
				},
				{
					pitch = 0,
					yaw = 0,
				},
				{
					pitch = 0,
					yaw = 0,
				},
				{
					pitch = 0.1,
					yaw = 0.15,
				},
				{
					pitch = 0.075,
					yaw = 0.1125,
				},
				{
					pitch = 0,
					yaw = 0,
				},
				{
					pitch = 0,
					yaw = 0,
				},
				{
					pitch = 0,
					yaw = 0,
				},
				{
					pitch = 0.075,
					yaw = 0.075,
				},
			},
		},
	},
	moving = {
		inherits = {
			"default_autogun_spraynpray",
			"still",
		},
		continuous_spread = {
			min_pitch = 2,
			min_yaw = 5,
		},
	},
	crouch_still = {
		inherits = {
			"default_autogun_spraynpray",
			"still",
		},
		continuous_spread = {
			min_pitch = 1,
			min_yaw = 3,
		},
	},
	crouch_moving = {
		inherits = {
			"default_autogun_spraynpray",
			"still",
		},
		continuous_spread = {
			min_pitch = 3,
			min_yaw = 6,
		},
	},
}

local p2_perfect_multi = 0.75

spread_templates.autogun_p2_m1_hip = {
	still = {
		max_spread = {
			pitch = 8,
			yaw = 8,
		},
		randomized_spread = {
			first_shot_min_ratio = 0.2,
			first_shot_random_ratio = 0.5,
			max_pitch_delta = 0.75,
			max_yaw_delta = 0.75,
			min_ratio = 0.25,
			random_ratio = 0.75,
		},
		decay = {
			from_shooting_grace_time = 0.6,
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
				lerp_basic = 2.4,
				lerp_perfect = 1.8,
			},
			min_yaw = {
				lerp_basic = 2.4,
				lerp_perfect = 1.8,
			},
		},
		immediate_spread = {
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
					pitch = {
						lerp_basic = 0.75,
						lerp_perfect = 0.45 * p2_perfect_multi,
					},
					yaw = {
						lerp_basic = 0.75,
						lerp_perfect = 0.45 * p2_perfect_multi,
					},
				},
				{
					pitch = {
						lerp_basic = 0.69,
						lerp_perfect = 0.41 * p2_perfect_multi,
					},
					yaw = {
						lerp_basic = 0.69,
						lerp_perfect = 0.41 * p2_perfect_multi,
					},
				},
				{
					pitch = {
						lerp_basic = 0.56,
						lerp_perfect = 0.34 * p2_perfect_multi,
					},
					yaw = {
						lerp_basic = 0.56,
						lerp_perfect = 0.34 * p2_perfect_multi,
					},
				},
				{
					pitch = {
						lerp_basic = 0.44,
						lerp_perfect = 0.26 * p2_perfect_multi,
					},
					yaw = {
						lerp_basic = 0.44,
						lerp_perfect = 0.26 * p2_perfect_multi,
					},
				},
				{
					pitch = {
						lerp_basic = 0.38,
						lerp_perfect = 0.23 * p2_perfect_multi,
					},
					yaw = {
						lerp_basic = 0.38,
						lerp_perfect = 0.23 * p2_perfect_multi,
					},
				},
				{
					pitch = {
						lerp_basic = 0.31,
						lerp_perfect = 0.19 * p2_perfect_multi,
					},
					yaw = {
						lerp_basic = 0.31,
						lerp_perfect = 0.19 * p2_perfect_multi,
					},
				},
				{
					pitch = {
						lerp_basic = 0.28,
						lerp_perfect = 0.17 * p2_perfect_multi,
					},
					yaw = {
						lerp_basic = 0.28,
						lerp_perfect = 0.17 * p2_perfect_multi,
					},
				},
				{
					pitch = {
						lerp_basic = 0.25,
						lerp_perfect = 0.15 * p2_perfect_multi,
					},
					yaw = {
						lerp_basic = 0.25,
						lerp_perfect = 0.15 * p2_perfect_multi,
					},
				},
				{
					pitch = {
						lerp_basic = 0.22,
						lerp_perfect = 0.13 * p2_perfect_multi,
					},
					yaw = {
						lerp_basic = 0.22,
						lerp_perfect = 0.13 * p2_perfect_multi,
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
			"autogun_p2_m1_hip",
			"still",
		},
		continuous_spread = {
			min_pitch = {
				lerp_basic = 2.88,
				lerp_perfect = 2.16,
			},
			min_yaw = {
				lerp_basic = 2.88,
				lerp_perfect = 2.16,
			},
		},
	},
	crouch_still = {
		inherits = {
			"autogun_p2_m1_hip",
			"still",
		},
		continuous_spread = {
			min_pitch = {
				lerp_basic = 1.92,
				lerp_perfect = 1.44,
			},
			min_yaw = {
				lerp_basic = 1.92,
				lerp_perfect = 1.44,
			},
		},
	},
	crouch_moving = {
		inherits = {
			"autogun_p2_m1_hip",
			"still",
		},
		continuous_spread = {
			min_pitch = {
				lerp_basic = 3.6,
				lerp_perfect = 2.7,
			},
			min_yaw = {
				lerp_basic = 3.6,
				lerp_perfect = 2.7,
			},
		},
	},
}
spread_templates.autogun_p2_m1_ads = {
	still = {
		max_spread = {
			pitch = 12,
			yaw = 14,
		},
		randomized_spread = {
			first_shot_min_ratio = 0.1,
			first_shot_random_ratio = 0.65,
			max_pitch_delta = 0.35,
			max_yaw_delta = 0.9,
			min_ratio = 0.35,
			random_ratio = 0.35,
		},
		decay = {
			from_shooting_grace_time = 0.3,
			shooting = {
				pitch = 1.75,
				yaw = 0.3,
			},
			idle = {
				pitch = 2,
				yaw = 1.75,
			},
		},
		continuous_spread = {
			min_pitch = 2,
			min_yaw = 3.5,
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
					pitch = 0.6,
					yaw = 0.6,
				},
				{
					pitch = 0.75,
					yaw = 0.75,
				},
				{
					pitch = 0.6,
					yaw = 0.6,
				},
				{
					pitch = 0.45,
					yaw = 0.525,
				},
				{
					pitch = 0.3,
					yaw = 0.45,
				},
				{
					pitch = 0.2,
					yaw = 0.3,
				},
				{
					pitch = 0.15,
					yaw = 0.225,
				},
				{
					pitch = 0,
					yaw = 0,
				},
				{
					pitch = 0,
					yaw = 0,
				},
				{
					pitch = 0,
					yaw = 0,
				},
				{
					pitch = 0.2,
					yaw = 0.3,
				},
				{
					pitch = 0.15,
					yaw = 0.225,
				},
				{
					pitch = 0,
					yaw = 0,
				},
				{
					pitch = 0,
					yaw = 0,
				},
				{
					pitch = 0,
					yaw = 0,
				},
				{
					pitch = 0.4,
					yaw = 0.6,
				},
				{
					pitch = 0.15,
					yaw = 0.225,
				},
				{
					pitch = 0,
					yaw = 0,
				},
				{
					pitch = 0,
					yaw = 0,
				},
				{
					pitch = 0,
					yaw = 0,
				},
				{
					pitch = 0.2,
					yaw = 0.3,
				},
				{
					pitch = 0.15,
					yaw = 0.225,
				},
				{
					pitch = 0,
					yaw = 0,
				},
				{
					pitch = 0,
					yaw = 0,
				},
				{
					pitch = 0,
					yaw = 0,
				},
				{
					pitch = 0.4,
					yaw = 0.6,
				},
				{
					pitch = 0.15,
					yaw = 0.225,
				},
				{
					pitch = 0,
					yaw = 0,
				},
				{
					pitch = 0,
					yaw = 0,
				},
				{
					pitch = 0,
					yaw = 0,
				},
				{
					pitch = 0.2,
					yaw = 0.3,
				},
				{
					pitch = 0.15,
					yaw = 0.225,
				},
				{
					pitch = 0,
					yaw = 0,
				},
				{
					pitch = 0,
					yaw = 0,
				},
				{
					pitch = 0,
					yaw = 0,
				},
				{
					pitch = 0.4,
					yaw = 0.6,
				},
				{
					pitch = 0.15,
					yaw = 0.225,
				},
				{
					pitch = 0,
					yaw = 0,
				},
				{
					pitch = 0,
					yaw = 0,
				},
				{
					pitch = 0,
					yaw = 0,
				},
				{
					pitch = 0.2,
					yaw = 0.3,
				},
				{
					pitch = 0.15,
					yaw = 0.225,
				},
				{
					pitch = 0,
					yaw = 0,
				},
				{
					pitch = 0,
					yaw = 0,
				},
				{
					pitch = 0,
					yaw = 0,
				},
				{
					pitch = 0.4,
					yaw = 0.6,
				},
				{
					pitch = 0.15,
					yaw = 0.225,
				},
				{
					pitch = 0,
					yaw = 0,
				},
				{
					pitch = 0,
					yaw = 0,
				},
				{
					pitch = 0,
					yaw = 0,
				},
				{
					pitch = 0.2,
					yaw = 0.3,
				},
				{
					pitch = 0.15,
					yaw = 0.225,
				},
				{
					pitch = 0,
					yaw = 0,
				},
				{
					pitch = 0,
					yaw = 0,
				},
				{
					pitch = 0,
					yaw = 0,
				},
				{
					pitch = 0.1,
					yaw = 0.15,
				},
				{
					pitch = 0.075,
					yaw = 0.1125,
				},
				{
					pitch = 0,
					yaw = 0,
				},
				{
					pitch = 0,
					yaw = 0,
				},
				{
					pitch = 0,
					yaw = 0,
				},
				{
					pitch = 0.075,
					yaw = 0.075,
				},
			},
		},
	},
	moving = {
		inherits = {
			"autogun_p2_m1_ads",
			"still",
		},
		continuous_spread = {
			min_pitch = 2,
			min_yaw = 5,
		},
	},
	crouch_still = {
		inherits = {
			"autogun_p2_m1_ads",
			"still",
		},
		continuous_spread = {
			min_pitch = 1,
			min_yaw = 3,
		},
	},
	crouch_moving = {
		inherits = {
			"autogun_p2_m1_ads",
			"still",
		},
		continuous_spread = {
			min_pitch = 3,
			min_yaw = 6,
		},
	},
}
spread_templates.autogun_p2_m2_hip = {
	still = {
		max_spread = {
			pitch = 8,
			yaw = 8,
		},
		randomized_spread = {
			first_shot_min_ratio = 0.15,
			first_shot_random_ratio = 0.45,
			max_pitch_delta = 0.75,
			max_yaw_delta = 0.75,
			min_ratio = 0.25,
			random_ratio = 0.75,
		},
		decay = {
			from_shooting_grace_time = 0.3,
			shooting = {
				pitch = 0.4,
				yaw = 0.4,
			},
			idle = {
				pitch = 2,
				yaw = 2,
			},
		},
		continuous_spread = {
			min_pitch = {
				lerp_basic = 2.4,
				lerp_perfect = 1.8,
			},
			min_yaw = {
				lerp_basic = 2.4,
				lerp_perfect = 1.8,
			},
		},
		immediate_spread = {
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
					pitch = {
						lerp_basic = 0.56,
						lerp_perfect = 0.34,
					},
					yaw = {
						lerp_basic = 0.56,
						lerp_perfect = 0.34,
					},
				},
				{
					pitch = {
						lerp_basic = 0.51,
						lerp_perfect = 0.31,
					},
					yaw = {
						lerp_basic = 0.51,
						lerp_perfect = 0.31,
					},
				},
				{
					pitch = {
						lerp_basic = 0.43,
						lerp_perfect = 0.26,
					},
					yaw = {
						lerp_basic = 0.43,
						lerp_perfect = 0.26,
					},
				},
				{
					pitch = {
						lerp_basic = 0.33,
						lerp_perfect = 0.2,
					},
					yaw = {
						lerp_basic = 0.33,
						lerp_perfect = 0.2,
					},
				},
				{
					pitch = {
						lerp_basic = 0.29,
						lerp_perfect = 0.17,
					},
					yaw = {
						lerp_basic = 0.29,
						lerp_perfect = 0.17,
					},
				},
				{
					pitch = {
						lerp_basic = 0.24,
						lerp_perfect = 0.14,
					},
					yaw = {
						lerp_basic = 0.24,
						lerp_perfect = 0.14,
					},
				},
				{
					pitch = {
						lerp_basic = 0.21,
						lerp_perfect = 0.13,
					},
					yaw = {
						lerp_basic = 0.21,
						lerp_perfect = 0.13,
					},
				},
				{
					pitch = {
						lerp_basic = 0.19,
						lerp_perfect = 0.11,
					},
					yaw = {
						lerp_basic = 0.19,
						lerp_perfect = 0.11,
					},
				},
				{
					pitch = {
						lerp_basic = 0.16,
						lerp_perfect = 0.1,
					},
					yaw = {
						lerp_basic = 0.16,
						lerp_perfect = 0.1,
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
			"autogun_p2_m2_hip",
			"still",
		},
		continuous_spread = {
			min_pitch = {
				lerp_basic = 2.88,
				lerp_perfect = 2.16,
			},
			min_yaw = {
				lerp_basic = 2.88,
				lerp_perfect = 2.16,
			},
		},
	},
	crouch_still = {
		inherits = {
			"autogun_p2_m2_hip",
			"still",
		},
		continuous_spread = {
			min_pitch = {
				lerp_basic = 1.92,
				lerp_perfect = 1.44,
			},
			min_yaw = {
				lerp_basic = 1.92,
				lerp_perfect = 1.44,
			},
		},
	},
	crouch_moving = {
		inherits = {
			"autogun_p2_m2_hip",
			"still",
		},
		continuous_spread = {
			min_pitch = {
				lerp_basic = 3.6,
				lerp_perfect = 2.7,
			},
			min_yaw = {
				lerp_basic = 3.6,
				lerp_perfect = 2.7,
			},
		},
	},
}
spread_templates.autogun_p2_m2_ads = {
	still = {
		max_spread = {
			pitch = 8,
			yaw = 8,
		},
		randomized_spread = {
			first_shot_min_ratio = 0.1275,
			first_shot_random_ratio = 0.3825,
			max_pitch_delta = 1,
			max_yaw_delta = 1,
			min_ratio = 0.2875,
			random_ratio = 0.6325,
		},
		decay = {
			from_shooting_grace_time = 0.3,
			shooting = {
				pitch = {
					lerp_basic = 0.8500000000000001,
					lerp_perfect = 1.25,
				},
				yaw = {
					lerp_basic = 0.8500000000000001,
					lerp_perfect = 1.25,
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
				lerp_basic = 1.75,
				lerp_perfect = 1.25,
			},
			min_yaw = {
				lerp_basic = 2.5,
				lerp_perfect = 1.75,
			},
		},
		immediate_spread = {
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
					pitch = {
						lerp_basic = 0.42,
						lerp_perfect = 0.252,
					},
					yaw = {
						lerp_basic = 0.42,
						lerp_perfect = 0.252,
					},
				},
				{
					pitch = {
						lerp_basic = 0.48999999999999994,
						lerp_perfect = 0.294,
					},
					yaw = {
						lerp_basic = 0.48999999999999994,
						lerp_perfect = 0.294,
					},
				},
				{
					pitch = {
						lerp_basic = 0.5599999999999999,
						lerp_perfect = 0.336,
					},
					yaw = {
						lerp_basic = 0.5599999999999999,
						lerp_perfect = 0.336,
					},
				},
				{
					pitch = {
						lerp_basic = 0.63,
						lerp_perfect = 0.378,
					},
					yaw = {
						lerp_basic = 0.63,
						lerp_perfect = 0.378,
					},
				},
				{
					pitch = {
						lerp_basic = 0.7,
						lerp_perfect = 0.42,
					},
					yaw = {
						lerp_basic = 0.7,
						lerp_perfect = 0.42,
					},
				},
				{
					pitch = {
						lerp_basic = 0.64,
						lerp_perfect = 0.38,
					},
					yaw = {
						lerp_basic = 0.64,
						lerp_perfect = 0.38,
					},
				},
				{
					pitch = {
						lerp_basic = 0.54,
						lerp_perfect = 0.32,
					},
					yaw = {
						lerp_basic = 0.54,
						lerp_perfect = 0.32,
					},
				},
				{
					pitch = {
						lerp_basic = 0.41,
						lerp_perfect = 0.25,
					},
					yaw = {
						lerp_basic = 0.41,
						lerp_perfect = 0.25,
					},
				},
				{
					pitch = {
						lerp_basic = 0.36,
						lerp_perfect = 0.22,
					},
					yaw = {
						lerp_basic = 0.36,
						lerp_perfect = 0.22,
					},
				},
				{
					pitch = {
						lerp_basic = 0.3,
						lerp_perfect = 0.18,
					},
					yaw = {
						lerp_basic = 0.3,
						lerp_perfect = 0.18,
					},
				},
				{
					pitch = {
						lerp_basic = 0.26,
						lerp_perfect = 0.16,
					},
					yaw = {
						lerp_basic = 0.26,
						lerp_perfect = 0.16,
					},
				},
				{
					pitch = {
						lerp_basic = 0.24,
						lerp_perfect = 0.14,
					},
					yaw = {
						lerp_basic = 0.24,
						lerp_perfect = 0.14,
					},
				},
				{
					pitch = {
						lerp_basic = 0.2,
						lerp_perfect = 0.12,
					},
					yaw = {
						lerp_basic = 0.2,
						lerp_perfect = 0.12,
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
			"autogun_p2_m2_ads",
			"still",
		},
		continuous_spread = {
			min_pitch = {
				lerp_basic = 2.25,
				lerp_perfect = 1.75,
			},
			min_yaw = {
				lerp_basic = 3,
				lerp_perfect = 2.5,
			},
		},
	},
	crouch_still = {
		inherits = {
			"autogun_p2_m2_ads",
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
	crouch_moving = {
		inherits = {
			"autogun_p2_m2_ads",
			"still",
		},
		continuous_spread = {
			min_pitch = {
				lerp_basic = 2.5,
				lerp_perfect = 1.5,
			},
			min_yaw = {
				lerp_basic = 3.25,
				lerp_perfect = 2,
			},
		},
	},
}
spread_templates.autogun_p2_m3_hip = {
	still = {
		max_spread = {
			pitch = 8,
			yaw = 8,
		},
		randomized_spread = {
			first_shot_min_ratio = 0.15,
			first_shot_random_ratio = 0.55,
			max_pitch_delta = 0.75,
			max_yaw_delta = 0.75,
			min_ratio = 0.15,
			random_ratio = 0.85,
		},
		decay = {
			from_shooting_grace_time = 0.3,
			shooting = {
				pitch = 0.4,
				yaw = 0.4,
			},
			idle = {
				pitch = 2,
				yaw = 2,
			},
		},
		continuous_spread = {
			min_pitch = {
				lerp_basic = 2.4,
				lerp_perfect = 1.8,
			},
			min_yaw = {
				lerp_basic = 2.4,
				lerp_perfect = 1.8,
			},
		},
		immediate_spread = {
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
					pitch = {
						lerp_basic = 0.56,
						lerp_perfect = 0.34,
					},
					yaw = {
						lerp_basic = 0.56,
						lerp_perfect = 0.34,
					},
				},
				{
					pitch = {
						lerp_basic = 0.51,
						lerp_perfect = 0.31,
					},
					yaw = {
						lerp_basic = 0.51,
						lerp_perfect = 0.31,
					},
				},
				{
					pitch = {
						lerp_basic = 0.43,
						lerp_perfect = 0.26,
					},
					yaw = {
						lerp_basic = 0.43,
						lerp_perfect = 0.26,
					},
				},
				{
					pitch = {
						lerp_basic = 0.33,
						lerp_perfect = 0.2,
					},
					yaw = {
						lerp_basic = 0.33,
						lerp_perfect = 0.2,
					},
				},
				{
					pitch = {
						lerp_basic = 0.29,
						lerp_perfect = 0.17,
					},
					yaw = {
						lerp_basic = 0.29,
						lerp_perfect = 0.17,
					},
				},
				{
					pitch = {
						lerp_basic = 0.24,
						lerp_perfect = 0.14,
					},
					yaw = {
						lerp_basic = 0.24,
						lerp_perfect = 0.14,
					},
				},
				{
					pitch = {
						lerp_basic = 0.21,
						lerp_perfect = 0.13,
					},
					yaw = {
						lerp_basic = 0.21,
						lerp_perfect = 0.13,
					},
				},
				{
					pitch = {
						lerp_basic = 0.19,
						lerp_perfect = 0.11,
					},
					yaw = {
						lerp_basic = 0.19,
						lerp_perfect = 0.11,
					},
				},
				{
					pitch = {
						lerp_basic = 0.16,
						lerp_perfect = 0.1,
					},
					yaw = {
						lerp_basic = 0.16,
						lerp_perfect = 0.1,
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
			"autogun_p2_m3_hip",
			"still",
		},
		continuous_spread = {
			min_pitch = {
				lerp_basic = 2.88,
				lerp_perfect = 2.16,
			},
			min_yaw = {
				lerp_basic = 2.88,
				lerp_perfect = 2.16,
			},
		},
	},
	crouch_still = {
		inherits = {
			"autogun_p2_m3_hip",
			"still",
		},
		continuous_spread = {
			min_pitch = {
				lerp_basic = 1.92,
				lerp_perfect = 1.44,
			},
			min_yaw = {
				lerp_basic = 1.92,
				lerp_perfect = 1.44,
			},
		},
	},
	crouch_moving = {
		inherits = {
			"autogun_p2_m3_hip",
			"still",
		},
		continuous_spread = {
			min_pitch = {
				lerp_basic = 3.6,
				lerp_perfect = 2.7,
			},
			min_yaw = {
				lerp_basic = 3.6,
				lerp_perfect = 2.7,
			},
		},
	},
}
spread_templates.autogun_p2_m3_ads = {
	still = {
		max_spread = {
			pitch = 8,
			yaw = 8,
		},
		randomized_spread = {
			first_shot_min_ratio = 0.2,
			first_shot_random_ratio = 0.4,
			max_pitch_delta = 0.95,
			max_yaw_delta = 0.95,
			min_ratio = 0.25,
			random_ratio = 0.55,
		},
		decay = {
			from_shooting_grace_time = 0.3,
			shooting = {
				pitch = 0.1,
				yaw = 0.1,
			},
			idle = {
				pitch = 2.5,
				yaw = 2.5,
			},
		},
		continuous_spread = {
			min_pitch = {
				lerp_basic = 2,
				lerp_perfect = 1.2,
			},
			min_yaw = {
				lerp_basic = 2,
				lerp_perfect = 1.2,
			},
		},
		immediate_spread = {
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
					pitch = {
						lerp_basic = 0.28,
						lerp_perfect = 0.17,
					},
					yaw = {
						lerp_basic = 0.28,
						lerp_perfect = 0.17,
					},
				},
				{
					pitch = {
						lerp_basic = 0.25,
						lerp_perfect = 0.15,
					},
					yaw = {
						lerp_basic = 0.25,
						lerp_perfect = 0.15,
					},
				},
				{
					pitch = {
						lerp_basic = 0.2,
						lerp_perfect = 0.12,
					},
					yaw = {
						lerp_basic = 0.2,
						lerp_perfect = 0.12,
					},
				},
				{
					pitch = {
						lerp_basic = 0.16,
						lerp_perfect = 0.1,
					},
					yaw = {
						lerp_basic = 0.16,
						lerp_perfect = 0.1,
					},
				},
				{
					pitch = {
						lerp_basic = 0.14,
						lerp_perfect = 0.08,
					},
					yaw = {
						lerp_basic = 0.14,
						lerp_perfect = 0.08,
					},
				},
				{
					pitch = {
						lerp_basic = 0.11,
						lerp_perfect = 0.07,
					},
					yaw = {
						lerp_basic = 0.11,
						lerp_perfect = 0.07,
					},
				},
				{
					pitch = {
						lerp_basic = 0.1,
						lerp_perfect = 0.06,
					},
					yaw = {
						lerp_basic = 0.1,
						lerp_perfect = 0.06,
					},
				},
				{
					pitch = {
						lerp_basic = 0.09,
						lerp_perfect = 0.05,
					},
					yaw = {
						lerp_basic = 0.09,
						lerp_perfect = 0.05,
					},
				},
				{
					pitch = {
						lerp_basic = 0.08,
						lerp_perfect = 0.05,
					},
					yaw = {
						lerp_basic = 0.08,
						lerp_perfect = 0.05,
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
			"autogun_p2_m3_ads",
			"still",
		},
		continuous_spread = {
			min_pitch = {
				lerp_basic = 2.88,
				lerp_perfect = 2.16,
			},
			min_yaw = {
				lerp_basic = 2.88,
				lerp_perfect = 2.16,
			},
		},
	},
	crouch_still = {
		inherits = {
			"autogun_p2_m3_ads",
			"still",
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
	},
	crouch_moving = {
		inherits = {
			"autogun_p2_m3_ads",
			"still",
		},
		continuous_spread = {
			min_pitch = {
				lerp_basic = 2.44,
				lerp_perfect = 1.86,
			},
			min_yaw = {
				lerp_basic = 2.44,
				lerp_perfect = 1.86,
			},
		},
	},
}

return {
	base_templates = spread_templates,
	overrides = overrides,
}
