-- chunkname: @dialogues/generated/mission_vo_hm_strain_adamant_male_c.lua

local mission_vo_hm_strain_adamant_male_c = {
	event_demolition_first_corruptor_destroyed_strain_a = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_adamant_male_c__event_demolition_first_corruptor_destroyed_a_01",
			"loc_adamant_male_c__event_demolition_first_corruptor_destroyed_a_02",
			"loc_adamant_male_c__event_demolition_first_corruptor_destroyed_a_03",
			"loc_adamant_male_c__event_demolition_first_corruptor_destroyed_a_04",
		},
		sound_events_duration = {
			1.721896,
			1.646792,
			2.411563,
			2.347844,
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
			[1] = "loc_adamant_male_c__mission_strain_atmosphere_shield_01",
		},
		sound_events_duration = {
			[1] = 6.358875,
		},
		randomize_indexes = {},
	},
	mission_strain_crossroads = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1] = "loc_adamant_male_c__mission_strain_crossroads_01",
		},
		sound_events_duration = {
			[1] = 3.20851,
		},
		randomize_indexes = {},
	},
	mission_strain_start_banter_a = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1] = "loc_adamant_male_c__mission_strain_start_banter_a_01",
		},
		sound_events_duration = {
			[1] = 5.145406,
		},
		randomize_indexes = {},
	},
	mission_strain_start_banter_c = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_adamant_male_c__region_periferus_01",
			"loc_adamant_male_c__region_periferus_02",
			"loc_adamant_male_c__region_periferus_03",
		},
		sound_events_duration = {
			5.05324,
			5.20225,
			4.028521,
		},
		sound_event_weights = {
			0.3333333,
			0.3333333,
			0.3333333,
		},
		randomize_indexes = {},
	},
}

return settings("mission_vo_hm_strain_adamant_male_c", mission_vo_hm_strain_adamant_male_c)
