local spread_templates = {}
local overrides = {}

table.make_unique(spread_templates)
table.make_unique(overrides)

spread_templates.default_ogryn_heavystubber_braced = {
	still = {
		max_spread = {
			yaw = 4.2,
			pitch = 4.2
		},
		randomized_spread = {
			random_ratio = 0.55,
			first_shot_min_ratio = 0.3,
			first_shot_random_ratio = 0.5,
			min_ratio = 0.23
		},
		decay = {
			from_shooting_grace_time = 0.3,
			shooting = {
				yaw = 0.9,
				pitch = 0.9
			},
			idle = {
				yaw = 1.75,
				pitch = 1.75
			}
		},
		continuous_spread = {
			min_pitch = {
				lerp_perfect = 0.5,
				lerp_basic = 3
			},
			min_yaw = {
				lerp_perfect = 0.5,
				lerp_basic = 3
			}
		},
		immediate_spread = {
			suppression_hit = {
				{
					yaw = 0.15,
					pitch = 0.15
				}
			},
			damage_hit = {
				{
					yaw = 0.3,
					pitch = 0.3
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
						lerp_perfect = 0.1,
						lerp_basic = 0.3
					},
					yaw = {
						lerp_perfect = 0.1,
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
			"default_ogryn_heavystubber_braced",
			"still"
		},
		continuous_spread = {
			min_pitch = {
				lerp_perfect = 1.05,
				lerp_basic = 1.9
			},
			min_yaw = {
				lerp_perfect = 1.05,
				lerp_basic = 1.9
			}
		}
	},
	crouch_still = {
		inherits = {
			"default_ogryn_heavystubber_braced",
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
			"default_ogryn_heavystubber_braced",
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
spread_templates.default_ogryn_heavystubber_burst = {
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
			"default_ogryn_heavystubber_burst",
			"still"
		},
		continuous_spread = {
			min_yaw = 0.75,
			min_pitch = 0.75
		}
	},
	crouch_still = {
		inherits = {
			"default_ogryn_heavystubber_burst",
			"still"
		},
		continuous_spread = {
			min_yaw = 0.8,
			min_pitch = 0.8
		}
	},
	crouch_moving = {
		inherits = {
			"default_ogryn_heavystubber_burst",
			"still"
		},
		continuous_spread = {
			min_yaw = 1.1,
			min_pitch = 1.1
		}
	}
}
spread_templates.default_ogryn_heavystubber_alternate_fire = {
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
local pitch_spread = 1.54
local yaw_spread = pitch_spread * 1.3
spread_templates.ogryn_heavystubber_spread_spraynpray_hip = {
	still = {
		max_spread = {
			yaw = 6,
			pitch = 6.4
		},
		decay = {
			from_shooting_grace_time = 0.025,
			shooting = {
				yaw = 0.5,
				pitch = 0.5
			},
			idle = {
				yaw = 1.5,
				pitch = 1.5
			}
		},
		continuous_spread = {
			min_yaw = 2,
			min_pitch = 2
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
					pitch = pitch_spread * 0.14,
					yaw = yaw_spread * 0.14
				}
			}
		}
	},
	moving = {
		inherits = {
			"ogryn_heavystubber_spread_spraynpray_hip",
			"still"
		},
		continuous_spread = {
			min_yaw = 2.1,
			min_pitch = 2.1
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
					pitch = pitch_spread * 1,
					yaw = yaw_spread * 1
				},
				{
					pitch = pitch_spread * 0.75,
					yaw = yaw_spread * 0.75
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
				}
			}
		}
	},
	crouch_still = {
		inherits = {
			"ogryn_heavystubber_spread_spraynpray_hip",
			"still"
		}
	},
	crouch_moving = {
		inherits = {
			"ogryn_heavystubber_spread_spraynpray_hip",
			"still"
		}
	}
}

return {
	base_templates = spread_templates,
	overrides = overrides
}
