local spread_templates = {}
local overrides = {}

table.make_unique(spread_templates)
table.make_unique(overrides)

spread_templates.default_plasma_rifle_bfg = {
	charge_scale = {
		max_yaw = 0.1,
		max_pitch = 0.1
	},
	still = {
		max_spread = {
			yaw = 20,
			pitch = 20
		},
		decay = {
			from_shooting_grace_time = 0.5,
			shooting = {
				yaw = 0.2,
				pitch = 0.2
			},
			idle = {
				yaw = 0.75,
				pitch = 0.75
			},
			charging = {
				yaw = 2.75,
				pitch = 2.75
			}
		},
		continuous_spread = {
			min_yaw = 1.5,
			min_pitch = 1.5
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
					yaw = 8,
					pitch = 8
				}
			},
			shooting = {
				{
					yaw = 2.5,
					pitch = 2.5
				},
				{
					yaw = 3,
					pitch = 3
				},
				{
					yaw = 4,
					pitch = 4
				}
			}
		}
	},
	moving = {
		inherits = {
			"default_plasma_rifle_bfg",
			"still"
		}
	},
	crouch_still = {
		inherits = {
			"default_plasma_rifle_bfg",
			"still"
		}
	},
	crouch_moving = {
		inherits = {
			"default_plasma_rifle_bfg",
			"still"
		}
	}
}
spread_templates.default_plasma_rifle_demolitions = {
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
			"default_plasma_rifle_demolitions",
			"still"
		}
	},
	crouch_still = {
		inherits = {
			"default_plasma_rifle_demolitions",
			"still"
		}
	},
	crouch_moving = {
		inherits = {
			"default_plasma_rifle_demolitions",
			"still"
		}
	}
}

return {
	base_templates = spread_templates,
	overrides = overrides
}
