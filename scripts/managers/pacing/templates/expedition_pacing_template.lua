-- chunkname: @scripts/managers/pacing/templates/expedition_pacing_template.lua

local HordePacingTemplates = require("scripts/managers/pacing/horde_pacing/horde_pacing_templates")
local SpecialsPacingTemplates = require("scripts/managers/pacing/specials_pacing/specials_pacing_templates")
local MonsterPacingTemplates = require("scripts/managers/pacing/monster_pacing/monster_pacing_templates")
local RoamerPacingTemplates = require("scripts/managers/pacing/roamer_pacing/roamer_pacing_templates")

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

local function _indexed_by_location(...)
	local indexed_by_location = {}
	local length = select("#", ...)
	local previous_index = 1
	local difference, steps, mutliplier_per_step, previous_data
	local stepped = 0

	for i = 1, length do
		local data = select(i, ...)
		local should_interpolate = data[3]

		if i ~= 1 then
			previous_data = select(i - 1, ...)
		end

		if previous_data then
			difference = data[2] - previous_data[2]
			steps = data[1] - previous_data[1]
			mutliplier_per_step = difference / steps
		end

		if data[1] == previous_index + 1 or not previous_data then
			indexed_by_location[#indexed_by_location + 1] = data[2]
			previous_index = data[1]
		else
			for ii = previous_index, data[1] - 1 do
				if should_interpolate and previous_data then
					stepped = stepped + 1
					indexed_by_location[#indexed_by_location + 1] = mutliplier_per_step * stepped + previous_data[2]
				else
					indexed_by_location[#indexed_by_location + 1] = data[2]
				end
			end

			stepped = 0
			previous_index = data[1]
		end
	end

	return indexed_by_location
end

local function _multiplier_step_desc(value)
	local multiplier_step = {
		value * 1.75,
		value * 1.5,
		value * 1.35,
		value * 1.2,
		value * 1,
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
		monsters = false,
		roamers = true,
		specials = true,
		terror_events = true,
		trickle_hordes = true,
	},
	build_up_tension = {
		hordes = true,
		monsters = false,
		roamers = true,
		specials = true,
		terror_events = true,
		trickle_hordes = true,
	},
	build_up_tension_high = {
		hordes = true,
		monsters = false,
		roamers = true,
		specials = true,
		terror_events = true,
		trickle_hordes = true,
	},
	sustain_tension_peak = {
		hordes = false,
		monsters = false,
		roamers = false,
		specials = false,
		terror_events = true,
		trickle_hordes = false,
	},
	tension_peak_fade = {
		hordes = false,
		monsters = false,
		roamers = false,
		specials = false,
		terror_events = true,
		trickle_hordes = false,
	},
	relax = {
		hordes = true,
		monsters = false,
		roamers = true,
		specials = true,
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
local MAX_HEAT = {
	100,
	100,
	100,
	100,
	100,
}
local HEAT_THRESHOLD_TYPES = {
	"none",
	"undetected",
	"alert",
	"detected",
	"max",
}
local HEAT_ALLOWED_SPAWN_TYPES = {
	none = {
		auto_events = true,
		hordes = false,
		monsters = false,
		roamers = true,
		specials = true,
		terror_events = true,
		trickle_hordes = true,
	},
	undetected = {
		auto_events = true,
		hordes = false,
		monsters = false,
		roamers = true,
		specials = true,
		terror_events = true,
		trickle_hordes = true,
	},
	alert = {
		auto_events = true,
		hordes = true,
		monsters = true,
		roamers = true,
		specials = true,
		terror_events = true,
		trickle_hordes = true,
	},
	detected = {
		auto_events = true,
		hordes = true,
		monsters = true,
		roamers = true,
		specials = true,
		terror_events = true,
		trickle_hordes = true,
	},
	max = {
		auto_events = true,
		hordes = true,
		monsters = true,
		roamers = true,
		specials = true,
		terror_events = true,
		trickle_hordes = true,
	},
}
local ALLOWED_TO_DROP_STAGE = {
	none = {
		true,
		true,
		true,
		true,
		true,
	},
	undetected = {
		false,
		false,
		false,
		false,
		false,
	},
	alert = {
		true,
		true,
		true,
		true,
		true,
	},
	detected = {
		true,
		true,
		true,
		true,
		true,
	},
	max = {
		true,
		true,
		true,
		true,
		true,
	},
}
local REQUIRED_TIME_AT_STAGE = {
	none = {
		0,
		0,
		0,
		0,
		0,
	},
	undetected = {
		5,
		5,
		5,
		5,
		5,
	},
	alert = {
		10,
		10,
		10,
		10,
		10,
	},
	detected = {
		20,
		20,
		20,
		20,
		20,
	},
	max = {
		30,
		30,
		30,
		30,
		30,
	},
}
local SPECIALS_ONLY_UPDATE_INJECTED_SLOTS = {
	alert = false,
	detected = false,
	max = false,
	none = true,
	undetected = true,
}
local HORDE_TIMER_MULTIPLIER = {
	none = {
		1,
		1,
		1,
		1,
		1,
	},
	undetected = {
		1,
		1,
		1,
		1,
		1,
	},
	alert = {
		1,
		1,
		1,
		1,
		1,
	},
	detected = {
		1,
		1,
		1,
		0.7,
		0.6,
	},
	max = {
		1,
		1,
		1,
		0.8,
		0.7,
	},
}
local HORDE_RATE_MULTIPLIER = {
	none = {
		1,
		1,
		1,
		1,
		1,
	},
	undetected = {
		1,
		1.1,
		1.1,
		1.3,
		1.5,
	},
	alert = {
		1.2,
		1.2,
		1.2,
		1.5,
		2,
	},
	detected = {
		1.2,
		1.3,
		1.3,
		1.7,
		2.5,
	},
	max = {
		1.2,
		1.5,
		1.4,
		2.2,
		2.5,
	},
}
local TRICKLE_HORDE_COOLDOWN_MODIFER = {
	none = {
		1,
		1,
		1,
		1,
		1,
	},
	undetected = {
		1,
		1,
		0.8,
		1,
		0.9,
	},
	alert = {
		1,
		1,
		0.6,
		0.8,
		0.8,
	},
	detected = {
		1,
		1,
		1.2,
		0.8,
		0.8,
	},
	max = {
		1,
		1,
		1.2,
		0.8,
		0.8,
	},
}
local TRICKLE_HORDE_DISTANCE_MODIFER = {
	none = {
		1,
		1,
		1,
		1,
		1,
	},
	undetected = {
		1,
		1,
		1,
		1,
		0.8,
	},
	alert = {
		1,
		1,
		0.8,
		0.8,
		0.8,
	},
	detected = {
		1,
		1,
		0.8,
		0.8,
		0.8,
	},
	max = {
		1,
		1,
		0.8,
		0.8,
		0.8,
	},
}
local TRICKLE_HORDE_MAX_ALLOWED_BEFORE_COOLDOWN_MODIFER = {
	none = {
		0,
		0,
		0,
		0,
		1,
	},
	undetected = {
		0,
		0,
		1,
		2,
		2,
	},
	alert = {
		0,
		0,
		2,
		2,
		3,
	},
	detected = {
		0,
		0,
		1,
		2,
		2,
	},
	max = {
		0,
		0,
		0,
		0,
		0,
	},
}
local EXTRACTION_WAIT_TIMINGS = {
	none = {
		valkyrie = {
			20,
			20,
		},
		safe_zone = {
			30,
			30,
		},
	},
	undetected = {
		valkyrie = {
			20,
			20,
		},
		safe_zone = {
			30,
			30,
		},
	},
	alert = {
		valkyrie = {
			20,
			20,
		},
		safe_zone = {
			30,
			30,
		},
	},
	detected = {
		valkyrie = {
			20,
			20,
		},
		safe_zone = {
			30,
			30,
		},
	},
	max = {
		valkyrie = {
			20,
			20,
		},
		safe_zone = {
			30,
			30,
		},
	},
}
local ROAMER_MINIMUM_SETTINGS = {
	multiplier_per_stage = {
		alert = 1.5,
		detected = 1.25,
		max = 1,
		none = 1,
		undetected = 1.25,
	},
	base_value = {
		20,
		25,
		30,
		33,
		38,
	},
}

local function _get_threshold(index, split_max_heat)
	local threshold = 0

	for i = 1, index - 1 do
		threshold = threshold + split_max_heat
	end

	return threshold
end

local function _generate_heat_settings()
	local heat_settings_per_challenge = {}

	for difficulty_index = 1, 5 do
		local max_heat = MAX_HEAT[difficulty_index]
		local thresholds = {}
		local split_max_heat = max_heat / 4

		for threshold_index = 1, 5 do
			local stage_type = HEAT_THRESHOLD_TYPES[threshold_index]

			thresholds[HEAT_THRESHOLD_TYPES[threshold_index]] = {
				threshold = _get_threshold(threshold_index, split_max_heat),
				allowed_spawn_types = HEAT_ALLOWED_SPAWN_TYPES[stage_type],
				specials_use_full_update = SPECIALS_ONLY_UPDATE_INJECTED_SLOTS[stage_type],
				allowed_to_drop_stage = ALLOWED_TO_DROP_STAGE[stage_type][difficulty_index],
				required_time_at_stage = REQUIRED_TIME_AT_STAGE[stage_type][difficulty_index],
				horde_timer_multiplier = HORDE_TIMER_MULTIPLIER[stage_type][difficulty_index],
				horde_rate_multiplier = HORDE_RATE_MULTIPLIER[stage_type][difficulty_index],
				extraction_wait_timings = EXTRACTION_WAIT_TIMINGS[stage_type],
				trickle_horde_overrides = {
					trickle_horde_travel_distance_range = TRICKLE_HORDE_DISTANCE_MODIFER[stage_type][difficulty_index],
					num_trickle_hordes_active_for_cooldown = TRICKLE_HORDE_MAX_ALLOWED_BEFORE_COOLDOWN_MODIFER[stage_type][difficulty_index],
					trickle_horde_cooldown = TRICKLE_HORDE_COOLDOWN_MODIFER[stage_type][difficulty_index],
				},
			}
		end

		heat_settings_per_challenge[difficulty_index] = thresholds
	end

	return heat_settings_per_challenge
end

local pacing_template = {
	auto_event_template = "expedition_auto_event_template",
	name = "expedition",
	progression_type = "expedition",
	starting_state = "build_up_tension_low",
	use_heat = true,
	horde_pacing_template = HordePacingTemplates.expedition_horde,
	specials_pacing_template = SpecialsPacingTemplates.expedition_specials,
	monster_pacing_template = MonsterPacingTemplates.expedition_monsters,
	roamer_pacing_template = RoamerPacingTemplates.expedition_roamers,
	max_tension = _multiplier_step(100),
	challenge_rating_thresholds = {
		specials = _challenge_rating_multiplier_steps(40),
		hordes = _challenge_rating_multiplier_steps(45),
		trickle_hordes = _challenge_rating_multiplier_steps(35),
		roamers = _challenge_rating_multiplier_steps(90),
		terror_events = _challenge_rating_multiplier_steps(100),
		auto_events = _challenge_rating_multiplier_steps(100),
	},
	ramp_up_frequency_modifiers = DEFAULT_RAMP_UP_FREQUENCY_MODIFIERS,
	min_wound_tension_requirement = {
		false,
		false,
		false,
		true,
		true,
	},
	heat_settings = {
		decay_heat_delay = 3,
		heat_decay_update_frequency = 1,
		record_heat_generation_per_player = true,
		should_disable_heat_on_timer_elapse = true,
		player_heat_decay_rate = _multiplier_step_desc(0.05),
		special_config = {
			threshold = 20,
			breeds = {
				"chaos_hound",
				"chaos_poxwalker_bomber",
				"grenadier",
				"renegade_netgunner",
				"flamer",
				"cultist_mutant",
				"renegade_sniper",
			},
			chance_for_special_injection = {
				0,
				0,
				0.3,
				0.5,
				0.6,
			},
		},
		trickle_patrol_settings = {
			alert = 0.3,
			detected = 0.5,
			max = 1,
			none = 0,
			undetected = 0,
		},
		heat_multiplier = {
			aggroed = _indexed_by_location({
				1,
				1,
			}, {
				2,
				1,
				true,
			}),
			pickups = _indexed_by_location({
				1,
				1,
			}, {
				2,
				1,
				true,
			}),
			oppertunity = _indexed_by_location({
				1,
				1,
			}, {
				2,
				1,
				true,
			}),
		},
		heat_decay_rate = _multiplier_step_desc(0.05),
		max_heat = MAX_HEAT,
		lowest_decay_allowed = _multiplier_step(10),
		heat_stages = _generate_heat_settings(),
		heat_conditions_lookup = HEAT_THRESHOLD_TYPES,
		heat_starting_stage = HEAT_THRESHOLD_TYPES[1],
		allowed_heat_generating_spawn_types = {
			default = false,
			roamer_pacing = true,
			trickle_patrol = true,
		},
		heat_lookups = {
			opportunities = {
				escape_event = 35,
				high = 15,
				low = 5,
				medium = 10,
				traversal = 0,
			},
			pickups = {
				large = 0,
				luggable = 0,
				medium = 0,
				small = 0,
			},
			lower_heat = {
				low = {
					5,
					4,
					3,
					2,
					1,
				},
				medium = {
					7,
					5,
					3,
					2,
					1,
				},
				high = {
					15,
					15,
					10,
					10,
					5,
				},
			},
			time_elapsed = {
				timer = 0,
			},
			heat_stage_per_location = {
				{
					name = "none",
					threshold = 0,
				},
				{
					name = "undetected",
					threshold = 2,
				},
				{
					name = "alert",
					threshold = 4,
				},
				{
					name = "detected",
					threshold = 99,
				},
				{
					name = "max",
					threshold = 99,
				},
			},
		},
		heat_stage_orders = {
			none = {
				next_stage = "undetected",
			},
			undetected = {
				back_stage = "none",
				next_stage = "alert",
			},
			alert = {
				back_stage = "undetected",
				next_stage = "detected",
			},
			detected = {
				back_stage = "alert",
				next_stage = "max",
			},
			max = {
				back_stage = "detected",
			},
		},
		stage_heat_breed_multipliers = {
			alert = 0.25,
			detected = 0,
			max = 0,
			none = 1,
			undetected = 0.5,
		},
		stage_index = {
			alert = 3,
			detected = 4,
			max = 5,
			none = 1,
			undetected = 2,
		},
		roamer_minimum_settings = ROAMER_MINIMUM_SETTINGS,
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
