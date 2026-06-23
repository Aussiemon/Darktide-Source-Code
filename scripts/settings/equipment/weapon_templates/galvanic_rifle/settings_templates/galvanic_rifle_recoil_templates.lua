-- chunkname: @scripts/settings/equipment/weapon_templates/galvanic_rifle/settings_templates/galvanic_rifle_recoil_templates.lua

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
			0.5,
		},
	},
	{
		3,
		{
			0.75,
			1,
		},
	},
	{
		6,
		{
			1,
			1,
		},
	},
	{
		12,
		{
			0.5,
			0.5,
		},
	},
	{
		20,
		{
			0.3,
			0.6,
		},
	},
	{
		30,
		{
			0.2,
			0.4,
		},
	},
}
local assault_random_scale = {
	{
		1,
		{
			0.5,
			0.25,
		},
	},
	{
		3,
		{
			1,
			0.5,
		},
	},
	{
		10,
		{
			0.5,
			0.8,
		},
	},
	{
		20,
		{
			0.6,
			0.9,
		},
	},
	{
		30,
		{
			1,
			1,
		},
	},
}
local killshot_scale = {
	{
		1,
		{
			2,
			2,
		},
	},
	{
		4,
		{
			0.2,
			0.1,
		},
	},
	{
		15,
		{
			0.175,
			0.05,
		},
	},
	{
		30,
		{
			0.1,
			0.075,
		},
	},
}
local killshot_random_scale = {
	{
		1,
		{
			0.08,
			0.15,
		},
	},
	{
		3,
		{
			0.2,
			0.35,
		},
	},
	{
		6,
		{
			0.2,
			0.3,
		},
	},
	{
		10,
		{
			0.4,
			0.4,
		},
	},
	{
		20,
		{
			0.3,
			0.3,
		},
	},
	{
		30,
		{
			0.5,
			0.1,
		},
	},
}
local killshot_p1_m2_scale = {
	{
		1,
		{
			2,
			0.07,
		},
	},
	{
		4,
		{
			0.2,
			0.05,
		},
	},
	{
		15,
		{
			0.1,
			0.04,
		},
	},
	{
		30,
		{
			0.06,
			0.005,
		},
	},
}
local killshot_p1_m2_random_scale = {
	{
		1,
		{
			0.1,
			0.1,
		},
	},
	{
		3,
		{
			0.2,
			0.24,
		},
	},
	{
		6,
		{
			0.3,
			0.36,
		},
	},
	{
		10,
		{
			0.35,
			0.4,
		},
	},
	{
		20,
		{
			0.25,
			0.3,
		},
	},
	{
		30,
		{
			0.15,
			0.2,
		},
	},
}
local spraynpray_scale = {
	{
		1,
		{
			1,
			0,
		},
	},
	{
		50,
		{
			0.25,
			0,
		},
	},
}
local spraynpray_scale_p2_m2 = {
	{
		1,
		{
			1,
			0,
		},
	},
	{
		5,
		{
			0.95,
			0,
		},
	},
	{
		50,
		{
			0.25,
			0,
		},
	},
}
local spraynpray_scale_p2_m3 = {
	{
		1,
		{
			0.5,
			0,
		},
	},
	{
		3,
		{
			0.85,
			0,
		},
	},
	{
		15,
		{
			0.2,
			0,
		},
	},
	{
		50,
		{
			0.1,
			0,
		},
	},
}
local spraynpray_braced_random_scale = {
	{
		1,
		{
			0.05,
			0.1,
		},
	},
	{
		4,
		{
			0.25,
			0.4,
		},
	},
	{
		8,
		{
			0.4,
			0.5,
		},
	},
	{
		12,
		{
			0.45,
			0.4,
		},
	},
	{
		16,
		{
			0.5,
			0.3,
		},
	},
	{
		20,
		{
			0.4,
			0.3,
		},
	},
	{
		24,
		{
			0.3,
			0.25,
		},
	},
	{
		28,
		{
			0.2,
			0.2,
		},
	},
	{
		32,
		{
			0.15,
			0.1,
		},
	},
	{
		36,
		{
			0.15,
			0.05,
		},
	},
	{
		50,
		{
			0.1,
			0.02,
		},
	},
}
local spraynpray_random_scale = {
	{
		1,
		{
			0.05,
			0.1,
		},
	},
	{
		4,
		{
			0.35,
			0.4,
		},
	},
	{
		8,
		{
			0.5,
			0.6,
		},
	},
	{
		12,
		{
			0.55,
			0.7,
		},
	},
	{
		16,
		{
			0.5,
			0.75,
		},
	},
	{
		20,
		{
			0.4,
			0.8,
		},
	},
	{
		24,
		{
			0.3,
			0.8,
		},
	},
	{
		28,
		{
			0.2,
			0.8,
		},
	},
	{
		32,
		{
			0.15,
			0.8,
		},
	},
	{
		36,
		{
			0.15,
			0.75,
		},
	},
	{
		50,
		{
			0.2,
			0.7,
		},
	},
}
local burst_scale = {
	{
		1,
		{
			1.5,
			0.25,
		},
	},
	{
		3,
		{
			0.9,
			0.4,
		},
	},
	{
		6,
		{
			0.75,
			0.65,
		},
	},
	{
		12,
		{
			0.75,
			0.55,
		},
	},
	{
		18,
		{
			0.5,
			0.5,
		},
	},
	{
		24,
		{
			0.5,
			0.4,
		},
	},
	{
		30,
		{
			0.5,
			0.375,
		},
	},
	{
		36,
		{
			0.5,
			0.35,
		},
	},
	{
		40,
		{
			0.5,
			0.3,
		},
	},
}
local burst_scale_moving = {
	{
		1,
		{
			2,
			0.25,
		},
	},
	{
		2,
		{
			1.2,
			0.5,
		},
	},
	{
		3,
		{
			0.9,
			0.4,
		},
	},
	{
		12,
		{
			0.75,
			0.55,
		},
	},
	{
		18,
		{
			0.5,
			0.5,
		},
	},
	{
		24,
		{
			0.5,
			0.4,
		},
	},
	{
		30,
		{
			0.5,
			0.375,
		},
	},
	{
		36,
		{
			0.5,
			0.35,
		},
	},
	{
		40,
		{
			0.5,
			0.3,
		},
	},
}
local burst_random_scale = {
	{
		1,
		{
			0.15,
			0,
		},
	},
	{
		2,
		{
			0.3,
			0.1,
		},
	},
	{
		6,
		{
			0.4,
			0.325,
		},
	},
	{
		12,
		{
			0.5,
			0.4,
		},
	},
	{
		18,
		{
			0.55,
			0.425,
		},
	},
	{
		24,
		{
			0.6,
			0.45,
		},
	},
	{
		30,
		{
			1,
			0.5,
		},
	},
	{
		36,
		{
			1.2,
			0.5,
		},
	},
	{
		40,
		{
			1.4,
			0.5,
		},
	},
}
local singleshot_scale = {
	{
		1,
		{
			0.5,
			1,
		},
	},
	{
		2,
		{
			0.9,
			1,
		},
	},
	{
		3,
		{
			0.75,
			1,
		},
	},
	{
		6,
		{
			0.5,
			1,
		},
	},
}
local singleshot_random_scale = {
	{
		1,
		{
			0.2,
			0.05,
		},
	},
	{
		2,
		{
			0.4,
			0.5,
		},
	},
	{
		3,
		{
			1,
			1,
		},
	},
	{
		4,
		{
			1.1,
			1.15,
		},
	},
	{
		5,
		{
			2,
			1.25,
		},
	},
	{
		6,
		{
			3,
			1.5,
		},
	},
}
local singleshot_scale_new = {
	{
		1,
		{
			4.7,
			0.25,
		},
	},
	{
		2,
		{
			4.9,
			0.25,
		},
	},
	{
		3,
		{
			4.75,
			0.35,
		},
	},
	{
		4,
		{
			4.1,
			0.15,
		},
	},
	{
		5,
		{
			4,
			0.25,
		},
	},
	{
		6,
		{
			4.5,
			0.45,
		},
	},
}
local singleshot_random_scale_new = {
	{
		1,
		{
			1.1,
			0.05,
		},
	},
	{
		2,
		{
			1.4,
			0.3,
		},
	},
	{
		3,
		{
			1,
			0.2,
		},
	},
	{
		4,
		{
			1.1,
			0.15,
		},
	},
	{
		5,
		{
			1,
			0.15,
		},
	},
	{
		6,
		{
			1,
			0.35,
		},
	},
}
local burst_scale_new = {
	{
		1,
		{
			4.7,
			0.25,
		},
	},
	{
		2,
		{
			4.9,
			0.25,
		},
	},
	{
		3,
		{
			4.75,
			0.35,
		},
	},
	{
		4,
		{
			4.1,
			0.15,
		},
	},
	{
		5,
		{
			4,
			0.25,
		},
	},
	{
		6,
		{
			4.5,
			0.45,
		},
	},
}
local burst_random_scale_new = {
	{
		1,
		{
			1.1,
			0.05,
		},
	},
	{
		2,
		{
			1.4,
			0.3,
		},
	},
	{
		3,
		{
			1,
			0.2,
		},
	},
	{
		4,
		{
			1.1,
			0.15,
		},
	},
	{
		5,
		{
			1,
			0.15,
		},
	},
	{
		6,
		{
			1,
			0.35,
		},
	},
}
local triple_burst_scale_new = {
	{
		1,
		{
			4.7,
			0.25,
		},
	},
	{
		2,
		{
			4.9,
			0.25,
		},
	},
	{
		3,
		{
			4.75,
			0.35,
		},
	},
	{
		4,
		{
			4.1,
			0.15,
		},
	},
	{
		5,
		{
			4,
			0.25,
		},
	},
	{
		6,
		{
			4.5,
			0.45,
		},
	},
}
local triple_burst_random_scale_new = {
	{
		1,
		{
			1.1,
			0.05,
		},
	},
	{
		2,
		{
			1.4,
			0.3,
		},
	},
	{
		3,
		{
			1,
			0.2,
		},
	},
	{
		4,
		{
			1.1,
			0.15,
		},
	},
	{
		5,
		{
			1,
			0.15,
		},
	},
	{
		6,
		{
			1,
			0.35,
		},
	},
}
local lerp_distance = 0.75
local assault_offset_range = generate_offset_range(30, 0.015, 0, 0.95, create_scale(assault_scale))
local assault_random_range = generate_offset_range(30, 0.01, 0.02, 0.95, create_scale(assault_random_scale))
local killshot_p1_m2_offset_range = generate_offset_range(20, 0.125, 0, 0.5, create_scale(killshot_p1_m2_scale))
local killshot_p1_m2_random_range = generate_offset_range(30, 0.025, 0.065, 0.75, create_scale(killshot_p1_m2_random_scale))
local killshot_offset_range = generate_offset_range(30, 0.11, 0, lerp_distance, create_scale(killshot_scale))
local killshot_random_range = generate_offset_range(30, 0.04, 0.05, 0.75, create_scale(killshot_random_scale))
local spraynpray_offset_range = generate_offset_range(50, 0.01, 0, 0.95, create_scale(spraynpray_scale))
local spraynpray_hip_offset_range = generate_offset_range(50, 0.02, 0, 0.95, create_scale(spraynpray_scale))
local spraynpray_random_range = generate_offset_range(50, 0.009, 0.04, 0.95, create_scale(spraynpray_random_scale))
local spraynpray_offset_range_p2_m2 = generate_offset_range(50, 0.0075, 0, 0.95, create_scale(spraynpray_scale_p2_m2))
local spraynpray_random_range_p2_m2 = generate_offset_range(50, 0.0075, 0.03, 0.95, create_scale(spraynpray_braced_random_scale))
local spraynpray_offset_range_p2_m3 = generate_offset_range(50, 0.0125, 0, 0.95, create_scale(spraynpray_scale_p2_m3))
local spraynpray_random_range_p2_m3 = generate_offset_range(50, 0.0075, 0.04, 0.95, create_scale(spraynpray_braced_random_scale))
local burst_offset_range = generate_offset_range(9, 0.015, 0, 0.95, create_scale(burst_scale))
local burst_offset_range_moving = generate_offset_range(6, 0.1, 0, 0.95, create_scale(burst_scale_moving))
local burst_random_range = generate_offset_range(9, 0.01, 0.02, 0.95, create_scale(burst_random_scale))
local singleshot_offset_range = generate_offset_range(6, 0.0225, 0, 0.8, create_scale(singleshot_scale))
local singleshot_random_range = generate_offset_range(6, 0.01, 0.02, 0.8, create_scale(singleshot_random_scale))
local singleshot_offset_range_new = generate_offset_range(6, 0.01, 0.02, 0.8, create_scale(singleshot_scale_new))
local singleshot_random_range_new = generate_offset_range(6, 0.01, 0.02, 0.8, create_scale(singleshot_random_scale_new))
local burst_offset_range_new = generate_offset_range(6, 0.01, 0.02, 0.8, create_scale(burst_scale_new))
local burst_random_range_new = generate_offset_range(6, 0.01, 0.02, 0.8, create_scale(burst_random_scale_new))
local triple_burst_random_range_new = generate_offset_range(6, 0.01, 0.02, 0.8, create_scale(triple_burst_random_scale_new))

