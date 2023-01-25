local spread_templates = {}
local overrides = {}

table.make_unique(spread_templates)
table.make_unique(overrides)

spread_templates.default_bolter_killshot = {
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
			"default_bolter_killshot",
			"still"
		},
		continuous_spread = {
			min_yaw = 0,
			min_pitch = 0
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
			"default_bolter_killshot",
			"still"
		},
		continuous_spread = {
			min_yaw = 0,
			min_pitch = 0
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
			min_yaw = 0,
			min_pitch = 0
		},
		inherits = {
			"default_bolter_killshot",
			"still"
		}
	}
}
spread_templates.default_bolter_spraynpray = {
	still = {
		randomized_spread = {
			first_shot_min_ratio = 0.5,
			max_yaw_delta = 1,
			first_shot_random_ratio = 0.5,
			random_ratio = 0.75,
			max_pitch_delta = 1,
			min_ratio = 0.25
		},
		max_spread = {
			pitch = {
				lerp_perfect = 2,
				lerp_basic = 4
			},
			yaw = {
				lerp_perfect = 2,
				lerp_basic = 4
			}
		},
		decay = {
			from_shooting_grace_time = 0.2,
			shooting = {
				yaw = 0.05,
				pitch = 0.05
			},
			idle = {
				yaw = 2,
				pitch = 1.5
			}
		},
		continuous_spread = {
			min_pitch = {
				lerp_perfect = 0.25,
				lerp_basic = 1
			},
			min_yaw = {
				lerp_perfect = 0.75,
				lerp_basic = 1.5
			}
		},
		immediate_spread = {
			num_shots_clear_time = 0.25,
			suppression_hit = {
				{
					pitch = {
						lerp_perfect = 0.15,
						lerp_basic = 0.35
					},
					yaw = {
						lerp_perfect = 0.15,
						lerp_basic = 0.35
					}
				}
			},
			damage_hit = {
				{
					pitch = {
						lerp_perfect = 0.3,
						lerp_basic = 0.5
					},
					yaw = {
						lerp_perfect = 0.3,
						lerp_basic = 0.5
					}
				}
			},
			shooting = {
				{
					pitch = {
						lerp_perfect = 0.15,
						lerp_basic = 0.3
					},
					yaw = {
						lerp_perfect = 1.25,
						lerp_basic = 2
					}
				},
				{
					pitch = {
						lerp_perfect = 0.11249999999999999,
						lerp_basic = 0.22499999999999998
					},
					yaw = {
						lerp_perfect = 0.1875,
						lerp_basic = 0.75
					}
				},
				{
					pitch = {
						lerp_perfect = 0.075,
						lerp_basic = 0.15
					},
					yaw = {
						lerp_perfect = 0.125,
						lerp_basic = 0.5
					}
				}
			}
		}
	},
	moving = {
		inherits = {
			"default_bolter_spraynpray",
			"still"
		},
		continuous_spread = {
			min_pitch = {
				lerp_perfect = 1,
				lerp_basic = 1.5
			},
			min_yaw = {
				lerp_perfect = 1.5,
				lerp_basic = 2
			}
		}
	},
	crouch_still = {
		inherits = {
			"default_bolter_spraynpray",
			"still"
		},
		continuous_spread = {
			min_pitch = {
				lerp_perfect = 0.1,
				lerp_basic = 1
			},
			min_yaw = {
				lerp_perfect = 0.4,
				lerp_basic = 1.5
			}
		}
	},
	crouch_moving = {
		inherits = {
			"default_bolter_spraynpray",
			"still"
		}
	}
}
spread_templates.bolter_p1_m2_spraynpray = {
	still = {
		randomized_spread = {
			first_shot_min_ratio = 0.75,
			max_yaw_delta = 0.7,
			first_shot_random_ratio = 0.25,
			random_ratio = 0.75,
			max_pitch_delta = 0.7,
			min_ratio = 0.2
		},
		max_spread = {
			yaw = 4,
			pitch = 3
		},
		decay = {
			from_shooting_grace_time = 0.2,
			shooting = {
				yaw = 0.05,
				pitch = 0.05
			},
			idle = {
				yaw = 2,
				pitch = 1.5
			}
		},
		continuous_spread = {
			min_yaw = 0.5,
			min_pitch = 0.5
		},
		immediate_spread = {
			num_shots_clear_time = 0.25,
			suppression_hit = {
				{
					yaw = 0.2,
					pitch = 0.2
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
					yaw = 0.4,
					pitch = 0.3
				}
			}
		}
	},
	moving = {
		inherits = {
			"default_bolter_spraynpray",
			"still"
		},
		continuous_spread = {
			min_yaw = 1,
			min_pitch = 1
		}
	},
	crouch_still = {
		inherits = {
			"default_bolter_spraynpray",
			"still"
		}
	},
	crouch_moving = {
		inherits = {
			"default_bolter_spraynpray",
			"still"
		}
	}
}

return {
	base_templates = spread_templates,
	overrides = overrides
}
