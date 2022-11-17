local spread_templates = {}
local overrides = {}

table.make_unique(spread_templates)
table.make_unique(overrides)

spread_templates.default_stub_pistol_assault = {
	still = {
		max_spread = {
			yaw = 5,
			pitch = 5
		},
		decay = {
			from_shooting_grace_time = 0.075,
			shooting = {
				yaw = 0.15,
				pitch = 0.15
			},
			idle = {
				yaw = 4.5,
				pitch = 4.5
			}
		},
		randomized_spread = {
			random_ratio = 0.5,
			first_shot_min_ratio = 0.3,
			first_shot_random_ratio = 0.6,
			min_ratio = 0.15
		},
		continuous_spread = {
			min_yaw = 1.5,
			min_pitch = 1.5
		},
		immediate_spread = {
			num_shots_clear_time = 0.5,
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
					yaw = 7.5,
					pitch = 7.5
				}
			}
		}
	},
	moving = {
		inherits = {
			"default_stub_pistol_assault",
			"still"
		},
		continuous_spread = {
			min_yaw = 3,
			min_pitch = 3
		}
	},
	crouch_still = {
		inherits = {
			"default_stub_pistol_assault",
			"still"
		},
		continuous_spread = {
			min_yaw = 2.25,
			min_pitch = 2.25
		}
	},
	crouch_moving = {
		inherits = {
			"default_stub_pistol_assault",
			"still"
		},
		continuous_spread = {
			min_yaw = 2.75,
			min_pitch = 2.75
		}
	}
}
spread_templates.default_stub_pistol_killshot = {
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
			"default_stub_pistol_killshot",
			"still"
		},
		continuous_spread = {
			min_yaw = 0,
			min_pitch = 0
		}
	},
	crouch_still = {
		inherits = {
			"default_stub_pistol_killshot",
			"still"
		},
		continuous_spread = {
			min_yaw = 0,
			min_pitch = 0
		}
	},
	crouch_moving = {
		inherits = {
			"default_stub_pistol_killshot",
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
