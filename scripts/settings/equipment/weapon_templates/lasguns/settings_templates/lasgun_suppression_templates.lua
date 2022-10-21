local suppression_templates = {}
local overrides = {}

table.make_unique(suppression_templates)
table.make_unique(overrides)

suppression_templates.default_lasgun_killshot = {
	still = {
		delay = 0.2,
		decay_time = 0.6,
		immediate_sway = {
			{
				pitch = {
					lerp_perfect = 0.1,
					lerp_basic = 0.25
				},
				yaw = {
					lerp_perfect = 0.1,
					lerp_basic = 0.25
				}
			},
			{
				pitch = {
					lerp_perfect = 0.25,
					lerp_basic = 0.5
				},
				yaw = {
					lerp_perfect = 0.25,
					lerp_basic = 0.5
				}
			},
			{
				pitch = {
					lerp_perfect = 1.5,
					lerp_basic = 2
				},
				yaw = {
					lerp_perfect = 1.5,
					lerp_basic = 2
				}
			},
			{
				pitch = {
					lerp_perfect = 2.5,
					lerp_basic = 3
				},
				yaw = {
					lerp_perfect = 2.5,
					lerp_basic = 3
				}
			},
			{
				pitch = {
					lerp_perfect = 3.5,
					lerp_basic = 4
				},
				yaw = {
					lerp_perfect = 3.5,
					lerp_basic = 4
				}
			}
		}
	},
	moving = {
		inherits = {
			"default_lasgun_killshot",
			"still"
		}
	},
	crouch_still = {
		inherits = {
			"default_lasgun_killshot",
			"still"
		}
	},
	crouch_moving = {
		inherits = {
			"default_lasgun_killshot",
			"still"
		}
	}
}
suppression_templates.hip_lasgun_killshot = {
	still = {
		delay = 0.2,
		decay_time = 0.6,
		immediate_spread = {
			{
				pitch = {
					lerp_perfect = 0.5,
					lerp_basic = 1
				},
				yaw = {
					lerp_perfect = 0.5,
					lerp_basic = 1
				}
			},
			{
				pitch = {
					lerp_perfect = 1,
					lerp_basic = 2
				},
				yaw = {
					lerp_perfect = 1,
					lerp_basic = 2
				}
			},
			{
				pitch = {
					lerp_perfect = 2,
					lerp_basic = 3
				},
				yaw = {
					lerp_perfect = 2,
					lerp_basic = 3
				}
			}
		}
	},
	moving = {
		inherits = {
			"hip_lasgun_killshot",
			"still"
		}
	},
	crouch_still = {
		inherits = {
			"hip_lasgun_killshot",
			"still"
		}
	},
	crouch_moving = {
		inherits = {
			"hip_lasgun_killshot",
			"still"
		}
	}
}

return {
	base_templates = suppression_templates,
	overrides = overrides
}