recoil_templates.default_galvanic_burst = {
	still = {
		camera_recoil_percentage = 0.75,
		decay_grace = 0.1,
		rise_duration = 0.05,
		rise = {
			{
				lerp_basic = 2.5,
				lerp_perfect = 2,
			},
			{
				lerp_basic = 2.35,
				lerp_perfect = 1.88,
			},
			{
				lerp_basic = 2,
				lerp_perfect = 1.6,
			},
			{
				lerp_basic = 1.25,
				lerp_perfect = 1,
			},
			{
				lerp_basic = 0.75,
				lerp_perfect = 0.6,
			},
			{
				lerp_basic = 0.5,
				lerp_perfect = 0.4,
			},
		},
		decay = {
			idle = 4,
			shooting = 1,
		},
		offset = burst_offset_range,
		offset_random_range = burst_random_range,
		offset_limit = {
			pitch = 2,
			yaw = 2,
		},
		new_influence_percent = {
			lerp_basic = 0.5,
			lerp_perfect = 0.25,
		},
		aim_assist = {
			multiplier_function = AIM_ASSIST_MULTIPLIER_FUNCTIONS.unmodified_inverted_unsteadiness,
		},
		visual_recoil_settings = {
			intensity = 4,
			lerp_scalar = 1,
		},
	},
	moving = {
		inherits = {
			"default_galvanic_burst",
			"still",
		},
		new_influence_percent = {
			lerp_basic = 0.55,
			lerp_perfect = 0.3,
		},
	},
	crouch_still = {
		inherits = {
			"default_galvanic_burst",
			"still",
		},
		new_influence_percent = {
			lerp_basic = 0.25,
			lerp_perfect = 0.15,
		},
	},
	crouch_moving = {
		inherits = {
			"default_galvanic_burst",
			"still",
		},
		new_influence_percent = {
			lerp_basic = 0.4,
			lerp_perfect = 0.2,
		},
	},
}
recoil_templates.ads_galvanic_burst = {
	still = {
		camera_recoil_percentage = 0.75,
		decay_grace = 0.01,
		rise_duration = 0.01,
		rise = {
			{
				lerp_basic = 2.5,
				lerp_perfect = 2,
			},
			{
				lerp_basic = 2.35,
				lerp_perfect = 1.88,
			},
			{
				lerp_basic = 2,
				lerp_perfect = 1.6,
			},
			{
				lerp_basic = 1.25,
				lerp_perfect = 1,
			},
			{
				lerp_basic = 0.75,
				lerp_perfect = 0.6,
			},
			{
				lerp_basic = 0.5,
				lerp_perfect = 0.4,
			},
		},
		decay = {
			idle = 1,
			shooting = 1,
		},
		offset = burst_offset_range,
		offset_random_range = burst_random_range,
		offset_limit = {
			pitch = 2,
			yaw = 2,
		},
		new_influence_percent = {
			lerp_basic = 0.4,
			lerp_perfect = 0.1,
		},
		aim_assist = {
			multiplier_function = AIM_ASSIST_MULTIPLIER_FUNCTIONS.unmodified_inverted_unsteadiness,
		},
		visual_recoil_settings = {
			intensity = 1,
			lerp_scalar = 1,
		},
	},
	moving = {
		inherits = {
			"ads_galvanic_burst",
			"still",
		},
		new_influence_percent = {
			lerp_basic = 0.5,
			lerp_perfect = 0.2,
		},
		offset = burst_offset_range_moving,
	},
	crouch_still = {
		inherits = {
			"ads_galvanic_burst",
			"still",
		},
		new_influence_percent = {
			lerp_basic = 0.1,
			lerp_perfect = 0.005,
		},
	},
	crouch_moving = {
		inherits = {
			"ads_galvanic_burst",
			"still",
		},
		new_influence_percent = {
			lerp_basic = 0.4,
			lerp_perfect = 0.2,
		},
	},
}
recoil_templates.galvanic_rifle_p1_m1_recoil_hip = {
	still = {
		camera_recoil_percentage = 0.75,
		decay_grace = 0.1,
		rise_duration = 0.1,
		rise = {
			3.5,
			3.3,
			3.2,
			3.3,
			3.2,
			3.3,
			3.2,
		},
		decay = {
			idle = 2,
			shooting = 2.45,
		},
		offset = singleshot_offset_range_new,
		offset_random_range = singleshot_random_range_new,
		offset_limit = {
			pitch = 4,
			yaw = 4,
		},
		new_influence_percent = {
			lerp_basic = 0.5,
			lerp_perfect = 0.25,
		},
		aim_assist = {
			multiplier_function = AIM_ASSIST_MULTIPLIER_FUNCTIONS.unmodified_inverted_unsteadiness,
		},
		visual_recoil_settings = {
			intensity = 6,
			lerp_scalar = 0.5,
			yaw_intensity = 6,
		},
	},
	moving = {
		inherits = {
			"galvanic_rifle_p1_m1_recoil_hip",
			"still",
		},
		new_influence_percent = {
			lerp_basic = 0.65,
			lerp_perfect = 0.4,
		},
	},
	crouch_still = {
		inherits = {
			"galvanic_rifle_p1_m1_recoil_hip",
			"still",
		},
		new_influence_percent = {
			lerp_basic = 0.25,
			lerp_perfect = 0.15,
		},
	},
	crouch_moving = {
		inherits = {
			"galvanic_rifle_p1_m1_recoil_hip",
			"still",
		},
		new_influence_percent = {
			lerp_basic = 0.4,
			lerp_perfect = 0.2,
		},
	},
}
recoil_templates.galvanic_rifle_p1_m1_recoil_ads = {
	still = {
		camera_recoil_percentage = 0.4,
		decay_grace = 0.1,
		rise_duration = 0.05,
		rise = {
			0.9,
			0.7,
			0.8,
			0.7,
			0.8,
			0.7,
			0.6,
			0.8,
		},
		decay = {
			idle = 2,
			shooting = 0.95,
		},
		offset = singleshot_offset_range_new,
		offset_random_range = singleshot_offset_range_new,
		offset_limit = {
			pitch = 2,
			yaw = 2,
		},
		new_influence_percent = {
			lerp_basic = 0.5,
			lerp_perfect = 0.25,
		},
		aim_assist = {
			multiplier_function = AIM_ASSIST_MULTIPLIER_FUNCTIONS.unmodified_inverted_unsteadiness,
		},
		visual_recoil_settings = {
			intensity = 4,
			lerp_scalar = 1,
			yaw_intensity = 6,
		},
	},
	moving = {
		inherits = {
			"galvanic_rifle_p1_m1_recoil_ads",
			"still",
		},
		new_influence_percent = {
			lerp_basic = 0.55,
			lerp_perfect = 0.3,
		},
	},
	crouch_still = {
		inherits = {
			"galvanic_rifle_p1_m1_recoil_ads",
			"still",
		},
		new_influence_percent = {
			lerp_basic = 0.15,
			lerp_perfect = 0.05,
		},
	},
	crouch_moving = {
		inherits = {
			"galvanic_rifle_p1_m1_recoil_ads",
			"still",
		},
		new_influence_percent = {
			lerp_basic = 0.4,
			lerp_perfect = 0.2,
		},
	},
}
recoil_templates.ads_galvanic_single_shot = {
	still = {
		camera_recoil_percentage = 0.75,
		decay_grace = 0.12,
		rise_duration = 0.075,
		rise = {
			1.3,
			1.4,
			1.3,
			1.4,
			1.6,
		},
		decay = {
			idle = 2,
			shooting = 0.15,
		},
		offset = singleshot_offset_range_new,
		offset_random_range = singleshot_random_range_new,
		offset_limit = {
			pitch = 1.5,
			yaw = 1.5,
		},
		new_influence_percent = {
			lerp_basic = 0.45,
			lerp_perfect = 0.2,
		},
		aim_assist = {
			multiplier_function = AIM_ASSIST_MULTIPLIER_FUNCTIONS.unmodified_inverted_unsteadiness,
		},
		visual_recoil_settings = {
			intensity = 6,
			lerp_scalar = 0.5,
			yaw_intensity = 6,
		},
	},
	moving = {
		inherits = {
			"ads_galvanic_single_shot",
			"still",
		},
		new_influence_percent = {
			lerp_basic = 0.55,
			lerp_perfect = 0.3,
		},
	},
	crouch_still = {
		inherits = {
			"ads_galvanic_single_shot",
			"still",
		},
		new_influence_percent = {
			lerp_basic = 0.1,
			lerp_perfect = 0.05,
		},
	},
	crouch_moving = {
		inherits = {
			"ads_galvanic_single_shot",
			"still",
		},
		new_influence_percent = {
			lerp_basic = 0.4,
			lerp_perfect = 0.2,
		},
	},
}
recoil_templates.ads_galvanic_double_shot = {
	still = {
		camera_recoil_percentage = 1,
		decay_grace = 0.1,
		rise_duration = 0.025,
		rise = {
			{
				lerp_basic = 0.5,
				lerp_perfect = 0.4,
			},
			{
				lerp_basic = 0.6,
				lerp_perfect = 0.6,
			},
			{
				lerp_basic = 0.5,
				lerp_perfect = 0.4,
			},
			{
				lerp_basic = 0.5,
				lerp_perfect = 0.4,
			},
			{
				lerp_basic = 0.4,
				lerp_perfect = 0.4,
			},
			{
				lerp_basic = 0.6,
				lerp_perfect = 0.6,
			},
		},
		decay = {
			idle = 1.5,
			shooting = 1.2,
		},
		offset = burst_offset_range_new,
		offset_random_range = burst_random_range_new,
		offset_limit = {
			pitch = 2.4,
			yaw = 2.4,
		},
		new_influence_percent = {
			lerp_basic = 0.4,
			lerp_perfect = 0.1,
		},
		aim_assist = {
			multiplier_function = AIM_ASSIST_MULTIPLIER_FUNCTIONS.unmodified_inverted_unsteadiness,
		},
		visual_recoil_settings = {
			intensity = 1,
			lerp_scalar = 0.5,
			yaw_intensity = 1,
		},
	},
	moving = {
		inherits = {
			"ads_galvanic_double_shot",
			"still",
		},
		new_influence_percent = {
			lerp_basic = 0.55,
			lerp_perfect = 0.3,
		},
	},
	crouch_still = {
		inherits = {
			"ads_galvanic_double_shot",
			"still",
		},
		new_influence_percent = {
			lerp_basic = 0.2,
			lerp_perfect = 0.05,
		},
	},
	crouch_moving = {
		inherits = {
			"ads_galvanic_double_shot",
			"still",
		},
		new_influence_percent = {
			lerp_basic = 0.35,
			lerp_perfect = 0.2,
		},
	},
}
recoil_templates.ads_galvanic_triple_shot = {
	still = {
		camera_recoil_percentage = 0.75,
		decay_grace = 0.01,
		rise_duration = 0.01,
		rise = {
			0.3,
			0.4,
			0.4,
			0.3,
			0.4,
			0.4,
		},
		decay = {
			idle = 1,
			shooting = 1,
		},
		offset = burst_offset_range_new,
		offset_random_range = triple_burst_random_range_new,
		offset_limit = {
			pitch = 1.5,
			yaw = 1,
		},
		new_influence_percent = {
			lerp_basic = 0.4,
			lerp_perfect = 0.1,
		},
		aim_assist = {
			multiplier_function = AIM_ASSIST_MULTIPLIER_FUNCTIONS.unmodified_inverted_unsteadiness,
		},
		visual_recoil_settings = {
			intensity = 1,
			lerp_scalar = 1,
		},
	},
	moving = {
		inherits = {
			"ads_galvanic_triple_shot",
			"still",
		},
		new_influence_percent = {
			lerp_basic = 0.55,
			lerp_perfect = 0.3,
		},
	},
	crouch_still = {
		inherits = {
			"ads_galvanic_triple_shot",
			"still",
		},
		new_influence_percent = {
			lerp_basic = 0.2,
			lerp_perfect = 0.05,
		},
	},
	crouch_moving = {
		inherits = {
			"ads_galvanic_triple_shot",
			"still",
		},
		new_influence_percent = {
			lerp_basic = 0.45,
			lerp_perfect = 0.2,
		},
	},
}

return {
	base_templates = recoil_templates,
	overrides = overrides,
}
