-- chunkname: @scripts/settings/equipment/weapon_templates/bolters/settings_templates/bolter_spread_templates.lua

local spread_templates = {}
local overrides = {}

table.make_unique(spread_templates)
table.make_unique(overrides)

spread_templates.default_bolter_killshot = {
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
			"default_bolter_killshot",
			"still",
		},
		continuous_spread = {
			min_pitch = 0,
			min_yaw = 0,
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
			"default_bolter_killshot",
			"still",
		},
		continuous_spread = {
			min_pitch = 0,
			min_yaw = 0,
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
			min_pitch = 0,
			min_yaw = 0,
		},
		inherits = {
			"default_bolter_killshot",
			"still",
		},
	},
}
spread_templates.default_bolter_spraynpray = {
	still = {
		randomized_spread = {
			first_shot_min_ratio = 0.5,
			first_shot_random_ratio = 0.5,
			max_pitch_delta = 1,
			max_yaw_delta = 1,
			min_ratio = 0.25,
			random_ratio = 0.75,
		},
		max_spread = {
			pitch = {
				lerp_basic = 4,
				lerp_perfect = 2,
			},
			yaw = {
				lerp_basic = 4,
				lerp_perfect = 2,
			},
		},
		decay = {
			from_shooting_grace_time = 0.2,
			shooting = {
				pitch = 0.05,
				yaw = 0.05,
			},
			idle = {
				pitch = 1.5,
				yaw = 2,
			},
		},
		continuous_spread = {
			min_pitch = {
				lerp_basic = 1,
				lerp_perfect = 0.25,
			},
			min_yaw = {
				lerp_basic = 1.5,
				lerp_perfect = 0.75,
			},
		},
		immediate_spread = {
			num_shots_clear_time = 0.25,
			damage_hit = {
				{
					pitch = {
						lerp_basic = 0.5,
						lerp_perfect = 0.3,
					},
					yaw = {
						lerp_basic = 0.5,
						lerp_perfect = 0.3,
					},
				},
			},
			shooting = {
				{
					pitch = {
						lerp_basic = 0.3,
						lerp_perfect = 0.15,
					},
					yaw = {
						lerp_basic = 2,
						lerp_perfect = 1.25,
					},
				},
				{
					pitch = {
						lerp_basic = 0.22499999999999998,
						lerp_perfect = 0.11249999999999999,
					},
					yaw = {
						lerp_basic = 0.75,
						lerp_perfect = 0.1875,
					},
				},
				{
					pitch = {
						lerp_basic = 0.15,
						lerp_perfect = 0.075,
					},
					yaw = {
						lerp_basic = 0.5,
						lerp_perfect = 0.125,
					},
				},
			},
		},
	},
	moving = {
		inherits = {
			"default_bolter_spraynpray",
			"still",
		},
		continuous_spread = {
			min_pitch = {
				lerp_basic = 1.5,
				lerp_perfect = 1,
			},
			min_yaw = {
				lerp_basic = 2,
				lerp_perfect = 1.5,
			},
		},
	},
	crouch_still = {
		inherits = {
			"default_bolter_spraynpray",
			"still",
		},
		continuous_spread = {
			min_pitch = {
				lerp_basic = 1,
				lerp_perfect = 0.1,
			},
			min_yaw = {
				lerp_basic = 1.5,
				lerp_perfect = 0.4,
			},
		},
	},
	crouch_moving = {
		inherits = {
			"default_bolter_spraynpray",
			"still",
		},
	},
}
spread_templates.bolter_p1_m2_spraynpray = {
	still = {
		randomized_spread = {
			first_shot_min_ratio = 0.75,
			first_shot_random_ratio = 0.25,
			max_pitch_delta = 0.7,
			max_yaw_delta = 0.7,
			min_ratio = 0.2,
			random_ratio = 0.75,
		},
		max_spread = {
			pitch = 3,
			yaw = 4,
		},
		decay = {
			from_shooting_grace_time = 0.2,
			shooting = {
				pitch = 0.05,
				yaw = 0.05,
			},
			idle = {
				pitch = 1.5,
				yaw = 2,
			},
		},
		continuous_spread = {
			min_pitch = 0.5,
			min_yaw = 0.5,
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
					pitch = 0.3,
					yaw = 0.4,
				},
			},
		},
	},
	moving = {
		inherits = {
			"default_bolter_spraynpray",
			"still",
		},
		continuous_spread = {
			min_pitch = 1,
			min_yaw = 1,
		},
	},
	crouch_still = {
		inherits = {
			"default_bolter_spraynpray",
			"still",
		},
	},
	crouch_moving = {
		inherits = {
			"default_bolter_spraynpray",
			"still",
		},
	},
}

return {
	base_templates = spread_templates,
	overrides = overrides,
}
