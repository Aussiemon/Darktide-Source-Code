-- chunkname: @dialogues/generated/mission_vo_hm_strain_adamant_male_b.lua

local mission_vo_hm_strain_adamant_male_b = {
	event_demolition_first_corruptor_destroyed_strain_a = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_adamant_male_b__event_demolition_first_corruptor_destroyed_a_01",
			"loc_adamant_male_b__event_demolition_first_corruptor_destroyed_a_02",
			"loc_adamant_male_b__event_demolition_first_corruptor_destroyed_a_03",
			"loc_adamant_male_b__event_demolition_first_corruptor_destroyed_a_04",
		},
		sound_events_duration = {
			1.775104,
			2.103021,
			2.919448,
			1.74224,
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
			[1] = "loc_adamant_male_b__mission_strain_atmosphere_shield_01",
		},
		sound_events_duration = {
			[1] = 5.464781,
		},
		randomize_indexes = {},
	},
	mission_strain_crossroads = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1] = "loc_adamant_male_b__mission_strain_crossroads_01",
		},
		sound_events_duration = {
			[1] = 3.896292,
		},
		randomize_indexes = {},
	},
	mission_strain_start_banter_a = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1] = "loc_adamant_male_b__mission_strain_start_banter_a_01",
		},
		sound_events_duration = {
			[1] = 3.645833,
		},
		randomize_indexes = {},
	},
	mission_strain_start_banter_c = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_adamant_male_b__region_periferus_01",
			"loc_adamant_male_b__region_periferus_02",
			"loc_adamant_male_b__region_periferus_03",
		},
		sound_events_duration = {
			3.81176,
			4.241104,
			3.209542,
		},
		sound_event_weights = {
			0.3333333,
			0.3333333,
			0.3333333,
		},
		randomize_indexes = {},
	},
}

return settings("mission_vo_hm_strain_adamant_male_b", mission_vo_hm_strain_adamant_male_b)
