local spread_templates = {}
local overrides = {}

table.make_unique(spread_templates)
table.make_unique(overrides)

spread_templates.default_laspistol_killshot = {
	still = {
		max_spread = {
			yaw = 6,
			pitch = 6
		},
		decay = {
			from_shooting_grace_time = 0.15,
			shooting = {
				yaw = 0.5,
				pitch = 0.5
			},
			idle = {
				yaw = 2,
				pitch = 2
			}
		},
		continuous_spread = {
			min_yaw = 0,
			min_pitch = 0
		},
		immediate_spread = {
			num_shots_clear_time = 0.4,
			suppression_hit = {
				{
					yaw = 0.2,
					pitch = 0.2
				}
			},
			damage_hit = {
				{
					yaw = 1.2,
					pitch = 1.2
				}
			},
			shooting = {
				{
					yaw = 0,
					pitch = 0
				},
				{
					yaw = 0,
					pitch = 0
				},
				{
					yaw = 0.05,
					pitch = 0.05
				}
			}
		},
		visual_spread_settings = {
			intensity = 0.5,
			speed_variance_max = 1.25,
			rotation_speed = 0.5,
			horizontal_speed = 4,
			speed_change_frequency = 1,
			speed_variance_min = 0.75
		}
	},
	moving = {
		inherits = {
			"default_laspistol_killshot",
			"still"
		},
		continuous_spread = {
			min_yaw = 0,
			min_pitch = 0
		}
	},
	crouch_still = {
		inherits = {
			"default_laspistol_killshot",
			"still"
		},
		continuous_spread = {
			min_yaw = 0,
			min_pitch = 0
		}
	},
	crouch_moving = {
		inherits = {
			"default_laspistol_killshot",
			"still"
		},
		continuous_spread = {
			min_yaw = 0,
			min_pitch = 0
		}
	}
}
local spread_multi = 0.65
spread_templates.default_laspistol_assault = {
	still = {
		max_spread = {
			pitch = {
				lerp_perfect = 6,
				lerp_basic = 6.25
			},
			yaw = {
				lerp_perfect = 6,
				lerp_basic = 6.25
			}
		},
		decay = {
			from_shooting_grace_time = 0.15,
			shooting = {
				pitch = {
					lerp_perfect = 0.3,
					lerp_basic = 0.15
				},
				yaw = {
					lerp_perfect = 0.3,
					lerp_basic = 0.15
				}
			},
			idle = {
				pitch = {
					lerp_perfect = 2,
					lerp_basic = 1
				},
				yaw = {
					lerp_perfect = 2,
					lerp_basic = 1
				}
			}
		},
		continuous_spread = {
			min_pitch = {
				lerp_perfect = 1,
				lerp_basic = 1.75
			},
			min_yaw = {
				lerp_perfect = 1,
				lerp_basic = 1.75
			}
		},
		randomized_spread = {
			first_shot_min_ratio = 0.15,
			max_yaw_delta = 0.95,
			first_shot_random_ratio = 0.5,
			random_ratio = 0.15,
			max_pitch_delta = 0.95,
			min_ratio = 0.8
		},
		immediate_spread = {
			num_shots_clear_time = 0.5,
			suppression_hit = {
				{
					pitch = {
						lerp_perfect = 0.75,
						lerp_basic = 1.5
					},
					yaw = {
						lerp_perfect = 0.75,
						lerp_basic = 1.5
					}
				}
			},
			damage_hit = {
				{
					pitch = {
						lerp_perfect = 1,
						lerp_basic = 1.5
					},
					yaw = {
						lerp_perfect = 1,
						lerp_basic = 1.5
					}
				}
			},
			shooting = {
				{
					pitch = {
						lerp_perfect = 0.25,
						lerp_basic = 0.75 * spread_multi
					},
					yaw = {
						lerp_perfect = 0.25,
						lerp_basic = 0.75 * spread_multi
					}
				},
				{
					pitch = {
						lerp_perfect = 0.35,
						lerp_basic = 0.85 * spread_multi
					},
					yaw = {
						lerp_perfect = 0.35,
						lerp_basic = 0.85 * spread_multi
					}
				},
				{
					pitch = {
						lerp_perfect = 0.45,
						lerp_basic = 0.95 * spread_multi
					},
					yaw = {
						lerp_perfect = 0.45,
						lerp_basic = 0.95 * spread_multi
					}
				},
				{
					pitch = {
						lerp_perfect = 0.475,
						lerp_basic = 1 * spread_multi
					},
					yaw = {
						lerp_perfect = 0.475,
						lerp_basic = 1 * spread_multi
					}
				},
				{
					pitch = {
						lerp_perfect = 0.5,
						lerp_basic = 1.1 * spread_multi
					},
					yaw = {
						lerp_perfect = 0.5,
						lerp_basic = 1.1 * spread_multi
					}
				},
				{
					pitch = {
						lerp_perfect = 0.5,
						lerp_basic = 1.2 * spread_multi
					},
					yaw = {
						lerp_perfect = 0.5,
						lerp_basic = 1.2 * spread_multi
					}
				},
				{
					pitch = {
						lerp_perfect = 0.25,
						lerp_basic = 1.15 * spread_multi
					},
					yaw = {
						lerp_perfect = 0.25,
						lerp_basic = 1.15 * spread_multi
					}
				}
			}
		}
	},
	moving = {
		inherits = {
			"default_laspistol_assault",
			"still"
		},
		continuous_spread = {
			min_pitch = {
				lerp_perfect = 1.75,
				lerp_basic = 2.25
			},
			min_yaw = {
				lerp_perfect = 1.75,
				lerp_basic = 2.25
			}
		},
		decay = {
			from_shooting_grace_time = 0.15,
			shooting = {
				pitch = {
					lerp_perfect = 1.5,
					lerp_basic = 0.25
				},
				yaw = {
					lerp_perfect = 1.5,
					lerp_basic = 0.25
				}
			},
			idle = {
				pitch = {
					lerp_perfect = 2.5,
					lerp_basic = 1.5
				},
				yaw = {
					lerp_perfect = 2.5,
					lerp_basic = 1.5
				}
			}
		}
	},
	crouch_still = {
		inherits = {
			"default_laspistol_assault",
			"still"
		},
		continuous_spread = {
			min_pitch = {
				lerp_perfect = 1.5,
				lerp_basic = 1.85
			},
			min_yaw = {
				lerp_perfect = 1.5,
				lerp_basic = 1.85
			}
		}
	},
	crouch_moving = {
		inherits = {
			"default_laspistol_assault",
			"still"
		},
		continuous_spread = {
			min_pitch = {
				lerp_perfect = 1.85,
				lerp_basic = 2.75
			},
			min_yaw = {
				lerp_perfect = 1.85,
				lerp_basic = 2.75
			}
		}
	}
}

return {
	base_templates = spread_templates,
	overrides = overrides
}
