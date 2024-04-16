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
local assault_scale_m2 = {
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
			1
		}
	},
	{
		6,
		{
			0.5,
			1
		}
	},
	{
		12,
		{
			0.75,
			0.5
		}
	},
	{
		20,
		{
			0.6,
			0.6
		}
	},
	{
		50,
		{
			0.2,
			0.4
		}
	}
}
local assault_random_scale_m2 = {
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
		50,
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
local assault_offset_range_m2 = generate_offset_range(50, 0.045, 0, 0.75, create_scale(assault_scale_m2))
local assault_random_range_m2 = generate_offset_range(50, 0.01, 0.015, 0.75, create_scale(assault_random_scale_m2))
local assault_scale_m3 = {
	{
		1,
		{
			0.75,
			0.5
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
			0.75,
			0.5
		}
	},
	{
		20,
		{
			0.6,
			0.6
		}
	},
	{
		50,
		{
			0.2,
			0.4
		}
	}
}
local assault_random_scale_m3 = {
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
		50,
		{
			1,
			1
		}
	}
}
local braced_scale_m3 = {
	{
		1,
		{
			0.25,
			0.25
		}
	},
	{
		12,
		{
			1,
			1
		}
	},
	{
		20,
		{
			0.6,
			0.6
		}
	},
	{
		50,
		{
			0.2,
			0.4
		}
	}
}
local braced_random_scale_m3 = {
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
		50,
		{
			1,
			1
		}
	}
}
local assault_offset_range_m3 = generate_offset_range(50, 0.045, 0, 0.95, create_scale(assault_scale_m3))
local assault_random_range_m3 = generate_offset_range(50, 0.01, 0.035, 0.95, create_scale(assault_random_scale_m3))
local braced_offset_range_m3 = generate_offset_range(50, 0.01, 0, 0.95, create_scale(braced_scale_m3))
local braced_random_range_m3 = generate_offset_range(50, 0.0075, 0.0075, 0.95, create_scale(braced_random_scale_m3))
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
pitch_default = 0.03
local firerate = 0.096
local shot_decay = 3.5
local rise_time = 0.04784000000000001
local decay_time = firerate - rise_time
local shot_rise = decay_time * shot_decay
recoil_templates.default_ogryn_heavystubber_recoil_spraynpray_hip_m2 = {
	still = {
		camera_recoil_percentage = 0.85,
		new_influence_percent = 1,
		rise_duration = 0.05,
		rise = {
			0.75,
			0.175,
			0.225,
			0.25,
			0.2,
			0.175,
			0.2
		},
		decay = {
			shooting = 1.6,
			idle = 3.2
		},
		offset = assault_offset_range_m2,
		offset_random_range = assault_random_range_m2,
		offset_limit = {
			yaw = 2,
			pitch = 3
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
		new_influence_percent = 0.85,
		inherits = {
			"default_ogryn_heavystubber_recoil_spraynpray_hip_m2",
			"still"
		}
	},
	crouch_still = {
		new_influence_percent = 0.85,
		inherits = {
			"default_ogryn_heavystubber_recoil_spraynpray_hip_m2",
			"still"
		}
	},
	crouch_moving = {
		new_influence_percent = 0.85,
		inherits = {
			"default_ogryn_heavystubber_recoil_spraynpray_hip_m2",
			"still"
		}
	}
}
recoil_templates.default_ogryn_heavystubber_recoil_spraynpray_brace_m2 = {
	still = {
		camera_recoil_percentage = 0.75,
		decay_grace = 0.1,
		rise_duration = 0.08,
		rise = {
			{
				lerp_perfect = 0.55,
				lerp_basic = 0.8
			},
			{
				lerp_perfect = 0.15,
				lerp_basic = 0.3
			},
			{
				lerp_perfect = 0.1,
				lerp_basic = 0.2
			},
			{
				lerp_perfect = 0.029,
				lerp_basic = 0.12
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
			pitch = 1.5
		},
		new_influence_percent = {
			lerp_perfect = 0.35,
			lerp_basic = 0.7
		},
		aim_assist = {
			multiplier_function = AIM_ASSIST_MULTIPLIER_FUNCTIONS.unmodified_inverted_unsteadiness
		},
		visual_recoil_settings = {
			intensity = 4.5,
			lerp_scalar = 1
		}
	},
	moving = {
		inherits = {
			"default_ogryn_heavystubber_recoil_spraynpray_brace_m2",
			"still"
		},
		new_influence_percent = {
			lerp_perfect = 0.3,
			lerp_basic = 0.55
		}
	},
	crouch_still = {
		inherits = {
			"default_ogryn_heavystubber_recoil_spraynpray_brace_m2",
			"still"
		},
		new_influence_percent = {
			lerp_perfect = 0.15,
			lerp_basic = 0.25
		}
	},
	crouch_moving = {
		inherits = {
			"default_ogryn_heavystubber_recoil_spraynpray_brace_m2",
			"still"
		},
		new_influence_percent = {
			lerp_perfect = 0.2,
			lerp_basic = 0.4
		}
	}
}
recoil_templates.default_ogryn_heavystubber_recoil_spraynpray_hip_m3 = {
	still = {
		camera_recoil_percentage = 0.7,
		new_influence_percent = 0.15,
		rise_duration = 0.04,
		rise = {
			0.09,
			0.2,
			0.17,
			0.14,
			0.12,
			0.4,
			0.4,
			0.3,
			0.3,
			0.3,
			0.35,
			0.4,
			0.75
		},
		decay = {
			shooting = 0.5,
			idle = 0.4
		},
		offset = assault_offset_range_m3,
		offset_random_range = assault_random_range_m3,
		offset_limit = {
			yaw = 2,
			pitch = 3
		},
		aim_assist = {
			multiplier_function = AIM_ASSIST_MULTIPLIER_FUNCTIONS.unmodified_inverted_unsteadiness
		},
		visual_recoil_settings = {
			intensity = 0.8,
			lerp_scalar = 0.9
		}
	},
	moving = {
		new_influence_percent = 0.25,
		inherits = {
			"default_ogryn_heavystubber_recoil_spraynpray_hip_m3",
			"still"
		}
	},
	crouch_still = {
		new_influence_percent = 0.25,
		inherits = {
			"default_ogryn_heavystubber_recoil_spraynpray_hip_m3",
			"still"
		}
	},
	crouch_moving = {
		new_influence_percent = 0.25,
		inherits = {
			"default_ogryn_heavystubber_recoil_spraynpray_hip_m3",
			"still"
		}
	}
}
recoil_templates.default_ogryn_heavystubber_recoil_spraynpray_brace_m3 = {
	still = {
		camera_recoil_percentage = 0.85,
		decay_grace = 0.05,
		new_influence_percent = 0.29,
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
			0.03,
			0.02
		},
		decay = {
			shooting = {
				lerp_perfect = 1.4,
				lerp_basic = 0.8
			},
			idle = {
				lerp_perfect = 3,
				lerp_basic = 2
			}
		},
		offset = braced_offset_range_m3,
		offset_random_range = braced_random_range_m3,
		offset_limit = {
			yaw = 1.2,
			pitch = 1.2
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
			"default_ogryn_heavystubber_recoil_spraynpray_brace_m3",
			"still"
		}
	},
	crouch_still = {
		new_influence_percent = 0.25,
		inherits = {
			"default_ogryn_heavystubber_recoil_spraynpray_brace_m3",
			"still"
		}
	},
	crouch_moving = {
		new_influence_percent = 0.25,
		inherits = {
			"default_ogryn_heavystubber_recoil_spraynpray_brace_m3",
			"still"
		}
	}
}
recoil_templates.ogryn_heavystubber_p2_m1_recoil_hip = {
	still = {
		camera_recoil_percentage = 0.85,
		decay_grace = 0.05,
		new_influence_percent = 0.94,
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
			intensity = 1.4,
			lerp_scalar = 1
		}
	},
	moving = {
		new_influence_percent = 0.25,
		inherits = {
			"ogryn_heavystubber_p2_m1_recoil_hip",
			"still"
		}
	},
	crouch_still = {
		new_influence_percent = 0.25,
		inherits = {
			"ogryn_heavystubber_p2_m1_recoil_hip",
			"still"
		}
	},
	crouch_moving = {
		new_influence_percent = 0.25,
		inherits = {
			"ogryn_heavystubber_p2_m1_recoil_hip",
			"still"
		}
	}
}
recoil_templates.ogryn_heavystubber_p2_m2_recoil_hip = {
	still = {
		camera_recoil_percentage = 0.3,
		decay_grace = 0.09,
		new_influence_percent = 0.4,
		rise_duration = 0.011,
		rise = {
			2,
			1.5,
			0.4
		},
		decay = {
			shooting = 1.2,
			idle = 2.5
		},
		offset_range = {
			{
				pitch = {
					0.0375,
					0.175
				},
				yaw = {
					-0.02,
					0.0375
				}
			}
		},
		offset_limit = {
			yaw = 1.5,
			pitch = 3.9
		},
		aim_assist = {
			multiplier_function = AIM_ASSIST_MULTIPLIER_FUNCTIONS.unmodified_inverted_unsteadiness
		},
		visual_recoil_settings = {
			intensity = 1.8,
			lerp_scalar = 1
		}
	},
	moving = {
		new_influence_percent = 0.6,
		inherits = {
			"ogryn_heavystubber_p2_m2_recoil_hip",
			"still"
		}
	},
	crouch_still = {
		new_influence_percent = 0.1,
		inherits = {
			"ogryn_heavystubber_p2_m2_recoil_hip",
			"still"
		}
	},
	crouch_moving = {
		new_influence_percent = 0.3,
		inherits = {
			"ogryn_heavystubber_p2_m2_recoil_hip",
			"still"
		}
	}
}
recoil_templates.ogryn_heavystubber_p2_m2_recoil_aim = {
	still = {
		camera_recoil_percentage = 0.2,
		new_influence_percent = 1.1,
		rise_duration = 0.15,
		rise = {
			4.75,
			2.5,
			1.225,
			1.25,
			1.2,
			1.175,
			0.2
		},
		decay = {
			shooting = 0.5,
			idle = 2.1
		},
		offset_range = {
			{
				pitch = {
					0.011000000000000001,
					0.038000000000000006
				},
				yaw = {
					-0.008,
					0.023000000000000003
				}
			}
		},
		offset_limit = {
			yaw = 2,
			pitch = 3
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
		new_influence_percent = 0.85,
		inherits = {
			"ogryn_heavystubber_p2_m2_recoil_aim",
			"still"
		}
	},
	crouch_still = {
		new_influence_percent = 0.3,
		inherits = {
			"ogryn_heavystubber_p2_m2_recoil_aim",
			"still"
		}
	},
	crouch_moving = {
		new_influence_percent = 0.85,
		inherits = {
			"ogryn_heavystubber_p2_m2_recoil_aim",
			"still"
		}
	}
}
recoil_templates.ogryn_heavystubber_p2_m3_recoil_hip = {
	still = {
		camera_recoil_percentage = 0.3,
		decay_grace = 0.09,
		new_influence_percent = 0.6,
		rise_duration = 0.011,
		rise = {
			2,
			1.5,
			0.4
		},
		decay = {
			shooting = 1.2,
			idle = 2.5
		},
		offset_range = {
			{
				pitch = {
					0.0375,
					0.175
				},
				yaw = {
					-0.02,
					0.0375
				}
			}
		},
		offset_limit = {
			yaw = 1.5,
			pitch = 3.9
		},
		aim_assist = {
			multiplier_function = AIM_ASSIST_MULTIPLIER_FUNCTIONS.unmodified_inverted_unsteadiness
		},
		visual_recoil_settings = {
			intensity = 1.8,
			lerp_scalar = 1
		}
	},
	moving = {
		new_influence_percent = 0.6,
		inherits = {
			"ogryn_heavystubber_p2_m3_recoil_hip",
			"still"
		}
	},
	crouch_still = {
		new_influence_percent = 0.1,
		inherits = {
			"ogryn_heavystubber_p2_m3_recoil_hip",
			"still"
		}
	},
	crouch_moving = {
		new_influence_percent = 0.3,
		inherits = {
			"ogryn_heavystubber_p2_m3_recoil_hip",
			"still"
		}
	}
}
recoil_templates.recoil_ogryn_heavystubber_p2_m3_braced = {
	still = {
		camera_recoil_percentage = 0.4,
		decay_grace = 0.2,
		new_influence_percent = 1.5,
		rise_duration = 0.125,
		rise = {
			5.2
		},
		decay = {
			shooting = 1.07,
			idle = 1.5
		},
		offset_range = {
			{
				pitch = {
					0.0275,
					0.095
				},
				yaw = {
					-0.02,
					0.0575
				}
			},
			{
				pitch = {
					0.025,
					0.0825
				},
				yaw = {
					-0.02,
					0.0625
				}
			},
			{
				pitch = {
					0.0225,
					0.075
				},
				yaw = {
					-0.02,
					0.0625
				}
			},
			{
				pitch = {
					0.02,
					0.06
				},
				yaw = {
					-0.02,
					0.0625
				}
			}
		},
		offset_limit = {
			yaw = 1.7,
			pitch = 3.3
		},
		aim_assist = {
			multiplier_function = AIM_ASSIST_MULTIPLIER_FUNCTIONS.unmodified_inverted_unsteadiness
		},
		visual_recoil_settings = {
			intensity = 1.5,
			lerp_scalar = 1
		}
	},
	moving = {
		new_influence_percent = 1.3,
		inherits = {
			"recoil_ogryn_heavystubber_p2_m3_braced",
			"still"
		}
	},
	crouch_still = {
		new_influence_percent = 0.2,
		inherits = {
			"recoil_ogryn_heavystubber_p2_m3_braced",
			"still"
		}
	},
	crouch_moving = {
		new_influence_percent = 0.3,
		inherits = {
			"recoil_ogryn_heavystubber_p2_m3_braced",
			"still"
		}
	}
}

return {
	base_templates = recoil_templates,
	overrides = overrides
}
