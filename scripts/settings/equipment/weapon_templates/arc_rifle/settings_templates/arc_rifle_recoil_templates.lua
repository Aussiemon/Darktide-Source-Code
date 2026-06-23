-- chunkname: @scripts/settings/equipment/weapon_templates/arc_rifle/settings_templates/arc_rifle_recoil_templates.lua

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
local assault_scale_m2 = {
	{
		1,
		{
			0.75,
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
		6,
		{
			0.5,
			1,
		},
	},
	{
		12,
		{
			0.75,
			0.5,
		},
	},
	{
		20,
		{
			0.6,
			0.6,
		},
	},
	{
		50,
		{
			0.2,
			0.4,
		},
	},
}
local assault_random_scale_m2 = {
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
		50,
		{
			1,
			1,
		},
	},
}
local assault_offset_range = generate_offset_range(30, 0.015, 0, 0.95, create_scale(assault_scale))
local assault_random_range = generate_offset_range(30, 0.01, 0.02, 0.95, create_scale(assault_random_scale))
local assault_offset_range_m2 = generate_offset_range(50, 0.045, 0, 0.75, create_scale(assault_scale_m2))
local assault_random_range_m2 = generate_offset_range(50, 0.01, 0.015, 0.75, create_scale(assault_random_scale_m2))
local assault_scale_m3 = {
	{
		1,
		{
			0.75,
			0.5,
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
			0.75,
			0.5,
		},
	},
	{
		20,
		{
			0.6,
			0.6,
		},
	},
	{
		50,
		{
			0.2,
			0.4,
		},
	},
}
local assault_random_scale_m3 = {
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
		50,
		{
			1,
			1,
		},
	},
}
local braced_scale_m3 = {
	{
		1,
		{
			0.25,
			0.25,
		},
	},
	{
		12,
		{
			1,
			1,
		},
	},
	{
		20,
		{
			0.6,
			0.6,
		},
	},
	{
		50,
		{
			0.2,
			0.4,
		},
	},
}
local braced_random_scale_m3 = {
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
		50,
		{
			1,
			1,
		},
	},
}
local assault_offset_range_m3 = generate_offset_range(50, 0.045, 0, 0.95, create_scale(assault_scale_m3))
local assault_random_range_m3 = generate_offset_range(50, 0.01, 0.035, 0.95, create_scale(assault_random_scale_m3))
local braced_offset_range_m3 = generate_offset_range(50, 0.01, 0, 0.95, create_scale(braced_scale_m3))
local braced_random_range_m3 = generate_offset_range(50, 0.0075, 0.0075, 0.95, create_scale(braced_random_scale_m3))

recoil_templates.arc_rifle_p1_m1_recoil_hip = {
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
			0.2,
		},
		decay = {
			idle = 3.2,
			shooting = 1.6,
		},
		offset = assault_offset_range_m2,
		offset_random_range = assault_random_range_m2,
		offset_limit = {
			pitch = 3,
			yaw = 2,
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
		new_influence_percent = 0.85,
		inherits = {
			"arc_rifle_p1_m1_recoil_hip",
			"still",
		},
	},
	crouch_still = {
		new_influence_percent = 0.85,
		inherits = {
			"arc_rifle_p1_m1_recoil_hip",
			"still",
		},
	},
	crouch_moving = {
		new_influence_percent = 0.85,
		inherits = {
			"arc_rifle_p1_m1_recoil_hip",
			"still",
		},
	},
}
recoil_templates.arc_rifle_p1_m1_recoil_ads = {
	still = {
		camera_recoil_percentage = 0.75,
		decay_grace = 0.1,
		rise_duration = 0.08,
		rise = {
			{
				lerp_basic = 0.8,
				lerp_perfect = 0.55,
			},
			{
				lerp_basic = 0.3,
				lerp_perfect = 0.15,
			},
			{
				lerp_basic = 0.2,
				lerp_perfect = 0.1,
			},
			{
				lerp_basic = 0.12,
				lerp_perfect = 0.029,
			},
			{
				lerp_basic = 0.2,
				lerp_perfect = 0.025,
			},
			{
				lerp_basic = 0.15,
				lerp_perfect = 0.025,
			},
		},
		decay = {
			shooting = {
				lerp_basic = 0.5,
				lerp_perfect = 0.75,
			},
			idle = {
				lerp_basic = 2.5,
				lerp_perfect = 3,
			},
		},
		offset = assault_offset_range,
		offset_random_range = assault_random_range,
		offset_limit = {
			pitch = 1.5,
			yaw = 1,
		},
		new_influence_percent = {
			lerp_basic = 0.7,
			lerp_perfect = 0.35,
		},
		aim_assist = {
			multiplier_function = AIM_ASSIST_MULTIPLIER_FUNCTIONS.unmodified_inverted_unsteadiness,
		},
		visual_recoil_settings = {
			intensity = 4.5,
			lerp_scalar = 1,
		},
	},
	moving = {
		inherits = {
			"arc_rifle_p1_m1_recoil_ads",
			"still",
		},
		new_influence_percent = {
			lerp_basic = 0.55,
			lerp_perfect = 0.3,
		},
	},
	crouch_still = {
		inherits = {
			"arc_rifle_p1_m1_recoil_ads",
			"still",
		},
		new_influence_percent = {
			lerp_basic = 0.25,
			lerp_perfect = 0.15,
		},
	},
	crouch_moving = {
		inherits = {
			"arc_rifle_p1_m1_recoil_ads",
			"still",
		},
		new_influence_percent = {
			lerp_basic = 0.4,
			lerp_perfect = 0.2,
		},
	},
}

return {
	base_templates = recoil_templates,
	overrides = overrides,
}
