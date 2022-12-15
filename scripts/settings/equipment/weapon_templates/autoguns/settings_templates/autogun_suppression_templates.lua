local suppression_templates = {}
local overrides = {}

table.make_unique(suppression_templates)
table.make_unique(overrides)

suppression_templates.default_autogun_assault = {
	still = {
		delay = 1,
		decay_time = 0.25,
		immediate_spread = {
			{
				pitch = {
					lerp_perfect = 3,
					lerp_basic = 6
				},
				yaw = {
					lerp_perfect = 3,
					lerp_basic = 6
				}
			},
			{
				pitch = {
					lerp_perfect = 2.5,
					lerp_basic = 5.5
				},
				yaw = {
					lerp_perfect = 2.5,
					lerp_basic = 5.5
				}
			},
			{
				pitch = {
					lerp_perfect = 2,
					lerp_basic = 5
				},
				yaw = {
					lerp_perfect = 2,
					lerp_basic = 5
				}
			},
			{
				pitch = {
					lerp_perfect = 1.5,
					lerp_basic = 4.5
				},
				yaw = {
					lerp_perfect = 1.5,
					lerp_basic = 4.5
				}
			},
			{
				pitch = {
					lerp_perfect = 1,
					lerp_basic = 4
				},
				yaw = {
					lerp_perfect = 1,
					lerp_basic = 4
				}
			}
		}
	},
	moving = {
		inherits = {
			"default_autogun_assault",
			"still"
		}
	},
	crouch_still = {
		inherits = {
			"default_autogun_assault",
			"still"
		}
	},
	crouch_moving = {
		inherits = {
			"default_autogun_assault",
			"still"
		}
	}
}
suppression_templates.fullauto_autogun_killshot = {
	still = {
		delay = 0.2,
		decay_time = 0.6,
		immediate_sway = {
			{
				pitch = {
					lerp_perfect = 4,
					lerp_basic = 8
				},
				yaw = {
					lerp_perfect = 4,
					lerp_basic = 8
				}
			}
		}
	},
	moving = {
		inherits = {
			"fullauto_autogun_killshot",
			"still"
		}
	},
	crouch_still = {
		inherits = {
			"fullauto_autogun_killshot",
			"still"
		}
	},
	crouch_moving = {
		inherits = {
			"fullauto_autogun_killshot",
			"still"
		}
	}
}

return {
	base_templates = suppression_templates,
	overrides = overrides
}
