local RecoilTemplate = require("scripts/utilities/recoil_template")
local generate_offset_range = RecoilTemplate.generate_offset_range
local create_scale = RecoilTemplate.create_scale
local AIM_ASSIST_MULTIPLIER_FUNCTIONS = RecoilTemplate.AIM_ASSIST_MULTIPLIER_FUNCTIONS
local recoil_templates = {}
local overrides = {}

table.make_unique(recoil_templates)
table.make_unique(overrides)

local assault_scale = {
	{
		1,
		{
			0.5,
			0.5
		}
	},
	{
		3,
		{
			0.75,
			1
		}
	},
	{
		6,
		{
			1,
			1
		}
	},
	{
		12,
		{
			0.5,
			0.5
		}
	},
	{
		20,
		{
			0.3,
			0.6
		}
	},
	{
		30,
		{
			0.2,
			0.4
		}
	}
}
local assault_random_scale = {
	{
		1,
		{
			0.5,
			0.25
		}
	},
	{
		3,
		{
			1,
			0.5
		}
	},
	{
		10,
		{
			0.5,
			0.8
		}
	},
	{
		20,
		{
			0.6,
			0.9
		}
	},
	{
		30,
		{
			1,
			1
		}
	}
}
local killshot_scale = {
	{
		1,
		{
			1,
			1
		}
	},
	{
		6,
		{
			0.2,
			0.5
		}
	},
	{
		15,
		{
			0.15,
			0.3
		}
	},
	{
		30,
		{
			0.3,
			0.1
		}
	}
}
local killshot_random_scale = {
	{
		1,
		{
			0.1,
			0.25
		}
	},
	{
		3,
		{
			0.2,
			0.5
		}
	},
	{
		6,
		{
			0.3,
			0.6
		}
	},
	{
		10,
		{
			0.5,
			0.7
		}
	},
	{
		20,
		{
			0.4,
			1
		}
	},
	{
		30,
		{
			0.5,
			1
		}
	}
}
local num_shot = 30
local pitch_base = 0.2
local yaw_base = 0
local lerp_distance = 0.75
local killshot_offset_range = generate_offset_range(num_shot, 0.125, 0, lerp_distance, create_scale(killshot_scale))
local killshot_random_range = generate_offset_range(30, 0.04, 0.03, 0.75, create_scale(killshot_random_scale))
local assault_offset_range = generate_offset_range(30, 0.015, 0, 0.95, create_scale(assault_scale))
local assault_random_range = generate_offset_range(30, 0.01, 0.02, 0.95, create_scale(assault_random_scale))
recoil_templates.default_ogryn_heavystubber_recoil_spraynpray = {
	still = {
		camera_recoil_percentage = 0.75,
		decay_grace = 0.1,
		rise_duration = 0.05,
		rise = {
			{
				lerp_perfect = 0.15,
				lerp_basic = 0.5
			},
			{
				lerp_perfect = 0.075,
				lerp_basic = 0.175
			},
			{
				lerp_perfect = 0.075,
				lerp_basic = 0.175
			},
			{
				lerp_perfect = 0.025,
				lerp_basic = 0.1
			},
			{
				lerp_perfect = 0.025,
				lerp_basic = 0.2
			},
			{
				lerp_perfect = 0.025,
				lerp_basic = 0.15
			}
		},
		decay = {
			shooting = {
				lerp_perfect = 0.75,
				lerp_basic = 0.5
			},
			idle = {
				lerp_perfect = 3,
				lerp_basic = 2.5
			}
		},
		offset = assault_offset_range,
		offset_random_range = assault_random_range,
		offset_limit = {
			yaw = 1,
			pitch = 1
		},
		new_influence_percent = {
			lerp_perfect = 0.25,
			lerp_basic = 0.5
		},
		aim_assist = {
			multiplier_function = AIM_ASSIST_MULTIPLIER_FUNCTIONS.unmodified_inverted_unsteadiness
		},
		visual_recoil_settings = {
			intensity = 4,
			lerp_scalar = 1
		}
	},
	moving = {
		inherits = {
			"default_ogryn_heavystubber_recoil_spraynpray",
			"still"
		},
		new_influence_percent = {
			lerp_perfect = 0.3,
			lerp_basic = 0.55
		}
	},
	crouch_still = {
		inherits = {
			"default_ogryn_heavystubber_recoil_spraynpray",
			"still"
		},
		new_influence_percent = {
			lerp_perfect = 0.15,
			lerp_basic = 0.25
		}
	},
	crouch_moving = {
		inherits = {
			"default_ogryn_heavystubber_recoil_spraynpray",
			"still"
		},
		new_influence_percent = {
			lerp_perfect = 0.2,
			lerp_basic = 0.4
		}
	}
}
recoil_templates.default_ogryn_heavystubber_recoil_spraynpray_brace = {
	still = {
		camera_recoil_percentage = 0.85,
		decay_grace = 0.05,
		new_influence_percent = 0.34,
		rise_duration = 0.07,
		rise = {
			0.1,
			0.15,
			0.17,
			0.13,
			0.12,
			0.1,
			0.09,
			0.08,
			0.08,
			0.05,
			0.05,
			0.05,
			0.03
		},
		decay = {
			shooting = 1.1,
			idle = 2.5
		},
		offset_range = {
			{
				pitch = {
					0.05,
					0.05
				},
				yaw = {
					-0.01,
					0.01
				}
			},
			{
				pitch = {
					0.065,
					0.065
				},
				yaw = {
					-0.0125,
					0.0125
				}
			},
			{
				pitch = {
					0.05,
					0.075
				},
				yaw = {
					-0.015,
					0.015
				}
			},
			{
				pitch = {
					0.05,
					0.075
				},
				yaw = {
					-0.0175,
					0.0175
				}
			},
			{
				pitch = {
					0.02,
					0.03
				},
				yaw = {
					-0.02,
					0.02
				}
			},
			{
				pitch = {
					0.01,
					0.02
				},
				yaw = {
					-0.02,
					0.02
				}
			},
			{
				pitch = {
					0.01,
					0.02
				},
				yaw = {
					-0.02,
					0.02
				}
			},
			{
				pitch = {
					0.01,
					0.02
				},
				yaw = {
					-0.02,
					0.02
				}
			},
			{
				pitch = {
					0,
					0.02
				},
				yaw = {
					-0.0225,
					0.0225
				}
			}
		},
		offset_limit = {
			yaw = 1.5,
			pitch = 1.5
		},
		aim_assist = {
			multiplier_function = AIM_ASSIST_MULTIPLIER_FUNCTIONS.unmodified_inverted_unsteadiness
		},
		visual_recoil_settings = {
			intensity = 0.4,
			lerp_scalar = 1
		}
	},
	moving = {
		new_influence_percent = 0.25,
		inherits = {
			"default_autogun_spraynpray",
			"still"
		}
	},
	crouch_still = {
		new_influence_percent = 0.25,
		inherits = {
			"default_autogun_spraynpray",
			"still"
		}
	},
	crouch_moving = {
		new_influence_percent = 0.25,
		inherits = {
			"default_autogun_spraynpray",
			"still"
		}
	}
}
recoil_templates.default_ogryn_heavystubber_recoil_spraynpray_hip = {
	still = {
		camera_recoil_percentage = 0.85,
		new_influence_percent = 0.2,
		rise_duration = 0.062,
		rise = {
			0.1,
			0.27,
			0.23,
			0.175,
			0.15,
			0.5,
			0.5,
			0.5,
			0.5,
			0.5,
			0.5,
			0.5,
			0.9
		},
		decay = {
			shooting = 0.5,
			idle = 0.35
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
			pitch = 4
		},
		aim_assist = {
			multiplier_function = AIM_ASSIST_MULTIPLIER_FUNCTIONS.unmodified_inverted_unsteadiness
		},
		visual_recoil_settings = {
			intensity = 1,
			lerp_scalar = 1
		}
	},
	moving = {
		new_influence_percent = 0.25,
		inherits = {
			"default_ogryn_heavystubber_recoil_spraynpray_hip",
			"still"
		}
	},
	crouch_still = {
		new_influence_percent = 0.25,
		inherits = {
			"default_ogryn_heavystubber_recoil_spraynpray_hip",
			"still"
		}
	},
	crouch_moving = {
		new_influence_percent = 0.25,
		inherits = {
			"default_ogryn_heavystubber_recoil_spraynpray_hip",
			"still"
		}
	}
}
pitch_default = 0.03
local firerate = 0.096
local shot_decay = 3.5
local rise_time = 0.04784000000000001
local decay_time = firerate - rise_time
local shot_rise = decay_time * shot_decay

return {
	base_templates = recoil_templates,
	overrides = overrides
}
