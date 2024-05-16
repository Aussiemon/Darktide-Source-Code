-- chunkname: @scripts/settings/equipment/weapon_templates/shotguns/settings_templates/shotgun_spread_templates.lua

local spread_templates = {}
local overrides = {}

table.make_unique(spread_templates)
table.make_unique(overrides)

spread_templates.default_shotgun_assault = {
	still = {
		max_spread = {
			pitch = 7.5,
			yaw = 7.5,
		},
		decay = {
			from_shooting_grace_time = 0.25,
			shooting = {
				pitch = 0.15,
				yaw = 0.15,
			},
			idle = {
				pitch = 1,
				yaw = 1,
			},
		},
		randomized_spread = {
			first_shot_min_ratio = 0.05,
			first_shot_random_ratio = 0.25,
			min_ratio = 0.1,
			random_ratio = 0.2,
		},
		continuous_spread = {
			min_pitch = {
				lerp_basic = 3.75,
				lerp_perfect = 3.25,
			},
			min_yaw = {
				lerp_basic = 3.75,
				lerp_perfect = 3.25,
			},
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
					pitch = {
						lerp_basic = 1,
						lerp_perfect = 0.5,
					},
					yaw = {
						lerp_basic = 1,
						lerp_perfect = 0.5,
					},
				},
				{
					pitch = {
						lerp_basic = 1.2,
						lerp_perfect = 0.8,
					},
					yaw = {
						lerp_basic = 1.2,
						lerp_perfect = 0.8,
					},
				},
				{
					pitch = {
						lerp_basic = 1,
						lerp_perfect = 0.5,
					},
					yaw = {
						lerp_basic = 1,
						lerp_perfect = 0.5,
					},
				},
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
		},
	},
	moving = {
		continuous_spread = {
			min_pitch = {
				lerp_basic = 4.25,
				lerp_perfect = 3.75,
			},
			min_yaw = {
				lerp_basic = 4.25,
				lerp_perfect = 3.75,
			},
		},
		inherits = {
			"default_shotgun_assault",
			"still",
		},
	},
	crouch_still = {
		continuous_spread = {
			min_pitch = {
				lerp_basic = 3.5,
				lerp_perfect = 3,
			},
			min_yaw = {
				lerp_basic = 3.5,
				lerp_perfect = 3,
			},
		},
		inherits = {
			"default_shotgun_assault",
			"still",
		},
	},
	crouch_moving = {
		continuous_spread = {
			min_pitch = {
				lerp_basic = 4,
				lerp_perfect = 3.5,
			},
			min_yaw = {
				lerp_basic = 4,
				lerp_perfect = 3.5,
			},
		},
		inherits = {
			"default_shotgun_assault",
			"still",
		},
	},
}
spread_templates.shotgun_p1_m2_assault = {
	still = {
		max_spread = {
			pitch = 3.75,
			yaw = 3.75,
		},
		decay = {
			from_shooting_grace_time = 0.25,
			shooting = {
				pitch = 0.15,
				yaw = 0.15,
			},
			idle = {
				pitch = 1,
				yaw = 1,
			},
		},
		randomized_spread = {
			first_shot_min_ratio = 0.05,
			first_shot_random_ratio = 0.25,
			min_ratio = 0.1,
			random_ratio = 0.2,
		},
		continuous_spread = {
			min_pitch = {
				lerp_basic = 1.875,
				lerp_perfect = 1.625,
			},
			min_yaw = {
				lerp_basic = 1.875,
				lerp_perfect = 1.625,
			},
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
					pitch = {
						lerp_basic = 1,
						lerp_perfect = 0.5,
					},
					yaw = {
						lerp_basic = 1,
						lerp_perfect = 0.5,
					},
				},
				{
					pitch = {
						lerp_basic = 1.2,
						lerp_perfect = 0.8,
					},
					yaw = {
						lerp_basic = 1.2,
						lerp_perfect = 0.8,
					},
				},
				{
					pitch = {
						lerp_basic = 1,
						lerp_perfect = 0.5,
					},
					yaw = {
						lerp_basic = 1,
						lerp_perfect = 0.5,
					},
				},
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
		},
	},
	moving = {
		continuous_spread = {
			min_pitch = {
				lerp_basic = 2.125,
				lerp_perfect = 1.875,
			},
			min_yaw = {
				lerp_basic = 2.125,
				lerp_perfect = 1.875,
			},
		},
		inherits = {
			"shotgun_p1_m2_assault",
			"still",
		},
	},
	crouch_still = {
		continuous_spread = {
			min_pitch = {
				lerp_basic = 1.75,
				lerp_perfect = 1.5,
			},
			min_yaw = {
				lerp_basic = 1.75,
				lerp_perfect = 1.5,
			},
		},
		inherits = {
			"shotgun_p1_m2_assault",
			"still",
		},
	},
	crouch_moving = {
		continuous_spread = {
			min_pitch = {
				lerp_basic = 2,
				lerp_perfect = 1.75,
			},
			min_yaw = {
				lerp_basic = 2,
				lerp_perfect = 1.75,
			},
		},
		inherits = {
			"shotgun_p1_m2_assault",
			"still",
		},
	},
}
spread_templates.shotgun_p1_m3_assault = {
	still = {
		max_spread = {
			pitch = 9.375,
			yaw = 9.375,
		},
		decay = {
			from_shooting_grace_time = 0.25,
			shooting = {
				pitch = 0.15,
				yaw = 0.15,
			},
			idle = {
				pitch = 1,
				yaw = 1,
			},
		},
		randomized_spread = {
			first_shot_min_ratio = 0.05,
			first_shot_random_ratio = 0.25,
			min_ratio = 0.1,
			random_ratio = 0.2,
		},
		continuous_spread = {
			min_pitch = {
				lerp_basic = 4.6875,
				lerp_perfect = 4.0625,
			},
			min_yaw = {
				lerp_basic = 4.6875,
				lerp_perfect = 4.0625,
			},
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
					pitch = {
						lerp_basic = 1,
						lerp_perfect = 0.5,
					},
					yaw = {
						lerp_basic = 1,
						lerp_perfect = 0.5,
					},
				},
				{
					pitch = {
						lerp_basic = 1.2,
						lerp_perfect = 0.8,
					},
					yaw = {
						lerp_basic = 1.2,
						lerp_perfect = 0.8,
					},
				},
				{
					pitch = {
						lerp_basic = 1,
						lerp_perfect = 0.5,
					},
					yaw = {
						lerp_basic = 1,
						lerp_perfect = 0.5,
					},
				},
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
		},
	},
	moving = {
		continuous_spread = {
			min_pitch = {
				lerp_basic = 5.3125,
				lerp_perfect = 4.6875,
			},
			min_yaw = {
				lerp_basic = 5.3125,
				lerp_perfect = 4.6875,
			},
		},
		inherits = {
			"shotgun_p1_m3_assault",
			"still",
		},
	},
	crouch_still = {
		continuous_spread = {
			min_pitch = {
				lerp_basic = 4.375,
				lerp_perfect = 3.75,
			},
			min_yaw = {
				lerp_basic = 4.375,
				lerp_perfect = 3.75,
			},
		},
		inherits = {
			"shotgun_p1_m3_assault",
			"still",
		},
	},
	crouch_moving = {
		continuous_spread = {
			min_pitch = {
				lerp_basic = 5,
				lerp_perfect = 4.375,
			},
			min_yaw = {
				lerp_basic = 5,
				lerp_perfect = 4.375,
			},
		},
		inherits = {
			"shotgun_p1_m3_assault",
			"still",
		},
	},
}
spread_templates.default_shotgun_killshot = {
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
				pitch = 0.5,
				yaw = 0.5,
			},
			idle = {
				pitch = 1.5,
				yaw = 1.5,
			},
			player_event = {
				pitch = 4,
				yaw = 4,
			},
		},
		continuous_spread = {
			min_pitch = 0,
			min_yaw = 0,
		},
		immediate_spread = {
			num_shots_clear_time = 0.6,
			alternate_fire_start = {
				{
					pitch = 0,
					yaw = 0,
				},
			},
			crouching_transition = {
				{
					pitch = 0,
					yaw = 0,
				},
			},
			suppression_hit = {
				{
					pitch = 0,
					yaw = 0,
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
			"default_shotgun_killshot",
			"still",
		},
		continuous_spread = {
			min_pitch = 0.15,
			min_yaw = 0.15,
		},
		decay = {
			crouch_transition_grace_time = 0.5,
			enter_alternate_fire_grace_time = 0.5,
			from_shooting_grace_time = 0.15,
			shooting = {
				pitch = 0.5,
				yaw = 0.5,
			},
			idle = {
				pitch = 1.5,
				yaw = 1.5,
			},
			player_event = {
				pitch = 3,
				yaw = 3,
			},
		},
		visual_spread_settings = {
			horizontal_speed = 2,
			intensity = 0.5,
			rotation_speed = 0.5,
			speed_change_frequency = 1,
			speed_variance_max = 1.25,
			speed_variance_min = 0.75,
		},
	},
	crouch_still = {
		inherits = {
			"default_shotgun_killshot",
			"still",
		},
		continuous_spread = {
			min_pitch = 0.25,
			min_yaw = 0.25,
		},
		decay = {
			from_shooting_grace_time = 0.15,
			shooting = {
				pitch = 0.5,
				yaw = 0.5,
			},
			idle = {
				pitch = 1.75,
				yaw = 1.75,
			},
		},
	},
	crouch_moving = {
		continuous_spread = {
			min_pitch = 0.65,
			min_yaw = 0.65,
		},
		inherits = {
			"default_shotgun_killshot",
			"still",
		},
	},
}

return {
	base_templates = spread_templates,
	overrides = overrides,
}
