-- chunkname: @scripts/settings/equipment/weapon_templates/shotpistol_shield/settings_templates/shotpistol_shield_spread_templates.lua

local spread_templates = {}
local overrides = {}

table.make_unique(spread_templates)
table.make_unique(overrides)

spread_templates.default_shotpistol_shield_hip = {
	still = {
		max_spread = {
			pitch = 2,
			yaw = 2,
		},
		decay = {
			from_shooting_grace_time = 0.075,
			shooting = {
				pitch = 0.15,
				yaw = 0.15,
			},
			idle = {
				pitch = 3.5,
				yaw = 3.5,
			},
		},
		randomized_spread = {
			first_shot_min_ratio = 0.3,
			first_shot_random_ratio = 0.3,
			min_ratio = 0.15,
			random_ratio = 0.3,
		},
		continuous_spread = {
			min_pitch = 0.7,
			min_yaw = 0.7,
		},
		immediate_spread = {
			num_shots_clear_time = 1.1,
			damage_hit = {
				{
					pitch = 0.4,
					yaw = 0.4,
				},
			},
			shooting = {
				{
					pitch = 0.3,
					yaw = 0.3,
				},
				{
					pitch = 1.4,
					yaw = 1,
				},
				{
					pitch = 1.6,
					yaw = 1.5,
				},
				{
					pitch = 1.3,
					yaw = 1.7,
				},
			},
		},
	},
	moving = {
		inherits = {
			"default_shotpistol_shield_hip",
			"still",
		},
		continuous_spread = {
			min_pitch = 1.2,
			min_yaw = 1.2,
		},
	},
	crouch_still = {
		inherits = {
			"default_shotpistol_shield_hip",
			"still",
		},
		continuous_spread = {
			min_pitch = 0.25,
			min_yaw = 0.25,
		},
	},
	crouch_moving = {
		inherits = {
			"default_shotpistol_shield_hip",
			"still",
		},
		continuous_spread = {
			min_pitch = 0.75,
			min_yaw = 0.75,
		},
	},
}
spread_templates.default_shotpistol_shield_ads = {
	still = {
		max_spread = {
			pitch = 2.5,
			yaw = 2.5,
		},
		decay = {
			crouch_transition_grace_time = 0.5,
			enter_alternate_fire_grace_time = 0.5,
			from_shooting_grace_time = 0.15,
			shooting = {
				pitch = {
					lerp_basic = 0.5,
					lerp_perfect = 0.8,
				},
				yaw = {
					lerp_basic = 0.5,
					lerp_perfect = 0.8,
				},
			},
			idle = {
				pitch = {
					lerp_basic = 1.5,
					lerp_perfect = 2,
				},
				yaw = {
					lerp_basic = 1.5,
					lerp_perfect = 2,
				},
			},
			player_event = {
				pitch = {
					lerp_basic = 40,
					lerp_perfect = 50,
				},
				yaw = {
					lerp_basic = 40,
					lerp_perfect = 50,
				},
			},
		},
		continuous_spread = {
			min_pitch = 0,
			min_yaw = 0,
		},
		immediate_spread = {
			num_shots_clear_time = 0.5,
			alternate_fire_start = {
				{
					pitch = {
						lerp_basic = 0.2,
						lerp_perfect = 0,
					},
					yaw = {
						lerp_basic = 0.2,
						lerp_perfect = 0.01,
					},
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
					pitch = 0,
					yaw = 0,
				},
			},
		},
	},
	moving = {
		inherits = {
			"default_shotpistol_shield_ads",
			"still",
		},
		continuous_spread = {
			min_pitch = 0,
			min_yaw = 0,
		},
	},
	crouch_still = {
		inherits = {
			"default_shotpistol_shield_ads",
			"still",
		},
		continuous_spread = {
			min_pitch = 0,
			min_yaw = 0,
		},
	},
	crouch_moving = {
		inherits = {
			"default_shotpistol_shield_ads",
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
