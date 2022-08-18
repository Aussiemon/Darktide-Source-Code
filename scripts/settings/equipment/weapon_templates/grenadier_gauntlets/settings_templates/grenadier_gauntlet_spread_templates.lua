local spread_templates = {}
local overrides = {}

table.make_unique(spread_templates)
table.make_unique(overrides)

spread_templates.default_grenadier_gauntlet_demolitions = {
	still = {
		max_spread = {
			yaw = 6.5,
			pitch = 6.5
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
			min_yaw = 2.25,
			min_pitch = 2.25
		},
		start_spread = {
			start_yaw = 4,
			start_pitch = 4
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
					yaw = 2.5,
					pitch = 2.5
				}
			}
		}
	},
	moving = {
		inherits = {
			"default_grenadier_gauntlet_demolitions",
			"still"
		}
	},
	crouch_still = {
		inherits = {
			"default_grenadier_gauntlet_demolitions",
			"still"
		}
	},
	crouch_moving = {
		inherits = {
			"default_grenadier_gauntlet_demolitions",
			"still"
		}
	}
}
spread_templates.default_grenadier_gauntlet_bfg = {
	still = {
		max_spread = {
			yaw = 20,
			pitch = 20
		},
		decay = {
			from_shooting_grace_time = 0.15,
			shooting = {
				yaw = 0.25,
				pitch = 0.25
			},
			idle = {
				yaw = 1,
				pitch = 1
			}
		},
		continuous_spread = {
			min_yaw = 2,
			min_pitch = 2
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
					yaw = 1.25,
					pitch = 1
				}
			}
		}
	},
	moving = {
		inherits = {
			"default_grenadier_gauntlet_bfg",
			"still"
		}
	},
	crouch_still = {
		inherits = {
			"default_grenadier_gauntlet_bfg",
			"still"
		}
	},
	crouch_moving = {
		inherits = {
			"default_grenadier_gauntlet_bfg",
			"still"
		}
	}
}

return {
	base_templates = spread_templates,
	overrides = overrides
}
