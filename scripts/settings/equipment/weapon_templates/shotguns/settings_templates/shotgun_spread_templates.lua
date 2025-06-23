-- chunkname: @scripts/settings/equipment/weapon_templates/shotguns/settings_templates/shotgun_spread_templates.lua

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
spread_templates.shotgun_p1_m2_assault = {
	still = {
		max_spread = {
			yaw = 3.75,
			pitch = 3.75
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
				lerp_perfect = 1.625,
				lerp_basic = 1.875
			},
			min_yaw = {
				lerp_perfect = 1.625,
				lerp_basic = 1.875
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
				lerp_perfect = 1.875,
				lerp_basic = 2.125
			},
			min_yaw = {
				lerp_perfect = 1.875,
				lerp_basic = 2.125
			}
		},
		inherits = {
			"shotgun_p1_m2_assault",
			"still"
		}
	},
	crouch_still = {
		continuous_spread = {
			min_pitch = {
				lerp_perfect = 1.5,
				lerp_basic = 1.75
			},
			min_yaw = {
				lerp_perfect = 1.5,
				lerp_basic = 1.75
			}
		},
		inherits = {
			"shotgun_p1_m2_assault",
			"still"
		}
	},
	crouch_moving = {
		continuous_spread = {
			min_pitch = {
				lerp_perfect = 1.75,
				lerp_basic = 2
			},
			min_yaw = {
				lerp_perfect = 1.75,
				lerp_basic = 2
			}
		},
		inherits = {
			"shotgun_p1_m2_assault",
			"still"
		}
	}
}
spread_templates.shotgun_p1_m3_assault = {
	still = {
		max_spread = {
			yaw = 9.375,
			pitch = 9.375
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
				lerp_perfect = 4.0625,
				lerp_basic = 4.6875
			},
			min_yaw = {
				lerp_perfect = 4.0625,
				lerp_basic = 4.6875
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
				lerp_perfect = 4.6875,
				lerp_basic = 5.3125
			},
			min_yaw = {
				lerp_perfect = 4.6875,
				lerp_basic = 5.3125
			}
		},
		inherits = {
			"shotgun_p1_m3_assault",
			"still"
		}
	},
	crouch_still = {
		continuous_spread = {
			min_pitch = {
				lerp_perfect = 3.75,
				lerp_basic = 4.375
			},
			min_yaw = {
				lerp_perfect = 3.75,
				lerp_basic = 4.375
			}
		},
		inherits = {
			"shotgun_p1_m3_assault",
			"still"
		}
	},
	crouch_moving = {
		continuous_spread = {
			min_pitch = {
				lerp_perfect = 4.375,
				lerp_basic = 5
			},
			min_yaw = {
				lerp_perfect = 4.375,
				lerp_basic = 5
			}
		},
		inherits = {
			"shotgun_p1_m3_assault",
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
spread_templates.default_spread_shotgun_p2 = {
	still = {
		max_spread = {
			yaw = 6.8,
			pitch = 4.4
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
			random_ratio = 0.1,
			first_shot_min_ratio = 0.02,
			first_shot_random_ratio = 0.2,
			min_ratio = 0.1
		},
		continuous_spread = {
			min_pitch = {
				lerp_perfect = 4.4,
				lerp_basic = 4.4
			},
			min_yaw = {
				lerp_perfect = 6.8,
				lerp_basic = 6.8
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
						lerp_basic = 2
					},
					yaw = {
						lerp_perfect = 0.5,
						lerp_basic = 2
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
				lerp_perfect = 6,
				lerp_basic = 6
			},
			min_yaw = {
				lerp_perfect = 9.3,
				lerp_basic = 9.3
			}
		},
		inherits = {
			"default_spread_shotgun_p2",
			"still"
		}
	},
	crouch_still = {
		continuous_spread = {
			min_pitch = {
				lerp_perfect = 4.9,
				lerp_basic = 4.9
			},
			min_yaw = {
				lerp_perfect = 7.6,
				lerp_basic = 7.6
			}
		},
		inherits = {
			"default_spread_shotgun_p2",
			"still"
		}
	},
	crouch_moving = {
		continuous_spread = {
			min_pitch = {
				lerp_perfect = 5.5,
				lerp_basic = 5.5
			},
			min_yaw = {
				lerp_perfect = 8.5,
				lerp_basic = 8.5
			}
		},
		inherits = {
			"default_spread_shotgun_p2",
			"still"
		}
	}
}
spread_templates.special_spread_shotgun_p2 = {
	still = {
		max_spread = {
			yaw = 8.5,
			pitch = 5.5
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
				lerp_perfect = 11,
				lerp_basic = 11
			},
			min_yaw = {
				lerp_perfect = 11,
				lerp_basic = 11
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
						lerp_basic = 2
					},
					yaw = {
						lerp_perfect = 0.5,
						lerp_basic = 2
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
				lerp_basic = 12
			},
			min_yaw = {
				lerp_perfect = 3.75,
				lerp_basic = 12
			}
		},
		inherits = {
			"special_spread_shotgun_p2",
			"still"
		}
	},
	crouch_still = {
		continuous_spread = {
			min_pitch = {
				lerp_perfect = 3,
				lerp_basic = 7
			},
			min_yaw = {
				lerp_perfect = 3,
				lerp_basic = 7.5
			}
		},
		inherits = {
			"special_spread_shotgun_p2",
			"still"
		}
	},
	crouch_moving = {
		continuous_spread = {
			min_pitch = {
				lerp_perfect = 3.5,
				lerp_basic = 8
			},
			min_yaw = {
				lerp_perfect = 3.5,
				lerp_basic = 9
			}
		},
		inherits = {
			"special_spread_shotgun_p2",
			"still"
		}
	}
}
spread_templates.ads_spread_shotgun_p2 = {
	still = {
		max_spread = {
			yaw = 6,
			pitch = 6
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
				lerp_perfect = 3,
				lerp_basic = 7.75
			},
			min_yaw = {
				lerp_perfect = 3,
				lerp_basic = 8.9
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
						lerp_basic = 2
					},
					yaw = {
						lerp_perfect = 0.5,
						lerp_basic = 2
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
				lerp_basic = 12
			},
			min_yaw = {
				lerp_perfect = 3.75,
				lerp_basic = 12
			}
		},
		inherits = {
			"ads_spread_shotgun_p2",
			"still"
		}
	},
	crouch_still = {
		continuous_spread = {
			min_pitch = {
				lerp_perfect = 3,
				lerp_basic = 7
			},
			min_yaw = {
				lerp_perfect = 3,
				lerp_basic = 7.5
			}
		},
		inherits = {
			"ads_spread_shotgun_p2",
			"still"
		}
	},
	crouch_moving = {
		continuous_spread = {
			min_pitch = {
				lerp_perfect = 3.5,
				lerp_basic = 8
			},
			min_yaw = {
				lerp_perfect = 3.5,
				lerp_basic = 9
			}
		},
		inherits = {
			"ads_spread_shotgun_p2",
			"still"
		}
	}
}
spread_templates.default_spread_shotgun_p4_hip = {
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
			min_yaw = 2.5,
			min_pitch = 2.5
		},
		immediate_spread = {
			num_shots_clear_time = 1,
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
		inherits = {
			"default_spread_shotgun_p4_hip",
			"still"
		}
	},
	crouch_still = {
		inherits = {
			"default_spread_shotgun_p4_hip",
			"still"
		}
	},
	crouch_moving = {
		inherits = {
			"default_spread_shotgun_p4_hip",
			"still"
		}
	}
}
spread_templates.default_spread_shotgun_p4_ads = {
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
			min_yaw = 1,
			min_pitch = 1
		},
		immediate_spread = {
			num_shots_clear_time = 1,
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
			"default_spread_shotgun_p4_ads",
			"still"
		}
	},
	crouch_still = {
		inherits = {
			"default_spread_shotgun_p4_ads",
			"still"
		}
	},
	crouch_moving = {
		inherits = {
			"default_spread_shotgun_p4_ads",
			"still"
		}
	}
}
spread_templates.default_spread_shotgun_p4_m2_hip = {
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
				lerp_perfect = 2.25,
				lerp_basic = 2.75
			},
			min_yaw = {
				lerp_perfect = 2.25,
				lerp_basic = 2.75
			}
		},
		immediate_spread = {
			num_shots_clear_time = 1.1,
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
				lerp_perfect = 2.75,
				lerp_basic = 3.25
			},
			min_yaw = {
				lerp_perfect = 2.75,
				lerp_basic = 3.25
			}
		},
		inherits = {
			"default_spread_shotgun_p4_m2_hip",
			"still"
		}
	},
	crouch_still = {
		continuous_spread = {
			min_pitch = {
				lerp_perfect = 1.5,
				lerp_basic = 2.5
			},
			min_yaw = {
				lerp_perfect = 1.5,
				lerp_basic = 2.5
			}
		},
		inherits = {
			"default_spread_shotgun_p4_m2_hip",
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
			"default_spread_shotgun_p4_m2_hip",
			"still"
		}
	}
}
spread_templates.default_spread_shotgun_p4_m2_ads = {
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
			num_shots_clear_time = 1.1,
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
			"default_spread_shotgun_p4_m2_ads",
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
			"default_spread_shotgun_p4_m2_ads",
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
			"default_spread_shotgun_p4_m2_ads",
			"still"
		}
	}
}

return {
	base_templates = spread_templates,
	overrides = overrides
}
