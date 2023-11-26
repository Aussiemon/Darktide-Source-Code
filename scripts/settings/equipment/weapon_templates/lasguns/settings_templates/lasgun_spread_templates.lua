-- chunkname: @scripts/settings/equipment/weapon_templates/lasguns/settings_templates/lasgun_spread_templates.lua

local spread_templates = {}
local overrides = {}

table.make_unique(spread_templates)
table.make_unique(overrides)

spread_templates.hip_lasgun_assault = {
	still = {
		max_spread = {
			yaw = 5,
			pitch = 5
		},
		decay = {
			from_shooting_grace_time = 0.075,
			shooting = {
				yaw = 0.75,
				pitch = 0.75
			},
			idle = {
				yaw = 1.5,
				pitch = 1.5
			}
		},
		continuous_spread = {
			min_yaw = 1,
			min_pitch = 1
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
					yaw = 0.5,
					pitch = 0.5
				},
				{
					yaw = 0.75,
					pitch = 0.75
				},
				{
					yaw = 1.25,
					pitch = 1.25
				},
				{
					yaw = 1,
					pitch = 1
				},
				{
					yaw = 0.75,
					pitch = 0.75
				},
				{
					yaw = 0.6,
					pitch = 0.6
				}
			}
		}
	},
	moving = {
		inherits = {
			"hip_lasgun_assault",
			"still"
		},
		continuous_spread = {
			min_yaw = 1.5,
			min_pitch = 1.5
		}
	},
	crouch_still = {
		inherits = {
			"hip_lasgun_assault",
			"still"
		},
		continuous_spread = {
			min_yaw = 1.15,
			min_pitch = 1.15
		}
	},
	crouch_moving = {
		inherits = {
			"hip_lasgun_assault",
			"still"
		},
		continuous_spread = {
			min_yaw = 2,
			min_pitch = 2
		}
	}
}

local pitch_spread = 0.8
local yaw_spread = pitch_spread * 1

spread_templates.default_lasgun_spraynpray = {
	still = {
		max_spread = {
			yaw = 13,
			pitch = 10
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
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1
				}
			}
		}
	},
	moving = {
		inherits = {
			"default_lasgun_spraynpray",
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
			"default_lasgun_spraynpray",
			"still"
		}
	},
	crouch_moving = {
		inherits = {
			"default_lasgun_spraynpray",
			"still"
		}
	}
}

local spread_multi = 0.8
local base_spread = 4
local perfect_spread = 2.25

