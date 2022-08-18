local recoil_templates = {}
local overrides = {}

table.make_unique(recoil_templates)
table.make_unique(overrides)

recoil_templates.default_stub_rifle_assault = {
	still = {
		new_influence_percent = 0.6,
		rise_duration = 0.1,
		decay_grace = 0.05,
		rise = {
			0.35,
			0.3,
			0.4,
			0.5
		},
		decay = {
			shooting = 0.5,
			idle = 2
		},
		offset_range = {
			{
				pitch = {
					0.075,
					0.075
				},
				yaw = {
					-0,
					0
				}
			},
			{
				pitch = {
					0.075,
					0.075
				},
				yaw = {
					-0.01,
					0.01
				}
			},
			{
				pitch = {
					0.065,
					0.085
				},
				yaw = {
					-0.02,
					0.02
				}
			},
			{
				pitch = {
					0.05,
					0.075
				},
				yaw = {
					-0.03,
					0.03
				}
			}
		},
		offset_limit = {
			yaw = 1,
			pitch = 1
		}
	},
	moving = {
		new_influence_percent = 0.65,
		inherits = {
			"default_stub_rifle_assault",
			"still"
		}
	},
	crouch_still = {
		new_influence_percent = 0.5,
		inherits = {
			"default_stub_rifle_assault",
			"still"
		}
	},
	crouch_moving = {
		new_influence_percent = 0.5,
		inherits = {
			"default_stub_rifle_assault",
			"still"
		}
	}
}
recoil_templates.default_stub_rifle_killshot = {
	still = {
		new_influence_percent = 0.75,
		rise_duration = 0.05,
		decay_grace = 0.05,
		rise = {
			0.6,
			0.55,
			0.5,
			0.45,
			0.4,
			0.35
		},
		decay = {
			shooting = 0.5,
			idle = 2.5
		},
		offset_range = {
			{
				pitch = {
					0.075,
					0.075
				},
				yaw = {
					-0,
					0
				}
			},
			{
				pitch = {
					0.08,
					0.08
				},
				yaw = {
					-0.01,
					0.01
				}
			},
			{
				pitch = {
					0.075,
					0.085
				},
				yaw = {
					-0.02,
					0.02
				}
			},
			{
				pitch = {
					0.06,
					0.09
				},
				yaw = {
					-0.03,
					0.03
				}
			}
		},
		offset_limit = {
			yaw = 2,
			pitch = 2
		}
	},
	moving = {
		new_influence_percent = 0.75,
		inherits = {
			"default_stub_rifle_killshot",
			"still"
		}
	},
	crouch_still = {
		new_influence_percent = 0.6,
		inherits = {
			"default_stub_rifle_killshot",
			"still"
		}
	},
	crouch_moving = {
		new_influence_percent = 0.8,
		inherits = {
			"default_stub_rifle_killshot",
			"still"
		}
	}
}

return {
	base_templates = recoil_templates,
	overrides = overrides
}
