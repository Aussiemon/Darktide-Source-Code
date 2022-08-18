local spread_templates = {}
local overrides = {}

table.make_unique(spread_templates)
table.make_unique(overrides)

spread_templates.default_thumper_assault = {
	still = {
		randomized_spread = {
			first_shot_min_ratio = 0.15,
			max_yaw_delta = 1,
			first_shot_random_ratio = 0.3,
			random_ratio = 0.3,
			max_pitch_delta = 1,
			min_ratio = 0.2
		},
		max_spread = {
			yaw = 20,
			pitch = 20
		},
		decay = {
			from_shooting_grace_time = 0.15,
			shooting = {
				yaw = 0.25,
				pitch = 0.25
			},
			idle = {
				yaw = 1,
				pitch = 1
			}
		},
		continuous_spread = {
			min_yaw = 6.25,
			min_pitch = 5
		},
		start_spread = {
			start_yaw = 6.25,
			start_pitch = 5
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
					yaw = 1.25,
					pitch = 1
				}
			}
		}
	},
	moving = {
		inherits = {
			"default_thumper_assault",
			"still"
		}
	},
	crouch_still = {
		inherits = {
			"default_thumper_assault",
			"still"
		}
	},
	crouch_moving = {
		inherits = {
			"default_thumper_assault",
			"still"
		}
	}
}
spread_templates.thumper_shotgun_hip_assault = {
	still = {
		randomized_spread = {
			random_ratio = 0.2,
			first_shot_min_ratio = 0.1,
			first_shot_random_ratio = 0.2,
			min_ratio = 0.1
		},
		max_spread = {
			yaw = 20,
			pitch = 20
		},
		decay = {
			from_shooting_grace_time = 0.15,
			shooting = {
				yaw = 0.25,
				pitch = 0.25
			},
			idle = {
				yaw = 1,
				pitch = 1
			}
		},
		continuous_spread = {
			min_yaw = 9,
			min_pitch = 6
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
					yaw = 1.25,
					pitch = 1
				}
			}
		}
	},
	moving = {
		inherits = {
			"thumper_shotgun_hip_assault",
			"still"
		}
	},
	crouch_still = {
		inherits = {
			"thumper_shotgun_hip_assault",
			"still"
		}
	},
	crouch_moving = {
		inherits = {
			"thumper_shotgun_hip_assault",
			"still"
		}
	}
}
spread_templates.thumper_shotgun_aim = {
	still = {
		randomized_spread = {
			random_ratio = 0.002,
			first_shot_min_ratio = 0.001,
			first_shot_random_ratio = 0.002,
			min_ratio = 0.001
		},
		max_spread = {
			yaw = 20,
			pitch = 20
		},
		decay = {
			from_shooting_grace_time = 0.15,
			shooting = {
				yaw = 0.25,
				pitch = 0.25
			},
			idle = {
				yaw = 1,
				pitch = 1
			}
		},
		continuous_spread = {
			min_yaw = 6,
			min_pitch = 4
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
					yaw = 1.25,
					pitch = 1
				}
			}
		}
	},
	moving = {
		inherits = {
			"thumper_shotgun_aim",
			"still"
		}
	},
	crouch_still = {
		inherits = {
			"thumper_shotgun_aim",
			"still"
		}
	},
	crouch_moving = {
		inherits = {
			"thumper_shotgun_aim",
			"still"
		}
	}
}
spread_templates.thumper_hip_assault = {
	still = {
		randomized_spread = {
			first_shot_min_ratio = 0.15,
			max_yaw_delta = 1,
			first_shot_random_ratio = 0.45,
			random_ratio = 0.8,
			max_pitch_delta = 1,
			min_ratio = 0.2
		},
		max_spread = {
			yaw = 20,
			pitch = 20
		},
		decay = {
			from_shooting_grace_time = 0.15,
			shooting = {
				yaw = 0.25,
				pitch = 0.25
			},
			idle = {
				yaw = 1,
				pitch = 1
			}
		},
		continuous_spread = {
			min_yaw = 4.25,
			min_pitch = 3
		},
		start_spread = {
			start_yaw = 4.25,
			start_pitch = 3
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
					yaw = 1.25,
					pitch = 1
				}
			}
		}
	},
	moving = {
		inherits = {
			"thumper_hip_assault",
			"still"
		}
	},
	crouch_still = {
		inherits = {
			"thumper_hip_assault",
			"still"
		}
	},
	crouch_moving = {
		inherits = {
			"thumper_hip_assault",
			"still"
		}
	}
}
spread_templates.thumper_aim_demolition = {
	still = {
		randomized_spread = {
			first_shot_min_ratio = 0.1,
			max_yaw_delta = 1,
			first_shot_random_ratio = 1,
			random_ratio = 0.8,
			max_pitch_delta = 1,
			min_ratio = 0.2
		},
		max_spread = {
			yaw = 20,
			pitch = 20
		},
		decay = {
			from_shooting_grace_time = 0.15,
			shooting = {
				yaw = 0.25,
				pitch = 0.25
			},
			idle = {
				yaw = 1,
				pitch = 1
			}
		},
		continuous_spread = {
			min_yaw = 0,
			min_pitch = 0
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
					yaw = 5.25,
					pitch = 5
				}
			}
		}
	},
	moving = {
		inherits = {
			"thumper_aim_demolition",
			"still"
		}
	},
	crouch_still = {
		inherits = {
			"thumper_aim_demolition",
			"still"
		}
	},
	crouch_moving = {
		inherits = {
			"thumper_aim_demolition",
			"still"
		}
	}
}

return {
	base_templates = spread_templates,
	overrides = overrides
}
