-- chunkname: @scripts/settings/equipment/weapon_templates/ogryn_heavystubbers/settings_templates/ogryn_heavystubber_spread_templates.lua

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

spread_templates.default_ogryn_heavystubber_braced = {
	still = {
		max_spread = {
			pitch = 4.2,
			yaw = 4.2,
		},
		randomized_spread = {
			first_shot_min_ratio = 0.3,
			first_shot_random_ratio = 0.5,
			min_ratio = 0.23,
			random_ratio = 0.55,
		},
		decay = {
			from_shooting_grace_time = 0.3,
			shooting = {
				pitch = 0.9,
				yaw = 0.9,
			},
			idle = {
				pitch = 1.75,
				yaw = 1.75,
			},
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
		immediate_spread = {
			damage_hit = {
				{
					pitch = 0.3,
					yaw = 0.3,
				},
			},
			shooting = {
				{
					pitch = {
						lerp_basic = 0.45,
						lerp_perfect = 0.25,
					},
					yaw = {
						lerp_basic = 0.45,
						lerp_perfect = 0.25,
					},
				},
				{
					pitch = {
						lerp_basic = 0.25,
						lerp_perfect = 0.15,
					},
					yaw = {
						lerp_basic = 0.25,
						lerp_perfect = 0.15,
					},
				},
				{
					pitch = {
						lerp_basic = 0.45,
						lerp_perfect = 0.25,
					},
					yaw = {
						lerp_basic = 0.45,
						lerp_perfect = 0.25,
					},
				},
				{
					pitch = {
						lerp_basic = 0.6,
						lerp_perfect = 0.4,
					},
					yaw = {
						lerp_basic = 0.6,
						lerp_perfect = 0.4,
					},
				},
				{
					pitch = {
						lerp_basic = 0.35,
						lerp_perfect = 0.2,
					},
					yaw = {
						lerp_basic = 0.35,
						lerp_perfect = 0.2,
					},
				},
				{
					pitch = {
						lerp_basic = 0.3,
						lerp_perfect = 0.15,
					},
					yaw = {
						lerp_basic = 0.3,
						lerp_perfect = 0.15,
					},
				},
				{
					pitch = {
						lerp_basic = 0.3,
						lerp_perfect = 0.15,
					},
					yaw = {
						lerp_basic = 0.3,
						lerp_perfect = 0.15,
					},
				},
				{
					pitch = {
						lerp_basic = 0.3,
						lerp_perfect = 0.15,
					},
					yaw = {
						lerp_basic = 0.3,
						lerp_perfect = 0.15,
					},
				},
				{
					pitch = {
						lerp_basic = 0.3,
						lerp_perfect = 0.1,
					},
					yaw = {
						lerp_basic = 0.3,
						lerp_perfect = 0.1,
					},
				},
			},
			num_shots_clear_time = {
				lerp_basic = 0.1,
				lerp_perfect = 0.1,
			},
		},
	},
	moving = {
		inherits = {
			"default_ogryn_heavystubber_braced",
			"still",
		},
		continuous_spread = {
			min_pitch = {
				lerp_basic = 1.9,
				lerp_perfect = 1.05,
			},
			min_yaw = {
				lerp_basic = 1.9,
				lerp_perfect = 1.05,
			},
		},
	},
	crouch_still = {
		inherits = {
			"default_ogryn_heavystubber_braced",
			"still",
		},
		continuous_spread = {
			min_pitch = {
				lerp_basic = 1.6,
				lerp_perfect = 1.25,
			},
			min_yaw = {
				lerp_basic = 1.6,
				lerp_perfect = 1.25,
			},
		},
	},
	crouch_moving = {
		inherits = {
			"default_ogryn_heavystubber_braced",
			"still",
		},
		continuous_spread = {
			min_pitch = {
				lerp_basic = 3,
				lerp_perfect = 2.1,
			},
			min_yaw = {
				lerp_basic = 3,
				lerp_perfect = 2.1,
			},
		},
	},
}
spread_templates.default_ogryn_heavystubber_burst = {
	still = {
		max_spread = {
			pitch = 8,
			yaw = 8,
		},
		decay = {
			from_shooting_grace_time = 0.3,
			shooting = {
				pitch = 0.25,
				yaw = 0.25,
			},
			idle = {
				pitch = 1.75,
				yaw = 1.75,
			},
		},
		continuous_spread = {
			min_pitch = 0.5,
			min_yaw = 0.5,
		},
		immediate_spread = {
			num_shots_clear_time = 0.75,
			damage_hit = {
				{
					pitch = 0.4,
					yaw = 0.4,
				},
			},
			shooting = {
				{
					pitch = 0.1,
					yaw = 0.1,
				},
				{
					pitch = 0.15,
					yaw = 0.15,
				},
				{
					pitch = 0.15,
					yaw = 0.15,
				},
				{
					pitch = 1,
					yaw = 1,
				},
				{
					pitch = 0.1,
					yaw = 0.1,
				},
				{
					pitch = 0.15,
					yaw = 0.15,
				},
				{
					pitch = 0.15,
					yaw = 0.15,
				},
				{
					pitch = 1,
					yaw = 1,
				},
				{
					pitch = 0.1,
					yaw = 0.1,
				},
				{
					pitch = 0.15,
					yaw = 0.15,
				},
				{
					pitch = 0.15,
					yaw = 0.15,
				},
				{
					pitch = 0.75,
					yaw = 0.75,
				},
				{
					pitch = 0.1,
					yaw = 0.1,
				},
				{
					pitch = 0.125,
					yaw = 0.125,
				},
				{
					pitch = 0.125,
					yaw = 0.125,
				},
				{
					pitch = 0.5,
					yaw = 0.5,
				},
				{
					pitch = 0.1,
					yaw = 0.1,
				},
				{
					pitch = 0.125,
					yaw = 0.125,
				},
				{
					pitch = 0.125,
					yaw = 0.125,
				},
				{
					pitch = 0.5,
					yaw = 0.5,
				},
				{
					pitch = 0.1,
					yaw = 0.1,
				},
				{
					pitch = 0.1,
					yaw = 0.1,
				},
				{
					pitch = 0.1,
					yaw = 0.1,
				},
				{
					pitch = 0.3,
					yaw = 0.3,
				},
				{
					pitch = 0.075,
					yaw = 0.075,
				},
				{
					pitch = 0.075,
					yaw = 0.075,
				},
				{
					pitch = 0.075,
					yaw = 0.075,
				},
				{
					pitch = 0.2,
					yaw = 0.2,
				},
				{
					pitch = 0.175,
					yaw = 0.175,
				},
				{
					pitch = 0.15,
					yaw = 0.15,
				},
			},
		},
	},
	moving = {
		inherits = {
			"default_ogryn_heavystubber_burst",
			"still",
		},
		continuous_spread = {
			min_pitch = 0.75,
			min_yaw = 0.75,
		},
	},
	crouch_still = {
		inherits = {
			"default_ogryn_heavystubber_burst",
			"still",
		},
		continuous_spread = {
			min_pitch = 0.8,
			min_yaw = 0.8,
		},
	},
	crouch_moving = {
		inherits = {
			"default_ogryn_heavystubber_burst",
			"still",
		},
		continuous_spread = {
			min_pitch = 1.1,
			min_yaw = 1.1,
		},
	},
}

local pitch_spread = 0.86
local yaw_spread = pitch_spread * 1.2

spread_templates.ogryn_heavystubber_spread_spraynpray_hip = {
	still = {
		max_spread = {
			pitch = 6.4,
			yaw = 6,
		},
		decay = {
			from_shooting_grace_time = 0.025,
			shooting = {
				pitch = 0.5,
				yaw = 0.5,
			},
			idle = {
				pitch = 1.5,
				yaw = 1.5,
			},
		},
		continuous_spread = {
			min_pitch = 2,
			min_yaw = 2,
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
					pitch = pitch_spread * 0.4,
					yaw = yaw_spread * 0.4,
				},
				{
					pitch = pitch_spread * 0.45,
					yaw = yaw_spread * 0.45,
				},
				{
					pitch = pitch_spread * 0.5,
					yaw = yaw_spread * 0.5,
				},
				{
					pitch = pitch_spread * 0.4,
					yaw = yaw_spread * 0.4,
				},
				{
					pitch = pitch_spread * 0.3,
					yaw = yaw_spread * 0.3,
				},
				{
					pitch = pitch_spread * 0.2,
					yaw = yaw_spread * 0.2,
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0,
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0,
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0,
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0,
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0,
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0,
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1,
				},
				{
					pitch = pitch_spread * 0.2,
					yaw = yaw_spread * 0.2,
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1,
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0,
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0,
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1,
				},
				{
					pitch = pitch_spread * 0.2,
					yaw = yaw_spread * 0.2,
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1,
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0,
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0,
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1,
				},
				{
					pitch = pitch_spread * 0.2,
					yaw = yaw_spread * 0.2,
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1,
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0,
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0,
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1,
				},
				{
					pitch = pitch_spread * 0.2,
					yaw = yaw_spread * 0.2,
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1,
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0,
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0,
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1,
				},
				{
					pitch = pitch_spread * 0.2,
					yaw = yaw_spread * 0.2,
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1,
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0,
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0,
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1,
				},
				{
					pitch = pitch_spread * 0.2,
					yaw = yaw_spread * 0.2,
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1,
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0,
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0,
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1,
				},
				{
					pitch = pitch_spread * 0.2,
					yaw = yaw_spread * 0.2,
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1,
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0,
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0,
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1,
				},
				{
					pitch = pitch_spread * 0.2,
					yaw = yaw_spread * 0.2,
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1,
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0,
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0,
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1,
				},
				{
					pitch = pitch_spread * 0.2,
					yaw = yaw_spread * 0.2,
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1,
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0,
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0,
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1,
				},
				{
					pitch = pitch_spread * 0.2,
					yaw = yaw_spread * 0.2,
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1,
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0,
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0,
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1,
				},
				{
					pitch = pitch_spread * 0.2,
					yaw = yaw_spread * 0.2,
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1,
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0,
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0,
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1,
				},
				{
					pitch = pitch_spread * 0.2,
					yaw = yaw_spread * 0.2,
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1,
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0,
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0,
				},
				{
					pitch = pitch_spread * 0.14,
					yaw = yaw_spread * 0.14,
				},
			},
		},
	},
	moving = {
		inherits = {
			"ogryn_heavystubber_spread_spraynpray_hip",
			"still",
		},
		continuous_spread = {
			min_pitch = 2.1,
			min_yaw = 2.1,
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
					pitch = pitch_spread * 1,
					yaw = yaw_spread * 1,
				},
				{
					pitch = pitch_spread * 0.75,
					yaw = yaw_spread * 0.75,
				},
				{
					pitch = pitch_spread * 0.5,
					yaw = yaw_spread * 0.5,
				},
				{
					pitch = pitch_spread * 0.4,
					yaw = yaw_spread * 0.4,
				},
				{
					pitch = pitch_spread * 0.3,
					yaw = yaw_spread * 0.3,
				},
				{
					pitch = pitch_spread * 0.2,
					yaw = yaw_spread * 0.2,
				},
			},
		},
	},
	crouch_still = {
		inherits = {
			"ogryn_heavystubber_spread_spraynpray_hip",
			"still",
		},
	},
	crouch_moving = {
		inherits = {
			"ogryn_heavystubber_spread_spraynpray_hip",
			"still",
		},
	},
}
spread_templates.ogryn_heavystubber_spread_spraynpray_hip_m2 = {
	still = {
		max_spread = {
			pitch = 6.4,
			yaw = 6,
		},
		randomized_spread = {
			first_shot_min_ratio = 0.2,
			first_shot_random_ratio = 0.5,
			max_pitch_delta = 0.75,
			max_yaw_delta = 0.75,
			min_ratio = 0.25,
			random_ratio = 0.75,
		},
		decay = {
			from_shooting_grace_time = 0.025,
			shooting = {
				pitch = 0.575,
				yaw = 0.6,
			},
			idle = {
				pitch = 1.5,
				yaw = 1.5,
			},
		},
		continuous_spread = {
			min_pitch = 1.8,
			min_yaw = 1.6,
		},
		immediate_spread = {
			num_shots_clear_time = 0.25,
			damage_hit = {
				{
					pitch = 0.4,
					yaw = 0.4,
				},
			},
			shooting = assault_spread_range_m2,
		},
	},
	moving = {
		inherits = {
			"ogryn_heavystubber_spread_spraynpray_hip_m2",
			"still",
		},
		continuous_spread = {
			min_pitch = 2.5,
			min_yaw = 2.5,
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
			"ogryn_heavystubber_spread_spraynpray_hip_m2",
			"still",
		},
	},
	crouch_moving = {
		inherits = {
			"ogryn_heavystubber_spread_spraynpray_hip_m2",
			"still",
		},
	},
}
spread_templates.default_ogryn_heavystubber_braced_m2 = {
	still = {
		max_spread = {
			pitch = 3.6,
			yaw = 3.6,
		},
		randomized_spread = {
			first_shot_min_ratio = 0.3,
			first_shot_random_ratio = 0.5,
			min_ratio = 0.15,
			random_ratio = 0.5,
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
				lerp_basic = 3,
				lerp_perfect = 0.5,
			},
			min_yaw = {
				lerp_basic = 3,
				lerp_perfect = 0.5,
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
			"default_ogryn_heavystubber_braced_m2",
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
			"default_ogryn_heavystubber_braced_m2",
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
			"default_ogryn_heavystubber_braced_m2",
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

local pitch_spread_m3 = 0.97
local yaw_spread_m3 = pitch_spread * 1.1

spread_templates.ogryn_heavystubber_spread_spraynpray_hip_m3 = {
	still = {
		max_spread = {
			pitch = 5.4,
			yaw = 5,
		},
		decay = {
			from_shooting_grace_time = 0.025,
			shooting = {
				pitch = 0.5,
				yaw = 0.5,
			},
			idle = {
				pitch = 1.5,
				yaw = 1.5,
			},
		},
		continuous_spread = {
			min_pitch = 1.8,
			min_yaw = 1.8,
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
					pitch = pitch_spread_m3 * 0.1,
					yaw = yaw_spread_m3 * 0.1,
				},
				{
					pitch = pitch_spread_m3 * 0.1,
					yaw = yaw_spread_m3 * 0.1,
				},
				{
					pitch = pitch_spread_m3 * 0.2,
					yaw = yaw_spread_m3 * 0.2,
				},
				{
					pitch = pitch_spread_m3 * 0.4,
					yaw = yaw_spread_m3 * 0.4,
				},
				{
					pitch = pitch_spread_m3 * 0.3,
					yaw = yaw_spread_m3 * 0.3,
				},
				{
					pitch = pitch_spread_m3 * 0.2,
					yaw = yaw_spread_m3 * 0.2,
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0,
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0,
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0,
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0,
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0,
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0,
				},
				{
					pitch = pitch_spread_m3 * 0.1,
					yaw = yaw_spread_m3 * 0.1,
				},
				{
					pitch = pitch_spread_m3 * 0.2,
					yaw = yaw_spread_m3 * 0.2,
				},
				{
					pitch = pitch_spread_m3 * 0.1,
					yaw = yaw_spread_m3 * 0.1,
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0,
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0,
				},
				{
					pitch = pitch_spread_m3 * 0.1,
					yaw = yaw_spread_m3 * 0.1,
				},
				{
					pitch = pitch_spread_m3 * 0.2,
					yaw = yaw_spread_m3 * 0.2,
				},
				{
					pitch = pitch_spread_m3 * 0.1,
					yaw = yaw_spread_m3 * 0.1,
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0,
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0,
				},
				{
					pitch = pitch_spread_m3 * 0.1,
					yaw = yaw_spread_m3 * 0.1,
				},
				{
					pitch = pitch_spread_m3 * 0.2,
					yaw = yaw_spread_m3 * 0.2,
				},
				{
					pitch = pitch_spread_m3 * 0.1,
					yaw = yaw_spread_m3 * 0.1,
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0,
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0,
				},
				{
					pitch = pitch_spread_m3 * 0.1,
					yaw = yaw_spread_m3 * 0.1,
				},
				{
					pitch = pitch_spread_m3 * 0.2,
					yaw = yaw_spread_m3 * 0.2,
				},
				{
					pitch = pitch_spread_m3 * 0.1,
					yaw = yaw_spread_m3 * 0.1,
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0,
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0,
				},
				{
					pitch = pitch_spread_m3 * 0.1,
					yaw = yaw_spread_m3 * 0.1,
				},
				{
					pitch = pitch_spread_m3 * 0.2,
					yaw = yaw_spread_m3 * 0.2,
				},
				{
					pitch = pitch_spread_m3 * 0.1,
					yaw = yaw_spread_m3 * 0.1,
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0,
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0,
				},
				{
					pitch = pitch_spread_m3 * 0.1,
					yaw = yaw_spread_m3 * 0.1,
				},
				{
					pitch = pitch_spread_m3 * 0.2,
					yaw = yaw_spread_m3 * 0.2,
				},
				{
					pitch = pitch_spread_m3 * 0.1,
					yaw = yaw_spread_m3 * 0.1,
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0,
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0,
				},
				{
					pitch = pitch_spread_m3 * 0.1,
					yaw = yaw_spread_m3 * 0.1,
				},
				{
					pitch = pitch_spread_m3 * 0.2,
					yaw = yaw_spread_m3 * 0.2,
				},
				{
					pitch = pitch_spread_m3 * 0.1,
					yaw = yaw_spread_m3 * 0.1,
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0,
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0,
				},
				{
					pitch = pitch_spread_m3 * 0.1,
					yaw = yaw_spread_m3 * 0.1,
				},
				{
					pitch = pitch_spread_m3 * 0.2,
					yaw = yaw_spread_m3 * 0.2,
				},
				{
					pitch = pitch_spread_m3 * 0.1,
					yaw = yaw_spread_m3 * 0.1,
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0,
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0,
				},
				{
					pitch = pitch_spread_m3 * 0.1,
					yaw = yaw_spread_m3 * 0.1,
				},
				{
					pitch = pitch_spread_m3 * 0.2,
					yaw = yaw_spread_m3 * 0.2,
				},
				{
					pitch = pitch_spread_m3 * 0.1,
					yaw = yaw_spread_m3 * 0.1,
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0,
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0,
				},
				{
					pitch = pitch_spread_m3 * 0.1,
					yaw = yaw_spread_m3 * 0.1,
				},
				{
					pitch = pitch_spread_m3 * 0.2,
					yaw = yaw_spread_m3 * 0.2,
				},
				{
					pitch = pitch_spread_m3 * 0.1,
					yaw = yaw_spread_m3 * 0.1,
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0,
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0,
				},
				{
					pitch = pitch_spread_m3 * 0.1,
					yaw = yaw_spread_m3 * 0.1,
				},
				{
					pitch = pitch_spread_m3 * 0.2,
					yaw = yaw_spread_m3 * 0.2,
				},
				{
					pitch = pitch_spread_m3 * 0.1,
					yaw = yaw_spread_m3 * 0.1,
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0,
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0,
				},
				{
					pitch = pitch_spread_m3 * 0.1,
					yaw = yaw_spread_m3 * 0.1,
				},
				{
					pitch = pitch_spread_m3 * 0.2,
					yaw = yaw_spread_m3 * 0.2,
				},
				{
					pitch = pitch_spread_m3 * 0.1,
					yaw = yaw_spread_m3 * 0.1,
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0,
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0,
				},
				{
					pitch = pitch_spread_m3 * 0.14,
					yaw = yaw_spread_m3 * 0.14,
				},
			},
		},
	},
	moving = {
		inherits = {
			"ogryn_heavystubber_spread_spraynpray_hip_m3",
			"still",
		},
		continuous_spread = {
			min_pitch = 1.8,
			min_yaw = 1.8,
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
					pitch = pitch_spread_m3 * 0.2,
					yaw = yaw_spread_m3 * 0.2,
				},
				{
					pitch = pitch_spread_m3 * 0.3,
					yaw = yaw_spread_m3 * 0.3,
				},
				{
					pitch = pitch_spread_m3 * 0.5,
					yaw = yaw_spread_m3 * 0.5,
				},
				{
					pitch = pitch_spread_m3 * 0.4,
					yaw = yaw_spread_m3 * 0.4,
				},
				{
					pitch = pitch_spread_m3 * 0.3,
					yaw = yaw_spread_m3 * 0.3,
				},
				{
					pitch = pitch_spread_m3 * 0.2,
					yaw = yaw_spread_m3 * 0.2,
				},
			},
		},
	},
	crouch_still = {
		inherits = {
			"ogryn_heavystubber_spread_spraynpray_hip_m3",
			"still",
		},
	},
	crouch_moving = {
		inherits = {
			"ogryn_heavystubber_spread_spraynpray_hip_m3",
			"still",
		},
	},
}
pitch_spread_m3 = 0.6
yaw_spread_m3 = pitch_spread_m3
spread_templates.ogryn_heavystubber_spread_spraynpray_braced_m3 = {
	still = {
		max_spread = {
			pitch = 3.4,
			yaw = 3,
		},
		decay = {
			from_shooting_grace_time = 0.025,
			shooting = {
				pitch = 0.5,
				yaw = 0.5,
			},
			idle = {
				pitch = 1.5,
				yaw = 1.5,
			},
		},
		continuous_spread = {
			min_pitch = 1.5,
			min_yaw = 1.5,
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
					pitch = pitch_spread_m3 * 0.01,
					yaw = yaw_spread_m3 * 0.01,
				},
				{
					pitch = pitch_spread_m3 * 0.01,
					yaw = yaw_spread_m3 * 0.01,
				},
				{
					pitch = pitch_spread_m3 * 0.02,
					yaw = yaw_spread_m3 * 0.02,
				},
				{
					pitch = pitch_spread_m3 * 0.04,
					yaw = yaw_spread_m3 * 0.04,
				},
				{
					pitch = pitch_spread_m3 * 0.05,
					yaw = yaw_spread_m3 * 0.05,
				},
				{
					pitch = pitch_spread_m3 * 0.08,
					yaw = yaw_spread_m3 * 0.08,
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0,
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0,
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0,
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0,
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0,
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0,
				},
				{
					pitch = pitch_spread_m3 * 0.1,
					yaw = yaw_spread_m3 * 0.1,
				},
				{
					pitch = pitch_spread_m3 * 0.2,
					yaw = yaw_spread_m3 * 0.2,
				},
				{
					pitch = pitch_spread_m3 * 0.1,
					yaw = yaw_spread_m3 * 0.1,
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0,
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0,
				},
				{
					pitch = pitch_spread_m3 * 0.1,
					yaw = yaw_spread_m3 * 0.1,
				},
				{
					pitch = pitch_spread_m3 * 0.2,
					yaw = yaw_spread_m3 * 0.2,
				},
				{
					pitch = pitch_spread_m3 * 0.1,
					yaw = yaw_spread_m3 * 0.1,
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0,
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0,
				},
				{
					pitch = pitch_spread_m3 * 0.1,
					yaw = yaw_spread_m3 * 0.1,
				},
				{
					pitch = pitch_spread_m3 * 0.2,
					yaw = yaw_spread_m3 * 0.2,
				},
				{
					pitch = pitch_spread_m3 * 0.1,
					yaw = yaw_spread_m3 * 0.1,
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0,
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0,
				},
				{
					pitch = pitch_spread_m3 * 0.1,
					yaw = yaw_spread_m3 * 0.1,
				},
				{
					pitch = pitch_spread_m3 * 0.2,
					yaw = yaw_spread_m3 * 0.2,
				},
				{
					pitch = pitch_spread_m3 * 0.1,
					yaw = yaw_spread_m3 * 0.1,
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0,
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0,
				},
				{
					pitch = pitch_spread_m3 * 0.1,
					yaw = yaw_spread_m3 * 0.1,
				},
				{
					pitch = pitch_spread_m3 * 0.2,
					yaw = yaw_spread_m3 * 0.2,
				},
				{
					pitch = pitch_spread_m3 * 0.1,
					yaw = yaw_spread_m3 * 0.1,
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0,
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0,
				},
				{
					pitch = pitch_spread_m3 * 0.1,
					yaw = yaw_spread_m3 * 0.1,
				},
				{
					pitch = pitch_spread_m3 * 0.2,
					yaw = yaw_spread_m3 * 0.2,
				},
				{
					pitch = pitch_spread_m3 * 0.1,
					yaw = yaw_spread_m3 * 0.1,
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0,
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0,
				},
				{
					pitch = pitch_spread_m3 * 0.1,
					yaw = yaw_spread_m3 * 0.1,
				},
				{
					pitch = pitch_spread_m3 * 0.2,
					yaw = yaw_spread_m3 * 0.2,
				},
				{
					pitch = pitch_spread_m3 * 0.1,
					yaw = yaw_spread_m3 * 0.1,
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0,
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0,
				},
				{
					pitch = pitch_spread_m3 * 0.1,
					yaw = yaw_spread_m3 * 0.1,
				},
				{
					pitch = pitch_spread_m3 * 0.2,
					yaw = yaw_spread_m3 * 0.2,
				},
				{
					pitch = pitch_spread_m3 * 0.1,
					yaw = yaw_spread_m3 * 0.1,
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0,
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0,
				},
				{
					pitch = pitch_spread_m3 * 0.1,
					yaw = yaw_spread_m3 * 0.1,
				},
				{
					pitch = pitch_spread_m3 * 0.2,
					yaw = yaw_spread_m3 * 0.2,
				},
				{
					pitch = pitch_spread_m3 * 0.1,
					yaw = yaw_spread_m3 * 0.1,
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0,
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0,
				},
				{
					pitch = pitch_spread_m3 * 0.1,
					yaw = yaw_spread_m3 * 0.1,
				},
				{
					pitch = pitch_spread_m3 * 0.2,
					yaw = yaw_spread_m3 * 0.2,
				},
				{
					pitch = pitch_spread_m3 * 0.1,
					yaw = yaw_spread_m3 * 0.1,
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0,
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0,
				},
				{
					pitch = pitch_spread_m3 * 0.1,
					yaw = yaw_spread_m3 * 0.1,
				},
				{
					pitch = pitch_spread_m3 * 0.2,
					yaw = yaw_spread_m3 * 0.2,
				},
				{
					pitch = pitch_spread_m3 * 0.1,
					yaw = yaw_spread_m3 * 0.1,
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0,
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0,
				},
				{
					pitch = pitch_spread_m3 * 0.1,
					yaw = yaw_spread_m3 * 0.1,
				},
				{
					pitch = pitch_spread_m3 * 0.2,
					yaw = yaw_spread_m3 * 0.2,
				},
				{
					pitch = pitch_spread_m3 * 0.1,
					yaw = yaw_spread_m3 * 0.1,
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0,
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0,
				},
				{
					pitch = pitch_spread_m3 * 0.14,
					yaw = yaw_spread_m3 * 0.14,
				},
			},
		},
	},
	moving = {
		inherits = {
			"ogryn_heavystubber_spread_spraynpray_braced_m3",
			"still",
		},
		continuous_spread = {
			min_pitch = 1.8,
			min_yaw = 1.8,
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
					pitch = pitch_spread_m3 * 0.2,
					yaw = yaw_spread_m3 * 0.2,
				},
				{
					pitch = pitch_spread_m3 * 0.3,
					yaw = yaw_spread_m3 * 0.3,
				},
				{
					pitch = pitch_spread_m3 * 0.5,
					yaw = yaw_spread_m3 * 0.5,
				},
				{
					pitch = pitch_spread_m3 * 0.4,
					yaw = yaw_spread_m3 * 0.4,
				},
				{
					pitch = pitch_spread_m3 * 0.3,
					yaw = yaw_spread_m3 * 0.3,
				},
				{
					pitch = pitch_spread_m3 * 0.2,
					yaw = yaw_spread_m3 * 0.2,
				},
			},
		},
	},
	crouch_still = {
		continuous_spread = {
			min_pitch = 1.2,
			min_yaw = 1.2,
		},
		inherits = {
			"ogryn_heavystubber_spread_spraynpray_braced_m3",
			"still",
		},
	},
	crouch_moving = {
		inherits = {
			"ogryn_heavystubber_spread_spraynpray_braced_m3",
			"still",
		},
	},
}
spread_templates.ogryn_heavystubber_p2_m1_spread_aim = {
	still = {
		max_spread = {
			pitch = 3.6,
			yaw = 3.6,
		},
		randomized_spread = {
			first_shot_min_ratio = 0.3,
			first_shot_random_ratio = 0.5,
			min_ratio = 0.1,
			random_ratio = 0.2,
		},
		decay = {
			from_shooting_grace_time = 0.1,
			shooting = {
				pitch = 0.675,
				yaw = 0.675,
			},
			idle = {
				pitch = 1.5,
				yaw = 1.5,
			},
		},
		continuous_spread = {
			min_pitch = {
				lerp_basic = 0.7,
				lerp_perfect = 0.2,
			},
			min_yaw = {
				lerp_basic = 0.7,
				lerp_perfect = 0.2,
			},
		},
		immediate_spread = {
			alternate_fire_start = {
				{
					pitch = 0.5,
					yaw = 0.5,
				},
			},
			damage_hit = {
				{
					pitch = 0,
					yaw = 0,
				},
			},
			shooting = {
				{
					pitch = {
						lerp_basic = 0.8,
						lerp_perfect = 0.3,
					},
					yaw = {
						lerp_basic = 0.8,
						lerp_perfect = 0.3,
					},
				},
			},
			num_shots_clear_time = {
				lerp_basic = 0.3,
				lerp_perfect = 0.3,
			},
		},
	},
	moving = {
		inherits = {
			"ogryn_heavystubber_p2_m1_spread_aim",
			"still",
		},
		continuous_spread = {
			min_pitch = {
				lerp_basic = 1.4,
				lerp_perfect = 0.5,
			},
			min_yaw = {
				lerp_basic = 1.4,
				lerp_perfect = 0.5,
			},
		},
	},
	crouch_still = {
		inherits = {
			"ogryn_heavystubber_p2_m1_spread_aim",
			"still",
		},
		continuous_spread = {
			min_pitch = {
				lerp_basic = 0.6,
				lerp_perfect = 0.15,
			},
			min_yaw = {
				lerp_basic = 0.6,
				lerp_perfect = 0.15,
			},
		},
	},
	crouch_moving = {
		inherits = {
			"ogryn_heavystubber_p2_m1_spread_aim",
			"still",
		},
		continuous_spread = {
			min_pitch = {
				lerp_basic = 1.4,
				lerp_perfect = 0.5,
			},
			min_yaw = {
				lerp_basic = 1.4,
				lerp_perfect = 0.5,
			},
		},
	},
}

