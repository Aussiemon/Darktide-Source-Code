-- chunkname: @scripts/settings/equipment/weapon_templates/autoguns/settings_templates/autogun_spread_templates.lua

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

local p1_m1_multi = 1.25

spread_templates.autogun_assault_p1_m1 = {
	still = {
		max_spread = {
			yaw = 8,
			pitch = 8
		},
		randomized_spread = {
			random_ratio = 0.75,
			first_shot_min_ratio = 0.3,
			first_shot_random_ratio = 0.5,
			min_ratio = 0.15
		},
		decay = {
			from_shooting_grace_time = 0.3,
			shooting = {
				yaw = 0.35,
				pitch = 0.35
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
						lerp_basic = 0.45 * p1_m1_multi,
						lerp_perfect = 0.25 * p1_m1_multi
					},
					yaw = {
						lerp_basic = 0.45 * p1_m1_multi,
						lerp_perfect = 0.25 * p1_m1_multi
					}
				},
				{
					pitch = {
						lerp_basic = 0.25 * p1_m1_multi,
						lerp_perfect = 0.15 * p1_m1_multi
					},
					yaw = {
						lerp_basic = 0.25 * p1_m1_multi,
						lerp_perfect = 0.15 * p1_m1_multi
					}
				},
				{
					pitch = {
						lerp_basic = 0.45 * p1_m1_multi,
						lerp_perfect = 0.25 * p1_m1_multi
					},
					yaw = {
						lerp_basic = 0.45 * p1_m1_multi,
						lerp_perfect = 0.25 * p1_m1_multi
					}
				},
				{
					pitch = {
						lerp_basic = 0.6 * p1_m1_multi,
						lerp_perfect = 0.4 * p1_m1_multi
					},
					yaw = {
						lerp_basic = 0.6 * p1_m1_multi,
						lerp_perfect = 0.4 * p1_m1_multi
					}
				},
				{
					pitch = {
						lerp_basic = 0.35 * p1_m1_multi,
						lerp_perfect = 0.2 * p1_m1_multi
					},
					yaw = {
						lerp_basic = 0.35 * p1_m1_multi,
						lerp_perfect = 0.2 * p1_m1_multi
					}
				},
				{
					pitch = {
						lerp_basic = 0.3 * p1_m1_multi,
						lerp_perfect = 0.15 * p1_m1_multi
					},
					yaw = {
						lerp_basic = 0.3 * p1_m1_multi,
						lerp_perfect = 0.15 * p1_m1_multi
					}
				},
				{
					pitch = {
						lerp_basic = 0.3 * p1_m1_multi,
						lerp_perfect = 0.15 * p1_m1_multi
					},
					yaw = {
						lerp_basic = 0.3 * p1_m1_multi,
						lerp_perfect = 0.15 * p1_m1_multi
					}
				},
				{
					pitch = {
						lerp_basic = 0.3 * p1_m1_multi,
						lerp_perfect = 0.15 * p1_m1_multi
					},
					yaw = {
						lerp_basic = 0.3 * p1_m1_multi,
						lerp_perfect = 0.15 * p1_m1_multi
					}
				},
				{
					pitch = {
						lerp_basic = 0.3 * p1_m1_multi,
						lerp_perfect = 0.15 * p1_m1_multi
					},
					yaw = {
						lerp_basic = 0.3 * p1_m1_multi,
						lerp_perfect = 0.15 * p1_m1_multi
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

local p1_m2_multi = 1

spread_templates.autogun_assault_p1_m2 = {
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
				yaw = 0.75,
				pitch = 0.75
			},
			idle = {
				yaw = 2.25,
				pitch = 2.25
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
						lerp_basic = 0.45 * p1_m2_multi,
						lerp_perfect = 0.25 * p1_m2_multi
					},
					yaw = {
						lerp_basic = 0.45 * p1_m2_multi,
						lerp_perfect = 0.25 * p1_m2_multi
					}
				},
				{
					pitch = {
						lerp_basic = 0.25 * p1_m2_multi,
						lerp_perfect = 0.15 * p1_m2_multi
					},
					yaw = {
						lerp_basic = 0.25 * p1_m2_multi,
						lerp_perfect = 0.15 * p1_m2_multi
					}
				},
				{
					pitch = {
						lerp_basic = 0.45 * p1_m2_multi,
						lerp_perfect = 0.25 * p1_m2_multi
					},
					yaw = {
						lerp_basic = 0.45 * p1_m2_multi,
						lerp_perfect = 0.25 * p1_m2_multi
					}
				},
				{
					pitch = {
						lerp_basic = 0.6 * p1_m2_multi,
						lerp_perfect = 0.4 * p1_m2_multi
					},
					yaw = {
						lerp_basic = 0.6 * p1_m2_multi,
						lerp_perfect = 0.4 * p1_m2_multi
					}
				},
				{
					pitch = {
						lerp_basic = 0.35 * p1_m2_multi,
						lerp_perfect = 0.2 * p1_m2_multi
					},
					yaw = {
						lerp_basic = 0.35 * p1_m2_multi,
						lerp_perfect = 0.2 * p1_m2_multi
					}
				},
				{
					pitch = {
						lerp_basic = 0.3 * p1_m2_multi,
						lerp_perfect = 0.15 * p1_m2_multi
					},
					yaw = {
						lerp_basic = 0.3 * p1_m2_multi,
						lerp_perfect = 0.15 * p1_m2_multi
					}
				},
				{
					pitch = {
						lerp_basic = 0.3 * p1_m2_multi,
						lerp_perfect = 0.15 * p1_m2_multi
					},
					yaw = {
						lerp_basic = 0.3 * p1_m2_multi,
						lerp_perfect = 0.15 * p1_m2_multi
					}
				},
				{
					pitch = {
						lerp_basic = 0.3 * p1_m2_multi,
						lerp_perfect = 0.15 * p1_m2_multi
					},
					yaw = {
						lerp_basic = 0.3 * p1_m2_multi,
						lerp_perfect = 0.15 * p1_m2_multi
					}
				},
				{
					pitch = {
						lerp_basic = 0.3 * p1_m2_multi,
						lerp_perfect = 0.15 * p1_m2_multi
					},
					yaw = {
						lerp_basic = 0.3 * p1_m2_multi,
						lerp_perfect = 0.15 * p1_m2_multi
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
				lerp_basic = 2.5
			},
			min_yaw = {
				lerp_perfect = 2.05,
				lerp_basic = 2.5
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
				lerp_basic = 2.75
			},
			min_yaw = {
				lerp_perfect = 2.1,
				lerp_basic = 2.75
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
		randomized_spread = {
			random_ratio = 0.65,
			first_shot_min_ratio = 0.05,
			first_shot_random_ratio = 0.05,
			min_ratio = 0.35
		},
		decay = {
			from_shooting_grace_time = 0.25,
			shooting = {
				yaw = 0.05,
				pitch = 0.05
			},
			idle = {
				yaw = 0.75,
				pitch = 0.75
			}
		},
		continuous_spread = {
			min_pitch = {
				lerp_perfect = 1.2,
				lerp_basic = 2
			},
			min_yaw = {
				lerp_perfect = 1.2,
				lerp_basic = 2
			}
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
					yaw = 0.2,
					pitch = 0.2
				}
			}
		}
	},
	moving = {
		inherits = {
			"default_autogun_burst",
			"still"
		},
		continuous_spread = {
			min_pitch = {
				lerp_perfect = 1.4,
				lerp_basic = 2.2
			},
			min_yaw = {
				lerp_perfect = 1.4,
				lerp_basic = 2.2
			}
		}
	},
	crouch_still = {
		inherits = {
			"default_autogun_burst",
			"still"
		},
		continuous_spread = {
			min_pitch = {
				lerp_perfect = 1,
				lerp_basic = 1.4
			},
			min_yaw = {
				lerp_perfect = 1,
				lerp_basic = 1.4
			}
		}
	},
	crouch_moving = {
		inherits = {
			"default_autogun_burst",
			"still"
		},
		continuous_spread = {
			min_pitch = {
				lerp_perfect = 1.2,
				lerp_basic = 2
			},
			min_yaw = {
				lerp_perfect = 1.2,
				lerp_basic = 2
			}
		}
	}
}
spread_templates.default_autogun_burst_p3_m2 = {
	still = {
		max_spread = {
			yaw = 8,
			pitch = 8
		},
		randomized_spread = {
			random_ratio = 0.65,
			first_shot_min_ratio = 0.05,
			first_shot_random_ratio = 0.05,
			min_ratio = 0.35
		},
		decay = {
			from_shooting_grace_time = 0.25,
			shooting = {
				yaw = 0.05,
				pitch = 0.05
			},
			idle = {
				yaw = 0.75,
				pitch = 0.75
			}
		},
		continuous_spread = {
			min_pitch = {
				lerp_perfect = 1.2,
				lerp_basic = 2
			},
			min_yaw = {
				lerp_perfect = 1.2,
				lerp_basic = 2
			}
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
					yaw = 0.5,
					pitch = 0.5
				},
				{
					yaw = 0.15,
					pitch = 0.15
				},
				{
					yaw = 0.2,
					pitch = 0.2
				}
			}
		}
	},
	moving = {
		inherits = {
			"default_autogun_burst",
			"still"
		},
		continuous_spread = {
			min_pitch = {
				lerp_perfect = 1.4,
				lerp_basic = 2.2
			},
			min_yaw = {
				lerp_perfect = 1.4,
				lerp_basic = 2.2
			}
		}
	},
	crouch_still = {
		inherits = {
			"default_autogun_burst",
			"still"
		},
		continuous_spread = {
			min_pitch = {
				lerp_perfect = 1,
				lerp_basic = 1.4
			},
			min_yaw = {
				lerp_perfect = 1,
				lerp_basic = 1.4
			}
		}
	},
	crouch_moving = {
		inherits = {
			"default_autogun_burst",
			"still"
		},
		continuous_spread = {
			min_pitch = {
				lerp_perfect = 1.2,
				lerp_basic = 2
			},
			min_yaw = {
				lerp_perfect = 1.2,
				lerp_basic = 2
			}
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
			"default_autogun_alternate_fire_killshot",
			"still"
		},
		continuous_spread = {
			min_yaw = 0,
			min_pitch = 0
		}
	},
	crouch_still = {
		inherits = {
			"default_autogun_alternate_fire_killshot",
			"still"
		},
		continuous_spread = {
			min_yaw = 0,
			min_pitch = 0
		}
	},
	crouch_moving = {
		inherits = {
			"default_autogun_alternate_fire_killshot",
			"still"
		},
		continuous_spread = {
			min_yaw = 0,
			min_pitch = 0
		}
	}
}
spread_templates.default_autogun_spraynpray = {
	still = {
		max_spread = {
			yaw = 14,
			pitch = 12
		},
		randomized_spread = {
			first_shot_min_ratio = 0.1,
			max_yaw_delta = 0.45,
			first_shot_random_ratio = 0.65,
			random_ratio = 0.35,
			max_pitch_delta = 0.35,
			min_ratio = 0.35
		},
		decay = {
			from_shooting_grace_time = 0.3,
			shooting = {
				yaw = 0.15,
				pitch = 1.75
			},
			idle = {
				yaw = 1.75,
				pitch = 2
			}
		},
		continuous_spread = {
			min_yaw = 3.5,
			min_pitch = 1.5
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
					yaw = 0.6,
					pitch = 0.6
				},
				{
					yaw = 0.75,
					pitch = 0.75
				},
				{
					yaw = 0.6,
					pitch = 0.6
				},
				{
					yaw = 0.525,
					pitch = 0.45
				},
				{
					yaw = 0.45,
					pitch = 0.3
				},
				{
					yaw = 0.3,
					pitch = 0.2
				},
				{
					yaw = 0.225,
					pitch = 0.15
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
					yaw = 0,
					pitch = 0
				},
				{
					yaw = 0.3,
					pitch = 0.2
				},
				{
					yaw = 0.225,
					pitch = 0.15
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
					yaw = 0,
					pitch = 0
				},
				{
					yaw = 0.6,
					pitch = 0.4
				},
				{
					yaw = 0.225,
					pitch = 0.15
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
					yaw = 0,
					pitch = 0
				},
				{
					yaw = 0.3,
					pitch = 0.2
				},
				{
					yaw = 0.225,
					pitch = 0.15
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
					yaw = 0,
					pitch = 0
				},
				{
					yaw = 0.6,
					pitch = 0.4
				},
				{
					yaw = 0.225,
					pitch = 0.15
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
					yaw = 0,
					pitch = 0
				},
				{
					yaw = 0.3,
					pitch = 0.2
				},
				{
					yaw = 0.225,
					pitch = 0.15
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
					yaw = 0,
					pitch = 0
				},
				{
					yaw = 0.6,
					pitch = 0.4
				},
				{
					yaw = 0.225,
					pitch = 0.15
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
					yaw = 0,
					pitch = 0
				},
				{
					yaw = 0.3,
					pitch = 0.2
				},
				{
					yaw = 0.225,
					pitch = 0.15
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
					yaw = 0,
					pitch = 0
				},
				{
					yaw = 0.6,
					pitch = 0.4
				},
				{
					yaw = 0.225,
					pitch = 0.15
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
					yaw = 0,
					pitch = 0
				},
				{
					yaw = 0.3,
					pitch = 0.2
				},
				{
					yaw = 0.225,
					pitch = 0.15
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
					yaw = 0,
					pitch = 0
				},
				{
					yaw = 0.15,
					pitch = 0.1
				},
				{
					yaw = 0.1125,
					pitch = 0.075
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
					yaw = 0,
					pitch = 0
				},
				{
					yaw = 0.075,
					pitch = 0.075
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
			min_yaw = 5,
			min_pitch = 2
		}
	},
	crouch_still = {
		inherits = {
			"default_autogun_spraynpray",
			"still"
		},
		continuous_spread = {
			min_yaw = 3,
			min_pitch = 1
		}
	},
	crouch_moving = {
		inherits = {
			"default_autogun_spraynpray",
			"still"
		},
		continuous_spread = {
			min_yaw = 6,
			min_pitch = 3
		}
	}
}

