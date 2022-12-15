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
			2,
			2
		}
	},
	{
		4,
		{
			0.2,
			0.3
		}
	},
	{
		15,
		{
			0.175,
			0.2
		}
	},
	{
		30,
		{
			0.1,
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
local killshot_p1_m2_scale = {
	{
		1,
		{
			2,
			2
		}
	},
	{
		4,
		{
			0.2,
			0.3
		}
	},
	{
		15,
		{
			0.125,
			0.15
		}
	},
	{
		30,
		{
			0.07,
			0.07
		}
	}
}
local killshot_p1_m2_random_scale = {
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
			0.7
		}
	},
	{
		10,
		{
			0.5,
			1
		}
	},
	{
		20,
		{
			0.4,
			0.6
		}
	},
	{
		30,
		{
			0.5,
			0.4
		}
	}
}
local spraynpray_scale = {
	{
		1,
		{
			1,
			0
		}
	},
	{
		50,
		{
			0.25,
			0
		}
	}
}
local spraynpray_scale_p2_m2 = {
	{
		1,
		{
			1,
			0
		}
	},
	{
		5,
		{
			0.95,
			0
		}
	},
	{
		50,
		{
			0.25,
			0
		}
	}
}
local spraynpray_scale_p2_m3 = {
	{
		1,
		{
			0.5,
			0
		}
	},
	{
		3,
		{
			1,
			0
		}
	},
	{
		15,
		{
			0.25,
			0
		}
	},
	{
		50,
		{
			0.1,
			0
		}
	}
}
local spraynpray_random_scale = {
	{
		1,
		{
			0.05,
			0.1
		}
	},
	{
		4,
		{
			0.35,
			0.4
		}
	},
	{
		8,
		{
			0.5,
			0.6
		}
	},
	{
		12,
		{
			0.55,
			0.7
		}
	},
	{
		16,
		{
			0.5,
			0.75
		}
	},
	{
		20,
		{
			0.4,
			0.8
		}
	},
	{
		24,
		{
			0.3,
			0.8
		}
	},
	{
		28,
		{
			0.2,
			0.8
		}
	},
	{
		32,
		{
			0.15,
			0.8
		}
	},
	{
		36,
		{
			0.15,
			0.75
		}
	},
	{
		50,
		{
			0.2,
			0.7
		}
	}
}
local burst_scale = {
	{
		1,
		{
			0.75,
			0.5
		}
	},
	{
		3,
		{
			1,
			1.5
		}
	},
	{
		6,
		{
			0.75,
			1.25
		}
	},
	{
		12,
		{
			0.75,
			1.05
		}
	},
	{
		18,
		{
			0.5,
			1
		}
	},
	{
		24,
		{
			0.5,
			0.8
		}
	},
	{
		30,
		{
			0.5,
			0.75
		}
	},
	{
		36,
		{
			0.5,
			0.7
		}
	},
	{
		40,
		{
			0.5,
			0.6
		}
	}
}
local burst_random_scale = {
	{
		1,
		{
			0.15,
			0
		}
	},
	{
		2,
		{
			0.65,
			0.5
		}
	},
	{
		6,
		{
			0.75,
			0.65
		}
	},
	{
		12,
		{
			0.5,
			0.8
		}
	},
	{
		18,
		{
			0.55,
			0.85
		}
	},
	{
		24,
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
	},
	{
		36,
		{
			1.2,
			1
		}
	},
	{
		40,
		{
			1.4,
			1
		}
	}
}
local singleshot_scale = {
	{
		1,
		{
			0.5,
			1
		}
	},
	{
		2,
		{
			0.9,
			1
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
			0.5,
			1
		}
	}
}
local singleshot_random_scale = {
	{
		1,
		{
			0.75,
			0.05
		}
	},
	{
		2,
		{
			0.9,
			0.5
		}
	},
	{
		3,
		{
			1,
			1
		}
	},
	{
		4,
		{
			1.1,
			1.15
		}
	},
	{
		5,
		{
			2,
			1.25
		}
	},
	{
		6,
		{
			3,
			1.5
		}
	}
}
local num_shot = 30
local pitch_base = 0.2
local yaw_base = 0
local lerp_distance = 0.75
local assault_offset_range = generate_offset_range(30, 0.015, 0, 0.95, create_scale(assault_scale))
local assault_random_range = generate_offset_range(30, 0.01, 0.02, 0.95, create_scale(assault_random_scale))
local killshot_p1_m2_offset_range = generate_offset_range(num_shot, 0.1, 0, lerp_distance, create_scale(killshot_p1_m2_scale))
local killshot_p1_m2_random_range = generate_offset_range(30, 0.025, 0.065, 0.75, create_scale(killshot_p1_m2_random_scale))
local killshot_offset_range = generate_offset_range(num_shot, 0.125, 0, lerp_distance, create_scale(killshot_scale))
local killshot_random_range = generate_offset_range(30, 0.04, 0.05, 0.75, create_scale(killshot_random_scale))
local spraynpray_offset_range = generate_offset_range(50, 0.01, 0, 0.95, create_scale(spraynpray_scale))
local spraynpray_hip_offset_range = generate_offset_range(50, 0.02, 0, 0.95, create_scale(spraynpray_scale))
local spraynpray_random_range = generate_offset_range(50, 0.009, 0.04, 0.95, create_scale(spraynpray_random_scale))
local spraynpray_offset_range_p2_m2 = generate_offset_range(50, 0.0075, 0, 0.95, create_scale(spraynpray_scale_p2_m2))
local spraynpray_random_range_p2_m2 = generate_offset_range(50, 0.0075, 0.03, 0.95, create_scale(spraynpray_random_scale))
local spraynpray_offset_range_p2_m3 = generate_offset_range(50, 0.0125, 0, 0.95, create_scale(spraynpray_scale_p2_m3))
local spraynpray_random_range_p2_m3 = generate_offset_range(50, 0.0075, 0.04, 0.95, create_scale(spraynpray_random_scale))
local burst_offset_range = generate_offset_range(40, 0.015, 0, 0.95, create_scale(burst_scale))
local burst_random_range = generate_offset_range(40, 0.01, 0.02, 0.95, create_scale(burst_random_scale))
local singleshot_offset_range = generate_offset_range(6, 0.0225, 0, 0.8, create_scale(singleshot_scale))
local singleshot_random_range = generate_offset_range(6, 0.01, 0.02, 0.8, create_scale(singleshot_random_scale))
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
			intensity = 0.025,
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
pitch_default = 0.03
local firerate = 0.096
local shot_decay = 3.5
local rise_time = 0.04784000000000001
local decay_time = firerate - rise_time
local shot_rise = decay_time * shot_decay
recoil_templates.default_autogun_killshot = {
	still = {
		camera_recoil_percentage = 0.5,
		decay_grace = 0.1,
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
				lerp_perfect = 0.5,
				lerp_basic = 0.25
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
			lerp_perfect = 0.1,
			lerp_basic = 0.15
		},
		aim_assist = {
			reduction_per_shot = 0.25,
			multiplier_function = AIM_ASSIST_MULTIPLIER_FUNCTIONS.flat_reduction_per_shot
		},
		visual_recoil_settings = {
			intensity = 4,
			lerp_scalar = 0.8,
			yaw_intensity = 6
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
recoil_templates.autogun_p1_m2_killshot = {
	still = {
		camera_recoil_percentage = 0.5,
		decay_grace = 0.1,
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
				lerp_perfect = 0.5,
				lerp_basic = 0.25
			},
			idle = {
				lerp_perfect = 1.5,
				lerp_basic = 0.5
			}
		},
		offset = killshot_p1_m2_offset_range,
		offset_random_range = killshot_p1_m2_random_range,
		offset_limit = {
			yaw = 2,
			pitch = 2
		},
		new_influence_percent = {
			lerp_perfect = 0.1,
			lerp_basic = 0.15
		},
		aim_assist = {
			reduction_per_shot = 0.25,
			multiplier_function = AIM_ASSIST_MULTIPLIER_FUNCTIONS.flat_reduction_per_shot
		},
		visual_recoil_settings = {
			intensity = 4,
			lerp_scalar = 0.5,
			yaw_intensity = 6
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
recoil_templates.autogun_p1_m1_killshot = {
	still = {
		camera_recoil_percentage = 0.5,
		decay_grace = 0.1,
		rise_duration = rise_time,
		rise = {
			{
				lerp_perfect = 0.25,
				lerp_basic = 0.6
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
				lerp_perfect = 0.5,
				lerp_basic = 0.25
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
			lerp_perfect = 0.1,
			lerp_basic = 0.35
		},
		aim_assist = {
			reduction_per_shot = 0.25,
			multiplier_function = AIM_ASSIST_MULTIPLIER_FUNCTIONS.flat_reduction_per_shot
		},
		visual_recoil_settings = {
			intensity = 4,
			lerp_scalar = 0.8,
			yaw_intensity = 6
		}
	},
	moving = {
		inherits = {
			"default_autogun_killshot",
			"still"
		},
		new_influence_percent = {
			lerp_perfect = 0.15,
			lerp_basic = 0.4
		}
	},
	crouch_still = {
		inherits = {
			"default_autogun_killshot",
			"still"
		},
		new_influence_percent = {
			lerp_perfect = 0.15,
			lerp_basic = 0.45
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
recoil_templates.default_autogun_spraynpray = {
	still = {
		camera_recoil_percentage = 0.75,
		decay_grace = 0.1,
		rise_duration = 0.015,
		rise = {
			{
				lerp_perfect = 0.4,
				lerp_basic = 0.5
			},
			{
				lerp_perfect = 0.24,
				lerp_basic = 0.3
			},
			{
				lerp_perfect = 0.18,
				lerp_basic = 0.225
			},
			{
				lerp_perfect = 0.16,
				lerp_basic = 0.2
			},
			{
				lerp_perfect = 0.08,
				lerp_basic = 0.1
			},
			{
				lerp_perfect = 0.04,
				lerp_basic = 0.05
			},
			{
				lerp_perfect = 0.18,
				lerp_basic = 0.225
			},
			{
				lerp_perfect = 0.16,
				lerp_basic = 0.2
			},
			{
				lerp_perfect = 0.12,
				lerp_basic = 0.15
			},
			{
				lerp_perfect = 0.04,
				lerp_basic = 0.05
			}
		},
		decay = {
			shooting = 0.25,
			idle = {
				lerp_perfect = 3,
				lerp_basic = 2.5
			}
		},
		offset = spraynpray_hip_offset_range,
		offset_random_range = assault_random_range,
		offset_limit = {
			yaw = 2.5,
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
			"default_autogun_spraynpray",
			"still"
		},
		new_influence_percent = {
			lerp_perfect = 0.3,
			lerp_basic = 0.55
		}
	},
	crouch_still = {
		inherits = {
			"default_autogun_spraynpray",
			"still"
		},
		new_influence_percent = {
			lerp_perfect = 0.15,
			lerp_basic = 0.25
		}
	},
	crouch_moving = {
		inherits = {
			"default_autogun_spraynpray",
			"still"
		},
		new_influence_percent = {
			lerp_perfect = 0.2,
			lerp_basic = 0.4
		}
	}
}
recoil_templates.ads_autogun_spraynpray = {
	still = {
		camera_recoil_percentage = 0.45,
		decay_grace = 0.1,
		rise_duration = 0.025,
		rise = {
			{
				lerp_perfect = 0.51,
				lerp_basic = 0.64
			},
			{
				lerp_perfect = 0.37,
				lerp_basic = 0.46
			},
			{
				lerp_perfect = 0.3,
				lerp_basic = 0.38
			},
			{
				lerp_perfect = 0.28,
				lerp_basic = 0.35
			},
			{
				lerp_perfect = 0.18,
				lerp_basic = 0.22
			},
			{
				lerp_perfect = 0.11,
				lerp_basic = 0.14
			},
			{
				lerp_perfect = 0.3,
				lerp_basic = 0.38
			},
			{
				lerp_perfect = 0.28,
				lerp_basic = 0.35
			},
			{
				lerp_perfect = 0.23,
				lerp_basic = 0.29
			},
			{
				lerp_perfect = 0.11,
				lerp_basic = 0.14
			}
		},
		decay = {
			shooting = 0.25,
			idle = {
				lerp_perfect = 2.25,
				lerp_basic = 2.5
			}
		},
		offset = spraynpray_offset_range,
		offset_random_range = spraynpray_random_range,
		offset_limit = {
			yaw = 2.5,
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
			"ads_autogun_spraynpray",
			"still"
		},
		new_influence_percent = {
			lerp_perfect = 0.5,
			lerp_basic = 0.6
		}
	},
	crouch_still = {
		inherits = {
			"ads_autogun_spraynpray",
			"still"
		},
		new_influence_percent = {
			lerp_perfect = 0.15,
			lerp_basic = 0.25
		}
	},
	crouch_moving = {
		inherits = {
			"ads_autogun_spraynpray",
			"still"
		},
		new_influence_percent = {
			lerp_perfect = 0.2,
			lerp_basic = 0.4
		}
	}
}
recoil_templates.ads_autogun_p2_m2_spraynpray = {
	still = {
		camera_recoil_percentage = 0.45,
		decay_grace = 0.1,
		rise_duration = 0.025,
		rise = {
			{
				lerp_perfect = 0.51,
				lerp_basic = 0.64
			},
			{
				lerp_perfect = 0.37,
				lerp_basic = 0.46
			},
			{
				lerp_perfect = 0.3,
				lerp_basic = 0.38
			},
			{
				lerp_perfect = 0.28,
				lerp_basic = 0.35
			},
			{
				lerp_perfect = 0.18,
				lerp_basic = 0.22
			},
			{
				lerp_perfect = 0.11,
				lerp_basic = 0.14
			},
			{
				lerp_perfect = 0.3,
				lerp_basic = 0.38
			},
			{
				lerp_perfect = 0.28,
				lerp_basic = 0.35
			},
			{
				lerp_perfect = 0.23,
				lerp_basic = 0.29
			},
			{
				lerp_perfect = 0.11,
				lerp_basic = 0.14
			}
		},
		decay = {
			shooting = 0.25,
			idle = {
				lerp_perfect = 2.25,
				lerp_basic = 2.5
			}
		},
		offset = spraynpray_offset_range_p2_m2,
		offset_random_range = spraynpray_random_range_p2_m2,
		offset_limit = {
			yaw = 2.5,
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
			"ads_autogun_p2_m2_spraynpray",
			"still"
		},
		new_influence_percent = {
			lerp_perfect = 0.5,
			lerp_basic = 0.6
		}
	},
	crouch_still = {
		inherits = {
			"ads_autogun_p2_m2_spraynpray",
			"still"
		},
		new_influence_percent = {
			lerp_perfect = 0.15,
			lerp_basic = 0.25
		}
	},
	crouch_moving = {
		inherits = {
			"ads_autogun_p2_m2_spraynpray",
			"still"
		},
		new_influence_percent = {
			lerp_perfect = 0.2,
			lerp_basic = 0.4
		}
	}
}
recoil_templates.ads_autogun_p2_m3_spraynpray = {
	still = {
		camera_recoil_percentage = 0.4,
		decay_grace = 0.1,
		rise_duration = 0.025,
		rise = {
			{
				lerp_perfect = 0.51,
				lerp_basic = 0.64
			},
			{
				lerp_perfect = 0.37,
				lerp_basic = 0.46
			},
			{
				lerp_perfect = 0.3,
				lerp_basic = 0.38
			},
			{
				lerp_perfect = 0.28,
				lerp_basic = 0.35
			},
			{
				lerp_perfect = 0.18,
				lerp_basic = 0.22
			},
			{
				lerp_perfect = 0.11,
				lerp_basic = 0.14
			},
			{
				lerp_perfect = 0.3,
				lerp_basic = 0.38
			},
			{
				lerp_perfect = 0.28,
				lerp_basic = 0.35
			},
			{
				lerp_perfect = 0.23,
				lerp_basic = 0.29
			},
			{
				lerp_perfect = 0.11,
				lerp_basic = 0.14
			}
		},
		decay = {
			shooting = 0.25,
			idle = {
				lerp_perfect = 2.25,
				lerp_basic = 2.5
			}
		},
		offset = spraynpray_offset_range_p2_m3,
		offset_random_range = spraynpray_random_range_p2_m3,
		offset_limit = {
			yaw = 2.5,
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
			"ads_autogun_p2_m3_spraynpray",
			"still"
		},
		new_influence_percent = {
			lerp_perfect = 0.5,
			lerp_basic = 0.6
		}
	},
	crouch_still = {
		inherits = {
			"ads_autogun_p2_m3_spraynpray",
			"still"
		},
		new_influence_percent = {
			lerp_perfect = 0.15,
			lerp_basic = 0.25
		}
	},
	crouch_moving = {
		inherits = {
			"ads_autogun_p2_m3_spraynpray",
			"still"
		},
		new_influence_percent = {
			lerp_perfect = 0.2,
			lerp_basic = 0.4
		}
	}
}
overrides.default_autogun_spraynpray_heavy = {
	parent_template_name = "default_autogun_spraynpray",
	overrides = {
		{
			"still",
			"rise_duration",
			0.015
		},
		{
			"still",
			"decay_grace",
			0.01
		}
	}
}
overrides.ads_autogun_spraynpray_heavy = {
	parent_template_name = "default_autogun_spraynpray",
	overrides = {
		{
			"still",
			"rise_duration",
			0.1
		},
		{
			"still",
			"decay_grace",
			0.1
		},
		{
			"still",
			"camera_recoil_percentage",
			0.4
		},
		{
			"moving",
			"camera_recoil_percentage",
			0.4
		},
		{
			"crouch_still",
			"camera_recoil_percentage",
			0.4
		},
		{
			"crouch_moving",
			"camera_recoil_percentage",
			0.4
		}
	}
}
recoil_templates.default_autogun_burst = {
	still = {
		camera_recoil_percentage = 0.75,
		decay_grace = 0.1,
		rise_duration = 0.05,
		rise = {
			{
				lerp_perfect = 2,
				lerp_basic = 2.5
			},
			{
				lerp_perfect = 1.88,
				lerp_basic = 2.35
			},
			{
				lerp_perfect = 1.6,
				lerp_basic = 2
			},
			{
				lerp_perfect = 1,
				lerp_basic = 1.25
			},
			{
				lerp_perfect = 0.6,
				lerp_basic = 0.75
			},
			{
				lerp_perfect = 0.4,
				lerp_basic = 0.5
			}
		},
		decay = {
			shooting = 1,
			idle = 4
		},
		offset = burst_offset_range,
		offset_random_range = burst_random_range,
		offset_limit = {
			yaw = 2,
			pitch = 2
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
			"default_autogun_burst",
			"still"
		},
		new_influence_percent = {
			lerp_perfect = 0.3,
			lerp_basic = 0.55
		}
	},
	crouch_still = {
		inherits = {
			"default_autogun_burst",
			"still"
		},
		new_influence_percent = {
			lerp_perfect = 0.15,
			lerp_basic = 0.25
		}
	},
	crouch_moving = {
		inherits = {
			"default_autogun_burst",
			"still"
		},
		new_influence_percent = {
			lerp_perfect = 0.2,
			lerp_basic = 0.4
		}
	}
}
overrides.ads_autogun_burst = {
	parent_template_name = "default_autogun_burst",
	overrides = {
		{
			"still",
			"rise_duration",
			0.01
		}
	}
}
recoil_templates.default_autogun_single_shot = {
	still = {
		camera_recoil_percentage = 0.3,
		decay_grace = 0.1,
		rise_duration = 0.05,
		rise = {
			1,
			1,
			1
		},
		decay = {
			shooting = 0.05,
			idle = 2
		},
		offset = singleshot_offset_range,
		offset_random_range = singleshot_random_range,
		offset_limit = {
			yaw = 2,
			pitch = 2
		},
		new_influence_percent = {
			lerp_perfect = 0.25,
			lerp_basic = 0.5
		},
		aim_assist = {
			multiplier_function = AIM_ASSIST_MULTIPLIER_FUNCTIONS.unmodified_inverted_unsteadiness
		},
		visual_recoil_settings = {
			intensity = 3.5,
			lerp_scalar = 1
		}
	},
	moving = {
		inherits = {
			"default_autogun_single_shot",
			"still"
		},
		new_influence_percent = {
			lerp_perfect = 0.3,
			lerp_basic = 0.55
		}
	},
	crouch_still = {
		inherits = {
			"default_autogun_single_shot",
			"still"
		},
		new_influence_percent = {
			lerp_perfect = 0.15,
			lerp_basic = 0.25
		}
	},
	crouch_moving = {
		inherits = {
			"default_autogun_single_shot",
			"still"
		},
		new_influence_percent = {
			lerp_perfect = 0.2,
			lerp_basic = 0.4
		}
	}
}
recoil_templates.ads_autogun_single_shot = {
	still = {
		camera_recoil_percentage = 0.5,
		decay_grace = 0.1,
		rise_duration = 0.05,
		rise = {
			1,
			1,
			1
		},
		decay = {
			shooting = 0.05,
			idle = 2
		},
		offset = singleshot_offset_range,
		offset_random_range = singleshot_random_range,
		offset_limit = {
			yaw = 2,
			pitch = 2
		},
		new_influence_percent = {
			lerp_perfect = 0.25,
			lerp_basic = 0.5
		},
		aim_assist = {
			multiplier_function = AIM_ASSIST_MULTIPLIER_FUNCTIONS.unmodified_inverted_unsteadiness
		},
		visual_recoil_settings = {
			intensity = 5,
			lerp_scalar = 1,
			yaw_intensity = 7
		}
	},
	moving = {
		inherits = {
			"ads_autogun_single_shot",
			"still"
		},
		new_influence_percent = {
			lerp_perfect = 0.3,
			lerp_basic = 0.55
		}
	},
	crouch_still = {
		inherits = {
			"ads_autogun_single_shot",
			"still"
		},
		new_influence_percent = {
			lerp_perfect = 0.15,
			lerp_basic = 0.25
		}
	},
	crouch_moving = {
		inherits = {
			"ads_autogun_single_shot",
			"still"
		},
		new_influence_percent = {
			lerp_perfect = 0.2,
			lerp_basic = 0.4
		}
	}
}

return {
	base_templates = recoil_templates,
	overrides = overrides
}