local pitch_spread_p2_m1 = 2.6
local yaw_spread_p2_m1 = pitch_spread_p2_m1

spread_templates.ogryn_heavystubber_p2_m1_spread_hip = {
	still = {
		max_spread = {
			pitch = 5,
			yaw = 5,
		},
		decay = {
			from_shooting_grace_time = 0.025,
			shooting = {
				pitch = 0.5,
				yaw = 0.5,
			},
			idle = {
				pitch = 1,
				yaw = 1,
			},
		},
		continuous_spread = {
			min_pitch = 1.7,
			min_yaw = 1.7,
		},
		randomized_spread = {
			first_shot_min_ratio = 0.35,
			first_shot_random_ratio = 0.8,
			max_pitch_delta = 0.8,
			max_yaw_delta = 0.8,
			min_ratio = 0.2,
			random_ratio = 0.85,
		},
		immediate_spread = {
			num_shots_clear_time = 1.5,
			damage_hit = {
				{
					pitch = 0.4,
					yaw = 0.4,
				},
			},
			shooting = {
				{
					pitch = pitch_spread_p2_m1 * 0.03,
					yaw = yaw_spread_p2_m1 * 0.03,
				},
				{
					pitch = pitch_spread_p2_m1 * 0.02,
					yaw = yaw_spread_p2_m1 * 0.02,
				},
				{
					pitch = pitch_spread_p2_m1 * 0.03,
					yaw = yaw_spread_p2_m1 * 0.03,
				},
				{
					pitch = pitch_spread_p2_m1 * 0.06,
					yaw = yaw_spread_p2_m1 * 0.06,
				},
				{
					pitch = pitch_spread_p2_m1 * 0.1,
					yaw = yaw_spread_p2_m1 * 0.1,
				},
				{
					pitch = pitch_spread_p2_m1 * 0.2,
					yaw = yaw_spread_p2_m1 * 0.2,
				},
				{
					pitch = pitch_spread_p2_m1 * 0.1,
					yaw = yaw_spread_p2_m1 * 0.1,
				},
				{
					pitch = pitch_spread_p2_m1 * 0.2,
					yaw = yaw_spread_p2_m1 * 0.2,
				},
				{
					pitch = pitch_spread_p2_m1 * 0.3,
					yaw = yaw_spread_p2_m1 * 0.3,
				},
				{
					pitch = pitch_spread_p2_m1 * 0.2,
					yaw = yaw_spread_p2_m1 * 0.2,
				},
			},
		},
	},
	moving = {
		inherits = {
			"ogryn_heavystubber_p2_m1_spread_hip",
			"still",
		},
		continuous_spread = {
			min_pitch = 2.3,
			min_yaw = 2.3,
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
					pitch = pitch_spread_p2_m1 * 0.2,
					yaw = yaw_spread_p2_m1 * 0.2,
				},
				{
					pitch = pitch_spread_p2_m1 * 0.3,
					yaw = yaw_spread_p2_m1 * 0.3,
				},
				{
					pitch = pitch_spread_p2_m1 * 0.5,
					yaw = yaw_spread_p2_m1 * 0.5,
				},
				{
					pitch = pitch_spread_p2_m1 * 0.4,
					yaw = yaw_spread_p2_m1 * 0.4,
				},
				{
					pitch = pitch_spread_p2_m1 * 0.3,
					yaw = yaw_spread_p2_m1 * 0.3,
				},
				{
					pitch = pitch_spread_p2_m1 * 0.2,
					yaw = yaw_spread_p2_m1 * 0.2,
				},
			},
		},
	},
	crouch_still = {
		continuous_spread = {
			min_pitch = 1.2,
			min_yaw = 1.2,
		},
		inherits = {
			"ogryn_heavystubber_p2_m1_spread_hip",
			"still",
		},
	},
	crouch_moving = {
		inherits = {
			"ogryn_heavystubber_p2_m1_spread_hip",
			"still",
		},
	},
}
spread_templates.ogryn_heavystubber_p2_spread_aim = {
	still = {
		max_spread = {
			pitch = 3.6,
			yaw = 3.6,
		},
		randomized_spread = {
			first_shot_min_ratio = 0.3,
			first_shot_random_ratio = 0.5,
			min_ratio = 0.1,
			random_ratio = 0.2,
		},
		decay = {
			from_shooting_grace_time = 0.15,
			shooting = {
				pitch = 0.675,
				yaw = 0.675,
			},
			idle = {
				pitch = 1.5,
				yaw = 1.5,
			},
		},
		continuous_spread = {
			min_pitch = {
				lerp_basic = 0.9,
				lerp_perfect = 0.2,
			},
			min_yaw = {
				lerp_basic = 0.9,
				lerp_perfect = 0.2,
			},
		},
		immediate_spread = {
			alternate_fire_start = {
				{
					pitch = 0.1,
					yaw = 0.1,
				},
			},
			damage_hit = {
				{
					pitch = 0,
					yaw = 0,
				},
			},
			shooting = {
				{
					pitch = {
						lerp_basic = 0.75,
						lerp_perfect = 0.25,
					},
					yaw = {
						lerp_basic = 0.75,
						lerp_perfect = 0.25,
					},
				},
			},
			num_shots_clear_time = {
				lerp_basic = 0.6,
				lerp_perfect = 0.6,
			},
		},
	},
	moving = {
		inherits = {
			"ogryn_heavystubber_p2_spread_aim",
			"still",
		},
		continuous_spread = {
			min_pitch = {
				lerp_basic = 1.5,
				lerp_perfect = 0.5,
			},
			min_yaw = {
				lerp_basic = 1.5,
				lerp_perfect = 0.5,
			},
		},
	},
	crouch_still = {
		inherits = {
			"ogryn_heavystubber_p2_spread_aim",
			"still",
		},
		continuous_spread = {
			min_pitch = {
				lerp_basic = 0.6,
				lerp_perfect = 0.15,
			},
			min_yaw = {
				lerp_basic = 0.6,
				lerp_perfect = 0.15,
			},
		},
	},
	crouch_moving = {
		inherits = {
			"ogryn_heavystubber_p2_spread_aim",
			"still",
		},
		continuous_spread = {
			min_pitch = {
				lerp_basic = 1.3,
				lerp_perfect = 0.5,
			},
			min_yaw = {
				lerp_basic = 1.3,
				lerp_perfect = 0.5,
			},
		},
	},
}