local p2_perfect_multi = 0.75

spread_templates.autogun_p2_m1_hip = {
	still = {
		max_spread = {
			yaw = 8,
			pitch = 8
		},
		randomized_spread = {
			first_shot_min_ratio = 0.2,
			max_yaw_delta = 0.75,
			first_shot_random_ratio = 0.5,
			random_ratio = 0.75,
			max_pitch_delta = 0.75,
			min_ratio = 0.25
		},
		decay = {
			from_shooting_grace_time = 0.6,
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
				lerp_perfect = 1.8,
				lerp_basic = 2.4
			},
			min_yaw = {
				lerp_perfect = 1.8,
				lerp_basic = 2.4
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
						lerp_basic = 0.75,
						lerp_perfect = 0.45 * p2_perfect_multi
					},
					yaw = {
						lerp_basic = 0.75,
						lerp_perfect = 0.45 * p2_perfect_multi
					}
				},
				{
					pitch = {
						lerp_basic = 0.69,
						lerp_perfect = 0.41 * p2_perfect_multi
					},
					yaw = {
						lerp_basic = 0.69,
						lerp_perfect = 0.41 * p2_perfect_multi
					}
				},
				{
					pitch = {
						lerp_basic = 0.56,
						lerp_perfect = 0.34 * p2_perfect_multi
					},
					yaw = {
						lerp_basic = 0.56,
						lerp_perfect = 0.34 * p2_perfect_multi
					}
				},
				{
					pitch = {
						lerp_basic = 0.44,
						lerp_perfect = 0.26 * p2_perfect_multi
					},
					yaw = {
						lerp_basic = 0.44,
						lerp_perfect = 0.26 * p2_perfect_multi
					}
				},
				{
					pitch = {
						lerp_basic = 0.38,
						lerp_perfect = 0.23 * p2_perfect_multi
					},
					yaw = {
						lerp_basic = 0.38,
						lerp_perfect = 0.23 * p2_perfect_multi
					}
				},
				{
					pitch = {
						lerp_basic = 0.31,
						lerp_perfect = 0.19 * p2_perfect_multi
					},
					yaw = {
						lerp_basic = 0.31,
						lerp_perfect = 0.19 * p2_perfect_multi
					}
				},
				{
					pitch = {
						lerp_basic = 0.28,
						lerp_perfect = 0.17 * p2_perfect_multi
					},
					yaw = {
						lerp_basic = 0.28,
						lerp_perfect = 0.17 * p2_perfect_multi
					}
				},
				{
					pitch = {
						lerp_basic = 0.25,
						lerp_perfect = 0.15 * p2_perfect_multi
					},
					yaw = {
						lerp_basic = 0.25,
						lerp_perfect = 0.15 * p2_perfect_multi
					}
				},
				{
					pitch = {
						lerp_basic = 0.22,
						lerp_perfect = 0.13 * p2_perfect_multi
					},
					yaw = {
						lerp_basic = 0.22,
						lerp_perfect = 0.13 * p2_perfect_multi
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
			"autogun_p2_m1_hip",
			"still"
		},
		continuous_spread = {
			min_pitch = {
				lerp_perfect = 2.16,
				lerp_basic = 2.88
			},
			min_yaw = {
				lerp_perfect = 2.16,
				lerp_basic = 2.88
			}
		}
	},
	crouch_still = {
		inherits = {
			"autogun_p2_m1_hip",
			"still"
		},
		continuous_spread = {
			min_pitch = {
				lerp_perfect = 1.44,
				lerp_basic = 1.92
			},
			min_yaw = {
				lerp_perfect = 1.44,
				lerp_basic = 1.92
			}
		}
	},
	crouch_moving = {
		inherits = {
			"autogun_p2_m1_hip",
			"still"
		},
		continuous_spread = {
			min_pitch = {
				lerp_perfect = 2.7,
				lerp_basic = 3.6
			},
			min_yaw = {
				lerp_perfect = 2.7,
				lerp_basic = 3.6
			}
		}
	}
}
spread_templates.autogun_p2_m1_ads = {
	still = {
		max_spread = {
			yaw = 14,
			pitch = 12
		},
		randomized_spread = {
			first_shot_min_ratio = 0.1,
			max_yaw_delta = 0.9,
			first_shot_random_ratio = 0.65,
			random_ratio = 0.35,
			max_pitch_delta = 0.35,
			min_ratio = 0.35
		},
		decay = {
			from_shooting_grace_time = 0.3,
			shooting = {
				yaw = 0.3,
				pitch = 1.75
			},
			idle = {
				yaw = 1.75,
				pitch = 2
			}
		},
		continuous_spread = {
			min_yaw = 3.5,
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
					yaw = 0.6,
					pitch = 0.6
				},
				{
					yaw = 0.75,
					pitch = 0.75
				},
				{
					yaw = 0.6,
					pitch = 0.6
				},
				{
					yaw = 0.525,
					pitch = 0.45
				},
				{
					yaw = 0.45,
					pitch = 0.3
				},
				{
					yaw = 0.3,
					pitch = 0.2
				},
				{
					yaw = 0.225,
					pitch = 0.15
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
					yaw = 0,
					pitch = 0
				},
				{
					yaw = 0.3,
					pitch = 0.2
				},
				{
					yaw = 0.225,
					pitch = 0.15
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
					yaw = 0,
					pitch = 0
				},
				{
					yaw = 0.6,
					pitch = 0.4
				},
				{
					yaw = 0.225,
					pitch = 0.15
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
					yaw = 0,
					pitch = 0
				},
				{
					yaw = 0.3,
					pitch = 0.2
				},
				{
					yaw = 0.225,
					pitch = 0.15
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
					yaw = 0,
					pitch = 0
				},
				{
					yaw = 0.6,
					pitch = 0.4
				},
				{
					yaw = 0.225,
					pitch = 0.15
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
					yaw = 0,
					pitch = 0
				},
				{
					yaw = 0.3,
					pitch = 0.2
				},
				{
					yaw = 0.225,
					pitch = 0.15
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
					yaw = 0,
					pitch = 0
				},
				{
					yaw = 0.6,
					pitch = 0.4
				},
				{
					yaw = 0.225,
					pitch = 0.15
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
					yaw = 0,
					pitch = 0
				},
				{
					yaw = 0.3,
					pitch = 0.2
				},
				{
					yaw = 0.225,
					pitch = 0.15
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
					yaw = 0,
					pitch = 0
				},
				{
					yaw = 0.6,
					pitch = 0.4
				},
				{
					yaw = 0.225,
					pitch = 0.15
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
					yaw = 0,
					pitch = 0
				},
				{
					yaw = 0.3,
					pitch = 0.2
				},
				{
					yaw = 0.225,
					pitch = 0.15
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
					yaw = 0,
					pitch = 0
				},
				{
					yaw = 0.15,
					pitch = 0.1
				},
				{
					yaw = 0.1125,
					pitch = 0.075
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
					yaw = 0,
					pitch = 0
				},
				{
					yaw = 0.075,
					pitch = 0.075
				}
			}
		}
	},
	moving = {
		inherits = {
			"autogun_p2_m1_ads",
			"still"
		},
		continuous_spread = {
			min_yaw = 5,
			min_pitch = 2
		}
	},
	crouch_still = {
		inherits = {
			"autogun_p2_m1_ads",
			"still"
		},
		continuous_spread = {
			min_yaw = 3,
			min_pitch = 1
		}
	},
	crouch_moving = {
		inherits = {
			"autogun_p2_m1_ads",
			"still"
		},
		continuous_spread = {
			min_yaw = 6,
			min_pitch = 3
		}
	}
}
spread_templates.autogun_p2_m2_hip = {
	still = {
		max_spread = {
			yaw = 8,
			pitch = 8
		},
		randomized_spread = {
			first_shot_min_ratio = 0.15,
			max_yaw_delta = 0.75,
			first_shot_random_ratio = 0.45,
			random_ratio = 0.75,
			max_pitch_delta = 0.75,
			min_ratio = 0.25
		},
		decay = {
			from_shooting_grace_time = 0.3,
			shooting = {
				yaw = 0.4,
				pitch = 0.4
			},
			idle = {
				yaw = 2,
				pitch = 2
			}
		},
		continuous_spread = {
			min_pitch = {
				lerp_perfect = 1.8,
				lerp_basic = 2.4
			},
			min_yaw = {
				lerp_perfect = 1.8,
				lerp_basic = 2.4
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
						lerp_perfect = 0.34,
						lerp_basic = 0.56
					},
					yaw = {
						lerp_perfect = 0.34,
						lerp_basic = 0.56
					}
				},
				{
					pitch = {
						lerp_perfect = 0.31,
						lerp_basic = 0.51
					},
					yaw = {
						lerp_perfect = 0.31,
						lerp_basic = 0.51
					}
				},
				{
					pitch = {
						lerp_perfect = 0.26,
						lerp_basic = 0.43
					},
					yaw = {
						lerp_perfect = 0.26,
						lerp_basic = 0.43
					}
				},
				{
					pitch = {
						lerp_perfect = 0.2,
						lerp_basic = 0.33
					},
					yaw = {
						lerp_perfect = 0.2,
						lerp_basic = 0.33
					}
				},
				{
					pitch = {
						lerp_perfect = 0.17,
						lerp_basic = 0.29
					},
					yaw = {
						lerp_perfect = 0.17,
						lerp_basic = 0.29
					}
				},
				{
					pitch = {
						lerp_perfect = 0.14,
						lerp_basic = 0.24
					},
					yaw = {
						lerp_perfect = 0.14,
						lerp_basic = 0.24
					}
				},
				{
					pitch = {
						lerp_perfect = 0.13,
						lerp_basic = 0.21
					},
					yaw = {
						lerp_perfect = 0.13,
						lerp_basic = 0.21
					}
				},
				{
					pitch = {
						lerp_perfect = 0.11,
						lerp_basic = 0.19
					},
					yaw = {
						lerp_perfect = 0.11,
						lerp_basic = 0.19
					}
				},
				{
					pitch = {
						lerp_perfect = 0.1,
						lerp_basic = 0.16
					},
					yaw = {
						lerp_perfect = 0.1,
						lerp_basic = 0.16
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
			"autogun_p2_m2_hip",
			"still"
		},
		continuous_spread = {
			min_pitch = {
				lerp_perfect = 2.16,
				lerp_basic = 2.88
			},
			min_yaw = {
				lerp_perfect = 2.16,
				lerp_basic = 2.88
			}
		}
	},
	crouch_still = {
		inherits = {
			"autogun_p2_m2_hip",
			"still"
		},
		continuous_spread = {
			min_pitch = {
				lerp_perfect = 1.44,
				lerp_basic = 1.92
			},
			min_yaw = {
				lerp_perfect = 1.44,
				lerp_basic = 1.92
			}
		}
	},
	crouch_moving = {
		inherits = {
			"autogun_p2_m2_hip",
			"still"
		},
		continuous_spread = {
			min_pitch = {
				lerp_perfect = 2.7,
				lerp_basic = 3.6
			},
			min_yaw = {
				lerp_perfect = 2.7,
				lerp_basic = 3.6
			}
		}
	}
}
spread_templates.autogun_p2_m2_ads = {
	still = {
		max_spread = {
			yaw = 8,
			pitch = 8
		},
		randomized_spread = {
			first_shot_min_ratio = 0.1275,
			max_yaw_delta = 1,
			first_shot_random_ratio = 0.3825,
			random_ratio = 0.6325,
			max_pitch_delta = 1,
			min_ratio = 0.2875
		},
		decay = {
			from_shooting_grace_time = 0.3,
			shooting = {
				pitch = {
					lerp_perfect = 1.25,
					lerp_basic = 0.8500000000000001
				},
				yaw = {
					lerp_perfect = 1.25,
					lerp_basic = 0.8500000000000001
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
		},
		continuous_spread = {
			min_pitch = {
				lerp_perfect = 1.25,
				lerp_basic = 1.75
			},
			min_yaw = {
				lerp_perfect = 1.75,
				lerp_basic = 2.5
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
						lerp_perfect = 0.252,
						lerp_basic = 0.42
					},
					yaw = {
						lerp_perfect = 0.252,
						lerp_basic = 0.42
					}
				},
				{
					pitch = {
						lerp_perfect = 0.294,
						lerp_basic = 0.48999999999999994
					},
					yaw = {
						lerp_perfect = 0.294,
						lerp_basic = 0.48999999999999994
					}
				},
				{
					pitch = {
						lerp_perfect = 0.336,
						lerp_basic = 0.5599999999999999
					},
					yaw = {
						lerp_perfect = 0.336,
						lerp_basic = 0.5599999999999999
					}
				},
				{
					pitch = {
						lerp_perfect = 0.378,
						lerp_basic = 0.63
					},
					yaw = {
						lerp_perfect = 0.378,
						lerp_basic = 0.63
					}
				},
				{
					pitch = {
						lerp_perfect = 0.42,
						lerp_basic = 0.7
					},
					yaw = {
						lerp_perfect = 0.42,
						lerp_basic = 0.7
					}
				},
				{
					pitch = {
						lerp_perfect = 0.38,
						lerp_basic = 0.64
					},
					yaw = {
						lerp_perfect = 0.38,
						lerp_basic = 0.64
					}
				},
				{
					pitch = {
						lerp_perfect = 0.32,
						lerp_basic = 0.54
					},
					yaw = {
						lerp_perfect = 0.32,
						lerp_basic = 0.54
					}
				},
				{
					pitch = {
						lerp_perfect = 0.25,
						lerp_basic = 0.41
					},
					yaw = {
						lerp_perfect = 0.25,
						lerp_basic = 0.41
					}
				},
				{
					pitch = {
						lerp_perfect = 0.22,
						lerp_basic = 0.36
					},
					yaw = {
						lerp_perfect = 0.22,
						lerp_basic = 0.36
					}
				},
				{
					pitch = {
						lerp_perfect = 0.18,
						lerp_basic = 0.3
					},
					yaw = {
						lerp_perfect = 0.18,
						lerp_basic = 0.3
					}
				},
				{
					pitch = {
						lerp_perfect = 0.16,
						lerp_basic = 0.26
					},
					yaw = {
						lerp_perfect = 0.16,
						lerp_basic = 0.26
					}
				},
				{
					pitch = {
						lerp_perfect = 0.14,
						lerp_basic = 0.24
					},
					yaw = {
						lerp_perfect = 0.14,
						lerp_basic = 0.24
					}
				},
				{
					pitch = {
						lerp_perfect = 0.12,
						lerp_basic = 0.2
					},
					yaw = {
						lerp_perfect = 0.12,
						lerp_basic = 0.2
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
			"autogun_p2_m2_ads",
			"still"
		},
		continuous_spread = {
			min_pitch = {
				lerp_perfect = 1.75,
				lerp_basic = 2.25
			},
			min_yaw = {
				lerp_perfect = 2.5,
				lerp_basic = 3
			}
		}
	},
	crouch_still = {
		inherits = {
			"autogun_p2_m2_ads",
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
	crouch_moving = {
		inherits = {
			"autogun_p2_m2_ads",
			"still"
		},
		continuous_spread = {
			min_pitch = {
				lerp_perfect = 1.5,
				lerp_basic = 2.5
			},
			min_yaw = {
				lerp_perfect = 2,
				lerp_basic = 3.25
			}
		}
	}
}
spread_templates.autogun_p2_m3_hip = {
	still = {
		max_spread = {
			yaw = 8,
			pitch = 8
		},
		randomized_spread = {
			first_shot_min_ratio = 0.15,
			max_yaw_delta = 0.75,
			first_shot_random_ratio = 0.55,
			random_ratio = 0.85,
			max_pitch_delta = 0.75,
			min_ratio = 0.15
		},
		decay = {
			from_shooting_grace_time = 0.3,
			shooting = {
				yaw = 0.4,
				pitch = 0.4
			},
			idle = {
				yaw = 2,
				pitch = 2
			}
		},
		continuous_spread = {
			min_pitch = {
				lerp_perfect = 1.8,
				lerp_basic = 2.4
			},
			min_yaw = {
				lerp_perfect = 1.8,
				lerp_basic = 2.4
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
						lerp_perfect = 0.34,
						lerp_basic = 0.56
					},
					yaw = {
						lerp_perfect = 0.34,
						lerp_basic = 0.56
					}
				},
				{
					pitch = {
						lerp_perfect = 0.31,
						lerp_basic = 0.51
					},
					yaw = {
						lerp_perfect = 0.31,
						lerp_basic = 0.51
					}
				},
				{
					pitch = {
						lerp_perfect = 0.26,
						lerp_basic = 0.43
					},
					yaw = {
						lerp_perfect = 0.26,
						lerp_basic = 0.43
					}
				},
				{
					pitch = {
						lerp_perfect = 0.2,
						lerp_basic = 0.33
					},
					yaw = {
						lerp_perfect = 0.2,
						lerp_basic = 0.33
					}
				},
				{
					pitch = {
						lerp_perfect = 0.17,
						lerp_basic = 0.29
					},
					yaw = {
						lerp_perfect = 0.17,
						lerp_basic = 0.29
					}
				},
				{
					pitch = {
						lerp_perfect = 0.14,
						lerp_basic = 0.24
					},
					yaw = {
						lerp_perfect = 0.14,
						lerp_basic = 0.24
					}
				},
				{
					pitch = {
						lerp_perfect = 0.13,
						lerp_basic = 0.21
					},
					yaw = {
						lerp_perfect = 0.13,
						lerp_basic = 0.21
					}
				},
				{
					pitch = {
						lerp_perfect = 0.11,
						lerp_basic = 0.19
					},
					yaw = {
						lerp_perfect = 0.11,
						lerp_basic = 0.19
					}
				},
				{
					pitch = {
						lerp_perfect = 0.1,
						lerp_basic = 0.16
					},
					yaw = {
						lerp_perfect = 0.1,
						lerp_basic = 0.16
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
			"autogun_p2_m3_hip",
			"still"
		},
		continuous_spread = {
			min_pitch = {
				lerp_perfect = 2.16,
				lerp_basic = 2.88
			},
			min_yaw = {
				lerp_perfect = 2.16,
				lerp_basic = 2.88
			}
		}
	},
	crouch_still = {
		inherits = {
			"autogun_p2_m3_hip",
			"still"
		},
		continuous_spread = {
			min_pitch = {
				lerp_perfect = 1.44,
				lerp_basic = 1.92
			},
			min_yaw = {
				lerp_perfect = 1.44,
				lerp_basic = 1.92
			}
		}
	},
	crouch_moving = {
		inherits = {
			"autogun_p2_m3_hip",
			"still"
		},
		continuous_spread = {
			min_pitch = {
				lerp_perfect = 2.7,
				lerp_basic = 3.6
			},
			min_yaw = {
				lerp_perfect = 2.7,
				lerp_basic = 3.6
			}
		}
	}
}
spread_templates.autogun_p2_m3_ads = {
	still = {
		max_spread = {
			yaw = 8,
			pitch = 8
		},
		randomized_spread = {
			first_shot_min_ratio = 0.2,
			max_yaw_delta = 0.95,
			first_shot_random_ratio = 0.4,
			random_ratio = 0.55,
			max_pitch_delta = 0.95,
			min_ratio = 0.25
		},
		decay = {
			from_shooting_grace_time = 0.3,
			shooting = {
				yaw = 0.1,
				pitch = 0.1
			},
			idle = {
				yaw = 2.5,
				pitch = 2.5
			}
		},
		continuous_spread = {
			min_pitch = {
				lerp_perfect = 1.2,
				lerp_basic = 2
			},
			min_yaw = {
				lerp_perfect = 1.2,
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
						lerp_perfect = 0.17,
						lerp_basic = 0.28
					},
					yaw = {
						lerp_perfect = 0.17,
						lerp_basic = 0.28
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
						lerp_perfect = 0.12,
						lerp_basic = 0.2
					},
					yaw = {
						lerp_perfect = 0.12,
						lerp_basic = 0.2
					}
				},
				{
					pitch = {
						lerp_perfect = 0.1,
						lerp_basic = 0.16
					},
					yaw = {
						lerp_perfect = 0.1,
						lerp_basic = 0.16
					}
				},
				{
					pitch = {
						lerp_perfect = 0.08,
						lerp_basic = 0.14
					},
					yaw = {
						lerp_perfect = 0.08,
						lerp_basic = 0.14
					}
				},
				{
					pitch = {
						lerp_perfect = 0.07,
						lerp_basic = 0.11
					},
					yaw = {
						lerp_perfect = 0.07,
						lerp_basic = 0.11
					}
				},
				{
					pitch = {
						lerp_perfect = 0.06,
						lerp_basic = 0.1
					},
					yaw = {
						lerp_perfect = 0.06,
						lerp_basic = 0.1
					}
				},
				{
					pitch = {
						lerp_perfect = 0.05,
						lerp_basic = 0.09
					},
					yaw = {
						lerp_perfect = 0.05,
						lerp_basic = 0.09
					}
				},
				{
					pitch = {
						lerp_perfect = 0.05,
						lerp_basic = 0.08
					},
					yaw = {
						lerp_perfect = 0.05,
						lerp_basic = 0.08
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
			"autogun_p2_m3_ads",
			"still"
		},
		continuous_spread = {
			min_pitch = {
				lerp_perfect = 2.16,
				lerp_basic = 2.88
			},
			min_yaw = {
				lerp_perfect = 2.16,
				lerp_basic = 2.88
			}
		}
	},
	crouch_still = {
		inherits = {
			"autogun_p2_m3_ads",
			"still"
		},
		continuous_spread = {
			min_pitch = {
				lerp_perfect = 1,
				lerp_basic = 1.5
			},
			min_yaw = {
				lerp_perfect = 1,
				lerp_basic = 1.5
			}
		}
	},
	crouch_moving = {
		inherits = {
			"autogun_p2_m3_ads",
			"still"
		},
		continuous_spread = {
			min_pitch = {
				lerp_perfect = 1.86,
				lerp_basic = 2.44
			},
			min_yaw = {
				lerp_perfect = 1.86,
				lerp_basic = 2.44
			}
		}
	}
}

return {
	base_templates = spread_templates,
	overrides = overrides
}
