local HordePacingTemplates = require("scripts/managers/pacing/horde_pacing/horde_pacing_templates")
local SpecialsPacingTemplates = require("scripts/managers/pacing/specials_pacing/specials_pacing_templates")
local MonsterPacingTemplates = require("scripts/managers/pacing/monster_pacing/monster_pacing_templates")

local function _multiplier_step(value)
	local multiplier_step = {
		value * 1,
		value * 1.2,
		value * 1.35,
		value * 1.5,
		value * 1.75
	}

	return multiplier_step
end

local DECAY_TENSION_RATES = {
	build_up_tension_low = _multiplier_step(1.25),
	build_up_tension = _multiplier_step(1.5),
	build_up_tension_high = _multiplier_step(2),
	sustain_tension_peak = _multiplier_step(0),
	tension_peak_fade = _multiplier_step(2),
	relax = _multiplier_step(2)
}
local DEFAULT_ALLOWED_SPAWN_TYPES = {
	build_up_tension_low = {
		monsters = true,
		terror_events = true,
		specials = true,
		roamers = true,
		hordes = true,
		trickle_hordes = true
	},
	build_up_tension = {
		monsters = true,
		terror_events = true,
		specials = true,
		roamers = true,
		hordes = true,
		trickle_hordes = true
	},
	build_up_tension_high = {
		monsters = true,
		terror_events = true,
		specials = true,
		roamers = true,
		hordes = true,
		trickle_hordes = true
	},
	sustain_tension_peak = {
		monsters = true,
		terror_events = false,
		specials = false,
		roamers = false,
		hordes = false,
		trickle_hordes = false
	},
	tension_peak_fade = {
		monsters = true,
		terror_events = false,
		specials = false,
		roamers = false,
		hordes = false,
		trickle_hordes = false
	},
	relax = {
		monsters = true,
		terror_events = true,
		specials = false,
		roamers = true,
		hordes = false,
		trickle_hordes = false
	}
}
local pacing_template = {
	starting_state = "build_up_tension_low",
	name = "default",
	horde_pacing_template = HordePacingTemplates.renegade_horde,
	specials_pacing_template = SpecialsPacingTemplates.renegade_specials,
	monster_pacing_template = MonsterPacingTemplates.renegade_monsters,
	max_tension = _multiplier_step(100),
	challenge_rating_thresholds = {
		specials = _multiplier_step(40),
		hordes = _multiplier_step(22),
		trickle_hordes = _multiplier_step(18),
		roamers = _multiplier_step(90)
	},
	state_settings = {
		{
			build_up_tension_low = {
				decay_tension_delay = 3,
				next_conditions = {
					tension_threshold = 10
				},
				allowed_spawn_types = DEFAULT_ALLOWED_SPAWN_TYPES.build_up_tension_low,
				decay_tension_rate = DECAY_TENSION_RATES.build_up_tension_low[1]
			},
			build_up_tension = {
				decay_tension_delay = 1,
				back_conditions = {
					tension_min_threshold = 5
				},
				next_conditions = {
					tension_threshold = 60,
					duration = {
						20,
						30
					}
				},
				allowed_spawn_types = DEFAULT_ALLOWED_SPAWN_TYPES.build_up_tension,
				decay_tension_rate = DECAY_TENSION_RATES.build_up_tension[1]
			},
			build_up_tension_high = {
				decay_tension_delay = 1,
				back_conditions = {
					tension_min_threshold = 5
				},
				next_conditions = {
					tension_threshold = 90
				},
				allowed_spawn_types = DEFAULT_ALLOWED_SPAWN_TYPES.build_up_tension_high,
				decay_tension_rate = DECAY_TENSION_RATES.build_up_tension_high[1]
			},
			sustain_tension_peak = {
				next_conditions = {
					duration = {
						12,
						15
					}
				},
				allowed_spawn_types = DEFAULT_ALLOWED_SPAWN_TYPES.sustain_tension_peak,
				decay_tension_rate = DECAY_TENSION_RATES.sustain_tension_peak[1]
			},
			tension_peak_fade = {
				next_conditions = {
					tension_min_threshold = 60,
					duration = {
						30,
						35
					}
				},
				allowed_spawn_types = DEFAULT_ALLOWED_SPAWN_TYPES.tension_peak_fade,
				decay_tension_rate = DECAY_TENSION_RATES.tension_peak_fade[1]
			},
			relax = {
				next_conditions = {
					tension_min_threshold = 5,
					duration = {
						65,
						100
					}
				},
				allowed_spawn_types = DEFAULT_ALLOWED_SPAWN_TYPES.relax,
				decay_tension_rate = DECAY_TENSION_RATES.tension_peak_fade[1]
			}
		},
		{
			build_up_tension_low = {
				decay_tension_delay = 3,
				next_conditions = {
					tension_threshold = 12,
					duration = {
						50,
						60
					}
				},
				allowed_spawn_types = DEFAULT_ALLOWED_SPAWN_TYPES.build_up_tension_low,
				decay_tension_rate = DECAY_TENSION_RATES.build_up_tension_low[2]
			},
			build_up_tension = {
				decay_tension_delay = 1.5,
				back_conditions = {
					tension_min_threshold = 6
				},
				next_conditions = {
					tension_threshold = 72,
					duration = {
						25,
						30
					}
				},
				allowed_spawn_types = DEFAULT_ALLOWED_SPAWN_TYPES.build_up_tension,
				decay_tension_rate = DECAY_TENSION_RATES.build_up_tension[2]
			},
			build_up_tension_high = {
				decay_tension_delay = 1.5,
				back_conditions = {
					tension_min_threshold = 60
				},
				next_conditions = {
					tension_threshold = 108
				},
				allowed_spawn_types = DEFAULT_ALLOWED_SPAWN_TYPES.build_up_tension_high,
				decay_tension_rate = DECAY_TENSION_RATES.build_up_tension_high[2]
			},
			sustain_tension_peak = {
				next_conditions = {
					duration = {
						13,
						17
					}
				},
				allowed_spawn_types = DEFAULT_ALLOWED_SPAWN_TYPES.sustain_tension_peak,
				decay_tension_rate = DECAY_TENSION_RATES.sustain_tension_peak[2]
			},
			tension_peak_fade = {
				next_conditions = {
					tension_min_threshold = 84,
					duration = {
						30,
						35
					}
				},
				allowed_spawn_types = DEFAULT_ALLOWED_SPAWN_TYPES.tension_peak_fade,
				decay_tension_rate = DECAY_TENSION_RATES.tension_peak_fade[2]
			},
			relax = {
				next_conditions = {
					tension_min_threshold = 0,
					duration = {
						30,
						55
					}
				},
				allowed_spawn_types = DEFAULT_ALLOWED_SPAWN_TYPES.relax,
				decay_tension_rate = DECAY_TENSION_RATES.relax[3]
			}
		},
		{
			build_up_tension_low = {
				decay_tension_delay = 3,
				next_conditions = {
					tension_threshold = 13.5,
					duration = {
						30,
						40
					}
				},
				allowed_spawn_types = DEFAULT_ALLOWED_SPAWN_TYPES.build_up_tension_low,
				decay_tension_rate = DECAY_TENSION_RATES.build_up_tension_low[3]
			},
			build_up_tension = {
				decay_tension_delay = 1,
				back_conditions = {
					tension_min_threshold = 6.75
				},
				next_conditions = {
					tension_threshold = 94.5,
					duration = {
						40,
						45
					}
				},
				allowed_spawn_types = DEFAULT_ALLOWED_SPAWN_TYPES.build_up_tension,
				decay_tension_rate = DECAY_TENSION_RATES.build_up_tension[3]
			},
			build_up_tension_high = {
				decay_tension_delay = 1,
				back_conditions = {
					tension_min_threshold = 67.5
				},
				next_conditions = {
					tension_threshold = 121.50000000000001
				},
				allowed_spawn_types = DEFAULT_ALLOWED_SPAWN_TYPES.build_up_tension_high,
				decay_tension_rate = DECAY_TENSION_RATES.build_up_tension_high[3]
			},
			sustain_tension_peak = {
				next_conditions = {
					duration = {
						13,
						17
					}
				},
				allowed_spawn_types = DEFAULT_ALLOWED_SPAWN_TYPES.sustain_tension_peak,
				decay_tension_rate = DECAY_TENSION_RATES.sustain_tension_peak[3]
			},
			tension_peak_fade = {
				next_conditions = {
					tension_min_threshold = 94.5,
					duration = {
						30,
						35
					}
				},
				allowed_spawn_types = DEFAULT_ALLOWED_SPAWN_TYPES.tension_peak_fade,
				decay_tension_rate = DECAY_TENSION_RATES.tension_peak_fade[3]
			},
			relax = {
				next_conditions = {
					tension_min_threshold = 0,
					duration = {
						30,
						55
					}
				},
				allowed_spawn_types = DEFAULT_ALLOWED_SPAWN_TYPES.relax,
				decay_tension_rate = DECAY_TENSION_RATES.relax[3]
			}
		},
		{
			build_up_tension_low = {
				decay_tension_delay = 3,
				next_conditions = {
					tension_threshold = 15,
					duration = {
						30,
						40
					}
				},
				allowed_spawn_types = DEFAULT_ALLOWED_SPAWN_TYPES.build_up_tension_low,
				decay_tension_rate = DECAY_TENSION_RATES.build_up_tension_low[4]
			},
			build_up_tension = {
				decay_tension_delay = 1,
				back_conditions = {
					tension_min_threshold = 7.5
				},
				next_conditions = {
					tension_threshold = 105,
					duration = {
						40,
						45
					}
				},
				allowed_spawn_types = DEFAULT_ALLOWED_SPAWN_TYPES.build_up_tension,
				decay_tension_rate = DECAY_TENSION_RATES.build_up_tension[4]
			},
			build_up_tension_high = {
				decay_tension_delay = 1,
				back_conditions = {
					tension_min_threshold = 75,
					duration = {
						30,
						45
					}
				},
				next_conditions = {
					tension_threshold = 135
				},
				allowed_spawn_types = DEFAULT_ALLOWED_SPAWN_TYPES.build_up_tension_high,
				decay_tension_rate = DECAY_TENSION_RATES.build_up_tension_high[4]
			},
			sustain_tension_peak = {
				next_conditions = {
					duration = {
						13,
						17
					}
				},
				allowed_spawn_types = DEFAULT_ALLOWED_SPAWN_TYPES.sustain_tension_peak,
				decay_tension_rate = DECAY_TENSION_RATES.sustain_tension_peak[4]
			},
			tension_peak_fade = {
				next_conditions = {
					tension_min_threshold = 105,
					duration = {
						30,
						35
					}
				},
				allowed_spawn_types = DEFAULT_ALLOWED_SPAWN_TYPES.tension_peak_fade,
				decay_tension_rate = DECAY_TENSION_RATES.tension_peak_fade[4]
			},
			relax = {
				next_conditions = {
					tension_min_threshold = 0,
					duration = {
						30,
						55
					}
				},
				allowed_spawn_types = DEFAULT_ALLOWED_SPAWN_TYPES.relax,
				decay_tension_rate = DECAY_TENSION_RATES.relax[4]
			}
		},
		{
			build_up_tension_low = {
				decay_tension_delay = 3,
				next_conditions = {
					tension_threshold = 17.5,
					duration = {
						30,
						40
					}
				},
				allowed_spawn_types = DEFAULT_ALLOWED_SPAWN_TYPES.build_up_tension_low,
				decay_tension_rate = DECAY_TENSION_RATES.build_up_tension_low[5]
			},
			build_up_tension = {
				decay_tension_delay = 1,
				back_conditions = {
					tension_min_threshold = 8.75
				},
				next_conditions = {
					tension_threshold = 122.5,
					duration = {
						40,
						45
					}
				},
				allowed_spawn_types = DEFAULT_ALLOWED_SPAWN_TYPES.build_up_tension,
				decay_tension_rate = DECAY_TENSION_RATES.build_up_tension[5]
			},
			build_up_tension_high = {
				decay_tension_delay = 1,
				back_conditions = {
					tension_min_threshold = 87.5
				},
				next_conditions = {
					tension_threshold = 157.5
				},
				allowed_spawn_types = DEFAULT_ALLOWED_SPAWN_TYPES.build_up_tension_high,
				decay_tension_rate = DECAY_TENSION_RATES.build_up_tension_high[5]
			},
			sustain_tension_peak = {
				next_conditions = {
					duration = {
						13,
						17
					}
				},
				allowed_spawn_types = DEFAULT_ALLOWED_SPAWN_TYPES.sustain_tension_peak,
				decay_tension_rate = DECAY_TENSION_RATES.sustain_tension_peak[5]
			},
			tension_peak_fade = {
				next_conditions = {
					tension_min_threshold = 122.5,
					duration = {
						30,
						35
					}
				},
				allowed_spawn_types = DEFAULT_ALLOWED_SPAWN_TYPES.tension_peak_fade,
				decay_tension_rate = DECAY_TENSION_RATES.tension_peak_fade[5]
			},
			relax = {
				next_conditions = {
					tension_min_threshold = 0,
					duration = {
						30,
						55
					}
				},
				allowed_spawn_types = DEFAULT_ALLOWED_SPAWN_TYPES.relax,
				decay_tension_rate = DECAY_TENSION_RATES.relax[5]
			}
		}
	},
	state_orders = {
		build_up_tension_low = {
			next_state = "build_up_tension"
		},
		build_up_tension = {
			back_state = "build_up_tension_low",
			next_state = "build_up_tension_high"
		},
		build_up_tension_high = {
			back_state = "build_up_tension",
			next_state = "sustain_tension_peak"
		},
		sustain_tension_peak = {
			next_state = "tension_peak_fade"
		},
		tension_peak_fade = {
			next_state = "relax"
		},
		relax = {
			next_state = "build_up_tension_low"
		}
	},
	combat_state_settings = {
		{
			medium_threshold = 10,
			base_decay_rate = 1,
			high_threshold = 30,
			max_value = 40,
			low_threshold = 0,
			tension_modifier = 1.75,
			combat_states = {
				high = "high",
				medium = "medium",
				low = "low"
			}
		},
		{
			medium_threshold = 20,
			base_decay_rate = 1,
			high_threshold = 40,
			max_value = 50,
			low_threshold = 0,
			tension_modifier = 1.5,
			combat_states = {
				high = "high",
				medium = "medium",
				low = "low"
			}
		},
		{
			medium_threshold = 25,
			base_decay_rate = 1,
			high_threshold = 50,
			max_value = 60,
			low_threshold = 0,
			tension_modifier = 1.25,
			combat_states = {
				high = "high",
				medium = "medium",
				low = "low"
			}
		},
		{
			medium_threshold = 30,
			base_decay_rate = 1,
			high_threshold = 60,
			max_value = 70,
			low_threshold = 0,
			tension_modifier = 1,
			combat_states = {
				high = "high",
				medium = "medium",
				low = "low"
			}
		},
		{
			medium_threshold = 30,
			base_decay_rate = 1,
			high_threshold = 60,
			max_value = 70,
			low_threshold = 0,
			tension_modifier = 0.5,
			combat_states = {
				high = "high",
				medium = "medium",
				low = "low"
			}
		}
	}
}

return pacing_template
