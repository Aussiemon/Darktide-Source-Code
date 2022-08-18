local spread_templates = {}
local overrides = {}

table.make_unique(spread_templates)
table.make_unique(overrides)

spread_templates.default_rippergun_assault = {
	still = {
		randomized_spread = {
			first_shot_min_ratio = 0.1,
			max_yaw_delta = 1,
			first_shot_random_ratio = 0.2,
			random_ratio = 0.2,
			max_pitch_delta = 1,
			min_ratio = 0.1
		},
		max_spread = {
			yaw = 8.5,
			pitch = 8.5
		},
		decay = {
			from_shooting_grace_time = 0.25,
			shooting = {
				yaw = 0.25,
				pitch = 0.25
			},
			idle = {
				yaw = 1.5,
				pitch = 1.5
			}
		},
		continuous_spread = {
			min_yaw = 5.25,
			min_pitch = 4
		},
		immediate_spread = {
			num_shots_clear_time = 0.75,
			suppression_hit = {
				{
					yaw = 0.5,
					pitch = 0.5
				}
			},
			damage_hit = {
				{
					yaw = 1.5,
					pitch = 1.5
				}
			},
			shooting = {
				{
					yaw = 2.25,
					pitch = 2.25
				}
			}
		},
		visual_spread_settings = {
			intensity = 0.4,
			speed_variance_max = 1.25,
			rotation_speed = 0.5,
			horizontal_speed = 1,
			speed_change_frequency = 1,
			speed_variance_min = 0.75
		}
	},
	moving = {
		inherits = {
			"default_rippergun_assault",
			"still"
		}
	},
	crouch_still = {
		inherits = {
			"default_rippergun_assault",
			"still"
		}
	},
	crouch_moving = {
		inherits = {
			"default_rippergun_assault",
			"still"
		}
	}
}
spread_templates.default_rippergun_braced = {
	still = {
		randomized_spread = {
			first_shot_min_ratio = 0.1,
			max_yaw_delta = 0.5,
			first_shot_random_ratio = 0.2,
			random_ratio = 0.8,
			max_pitch_delta = 0.5,
			min_ratio = 0.2
		},
		max_spread = {
			yaw = 10.5,
			pitch = 8.5
		},
		decay = {
			from_shooting_grace_time = 0.25,
			shooting = {
				yaw = 0.25,
				pitch = 0.25
			},
			idle = {
				yaw = 1.5,
				pitch = 1.5
			}
		},
		continuous_spread = {
			min_yaw = 5,
			min_pitch = 2
		},
		immediate_spread = {
			num_shots_clear_time = 0.4,
			suppression_hit = {
				{
					yaw = 0.5,
					pitch = 0.5
				}
			},
			damage_hit = {
				{
					yaw = 1.5,
					pitch = 1.5
				}
			},
			shooting = {
				{
					yaw = 0.8,
					pitch = 0.2
				},
				{
					yaw = 0.6000000000000001,
					pitch = 0.15000000000000002
				},
				{
					yaw = 0.4,
					pitch = 0.1
				},
				{
					yaw = 0.2,
					pitch = 0.05
				},
				{
					yaw = 0.08000000000000002,
					pitch = 0.020000000000000004
				}
			}
		},
		visual_spread_settings = {
			intensity = 0.4,
			speed_variance_max = 1.25,
			rotation_speed = 0.5,
			horizontal_speed = 1,
			speed_change_frequency = 1,
			speed_variance_min = 0.75
		}
	},
	moving = {
		inherits = {
			"default_rippergun_braced",
			"still"
		}
	},
	crouch_still = {
		inherits = {
			"default_rippergun_braced",
			"still"
		}
	},
	crouch_moving = {
		inherits = {
			"default_rippergun_braced",
			"still"
		}
	}
}

return {
	base_templates = spread_templates,
	overrides = overrides
}
