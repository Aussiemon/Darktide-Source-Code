-- chunkname: @scripts/settings/equipment/weapon_templates/stub_pistols/settings_templates/stub_pistol_spread_templates.lua

local spread_templates = {}
local overrides = {}

table.make_unique(spread_templates)
table.make_unique(overrides)

spread_templates.default_stub_pistol_assault = {
	still = {
		max_spread = {
			pitch = 5,
			yaw = 5,
		},
		decay = {
			from_shooting_grace_time = 0.075,
			shooting = {
				pitch = 0.15,
				yaw = 0.15,
			},
			idle = {
				pitch = 4.5,
				yaw = 4.5,
			},
		},
		randomized_spread = {
			first_shot_min_ratio = 0.3,
			first_shot_random_ratio = 0.6,
			min_ratio = 0.15,
			random_ratio = 0.5,
		},
		continuous_spread = {
			min_pitch = 1.5,
			min_yaw = 1.5,
		},
		immediate_spread = {
			num_shots_clear_time = 0.5,
			damage_hit = {
				{
					pitch = 0.4,
					yaw = 0.4,
				},
			},
			shooting = {
				{
					pitch = 7.5,
					yaw = 7.5,
				},
			},
		},
	},
	moving = {
		inherits = {
			"default_stub_pistol_assault",
			"still",
		},
		continuous_spread = {
			min_pitch = 3,
			min_yaw = 3,
		},
	},
	crouch_still = {
		inherits = {
			"default_stub_pistol_assault",
			"still",
		},
		continuous_spread = {
			min_pitch = 2.25,
			min_yaw = 2.25,
		},
	},
	crouch_moving = {
		inherits = {
			"default_stub_pistol_assault",
			"still",
		},
		continuous_spread = {
			min_pitch = 2.75,
			min_yaw = 2.75,
		},
	},
}
spread_templates.default_stub_pistol_killshot = {
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
			"default_stub_pistol_killshot",
			"still",
		},
		continuous_spread = {
			min_pitch = 0,
			min_yaw = 0,
		},
	},
	crouch_still = {
		inherits = {
			"default_stub_pistol_killshot",
			"still",
		},
		continuous_spread = {
			min_pitch = 0,
			min_yaw = 0,
		},
	},
	crouch_moving = {
		inherits = {
			"default_stub_pistol_killshot",
			"still",
		},
		continuous_spread = {
			min_pitch = 0,
			min_yaw = 0,
		},
	},
}

local p1_m2_modifier = 0.8

spread_templates.stub_pistol_p1_m2_hip = {
	still = {
		max_spread = {
			pitch = 5,
			yaw = 5,
		},
		decay = {
			from_shooting_grace_time = 0.075,
			shooting = {
				pitch = 0.15,
				yaw = 0.15,
			},
			idle = {
				pitch = 4.5,
				yaw = 4.5,
			},
		},
		continuous_spread = {
			min_pitch = 1.5 * p1_m2_modifier,
			min_yaw = 1.5 * p1_m2_modifier,
		},
		immediate_spread = {
			num_shots_clear_time = 0.5,
			damage_hit = {
				{
					pitch = 0.4 * p1_m2_modifier,
					yaw = 0.4 * p1_m2_modifier,
				},
			},
			shooting = {
				{
					pitch = 7.5 * p1_m2_modifier,
					yaw = 7.5 * p1_m2_modifier,
				},
			},
		},
	},
	moving = {
		inherits = {
			"stub_pistol_p1_m2_hip",
			"still",
		},
		continuous_spread = {
			min_pitch = 2.4000000000000004,
			min_yaw = 2.4000000000000004,
		},
	},
	crouch_still = {
		inherits = {
			"stub_pistol_p1_m2_hip",
			"still",
		},
		continuous_spread = {
			min_pitch = 0.9,
			min_yaw = 0.9,
		},
	},
	crouch_moving = {
		inherits = {
			"stub_pistol_p1_m2_hip",
			"still",
		},
		continuous_spread = {
			min_pitch = 2.2,
			min_yaw = 2.2,
		},
	},
}
spread_templates.stub_pistol_p1_m2_ads = {
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
		randomized_spread = {
			first_shot_min_ratio = 0.4,
			first_shot_random_ratio = 0.45,
		},
		continuous_spread = {
			min_pitch = 0.7,
			min_yaw = 0.7,
		},
		immediate_spread = {
			num_shots_clear_time = 0.5,
			alternate_fire_start = {
				{
					pitch = {
						lerp_basic = 1.2,
						lerp_perfect = 0.4,
					},
					yaw = {
						lerp_basic = 1.2,
						lerp_perfect = 0.45,
					},
				},
			},
			damage_hit = {
				{
					pitch = 0.3,
					yaw = 0.3,
				},
			},
			shooting = {
				{
					pitch = {
						lerp_basic = 1.2,
						lerp_perfect = 0.4,
					},
					yaw = {
						lerp_basic = 1.2,
						lerp_perfect = 0.45,
					},
				},
			},
		},
	},
	moving = {
		inherits = {
			"stub_pistol_p1_m2_ads",
			"still",
		},
		continuous_spread = {
			min_pitch = 1.65,
			min_yaw = 1.65,
		},
	},
	crouch_still = {
		inherits = {
			"stub_pistol_p1_m2_ads",
			"still",
		},
		continuous_spread = {
			min_pitch = 0.5,
			min_yaw = 0.5,
		},
	},
	crouch_moving = {
		inherits = {
			"stub_pistol_p1_m2_ads",
			"still",
		},
		continuous_spread = {
			min_pitch = 2,
			min_yaw = 2,
		},
	},
}

local p1_m3_modifier = 1.8

spread_templates.stub_pistol_p1_m3_hip = {
	still = {
		max_spread = {
			pitch = 5,
			yaw = 5,
		},
		decay = {
			from_shooting_grace_time = 0.075,
			shooting = {
				pitch = 0.15,
				yaw = 0.15,
			},
			idle = {
				pitch = 4.5,
				yaw = 4.5,
			},
		},
		randomized_spread = {
			first_shot_min_ratio = 0.3,
			first_shot_random_ratio = 0.6,
			min_ratio = 0.15,
			random_ratio = 0.5,
		},
		continuous_spread = {
			min_pitch = 1.5 * p1_m3_modifier,
			min_yaw = 1.5 * p1_m3_modifier,
		},
		immediate_spread = {
			num_shots_clear_time = 0.5,
			damage_hit = {
				{
					pitch = 0.4 * p1_m3_modifier,
					yaw = 0.4 * p1_m3_modifier,
				},
			},
			shooting = {
				{
					pitch = 7.5 * p1_m3_modifier,
					yaw = 7.5 * p1_m3_modifier,
				},
			},
		},
	},
	moving = {
		inherits = {
			"stub_pistol_p1_m3_hip",
			"still",
		},
		continuous_spread = {
			min_pitch = 4.5,
			min_yaw = 4.5,
		},
	},
	crouch_still = {
		inherits = {
			"stub_pistol_p1_m3_hip",
			"still",
		},
		continuous_spread = {
			min_pitch = 3.375,
			min_yaw = 3.375,
		},
	},
	crouch_moving = {
		inherits = {
			"stub_pistol_p1_m3_hip",
			"still",
		},
		continuous_spread = {
			min_pitch = 4.125,
			min_yaw = 4.125,
		},
	},
}
overrides.stub_pistol_p1_m3_ads = {
	parent_template_name = "default_stub_pistol_killshot",
	overrides = {},
}

return {
	base_templates = spread_templates,
	overrides = overrides,
}