local pitch_spread_p2_m2 = 2.8
local yaw_spread_p2_m2 = pitch_spread_p2_m2

spread_templates.ogryn_heavystubber_p2_m2_spread_hip = {
	still = {
		max_spread = {
			pitch = 5,
			yaw = 5,
		},
		decay = {
			from_shooting_grace_time = 0.025,
			shooting = {
				pitch = 0.5,
				yaw = 0.5,
			},
			idle = {
				pitch = 1,
				yaw = 1,
			},
		},
		continuous_spread = {
			min_pitch = 1.8,
			min_yaw = 1.8,
		},
		randomized_spread = {
			first_shot_min_ratio = 0.35,
			first_shot_random_ratio = 0.8,
			max_pitch_delta = 0.8,
			max_yaw_delta = 0.8,
			min_ratio = 0.2,
			random_ratio = 0.85,
		},
		immediate_spread = {
			num_shots_clear_time = 1.5,
			damage_hit = {
				{
					pitch = 0.4,
					yaw = 0.4,
				},
			},
			shooting = {
				{
					pitch = pitch_spread_p2_m2 * 0.04,
					yaw = yaw_spread_p2_m2 * 0.04,
				},
				{
					pitch = pitch_spread_p2_m2 * 0.05,
					yaw = yaw_spread_p2_m2 * 0.05,
				},
				{
					pitch = pitch_spread_p2_m2 * 0.07,
					yaw = yaw_spread_p2_m2 * 0.07,
				},
				{
					pitch = pitch_spread_p2_m2 * 0.09,
					yaw = yaw_spread_p2_m2 * 0.09,
				},
				{
					pitch = pitch_spread_p2_m2 * 0.1,
					yaw = yaw_spread_p2_m2 * 0.1,
				},
				{
					pitch = pitch_spread_p2_m2 * 0.2,
					yaw = yaw_spread_p2_m2 * 0.2,
				},
				{
					pitch = pitch_spread_p2_m2 * 0.1,
					yaw = yaw_spread_p2_m2 * 0.1,
				},
				{
					pitch = pitch_spread_p2_m2 * 0.2,
					yaw = yaw_spread_p2_m2 * 0.2,
				},
				{
					pitch = pitch_spread_p2_m2 * 0.3,
					yaw = yaw_spread_p2_m2 * 0.3,
				},
				{
					pitch = pitch_spread_p2_m2 * 0.2,
					yaw = yaw_spread_p2_m2 * 0.2,
				},
			},
		},
	},
	moving = {
		inherits = {
			"ogryn_heavystubber_p2_m2_spread_hip",
			"still",
		},
		continuous_spread = {
			min_pitch = 2.3,
			min_yaw = 2.3,
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
					pitch = pitch_spread_p2_m2 * 0.2,
					yaw = yaw_spread_p2_m2 * 0.2,
				},
				{
					pitch = pitch_spread_p2_m2 * 0.3,
					yaw = yaw_spread_p2_m2 * 0.3,
				},
				{
					pitch = pitch_spread_p2_m2 * 0.5,
					yaw = yaw_spread_p2_m2 * 0.5,
				},
				{
					pitch = pitch_spread_p2_m2 * 0.4,
					yaw = yaw_spread_p2_m2 * 0.4,
				},
				{
					pitch = pitch_spread_p2_m2 * 0.3,
					yaw = yaw_spread_p2_m2 * 0.3,
				},
				{
					pitch = pitch_spread_p2_m2 * 0.2,
					yaw = yaw_spread_p2_m2 * 0.2,
				},
			},
		},
	},
	crouch_still = {
		continuous_spread = {
			min_pitch = 1.5,
			min_yaw = 1.5,
		},
		inherits = {
			"ogryn_heavystubber_p2_m2_spread_hip",
			"still",
		},
	},
	crouch_moving = {
		inherits = {
			"ogryn_heavystubber_p2_m2_spread_hip",
			"still",
		},
	},
}