spread_templates.hip_lasgun_killshot = {
	still = {
		max_spread = {
			pitch = {
				lerp_perfect = 3,
				lerp_basic = 3.25
			},
			yaw = {
				lerp_perfect = 3,
				lerp_basic = 3.25
			}
		},
		decay = {
			from_shooting_grace_time = 0.15,
			shooting = {
				pitch = {
					lerp_perfect = 0.25,
					lerp_basic = 0.15
				},
				yaw = {
					lerp_perfect = 0.25,
					lerp_basic = 0.15
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
				lerp_perfect = 1,
				lerp_basic = 1.5
			},
			min_yaw = {
				lerp_perfect = 1,
				lerp_basic = 1.5
			}
		},
		randomized_spread = {
			first_shot_min_ratio = 0.3,
			max_yaw_delta = 0.8,
			first_shot_random_ratio = 0.8,
			random_ratio = 0.85,
			max_pitch_delta = 0.8,
			min_ratio = 0.15
		},
		immediate_spread = {
			num_shots_clear_time = 0.5,
			suppression_hit = {
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
						lerp_perfect = 0.75,
						lerp_basic = 2 * spread_multi
					},
					yaw = {
						lerp_perfect = 0.5,
						lerp_basic = 2 * spread_multi
					}
				},
				{
					pitch = {
						lerp_perfect = 0.5,
						lerp_basic = 1.75 * spread_multi
					},
					yaw = {
						lerp_perfect = 0.5,
						lerp_basic = 1.75 * spread_multi
					}
				},
				{
					pitch = {
						lerp_perfect = 0.5,
						lerp_basic = 1.5 * spread_multi
					},
					yaw = {
						lerp_perfect = 0.5,
						lerp_basic = 1.5 * spread_multi
					}
				},
				{
					pitch = {
						lerp_perfect = 0.5,
						lerp_basic = 1.375 * spread_multi
					},
					yaw = {
						lerp_perfect = 0.5,
						lerp_basic = 1.375 * spread_multi
					}
				},
				{
					pitch = {
						lerp_perfect = 0.5,
						lerp_basic = 1.3 * spread_multi
					},
					yaw = {
						lerp_perfect = 0.5,
						lerp_basic = 1.3 * spread_multi
					}
				},
				{
					pitch = {
						lerp_perfect = 0.5,
						lerp_basic = 1.3 * spread_multi
					},
					yaw = {
						lerp_perfect = 0.5,
						lerp_basic = 1.3 * spread_multi
					}
				},
				{
					pitch = {
						lerp_perfect = 0.5,
						lerp_basic = 1.15 * spread_multi
					},
					yaw = {
						lerp_perfect = 0.5,
						lerp_basic = 1.15 * spread_multi
					}
				}
			}
		}
	},
	moving = {
		inherits = {
			"hip_lasgun_killshot",
			"still"
		},
		continuous_spread = {
			min_pitch = {
				lerp_perfect = 1.8,
				lerp_basic = 2.5
			},
			min_yaw = {
				lerp_perfect = 2,
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
		},
		immediate_spread = {
			num_shots_clear_time = 0.5,
			suppression_hit = {
				{
					pitch = {
						lerp_perfect = 0.5,
						lerp_basic = 1.5
					},
					yaw = {
						lerp_perfect = 0.5,
						lerp_basic = 1.5
					}
				}
			},
			damage_hit = {
				{
					pitch = {
						lerp_perfect = 1.25,
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
						lerp_perfect = 0.4,
						lerp_basic = 1.65
					},
					yaw = {
						lerp_perfect = 0.4,
						lerp_basic = 1.65
					}
				},
				{
					pitch = {
						lerp_perfect = 0.5,
						lerp_basic = 1.35
					},
					yaw = {
						lerp_perfect = 0.5,
						lerp_basic = 1.35
					}
				}
			}
		}
	},
	crouch_still = {
		inherits = {
			"hip_lasgun_killshot",
			"still"
		},
		continuous_spread = {
			min_pitch = {
				lerp_perfect = 0.7,
				lerp_basic = 1.4
			},
			min_yaw = {
				lerp_perfect = 0.8,
				lerp_basic = 1.3
			}
		}
	},
	crouch_moving = {
		inherits = {
			"hip_lasgun_killshot",
			"still"
		},
		continuous_spread = {
			min_pitch = {
				lerp_perfect = 2.3,
				lerp_basic = 2.15
			},
			min_yaw = {
				lerp_perfect = 2.3,
				lerp_basic = 2.15
			}
		}
	}
}
spread_templates.hip_lasgun_killshot_p1_m2 = {
	still = {
		max_spread = {
			pitch = {
				lerp_perfect = 3,
				lerp_basic = 3.25
			},
			yaw = {
				lerp_perfect = 3,
				lerp_basic = 3.25
			}
		},
		decay = {
			from_shooting_grace_time = 0.15,
			shooting = {
				pitch = {
					lerp_perfect = 0.4,
					lerp_basic = 0.15
				},
				yaw = {
					lerp_perfect = 0.4,
					lerp_basic = 0.15
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
				lerp_perfect = 1,
				lerp_basic = 1.25
			},
			min_yaw = {
				lerp_perfect = 1,
				lerp_basic = 1.25
			}
		},
		randomized_spread = {
			first_shot_min_ratio = 0.2,
			max_yaw_delta = 0.5,
			first_shot_random_ratio = 0.6,
			random_ratio = 0.9,
			max_pitch_delta = 0.5,
			min_ratio = 0.1
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
						lerp_perfect = 0.5,
						lerp_basic = 2 * spread_multi
					},
					yaw = {
						lerp_perfect = 0.5,
						lerp_basic = 2 * spread_multi
					}
				},
				{
					pitch = {
						lerp_perfect = 0.25,
						lerp_basic = 1.75 * spread_multi
					},
					yaw = {
						lerp_perfect = 0.25,
						lerp_basic = 1.75 * spread_multi
					}
				},
				{
					pitch = {
						lerp_perfect = 0.15,
						lerp_basic = 1.5 * spread_multi
					},
					yaw = {
						lerp_perfect = 0.15,
						lerp_basic = 1.5 * spread_multi
					}
				},
				{
					pitch = {
						lerp_perfect = 0.175,
						lerp_basic = 1.375 * spread_multi
					},
					yaw = {
						lerp_perfect = 0.175,
						lerp_basic = 1.375 * spread_multi
					}
				},
				{
					pitch = {
						lerp_perfect = 0.2,
						lerp_basic = 1.3 * spread_multi
					},
					yaw = {
						lerp_perfect = 0.2,
						lerp_basic = 1.3 * spread_multi
					}
				},
				{
					pitch = {
						lerp_perfect = 0.2,
						lerp_basic = 1.3 * spread_multi
					},
					yaw = {
						lerp_perfect = 0.2,
						lerp_basic = 1.3 * spread_multi
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
			"hip_lasgun_killshot_p1_m2",
			"still"
		},
		continuous_spread = {
			min_pitch = {
				lerp_perfect = 1.25,
				lerp_basic = 1.5
			},
			min_yaw = {
				lerp_perfect = 1.25,
				lerp_basic = 1.5
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
		},
		immediate_spread = {
			num_shots_clear_time = 1.2,
			suppression_hit = {
				{
					pitch = {
						lerp_perfect = 0.5,
						lerp_basic = 1
					},
					yaw = {
						lerp_perfect = 0.5,
						lerp_basic = 1
					}
				}
			},
			damage_hit = {
				{
					pitch = {
						lerp_perfect = 1.25,
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
						lerp_perfect = 0.4,
						lerp_basic = 1.65
					},
					yaw = {
						lerp_perfect = 0.4,
						lerp_basic = 1.65
					}
				},
				{
					pitch = {
						lerp_perfect = 0.5,
						lerp_basic = 1.35
					},
					yaw = {
						lerp_perfect = 0.5,
						lerp_basic = 1.35
					}
				}
			}
		}
	},
	crouch_still = {
		inherits = {
			"hip_lasgun_killshot_p1_m2",
			"still"
		},
		continuous_spread = {
			min_pitch = {
				lerp_perfect = 0.5,
				lerp_basic = 0.8
			},
			min_yaw = {
				lerp_perfect = 0.5,
				lerp_basic = 0.8
			}
		}
	},
	crouch_moving = {
		inherits = {
			"hip_lasgun_killshot_p1_m2",
			"still"
		},
		continuous_spread = {
			min_pitch = {
				lerp_perfect = 0.7,
				lerp_basic = 1
			},
			min_yaw = {
				lerp_perfect = 0.7,
				lerp_basic = 1
			}
		}
	}
}
spread_templates.hip_lasgun_killshot_p1_m3 = {
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
					lerp_perfect = 0.4,
					lerp_basic = 0.15
				},
				yaw = {
					lerp_perfect = 0.4,
					lerp_basic = 0.15
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
				lerp_perfect = 1.5,
				lerp_basic = 2.5
			},
			min_yaw = {
				lerp_perfect = 1.5,
				lerp_basic = 2.5
			}
		},
		randomized_spread = {
			first_shot_min_ratio = 0.17,
			max_yaw_delta = 0.8,
			first_shot_random_ratio = 0.5,
			random_ratio = 0.18,
			max_pitch_delta = 0.8,
			min_ratio = 0.25
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
						lerp_perfect = 0.5,
						lerp_basic = 2 * spread_multi
					},
					yaw = {
						lerp_perfect = 0.5,
						lerp_basic = 2 * spread_multi
					}
				},
				{
					pitch = {
						lerp_perfect = 0.25,
						lerp_basic = 1.75 * spread_multi
					},
					yaw = {
						lerp_perfect = 0.25,
						lerp_basic = 1.75 * spread_multi
					}
				},
				{
					pitch = {
						lerp_perfect = 0.15,
						lerp_basic = 1.5 * spread_multi
					},
					yaw = {
						lerp_perfect = 0.15,
						lerp_basic = 1.5 * spread_multi
					}
				},
				{
					pitch = {
						lerp_perfect = 0.175,
						lerp_basic = 1.375 * spread_multi
					},
					yaw = {
						lerp_perfect = 0.175,
						lerp_basic = 1.375 * spread_multi
					}
				},
				{
					pitch = {
						lerp_perfect = 0.2,
						lerp_basic = 1.3 * spread_multi
					},
					yaw = {
						lerp_perfect = 0.2,
						lerp_basic = 1.3 * spread_multi
					}
				},
				{
					pitch = {
						lerp_perfect = 0.2,
						lerp_basic = 1.3 * spread_multi
					},
					yaw = {
						lerp_perfect = 0.2,
						lerp_basic = 1.3 * spread_multi
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
			"hip_lasgun_killshot_p1_m3",
			"still"
		},
		continuous_spread = {
			min_pitch = {
				lerp_perfect = 2.5,
				lerp_basic = 3
			},
			min_yaw = {
				lerp_perfect = 2.5,
				lerp_basic = 3
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
		},
		immediate_spread = {
			num_shots_clear_time = 1.2,
			suppression_hit = {
				{
					pitch = {
						lerp_perfect = 0.5,
						lerp_basic = 1
					},
					yaw = {
						lerp_perfect = 0.5,
						lerp_basic = 1
					}
				}
			},
			damage_hit = {
				{
					pitch = {
						lerp_perfect = 1.25,
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
						lerp_perfect = 0.4,
						lerp_basic = 1.65
					},
					yaw = {
						lerp_perfect = 0.4,
						lerp_basic = 1.65
					}
				},
				{
					pitch = {
						lerp_perfect = 0.5,
						lerp_basic = 1.35
					},
					yaw = {
						lerp_perfect = 0.5,
						lerp_basic = 1.35
					}
				}
			}
		}
	},
	crouch_still = {
		inherits = {
			"hip_lasgun_killshot_p1_m3",
			"still"
		},
		continuous_spread = {
			min_pitch = {
				lerp_perfect = 1.3,
				lerp_basic = 2.3
			},
			min_yaw = {
				lerp_perfect = 1.3,
				lerp_basic = 2.6
			}
		}
	},
	crouch_moving = {
		inherits = {
			"hip_lasgun_killshot_p1_m3",
			"still"
		},
		continuous_spread = {
			min_pitch = {
				lerp_perfect = 2.3,
				lerp_basic = 2.85
			},
			min_yaw = {
				lerp_perfect = 2.3,
				lerp_basic = 2.85
			}
		}
	}
}

