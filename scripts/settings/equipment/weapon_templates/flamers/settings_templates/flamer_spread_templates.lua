local spread_templates = {}
local overrides = {}

table.make_unique(spread_templates)
table.make_unique(overrides)

spread_templates.default_flamer_assault = {
	charge_scale = {
		max_yaw = 0.25,
		max_pitch = 0.25
	},
	still = {
		max_spread = {
			yaw = 1,
			pitch = 1
		},
		decay = {
			from_shooting_grace_time = 1.1,
			shooting = {
				yaw = 1,
				pitch = 1
			},
			idle = {
				yaw = 4,
				pitch = 4
			}
		},
		continuous_spread = {
			min_yaw = 2.5,
			min_pitch = 2.5
		},
		immediate_spread = {
			num_shots_clear_time = 0.7,
			suppression_hit = {
				{
					yaw = 0.5,
					pitch = 0.5
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
					yaw = 0.15,
					pitch = 0.25
				},
				{
					yaw = 0.15,
					pitch = 0.1
				},
				{
					yaw = 0.05,
					pitch = 0.15
				},
				{
					yaw = 0.15,
					pitch = 0.25
				},
				{
					yaw = 0.15,
					pitch = 0.15
				},
				{
					yaw = 0.25,
					pitch = 0
				},
				{
					yaw = 0.1,
					pitch = 0.2
				}
			}
		}
	},
	moving = {
		inherits = {
			"default_flamer_assault",
			"still"
		}
	},
	crouch_still = {
		inherits = {
			"default_flamer_assault",
			"still"
		}
	},
	crouch_moving = {
		inherits = {
			"default_flamer_assault",
			"still"
		}
	}
}
spread_templates.default_flamer_demolitions = {
	charge_scale = {
		max_yaw = 0.25,
		max_pitch = 0.25
	},
	still = {
		max_spread = {
			yaw = 20,
			pitch = 20
		},
		decay = {
			from_shooting_grace_time = 0.2,
			shooting = {
				yaw = 0.5,
				pitch = 0.5
			},
			idle = {
				yaw = 1,
				pitch = 1
			}
		},
		continuous_spread = {
			min_yaw = 2.5,
			min_pitch = 2.5
		},
		immediate_spread = {
			num_shots_clear_time = 0.35,
			suppression_hit = {
				{
					yaw = 0.5,
					pitch = 0.5
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
					yaw = 2.5,
					pitch = 2.5
				}
			}
		}
	},
	moving = {
		inherits = {
			"default_flamer_demolitions",
			"still"
		}
	},
	crouch_still = {
		inherits = {
			"default_flamer_demolitions",
			"still"
		}
	},
	crouch_moving = {
		inherits = {
			"default_flamer_demolitions",
			"still"
		}
	}
}

return {
	base_templates = spread_templates,
	overrides = overrides
}
