local RecoilTemplate = require("scripts/utilities/recoil_template")
local generate_offset_range = RecoilTemplate.generate_offset_range
local create_scale = RecoilTemplate.create_scale
local spread_templates = {}
local overrides = {}

table.make_unique(spread_templates)
table.make_unique(overrides)

local assault_scale_m2 = {
	{
		1,
		{
			0.4,
			0.4
		}
	},
	{
		3,
		{
			1,
			1
		}
	},
	{
		6,
		{
			0.4,
			0.4
		}
	},
	{
		12,
		{
			0.01,
			0.01
		}
	},
	{
		18,
		{
			0.5,
			0.5
		}
	},
	{
		24,
		{
			0.01,
			0.01
		}
	},
	{
		30,
		{
			0.5,
			0.5
		}
	},
	{
		36,
		{
			0.01,
			0.01
		}
	},
	{
		42,
		{
			0.5,
			0.5
		}
	},
	{
		48,
		{
			0.01,
			0.01
		}
	},
	{
		54,
		{
			0.5,
			0.5
		}
	},
	{
		60,
		{
			0.01,
			0.01
		}
	},
	{
		66,
		{
			0.5,
			0.5
		}
	},
	{
		72,
		{
			0.01,
			0.01
		}
	},
	{
		78,
		{
			0.5,
			0.5
		}
	},
	{
		84,
		{
			0.01,
			0.01
		}
	},
	{
		90,
		{
			0.5,
			0.5
		}
	}
}
local braced_scale_m2 = {
	{
		1,
		{
			0.3,
			0.4
		}
	},
	{
		3,
		{
			0.5,
			0.5
		}
	},
	{
		6,
		{
			0.4,
			0.4
		}
	},
	{
		12,
		{
			0.75,
			0.75
		}
	},
	{
		18,
		{
			0.3,
			0.3
		}
	},
	{
		24,
		{
			0.01,
			0.01
		}
	},
	{
		30,
		{
			0.3,
			0.3
		}
	},
	{
		36,
		{
			0.01,
			0.01
		}
	},
	{
		42,
		{
			0.3,
			0.3
		}
	},
	{
		48,
		{
			0.01,
			0.01
		}
	},
	{
		54,
		{
			0.3,
			0.3
		}
	},
	{
		60,
		{
			0.01,
			0.01
		}
	},
	{
		66,
		{
			0.3,
			0.3
		}
	},
	{
		72,
		{
			0.01,
			0.01
		}
	},
	{
		78,
		{
			0.3,
			0.3
		}
	},
	{
		84,
		{
			0.01,
			0.01
		}
	},
	{
		90,
		{
			0.3,
			0.3
		}
	}
}
local braced_spread_range_m2 = generate_offset_range(90, 0.35, 0.4, 0.75, create_scale(braced_scale_m2))
local assault_spread_range_m2 = generate_offset_range(90, 0.725, 0.775, 0.85, create_scale(assault_scale_m2))
local assault_spread_range_m2_moving = generate_offset_range(90, 0.775, 0.825, 0.85, create_scale(assault_scale_m2))
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
local pitch_spread = 0.86
local yaw_spread = pitch_spread * 1.2
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
spread_templates.ogryn_heavystubber_spread_spraynpray_hip_m2 = {
	still = {
		max_spread = {
			yaw = 6,
			pitch = 6.4
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
			from_shooting_grace_time = 0.025,
			shooting = {
				yaw = 0.6,
				pitch = 0.575
			},
			idle = {
				yaw = 1.5,
				pitch = 1.5
			}
		},
		continuous_spread = {
			min_yaw = 1.6,
			min_pitch = 1.8
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
			shooting = assault_spread_range_m2
		}
	},
	moving = {
		inherits = {
			"ogryn_heavystubber_spread_spraynpray_hip_m2",
			"still"
		},
		continuous_spread = {
			min_yaw = 2.5,
			min_pitch = 2.5
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
			shooting = assault_spread_range_m2_moving
		}
	},
	crouch_still = {
		inherits = {
			"ogryn_heavystubber_spread_spraynpray_hip_m2",
			"still"
		}
	},
	crouch_moving = {
		inherits = {
			"ogryn_heavystubber_spread_spraynpray_hip_m2",
			"still"
		}
	}
}
spread_templates.default_ogryn_heavystubber_braced_m2 = {
	still = {
		max_spread = {
			yaw = 3.6,
			pitch = 3.6
		},
		randomized_spread = {
			random_ratio = 0.5,
			first_shot_min_ratio = 0.3,
			first_shot_random_ratio = 0.5,
			min_ratio = 0.15
		},
		decay = {
			from_shooting_grace_time = 0.3,
			shooting = {
				yaw = 0.7,
				pitch = 0.675
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
			shooting = braced_spread_range_m2,
			num_shots_clear_time = {
				lerp_perfect = 0.1,
				lerp_basic = 0.1
			}
		}
	},
	moving = {
		inherits = {
			"default_ogryn_heavystubber_braced_m2",
			"still"
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
		}
	},
	crouch_still = {
		inherits = {
			"default_ogryn_heavystubber_braced_m2",
			"still"
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
		}
	},
	crouch_moving = {
		inherits = {
			"default_ogryn_heavystubber_braced_m2",
			"still"
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
		}
	}
}
local pitch_spread_m3 = 0.97
local yaw_spread_m3 = pitch_spread * 1.1
spread_templates.ogryn_heavystubber_spread_spraynpray_hip_m3 = {
	still = {
		max_spread = {
			yaw = 5,
			pitch = 5.4
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
			min_yaw = 1.8,
			min_pitch = 1.8
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
					pitch = pitch_spread_m3 * 0.1,
					yaw = yaw_spread_m3 * 0.1
				},
				{
					pitch = pitch_spread_m3 * 0.1,
					yaw = yaw_spread_m3 * 0.1
				},
				{
					pitch = pitch_spread_m3 * 0.2,
					yaw = yaw_spread_m3 * 0.2
				},
				{
					pitch = pitch_spread_m3 * 0.4,
					yaw = yaw_spread_m3 * 0.4
				},
				{
					pitch = pitch_spread_m3 * 0.3,
					yaw = yaw_spread_m3 * 0.3
				},
				{
					pitch = pitch_spread_m3 * 0.2,
					yaw = yaw_spread_m3 * 0.2
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0
				},
				{
					pitch = pitch_spread_m3 * 0.1,
					yaw = yaw_spread_m3 * 0.1
				},
				{
					pitch = pitch_spread_m3 * 0.2,
					yaw = yaw_spread_m3 * 0.2
				},
				{
					pitch = pitch_spread_m3 * 0.1,
					yaw = yaw_spread_m3 * 0.1
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0
				},
				{
					pitch = pitch_spread_m3 * 0.1,
					yaw = yaw_spread_m3 * 0.1
				},
				{
					pitch = pitch_spread_m3 * 0.2,
					yaw = yaw_spread_m3 * 0.2
				},
				{
					pitch = pitch_spread_m3 * 0.1,
					yaw = yaw_spread_m3 * 0.1
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0
				},
				{
					pitch = pitch_spread_m3 * 0.1,
					yaw = yaw_spread_m3 * 0.1
				},
				{
					pitch = pitch_spread_m3 * 0.2,
					yaw = yaw_spread_m3 * 0.2
				},
				{
					pitch = pitch_spread_m3 * 0.1,
					yaw = yaw_spread_m3 * 0.1
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0
				},
				{
					pitch = pitch_spread_m3 * 0.1,
					yaw = yaw_spread_m3 * 0.1
				},
				{
					pitch = pitch_spread_m3 * 0.2,
					yaw = yaw_spread_m3 * 0.2
				},
				{
					pitch = pitch_spread_m3 * 0.1,
					yaw = yaw_spread_m3 * 0.1
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0
				},
				{
					pitch = pitch_spread_m3 * 0.1,
					yaw = yaw_spread_m3 * 0.1
				},
				{
					pitch = pitch_spread_m3 * 0.2,
					yaw = yaw_spread_m3 * 0.2
				},
				{
					pitch = pitch_spread_m3 * 0.1,
					yaw = yaw_spread_m3 * 0.1
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0
				},
				{
					pitch = pitch_spread_m3 * 0.1,
					yaw = yaw_spread_m3 * 0.1
				},
				{
					pitch = pitch_spread_m3 * 0.2,
					yaw = yaw_spread_m3 * 0.2
				},
				{
					pitch = pitch_spread_m3 * 0.1,
					yaw = yaw_spread_m3 * 0.1
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0
				},
				{
					pitch = pitch_spread_m3 * 0.1,
					yaw = yaw_spread_m3 * 0.1
				},
				{
					pitch = pitch_spread_m3 * 0.2,
					yaw = yaw_spread_m3 * 0.2
				},
				{
					pitch = pitch_spread_m3 * 0.1,
					yaw = yaw_spread_m3 * 0.1
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0
				},
				{
					pitch = pitch_spread_m3 * 0.1,
					yaw = yaw_spread_m3 * 0.1
				},
				{
					pitch = pitch_spread_m3 * 0.2,
					yaw = yaw_spread_m3 * 0.2
				},
				{
					pitch = pitch_spread_m3 * 0.1,
					yaw = yaw_spread_m3 * 0.1
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0
				},
				{
					pitch = pitch_spread_m3 * 0.1,
					yaw = yaw_spread_m3 * 0.1
				},
				{
					pitch = pitch_spread_m3 * 0.2,
					yaw = yaw_spread_m3 * 0.2
				},
				{
					pitch = pitch_spread_m3 * 0.1,
					yaw = yaw_spread_m3 * 0.1
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0
				},
				{
					pitch = pitch_spread_m3 * 0.1,
					yaw = yaw_spread_m3 * 0.1
				},
				{
					pitch = pitch_spread_m3 * 0.2,
					yaw = yaw_spread_m3 * 0.2
				},
				{
					pitch = pitch_spread_m3 * 0.1,
					yaw = yaw_spread_m3 * 0.1
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0
				},
				{
					pitch = pitch_spread_m3 * 0.1,
					yaw = yaw_spread_m3 * 0.1
				},
				{
					pitch = pitch_spread_m3 * 0.2,
					yaw = yaw_spread_m3 * 0.2
				},
				{
					pitch = pitch_spread_m3 * 0.1,
					yaw = yaw_spread_m3 * 0.1
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0
				},
				{
					pitch = pitch_spread_m3 * 0.1,
					yaw = yaw_spread_m3 * 0.1
				},
				{
					pitch = pitch_spread_m3 * 0.2,
					yaw = yaw_spread_m3 * 0.2
				},
				{
					pitch = pitch_spread_m3 * 0.1,
					yaw = yaw_spread_m3 * 0.1
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0
				},
				{
					pitch = pitch_spread_m3 * 0.14,
					yaw = yaw_spread_m3 * 0.14
				}
			}
		}
	},
	moving = {
		inherits = {
			"ogryn_heavystubber_spread_spraynpray_hip_m3",
			"still"
		},
		continuous_spread = {
			min_yaw = 1.8,
			min_pitch = 1.8
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
					pitch = pitch_spread_m3 * 0.2,
					yaw = yaw_spread_m3 * 0.2
				},
				{
					pitch = pitch_spread_m3 * 0.3,
					yaw = yaw_spread_m3 * 0.3
				},
				{
					pitch = pitch_spread_m3 * 0.5,
					yaw = yaw_spread_m3 * 0.5
				},
				{
					pitch = pitch_spread_m3 * 0.4,
					yaw = yaw_spread_m3 * 0.4
				},
				{
					pitch = pitch_spread_m3 * 0.3,
					yaw = yaw_spread_m3 * 0.3
				},
				{
					pitch = pitch_spread_m3 * 0.2,
					yaw = yaw_spread_m3 * 0.2
				}
			}
		}
	},
	crouch_still = {
		inherits = {
			"ogryn_heavystubber_spread_spraynpray_hip_m3",
			"still"
		}
	},
	crouch_moving = {
		inherits = {
			"ogryn_heavystubber_spread_spraynpray_hip_m3",
			"still"
		}
	}
}
pitch_spread_m3 = 0.6
yaw_spread_m3 = pitch_spread_m3
spread_templates.ogryn_heavystubber_spread_spraynpray_braced_m3 = {
	still = {
		max_spread = {
			yaw = 3,
			pitch = 3.4
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
			min_yaw = 1.5,
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
					pitch = pitch_spread_m3 * 0.01,
					yaw = yaw_spread_m3 * 0.01
				},
				{
					pitch = pitch_spread_m3 * 0.01,
					yaw = yaw_spread_m3 * 0.01
				},
				{
					pitch = pitch_spread_m3 * 0.02,
					yaw = yaw_spread_m3 * 0.02
				},
				{
					pitch = pitch_spread_m3 * 0.04,
					yaw = yaw_spread_m3 * 0.04
				},
				{
					pitch = pitch_spread_m3 * 0.05,
					yaw = yaw_spread_m3 * 0.05
				},
				{
					pitch = pitch_spread_m3 * 0.08,
					yaw = yaw_spread_m3 * 0.08
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0
				},
				{
					pitch = pitch_spread_m3 * 0.1,
					yaw = yaw_spread_m3 * 0.1
				},
				{
					pitch = pitch_spread_m3 * 0.2,
					yaw = yaw_spread_m3 * 0.2
				},
				{
					pitch = pitch_spread_m3 * 0.1,
					yaw = yaw_spread_m3 * 0.1
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0
				},
				{
					pitch = pitch_spread_m3 * 0.1,
					yaw = yaw_spread_m3 * 0.1
				},
				{
					pitch = pitch_spread_m3 * 0.2,
					yaw = yaw_spread_m3 * 0.2
				},
				{
					pitch = pitch_spread_m3 * 0.1,
					yaw = yaw_spread_m3 * 0.1
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0
				},
				{
					pitch = pitch_spread_m3 * 0.1,
					yaw = yaw_spread_m3 * 0.1
				},
				{
					pitch = pitch_spread_m3 * 0.2,
					yaw = yaw_spread_m3 * 0.2
				},
				{
					pitch = pitch_spread_m3 * 0.1,
					yaw = yaw_spread_m3 * 0.1
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0
				},
				{
					pitch = pitch_spread_m3 * 0.1,
					yaw = yaw_spread_m3 * 0.1
				},
				{
					pitch = pitch_spread_m3 * 0.2,
					yaw = yaw_spread_m3 * 0.2
				},
				{
					pitch = pitch_spread_m3 * 0.1,
					yaw = yaw_spread_m3 * 0.1
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0
				},
				{
					pitch = pitch_spread_m3 * 0.1,
					yaw = yaw_spread_m3 * 0.1
				},
				{
					pitch = pitch_spread_m3 * 0.2,
					yaw = yaw_spread_m3 * 0.2
				},
				{
					pitch = pitch_spread_m3 * 0.1,
					yaw = yaw_spread_m3 * 0.1
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0
				},
				{
					pitch = pitch_spread_m3 * 0.1,
					yaw = yaw_spread_m3 * 0.1
				},
				{
					pitch = pitch_spread_m3 * 0.2,
					yaw = yaw_spread_m3 * 0.2
				},
				{
					pitch = pitch_spread_m3 * 0.1,
					yaw = yaw_spread_m3 * 0.1
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0
				},
				{
					pitch = pitch_spread_m3 * 0.1,
					yaw = yaw_spread_m3 * 0.1
				},
				{
					pitch = pitch_spread_m3 * 0.2,
					yaw = yaw_spread_m3 * 0.2
				},
				{
					pitch = pitch_spread_m3 * 0.1,
					yaw = yaw_spread_m3 * 0.1
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0
				},
				{
					pitch = pitch_spread_m3 * 0.1,
					yaw = yaw_spread_m3 * 0.1
				},
				{
					pitch = pitch_spread_m3 * 0.2,
					yaw = yaw_spread_m3 * 0.2
				},
				{
					pitch = pitch_spread_m3 * 0.1,
					yaw = yaw_spread_m3 * 0.1
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0
				},
				{
					pitch = pitch_spread_m3 * 0.1,
					yaw = yaw_spread_m3 * 0.1
				},
				{
					pitch = pitch_spread_m3 * 0.2,
					yaw = yaw_spread_m3 * 0.2
				},
				{
					pitch = pitch_spread_m3 * 0.1,
					yaw = yaw_spread_m3 * 0.1
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0
				},
				{
					pitch = pitch_spread_m3 * 0.1,
					yaw = yaw_spread_m3 * 0.1
				},
				{
					pitch = pitch_spread_m3 * 0.2,
					yaw = yaw_spread_m3 * 0.2
				},
				{
					pitch = pitch_spread_m3 * 0.1,
					yaw = yaw_spread_m3 * 0.1
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0
				},
				{
					pitch = pitch_spread_m3 * 0.1,
					yaw = yaw_spread_m3 * 0.1
				},
				{
					pitch = pitch_spread_m3 * 0.2,
					yaw = yaw_spread_m3 * 0.2
				},
				{
					pitch = pitch_spread_m3 * 0.1,
					yaw = yaw_spread_m3 * 0.1
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0
				},
				{
					pitch = pitch_spread_m3 * 0.1,
					yaw = yaw_spread_m3 * 0.1
				},
				{
					pitch = pitch_spread_m3 * 0.2,
					yaw = yaw_spread_m3 * 0.2
				},
				{
					pitch = pitch_spread_m3 * 0.1,
					yaw = yaw_spread_m3 * 0.1
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0
				},
				{
					pitch = pitch_spread_m3 * 0,
					yaw = yaw_spread_m3 * 0
				},
				{
					pitch = pitch_spread_m3 * 0.14,
					yaw = yaw_spread_m3 * 0.14
				}
			}
		}
	},
	moving = {
		inherits = {
			"ogryn_heavystubber_spread_spraynpray_braced_m3",
			"still"
		},
		continuous_spread = {
			min_yaw = 1.8,
			min_pitch = 1.8
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
					pitch = pitch_spread_m3 * 0.2,
					yaw = yaw_spread_m3 * 0.2
				},
				{
					pitch = pitch_spread_m3 * 0.3,
					yaw = yaw_spread_m3 * 0.3
				},
				{
					pitch = pitch_spread_m3 * 0.5,
					yaw = yaw_spread_m3 * 0.5
				},
				{
					pitch = pitch_spread_m3 * 0.4,
					yaw = yaw_spread_m3 * 0.4
				},
				{
					pitch = pitch_spread_m3 * 0.3,
					yaw = yaw_spread_m3 * 0.3
				},
				{
					pitch = pitch_spread_m3 * 0.2,
					yaw = yaw_spread_m3 * 0.2
				}
			}
		}
	},
	crouch_still = {
		continuous_spread = {
			min_yaw = 1.2,
			min_pitch = 1.2
		},
		inherits = {
			"ogryn_heavystubber_spread_spraynpray_braced_m3",
			"still"
		}
	},
	crouch_moving = {
		inherits = {
			"ogryn_heavystubber_spread_spraynpray_braced_m3",
			"still"
		}
	}
}

return {
	base_templates = spread_templates,
	overrides = overrides
}
