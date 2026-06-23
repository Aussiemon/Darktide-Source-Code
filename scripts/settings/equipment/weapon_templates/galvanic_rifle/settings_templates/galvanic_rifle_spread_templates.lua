-- chunkname: @scripts/settings/equipment/weapon_templates/galvanic_rifle/settings_templates/galvanic_rifle_spread_templates.lua

local spread_templates = {}
local overrides = {}

table.make_unique(spread_templates)
table.make_unique(overrides)

spread_templates.galvanic_rifle_p1_spread_hip = {
	still = {
		max_spread = {
			pitch = 5.5,
			yaw = 5.5,
		},
		randomized_spread = {
			first_shot_min_ratio = 0.05,
			first_shot_random_ratio = 0.05,
			min_ratio = 0.35,
			random_ratio = 0.25,
		},
		decay = {
			from_shooting_grace_time = 0.45,
			shooting = {
				pitch = 2.3,
				yaw = 2.3,
			},
			idle = {
				pitch = 2.75,
				yaw = 2.75,
			},
		},
		continuous_spread = {
			min_pitch = {
				lerp_basic = 2.3,
				lerp_perfect = 1.5,
			},
			min_yaw = {
				lerp_basic = 3,
				lerp_perfect = 1.5,
			},
		},
		immediate_spread = {
			num_shots_clear_time = 0.55,
			damage_hit = {
				{
					pitch = 0.4,
					yaw = 0.4,
				},
			},
			shooting = {
				{
					pitch = 4.7,
					yaw = 4.7,
				},
				{
					pitch = 4.65,
					yaw = 4.65,
				},
				{
					pitch = 4.5,
					yaw = 4.5,
				},
			},
		},
	},
	moving = {
		inherits = {
			"galvanic_rifle_p1_spread_hip",
			"still",
		},
		continuous_spread = {
			min_pitch = {
				lerp_basic = 2.2,
				lerp_perfect = 1.4,
			},
			min_yaw = {
				lerp_basic = 2.2,
				lerp_perfect = 1.4,
			},
		},
	},
	crouch_still = {
		inherits = {
			"galvanic_rifle_p1_spread_hip",
			"still",
		},
		continuous_spread = {
			min_pitch = {
				lerp_basic = 1.4,
				lerp_perfect = 1,
			},
			min_yaw = {
				lerp_basic = 1.4,
				lerp_perfect = 1,
			},
		},
	},
	crouch_moving = {
		inherits = {
			"galvanic_rifle_p1_spread_hip",
			"still",
		},
		continuous_spread = {
			min_pitch = {
				lerp_basic = 2,
				lerp_perfect = 1.2,
			},
			min_yaw = {
				lerp_basic = 2,
				lerp_perfect = 1.2,
			},
		},
	},
}
spread_templates.galvanic_rifle_p1_m1_ads_spread = {
	still = {
		max_spread = {
			pitch = 2,
			yaw = 2,
		},
		decay = {
			from_shooting_grace_time = 0.1,
			shooting = {
				pitch = 0.45,
				yaw = 0.45,
			},
			idle = {
				pitch = 3.25,
				yaw = 3.25,
			},
		},
		continuous_spread = {
			min_pitch = 0,
			min_yaw = 0,
		},
		immediate_spread = {
			num_shots_clear_time = 0.35,
			damage_hit = {
				{
					pitch = 0.4,
					yaw = 0.4,
				},
			},
			shooting = {
				{
					pitch = 0.5,
					yaw = 0.3,
				},
				{
					pitch = 0.4,
					yaw = 0.3,
				},
				{
					pitch = 0.3,
					yaw = 0.3,
				},
				{
					pitch = 0.301,
					yaw = 0.401,
				},
				{
					pitch = 0.301,
					yaw = 0.301,
				},
				{
					pitch = 0.401,
					yaw = 0.301,
				},
				{
					pitch = 0.302,
					yaw = 0.402,
				},
			},
		},
	},
	moving = {
		inherits = {
			"galvanic_rifle_p1_m1_ads_spread",
			"still",
		},
		continuous_spread = {
			min_pitch = 0,
			min_yaw = 0,
		},
	},
	crouch_still = {
		inherits = {
			"galvanic_rifle_p1_m1_ads_spread",
			"still",
		},
		continuous_spread = {
			min_pitch = 0,
			min_yaw = 0,
		},
	},
	crouch_moving = {
		inherits = {
			"galvanic_rifle_p1_m1_ads_spread",
			"still",
		},
		continuous_spread = {
			min_pitch = 0,
			min_yaw = 0,
		},
	},
}

return {
	base_templates = spread_templates,
	overrides = overrides,
}
