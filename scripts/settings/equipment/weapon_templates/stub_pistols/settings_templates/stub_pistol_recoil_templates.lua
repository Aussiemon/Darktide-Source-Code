local recoil_templates = {}
local overrides = {}

table.make_unique(recoil_templates)
table.make_unique(overrides)

recoil_templates.default_stub_pistol_assault = {
	still = {
		camera_recoil_percentage = 0.65,
		decay_grace = 0.05,
		new_influence_percent = 0.6,
		rise_duration = 0.05,
		rise = {
			0.75,
			1,
			0.4,
			0.5
		},
		decay = {
			shooting = 1,
			idle = 2
		},
		offset_range = {
			{
				pitch = {
					0.125,
					0.125
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
			yaw = 2,
			pitch = 2
		},
		visual_recoil_settings = {
			intensity = 5,
			lerp_scalar = 1
		}
	},
	moving = {
		new_influence_percent = 0.65,
		inherits = {
			"default_stub_pistol_assault",
			"still"
		}
	},
	crouch_still = {
		new_influence_percent = 0.5,
		inherits = {
			"default_stub_pistol_assault",
			"still"
		}
	},
	crouch_moving = {
		new_influence_percent = 0.5,
		inherits = {
			"default_stub_pistol_assault",
			"still"
		}
	}
}
recoil_templates.default_stub_pistol_killshot = {
	still = {
		camera_recoil_percentage = 0.2,
		decay_grace = 0.2,
		new_influence_percent = 1,
		rise_duration = 0.06,
		rise = {
			0.85,
			0.3,
			0.3,
			0.45,
			0.2,
			0.35
		},
		decay = {
			shooting = 1.2,
			idle = 2
		},
		offset_range = {
			{
				pitch = {
					0.0375,
					0.04375
				},
				yaw = {
					-0.02,
					0.02
				}
			}
		},
		offset_limit = {
			yaw = 2,
			pitch = 2
		},
		visual_recoil_settings = {
			intensity = 12,
			lerp_scalar = 1,
			yaw_intensity = 8
		}
	},
	moving = {
		new_influence_percent = 0.75,
		inherits = {
			"default_stub_pistol_killshot",
			"still"
		}
	},
	crouch_still = {
		new_influence_percent = 0.6,
		inherits = {
			"default_stub_pistol_killshot",
			"still"
		}
	},
	crouch_moving = {
		new_influence_percent = 0.8,
		inherits = {
			"default_stub_pistol_killshot",
			"still"
		}
	}
}
recoil_templates.default_stub_pistol_bfg = {
	still = {
		camera_recoil_percentage = 0.65,
		decay_grace = 0.15,
		new_influence_percent = 0.6,
		rise_duration = 0.05,
		rise = {
			1
		},
		decay = {
			shooting = 1,
			idle = 2
		},
		offset_range = {
			{
				pitch = {
					0.15,
					0.175
				},
				yaw = {
					-0,
					0
				}
			}
		},
		offset_limit = {
			yaw = 2,
			pitch = 2
		},
		visual_recoil_settings = {
			intensity = 5,
			lerp_scalar = 1
		}
	},
	moving = {
		new_influence_percent = 0.7,
		inherits = {
			"default_stub_pistol_bfg",
			"still"
		}
	},
	crouch_still = {
		new_influence_percent = 0.5,
		inherits = {
			"default_stub_pistol_bfg",
			"still"
		}
	},
	crouch_moving = {
		new_influence_percent = 0.7,
		inherits = {
			"default_stub_pistol_bfg",
			"still"
		}
	}
}

return {
	base_templates = recoil_templates,
	overrides = overrides
}
