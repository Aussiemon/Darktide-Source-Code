local spread_templates = {}
local overrides = {}

table.make_unique(spread_templates)
table.make_unique(overrides)

spread_templates.default_shotgun_assault = {
	still = {
		max_spread = {
			yaw = 7.5,
			pitch = 7.5
		},
		decay = {
			from_shooting_grace_time = 0.25,
			shooting = {
				yaw = 0.15,
				pitch = 0.15
			},
			idle = {
				yaw = 1,
				pitch = 1
			}
		},
		randomized_spread = {
			random_ratio = 0.2,
			first_shot_min_ratio = 0.05,
			first_shot_random_ratio = 0.25,
			min_ratio = 0.1
		},
		continuous_spread = {
			min_pitch = {
				lerp_perfect = 3.25,
				lerp_basic = 3.75
			},
			min_yaw = {
				lerp_perfect = 3.25,
				lerp_basic = 3.75
			}
		},
		immediate_spread = {
			num_shots_clear_time = 0.75,
			suppression_hit = {
				{
					yaw = 0.5,
					pitch = 0.5
				}
			},
			damage_hit = {
				{
					yaw = 1.5,
					pitch = 1.5
				}
			},
			shooting = {
				{
					pitch = {
						lerp_perfect = 0.5,
						lerp_basic = 1
					},
					yaw = {
						lerp_perfect = 0.5,
						lerp_basic = 1
					}
				},
				{
					pitch = {
						lerp_perfect = 0.8,
						lerp_basic = 1.2
					},
					yaw = {
						lerp_perfect = 0.8,
						lerp_basic = 1.2
					}
				},
				{
					pitch = {
						lerp_perfect = 0.5,
						lerp_basic = 1
					},
					yaw = {
						lerp_perfect = 0.5,
						lerp_basic = 1
					}
				},
				{
					pitch = {
						lerp_perfect = 0.25,
						lerp_basic = 0.75
					},
					yaw = {
						lerp_perfect = 0.25,
						lerp_basic = 0.75
					}
				}
			}
		}
	},
	moving = {
		continuous_spread = {
			min_pitch = {
				lerp_perfect = 3.75,
				lerp_basic = 4.25
			},
			min_yaw = {
				lerp_perfect = 3.75,
				lerp_basic = 4.25
			}
		},
		inherits = {
			"default_shotgun_assault",
			"still"
		}
	},
	crouch_still = {
		continuous_spread = {
			min_pitch = {
				lerp_perfect = 3,
				lerp_basic = 3.5
			},
			min_yaw = {
				lerp_perfect = 3,
				lerp_basic = 3.5
			}
		},
		inherits = {
			"default_shotgun_assault",
			"still"
		}
	},
	crouch_moving = {
		continuous_spread = {
			min_pitch = {
				lerp_perfect = 3.5,
				lerp_basic = 4
			},
			min_yaw = {
				lerp_perfect = 3.5,
				lerp_basic = 4
			}
		},
		inherits = {
			"default_shotgun_assault",
			"still"
		}
	}
}
spread_templates.default_shotgun_killshot = {
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
				yaw = 0.5,
				pitch = 0.5
			},
			idle = {
				yaw = 1.5,
				pitch = 1.5
			},
			player_event = {
				yaw = 4,
				pitch = 4
			}
		},
		continuous_spread = {
			min_yaw = 0,
			min_pitch = 0
		},
		immediate_spread = {
			num_shots_clear_time = 0.6,
			alternate_fire_start = {
				{
					yaw = 0,
					pitch = 0
				}
			},
			crouching_transition = {
				{
					yaw = 0,
					pitch = 0
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
		},
		visual_spread_settings = {
			intensity = 0.4,
			speed_variance_max = 1.25,
			rotation_speed = 0.5,
			horizontal_speed = 1,
			speed_change_frequency = 1,
			speed_variance_min = 0.75
		}
	},
	moving = {
		inherits = {
			"default_shotgun_killshot",
			"still"
		},
		continuous_spread = {
			min_yaw = 0.15,
			min_pitch = 0.15
		},
		decay = {
			from_shooting_grace_time = 0.15,
			enter_alternate_fire_grace_time = 0.5,
			crouch_transition_grace_time = 0.5,
			shooting = {
				yaw = 0.5,
				pitch = 0.5
			},
			idle = {
				yaw = 1.5,
				pitch = 1.5
			},
			player_event = {
				yaw = 3,
				pitch = 3
			}
		},
		visual_spread_settings = {
			intensity = 0.5,
			speed_variance_max = 1.25,
			rotation_speed = 0.5,
			horizontal_speed = 2,
			speed_change_frequency = 1,
			speed_variance_min = 0.75
		}
	},
	crouch_still = {
		inherits = {
			"default_shotgun_killshot",
			"still"
		},
		continuous_spread = {
			min_yaw = 0.25,
			min_pitch = 0.25
		},
		decay = {
			from_shooting_grace_time = 0.15,
			shooting = {
				yaw = 0.5,
				pitch = 0.5
			},
			idle = {
				yaw = 1.75,
				pitch = 1.75
			}
		}
	},
	crouch_moving = {
		continuous_spread = {
			min_yaw = 0.65,
			min_pitch = 0.65
		},
		inherits = {
			"default_shotgun_killshot",
			"still"
		}
	}
}

return {
	base_templates = spread_templates,
	overrides = overrides
}
