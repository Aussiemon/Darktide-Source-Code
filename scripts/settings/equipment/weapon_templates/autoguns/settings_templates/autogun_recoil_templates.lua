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
recoil_templates.default_autogun_assault = {
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
			"default_autogun_assault",
			"still"
		},
		new_influence_percent = {
			lerp_perfect = 0.3,
			lerp_basic = 0.55
		}
	},
	crouch_still = {
		inherits = {
			"default_autogun_assault",
			"still"
		},
		new_influence_percent = {
			lerp_perfect = 0.15,
			lerp_basic = 0.25
		}
	},
	crouch_moving = {
		inherits = {
			"default_autogun_assault",
			"still"
		},
		new_influence_percent = {
			lerp_perfect = 0.2,
			lerp_basic = 0.4
		}
	}
}
recoil_templates.default_autogun_burst = {
	still = {
		camera_recoil_percentage = 0.5,
		decay_grace = 0.05,
		new_influence_percent = 0.35,
		rise_duration = 0.05,
		rise = {
			0.3,
			0.15,
			0.15,
			0.15,
			0.3,
			0.1,
			0.1,
			0.1,
			0.3,
			0.1,
			0.1,
			0.1,
			0.3,
			0.05,
			0.05,
			0.05,
			0.2,
			0.05,
			0.05,
			0.05,
			0.2,
			0.05,
			0.05,
			0.05,
			0.2,
			0.05,
			0.05,
			0.05,
			0.2,
			0.05,
			0.05,
			0.05,
			0.2,
			0.05,
			0.05,
			0.05,
			0.2,
			0.05,
			0.05,
			0.05,
			0.2,
			0.05,
			0.05,
			0.05,
			0.2,
			0.05,
			0.05,
			0.05,
			0.2
		},
		decay = {
			shooting = 1,
			idle = 4
		},
		offset_range = {
			{
				pitch = {
					0.05,
					0.06
				},
				yaw = {
					-0.025,
					0.025
				}
			},
			{
				pitch = {
					0.05,
					0.07
				},
				yaw = {
					-0.0225,
					0.0225
				}
			},
			{
				pitch = {
					0.05,
					0.07
				},
				yaw = {
					-0.0225,
					0.0225
				}
			},
			{
				pitch = {
					0.05,
					0.08
				},
				yaw = {
					-0.02,
					0.02
				}
			},
			{
				pitch = {
					0.06,
					0.07
				},
				yaw = {
					-0.02,
					0.02
				}
			},
			{
				pitch = {
					0.06,
					0.06
				},
				yaw = {
					-0.02,
					0.02
				}
			},
			{
				pitch = {
					0.06,
					0.07
				},
				yaw = {
					-0.02,
					0.02
				}
			},
			{
				pitch = {
					0.05,
					0.07
				},
				yaw = {
					-0.02,
					0.02
				}
			},
			{
				pitch = {
					0.05,
					0.07
				},
				yaw = {
					-0.03,
					0.02
				}
			},
			{
				pitch = {
					0.05,
					0.07
				},
				yaw = {
					-0.04,
					0.02
				}
			},
			{
				pitch = {
					0.05,
					0.07
				},
				yaw = {
					-0.04,
					0.02
				}
			}
		},
		offset_limit = {
			yaw = 2,
			pitch = 2
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
		new_influence_percent = 0.4,
		inherits = {
			"default_autogun_burst",
			"still"
		}
	},
	crouch_still = {
		new_influence_percent = 0.25,
		inherits = {
			"default_autogun_burst",
			"still"
		}
	},
	crouch_moving = {
		new_influence_percent = 0.4,
		inherits = {
			"default_autogun_burst",
			"still"
		}
	}
}
recoil_templates.default_autogun_spraynpray = {
	still = {
		camera_recoil_percentage = 0.85,
		decay_grace = 0.05,
		new_influence_percent = 0.25,
		rise_duration = 0.05,
		rise = {
			0.4,
			0.1,
			0.1,
			0.1,
			0.2
		},
		decay = {
			shooting = 1,
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
			yaw = 2,
			pitch = 2
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
recoil_templates.hip_autogun_spraynpray = {
	still = {
		camera_recoil_percentage = 0.85,
		new_influence_percent = 0.25,
		rise_duration = 0.075,
		rise = {
			0.4,
			0.25,
			0.175,
			0.2,
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
		},
		visual_recoil_settings = {
			intensity = 1,
			lerp_scalar = 1
		}
	},
	moving = {
		new_influence_percent = 0.25,
		inherits = {
			"hip_autogun_spraynpray",
			"still"
		}
	},
	crouch_still = {
		new_influence_percent = 0.25,
		inherits = {
			"hip_autogun_spraynpray",
			"still"
		}
	},
	crouch_moving = {
		new_influence_percent = 0.25,
		inherits = {
			"hip_autogun_spraynpray",
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
recoil_templates.default_autogun_killshot = {
	still = {
		camera_recoil_percentage = 0.5,
		decay_grace = 0.2,
		rise_duration = rise_time,
		rise = {
			{
				lerp_perfect = 0.25,
				lerp_basic = 0.5
			},
			{
				lerp_perfect = 0.175,
				lerp_basic = 0.35
			},
			{
				lerp_basic = shot_rise * 1.25,
				lerp_perfect = shot_rise * 1.5 * 0.5
			},
			{
				lerp_basic = shot_rise * 1.25,
				lerp_perfect = shot_rise * 1.5 * 0.5
			},
			{
				lerp_basic = shot_rise * 1.25,
				lerp_perfect = shot_rise * 1.25 * 0.5
			}
		},
		decay = {
			shooting = {
				lerp_perfect = 2,
				lerp_basic = 1
			},
			idle = {
				lerp_perfect = 1.5,
				lerp_basic = 0.5
			}
		},
		offset = killshot_offset_range,
		offset_random_range = killshot_random_range,
		offset_limit = {
			yaw = 2,
			pitch = 2
		},
		new_influence_percent = {
			lerp_perfect = 0.15,
			lerp_basic = 0.25
		},
		aim_assist = {
			reduction_per_shot = 0.25,
			multiplier_function = AIM_ASSIST_MULTIPLIER_FUNCTIONS.flat_reduction_per_shot
		},
		visual_recoil_settings = {
			intensity = 4,
			lerp_scalar = 0.4,
			yaw_intensity = 3
		}
	},
	moving = {
		inherits = {
			"default_autogun_killshot",
			"still"
		},
		new_influence_percent = {
			lerp_perfect = 0.15,
			lerp_basic = 0.3
		}
	},
	crouch_still = {
		inherits = {
			"default_autogun_killshot",
			"still"
		},
		new_influence_percent = {
			lerp_perfect = 0.15,
			lerp_basic = 0.35
		}
	},
	crouch_moving = {
		inherits = {
			"default_autogun_killshot",
			"still"
		}
	}
}
pitch_default = 0.15
recoil_templates.hip_autogun_killshot = {
	still = {
		camera_recoil_percentage = 0.85,
		new_influence_percent = 0.5,
		rise_duration = 0.05,
		rise = {
			0.3,
			0.45
		},
		decay = {
			shooting = 1,
			idle = 2
		},
		offset_range = {
			{
				pitch = {
					pitch_default * 0.95,
					pitch_default * 1.05
				},
				yaw = {
					-0.15,
					0.15
				}
			},
			{
				pitch = {
					pitch_default * 0.85,
					pitch_default * 1.15
				},
				yaw = {
					-0.13,
					0.13
				}
			},
			{
				pitch = {
					pitch_default * 0.75,
					pitch_default * 1.25
				},
				yaw = {
					-0.01,
					0.01
				}
			},
			{
				pitch = {
					pitch_default * 0.75,
					pitch_default * 1.25
				},
				yaw = {
					-0.01,
					0.01
				}
			},
			{
				pitch = {
					pitch_default * 0.75,
					pitch_default * 1.25
				},
				yaw = {
					-0.01,
					0.01
				}
			},
			{
				pitch = {
					pitch_default * 0.75,
					pitch_default * 1.25
				},
				yaw = {
					-0.015,
					0.015
				}
			},
			{
				pitch = {
					pitch_default * 0.75,
					pitch_default * 1.25
				},
				yaw = {
					-0.02,
					0.02
				}
			},
			{
				pitch = {
					pitch_default * 0.75,
					pitch_default * 1.25
				},
				yaw = {
					-0.025,
					0.025
				}
			}
		},
		offset_limit = {
			yaw = 0.5,
			pitch = 0.15
		},
		aim_assist = {
			reduction_per_shot = 0.25,
			multiplier_function = AIM_ASSIST_MULTIPLIER_FUNCTIONS.flat_reduction_per_shot
		},
		visual_recoil_settings = {
			intensity = 1,
			lerp_scalar = 1
		}
	},
	moving = {
		new_influence_percent = 0.4,
		inherits = {
			"hip_autogun_killshot",
			"still"
		}
	},
	crouch_still = {
		inherits = {
			"hip_autogun_killshot",
			"still"
		}
	},
	crouch_moving = {
		inherits = {
			"hip_autogun_killshot",
			"still"
		}
	}
}

return {
	base_templates = recoil_templates,
	overrides = overrides
}
