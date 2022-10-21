local spread_templates = {}
local overrides = {}

table.make_unique(spread_templates)
table.make_unique(overrides)

spread_templates.default_autogun_assault = {
	still = {
		max_spread = {
			yaw = 8,
			pitch = 8
		},
		randomized_spread = {
			random_ratio = 0.75,
			first_shot_min_ratio = 0.3,
			first_shot_random_ratio = 0.5,
			min_ratio = 0.25
		},
		decay = {
			from_shooting_grace_time = 0.3,
			shooting = {
				yaw = 0.5,
				pitch = 0.5
			},
			idle = {
				yaw = 1.75,
				pitch = 1.75
			}
		},
		continuous_spread = {
			min_pitch = {
				lerp_perfect = 1.4,
				lerp_basic = 2
			},
			min_yaw = {
				lerp_perfect = 1.4,
				lerp_basic = 2
			}
		},
		immediate_spread = {
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
					pitch = {
						lerp_perfect = 0.25,
						lerp_basic = 0.45
					},
					yaw = {
						lerp_perfect = 0.25,
						lerp_basic = 0.45
					}
				},
				{
					pitch = {
						lerp_perfect = 0.15,
						lerp_basic = 0.25
					},
					yaw = {
						lerp_perfect = 0.15,
						lerp_basic = 0.25
					}
				},
				{
					pitch = {
						lerp_perfect = 0.25,
						lerp_basic = 0.45
					},
					yaw = {
						lerp_perfect = 0.25,
						lerp_basic = 0.45
					}
				},
				{
					pitch = {
						lerp_perfect = 0.4,
						lerp_basic = 0.6
					},
					yaw = {
						lerp_perfect = 0.4,
						lerp_basic = 0.6
					}
				},
				{
					pitch = {
						lerp_perfect = 0.2,
						lerp_basic = 0.35
					},
					yaw = {
						lerp_perfect = 0.2,
						lerp_basic = 0.35
					}
				},
				{
					pitch = {
						lerp_perfect = 0.15,
						lerp_basic = 0.3
					},
					yaw = {
						lerp_perfect = 0.15,
						lerp_basic = 0.3
					}
				},
				{
					pitch = {
						lerp_perfect = 0.15,
						lerp_basic = 0.3
					},
					yaw = {
						lerp_perfect = 0.15,
						lerp_basic = 0.3
					}
				},
				{
					pitch = {
						lerp_perfect = 0.15,
						lerp_basic = 0.3
					},
					yaw = {
						lerp_perfect = 0.15,
						lerp_basic = 0.3
					}
				},
				{
					pitch = {
						lerp_perfect = 0.15,
						lerp_basic = 0.3
					},
					yaw = {
						lerp_perfect = 0.15,
						lerp_basic = 0.3
					}
				}
			},
			num_shots_clear_time = {
				lerp_perfect = 0.1,
				lerp_basic = 0.1
			}
		}
	},
	moving = {
		inherits = {
			"default_autogun_assault",
			"still"
		},
		continuous_spread = {
			min_pitch = {
				lerp_perfect = 2.05,
				lerp_basic = 2.9
			},
			min_yaw = {
				lerp_perfect = 2.05,
				lerp_basic = 2.9
			}
		}
	},
	crouch_still = {
		inherits = {
			"default_autogun_assault",
			"still"
		},
		continuous_spread = {
			min_pitch = {
				lerp_perfect = 1.25,
				lerp_basic = 1.6
			},
			min_yaw = {
				lerp_perfect = 1.25,
				lerp_basic = 1.6
			}
		}
	},
	crouch_moving = {
		inherits = {
			"default_autogun_assault",
			"still"
		},
		continuous_spread = {
			min_pitch = {
				lerp_perfect = 2.1,
				lerp_basic = 3
			},
			min_yaw = {
				lerp_perfect = 2.1,
				lerp_basic = 3
			}
		}
	}
}
spread_templates.default_autogun_burst = {
	still = {
		max_spread = {
			yaw = 8,
			pitch = 8
		},
		decay = {
			from_shooting_grace_time = 0.3,
			shooting = {
				yaw = 0.25,
				pitch = 0.25
			},
			idle = {
				yaw = 1.75,
				pitch = 1.75
			}
		},
		continuous_spread = {
			min_yaw = 0.5,
			min_pitch = 0.5
		},
		immediate_spread = {
			num_shots_clear_time = 0.75,
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
					yaw = 0.1,
					pitch = 0.1
				},
				{
					yaw = 0.15,
					pitch = 0.15
				},
				{
					yaw = 0.15,
					pitch = 0.15
				},
				{
					yaw = 1,
					pitch = 1
				},
				{
					yaw = 0.1,
					pitch = 0.1
				},
				{
					yaw = 0.15,
					pitch = 0.15
				},
				{
					yaw = 0.15,
					pitch = 0.15
				},
				{
					yaw = 1,
					pitch = 1
				},
				{
					yaw = 0.1,
					pitch = 0.1
				},
				{
					yaw = 0.15,
					pitch = 0.15
				},
				{
					yaw = 0.15,
					pitch = 0.15
				},
				{
					yaw = 0.75,
					pitch = 0.75
				},
				{
					yaw = 0.1,
					pitch = 0.1
				},
				{
					yaw = 0.125,
					pitch = 0.125
				},
				{
					yaw = 0.125,
					pitch = 0.125
				},
				{
					yaw = 0.5,
					pitch = 0.5
				},
				{
					yaw = 0.1,
					pitch = 0.1
				},
				{
					yaw = 0.125,
					pitch = 0.125
				},
				{
					yaw = 0.125,
					pitch = 0.125
				},
				{
					yaw = 0.5,
					pitch = 0.5
				},
				{
					yaw = 0.1,
					pitch = 0.1
				},
				{
					yaw = 0.1,
					pitch = 0.1
				},
				{
					yaw = 0.1,
					pitch = 0.1
				},
				{
					yaw = 0.3,
					pitch = 0.3
				},
				{
					yaw = 0.075,
					pitch = 0.075
				},
				{
					yaw = 0.075,
					pitch = 0.075
				},
				{
					yaw = 0.075,
					pitch = 0.075
				},
				{
					yaw = 0.2,
					pitch = 0.2
				},
				{
					yaw = 0.175,
					pitch = 0.175
				},
				{
					yaw = 0.15,
					pitch = 0.15
				}
			}
		}
	},
	moving = {
		inherits = {
			"default_autogun_assault",
			"still"
		},
		continuous_spread = {
			min_yaw = 0.75,
			min_pitch = 0.75
		}
	},
	crouch_still = {
		inherits = {
			"default_autogun_assault",
			"still"
		},
		continuous_spread = {
			min_yaw = 0.8,
			min_pitch = 0.8
		}
	},
	crouch_moving = {
		inherits = {
			"default_autogun_assault",
			"still"
		},
		continuous_spread = {
			min_yaw = 1.1,
			min_pitch = 1.1
		}
	}
}
spread_templates.default_autogun_killshot = {
	still = {
		max_spread = {
			yaw = 8,
			pitch = 8
		},
		decay = {
			from_shooting_grace_time = 0.1,
			shooting = {
				yaw = 0.25,
				pitch = 0.25
			},
			idle = {
				yaw = 1.25,
				pitch = 1.25
			}
		},
		continuous_spread = {
			min_yaw = 0,
			min_pitch = 0
		},
		immediate_spread = {
			num_shots_clear_time = 0.35,
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
					yaw = 0,
					pitch = 0
				},
				{
					yaw = 0,
					pitch = 0
				},
				{
					yaw = 0,
					pitch = 0
				},
				{
					yaw = 0.001,
					pitch = 0.001
				},
				{
					yaw = 0.001,
					pitch = 0.001
				},
				{
					yaw = 0.001,
					pitch = 0.001
				},
				{
					yaw = 0.002,
					pitch = 0.002
				}
			}
		}
	},
	moving = {
		inherits = {
			"default_autogun_killshot",
			"still"
		},
		continuous_spread = {
			min_yaw = 0,
			min_pitch = 0
		}
	},
	crouch_still = {
		inherits = {
			"default_autogun_killshot",
			"still"
		},
		continuous_spread = {
			min_yaw = 0,
			min_pitch = 0
		}
	},
	crouch_moving = {
		inherits = {
			"default_autogun_killshot",
			"still"
		},
		continuous_spread = {
			min_yaw = 0,
			min_pitch = 0
		}
	}
}
spread_templates.default_autogun_alternate_fire_killshot = {
	still = {
		max_spread = {
			yaw = 8,
			pitch = 8
		},
		decay = {
			from_shooting_grace_time = 0.1,
			shooting = {
				yaw = 0.25,
				pitch = 0.25
			},
			idle = {
				yaw = 1.25,
				pitch = 1.25
			}
		},
		continuous_spread = {
			min_yaw = 0,
			min_pitch = 0
		},
		start_spread = {
			start_yaw = 0,
			start_pitch = 0
		},
		immediate_spread = {
			num_shots_clear_time = 0.25,
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
					yaw = 0,
					pitch = 0
				},
				{
					yaw = 0,
					pitch = 0
				},
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
			"default_autogun_killshot",
			"still"
		},
		continuous_spread = {
			min_yaw = 0,
			min_pitch = 0
		}
	},
	crouch_still = {
		inherits = {
			"default_autogun_killshot",
			"still"
		},
		continuous_spread = {
			min_yaw = 0,
			min_pitch = 0
		}
	},
	crouch_moving = {
		inherits = {
			"default_autogun_killshot",
			"still"
		},
		continuous_spread = {
			min_yaw = 0,
			min_pitch = 0
		}
	}
}
local pitch_spread = 1
local yaw_spread = pitch_spread * 1.2
spread_templates.default_autogun_spraynpray = {
	still = {
		max_spread = {
			yaw = 14,
			pitch = 10
		},
		decay = {
			from_shooting_grace_time = 0.025,
			shooting = {
				yaw = 0.25,
				pitch = 0.5
			},
			idle = {
				yaw = 1.5,
				pitch = 1.5
			}
		},
		continuous_spread = {
			min_pitch = {
				lerp_perfect = 1.2,
				lerp_basic = 1.8
			},
			min_yaw = {
				lerp_perfect = 3.5,
				lerp_basic = 4.5
			}
		},
		immediate_spread = {
			num_shots_clear_time = 0.25,
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
					pitch = pitch_spread * 0.4,
					yaw = yaw_spread * 0.4
				},
				{
					pitch = pitch_spread * 0.45,
					yaw = yaw_spread * 0.45
				},
				{
					pitch = pitch_spread * 0.5,
					yaw = yaw_spread * 0.5
				},
				{
					pitch = pitch_spread * 0.4,
					yaw = yaw_spread * 0.4
				},
				{
					pitch = pitch_spread * 0.3,
					yaw = yaw_spread * 0.3
				},
				{
					pitch = pitch_spread * 0.2,
					yaw = yaw_spread * 0.2
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1
				},
				{
					pitch = pitch_spread * 0.2,
					yaw = yaw_spread * 0.2
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1
				},
				{
					pitch = pitch_spread * 0.2,
					yaw = yaw_spread * 0.2
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1
				},
				{
					pitch = pitch_spread * 0.2,
					yaw = yaw_spread * 0.2
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1
				},
				{
					pitch = pitch_spread * 0.2,
					yaw = yaw_spread * 0.2
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1
				},
				{
					pitch = pitch_spread * 0.2,
					yaw = yaw_spread * 0.2
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1
				},
				{
					pitch = pitch_spread * 0.2,
					yaw = yaw_spread * 0.2
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1
				},
				{
					pitch = pitch_spread * 0.2,
					yaw = yaw_spread * 0.2
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1
				},
				{
					pitch = pitch_spread * 0.2,
					yaw = yaw_spread * 0.2
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1
				},
				{
					pitch = pitch_spread * 0.2,
					yaw = yaw_spread * 0.2
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1
				},
				{
					pitch = pitch_spread * 0.2,
					yaw = yaw_spread * 0.2
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1
				},
				{
					pitch = pitch_spread * 0.2,
					yaw = yaw_spread * 0.2
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1
				},
				{
					pitch = pitch_spread * 0.2,
					yaw = yaw_spread * 0.2
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0,
					yaw = yaw_spread * 0
				},
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1
				}
			}
		}
	},
	moving = {
		inherits = {
			"default_autogun_spraynpray",
			"still"
		},
		continuous_spread = {
			min_pitch = {
				lerp_perfect = 1.6,
				lerp_basic = 2.2
			},
			min_yaw = {
				lerp_perfect = 6,
				lerp_basic = 8
			}
		}
	},
	crouch_still = {
		inherits = {
			"default_autogun_spraynpray",
			"still"
		}
	},
	crouch_moving = {
		inherits = {
			"default_autogun_spraynpray",
			"still"
		}
	}
}

return {
	base_templates = spread_templates,
	overrides = overrides
}
