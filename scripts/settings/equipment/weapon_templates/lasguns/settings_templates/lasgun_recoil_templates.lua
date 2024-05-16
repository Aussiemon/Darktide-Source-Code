-- chunkname: @scripts/settings/equipment/weapon_templates/lasguns/settings_templates/lasgun_recoil_templates.lua

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
			0,
		},
	},
	{
		5,
		{
			0.75,
			0,
		},
	},
	{
		10,
		{
			1,
			0,
		},
	},
	{
		20,
		{
			0.5,
			0,
		},
	},
	{
		30,
		{
			0.25,
			0,
		},
	},
	{
		90,
		{
			0.25,
			0,
		},
	},
}
local assault_p3_m1_random_scale = {
	{
		1,
		{
			0.25,
			0.25,
		},
	},
	{
		5,
		{
			0.75,
			0.75,
		},
	},
	{
		10,
		{
			1,
			1,
		},
	},
	{
		20,
		{
			0.75,
			0.5,
		},
	},
	{
		30,
		{
			0.85,
			0.25,
		},
	},
	{
		90,
		{
			0.25,
			0.25,
		},
	},
}
local killshot_p3_m1_scale = {
	{
		1,
		{
			0.1,
			0,
		},
	},
	{
		5,
		{
			0.25,
			0,
		},
	},
	{
		10,
		{
			0.75,
			0,
		},
	},
	{
		20,
		{
			1,
			0,
		},
	},
	{
		30,
		{
			0.5,
			0,
		},
	},
	{
		90,
		{
			0.25,
			0,
		},
	},
}
local killshot_p3_m1_random_scale = {
	{
		1,
		{
			0.1,
			0.25,
		},
	},
	{
		5,
		{
			0.25,
			0.75,
		},
	},
	{
		10,
		{
			0.75,
			1,
		},
	},
	{
		20,
		{
			1,
			0.5,
		},
	},
	{
		30,
		{
			0.5,
			0.25,
		},
	},
	{
		90,
		{
			0.25,
			0.25,
		},
	},
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
			0.2,
		},
		decay = {
			idle = 2,
			shooting = 0,
		},
		offset_range = {
			{
				pitch = {
					pitch_default * 0.6,
					pitch_default * 0.6,
				},
				yaw = {
					0,
					0,
				},
			},
			{
				pitch = {
					pitch_default * 0.7,
					pitch_default * 0.7,
				},
				yaw = {
					0,
					0,
				},
			},
			{
				pitch = {
					pitch_default,
					pitch_default,
				},
				yaw = {
					0,
					0,
				},
			},
			{
				pitch = {
					pitch_default * 0.9,
					pitch_default * 1.1,
				},
				yaw = {
					-0.01,
					0.01,
				},
			},
			{
				pitch = {
					pitch_default * 0.8,
					pitch_default * 1.2,
				},
				yaw = {
					-0.02,
					0.02,
				},
			},
			{
				pitch = {
					pitch_default * 0.7,
					pitch_default * 1.2,
				},
				yaw = {
					-0.03,
					0.03,
				},
			},
			{
				pitch = {
					pitch_default * 0.6,
					pitch_default * 1.3,
				},
				yaw = {
					-0.04,
					0.04,
				},
			},
			{
				pitch = {
					pitch_default * 0.5,
					pitch_default * 1.5,
				},
				yaw = {
					-0.05,
					0.05,
				},
			},
		},
		hit_offset_multiplier = {
			afro_hit = 1.05,
			damage_hit = 1.8,
			fortitude_hit = 1.2,
			grace_hit = 1.1,
		},
		offset_limit = {
			pitch = 0.4,
			profile = "linear",
			yaw = 0.4,
		},
		visual_recoil_settings = {
			intensity = 4,
			lerp_scalar = 1,
		},
	},
	moving = {
		new_influence_percent = 0.65,
		inherits = {
			"hip_lasgun_assault",
			"still",
		},
	},
	crouch_still = {
		new_influence_percent = 0.4,
		inherits = {
			"hip_lasgun_assault",
			"still",
		},
	},
	crouch_moving = {
		new_influence_percent = 0.45,
		inherits = {
			"hip_lasgun_assault",
			"still",
		},
	},
}
recoil_templates.hip_lasgun_killshot = {
	still = {
		camera_recoil_percentage = 0.25,
		decay_grace = 0.125,
		rise_duration = 0.075,
		rise = {
			{
				lerp_basic = 0.75,
				lerp_perfect = 0.5,
			},
			{
				lerp_basic = 0.5,
				lerp_perfect = 0.2,
			},
			{
				lerp_basic = 0.5,
				lerp_perfect = 0.15,
			},
		},
		decay = {
			idle = 2.25,
			shooting = 0.75,
		},
		offset = {
			{
				pitch = {
					lerp_basic = 0.0625,
					lerp_perfect = 0.025,
				},
				yaw = {
					lerp_basic = 0,
					lerp_perfect = 0,
				},
			},
			{
				pitch = {
					lerp_basic = 0.05,
					lerp_perfect = 0.0375,
				},
				yaw = {
					lerp_basic = 0,
					lerp_perfect = 0,
				},
			},
			{
				pitch = {
					lerp_basic = 0.0375,
					lerp_perfect = 0.005,
				},
				yaw = {
					lerp_basic = 0,
					lerp_perfect = 0,
				},
			},
			{
				pitch = {
					lerp_basic = 0.0325,
					lerp_perfect = 0.005,
				},
				yaw = {
					lerp_basic = 0,
					lerp_perfect = 0,
				},
			},
			{
				pitch = {
					lerp_basic = 0.025,
					lerp_perfect = 0.005,
				},
				yaw = {
					lerp_basic = 0,
					lerp_perfect = 0,
				},
			},
		},
		offset_random_range = {
			{
				pitch = {
					lerp_basic = 0.0005,
					lerp_perfect = 0,
				},
				yaw = {
					lerp_basic = 0.001,
					lerp_perfect = 0,
				},
			},
			{
				pitch = {
					lerp_basic = 0.001,
					lerp_perfect = 0,
				},
				yaw = {
					lerp_basic = 0.001,
					lerp_perfect = 0,
				},
			},
			{
				pitch = {
					lerp_basic = 0.00125,
					lerp_perfect = 0,
				},
				yaw = {
					lerp_basic = 0.001,
					lerp_perfect = 0,
				},
			},
			{
				pitch = {
					lerp_basic = 0.0015,
					lerp_perfect = 0,
				},
				yaw = {
					lerp_basic = 0.0025,
					lerp_perfect = 0,
				},
			},
			{
				pitch = {
					lerp_basic = 0.0015,
					lerp_perfect = 0,
				},
				yaw = {
					lerp_basic = 0.005,
					lerp_perfect = 0,
				},
			},
			{
				pitch = {
					lerp_basic = 0.0015,
					lerp_perfect = 0,
				},
				yaw = {
					lerp_basic = 0.015,
					lerp_perfect = 0,
				},
			},
			{
				pitch = {
					lerp_basic = 0.0015,
					lerp_perfect = 0,
				},
				yaw = {
					lerp_basic = 0.025,
					lerp_perfect = 0,
				},
			},
		},
		offset_limit = {
			pitch = 0.25,
			yaw = 0.25,
		},
		visual_recoil_settings = {
			intensity = 25,
			lerp_scalar = 0.2,
		},
		new_influence_percent = {
			lerp_basic = 0.1,
			lerp_perfect = 0.025,
		},
	},
	moving = {
		inherits = {
			"hip_lasgun_killshot",
			"still",
		},
		new_influence_percent = {
			lerp_basic = 0.12,
			lerp_perfect = 0.06,
		},
	},
	crouch_still = {
		inherits = {
			"hip_lasgun_killshot",
			"still",
		},
		new_influence_percent = {
			lerp_basic = 0.05,
			lerp_perfect = 0.01,
		},
	},
	crouch_moving = {
		inherits = {
			"hip_lasgun_killshot",
			"still",
		},
		new_influence_percent = {
			lerp_basic = 0.12,
			lerp_perfect = 0.06,
		},
	},
}
recoil_templates.hip_lasgun_p2_killshot = {
	still = {
		camera_recoil_percentage = 0.25,
		decay_grace = 0.125,
		rise_duration = 0.075,
		rise = {
			{
				lerp_basic = 0.75,
				lerp_perfect = 0.5,
			},
			{
				lerp_basic = 0.5,
				lerp_perfect = 0.2,
			},
			{
				lerp_basic = 0.5,
				lerp_perfect = 0.15,
			},
		},
		decay = {
			idle = 2.25,
			shooting = 0.75,
		},
		offset = {
			{
				pitch = {
					lerp_basic = 0.09375,
					lerp_perfect = 0.037500000000000006,
				},
				yaw = {
					lerp_basic = 0,
					lerp_perfect = 0,
				},
			},
			{
				pitch = {
					lerp_basic = 0.07500000000000001,
					lerp_perfect = 0.056249999999999994,
				},
				yaw = {
					lerp_basic = 0,
					lerp_perfect = 0,
				},
			},
			{
				pitch = {
					lerp_basic = 0.056249999999999994,
					lerp_perfect = 0.07500000000000001,
				},
				yaw = {
					lerp_basic = 0,
					lerp_perfect = 0,
				},
			},
			{
				pitch = {
					lerp_basic = 0.04875,
					lerp_perfect = 0.07500000000000001,
				},
				yaw = {
					lerp_basic = 0,
					lerp_perfect = 0,
				},
			},
			{
				pitch = {
					lerp_basic = 0.037500000000000006,
					lerp_perfect = 0.07500000000000001,
				},
				yaw = {
					lerp_basic = 0,
					lerp_perfect = 0,
				},
			},
		},
		offset_random_range = {
			{
				pitch = {
					lerp_basic = 0.005,
					lerp_perfect = 0,
				},
				yaw = {
					lerp_basic = 0.01,
					lerp_perfect = 0,
				},
			},
			{
				pitch = {
					lerp_basic = 0.006,
					lerp_perfect = 0,
				},
				yaw = {
					lerp_basic = 0.02,
					lerp_perfect = 0,
				},
			},
			{
				pitch = {
					lerp_basic = 0.00625,
					lerp_perfect = 0,
				},
				yaw = {
					lerp_basic = 0.03,
					lerp_perfect = 0,
				},
			},
			{
				pitch = {
					lerp_basic = 0.0065,
					lerp_perfect = 0,
				},
				yaw = {
					lerp_basic = 0.045,
					lerp_perfect = 0,
				},
			},
			{
				pitch = {
					lerp_basic = 0.0065,
					lerp_perfect = 0,
				},
				yaw = {
					lerp_basic = 0.055,
					lerp_perfect = 0,
				},
			},
			{
				pitch = {
					lerp_basic = 0.0065,
					lerp_perfect = 0,
				},
				yaw = {
					lerp_basic = 0.065,
					lerp_perfect = 0,
				},
			},
			{
				pitch = {
					lerp_basic = 0.0065,
					lerp_perfect = 0,
				},
				yaw = {
					lerp_basic = 0.075,
					lerp_perfect = 0,
				},
			},
		},
		offset_limit = {
			pitch = 0.25,
			yaw = 0.25,
		},
		visual_recoil_settings = {
			intensity = 25,
			lerp_scalar = 0.2,
		},
		new_influence_percent = {
			lerp_basic = 0.2,
			lerp_perfect = 0.05,
		},
	},
	moving = {
		inherits = {
			"hip_lasgun_p2_killshot",
			"still",
		},
		new_influence_percent = {
			lerp_basic = 0.12,
			lerp_perfect = 0.06,
		},
	},
	crouch_still = {
		inherits = {
			"hip_lasgun_p2_killshot",
			"still",
		},
		new_influence_percent = {
			lerp_basic = 0.1,
			lerp_perfect = 0.05,
		},
	},
	crouch_moving = {
		inherits = {
			"hip_lasgun_p2_killshot",
			"still",
		},
		new_influence_percent = {
			lerp_basic = 0.125,
			lerp_perfect = 0.075,
		},
	},
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
				lerp_basic = 0.5,
				lerp_perfect = 0.1,
			},
			{
				lerp_basic = 0.4,
				lerp_perfect = 0.2,
			},
			{
				lerp_basic = 0.35,
				lerp_perfect = 0.15,
			},
			{
				lerp_basic = 0.5,
				lerp_perfect = 0.125,
			},
			{
				lerp_basic = 0.5,
				lerp_perfect = 0.125,
			},
			{
				lerp_basic = 0.5,
				lerp_perfect = 0.125,
			},
			{
				lerp_basic = 0.5,
				lerp_perfect = 0.125,
			},
			{
				lerp_basic = 0.5,
				lerp_perfect = 0.125,
			},
		},
		decay = {
			shooting = {
				lerp_basic = 0.25,
				lerp_perfect = 1,
			},
			idle = {
				lerp_basic = 0.5,
				lerp_perfect = 2,
			},
		},
		offset = {
			{
				pitch = {
					lerp_basic = 0.15,
					lerp_perfect = 0.06,
				},
				yaw = {
					lerp_basic = 0,
					lerp_perfect = 0,
				},
			},
			{
				pitch = {
					lerp_basic = 0.125,
					lerp_perfect = 0.055,
				},
				yaw = {
					lerp_basic = 0,
					lerp_perfect = 0,
				},
			},
			{
				pitch = {
					lerp_basic = 0.1,
					lerp_perfect = 0.05,
				},
				yaw = {
					lerp_basic = 0.01,
					lerp_perfect = 0,
				},
			},
			{
				pitch = {
					lerp_basic = 0.05,
					lerp_perfect = 0.02,
				},
				yaw = {
					lerp_basic = 0.011,
					lerp_perfect = 0,
				},
			},
			{
				pitch = {
					lerp_basic = 0.04,
					lerp_perfect = 0.02,
				},
				yaw = {
					lerp_basic = -0.009,
					lerp_perfect = 0,
				},
			},
			{
				pitch = {
					lerp_basic = 0.038,
					lerp_perfect = 0.018,
				},
				yaw = {
					lerp_basic = -0.005,
					lerp_perfect = 0,
				},
			},
			{
				pitch = {
					lerp_basic = 0.036,
					lerp_perfect = 0.016,
				},
				yaw = {
					lerp_basic = -0.007,
					lerp_perfect = 0,
				},
			},
			{
				pitch = {
					lerp_basic = 0.034,
					lerp_perfect = 0.014,
				},
				yaw = {
					lerp_basic = 0.005,
					lerp_perfect = 0,
				},
			},
			{
				pitch = {
					lerp_basic = 0.032,
					lerp_perfect = 0.012,
				},
				yaw = {
					lerp_basic = 0,
					lerp_perfect = 0,
				},
			},
			{
				pitch = {
					lerp_basic = 0.03,
					lerp_perfect = 0.01,
				},
				yaw = {
					lerp_basic = 0,
					lerp_perfect = 0,
				},
			},
		},
		offset_random_range = {
			{
				pitch = {
					lerp_basic = 0.02,
					lerp_perfect = 0,
				},
				yaw = {
					lerp_basic = 0.05,
					lerp_perfect = 0,
				},
			},
			{
				pitch = {
					lerp_basic = 0,
					lerp_perfect = 0,
				},
				yaw = {
					lerp_basic = 0.075,
					lerp_perfect = 0,
				},
			},
			{
				pitch = {
					lerp_basic = 0.01,
					lerp_perfect = 0,
				},
				yaw = {
					lerp_basic = 0.005,
					lerp_perfect = 0,
				},
			},
			{
				pitch = {
					lerp_basic = 0.011,
					lerp_perfect = 0,
				},
				yaw = {
					lerp_basic = 0.0075,
					lerp_perfect = 0,
				},
			},
			{
				pitch = {
					lerp_basic = 0.012,
					lerp_perfect = 0.005,
				},
				yaw = {
					lerp_basic = 0.01,
					lerp_perfect = 0.001,
				},
			},
			{
				pitch = {
					lerp_basic = 0.013,
					lerp_perfect = 0.0065,
				},
				yaw = {
					lerp_basic = 0.0125,
					lerp_perfect = 0.0025,
				},
			},
			{
				pitch = {
					lerp_basic = 0.015,
					lerp_perfect = 0.0075,
				},
				yaw = {
					lerp_basic = 0.015,
					lerp_perfect = 0.005,
				},
			},
			{
				pitch = {
					lerp_basic = 0.0175,
					lerp_perfect = 0.01,
				},
				yaw = {
					lerp_basic = 0.0175,
					lerp_perfect = 0.008,
				},
			},
			{
				pitch = {
					lerp_basic = 0.02,
					lerp_perfect = 0.0125,
				},
				yaw = {
					lerp_basic = 0.02,
					lerp_perfect = 0.009,
				},
			},
			{
				pitch = {
					lerp_basic = 0.025,
					lerp_perfect = 0.015,
				},
				yaw = {
					lerp_basic = 0.0225,
					lerp_perfect = 0.01,
				},
			},
			{
				pitch = {
					lerp_basic = 0.025,
					lerp_perfect = 0.015,
				},
				yaw = {
					lerp_basic = 0.025,
					lerp_perfect = 0.01,
				},
			},
		},
		offset_limit = {
			pitch = 1,
			yaw = 0.5,
		},
		new_influence_percent = {
			lerp_basic = 0.2,
			lerp_perfect = 0.2,
		},
		visual_recoil_settings = {
			intensity = 3,
			lerp_scalar = 1,
			yaw_intensity = 3,
		},
	},
	moving = {
		inherits = {
			"default_lasgun_killshot",
			"still",
		},
		new_influence_percent = {
			lerp_basic = 0.25,
			lerp_perfect = 0.075,
		},
	},
	crouch_still = {
		inherits = {
			"default_lasgun_killshot",
			"still",
		},
	},
	crouch_moving = {
		inherits = {
			"default_lasgun_killshot",
			"still",
		},
	},
}
recoil_templates.lasgun_p1_m1_ads_killshot = {
	still = {
		camera_recoil_percentage = 0.01,
		decay_grace = 0.15,
		rise_duration = 0.01,
		rise = {
			{
				lerp_basic = 0.5,
				lerp_perfect = 0.35,
			},
			{
				lerp_basic = 0.4,
				lerp_perfect = 0.25,
			},
			{
				lerp_basic = 0.35,
				lerp_perfect = 0.15,
			},
			{
				lerp_basic = 0.5,
				lerp_perfect = 0.125,
			},
			{
				lerp_basic = 0.5,
				lerp_perfect = 0.125,
			},
			{
				lerp_basic = 0.5,
				lerp_perfect = 0.125,
			},
			{
				lerp_basic = 0.5,
				lerp_perfect = 0.125,
			},
			{
				lerp_basic = 0.5,
				lerp_perfect = 0.125,
			},
		},
		decay = {
			shooting = {
				lerp_basic = 0.25,
				lerp_perfect = 1,
			},
			idle = {
				lerp_basic = 1,
				lerp_perfect = 3,
			},
		},
		offset = {
			{
				pitch = {
					lerp_basic = 0.025,
					lerp_perfect = 0.015,
				},
				yaw = {
					lerp_basic = 0.025,
					lerp_perfect = 0,
				},
			},
			{
				pitch = {
					lerp_basic = 0.035,
					lerp_perfect = 0.0125,
				},
				yaw = {
					lerp_basic = 0,
					lerp_perfect = 0,
				},
			},
			{
				pitch = {
					lerp_basic = 0.05,
					lerp_perfect = 0.02,
				},
				yaw = {
					lerp_basic = 0.011,
					lerp_perfect = 0,
				},
			},
			{
				pitch = {
					lerp_basic = 0.04,
					lerp_perfect = 0.02,
				},
				yaw = {
					lerp_basic = -0.009,
					lerp_perfect = 0,
				},
			},
			{
				pitch = {
					lerp_basic = 0.038,
					lerp_perfect = 0.018,
				},
				yaw = {
					lerp_basic = -0.005,
					lerp_perfect = 0,
				},
			},
			{
				pitch = {
					lerp_basic = 0.036,
					lerp_perfect = 0.016,
				},
				yaw = {
					lerp_basic = -0.007,
					lerp_perfect = 0,
				},
			},
			{
				pitch = {
					lerp_basic = 0.034,
					lerp_perfect = 0.014,
				},
				yaw = {
					lerp_basic = 0.005,
					lerp_perfect = 0,
				},
			},
			{
				pitch = {
					lerp_basic = 0.032,
					lerp_perfect = 0.012,
				},
				yaw = {
					lerp_basic = 0,
					lerp_perfect = 0,
				},
			},
			{
				pitch = {
					lerp_basic = 0.03,
					lerp_perfect = 0.01,
				},
				yaw = {
					lerp_basic = 0,
					lerp_perfect = 0,
				},
			},
		},
		offset_random_range = {
			{
				pitch = {
					lerp_basic = 0.02,
					lerp_perfect = 0,
				},
				yaw = {
					lerp_basic = 0.015,
					lerp_perfect = 0,
				},
			},
			{
				pitch = {
					lerp_basic = 0.015,
					lerp_perfect = 0,
				},
				yaw = {
					lerp_basic = 0.0125,
					lerp_perfect = 0,
				},
			},
			{
				pitch = {
					lerp_basic = 0.01,
					lerp_perfect = 0,
				},
				yaw = {
					lerp_basic = 0.0075,
					lerp_perfect = 0,
				},
			},
			{
				pitch = {
					lerp_basic = 0.011,
					lerp_perfect = 0,
				},
				yaw = {
					lerp_basic = 0.0075,
					lerp_perfect = 0,
				},
			},
			{
				pitch = {
					lerp_basic = 0.012,
					lerp_perfect = 0.005,
				},
				yaw = {
					lerp_basic = 0.01,
					lerp_perfect = 0.001,
				},
			},
			{
				pitch = {
					lerp_basic = 0.013,
					lerp_perfect = 0.0065,
				},
				yaw = {
					lerp_basic = 0.0125,
					lerp_perfect = 0.0025,
				},
			},
			{
				pitch = {
					lerp_basic = 0.015,
					lerp_perfect = 0.0075,
				},
				yaw = {
					lerp_basic = 0.015,
					lerp_perfect = 0.005,
				},
			},
			{
				pitch = {
					lerp_basic = 0.0175,
					lerp_perfect = 0.01,
				},
				yaw = {
					lerp_basic = 0.0175,
					lerp_perfect = 0.008,
				},
			},
			{
				pitch = {
					lerp_basic = 0.02,
					lerp_perfect = 0.0125,
				},
				yaw = {
					lerp_basic = 0.02,
					lerp_perfect = 0.009,
				},
			},
			{
				pitch = {
					lerp_basic = 0.025,
					lerp_perfect = 0.015,
				},
				yaw = {
					lerp_basic = 0.0225,
					lerp_perfect = 0.01,
				},
			},
			{
				pitch = {
					lerp_basic = 0.025,
					lerp_perfect = 0.015,
				},
				yaw = {
					lerp_basic = 0.025,
					lerp_perfect = 0.01,
				},
			},
		},
		offset_limit = {
			pitch = 1,
			yaw = 0.5,
		},
		new_influence_percent = {
			lerp_basic = 0.6,
			lerp_perfect = 0.4,
		},
		visual_recoil_settings = {
			intensity = 4.5,
			lerp_scalar = 0.8,
			yaw_intensity = 3.25,
		},
	},
	moving = {
		inherits = {
			"lasgun_p1_m1_ads_killshot",
			"still",
		},
		new_influence_percent = {
			lerp_basic = 0.7,
			lerp_perfect = 0.45,
		},
	},
	crouch_still = {
		inherits = {
			"lasgun_p1_m1_ads_killshot",
			"still",
		},
		new_influence_percent = {
			lerp_basic = 0.5,
			lerp_perfect = 0.35,
		},
	},
	crouch_moving = {
		inherits = {
			"lasgun_p1_m1_ads_killshot",
			"still",
		},
		new_influence_percent = {
			lerp_basic = 0.8,
			lerp_perfect = 0.5,
		},
	},
}
recoil_templates.lasgun_p1_m2_ads_killshot = {
	still = {
		camera_recoil_percentage = 0.01,
		decay_grace = 0.15,
		rise_duration = 0.01,
		rise = {
			{
				lerp_basic = 0.5,
				lerp_perfect = 0.25,
			},
			{
				lerp_basic = 0.4,
				lerp_perfect = 0.2,
			},
			{
				lerp_basic = 0.35,
				lerp_perfect = 0.15,
			},
			{
				lerp_basic = 0.5,
				lerp_perfect = 0.125,
			},
			{
				lerp_basic = 0.5,
				lerp_perfect = 0.125,
			},
			{
				lerp_basic = 0.5,
				lerp_perfect = 0.125,
			},
			{
				lerp_basic = 0.5,
				lerp_perfect = 0.125,
			},
			{
				lerp_basic = 0.5,
				lerp_perfect = 0.125,
			},
		},
		decay = {
			shooting = {
				lerp_basic = 0.25,
				lerp_perfect = 1,
			},
			idle = {
				lerp_basic = 1,
				lerp_perfect = 3,
			},
		},
		offset = {
			{
				pitch = {
					lerp_basic = 0.025,
					lerp_perfect = 0.015,
				},
				yaw = {
					lerp_basic = 0,
					lerp_perfect = 0,
				},
			},
			{
				pitch = {
					lerp_basic = 0.035,
					lerp_perfect = 0.0125,
				},
				yaw = {
					lerp_basic = 0,
					lerp_perfect = 0,
				},
			},
			{
				pitch = {
					lerp_basic = 0.03,
					lerp_perfect = 0.02,
				},
				yaw = {
					lerp_basic = 0.011,
					lerp_perfect = 0,
				},
			},
			{
				pitch = {
					lerp_basic = 0.032,
					lerp_perfect = 0.02,
				},
				yaw = {
					lerp_basic = -0.009,
					lerp_perfect = 0,
				},
			},
			{
				pitch = {
					lerp_basic = 0.034,
					lerp_perfect = 0.018,
				},
				yaw = {
					lerp_basic = -0.005,
					lerp_perfect = 0,
				},
			},
			{
				pitch = {
					lerp_basic = 0.033,
					lerp_perfect = 0.016,
				},
				yaw = {
					lerp_basic = -0.007,
					lerp_perfect = 0,
				},
			},
			{
				pitch = {
					lerp_basic = 0.032,
					lerp_perfect = 0.014,
				},
				yaw = {
					lerp_basic = 0.005,
					lerp_perfect = 0,
				},
			},
			{
				pitch = {
					lerp_basic = 0.031,
					lerp_perfect = 0.012,
				},
				yaw = {
					lerp_basic = 0,
					lerp_perfect = 0,
				},
			},
			{
				pitch = {
					lerp_basic = 0.03,
					lerp_perfect = 0.01,
				},
				yaw = {
					lerp_basic = 0,
					lerp_perfect = 0,
				},
			},
		},
		offset_random_range = {
			{
				pitch = {
					lerp_basic = 0.02,
					lerp_perfect = 0,
				},
				yaw = {
					lerp_basic = 0.015,
					lerp_perfect = 0,
				},
			},
			{
				pitch = {
					lerp_basic = 0.015,
					lerp_perfect = 0,
				},
				yaw = {
					lerp_basic = 0.0125,
					lerp_perfect = 0,
				},
			},
			{
				pitch = {
					lerp_basic = 0.01,
					lerp_perfect = 0,
				},
				yaw = {
					lerp_basic = 0.0075,
					lerp_perfect = 0,
				},
			},
			{
				pitch = {
					lerp_basic = 0.011,
					lerp_perfect = 0,
				},
				yaw = {
					lerp_basic = 0.0075,
					lerp_perfect = 0,
				},
			},
			{
				pitch = {
					lerp_basic = 0.012,
					lerp_perfect = 0.005,
				},
				yaw = {
					lerp_basic = 0.01,
					lerp_perfect = 0.001,
				},
			},
			{
				pitch = {
					lerp_basic = 0.013,
					lerp_perfect = 0.0065,
				},
				yaw = {
					lerp_basic = 0.0125,
					lerp_perfect = 0.0025,
				},
			},
			{
				pitch = {
					lerp_basic = 0.015,
					lerp_perfect = 0.0075,
				},
				yaw = {
					lerp_basic = 0.015,
					lerp_perfect = 0.005,
				},
			},
			{
				pitch = {
					lerp_basic = 0.0175,
					lerp_perfect = 0.01,
				},
				yaw = {
					lerp_basic = 0.0175,
					lerp_perfect = 0.008,
				},
			},
			{
				pitch = {
					lerp_basic = 0.02,
					lerp_perfect = 0.0125,
				},
				yaw = {
					lerp_basic = 0.02,
					lerp_perfect = 0.009,
				},
			},
			{
				pitch = {
					lerp_basic = 0.025,
					lerp_perfect = 0.015,
				},
				yaw = {
					lerp_basic = 0.0225,
					lerp_perfect = 0.01,
				},
			},
			{
				pitch = {
					lerp_basic = 0.025,
					lerp_perfect = 0.015,
				},
				yaw = {
					lerp_basic = 0.025,
					lerp_perfect = 0.01,
				},
			},
		},
		offset_limit = {
			pitch = 1,
			yaw = 0.5,
		},
		new_influence_percent = {
			lerp_basic = 0.6,
			lerp_perfect = 0.4,
		},
		visual_recoil_settings = {
			intensity = 4.5,
			lerp_scalar = 0.8,
			yaw_intensity = 4.25,
		},
	},
	moving = {
		inherits = {
			"lasgun_p1_m2_ads_killshot",
			"still",
		},
		new_influence_percent = {
			lerp_basic = 0.7,
			lerp_perfect = 0.45,
		},
	},
	crouch_still = {
		inherits = {
			"lasgun_p1_m2_ads_killshot",
			"still",
		},
		new_influence_percent = {
			lerp_basic = 0.5,
			lerp_perfect = 0.35,
		},
	},
	crouch_moving = {
		inherits = {
			"lasgun_p1_m2_ads_killshot",
			"still",
		},
		new_influence_percent = {
			lerp_basic = 0.8,
			lerp_perfect = 0.5,
		},
	},
}
recoil_templates.lasgun_p1_m3_ads_killshot = {
	still = {
		camera_recoil_percentage = 0.1,
		decay_grace = 0.15,
		rise_duration = 0.05,
		rise = {
			{
				lerp_basic = 0.8,
				lerp_perfect = 0.5,
			},
			{
				lerp_basic = 0.7,
				lerp_perfect = 0.4,
			},
			{
				lerp_basic = 0.6,
				lerp_perfect = 0.35,
			},
			{
				lerp_basic = 0.5,
				lerp_perfect = 0.3,
			},
		},
		decay = {
			shooting = {
				lerp_basic = 0.2,
				lerp_perfect = 0.75,
			},
			idle = {
				lerp_basic = 0.75,
				lerp_perfect = 2,
			},
		},
		offset = {
			{
				pitch = {
					lerp_basic = 0.07,
					lerp_perfect = 0.025,
				},
				yaw = {
					lerp_basic = 0,
					lerp_perfect = 0,
				},
			},
			{
				pitch = {
					lerp_basic = 0.075,
					lerp_perfect = 0.02,
				},
				yaw = {
					lerp_basic = 0.011,
					lerp_perfect = 0,
				},
			},
			{
				pitch = {
					lerp_basic = 0.065,
					lerp_perfect = 0.02,
				},
				yaw = {
					lerp_basic = -0.011,
					lerp_perfect = 0,
				},
			},
			{
				pitch = {
					lerp_basic = 0.05,
					lerp_perfect = 0.02,
				},
				yaw = {
					lerp_basic = 0.011,
					lerp_perfect = 0,
				},
			},
		},
		offset_random_range = {
			{
				pitch = {
					lerp_basic = 0.02,
					lerp_perfect = 0,
				},
				yaw = {
					lerp_basic = 0.01,
					lerp_perfect = 0.0025,
				},
			},
			{
				pitch = {
					lerp_basic = 0,
					lerp_perfect = 0,
				},
				yaw = {
					lerp_basic = 0.01,
					lerp_perfect = 0.0025,
				},
			},
			{
				pitch = {
					lerp_basic = 0.01,
					lerp_perfect = 0,
				},
				yaw = {
					lerp_basic = 0.005,
					lerp_perfect = 0,
				},
			},
			{
				pitch = {
					lerp_basic = 0.011,
					lerp_perfect = 0,
				},
				yaw = {
					lerp_basic = 0.0075,
					lerp_perfect = 0,
				},
			},
			{
				pitch = {
					lerp_basic = 0.012,
					lerp_perfect = 0.005,
				},
				yaw = {
					lerp_basic = 0.01,
					lerp_perfect = 0.001,
				},
			},
			{
				pitch = {
					lerp_basic = 0.013,
					lerp_perfect = 0.0065,
				},
				yaw = {
					lerp_basic = 0.0125,
					lerp_perfect = 0.0025,
				},
			},
			{
				pitch = {
					lerp_basic = 0.015,
					lerp_perfect = 0.0075,
				},
				yaw = {
					lerp_basic = 0.015,
					lerp_perfect = 0.005,
				},
			},
			{
				pitch = {
					lerp_basic = 0.0175,
					lerp_perfect = 0.01,
				},
				yaw = {
					lerp_basic = 0.0175,
					lerp_perfect = 0.008,
				},
			},
			{
				pitch = {
					lerp_basic = 0.02,
					lerp_perfect = 0.0125,
				},
				yaw = {
					lerp_basic = 0.02,
					lerp_perfect = 0.009,
				},
			},
			{
				pitch = {
					lerp_basic = 0.025,
					lerp_perfect = 0.015,
				},
				yaw = {
					lerp_basic = 0.0225,
					lerp_perfect = 0.01,
				},
			},
			{
				pitch = {
					lerp_basic = 0.025,
					lerp_perfect = 0.015,
				},
				yaw = {
					lerp_basic = 0.025,
					lerp_perfect = 0.01,
				},
			},
		},
		offset_limit = {
			pitch = 1,
			yaw = 0.5,
		},
		new_influence_percent = {
			lerp_basic = 0.6,
			lerp_perfect = 0.4,
		},
		visual_recoil_settings = {
			intensity = 4,
			lerp_scalar = 0.8,
			yaw_intensity = 3.8,
		},
	},
	moving = {
		inherits = {
			"lasgun_p1_m3_ads_killshot",
			"still",
		},
		new_influence_percent = {
			lerp_basic = 0.7,
			lerp_perfect = 0.45,
		},
	},
	crouch_still = {
		inherits = {
			"lasgun_p1_m3_ads_killshot",
			"still",
		},
		new_influence_percent = {
			lerp_basic = 0.5,
			lerp_perfect = 0.35,
		},
	},
	crouch_moving = {
		inherits = {
			"lasgun_p1_m3_ads_killshot",
			"still",
		},
		new_influence_percent = {
			lerp_basic = 0.8,
			lerp_perfect = 0.5,
		},
	},
}
recoil_templates.ironsight_lasgun_killshot = {
	still = {
		camera_recoil_percentage = 0.5,
		rise_duration = 0.095,
		rise = {
			{
				lerp_basic = 0.5,
				lerp_perfect = 0.45,
			},
			{
				lerp_basic = 0.25,
				lerp_perfect = 0.2,
			},
			{
				lerp_basic = 0.2,
				lerp_perfect = 0.15,
			},
			{
				lerp_basic = 0.2,
				lerp_perfect = 0.15,
			},
		},
		decay = {
			shooting = {
				lerp_basic = 0.25,
				lerp_perfect = 0.3,
			},
			idle = {
				lerp_basic = 0.8,
				lerp_perfect = 1,
			},
		},
		offset = {
			{
				pitch = {
					lerp_basic = 0.075,
					lerp_perfect = 0.03,
				},
				yaw = {
					lerp_basic = 0,
					lerp_perfect = 0,
				},
			},
			{
				pitch = {
					lerp_basic = 0.07,
					lerp_perfect = 0.06,
				},
				yaw = {
					lerp_basic = 0,
					lerp_perfect = 0,
				},
			},
			{
				pitch = {
					lerp_basic = 0.065,
					lerp_perfect = 0.075,
				},
				yaw = {
					lerp_basic = 0,
					lerp_perfect = 0,
				},
			},
			{
				pitch = {
					lerp_basic = 0.085,
					lerp_perfect = 0.075,
				},
				yaw = {
					lerp_basic = 0,
					lerp_perfect = 0,
				},
			},
			{
				pitch = {
					lerp_basic = 0.095,
					lerp_perfect = 0.075,
				},
				yaw = {
					lerp_basic = 0,
					lerp_perfect = 0,
				},
			},
			{
				pitch = {
					lerp_basic = 0.1,
					lerp_perfect = 0.075,
				},
				yaw = {
					lerp_basic = 0,
					lerp_perfect = 0,
				},
			},
		},
		offset_random_range = {
			{
				pitch = {
					lerp_basic = 0,
					lerp_perfect = 0,
				},
				yaw = {
					lerp_basic = 0,
					lerp_perfect = 0,
				},
			},
			{
				pitch = {
					lerp_basic = 0,
					lerp_perfect = 0,
				},
				yaw = {
					lerp_basic = 0,
					lerp_perfect = 0,
				},
			},
			{
				pitch = {
					lerp_basic = 0.01,
					lerp_perfect = 0.02,
				},
				yaw = {
					lerp_basic = 0.01,
					lerp_perfect = 0,
				},
			},
			{
				pitch = {
					lerp_basic = 0.015,
					lerp_perfect = 0.035,
				},
				yaw = {
					lerp_basic = 0.015,
					lerp_perfect = 0,
				},
			},
			{
				pitch = {
					lerp_basic = 0.02,
					lerp_perfect = 0.035,
				},
				yaw = {
					lerp_basic = 0.02,
					lerp_perfect = 0.02,
				},
			},
			{
				pitch = {
					lerp_basic = 0.025,
					lerp_perfect = 0.025,
				},
				yaw = {
					lerp_basic = 0.025,
					lerp_perfect = 0.035,
				},
			},
			{
				pitch = {
					lerp_basic = 0.03,
					lerp_perfect = 0.015,
				},
				yaw = {
					lerp_basic = 0.03,
					lerp_perfect = 0.04,
				},
			},
			{
				pitch = {
					lerp_basic = 0.035,
					lerp_perfect = 0.015,
				},
				yaw = {
					lerp_basic = 0.035,
					lerp_perfect = 0.04,
				},
			},
			{
				pitch = {
					lerp_basic = 0.04,
					lerp_perfect = 0.015,
				},
				yaw = {
					lerp_basic = 0.04,
					lerp_perfect = 0.04,
				},
			},
			{
				pitch = {
					lerp_basic = 0.045,
					lerp_perfect = 0.015,
				},
				yaw = {
					lerp_basic = 0.045,
					lerp_perfect = 0.04,
				},
			},
			{
				pitch = {
					lerp_basic = 0.05,
					lerp_perfect = 0.015,
				},
				yaw = {
					lerp_basic = 0.05,
					lerp_perfect = 0.04,
				},
			},
		},
		offset_limit = {
			pitch = 0.175,
			yaw = 0.175,
		},
		new_influence_percent = {
			lerp_basic = 0.3,
			lerp_perfect = 0.25,
		},
		visual_recoil_settings = {
			intensity = 5,
			lerp_scalar = 0.2,
		},
	},
	moving = {
		inherits = {
			"ironsight_lasgun_killshot",
			"still",
		},
		new_influence_percent = {
			lerp_basic = 0.35,
			lerp_perfect = 0.25,
		},
	},
	crouch_still = {
		inherits = {
			"ironsight_lasgun_killshot",
			"still",
		},
	},
	crouch_moving = {
		inherits = {
			"ironsight_lasgun_killshot",
			"still",
		},
	},
}
recoil_templates.default_lasgun_spraynpray = {
	still = {
		new_influence_percent = 0.1,
		rise_duration = 0.075,
		rise = {
			0.1,
		},
		decay = {
			idle = 1.75,
			shooting = 1,
		},
		offset_range = {
			{
				pitch = {
					0.1,
					0.125,
				},
				yaw = {
					-0.02,
					0.02,
				},
			},
			{
				pitch = {
					0.075,
					0.1,
				},
				yaw = {
					-0.02,
					0.02,
				},
			},
			{
				pitch = {
					0.05,
					0.075,
				},
				yaw = {
					-0.03,
					0.03,
				},
			},
			{
				pitch = {
					0.02,
					0.04,
				},
				yaw = {
					-0.03,
					0.03,
				},
			},
		},
		offset_limit = {
			pitch = 2,
			yaw = 2,
		},
		aim_assist = {
			multiplier_function = AIM_ASSIST_MULTIPLIER_FUNCTIONS.unmodified_inverted_unsteadiness,
		},
	},
	moving = {
		new_influence_percent = 0.05,
		inherits = {
			"default_lasgun_spraynpray",
			"still",
		},
		rise = {
			0.5,
			0.35,
			0.275,
			0.2,
		},
	},
	crouch_still = {
		new_influence_percent = 0.04,
		inherits = {
			"default_lasgun_spraynpray",
			"still",
		},
	},
	crouch_moving = {
		new_influence_percent = 0.08,
		inherits = {
			"default_lasgun_spraynpray",
			"still",
		},
	},
}

