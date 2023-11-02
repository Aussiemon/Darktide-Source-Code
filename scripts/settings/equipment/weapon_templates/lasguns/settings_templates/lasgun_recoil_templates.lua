local RecoilTemplate = require("scripts/utilities/recoil_template")
local AIM_ASSIST_MULTIPLIER_FUNCTIONS = RecoilTemplate.AIM_ASSIST_MULTIPLIER_FUNCTIONS
local generate_offset_range = RecoilTemplate.generate_offset_range
local create_scale = RecoilTemplate.create_scale
local recoil_templates = {}
local overrides = {}

table.make_unique(recoil_templates)
table.make_unique(overrides)

local assault_p3_m1_scale = {
	{
		1,
		{
			0.25,
			0
		}
	},
	{
		5,
		{
			0.75,
			0
		}
	},
	{
		10,
		{
			1,
			0
		}
	},
	{
		20,
		{
			0.5,
			0
		}
	},
	{
		30,
		{
			0.25,
			0
		}
	},
	{
		90,
		{
			0.25,
			0
		}
	}
}
local assault_p3_m1_random_scale = {
	{
		1,
		{
			0.25,
			0.25
		}
	},
	{
		5,
		{
			0.75,
			0.75
		}
	},
	{
		10,
		{
			1,
			1
		}
	},
	{
		20,
		{
			0.75,
			0.5
		}
	},
	{
		30,
		{
			0.85,
			0.25
		}
	},
	{
		90,
		{
			0.25,
			0.25
		}
	}
}
local killshot_p3_m1_scale = {
	{
		1,
		{
			0.1,
			0
		}
	},
	{
		5,
		{
			0.25,
			0
		}
	},
	{
		10,
		{
			0.75,
			0
		}
	},
	{
		20,
		{
			1,
			0
		}
	},
	{
		30,
		{
			0.5,
			0
		}
	},
	{
		90,
		{
			0.25,
			0
		}
	}
}
local killshot_p3_m1_random_scale = {
	{
		1,
		{
			0.1,
			0.25
		}
	},
	{
		5,
		{
			0.25,
			0.75
		}
	},
	{
		10,
		{
			0.75,
			1
		}
	},
	{
		20,
		{
			1,
			0.5
		}
	},
	{
		30,
		{
			0.5,
			0.25
		}
	},
	{
		90,
		{
			0.25,
			0.25
		}
	}
}
local assault_p3_m1_offset_range = generate_offset_range(90, 0.0025, 0, 0.75, create_scale(assault_p3_m1_scale))
local assault_p3_m1_random_range = generate_offset_range(90, 0.02, 0.015, 0.75, create_scale(assault_p3_m1_random_scale))
local killshot_p3_m1_offset_range = generate_offset_range(90, 0.0025, 0, 0.75, create_scale(killshot_p3_m1_scale))
local killshot_p3_m1_random_range = generate_offset_range(90, 0.01, 0.0175, 0.75, create_scale(killshot_p3_m1_random_scale))
local pitch_default = 0.08
recoil_templates.hip_lasgun_assault = {
	still = {
		camera_recoil_percentage = 0.25,
		new_influence_percent = 0.5,
		rise_duration = 0.1,
		rise = {
			0.4,
			0.2
		},
		decay = {
			shooting = 0,
			idle = 2
		},
		offset_range = {
			{
				pitch = {
					pitch_default * 0.6,
					pitch_default * 0.6
				},
				yaw = {
					0,
					0
				}
			},
			{
				pitch = {
					pitch_default * 0.7,
					pitch_default * 0.7
				},
				yaw = {
					0,
					0
				}
			},
			{
				pitch = {
					pitch_default,
					pitch_default
				},
				yaw = {
					0,
					0
				}
			},
			{
				pitch = {
					pitch_default * 0.9,
					pitch_default * 1.1
				},
				yaw = {
					-0.01,
					0.01
				}
			},
			{
				pitch = {
					pitch_default * 0.8,
					pitch_default * 1.2
				},
				yaw = {
					-0.02,
					0.02
				}
			},
			{
				pitch = {
					pitch_default * 0.7,
					pitch_default * 1.2
				},
				yaw = {
					-0.03,
					0.03
				}
			},
			{
				pitch = {
					pitch_default * 0.6,
					pitch_default * 1.3
				},
				yaw = {
					-0.04,
					0.04
				}
			},
			{
				pitch = {
					pitch_default * 0.5,
					pitch_default * 1.5
				},
				yaw = {
					-0.05,
					0.05
				}
			}
		},
		hit_offset_multiplier = {
			fortitude_hit = 1.2,
			afro_hit = 1.05,
			grace_hit = 1.1,
			damage_hit = 1.8
		},
		offset_limit = {
			yaw = 0.4,
			pitch = 0.4,
			profile = "linear"
		},
		visual_recoil_settings = {
			intensity = 4,
			lerp_scalar = 1
		}
	},
	moving = {
		new_influence_percent = 0.65,
		inherits = {
			"hip_lasgun_assault",
			"still"
		}
	},
	crouch_still = {
		new_influence_percent = 0.4,
		inherits = {
			"hip_lasgun_assault",
			"still"
		}
	},
	crouch_moving = {
		new_influence_percent = 0.45,
		inherits = {
			"hip_lasgun_assault",
			"still"
		}
	}
}
recoil_templates.hip_lasgun_killshot = {
	still = {
		camera_recoil_percentage = 0.25,
		decay_grace = 0.125,
		rise_duration = 0.075,
		rise = {
			{
				lerp_perfect = 0.5,
				lerp_basic = 0.75
			},
			{
				lerp_perfect = 0.2,
				lerp_basic = 0.5
			},
			{
				lerp_perfect = 0.15,
				lerp_basic = 0.5
			}
		},
		decay = {
			shooting = 0.75,
			idle = 2.25
		},
		offset = {
			{
				pitch = {
					lerp_perfect = 0.025,
					lerp_basic = 0.0625
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0
				}
			},
			{
				pitch = {
					lerp_perfect = 0.0375,
					lerp_basic = 0.05
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0
				}
			},
			{
				pitch = {
					lerp_perfect = 0.005,
					lerp_basic = 0.0375
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0
				}
			},
			{
				pitch = {
					lerp_perfect = 0.005,
					lerp_basic = 0.0325
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0
				}
			},
			{
				pitch = {
					lerp_perfect = 0.005,
					lerp_basic = 0.025
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0
				}
			}
		},
		offset_random_range = {
			{
				pitch = {
					lerp_perfect = 0,
					lerp_basic = 0.0005
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0.001
				}
			},
			{
				pitch = {
					lerp_perfect = 0,
					lerp_basic = 0.001
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0.001
				}
			},
			{
				pitch = {
					lerp_perfect = 0,
					lerp_basic = 0.00125
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0.001
				}
			},
			{
				pitch = {
					lerp_perfect = 0,
					lerp_basic = 0.0015
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0.0025
				}
			},
			{
				pitch = {
					lerp_perfect = 0,
					lerp_basic = 0.0015
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0.005
				}
			},
			{
				pitch = {
					lerp_perfect = 0,
					lerp_basic = 0.0015
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0.015
				}
			},
			{
				pitch = {
					lerp_perfect = 0,
					lerp_basic = 0.0015
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0.025
				}
			}
		},
		offset_limit = {
			yaw = 0.25,
			pitch = 0.25
		},
		visual_recoil_settings = {
			intensity = 25,
			lerp_scalar = 0.2
		},
		new_influence_percent = {
			lerp_perfect = 0.025,
			lerp_basic = 0.1
		}
	},
	moving = {
		inherits = {
			"hip_lasgun_killshot",
			"still"
		},
		new_influence_percent = {
			lerp_perfect = 0.06,
			lerp_basic = 0.12
		}
	},
	crouch_still = {
		inherits = {
			"hip_lasgun_killshot",
			"still"
		},
		new_influence_percent = {
			lerp_perfect = 0.01,
			lerp_basic = 0.05
		}
	},
	crouch_moving = {
		inherits = {
			"hip_lasgun_killshot",
			"still"
		},
		new_influence_percent = {
			lerp_perfect = 0.06,
			lerp_basic = 0.12
		}
	}
}
recoil_templates.hip_lasgun_p2_killshot = {
	still = {
		camera_recoil_percentage = 0.25,
		decay_grace = 0.125,
		rise_duration = 0.075,
		rise = {
			{
				lerp_perfect = 0.5,
				lerp_basic = 0.75
			},
			{
				lerp_perfect = 0.2,
				lerp_basic = 0.5
			},
			{
				lerp_perfect = 0.15,
				lerp_basic = 0.5
			}
		},
		decay = {
			shooting = 0.75,
			idle = 2.25
		},
		offset = {
			{
				pitch = {
					lerp_perfect = 0.037500000000000006,
					lerp_basic = 0.09375
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0
				}
			},
			{
				pitch = {
					lerp_perfect = 0.056249999999999994,
					lerp_basic = 0.07500000000000001
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0
				}
			},
			{
				pitch = {
					lerp_perfect = 0.07500000000000001,
					lerp_basic = 0.056249999999999994
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0
				}
			},
			{
				pitch = {
					lerp_perfect = 0.07500000000000001,
					lerp_basic = 0.04875
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0
				}
			},
			{
				pitch = {
					lerp_perfect = 0.07500000000000001,
					lerp_basic = 0.037500000000000006
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0
				}
			}
		},
		offset_random_range = {
			{
				pitch = {
					lerp_perfect = 0,
					lerp_basic = 0.005
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0.01
				}
			},
			{
				pitch = {
					lerp_perfect = 0,
					lerp_basic = 0.006
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0.02
				}
			},
			{
				pitch = {
					lerp_perfect = 0,
					lerp_basic = 0.00625
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0.03
				}
			},
			{
				pitch = {
					lerp_perfect = 0,
					lerp_basic = 0.0065
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0.045
				}
			},
			{
				pitch = {
					lerp_perfect = 0,
					lerp_basic = 0.0065
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0.055
				}
			},
			{
				pitch = {
					lerp_perfect = 0,
					lerp_basic = 0.0065
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0.065
				}
			},
			{
				pitch = {
					lerp_perfect = 0,
					lerp_basic = 0.0065
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0.075
				}
			}
		},
		offset_limit = {
			yaw = 0.25,
			pitch = 0.25
		},
		visual_recoil_settings = {
			intensity = 25,
			lerp_scalar = 0.2
		},
		new_influence_percent = {
			lerp_perfect = 0.05,
			lerp_basic = 0.2
		}
	},
	moving = {
		inherits = {
			"hip_lasgun_p2_killshot",
			"still"
		},
		new_influence_percent = {
			lerp_perfect = 0.06,
			lerp_basic = 0.12
		}
	},
	crouch_still = {
		inherits = {
			"hip_lasgun_p2_killshot",
			"still"
		},
		new_influence_percent = {
			lerp_perfect = 0.05,
			lerp_basic = 0.1
		}
	},
	crouch_moving = {
		inherits = {
			"hip_lasgun_p2_killshot",
			"still"
		},
		new_influence_percent = {
			lerp_perfect = 0.075,
			lerp_basic = 0.125
		}
	}
}
local yaw_spread = 0.03
local pitch_spread = 0.025
local pitch_offset = 0.04
recoil_templates.default_lasgun_killshot = {
	still = {
		camera_recoil_percentage = 0.2,
		decay_grace = 0.15,
		rise_duration = 0.095,
		rise = {
			{
				lerp_perfect = 0.1,
				lerp_basic = 0.5
			},
			{
				lerp_perfect = 0.2,
				lerp_basic = 0.4
			},
			{
				lerp_perfect = 0.15,
				lerp_basic = 0.35
			},
			{
				lerp_perfect = 0.125,
				lerp_basic = 0.5
			},
			{
				lerp_perfect = 0.125,
				lerp_basic = 0.5
			},
			{
				lerp_perfect = 0.125,
				lerp_basic = 0.5
			},
			{
				lerp_perfect = 0.125,
				lerp_basic = 0.5
			},
			{
				lerp_perfect = 0.125,
				lerp_basic = 0.5
			}
		},
		decay = {
			shooting = {
				lerp_perfect = 1,
				lerp_basic = 0.25
			},
			idle = {
				lerp_perfect = 2,
				lerp_basic = 0.5
			}
		},
		offset = {
			{
				pitch = {
					lerp_perfect = 0.06,
					lerp_basic = 0.15
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0
				}
			},
			{
				pitch = {
					lerp_perfect = 0.055,
					lerp_basic = 0.125
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0
				}
			},
			{
				pitch = {
					lerp_perfect = 0.05,
					lerp_basic = 0.1
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0.01
				}
			},
			{
				pitch = {
					lerp_perfect = 0.02,
					lerp_basic = 0.05
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0.011
				}
			},
			{
				pitch = {
					lerp_perfect = 0.02,
					lerp_basic = 0.04
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = -0.009
				}
			},
			{
				pitch = {
					lerp_perfect = 0.018,
					lerp_basic = 0.038
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = -0.005
				}
			},
			{
				pitch = {
					lerp_perfect = 0.016,
					lerp_basic = 0.036
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = -0.007
				}
			},
			{
				pitch = {
					lerp_perfect = 0.014,
					lerp_basic = 0.034
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0.005
				}
			},
			{
				pitch = {
					lerp_perfect = 0.012,
					lerp_basic = 0.032
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0
				}
			},
			{
				pitch = {
					lerp_perfect = 0.01,
					lerp_basic = 0.03
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0
				}
			}
		},
		offset_random_range = {
			{
				pitch = {
					lerp_perfect = 0,
					lerp_basic = 0.02
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0.05
				}
			},
			{
				pitch = {
					lerp_perfect = 0,
					lerp_basic = 0
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0.075
				}
			},
			{
				pitch = {
					lerp_perfect = 0,
					lerp_basic = 0.01
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0.005
				}
			},
			{
				pitch = {
					lerp_perfect = 0,
					lerp_basic = 0.011
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0.0075
				}
			},
			{
				pitch = {
					lerp_perfect = 0.005,
					lerp_basic = 0.012
				},
				yaw = {
					lerp_perfect = 0.001,
					lerp_basic = 0.01
				}
			},
			{
				pitch = {
					lerp_perfect = 0.0065,
					lerp_basic = 0.013
				},
				yaw = {
					lerp_perfect = 0.0025,
					lerp_basic = 0.0125
				}
			},
			{
				pitch = {
					lerp_perfect = 0.0075,
					lerp_basic = 0.015
				},
				yaw = {
					lerp_perfect = 0.005,
					lerp_basic = 0.015
				}
			},
			{
				pitch = {
					lerp_perfect = 0.01,
					lerp_basic = 0.0175
				},
				yaw = {
					lerp_perfect = 0.008,
					lerp_basic = 0.0175
				}
			},
			{
				pitch = {
					lerp_perfect = 0.0125,
					lerp_basic = 0.02
				},
				yaw = {
					lerp_perfect = 0.009,
					lerp_basic = 0.02
				}
			},
			{
				pitch = {
					lerp_perfect = 0.015,
					lerp_basic = 0.025
				},
				yaw = {
					lerp_perfect = 0.01,
					lerp_basic = 0.0225
				}
			},
			{
				pitch = {
					lerp_perfect = 0.015,
					lerp_basic = 0.025
				},
				yaw = {
					lerp_perfect = 0.01,
					lerp_basic = 0.025
				}
			}
		},
		offset_limit = {
			yaw = 0.5,
			pitch = 1
		},
		new_influence_percent = {
			lerp_perfect = 0.2,
			lerp_basic = 0.2
		},
		visual_recoil_settings = {
			intensity = 3,
			lerp_scalar = 1,
			yaw_intensity = 3
		}
	},
	moving = {
		inherits = {
			"default_lasgun_killshot",
			"still"
		},
		new_influence_percent = {
			lerp_perfect = 0.075,
			lerp_basic = 0.25
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
recoil_templates.lasgun_p1_m1_ads_killshot = {
	still = {
		camera_recoil_percentage = 0.01,
		decay_grace = 0.15,
		rise_duration = 0.01,
		rise = {
			{
				lerp_perfect = 0.35,
				lerp_basic = 0.5
			},
			{
				lerp_perfect = 0.25,
				lerp_basic = 0.4
			},
			{
				lerp_perfect = 0.15,
				lerp_basic = 0.35
			},
			{
				lerp_perfect = 0.125,
				lerp_basic = 0.5
			},
			{
				lerp_perfect = 0.125,
				lerp_basic = 0.5
			},
			{
				lerp_perfect = 0.125,
				lerp_basic = 0.5
			},
			{
				lerp_perfect = 0.125,
				lerp_basic = 0.5
			},
			{
				lerp_perfect = 0.125,
				lerp_basic = 0.5
			}
		},
		decay = {
			shooting = {
				lerp_perfect = 1,
				lerp_basic = 0.25
			},
			idle = {
				lerp_perfect = 3,
				lerp_basic = 1
			}
		},
		offset = {
			{
				pitch = {
					lerp_perfect = 0.015,
					lerp_basic = 0.025
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0.025
				}
			},
			{
				pitch = {
					lerp_perfect = 0.0125,
					lerp_basic = 0.035
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0
				}
			},
			{
				pitch = {
					lerp_perfect = 0.02,
					lerp_basic = 0.05
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0.011
				}
			},
			{
				pitch = {
					lerp_perfect = 0.02,
					lerp_basic = 0.04
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = -0.009
				}
			},
			{
				pitch = {
					lerp_perfect = 0.018,
					lerp_basic = 0.038
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = -0.005
				}
			},
			{
				pitch = {
					lerp_perfect = 0.016,
					lerp_basic = 0.036
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = -0.007
				}
			},
			{
				pitch = {
					lerp_perfect = 0.014,
					lerp_basic = 0.034
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0.005
				}
			},
			{
				pitch = {
					lerp_perfect = 0.012,
					lerp_basic = 0.032
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0
				}
			},
			{
				pitch = {
					lerp_perfect = 0.01,
					lerp_basic = 0.03
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0
				}
			}
		},
		offset_random_range = {
			{
				pitch = {
					lerp_perfect = 0,
					lerp_basic = 0.02
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0.015
				}
			},
			{
				pitch = {
					lerp_perfect = 0,
					lerp_basic = 0.015
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0.0125
				}
			},
			{
				pitch = {
					lerp_perfect = 0,
					lerp_basic = 0.01
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0.0075
				}
			},
			{
				pitch = {
					lerp_perfect = 0,
					lerp_basic = 0.011
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0.0075
				}
			},
			{
				pitch = {
					lerp_perfect = 0.005,
					lerp_basic = 0.012
				},
				yaw = {
					lerp_perfect = 0.001,
					lerp_basic = 0.01
				}
			},
			{
				pitch = {
					lerp_perfect = 0.0065,
					lerp_basic = 0.013
				},
				yaw = {
					lerp_perfect = 0.0025,
					lerp_basic = 0.0125
				}
			},
			{
				pitch = {
					lerp_perfect = 0.0075,
					lerp_basic = 0.015
				},
				yaw = {
					lerp_perfect = 0.005,
					lerp_basic = 0.015
				}
			},
			{
				pitch = {
					lerp_perfect = 0.01,
					lerp_basic = 0.0175
				},
				yaw = {
					lerp_perfect = 0.008,
					lerp_basic = 0.0175
				}
			},
			{
				pitch = {
					lerp_perfect = 0.0125,
					lerp_basic = 0.02
				},
				yaw = {
					lerp_perfect = 0.009,
					lerp_basic = 0.02
				}
			},
			{
				pitch = {
					lerp_perfect = 0.015,
					lerp_basic = 0.025
				},
				yaw = {
					lerp_perfect = 0.01,
					lerp_basic = 0.0225
				}
			},
			{
				pitch = {
					lerp_perfect = 0.015,
					lerp_basic = 0.025
				},
				yaw = {
					lerp_perfect = 0.01,
					lerp_basic = 0.025
				}
			}
		},
		offset_limit = {
			yaw = 0.5,
			pitch = 1
		},
		new_influence_percent = {
			lerp_perfect = 0.4,
			lerp_basic = 0.6
		},
		visual_recoil_settings = {
			intensity = 4.5,
			lerp_scalar = 0.8,
			yaw_intensity = 3.25
		}
	},
	moving = {
		inherits = {
			"lasgun_p1_m1_ads_killshot",
			"still"
		},
		new_influence_percent = {
			lerp_perfect = 0.45,
			lerp_basic = 0.7
		}
	},
	crouch_still = {
		inherits = {
			"lasgun_p1_m1_ads_killshot",
			"still"
		},
		new_influence_percent = {
			lerp_perfect = 0.35,
			lerp_basic = 0.5
		}
	},
	crouch_moving = {
		inherits = {
			"lasgun_p1_m1_ads_killshot",
			"still"
		},
		new_influence_percent = {
			lerp_perfect = 0.5,
			lerp_basic = 0.8
		}
	}
}
recoil_templates.lasgun_p1_m2_ads_killshot = {
	still = {
		camera_recoil_percentage = 0.01,
		decay_grace = 0.15,
		rise_duration = 0.01,
		rise = {
			{
				lerp_perfect = 0.25,
				lerp_basic = 0.5
			},
			{
				lerp_perfect = 0.2,
				lerp_basic = 0.4
			},
			{
				lerp_perfect = 0.15,
				lerp_basic = 0.35
			},
			{
				lerp_perfect = 0.125,
				lerp_basic = 0.5
			},
			{
				lerp_perfect = 0.125,
				lerp_basic = 0.5
			},
			{
				lerp_perfect = 0.125,
				lerp_basic = 0.5
			},
			{
				lerp_perfect = 0.125,
				lerp_basic = 0.5
			},
			{
				lerp_perfect = 0.125,
				lerp_basic = 0.5
			}
		},
		decay = {
			shooting = {
				lerp_perfect = 1,
				lerp_basic = 0.25
			},
			idle = {
				lerp_perfect = 3,
				lerp_basic = 1
			}
		},
		offset = {
			{
				pitch = {
					lerp_perfect = 0.015,
					lerp_basic = 0.025
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0
				}
			},
			{
				pitch = {
					lerp_perfect = 0.0125,
					lerp_basic = 0.035
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0
				}
			},
			{
				pitch = {
					lerp_perfect = 0.02,
					lerp_basic = 0.03
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0.011
				}
			},
			{
				pitch = {
					lerp_perfect = 0.02,
					lerp_basic = 0.032
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = -0.009
				}
			},
			{
				pitch = {
					lerp_perfect = 0.018,
					lerp_basic = 0.034
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = -0.005
				}
			},
			{
				pitch = {
					lerp_perfect = 0.016,
					lerp_basic = 0.033
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = -0.007
				}
			},
			{
				pitch = {
					lerp_perfect = 0.014,
					lerp_basic = 0.032
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0.005
				}
			},
			{
				pitch = {
					lerp_perfect = 0.012,
					lerp_basic = 0.031
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0
				}
			},
			{
				pitch = {
					lerp_perfect = 0.01,
					lerp_basic = 0.03
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0
				}
			}
		},
		offset_random_range = {
			{
				pitch = {
					lerp_perfect = 0,
					lerp_basic = 0.02
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0.015
				}
			},
			{
				pitch = {
					lerp_perfect = 0,
					lerp_basic = 0.015
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0.0125
				}
			},
			{
				pitch = {
					lerp_perfect = 0,
					lerp_basic = 0.01
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0.0075
				}
			},
			{
				pitch = {
					lerp_perfect = 0,
					lerp_basic = 0.011
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0.0075
				}
			},
			{
				pitch = {
					lerp_perfect = 0.005,
					lerp_basic = 0.012
				},
				yaw = {
					lerp_perfect = 0.001,
					lerp_basic = 0.01
				}
			},
			{
				pitch = {
					lerp_perfect = 0.0065,
					lerp_basic = 0.013
				},
				yaw = {
					lerp_perfect = 0.0025,
					lerp_basic = 0.0125
				}
			},
			{
				pitch = {
					lerp_perfect = 0.0075,
					lerp_basic = 0.015
				},
				yaw = {
					lerp_perfect = 0.005,
					lerp_basic = 0.015
				}
			},
			{
				pitch = {
					lerp_perfect = 0.01,
					lerp_basic = 0.0175
				},
				yaw = {
					lerp_perfect = 0.008,
					lerp_basic = 0.0175
				}
			},
			{
				pitch = {
					lerp_perfect = 0.0125,
					lerp_basic = 0.02
				},
				yaw = {
					lerp_perfect = 0.009,
					lerp_basic = 0.02
				}
			},
			{
				pitch = {
					lerp_perfect = 0.015,
					lerp_basic = 0.025
				},
				yaw = {
					lerp_perfect = 0.01,
					lerp_basic = 0.0225
				}
			},
			{
				pitch = {
					lerp_perfect = 0.015,
					lerp_basic = 0.025
				},
				yaw = {
					lerp_perfect = 0.01,
					lerp_basic = 0.025
				}
			}
		},
		offset_limit = {
			yaw = 0.5,
			pitch = 1
		},
		new_influence_percent = {
			lerp_perfect = 0.4,
			lerp_basic = 0.6
		},
		visual_recoil_settings = {
			intensity = 4.5,
			lerp_scalar = 0.8,
			yaw_intensity = 4.25
		}
	},
	moving = {
		inherits = {
			"lasgun_p1_m2_ads_killshot",
			"still"
		},
		new_influence_percent = {
			lerp_perfect = 0.45,
			lerp_basic = 0.7
		}
	},
	crouch_still = {
		inherits = {
			"lasgun_p1_m2_ads_killshot",
			"still"
		},
		new_influence_percent = {
			lerp_perfect = 0.35,
			lerp_basic = 0.5
		}
	},
	crouch_moving = {
		inherits = {
			"lasgun_p1_m2_ads_killshot",
			"still"
		},
		new_influence_percent = {
			lerp_perfect = 0.5,
			lerp_basic = 0.8
		}
	}
}
recoil_templates.lasgun_p1_m3_ads_killshot = {
	still = {
		camera_recoil_percentage = 0.1,
		decay_grace = 0.15,
		rise_duration = 0.05,
		rise = {
			{
				lerp_perfect = 0.5,
				lerp_basic = 0.8
			},
			{
				lerp_perfect = 0.4,
				lerp_basic = 0.7
			},
			{
				lerp_perfect = 0.35,
				lerp_basic = 0.6
			},
			{
				lerp_perfect = 0.3,
				lerp_basic = 0.5
			}
		},
		decay = {
			shooting = {
				lerp_perfect = 0.75,
				lerp_basic = 0.2
			},
			idle = {
				lerp_perfect = 2,
				lerp_basic = 0.75
			}
		},
		offset = {
			{
				pitch = {
					lerp_perfect = 0.025,
					lerp_basic = 0.07
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0
				}
			},
			{
				pitch = {
					lerp_perfect = 0.02,
					lerp_basic = 0.075
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0.011
				}
			},
			{
				pitch = {
					lerp_perfect = 0.02,
					lerp_basic = 0.065
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = -0.011
				}
			},
			{
				pitch = {
					lerp_perfect = 0.02,
					lerp_basic = 0.05
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0.011
				}
			}
		},
		offset_random_range = {
			{
				pitch = {
					lerp_perfect = 0,
					lerp_basic = 0.02
				},
				yaw = {
					lerp_perfect = 0.0025,
					lerp_basic = 0.01
				}
			},
			{
				pitch = {
					lerp_perfect = 0,
					lerp_basic = 0
				},
				yaw = {
					lerp_perfect = 0.0025,
					lerp_basic = 0.01
				}
			},
			{
				pitch = {
					lerp_perfect = 0,
					lerp_basic = 0.01
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0.005
				}
			},
			{
				pitch = {
					lerp_perfect = 0,
					lerp_basic = 0.011
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0.0075
				}
			},
			{
				pitch = {
					lerp_perfect = 0.005,
					lerp_basic = 0.012
				},
				yaw = {
					lerp_perfect = 0.001,
					lerp_basic = 0.01
				}
			},
			{
				pitch = {
					lerp_perfect = 0.0065,
					lerp_basic = 0.013
				},
				yaw = {
					lerp_perfect = 0.0025,
					lerp_basic = 0.0125
				}
			},
			{
				pitch = {
					lerp_perfect = 0.0075,
					lerp_basic = 0.015
				},
				yaw = {
					lerp_perfect = 0.005,
					lerp_basic = 0.015
				}
			},
			{
				pitch = {
					lerp_perfect = 0.01,
					lerp_basic = 0.0175
				},
				yaw = {
					lerp_perfect = 0.008,
					lerp_basic = 0.0175
				}
			},
			{
				pitch = {
					lerp_perfect = 0.0125,
					lerp_basic = 0.02
				},
				yaw = {
					lerp_perfect = 0.009,
					lerp_basic = 0.02
				}
			},
			{
				pitch = {
					lerp_perfect = 0.015,
					lerp_basic = 0.025
				},
				yaw = {
					lerp_perfect = 0.01,
					lerp_basic = 0.0225
				}
			},
			{
				pitch = {
					lerp_perfect = 0.015,
					lerp_basic = 0.025
				},
				yaw = {
					lerp_perfect = 0.01,
					lerp_basic = 0.025
				}
			}
		},
		offset_limit = {
			yaw = 0.5,
			pitch = 1
		},
		new_influence_percent = {
			lerp_perfect = 0.4,
			lerp_basic = 0.6
		},
		visual_recoil_settings = {
			intensity = 4,
			lerp_scalar = 0.8,
			yaw_intensity = 3.8
		}
	},
	moving = {
		inherits = {
			"lasgun_p1_m3_ads_killshot",
			"still"
		},
		new_influence_percent = {
			lerp_perfect = 0.45,
			lerp_basic = 0.7
		}
	},
	crouch_still = {
		inherits = {
			"lasgun_p1_m3_ads_killshot",
			"still"
		},
		new_influence_percent = {
			lerp_perfect = 0.35,
			lerp_basic = 0.5
		}
	},
	crouch_moving = {
		inherits = {
			"lasgun_p1_m3_ads_killshot",
			"still"
		},
		new_influence_percent = {
			lerp_perfect = 0.5,
			lerp_basic = 0.8
		}
	}
}
recoil_templates.ironsight_lasgun_killshot = {
	still = {
		camera_recoil_percentage = 0.5,
		rise_duration = 0.095,
		rise = {
			{
				lerp_perfect = 0.45,
				lerp_basic = 0.5
			},
			{
				lerp_perfect = 0.2,
				lerp_basic = 0.25
			},
			{
				lerp_perfect = 0.15,
				lerp_basic = 0.2
			},
			{
				lerp_perfect = 0.15,
				lerp_basic = 0.2
			}
		},
		decay = {
			shooting = {
				lerp_perfect = 0.3,
				lerp_basic = 0.25
			},
			idle = {
				lerp_perfect = 1,
				lerp_basic = 0.8
			}
		},
		offset = {
			{
				pitch = {
					lerp_perfect = 0.03,
					lerp_basic = 0.075
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0
				}
			},
			{
				pitch = {
					lerp_perfect = 0.06,
					lerp_basic = 0.07
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0
				}
			},
			{
				pitch = {
					lerp_perfect = 0.075,
					lerp_basic = 0.065
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0
				}
			},
			{
				pitch = {
					lerp_perfect = 0.075,
					lerp_basic = 0.085
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0
				}
			},
			{
				pitch = {
					lerp_perfect = 0.075,
					lerp_basic = 0.095
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0
				}
			},
			{
				pitch = {
					lerp_perfect = 0.075,
					lerp_basic = 0.1
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0
				}
			}
		},
		offset_random_range = {
			{
				pitch = {
					lerp_perfect = 0,
					lerp_basic = 0
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0
				}
			},
			{
				pitch = {
					lerp_perfect = 0,
					lerp_basic = 0
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0
				}
			},
			{
				pitch = {
					lerp_perfect = 0.02,
					lerp_basic = 0.01
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0.01
				}
			},
			{
				pitch = {
					lerp_perfect = 0.035,
					lerp_basic = 0.015
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0.015
				}
			},
			{
				pitch = {
					lerp_perfect = 0.035,
					lerp_basic = 0.02
				},
				yaw = {
					lerp_perfect = 0.02,
					lerp_basic = 0.02
				}
			},
			{
				pitch = {
					lerp_perfect = 0.025,
					lerp_basic = 0.025
				},
				yaw = {
					lerp_perfect = 0.035,
					lerp_basic = 0.025
				}
			},
			{
				pitch = {
					lerp_perfect = 0.015,
					lerp_basic = 0.03
				},
				yaw = {
					lerp_perfect = 0.04,
					lerp_basic = 0.03
				}
			},
			{
				pitch = {
					lerp_perfect = 0.015,
					lerp_basic = 0.035
				},
				yaw = {
					lerp_perfect = 0.04,
					lerp_basic = 0.035
				}
			},
			{
				pitch = {
					lerp_perfect = 0.015,
					lerp_basic = 0.04
				},
				yaw = {
					lerp_perfect = 0.04,
					lerp_basic = 0.04
				}
			},
			{
				pitch = {
					lerp_perfect = 0.015,
					lerp_basic = 0.045
				},
				yaw = {
					lerp_perfect = 0.04,
					lerp_basic = 0.045
				}
			},
			{
				pitch = {
					lerp_perfect = 0.015,
					lerp_basic = 0.05
				},
				yaw = {
					lerp_perfect = 0.04,
					lerp_basic = 0.05
				}
			}
		},
		offset_limit = {
			yaw = 0.175,
			pitch = 0.175
		},
		new_influence_percent = {
			lerp_perfect = 0.25,
			lerp_basic = 0.3
		},
		visual_recoil_settings = {
			intensity = 5,
			lerp_scalar = 0.2
		}
	},
	moving = {
		inherits = {
			"ironsight_lasgun_killshot",
			"still"
		},
		new_influence_percent = {
			lerp_perfect = 0.25,
			lerp_basic = 0.35
		}
	},
	crouch_still = {
		inherits = {
			"ironsight_lasgun_killshot",
			"still"
		}
	},
	crouch_moving = {
		inherits = {
			"ironsight_lasgun_killshot",
			"still"
		}
	}
}
recoil_templates.default_lasgun_spraynpray = {
	still = {
		new_influence_percent = 0.1,
		rise_duration = 0.075,
		rise = {
			0.1
		},
		decay = {
			shooting = 1,
			idle = 1.75
		},
		offset_range = {
			{
				pitch = {
					0.1,
					0.125
				},
				yaw = {
					-0.02,
					0.02
				}
			},
			{
				pitch = {
					0.075,
					0.1
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
			},
			{
				pitch = {
					0.02,
					0.04
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
		aim_assist = {
			multiplier_function = AIM_ASSIST_MULTIPLIER_FUNCTIONS.unmodified_inverted_unsteadiness
		}
	},
	moving = {
		new_influence_percent = 0.05,
		inherits = {
			"default_lasgun_spraynpray",
			"still"
		},
		rise = {
			0.5,
			0.35,
			0.275,
			0.2
		}
	},
	crouch_still = {
		new_influence_percent = 0.04,
		inherits = {
			"default_lasgun_spraynpray",
			"still"
		}
	},
	crouch_moving = {
		new_influence_percent = 0.08,
		inherits = {
			"default_lasgun_spraynpray",
			"still"
		}
	}
}
local p2_m1_pitch = 0.05
recoil_templates.lasgun_p2_m1_ads_killshot = {
	still = {
		camera_recoil_percentage = 0.1,
		decay_grace = 0.15,
		rise_duration = 0.05,
		rise = {
			{
				lerp_perfect = 0.5,
				lerp_basic = 0.8
			},
			{
				lerp_perfect = 0.4,
				lerp_basic = 0.7
			}
		},
		decay = {
			shooting = {
				lerp_perfect = 0.75,
				lerp_basic = 0.2
			},
			idle = {
				lerp_perfect = 2,
				lerp_basic = 0.75
			}
		},
		offset = {
			{
				pitch = {
					lerp_perfect = 0.015,
					lerp_basic = 0.05
				},
				yaw = {
					lerp_perfect = 0,
					lerp_basic = 0
				}
			}
		},
		offset_random_range = {
			{
				pitch = {
					lerp_perfect = 0,
					lerp_basic = 0.025
				},
				yaw = {
					lerp_perfect = 0.0025,
					lerp_basic = 0.01
				}
			}
		},
		offset_limit = {
			yaw = 0.5,
			pitch = 1
		},
		new_influence_percent = {
			lerp_perfect = 0.4,
			lerp_basic = 0.6
		},
		visual_recoil_settings = {
			intensity = 6,
			lerp_scalar = 0.8,
			yaw_intensity = 7.8
		}
	},
	moving = {
		inherits = {
			"lasgun_p2_m1_ads_killshot",
			"still"
		},
		new_influence_percent = {
			lerp_perfect = 0.45,
			lerp_basic = 0.7
		}
	},
	crouch_still = {
		inherits = {
			"lasgun_p2_m1_ads_killshot",
			"still"
		},
		new_influence_percent = {
			lerp_perfect = 0.35,
			lerp_basic = 0.5
		}
	},
	crouch_moving = {
		inherits = {
			"lasgun_p2_m1_ads_killshot",
			"still"
		},
		new_influence_percent = {
			lerp_perfect = 0.5,
			lerp_basic = 0.8
		}
	}
}
recoil_templates.default_lasgun_bfg = {
	still = {
		new_influence_percent = 0.75,
		rise_duration = 0.1,
		rise = {
			0.3
		},
		decay = {
			shooting = 0.5,
			idle = 1.5
		},
		offset_range = {
			{
				pitch = {
					0.01,
					0.3
				},
				yaw = {
					-0.1,
					0.1
				}
			}
		},
		offset_limit = {
			yaw = 3,
			pitch = 1
		}
	},
	moving = {
		inherits = {
			"default_lasgun_bfg",
			"still"
		}
	},
	crouch_still = {
		inherits = {
			"default_lasgun_bfg",
			"still"
		}
	},
	crouch_moving = {
		inherits = {
			"default_lasgun_bfg",
			"still"
		}
	}
}
recoil_templates.hip_lasgun_p3_m1_recoil = {
	still = {
		camera_recoil_percentage = 0.15,
		decay_grace = 0.125,
		rise_duration = 0.075,
		rise = {
			{
				lerp_perfect = 0.3,
				lerp_basic = 0.4
			},
			{
				lerp_perfect = 0.3,
				lerp_basic = 0.4
			},
			{
				lerp_perfect = 0.3,
				lerp_basic = 0.4
			},
			{
				lerp_perfect = 0.3,
				lerp_basic = 0.4
			},
			{
				lerp_perfect = 0.2,
				lerp_basic = 0.5
			},
			{
				lerp_perfect = 0.15,
				lerp_basic = 0.5
			}
		},
		decay = {
			shooting = {
				lerp_perfect = 1,
				lerp_basic = 0.25
			},
			idle = {
				lerp_perfect = 3,
				lerp_basic = 1
			}
		},
		offset = assault_p3_m1_offset_range,
		offset_random_range = assault_p3_m1_random_range,
		offset_limit = {
			yaw = 0.5,
			pitch = 0.5
		},
		visual_recoil_settings = {
			intensity = 10,
			lerp_scalar = 0.75
		},
		new_influence_percent = {
			lerp_perfect = 0.05,
			lerp_basic = 0.2
		}
	},
	moving = {
		inherits = {
			"hip_lasgun_p3_m1_recoil",
			"still"
		},
		new_influence_percent = {
			lerp_perfect = 0.06,
			lerp_basic = 0.12
		}
	},
	crouch_still = {
		inherits = {
			"hip_lasgun_p3_m1_recoil",
			"still"
		},
		new_influence_percent = {
			lerp_perfect = 0.05,
			lerp_basic = 0.1
		}
	},
	crouch_moving = {
		inherits = {
			"hip_lasgun_p3_m1_recoil",
			"still"
		},
		new_influence_percent = {
			lerp_perfect = 0.075,
			lerp_basic = 0.125
		}
	}
}
recoil_templates.lasgun_p3_m1_ads_killshot = {
	still = {
		camera_recoil_percentage = 0.01,
		decay_grace = 0.15,
		rise_duration = 0.01,
		rise = {
			{
				lerp_perfect = 0.3,
				lerp_basic = 0.4
			},
			{
				lerp_perfect = 0.3,
				lerp_basic = 0.4
			},
			{
				lerp_perfect = 0.3,
				lerp_basic = 0.4
			},
			{
				lerp_perfect = 0.3,
				lerp_basic = 0.4
			},
			{
				lerp_perfect = 0.2,
				lerp_basic = 0.5
			},
			{
				lerp_perfect = 0.15,
				lerp_basic = 0.5
			}
		},
		decay = {
			shooting = {
				lerp_perfect = 1,
				lerp_basic = 0.25
			},
			idle = {
				lerp_perfect = 3,
				lerp_basic = 1
			}
		},
		offset = killshot_p3_m1_offset_range,
		offset_random_range = killshot_p3_m1_random_range,
		offset_limit = {
			yaw = 0.5,
			pitch = 0.5
		},
		new_influence_percent = {
			lerp_perfect = 0.05,
			lerp_basic = 0.2
		},
		visual_recoil_settings = {
			intensity = 4,
			lerp_scalar = 0.8,
			yaw_intensity = 4.25
		}
	},
	moving = {
		inherits = {
			"lasgun_p3_m1_ads_killshot",
			"still"
		},
		new_influence_percent = {
			lerp_perfect = 0.075,
			lerp_basic = 0.25
		}
	},
	crouch_still = {
		inherits = {
			"lasgun_p3_m1_ads_killshot",
			"still"
		},
		new_influence_percent = {
			lerp_perfect = 0.048,
			lerp_basic = 0.18
		}
	},
	crouch_moving = {
		inherits = {
			"lasgun_p3_m1_ads_killshot",
			"still"
		},
		new_influence_percent = {
			lerp_perfect = 0.73,
			lerp_basic = 0.23
		}
	}
}

return {
	base_templates = recoil_templates,
	overrides = overrides
}