local pitch_spread_p2_m3 = 3
local yaw_spread_p2_m3 = pitch_spread_p2_m3

spread_templates.ogryn_heavystubber_p2_m3_spread_hip = {
	still = {
		max_spread = {
			pitch = 6,
			yaw = 6,
		},
		decay = {
			from_shooting_grace_time = 0.025,
			shooting = {
				pitch = 0.5,
				yaw = 0.5,
			},
			idle = {
				pitch = 1.2,
				yaw = 1.2,
			},
		},
		continuous_spread = {
			min_pitch = 2.3,
			min_yaw = 2.3,
		},
		immediate_spread = {
			num_shots_clear_time = 1.5,
			damage_hit = {
				{
					pitch = 0.4,
					yaw = 0.4,
				},
			},
			shooting = {
				{
					pitch = pitch_spread_p2_m3 * 0.05,
					yaw = yaw_spread_p2_m3 * 0.05,
				},
				{
					pitch = pitch_spread_p2_m3 * 0.09,
					yaw = yaw_spread_p2_m3 * 0.09,
				},
				{
					pitch = pitch_spread_p2_m3 * 0.3,
					yaw = yaw_spread_p2_m3 * 0.3,
				},
				{
					pitch = pitch_spread_p2_m3 * 0.7,
					yaw = yaw_spread_p2_m3 * 0.7,
				},
				{
					pitch = pitch_spread_p2_m3 * 0.4,
					yaw = yaw_spread_p2_m3 * 0.4,
				},
				{
					pitch = pitch_spread_p2_m3 * 0.3,
					yaw = yaw_spread_p2_m3 * 0.3,
				},
				{
					pitch = pitch_spread_p2_m3 * 0.3,
					yaw = yaw_spread_p2_m3 * 0.3,
				},
				{
					pitch = pitch_spread_p2_m3 * 0.4,
					yaw = yaw_spread_p2_m3 * 0.4,
				},
				{
					pitch = pitch_spread_p2_m3 * 0.3,
					yaw = yaw_spread_p2_m3 * 0.3,
				},
			},
		},
	},
	moving = {
		inherits = {
			"ogryn_heavystubber_p2_m3_spread_hip",
			"still",
		},
		continuous_spread = {
			min_pitch = 2.5,
			min_yaw = 2.5,
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
					pitch = pitch_spread_p2_m3 * 0.2,
					yaw = yaw_spread_p2_m3 * 0.2,
				},
				{
					pitch = pitch_spread_p2_m3 * 0.3,
					yaw = yaw_spread_p2_m3 * 0.3,
				},
				{
					pitch = pitch_spread_p2_m3 * 0.5,
					yaw = yaw_spread_p2_m3 * 0.5,
				},
				{
					pitch = pitch_spread_p2_m3 * 0.4,
					yaw = yaw_spread_p2_m3 * 0.4,
				},
				{
					pitch = pitch_spread_p2_m3 * 0.3,
					yaw = yaw_spread_p2_m3 * 0.3,
				},
				{
					pitch = pitch_spread_p2_m3 * 0.2,
					yaw = yaw_spread_p2_m3 * 0.2,
				},
			},
		},
	},
	crouch_still = {
		continuous_spread = {
			min_pitch = 1.7,
			min_yaw = 1.7,
		},
		inherits = {
			"ogryn_heavystubber_p2_m3_spread_hip",
			"still",
		},
	},
	crouch_moving = {
		inherits = {
			"ogryn_heavystubber_p2_m3_spread_hip",
			"still",
		},
	},
}
spread_templates.ogryn_heavystubber_p2_m3_spread_aim = {
	still = {
		max_spread = {
			pitch = 3.6,
			yaw = 3.6,
		},
		randomized_spread = {
			first_shot_min_ratio = 0.3,
			first_shot_random_ratio = 0.5,
			min_ratio = 0.1,
			random_ratio = 0.2,
		},
		decay = {
			from_shooting_grace_time = 0.15,
			shooting = {
				pitch = 0.675,
				yaw = 0.675,
			},
			idle = {
				pitch = 2,
				yaw = 2,
			},
		},
		continuous_spread = {
			min_pitch = {
				lerp_basic = 0.9,
				lerp_perfect = 0.2,
			},
			min_yaw = {
				lerp_basic = 0.9,
				lerp_perfect = 0.2,
			},
		},
		immediate_spread = {
			alternate_fire_start = {
				{
					pitch = 0.1,
					yaw = 0.1,
				},
			},
			damage_hit = {
				{
					pitch = 0,
					yaw = 0,
				},
			},
			shooting = {
				{
					pitch = {
						lerp_basic = 1.7,
						lerp_perfect = 0,
					},
					yaw = {
						lerp_basic = 1.7,
						lerp_perfect = 0,
					},
				},
			},
			num_shots_clear_time = {
				lerp_basic = 1,
				lerp_perfect = 1,
			},
		},
	},
	moving = {
		inherits = {
			"ogryn_heavystubber_p2_m3_spread_aim",
			"still",
		},
		continuous_spread = {
			min_pitch = {
				lerp_basic = 1.4,
				lerp_perfect = 0.5,
			},
			min_yaw = {
				lerp_basic = 1.4,
				lerp_perfect = 0.5,
			},
		},
	},
	crouch_still = {
		inherits = {
			"ogryn_heavystubber_p2_m3_spread_aim",
			"still",
		},
		continuous_spread = {
			min_pitch = {
				lerp_basic = 0.6,
				lerp_perfect = 0.15,
			},
			min_yaw = {
				lerp_basic = 0.6,
				lerp_perfect = 0.15,
			},
		},
	},
	crouch_moving = {
		inherits = {
			"ogryn_heavystubber_p2_m3_spread_aim",
			"still",
		},
		continuous_spread = {
			min_pitch = {
				lerp_basic = 1.3,
				lerp_perfect = 0.5,
			},
			min_yaw = {
				lerp_basic = 1.3,
				lerp_perfect = 0.5,
			},
		},
	},
}

return {
	base_templates = spread_templates,
	overrides = overrides,
}