local p2_spread_multi = 1

spread_templates.hip_lasgun_killshot_p2_m1 = {
	charge_scale = {
		max_yaw = 0.5,
		max_pitch = 0.5
	},
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
					lerp_perfect = 0.4,
					lerp_basic = 0.15
				},
				yaw = {
					lerp_perfect = 0.4,
					lerp_basic = 0.15
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
				lerp_perfect = 2.25,
				lerp_basic = 3
			},
			min_yaw = {
				lerp_perfect = 2.25,
				lerp_basic = 3
			}
		},
		randomized_spread = {
			random_ratio = 0.65,
			first_shot_min_ratio = 0.2,
			first_shot_random_ratio = 0.4,
			min_ratio = 0.25
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
						lerp_perfect = 0.5,
						lerp_basic = 2 * p2_spread_multi
					},
					yaw = {
						lerp_perfect = 0.5,
						lerp_basic = 2 * p2_spread_multi
					}
				},
				{
					pitch = {
						lerp_perfect = 0.25,
						lerp_basic = 1.75 * p2_spread_multi
					},
					yaw = {
						lerp_perfect = 0.25,
						lerp_basic = 1.75 * p2_spread_multi
					}
				},
				{
					pitch = {
						lerp_perfect = 0.15,
						lerp_basic = 1.5 * p2_spread_multi
					},
					yaw = {
						lerp_perfect = 0.15,
						lerp_basic = 1.5 * p2_spread_multi
					}
				}
			}
		}
	},
	moving = {
		inherits = {
			"hip_lasgun_killshot_p2_m1",
			"still"
		},
		continuous_spread = {
			min_pitch = {
				lerp_perfect = 2.5,
				lerp_basic = 4
			},
			min_yaw = {
				lerp_perfect = 2.5,
				lerp_basic = 4
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
		},
		immediate_spread = {
			num_shots_clear_time = 1.2,
			suppression_hit = {
				{
					pitch = {
						lerp_perfect = 0.5,
						lerp_basic = 1
					},
					yaw = {
						lerp_perfect = 0.5,
						lerp_basic = 1
					}
				}
			},
			damage_hit = {
				{
					pitch = {
						lerp_perfect = 1.25,
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
						lerp_perfect = 0.4,
						lerp_basic = 1.65
					},
					yaw = {
						lerp_perfect = 0.4,
						lerp_basic = 1.65
					}
				},
				{
					pitch = {
						lerp_perfect = 0.5,
						lerp_basic = 1.35
					},
					yaw = {
						lerp_perfect = 0.5,
						lerp_basic = 1.35
					}
				}
			}
		}
	},
	crouch_still = {
		inherits = {
			"hip_lasgun_killshot_p2_m1",
			"still"
		},
		continuous_spread = {
			min_pitch = {
				lerp_perfect = 1.3,
				lerp_basic = 2.3
			},
			min_yaw = {
				lerp_perfect = 1.3,
				lerp_basic = 2.6
			}
		}
	},
	crouch_moving = {
		inherits = {
			"hip_lasgun_killshot_p2_m1",
			"still"
		},
		continuous_spread = {
			min_pitch = {
				lerp_perfect = 2.3,
				lerp_basic = 2.85
			},
			min_yaw = {
				lerp_perfect = 2.3,
				lerp_basic = 2.85
			}
		}
	}
}
spread_templates.hip_lasgun_killshot_p2_m2 = table.clone(spread_templates.hip_lasgun_killshot_p2_m1)
spread_templates.hip_lasgun_killshot_p2_m2.still.continuous_spread = {
	min_pitch = {
		lerp_perfect = 2,
		lerp_basic = 3
	},
	min_yaw = {
		lerp_perfect = 2,
		lerp_basic = 3
	}
}
spread_templates.hip_lasgun_killshot_p2_m2.moving.continuous_spread = {
	min_pitch = {
		lerp_perfect = 3,
		lerp_basic = 4.5
	},
	min_yaw = {
		lerp_perfect = 3,
		lerp_basic = 4.5
	}
}
spread_templates.hip_lasgun_killshot_p2_m2.crouch_still.continuous_spread = {
	min_pitch = {
		lerp_perfect = 1.8,
		lerp_basic = 2.8
	},
	min_yaw = {
		lerp_perfect = 1.8,
		lerp_basic = 2.8
	}
}
spread_templates.hip_lasgun_killshot_p2_m2.crouch_moving.continuous_spread = {
	min_pitch = {
		lerp_perfect = 2.8,
		lerp_basic = 3.35
	},
	min_yaw = {
		lerp_perfect = 2.8,
		lerp_basic = 3.35
	}
}
spread_templates.ads_lasgun_killshot_p2_m1 = {
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
					lerp_perfect = 0.4,
					lerp_basic = 0.15
				},
				yaw = {
					lerp_perfect = 0.4,
					lerp_basic = 0.15
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
				lerp_perfect = 1.5,
				lerp_basic = 2.5
			},
			min_yaw = {
				lerp_perfect = 1.5,
				lerp_basic = 2.5
			}
		},
		randomized_spread = {
			first_shot_min_ratio = 0.017,
			max_yaw_delta = 0.8,
			first_shot_random_ratio = 0.05,
			random_ratio = 0.18,
			max_pitch_delta = 0.8,
			min_ratio = 0.25
		},
		immediate_spread = {
			num_shots_clear_time = 2,
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
						lerp_perfect = 0.5,
						lerp_basic = 2 * spread_multi
					},
					yaw = {
						lerp_perfect = 0.5,
						lerp_basic = 2 * spread_multi
					}
				},
				{
					pitch = {
						lerp_perfect = 0.25,
						lerp_basic = 1.75 * spread_multi
					},
					yaw = {
						lerp_perfect = 0.25,
						lerp_basic = 1.75 * spread_multi
					}
				},
				{
					pitch = {
						lerp_perfect = 0.15,
						lerp_basic = 1.5 * spread_multi
					},
					yaw = {
						lerp_perfect = 0.15,
						lerp_basic = 1.5 * spread_multi
					}
				}
			}
		}
	},
	moving = {
		inherits = {
			"ads_lasgun_killshot_p2_m1",
			"still"
		},
		continuous_spread = {
			min_pitch = {
				lerp_perfect = 2.5,
				lerp_basic = 3
			},
			min_yaw = {
				lerp_perfect = 2.5,
				lerp_basic = 3
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
		},
		immediate_spread = {
			num_shots_clear_time = 1.2,
			suppression_hit = {
				{
					pitch = {
						lerp_perfect = 0.5,
						lerp_basic = 1
					},
					yaw = {
						lerp_perfect = 0.5,
						lerp_basic = 1
					}
				}
			},
			damage_hit = {
				{
					pitch = {
						lerp_perfect = 1.25,
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
						lerp_perfect = 0.4,
						lerp_basic = 1.65
					},
					yaw = {
						lerp_perfect = 0.4,
						lerp_basic = 1.65
					}
				},
				{
					pitch = {
						lerp_perfect = 0.5,
						lerp_basic = 1.35
					},
					yaw = {
						lerp_perfect = 0.5,
						lerp_basic = 1.35
					}
				}
			}
		}
	},
	crouch_still = {
		inherits = {
			"ads_lasgun_killshot_p2_m1",
			"still"
		},
		continuous_spread = {
			min_pitch = {
				lerp_perfect = 1.3,
				lerp_basic = 2.3
			},
			min_yaw = {
				lerp_perfect = 1.3,
				lerp_basic = 2.6
			}
		}
	},
	crouch_moving = {
		inherits = {
			"ads_lasgun_killshot_p2_m1",
			"still"
		},
		continuous_spread = {
			min_pitch = {
				lerp_perfect = 2.3,
				lerp_basic = 2.85
			},
			min_yaw = {
				lerp_perfect = 2.3,
				lerp_basic = 2.85
			}
		}
	}
}
spread_templates.default_lasgun_killshot = {
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
			min_pitch = {
				lerp_perfect = 0,
				lerp_basic = 0
			},
			min_yaw = {
				lerp_perfect = 0,
				lerp_basic = 0
			}
		},
		immediate_spread = {
			num_shots_clear_time = 1,
			alternate_fire_start = {
				{
					pitch = {
						lerp_perfect = 0,
						lerp_basic = 0
					},
					yaw = {
						lerp_perfect = 0,
						lerp_basic = 0
					}
				}
			},
			crouching_transition = {
				{
					pitch = {
						lerp_perfect = 0,
						lerp_basic = 0
					},
					yaw = {
						lerp_perfect = 0,
						lerp_basic = 0
					}
				}
			},
			suppression_hit = {
				{
					pitch = {
						lerp_perfect = 0,
						lerp_basic = 0
					},
					yaw = {
						lerp_perfect = 0,
						lerp_basic = 0
					}
				}
			},
			damage_hit = {
				{
					pitch = {
						lerp_perfect = 0,
						lerp_basic = 0
					},
					yaw = {
						lerp_perfect = 0,
						lerp_basic = 0
					}
				}
			},
			shooting = {
				{
					pitch = {
						lerp_perfect = 0,
						lerp_basic = 0
					},
					yaw = {
						lerp_perfect = 0,
						lerp_basic = 0
					}
				}
			}
		}
	},
	moving = {
		inherits = {
			"default_lasgun_killshot",
			"still"
		},
		continuous_spread = {
			min_yaw = 0,
			min_pitch = 0
		}
	},
	crouch_still = {
		inherits = {
			"default_lasgun_killshot",
			"still"
		},
		continuous_spread = {
			min_yaw = 0,
			min_pitch = 0
		}
	},
	crouch_moving = {
		inherits = {
			"default_lasgun_killshot",
			"still"
		}
	},
	continuous_spread = {
		min_yaw = 0,
		min_pitch = 0
	}
}
spread_templates.lasgun_heavy_killshot = {
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
			min_pitch = {
				lerp_perfect = 0,
				lerp_basic = 0
			},
			min_yaw = {
				lerp_perfect = 0,
				lerp_basic = 0
			}
		},
		immediate_spread = {
			num_shots_clear_time = 1,
			alternate_fire_start = {
				{
					pitch = {
						lerp_perfect = 0,
						lerp_basic = 0
					},
					yaw = {
						lerp_perfect = 0,
						lerp_basic = 0
					}
				}
			},
			crouching_transition = {
				{
					pitch = {
						lerp_perfect = 0,
						lerp_basic = 0
					},
					yaw = {
						lerp_perfect = 0,
						lerp_basic = 0
					}
				}
			},
			suppression_hit = {
				{
					pitch = {
						lerp_perfect = 0,
						lerp_basic = 0
					},
					yaw = {
						lerp_perfect = 0,
						lerp_basic = 0
					}
				}
			},
			damage_hit = {
				{
					pitch = {
						lerp_perfect = 0,
						lerp_basic = 0
					},
					yaw = {
						lerp_perfect = 0,
						lerp_basic = 0
					}
				}
			},
			shooting = {
				{
					pitch = {
						lerp_perfect = 0,
						lerp_basic = 0
					},
					yaw = {
						lerp_perfect = 0,
						lerp_basic = 0
					}
				}
			}
		}
	},
	moving = {
		inherits = {
			"default_lasgun_killshot",
			"still"
		},
		continuous_spread = {
			min_yaw = 0,
			min_pitch = 0
		}
	},
	crouch_still = {
		inherits = {
			"default_lasgun_killshot",
			"still"
		},
		continuous_spread = {
			min_yaw = 0,
			min_pitch = 0
		}
	},
	crouch_moving = {
		inherits = {
			"default_lasgun_killshot",
			"still"
		}
	},
	continuous_spread = {
		min_yaw = 0,
		min_pitch = 0
	}
}
spread_templates.default_lasgun_bfg = {
	charge_scale = {
		max_yaw = 0.25,
		max_pitch = 0.25
	},
	still = {
		max_spread = {
			yaw = 20,
			pitch = 20
		},
		decay = {
			from_shooting_grace_time = 0.2,
			shooting = {
				yaw = 0.5,
				pitch = 0.5
			},
			idle = {
				yaw = 1,
				pitch = 1
			}
		},
		continuous_spread = {
			min_yaw = 2.5,
			min_pitch = 2.5
		},
		immediate_spread = {
			num_shots_clear_time = 0.35,
			suppression_hit = {
				{
					yaw = 0.5,
					pitch = 0.5
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
					yaw = 2.5,
					pitch = 2.5
				}
			}
		}
	},
	moving = {
		inherits = {
			"default_lasgun_bfg",
			"still"
		}
	},
	crouch_still = {
		inherits = {
			"default_lasgun_bfg",
			"still"
		}
	},
	crouch_moving = {
		inherits = {
			"default_lasgun_bfg",
			"still"
		}
	}
}
spread_templates.hip_lasgun_p3_m1 = {
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
					lerp_perfect = 0.4,
					lerp_basic = 0.15
				},
				yaw = {
					lerp_perfect = 0.4,
					lerp_basic = 0.15
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
				lerp_perfect = 1.4,
				lerp_basic = 1.6
			},
			min_yaw = {
				lerp_perfect = 1.4,
				lerp_basic = 1.6
			}
		},
		randomized_spread = {
			first_shot_min_ratio = 0.2,
			max_yaw_delta = 0.5,
			first_shot_random_ratio = 0.6,
			random_ratio = 0.9,
			max_pitch_delta = 0.5,
			min_ratio = 0.1
		},
		immediate_spread = {
			num_shots_clear_time = 0.5,
			suppression_hit = {
				{
					pitch = {
						lerp_perfect = 0.25,
						lerp_basic = 0.5
					},
					yaw = {
						lerp_perfect = 0.25,
						lerp_basic = 0.5
					}
				}
			},
			damage_hit = {
				{
					pitch = {
						lerp_perfect = 0.25,
						lerp_basic = 0.5
					},
					yaw = {
						lerp_perfect = 0.25,
						lerp_basic = 0.5
					}
				}
			},
			shooting = {
				{
					pitch = {
						lerp_perfect = 0.075,
						lerp_basic = 0.1
					},
					yaw = {
						lerp_perfect = 0.075,
						lerp_basic = 0.1
					}
				}
			}
		}
	},
	moving = {
		inherits = {
			"hip_lasgun_p3_m1",
			"still"
		},
		continuous_spread = {
			min_pitch = {
				lerp_perfect = 1.6,
				lerp_basic = 1.8
			},
			min_yaw = {
				lerp_perfect = 1.6,
				lerp_basic = 1.8
			}
		}
	},
	crouch_still = {
		inherits = {
			"hip_lasgun_p3_m1",
			"still"
		},
		continuous_spread = {
			min_pitch = {
				lerp_perfect = 1.4,
				lerp_basic = 1.6
			},
			min_yaw = {
				lerp_perfect = 1.4,
				lerp_basic = 1.6
			}
		}
	},
	crouch_moving = {
		inherits = {
			"hip_lasgun_p3_m1",
			"still"
		},
		continuous_spread = {
			min_pitch = {
				lerp_perfect = 1.6,
				lerp_basic = 1.8
			},
			min_yaw = {
				lerp_perfect = 1.6,
				lerp_basic = 1.8
			}
		}
	}
}

return {
	base_templates = spread_templates,
	overrides = overrides
}
