-- chunkname: @scripts/settings/equipment/weapon_templates/shotpistol_shield/settings_templates/shotpistol_shield_spread_templates.lua

local spread_templates = {}
local overrides = {}

table.make_unique(spread_templates)
table.make_unique(overrides)

spread_templates.default_shotpistol_shield_hip = {
	still = {
		max_spread = {
			yaw = 2,
			pitch = 2
		},
		decay = {
			from_shooting_grace_time = 0.075,
			shooting = {
				yaw = 0.15,
				pitch = 0.15
			},
			idle = {
				yaw = 3.5,
				pitch = 3.5
			}
		},
		randomized_spread = {
			random_ratio = 0.3,
			first_shot_min_ratio = 0.3,
			first_shot_random_ratio = 0.3,
			min_ratio = 0.15
		},
		continuous_spread = {
			min_yaw = 0.7,
			min_pitch = 0.7
		},
		immediate_spread = {
			num_shots_clear_time = 1.1,
			suppression_hit = {
				{
					yaw = 0.25,
					pitch = 0.25
				}
			},
			damage_hit = {
				{
					yaw = 0.4,
					pitch = 0.4
				}
			},
			shooting = {
				{
					yaw = 0.3,
					pitch = 0.3
				},
				{
					yaw = 1,
					pitch = 1.4
				},
				{
					yaw = 1.5,
					pitch = 1.6
				},
				{
					yaw = 1.7,
					pitch = 1.3
				}
			}
		}
	},
	moving = {
		inherits = {
			"default_shotpistol_shield_hip",
			"still"
		},
		continuous_spread = {
			min_yaw = 1.2,
			min_pitch = 1.2
		}
	},
	crouch_still = {
		inherits = {
			"default_shotpistol_shield_hip",
			"still"
		},
		continuous_spread = {
			min_yaw = 0.25,
			min_pitch = 0.25
		}
	},
	crouch_moving = {
		inherits = {
			"default_shotpistol_shield_hip",
			"still"
		},
		continuous_spread = {
			min_yaw = 0.75,
			min_pitch = 0.75
		}
	}
}
spread_templates.default_shotpistol_shield_ads = {
	still = {
		max_spread = {
			yaw = 2.5,
			pitch = 2.5
		},
		decay = {
			from_shooting_grace_time = 0.15,
			enter_alternate_fire_grace_time = 0.5,
			crouch_transition_grace_time = 0.5,
			shooting = {
				pitch = {
					lerp_perfect = 0.8,
					lerp_basic = 0.5
				},
				yaw = {
					lerp_perfect = 0.8,
					lerp_basic = 0.5
				}
			},
			idle = {
				pitch = {
					lerp_perfect = 2,
					lerp_basic = 1.5
				},
				yaw = {
					lerp_perfect = 2,
					lerp_basic = 1.5
				}
			},
			player_event = {
				pitch = {
					lerp_perfect = 50,
					lerp_basic = 40
				},
				yaw = {
					lerp_perfect = 50,
					lerp_basic = 40
				}
			}
		},
		continuous_spread = {
			min_yaw = 0,
			min_pitch = 0
		},
		immediate_spread = {
			num_shots_clear_time = 0.5,
			alternate_fire_start = {
				{
					pitch = {
						lerp_perfect = 0,
						lerp_basic = 0.2
					},
					yaw = {
						lerp_perfect = 0.01,
						lerp_basic = 0.2
					}
				}
			},
			suppression_hit = {
				{
					yaw = 0,
					pitch = 0
				}
			},
			damage_hit = {
				{
					yaw = 0,
					pitch = 0
				}
			},
			shooting = {
				{
					yaw = 0,
					pitch = 0
				}
			}
		}
	},
	moving = {
		inherits = {
			"default_shotpistol_shield_ads",
			"still"
		},
		continuous_spread = {
			min_yaw = 0,
			min_pitch = 0
		}
	},
	crouch_still = {
		inherits = {
			"default_shotpistol_shield_ads",
			"still"
		},
		continuous_spread = {
			min_yaw = 0,
			min_pitch = 0
		}
	},
	crouch_moving = {
		inherits = {
			"default_shotpistol_shield_ads",
			"still"
		},
		continuous_spread = {
			min_yaw = 0,
			min_pitch = 0
		}
	}
}

return {
	base_templates = spread_templates,
	overrides = overrides
}
