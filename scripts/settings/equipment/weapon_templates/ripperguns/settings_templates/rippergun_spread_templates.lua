﻿-- chunkname: @scripts/settings/equipment/weapon_templates/ripperguns/settings_templates/rippergun_spread_templates.lua

local spread_templates = {}
local overrides = {}

table.make_unique(spread_templates)
table.make_unique(overrides)

spread_templates.default_rippergun_assault = {
	still = {
		randomized_spread = {
			first_shot_min_ratio = 0.1,
			first_shot_random_ratio = 0.2,
			max_pitch_delta = 1,
			max_yaw_delta = 1,
			min_ratio = 0.1,
			random_ratio = 0.2,
		},
		max_spread = {
			pitch = 8.5,
			yaw = 8.5,
		},
		decay = {
			from_shooting_grace_time = 0.25,
			shooting = {
				pitch = 0.25,
				yaw = 0.25,
			},
			idle = {
				pitch = 1.5,
				yaw = 1.5,
			},
		},
		continuous_spread = {
			min_pitch = 4,
			min_yaw = 5.25,
		},
		immediate_spread = {
			num_shots_clear_time = 0.75,
			suppression_hit = {
				{
					pitch = 0.5,
					yaw = 0.5,
				},
			},
			damage_hit = {
				{
					pitch = 1.5,
					yaw = 1.5,
				},
			},
			shooting = {
				{
					pitch = 2.25,
					yaw = 2.25,
				},
			},
		},
		visual_spread_settings = {
			horizontal_speed = 1,
			intensity = 0.4,
			rotation_speed = 0.5,
			speed_change_frequency = 1,
			speed_variance_max = 1.25,
			speed_variance_min = 0.75,
		},
	},
	moving = {
		inherits = {
			"default_rippergun_assault",
			"still",
		},
	},
	crouch_still = {
		inherits = {
			"default_rippergun_assault",
			"still",
		},
	},
	crouch_moving = {
		inherits = {
			"default_rippergun_assault",
			"still",
		},
	},
}
spread_templates.default_rippergun_braced = {
	still = {
		randomized_spread = {
			first_shot_min_ratio = 0.1,
			first_shot_random_ratio = 0.2,
			max_pitch_delta = 0.5,
			max_yaw_delta = 0.5,
			min_ratio = 0.2,
			random_ratio = 0.8,
		},
		max_spread = {
			pitch = 8.5,
			yaw = 10.5,
		},
		decay = {
			from_shooting_grace_time = 0.25,
			shooting = {
				pitch = 0.25,
				yaw = 0.25,
			},
			idle = {
				pitch = 1.5,
				yaw = 1.5,
			},
		},
		continuous_spread = {
			min_pitch = 2,
			min_yaw = 5,
		},
		immediate_spread = {
			num_shots_clear_time = 0.4,
			suppression_hit = {
				{
					pitch = 0.5,
					yaw = 0.5,
				},
			},
			damage_hit = {
				{
					pitch = 1.5,
					yaw = 1.5,
				},
			},
			shooting = {
				{
					pitch = 0.2,
					yaw = 0.8,
				},
				{
					pitch = 0.15000000000000002,
					yaw = 0.6000000000000001,
				},
				{
					pitch = 0.1,
					yaw = 0.4,
				},
				{
					pitch = 0.05,
					yaw = 0.2,
				},
				{
					pitch = 0.020000000000000004,
					yaw = 0.08000000000000002,
				},
			},
		},
		visual_spread_settings = {
			horizontal_speed = 1,
			intensity = 0.4,
			rotation_speed = 0.5,
			speed_change_frequency = 1,
			speed_variance_max = 1.25,
			speed_variance_min = 0.75,
		},
	},
	moving = {
		inherits = {
			"default_rippergun_braced",
			"still",
		},
	},
	crouch_still = {
		inherits = {
			"default_rippergun_braced",
			"still",
		},
	},
	crouch_moving = {
		inherits = {
			"default_rippergun_braced",
			"still",
		},
	},
}
spread_templates.rippergun_p1_m2_assault = {
	still = {
		randomized_spread = {
			first_shot_min_ratio = 0.1,
			first_shot_random_ratio = 0.2,
			max_pitch_delta = 1,
			max_yaw_delta = 1,
			min_ratio = 0.1,
			random_ratio = 0.2,
		},
		max_spread = {
			pitch = 8.5,
			yaw = 8.5,
		},
		decay = {
			from_shooting_grace_time = 0.25,
			shooting = {
				pitch = 0.25,
				yaw = 0.25,
			},
			idle = {
				pitch = 1.5,
				yaw = 1.5,
			},
		},
		continuous_spread = {
			min_pitch = 3,
			min_yaw = 3.9375,
		},
		immediate_spread = {
			num_shots_clear_time = 0.75,
			suppression_hit = {
				{
					pitch = 0.5,
					yaw = 0.5,
				},
			},
			damage_hit = {
				{
					pitch = 1.5,
					yaw = 1.5,
				},
			},
			shooting = {
				{
					pitch = 1.25,
					yaw = 1.25,
				},
			},
		},
		visual_spread_settings = {
			horizontal_speed = 1,
			intensity = 0.4,
			rotation_speed = 0.5,
			speed_change_frequency = 1,
			speed_variance_max = 1.25,
			speed_variance_min = 0.75,
		},
	},
	moving = {
		inherits = {
			"rippergun_p1_m2_assault",
			"still",
		},
	},
	crouch_still = {
		inherits = {
			"rippergun_p1_m2_assault",
			"still",
		},
	},
	crouch_moving = {
		inherits = {
			"rippergun_p1_m2_assault",
			"still",
		},
	},
}
spread_templates.rippergun_p1_m2_braced = {
	still = {
		randomized_spread = {
			first_shot_min_ratio = 0.1,
			first_shot_random_ratio = 0.5,
			max_pitch_delta = 0.75,
			max_yaw_delta = 0.75,
			min_ratio = 0.2,
			random_ratio = 0.8,
		},
		max_spread = {
			pitch = 8.5,
			yaw = 10.5,
		},
		decay = {
			from_shooting_grace_time = 0.25,
			shooting = {
				pitch = 0.25,
				yaw = 0.25,
			},
			idle = {
				pitch = 1.5,
				yaw = 1.5,
			},
		},
		continuous_spread = {
			min_pitch = 1.5,
			min_yaw = 3.75,
		},
		immediate_spread = {
			num_shots_clear_time = 0.4,
			suppression_hit = {
				{
					pitch = 0.5,
					yaw = 0.5,
				},
			},
			damage_hit = {
				{
					pitch = 1.5,
					yaw = 1.5,
				},
			},
			shooting = {
				{
					pitch = 0.2,
					yaw = 0.8,
				},
				{
					pitch = 0.15000000000000002,
					yaw = 0.6000000000000001,
				},
				{
					pitch = 0.1,
					yaw = 0.4,
				},
				{
					pitch = 0.05,
					yaw = 0.2,
				},
				{
					pitch = 0.020000000000000004,
					yaw = 0.08000000000000002,
				},
			},
		},
		visual_spread_settings = {
			horizontal_speed = 1,
			intensity = 0.4,
			rotation_speed = 0.5,
			speed_change_frequency = 1,
			speed_variance_max = 1.25,
			speed_variance_min = 0.75,
		},
	},
	moving = {
		inherits = {
			"rippergun_p1_m2_braced",
			"still",
		},
	},
	crouch_still = {
		inherits = {
			"rippergun_p1_m2_braced",
			"still",
		},
	},
	crouch_moving = {
		inherits = {
			"rippergun_p1_m2_braced",
			"still",
		},
	},
}
spread_templates.rippergun_p1_m3_assault = {
	still = {
		randomized_spread = {
			first_shot_min_ratio = 0.1,
			first_shot_random_ratio = 0.25,
			max_pitch_delta = 1,
			max_yaw_delta = 1,
			min_ratio = 0.1,
			random_ratio = 0.5,
		},
		max_spread = {
			pitch = 8.5,
			yaw = 8.5,
		},
		decay = {
			from_shooting_grace_time = 0.25,
			shooting = {
				pitch = 0.25,
				yaw = 0.25,
			},
			idle = {
				pitch = 1.5,
				yaw = 1.5,
			},
		},
		continuous_spread = {
			min_pitch = 3,
			min_yaw = 4.25,
		},
		immediate_spread = {
			num_shots_clear_time = 0.75,
			suppression_hit = {
				{
					pitch = 0.5,
					yaw = 0.5,
				},
			},
			damage_hit = {
				{
					pitch = 1.5,
					yaw = 1.5,
				},
			},
			shooting = {
				{
					pitch = 0.75,
					yaw = 0.75,
				},
			},
		},
		visual_spread_settings = {
			horizontal_speed = 1,
			intensity = 0.4,
			rotation_speed = 0.5,
			speed_change_frequency = 1,
			speed_variance_max = 1.25,
			speed_variance_min = 0.75,
		},
	},
	moving = {
		inherits = {
			"rippergun_p1_m3_assault",
			"still",
		},
	},
	crouch_still = {
		inherits = {
			"rippergun_p1_m3_assault",
			"still",
		},
	},
	crouch_moving = {
		inherits = {
			"rippergun_p1_m3_assault",
			"still",
		},
	},
}

return {
	base_templates = spread_templates,
	overrides = overrides,
}
