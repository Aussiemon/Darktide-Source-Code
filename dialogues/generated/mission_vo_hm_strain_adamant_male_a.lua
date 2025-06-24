-- chunkname: @dialogues/generated/mission_vo_hm_strain_adamant_male_a.lua

local mission_vo_hm_strain_adamant_male_a = {
	event_demolition_first_corruptor_destroyed_strain_a = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_adamant_male_a__event_demolition_first_corruptor_destroyed_a_01",
			"loc_adamant_male_a__event_demolition_first_corruptor_destroyed_a_02",
			"loc_adamant_male_a__event_demolition_first_corruptor_destroyed_a_03",
			"loc_adamant_male_a__event_demolition_first_corruptor_destroyed_a_04",
		},
		sound_events_duration = {
			2.948406,
			3.733333,
			4.620833,
			2.934052,
		},
		sound_event_weights = {
			0.25,
			0.25,
			0.25,
			0.25,
		},
		randomize_indexes = {},
	},
	mission_strain_atmosphere_shield = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1] = "loc_adamant_male_a__mission_strain_atmosphere_shield_01",
		},
		sound_events_duration = {
			[1] = 4.849365,
		},
		randomize_indexes = {},
	},
	mission_strain_crossroads = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1] = "loc_adamant_male_a__mission_strain_crossroads_01",
		},
		sound_events_duration = {
			[1] = 4.213281,
		},
		randomize_indexes = {},
	},
	mission_strain_start_banter_a = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1] = "loc_adamant_male_a__mission_strain_start_banter_a_01",
		},
		sound_events_duration = {
			[1] = 6.507302,
		},
		randomize_indexes = {},
	},
	mission_strain_start_banter_c = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_adamant_male_a__region_periferus_01",
			"loc_adamant_male_a__region_periferus_02",
			"loc_adamant_male_a__region_periferus_03",
		},
		sound_events_duration = {
			3.558667,
			3.992667,
			4.101344,
		},
		sound_event_weights = {
			0.3333333,
			0.3333333,
			0.3333333,
		},
		randomize_indexes = {},
	},
}

return settings("mission_vo_hm_strain_adamant_male_a", mission_vo_hm_strain_adamant_male_a)
