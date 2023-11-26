-- chunkname: @scripts/settings/equipment/weapon_templates/autopistols/settings_templates/autopistol_spread_templates.lua

local spread_templates = {}
local overrides = {}

table.make_unique(spread_templates)
table.make_unique(overrides)

spread_templates.default_autopistol_assault = {
	still = {
		max_spread = {
			yaw = 8,
			pitch = 8
		},
		decay = {
			from_shooting_grace_time = 0.1,
			shooting = {
				yaw = 1,
				pitch = 1
			},
			idle = {
				yaw = 2.75,
				pitch = 2.75
			}
		},
		continuous_spread = {
			min_yaw = 1.35,
			min_pitch = 1.35
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
					yaw = 0.15,
					pitch = 0.15
				},
				{
					yaw = 0.25,
					pitch = 0.25
				},
				{
					yaw = 0.3,
					pitch = 0.3
				},
				{
					yaw = 0.275,
					pitch = 0.275
				},
				{
					yaw = 0.25,
					pitch = 0.25
				},
				{
					yaw = 0.225,
					pitch = 0.225
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
			"default_autopistol_assault",
			"still"
		},
		continuous_spread = {
			min_yaw = 1.75,
			min_pitch = 1.75
		}
	},
	crouch_still = {
		inherits = {
			"default_autopistol_assault",
			"still"
		},
		continuous_spread = {
			min_yaw = 1.3,
			min_pitch = 1.3
		}
	},
	crouch_moving = {
		inherits = {
			"default_autopistol_assault",
			"still"
		},
		continuous_spread = {
			min_yaw = 1.6,
			min_pitch = 1.6
		}
	}
}
spread_templates.autopistol_assault_p1m2 = {
	still = {
		max_spread = {
			yaw = 8,
			pitch = 8
		},
		decay = {
			from_shooting_grace_time = 0.1,
			shooting = {
				yaw = 1,
				pitch = 1
			},
			idle = {
				yaw = 2.75,
				pitch = 2.75
			}
		},
		continuous_spread = {
			min_yaw = 2.35,
			min_pitch = 2.1
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
					yaw = 0.15,
					pitch = 0.15
				},
				{
					yaw = 0.25,
					pitch = 0.25
				},
				{
					yaw = 0.3,
					pitch = 0.3
				},
				{
					yaw = 0.275,
					pitch = 0.275
				},
				{
					yaw = 0.25,
					pitch = 0.25
				},
				{
					yaw = 0.225,
					pitch = 0.225
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
			"default_autopistol_assault",
			"still"
		},
		continuous_spread = {
			min_yaw = 2.75,
			min_pitch = 2.35
		}
	},
	crouch_still = {
		inherits = {
			"default_autopistol_assault",
			"still"
		},
		continuous_spread = {
			min_yaw = 1.6,
			min_pitch = 1.4
		}
	},
	crouch_moving = {
		inherits = {
			"default_autopistol_assault",
			"still"
		},
		continuous_spread = {
			min_yaw = 1.9,
			min_pitch = 1.7
		}
	}
}

local pitch_spread = 0.6
local yaw_spread = pitch_spread * 1.75

spread_templates.default_autopistol_spraynpray = {
	still = {
		max_spread = {
			yaw = 4,
			pitch = 3
		},
		decay = {
			from_shooting_grace_time = 0.025,
			shooting = {
				yaw = 2.0124999999999997,
				pitch = 1.15
			},
			idle = {
				yaw = 2.5,
				pitch = 2.5
			}
		},
		continuous_spread = {
			min_yaw = 1.75,
			min_pitch = 1.25
		},
		immediate_spread = {
			num_shots_clear_time = 0.25,
			suppression_hit = {
				{
					yaw = 0.05,
					pitch = 0.05
				}
			},
			damage_hit = {
				{
					yaw = 0.2,
					pitch = 0.2
				}
			},
			shooting = {
				{
					pitch = pitch_spread * 0.1,
					yaw = yaw_spread * 0.1
				},
				{
					pitch = pitch_spread * 0.125,
					yaw = yaw_spread * 0.125
				},
				{
					pitch = pitch_spread * 0.15,
					yaw = yaw_spread * 0.15
				},
				{
					pitch = pitch_spread * 0.2,
					yaw = yaw_spread * 0.2
				},
				{
					pitch = pitch_spread * 0.225,
					yaw = yaw_spread * 0.225
				},
				{
					pitch = pitch_spread * 0.25,
					yaw = yaw_spread * 0.25
				},
				{
					pitch = pitch_spread * 0.2,
					yaw = yaw_spread * 0.2
				},
				{
					pitch = pitch_spread * 0.15,
					yaw = yaw_spread * 0.15
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
			"default_autopistol_spraynpray",
			"still"
		},
		continuous_spread = {
			min_yaw = 2.1,
			min_pitch = 1.5
		}
	},
	crouch_still = {
		inherits = {
			"default_autopistol_spraynpray",
			"still"
		},
		continuous_spread = {
			min_yaw = 1.575,
			min_pitch = 1.125
		}
	},
	crouch_moving = {
		inherits = {
			"default_autopistol_spraynpray",
			"still"
		},
		continuous_spread = {
			min_yaw = 1.9250000000000003,
			min_pitch = 1.375
		}
	}
}

return {
	base_templates = spread_templates,
	overrides = overrides
}
