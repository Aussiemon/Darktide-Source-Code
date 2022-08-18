local spread_templates = {}
local overrides = {}

table.make_unique(spread_templates)
table.make_unique(overrides)

spread_templates.default_stub_rifle_assault = {
	still = {
		max_spread = {
			yaw = 20,
			pitch = 20
		},
		decay = {
			from_shooting_grace_time = 0.1,
			shooting = {
				yaw = 1,
				pitch = 1
			},
			idle = {
				yaw = 2.5,
				pitch = 2.5
			}
		},
		continuous_spread = {
			min_yaw = 0.4,
			min_pitch = 0.4
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
					yaw = 5,
					pitch = 5
				}
			},
			shooting = {
				{
					yaw = 0.75,
					pitch = 0.75
				},
				{
					yaw = 0.4,
					pitch = 0.4
				},
				{
					yaw = 0.75,
					pitch = 0.75
				},
				{
					yaw = 1.25,
					pitch = 1
				},
				{
					yaw = 1.75,
					pitch = 1.5
				}
			}
		}
	},
	moving = {
		inherits = {
			"default_stub_rifle_assault",
			"still"
		},
		continuous_spread = {
			min_yaw = 0.6,
			min_pitch = 0.6
		}
	},
	crouch_still = {
		inherits = {
			"default_stub_rifle_assault",
			"still"
		}
	},
	crouch_moving = {
		inherits = {
			"default_stub_rifle_assault",
			"still"
		}
	}
}
spread_templates.default_stub_rifle_killshot = {
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
			min_yaw = 0.25,
			min_pitch = 0.25
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
					yaw = 0.35,
					pitch = 0.35
				},
				{
					yaw = 0.5,
					pitch = 0.5
				},
				{
					yaw = 1,
					pitch = 1
				},
				{
					yaw = 1,
					pitch = 1
				},
				{
					yaw = 1.5,
					pitch = 1.5
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
			"default_stub_rifle_killshot",
			"still"
		},
		continuous_spread = {
			min_yaw = 0.6,
			min_pitch = 0.6
		}
	},
	crouch_still = {
		inherits = {
			"default_stub_rifle_killshot",
			"still"
		},
		continuous_spread = {
			min_yaw = 0.2,
			min_pitch = 0.2
		}
	},
	crouch_moving = {
		inherits = {
			"default_stub_rifle_killshot",
			"still"
		},
		continuous_spread = {
			min_yaw = 0.5,
			min_pitch = 0.5
		}
	}
}

return {
	base_templates = spread_templates,
	overrides = overrides
}
