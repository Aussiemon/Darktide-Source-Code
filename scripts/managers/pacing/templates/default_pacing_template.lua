﻿-- chunkname: @scripts/managers/pacing/templates/default_pacing_template.lua

local HordePacingTemplates = require("scripts/managers/pacing/horde_pacing/horde_pacing_templates")
local SpecialsPacingTemplates = require("scripts/managers/pacing/specials_pacing/specials_pacing_templates")
local MonsterPacingTemplates = require("scripts/managers/pacing/monster_pacing/monster_pacing_templates")

local function _multiplier_step(value)
	local multiplier_step = {
		value * 1,
		value * 1.2,
		value * 1.35,
		value * 1.5,
		value * 1.75,
	}

	return multiplier_step
end

local function _challenge_rating_multiplier_steps(value)
	local multiplier_step = {
		value * 1,
		value * 1.25,
		value * 1.5,
		value * 1.75,
		value * 2,
	}

	return multiplier_step
end

local DECAY_TENSION_RATES = {
	build_up_tension_low = _multiplier_step(1.25),
	build_up_tension = _multiplier_step(1.5),
	build_up_tension_high = _multiplier_step(2),
	sustain_tension_peak = _multiplier_step(0),
	tension_peak_fade = _multiplier_step(2),
	relax = _multiplier_step(2),
}
local DEFAULT_ALLOWED_SPAWN_TYPES = {
	build_up_tension_low = {
		hordes = true,
		monsters = true,
		roamers = true,
		specials = true,
		terror_events = true,
		trickle_hordes = true,
	},
	build_up_tension = {
		hordes = true,
		monsters = true,
		roamers = true,
		specials = true,
		terror_events = true,
		trickle_hordes = true,
	},
	build_up_tension_high = {
		hordes = true,
		monsters = true,
		roamers = true,
		specials = true,
		terror_events = true,
		trickle_hordes = true,
	},
	sustain_tension_peak = {
		hordes = false,
		monsters = true,
		roamers = false,
		specials = false,
		terror_events = false,
		trickle_hordes = false,
	},
	tension_peak_fade = {
		hordes = false,
		monsters = true,
		roamers = false,
		specials = false,
		terror_events = false,
		trickle_hordes = false,
	},
	relax = {
		hordes = false,
		monsters = true,
		roamers = true,
		specials = false,
		terror_events = true,
		trickle_hordes = false,
	},
}
local DEFAULT_RAMP_UP_FREQUENCY_MODIFIERS = {
	{
		max_duration = 50,
		ramp_duration = 1200,
		travel_change_pause_time = 5,
		ramp_up_states = {
			build_up_tension = true,
			build_up_tension_low = true,
		},
		ramp_modifiers = {
			hordes = 1.25,
			specials = 2,
		},
	},
	{
		max_duration = 50,
		ramp_duration = 600,
		travel_change_pause_time = 7,
		ramp_up_states = {
			build_up_tension = true,
			build_up_tension_low = true,
		},
		ramp_modifiers = {
			hordes = 1.25,
			specials = 2,
			terror_events = 1.25,
		},
	},
	{
		max_duration = 60,
		ramp_duration = 500,
		travel_change_pause_time = 9,
		wait_for_ramp_clear = true,
		ramp_up_states = {
			build_up_tension = true,
			build_up_tension_low = true,
		},
		ramp_modifiers = {
			hordes = 1.5,
			specials = 2.5,
			terror_events = 1.5,
			trickle_hordes = 1.5,
		},
		wait_for_ramp_clear_reset = {
			80,
			160,
		},
	},
	{
		max_duration = 80,
		ramp_duration = 400,
		travel_change_pause_time = 11,
		wait_for_ramp_clear = true,
		ramp_up_states = {
			build_up_tension = true,
			build_up_tension_low = true,
		},
		ramp_modifiers = {
			hordes = 1.5,
			specials = 2.5,
			terror_events = 1.75,
			trickle_hordes = 1.5,
		},
		wait_for_ramp_clear_reset = {
			80,
			160,
		},
	},
	{
		max_duration = 100,
		ramp_duration = 200,
		travel_change_pause_time = 20,
		wait_for_ramp_clear = true,
		ramp_up_states = {
			build_up_tension = true,
			build_up_tension_low = true,
		},
		ramp_modifiers = {
			hordes = 2,
			specials = 3,
			terror_events = 2,
			trickle_hordes = 2,
		},
		wait_for_ramp_clear_reset = {
			120,
			200,
		},
	},
}
local pacing_template = {
	name = "default",
	starting_state = "build_up_tension_low",
	horde_pacing_template = HordePacingTemplates.default_horde,
	specials_pacing_template = SpecialsPacingTemplates.default_specials,
	monster_pacing_template = MonsterPacingTemplates.default_monsters,
	max_tension = _multiplier_step(100),
	challenge_rating_thresholds = {
		specials = _challenge_rating_multiplier_steps(40),
		hordes = _challenge_rating_multiplier_steps(30),
		trickle_hordes = _challenge_rating_multiplier_steps(20),
		roamers = _challenge_rating_multiplier_steps(90),
		terror_events = _challenge_rating_multiplier_steps(100),
	},
	ramp_up_frequency_modifiers = DEFAULT_RAMP_UP_FREQUENCY_MODIFIERS,
	min_wound_tension_requirement = {
		false,
		false,
		false,
		true,
		true,
	},
	state_settings = {
		{
			build_up_tension_low = {
				decay_tension_delay = 3,
				next_conditions = {
					tension_threshold = 10,
				},
				allowed_spawn_types = DEFAULT_ALLOWED_SPAWN_TYPES.build_up_tension_low,
				decay_tension_rate = DECAY_TENSION_RATES.build_up_tension_low[1],
			},
			build_up_tension = {
				decay_tension_delay = 1,
				back_conditions = {
					tension_min_threshold = 5,
				},
				next_conditions = {
					tension_threshold = 60,
				},
				allowed_spawn_types = DEFAULT_ALLOWED_SPAWN_TYPES.build_up_tension,
				decay_tension_rate = DECAY_TENSION_RATES.build_up_tension[1],
			},
			build_up_tension_high = {
				decay_tension_delay = 1,
				back_conditions = {
					tension_min_threshold = 5,
				},
				next_conditions = {
					tension_threshold = 90,
				},
				allowed_spawn_types = DEFAULT_ALLOWED_SPAWN_TYPES.build_up_tension_high,
				decay_tension_rate = DECAY_TENSION_RATES.build_up_tension_high[1],
			},
			sustain_tension_peak = {
				next_conditions = {
					duration = {
						12,
						15,
					},
				},
				allowed_spawn_types = DEFAULT_ALLOWED_SPAWN_TYPES.sustain_tension_peak,
				decay_tension_rate = DECAY_TENSION_RATES.sustain_tension_peak[1],
			},
			tension_peak_fade = {
				next_conditions = {
					tension_min_threshold = 60,
					duration = {
						30,
						35,
					},
				},
				allowed_spawn_types = DEFAULT_ALLOWED_SPAWN_TYPES.tension_peak_fade,
				decay_tension_rate = DECAY_TENSION_RATES.tension_peak_fade[1],
			},
			relax = {
				next_conditions = {
					tension_min_threshold = 5,
					duration = {
						65,
						100,
					},
				},
				allowed_spawn_types = DEFAULT_ALLOWED_SPAWN_TYPES.relax,
				decay_tension_rate = DECAY_TENSION_RATES.tension_peak_fade[1],
			},
		},
		{
			build_up_tension_low = {
				decay_tension_delay = 3,
				next_conditions = {
					tension_threshold = 12,
				},
				allowed_spawn_types = DEFAULT_ALLOWED_SPAWN_TYPES.build_up_tension_low,
				decay_tension_rate = DECAY_TENSION_RATES.build_up_tension_low[2],
			},
			build_up_tension = {
				decay_tension_delay = 1.5,
				back_conditions = {
					tension_min_threshold = 6,
				},
				next_conditions = {
					tension_threshold = 72,
				},
				allowed_spawn_types = DEFAULT_ALLOWED_SPAWN_TYPES.build_up_tension,
				decay_tension_rate = DECAY_TENSION_RATES.build_up_tension[2],
			},
			build_up_tension_high = {
				decay_tension_delay = 1.5,
				back_conditions = {
					tension_min_threshold = 60,
				},
				next_conditions = {
					tension_threshold = 108,
				},
				allowed_spawn_types = DEFAULT_ALLOWED_SPAWN_TYPES.build_up_tension_high,
				decay_tension_rate = DECAY_TENSION_RATES.build_up_tension_high[2],
			},
			sustain_tension_peak = {
				next_conditions = {
					duration = {
						13,
						17,
					},
				},
				allowed_spawn_types = DEFAULT_ALLOWED_SPAWN_TYPES.sustain_tension_peak,
				decay_tension_rate = DECAY_TENSION_RATES.sustain_tension_peak[2],
			},
			tension_peak_fade = {
				next_conditions = {
					tension_min_threshold = 84,
					duration = {
						30,
						35,
					},
				},
				allowed_spawn_types = DEFAULT_ALLOWED_SPAWN_TYPES.tension_peak_fade,
				decay_tension_rate = DECAY_TENSION_RATES.tension_peak_fade[2],
			},
			relax = {
				next_conditions = {
					tension_min_threshold = 0,
					duration = {
						30,
						55,
					},
				},
				allowed_spawn_types = DEFAULT_ALLOWED_SPAWN_TYPES.relax,
				decay_tension_rate = DECAY_TENSION_RATES.relax[3],
			},
		},
		{
			build_up_tension_low = {
				decay_tension_delay = 3,
				next_conditions = {
					tension_threshold = 13.5,
				},
				allowed_spawn_types = DEFAULT_ALLOWED_SPAWN_TYPES.build_up_tension_low,
				decay_tension_rate = DECAY_TENSION_RATES.build_up_tension_low[3],
			},
			build_up_tension = {
				decay_tension_delay = 1,
				back_conditions = {
					tension_min_threshold = 6.75,
				},
				next_conditions = {
					tension_threshold = 94.5,
				},
				allowed_spawn_types = DEFAULT_ALLOWED_SPAWN_TYPES.build_up_tension,
				decay_tension_rate = DECAY_TENSION_RATES.build_up_tension[3],
			},
			build_up_tension_high = {
				decay_tension_delay = 1,
				back_conditions = {
					tension_min_threshold = 67.5,
				},
				next_conditions = {
					tension_threshold = 121.50000000000001,
				},
				allowed_spawn_types = DEFAULT_ALLOWED_SPAWN_TYPES.build_up_tension_high,
				decay_tension_rate = DECAY_TENSION_RATES.build_up_tension_high[3],
			},
			sustain_tension_peak = {
				next_conditions = {
					duration = {
						13,
						17,
					},
				},
				allowed_spawn_types = DEFAULT_ALLOWED_SPAWN_TYPES.sustain_tension_peak,
				decay_tension_rate = DECAY_TENSION_RATES.sustain_tension_peak[3],
			},
			tension_peak_fade = {
				next_conditions = {
					tension_min_threshold = 94.5,
					duration = {
						30,
						35,
					},
				},
				allowed_spawn_types = DEFAULT_ALLOWED_SPAWN_TYPES.tension_peak_fade,
				decay_tension_rate = DECAY_TENSION_RATES.tension_peak_fade[3],
			},
			relax = {
				next_conditions = {
					tension_min_threshold = 0,
					duration = {
						30,
						55,
					},
				},
				allowed_spawn_types = DEFAULT_ALLOWED_SPAWN_TYPES.relax,
				decay_tension_rate = DECAY_TENSION_RATES.relax[3],
			},
		},
		{
			build_up_tension_low = {
				decay_tension_delay = 3,
				next_conditions = {
					tension_threshold = 15,
				},
				allowed_spawn_types = DEFAULT_ALLOWED_SPAWN_TYPES.build_up_tension_low,
				decay_tension_rate = DECAY_TENSION_RATES.build_up_tension_low[4],
			},
			build_up_tension = {
				decay_tension_delay = 1,
				back_conditions = {
					tension_min_threshold = 7.5,
				},
				next_conditions = {
					tension_threshold = 105,
				},
				allowed_spawn_types = DEFAULT_ALLOWED_SPAWN_TYPES.build_up_tension,
				decay_tension_rate = DECAY_TENSION_RATES.build_up_tension[4],
			},
			build_up_tension_high = {
				decay_tension_delay = 1,
				back_conditions = {
					tension_min_threshold = 75,
					duration = {
						30,
						45,
					},
				},
				next_conditions = {
					tension_threshold = 135,
				},
				allowed_spawn_types = DEFAULT_ALLOWED_SPAWN_TYPES.build_up_tension_high,
				decay_tension_rate = DECAY_TENSION_RATES.build_up_tension_high[4],
			},
			sustain_tension_peak = {
				next_conditions = {
					duration = {
						13,
						17,
					},
				},
				allowed_spawn_types = DEFAULT_ALLOWED_SPAWN_TYPES.sustain_tension_peak,
				decay_tension_rate = DECAY_TENSION_RATES.sustain_tension_peak[4],
			},
			tension_peak_fade = {
				next_conditions = {
					tension_min_threshold = 105,
					duration = {
						30,
						35,
					},
				},
				allowed_spawn_types = DEFAULT_ALLOWED_SPAWN_TYPES.tension_peak_fade,
				decay_tension_rate = DECAY_TENSION_RATES.tension_peak_fade[4],
			},
			relax = {
				next_conditions = {
					tension_min_threshold = 0,
					duration = {
						30,
						55,
					},
				},
				allowed_spawn_types = DEFAULT_ALLOWED_SPAWN_TYPES.relax,
				decay_tension_rate = DECAY_TENSION_RATES.relax[4],
			},
		},
		{
			build_up_tension_low = {
				decay_tension_delay = 3,
				next_conditions = {
					tension_threshold = 26.25,
				},
				allowed_spawn_types = DEFAULT_ALLOWED_SPAWN_TYPES.build_up_tension_low,
				decay_tension_rate = DECAY_TENSION_RATES.build_up_tension_low[5],
			},
			build_up_tension = {
				decay_tension_delay = 1,
				back_conditions = {
					tension_min_threshold = 8.75,
				},
				next_conditions = {
					tension_threshold = 122.5,
				},
				allowed_spawn_types = DEFAULT_ALLOWED_SPAWN_TYPES.build_up_tension,
				decay_tension_rate = DECAY_TENSION_RATES.build_up_tension[5],
			},
			build_up_tension_high = {
				decay_tension_delay = 1,
				back_conditions = {
					tension_min_threshold = 87.5,
				},
				next_conditions = {
					tension_threshold = 157.5,
				},
				allowed_spawn_types = DEFAULT_ALLOWED_SPAWN_TYPES.build_up_tension_high,
				decay_tension_rate = DECAY_TENSION_RATES.build_up_tension_high[5],
			},
			sustain_tension_peak = {
				next_conditions = {
					duration = {
						13,
						17,
					},
				},
				allowed_spawn_types = DEFAULT_ALLOWED_SPAWN_TYPES.sustain_tension_peak,
				decay_tension_rate = DECAY_TENSION_RATES.sustain_tension_peak[5],
			},
			tension_peak_fade = {
				next_conditions = {
					tension_min_threshold = 122.5,
					duration = {
						30,
						35,
					},
				},
				allowed_spawn_types = DEFAULT_ALLOWED_SPAWN_TYPES.tension_peak_fade,
				decay_tension_rate = DECAY_TENSION_RATES.tension_peak_fade[5],
			},
			relax = {
				next_conditions = {
					tension_min_threshold = 0,
					duration = {
						30,
						55,
					},
				},
				allowed_spawn_types = DEFAULT_ALLOWED_SPAWN_TYPES.relax,
				decay_tension_rate = DECAY_TENSION_RATES.relax[5],
			},
		},
	},
	state_orders = {
		build_up_tension_low = {
			next_state = "build_up_tension",
		},
		build_up_tension = {
			back_state = "build_up_tension_low",
			next_state = "build_up_tension_high",
		},
		build_up_tension_high = {
			back_state = "build_up_tension",
			next_state = "sustain_tension_peak",
		},
		sustain_tension_peak = {
			next_state = "tension_peak_fade",
		},
		tension_peak_fade = {
			next_state = "relax",
		},
		relax = {
			next_state = "build_up_tension_low",
		},
	},
	combat_state_settings = {
		{
			base_decay_rate = 0.8,
			high_threshold = 50,
			low_threshold = 0,
			max_value = 60,
			medium_threshold = 25,
			tension_modifier = 12,
			combat_states = {
				high = "high",
				low = "low",
				medium = "medium",
			},
		},
		{
			base_decay_rate = 0.8,
			high_threshold = 50,
			low_threshold = 0,
			max_value = 60,
			medium_threshold = 25,
			tension_modifier = 12,
			combat_states = {
				high = "high",
				low = "low",
				medium = "medium",
			},
		},
		{
			base_decay_rate = 0.8,
			high_threshold = 50,
			low_threshold = 0,
			max_value = 60,
			medium_threshold = 25,
			tension_modifier = 12,
			combat_states = {
				high = "high",
				low = "low",
				medium = "medium",
			},
		},
		{
			base_decay_rate = 0.8,
			high_threshold = 50,
			low_threshold = 0,
			max_value = 60,
			medium_threshold = 25,
			tension_modifier = 12,
			combat_states = {
				high = "high",
				low = "low",
				medium = "medium",
			},
		},
		{
			base_decay_rate = 0.8,
			high_threshold = 50,
			low_threshold = 0,
			max_value = 60,
			medium_threshold = 25,
			tension_modifier = 12,
			combat_states = {
				high = "high",
				low = "low",
				medium = "medium",
			},
		},
	},
}

return pacing_template
