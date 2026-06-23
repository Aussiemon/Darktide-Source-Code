-- chunkname: @scripts/settings/equipment/weapon_templates/arc_rifle/settings_templates/arc_rifle_spread_templates.lua

local RecoilTemplate = require("scripts/utilities/recoil_template")
local generate_offset_range = RecoilTemplate.generate_offset_range
local create_scale = RecoilTemplate.create_scale
local spread_templates = {}
local overrides = {}

table.make_unique(spread_templates)
table.make_unique(overrides)

local assault_scale_m2 = {
	{
		1,
		{
			0.4,
			0.4,
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
			0.4,
			0.4,
		},
	},
	{
		12,
		{
			0.01,
			0.01,
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
			0.01,
			0.01,
		},
	},
	{
		30,
		{
			0.5,
			0.5,
		},
	},
	{
		36,
		{
			0.01,
			0.01,
		},
	},
	{
		42,
		{
			0.5,
			0.5,
		},
	},
	{
		48,
		{
			0.01,
			0.01,
		},
	},
	{
		54,
		{
			0.5,
			0.5,
		},
	},
	{
		60,
		{
			0.01,
			0.01,
		},
	},
	{
		66,
		{
			0.5,
			0.5,
		},
	},
	{
		72,
		{
			0.01,
			0.01,
		},
	},
	{
		78,
		{
			0.5,
			0.5,
		},
	},
	{
		84,
		{
			0.01,
			0.01,
		},
	},
	{
		90,
		{
			0.5,
			0.5,
		},
	},
}
local braced_scale_m2 = {
	{
		1,
		{
			0.3,
			0.4,
		},
	},
	{
		3,
		{
			0.5,
			0.5,
		},
	},
	{
		6,
		{
			0.4,
			0.4,
		},
	},
	{
		12,
		{
			0.75,
			0.75,
		},
	},
	{
		18,
		{
			0.3,
			0.3,
		},
	},
	{
		24,
		{
			0.01,
			0.01,
		},
	},
	{
		30,
		{
			0.3,
			0.3,
		},
	},
	{
		36,
		{
			0.01,
			0.01,
		},
	},
	{
		42,
		{
			0.3,
			0.3,
		},
	},
	{
		48,
		{
			0.01,
			0.01,
		},
	},
	{
		54,
		{
			0.3,
			0.3,
		},
	},
	{
		60,
		{
			0.01,
			0.01,
		},
	},
	{
		66,
		{
			0.3,
			0.3,
		},
	},
	{
		72,
		{
			0.01,
			0.01,
		},
	},
	{
		78,
		{
			0.3,
			0.3,
		},
	},
	{
		84,
		{
			0.01,
			0.01,
		},
	},
	{
		90,
		{
			0.3,
			0.3,
		},
	},
}
local braced_spread_range_m2 = generate_offset_range(90, 0.35, 0.4, 0.75, create_scale(braced_scale_m2))
local assault_spread_range_m2 = generate_offset_range(90, 0.725, 0.775, 0.85, create_scale(assault_scale_m2))
local assault_spread_range_m2_moving = generate_offset_range(90, 0.775, 0.825, 0.85, create_scale(assault_scale_m2))

spread_templates.arc_rifle_p1_m1_spread_hip = {
	still = {
		max_spread = {
			pitch = 3.4,
			yaw = 3.4,
		},
		randomized_spread = {
			max_pitch_delta = 0.25,
			max_yaw_delta = 0.25,
			min_ratio = 0.05,
			random_ratio = 0.1,
		},
		decay = {
			from_shooting_grace_time = 0.025,
			shooting = {
				pitch = 1.275,
				yaw = 1.3,
			},
			idle = {
				pitch = 3.5,
				yaw = 3.5,
			},
		},
		continuous_spread = {
			min_pitch = {
				lerp_basic = 3.5,
				lerp_perfect = 2.75,
			},
			min_yaw = {
				lerp_basic = 3.5,
				lerp_perfect = 2.75,
			},
		},
		immediate_spread = {
			num_shots_clear_time = 0.25,
			damage_hit = {
				{
					pitch = 0.4,
					yaw = 0.4,
				},
			},
			shooting = {
				{
					pitch = 2.7,
					yaw = 1.7,
				},
				{
					pitch = 2.65,
					yaw = 1.65,
				},
				{
					pitch = 2.1,
					yaw = 1.2,
				},
			},
		},
	},
	moving = {
		inherits = {
			"arc_rifle_p1_m1_spread_hip",
			"still",
		},
		continuous_spread = {
			min_pitch = {
				lerp_basic = 3.6,
				lerp_perfect = 2.85,
			},
			min_yaw = {
				lerp_basic = 3.3,
				lerp_perfect = 2.65,
			},
		},
		immediate_spread = {
			num_shots_clear_time = 0.25,
			damage_hit = {
				{
					pitch = 0.4,
					yaw = 0.4,
				},
			},
			shooting = assault_spread_range_m2_moving,
		},
	},
	crouch_still = {
		inherits = {
			"arc_rifle_p1_m1_spread_hip",
			"still",
		},
	},
	crouch_moving = {
		inherits = {
			"arc_rifle_p1_m1_spread_hip",
			"still",
		},
	},
}
spread_templates.arc_rifle_p1_m1_spread_ads = {
	still = {
		max_spread = {
			pitch = 2.6,
			yaw = 2.6,
		},
		randomized_spread = {
			first_shot_min_ratio = 0.1,
			first_shot_random_ratio = 0.2,
			min_ratio = 0.1,
			random_ratio = 0.15,
		},
		decay = {
			from_shooting_grace_time = 0.3,
			shooting = {
				pitch = 0.675,
				yaw = 0.7,
			},
			idle = {
				pitch = 1.75,
				yaw = 1.75,
			},
		},
		continuous_spread = {
			min_pitch = {
				lerp_basic = 2.25,
				lerp_perfect = 1.4,
			},
			min_yaw = {
				lerp_basic = 2.25,
				lerp_perfect = 1.4,
			},
		},
		immediate_spread = {
			damage_hit = {
				{
					pitch = 0.3,
					yaw = 0.3,
				},
			},
			shooting = braced_spread_range_m2,
			num_shots_clear_time = {
				lerp_basic = 0.1,
				lerp_perfect = 0.1,
			},
		},
	},
	moving = {
		inherits = {
			"arc_rifle_p1_m1_spread_ads",
			"still",
		},
		continuous_spread = {
			min_pitch = {
				lerp_basic = 3,
				lerp_perfect = 0.5,
			},
			min_yaw = {
				lerp_basic = 3,
				lerp_perfect = 0.5,
			},
		},
	},
	crouch_still = {
		inherits = {
			"arc_rifle_p1_m1_spread_ads",
			"still",
		},
		continuous_spread = {
			min_pitch = {
				lerp_basic = 3,
				lerp_perfect = 0.5,
			},
			min_yaw = {
				lerp_basic = 3,
				lerp_perfect = 0.5,
			},
		},
	},
	crouch_moving = {
		inherits = {
			"arc_rifle_p1_m1_spread_ads",
			"still",
		},
		continuous_spread = {
			min_pitch = {
				lerp_basic = 3,
				lerp_perfect = 0.5,
			},
			min_yaw = {
				lerp_basic = 3,
				lerp_perfect = 0.5,
			},
		},
	},
}

return {
	base_templates = spread_templates,
	overrides = overrides,
}
