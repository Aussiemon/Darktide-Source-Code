local spread_templates = {}
local overrides = {}

table.make_unique(spread_templates)
table.make_unique(overrides)

spread_templates.default_force_staff_killshot = {
	charge_scale = {
		max_yaw = 0.25,
		max_pitch = 0.25
	},
	still = {
		max_spread = {
			yaw = 2,
			pitch = 1
		},
		decay = {
			from_shooting_grace_time = 0.1,
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
			min_yaw = 0.01,
			min_pitch = 0.01
		},
		immediate_spread = {
			num_shots_clear_time = 0.15,
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
					yaw = 0,
					pitch = 0
				}
			}
		}
	},
	moving = {
		inherits = {
			"default_force_staff_killshot",
			"still"
		}
	},
	crouch_still = {
		inherits = {
			"default_force_staff_killshot",
			"still"
		}
	},
	crouch_moving = {
		inherits = {
			"default_force_staff_killshot",
			"still"
		}
	}
}

return {
	base_templates = spread_templates,
	overrides = overrides
}