local p2_m1_pitch = 0.05

recoil_templates.lasgun_p2_m1_ads_killshot = {
	still = {
		camera_recoil_percentage = 0.1,
		decay_grace = 0.15,
		rise_duration = 0.05,
		rise = {
			{
				lerp_basic = 0.8,
				lerp_perfect = 0.5,
			},
			{
				lerp_basic = 0.7,
				lerp_perfect = 0.4,
			},
		},
		decay = {
			shooting = {
				lerp_basic = 0.2,
				lerp_perfect = 0.75,
			},
			idle = {
				lerp_basic = 0.75,
				lerp_perfect = 2,
			},
		},
		offset = {
			{
				pitch = {
					lerp_basic = 0.05,
					lerp_perfect = 0.015,
				},
				yaw = {
					lerp_basic = 0,
					lerp_perfect = 0,
				},
			},
		},
		offset_random_range = {
			{
				pitch = {
					lerp_basic = 0.025,
					lerp_perfect = 0,
				},
				yaw = {
					lerp_basic = 0.01,
					lerp_perfect = 0.0025,
				},
			},
		},
		offset_limit = {
			pitch = 1,
			yaw = 0.5,
		},
		new_influence_percent = {
			lerp_basic = 0.6,
			lerp_perfect = 0.4,
		},
		visual_recoil_settings = {
			intensity = 6,
			lerp_scalar = 0.8,
			yaw_intensity = 7.8,
		},
	},
	moving = {
		inherits = {
			"lasgun_p2_m1_ads_killshot",
			"still",
		},
		new_influence_percent = {
			lerp_basic = 0.7,
			lerp_perfect = 0.45,
		},
	},
	crouch_still = {
		inherits = {
			"lasgun_p2_m1_ads_killshot",
			"still",
		},
		new_influence_percent = {
			lerp_basic = 0.5,
			lerp_perfect = 0.35,
		},
	},
	crouch_moving = {
		inherits = {
			"lasgun_p2_m1_ads_killshot",
			"still",
		},
		new_influence_percent = {
			lerp_basic = 0.8,
			lerp_perfect = 0.5,
		},
	},
}
recoil_templates.default_lasgun_bfg = {
	still = {
		new_influence_percent = 0.75,
		rise_duration = 0.1,
		rise = {
			0.3,
		},
		decay = {
			idle = 1.5,
			shooting = 0.5,
		},
		offset_range = {
			{
				pitch = {
					0.01,
					0.3,
				},
				yaw = {
					-0.1,
					0.1,
				},
			},
		},
		offset_limit = {
			pitch = 1,
			yaw = 3,
		},
	},
	moving = {
		inherits = {
			"default_lasgun_bfg",
			"still",
		},
	},
	crouch_still = {
		inherits = {
			"default_lasgun_bfg",
			"still",
		},
	},
	crouch_moving = {
		inherits = {
			"default_lasgun_bfg",
			"still",
		},
	},
}
recoil_templates.hip_lasgun_p3_m1_recoil = {
	still = {
		camera_recoil_percentage = 0.15,
		decay_grace = 0.125,
		rise_duration = 0.075,
		rise = {
			{
				lerp_basic = 0.4,
				lerp_perfect = 0.3,
			},
			{
				lerp_basic = 0.4,
				lerp_perfect = 0.3,
			},
			{
				lerp_basic = 0.4,
				lerp_perfect = 0.3,
			},
			{
				lerp_basic = 0.4,
				lerp_perfect = 0.3,
			},
			{
				lerp_basic = 0.5,
				lerp_perfect = 0.2,
			},
			{
				lerp_basic = 0.5,
				lerp_perfect = 0.15,
			},
		},
		decay = {
			shooting = {
				lerp_basic = 0.25,
				lerp_perfect = 1,
			},
			idle = {
				lerp_basic = 1,
				lerp_perfect = 3,
			},
		},
		offset = assault_p3_m1_offset_range,
		offset_random_range = assault_p3_m1_random_range,
		offset_limit = {
			pitch = 0.5,
			yaw = 0.5,
		},
		visual_recoil_settings = {
			intensity = 10,
			lerp_scalar = 0.75,
		},
		new_influence_percent = {
			lerp_basic = 0.2,
			lerp_perfect = 0.05,
		},
	},
	moving = {
		inherits = {
			"hip_lasgun_p3_m1_recoil",
			"still",
		},
		new_influence_percent = {
			lerp_basic = 0.12,
			lerp_perfect = 0.06,
		},
	},
	crouch_still = {
		inherits = {
			"hip_lasgun_p3_m1_recoil",
			"still",
		},
		new_influence_percent = {
			lerp_basic = 0.1,
			lerp_perfect = 0.05,
		},
	},
	crouch_moving = {
		inherits = {
			"hip_lasgun_p3_m1_recoil",
			"still",
		},
		new_influence_percent = {
			lerp_basic = 0.125,
			lerp_perfect = 0.075,
		},
	},
}
recoil_templates.lasgun_p3_m1_ads_killshot = {
	still = {
		camera_recoil_percentage = 0.01,
		decay_grace = 0.15,
		rise_duration = 0.01,
		rise = {
			{
				lerp_basic = 0.4,
				lerp_perfect = 0.3,
			},
			{
				lerp_basic = 0.4,
				lerp_perfect = 0.3,
			},
			{
				lerp_basic = 0.4,
				lerp_perfect = 0.3,
			},
			{
				lerp_basic = 0.4,
				lerp_perfect = 0.3,
			},
			{
				lerp_basic = 0.5,
				lerp_perfect = 0.2,
			},
			{
				lerp_basic = 0.5,
				lerp_perfect = 0.15,
			},
		},
		decay = {
			shooting = {
				lerp_basic = 0.25,
				lerp_perfect = 1,
			},
			idle = {
				lerp_basic = 1,
				lerp_perfect = 3,
			},
		},
		offset = killshot_p3_m1_offset_range,
		offset_random_range = killshot_p3_m1_random_range,
		offset_limit = {
			pitch = 0.5,
			yaw = 0.5,
		},
		new_influence_percent = {
			lerp_basic = 0.2,
			lerp_perfect = 0.05,
		},
		visual_recoil_settings = {
			intensity = 4,
			lerp_scalar = 0.8,
			yaw_intensity = 4.25,
		},
	},
	moving = {
		inherits = {
			"lasgun_p3_m1_ads_killshot",
			"still",
		},
		new_influence_percent = {
			lerp_basic = 0.25,
			lerp_perfect = 0.075,
		},
	},
	crouch_still = {
		inherits = {
			"lasgun_p3_m1_ads_killshot",
			"still",
		},
		new_influence_percent = {
			lerp_basic = 0.18,
			lerp_perfect = 0.048,
		},
	},
	crouch_moving = {
		inherits = {
			"lasgun_p3_m1_ads_killshot",
			"still",
		},
		new_influence_percent = {
			lerp_basic = 0.23,
			lerp_perfect = 0.73,
		},
	},
}

return {
	base_templates = recoil_templates,
	overrides = overrides,
}
