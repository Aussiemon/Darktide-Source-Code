local spread_templates = {}
local overrides = {}

table.make_unique(spread_templates)
table.make_unique(overrides)

spread_templates.default_laspistol_killshot = {
	still = {
		max_spread = {
			yaw = 6,
			pitch = 6
		},
		decay = {
			from_shooting_grace_time = 0.15,
			shooting = {
				yaw = 0.5,
				pitch = 0.5
			},
			idle = {
				yaw = 2,
				pitch = 2
			}
		},
		continuous_spread = {
			min_yaw = 0,
			min_pitch = 0
		},
		immediate_spread = {
			num_shots_clear_time = 0.4,
			suppression_hit = {
				{
					yaw = 0.2,
					pitch = 0.2
				}
			},
			damage_hit = {
				{
					yaw = 1.2,
					pitch = 1.2
				}
			},
			shooting = {
				{
					yaw = 0,
					pitch = 0
				},
				{
					yaw = 0,
					pitch = 0
				},
				{
					yaw = 0.05,
					pitch = 0.05
				}
			}
		},
		visual_spread_settings = {
			intensity = 0.5,
			speed_variance_max = 1.25,
			rotation_speed = 0.5,
			horizontal_speed = 4,
			speed_change_frequency = 1,
			speed_variance_min = 0.75
		}
	},
	moving = {
		inherits = {
			"default_laspistol_killshot",
			"still"
		},
		continuous_spread = {
			min_yaw = 0,
			min_pitch = 0
		}
	},
	crouch_still = {
		inherits = {
			"default_laspistol_killshot",
			"still"
		},
		continuous_spread = {
			min_yaw = 0,
			min_pitch = 0
		}
	},
	crouch_moving = {
		inherits = {
			"default_laspistol_killshot",
			"still"
		},
		continuous_spread = {
			min_yaw = 0,
			min_pitch = 0
		}
	}
}
spread_templates.default_laspistol_assault = {
	still = {
		randomized_spread = {
			first_shot_min_ratio = 0.15,
			max_yaw_delta = 0.4,
			first_shot_random_ratio = 0.2,
			random_ratio = 0.5,
			max_pitch_delta = 0.4,
			min_ratio = 0.4
		},
		max_spread = {
			yaw = 4,
			pitch = 4
		},
		decay = {
			from_shooting_grace_time = 0.075,
			shooting = {
				yaw = 0.25,
				pitch = 0.25
			},
			idle = {
				yaw = 1.25,
				pitch = 1.5
			}
		},
		continuous_spread = {
			min_yaw = 1.3,
			min_pitch = 1.3
		},
		immediate_spread = {
			num_shots_clear_time = 0.5,
			suppression_hit = {
				{
					yaw = 0.25,
					pitch = 0.25
				}
			},
			damage_hit = {
				{
					yaw = 0.4,
					pitch = 0.4
				}
			},
			shooting = {
				{
					yaw = 0.5,
					pitch = 0.5
				}
			}
		}
	},
	moving = {
		inherits = {
			"default_laspistol_assault",
			"still"
		},
		continuous_spread = {
			min_yaw = 1,
			min_pitch = 1
		}
	},
	crouch_still = {
		inherits = {
			"default_laspistol_assault",
			"still"
		},
		continuous_spread = {
			min_yaw = 1.15,
			min_pitch = 1.15
		}
	},
	crouch_moving = {
		inherits = {
			"default_laspistol_assault",
			"still"
		},
		continuous_spread = {
			min_yaw = 1.5,
			min_pitch = 1.5
		}
	}
}

return {
	base_templates = spread_templates,
	overrides = overrides
}
