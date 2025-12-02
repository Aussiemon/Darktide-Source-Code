-- chunkname: @dialogues/generated/mission_vo_hm_strain_adamant_female_c.lua

local mission_vo_hm_strain_adamant_female_c = {
	event_demolition_first_corruptor_destroyed_strain_a = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_adamant_female_c__event_demolition_first_corruptor_destroyed_a_01",
			"loc_adamant_female_c__event_demolition_first_corruptor_destroyed_a_02",
			"loc_adamant_female_c__event_demolition_first_corruptor_destroyed_a_03",
			"loc_adamant_female_c__event_demolition_first_corruptor_destroyed_a_04",
		},
		sound_events_duration = {
			2.87701,
			2.90001,
			2.801323,
			4.191135,
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
			[1] = "loc_adamant_female_c__mission_strain_atmosphere_shield_01",
		},
		sound_events_duration = {
			[1] = 7.241146,
		},
		randomize_indexes = {},
	},
	mission_strain_crossroads = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1] = "loc_adamant_female_c__mission_strain_crossroads_01",
		},
		sound_events_duration = {
			[1] = 2.209656,
		},
		randomize_indexes = {},
	},
	mission_strain_first_objective_response = {
		randomize_indexes_n = 0,
		sound_events_n = 8,
		sound_events = {
			"loc_adamant_female_c__guidance_starting_area_01",
			"loc_adamant_female_c__guidance_starting_area_02",
			"loc_adamant_female_c__guidance_starting_area_03",
			"loc_adamant_female_c__guidance_starting_area_04",
			"loc_adamant_female_c__guidance_starting_area_05",
			"loc_adamant_female_c__guidance_starting_area_06",
			"loc_adamant_female_c__guidance_starting_area_07",
			"loc_adamant_female_c__guidance_starting_area_08",
		},
		sound_events_duration = {
			2.282708,
			2.790948,
			2.620156,
			2.567042,
			2.132865,
			2.604115,
			2.831365,
			2.629792,
		},
		sound_event_weights = {
			0.125,
			0.125,
			0.125,
			0.125,
			0.125,
			0.125,
			0.125,
			0.125,
		},
		randomize_indexes = {},
	},
	mission_strain_start_banter_a = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1] = "loc_adamant_female_c__mission_strain_start_banter_a_01",
		},
		sound_events_duration = {
			[1] = 4.979354,
		},
		randomize_indexes = {},
	},
	mission_strain_start_banter_c = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_adamant_female_c__region_periferus_01",
			"loc_adamant_female_c__region_periferus_02",
			"loc_adamant_female_c__region_periferus_03",
		},
		sound_events_duration = {
			3.853708,
			3.757813,
			3.600125,
		},
		sound_event_weights = {
			0.3333333,
			0.3333333,
			0.3333333,
		},
		randomize_indexes = {},
	},
}

return settings("mission_vo_hm_strain_adamant_female_c", mission_vo_hm_strain_adamant_female_c)
