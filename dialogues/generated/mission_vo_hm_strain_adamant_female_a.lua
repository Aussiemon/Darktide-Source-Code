-- chunkname: @dialogues/generated/mission_vo_hm_strain_adamant_female_a.lua

local mission_vo_hm_strain_adamant_female_a = {
	event_demolition_first_corruptor_destroyed_strain_a = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_adamant_female_a__event_demolition_first_corruptor_destroyed_a_01",
			"loc_adamant_female_a__event_demolition_first_corruptor_destroyed_a_02",
			"loc_adamant_female_a__event_demolition_first_corruptor_destroyed_a_03",
			"loc_adamant_female_a__event_demolition_first_corruptor_destroyed_a_04",
		},
		sound_events_duration = {
			2.708156,
			3.039135,
			3.578802,
			2.267052,
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
			[1] = "loc_adamant_female_a__mission_strain_atmosphere_shield_01",
		},
		sound_events_duration = {
			[1] = 2.923906,
		},
		randomize_indexes = {},
	},
	mission_strain_crossroads = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1] = "loc_adamant_female_a__mission_strain_crossroads_01",
		},
		sound_events_duration = {
			[1] = 4.357313,
		},
		randomize_indexes = {},
	},
	mission_strain_first_objective_response = {
		randomize_indexes_n = 0,
		sound_events_n = 8,
		sound_events = {
			"loc_adamant_female_a__guidance_starting_area_01",
			"loc_adamant_female_a__guidance_starting_area_02",
			"loc_adamant_female_a__guidance_starting_area_03",
			"loc_adamant_female_a__guidance_starting_area_04",
			"loc_adamant_female_a__guidance_starting_area_05",
			"loc_adamant_female_a__guidance_starting_area_06",
			"loc_adamant_female_a__guidance_starting_area_07",
			"loc_adamant_female_a__guidance_starting_area_08",
		},
		sound_events_duration = {
			1.302021,
			2.593021,
			3.317521,
			3.8065,
			2.848792,
			3.968281,
			2.085708,
			4.802833,
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
			[1] = "loc_adamant_female_a__mission_strain_start_banter_a_01",
		},
		sound_events_duration = {
			[1] = 6.315344,
		},
		randomize_indexes = {},
	},
	mission_strain_start_banter_c = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_adamant_female_a__region_periferus_01",
			"loc_adamant_female_a__region_periferus_02",
			"loc_adamant_female_a__region_periferus_03",
		},
		sound_events_duration = {
			2.842354,
			3.776198,
			3.651438,
		},
		sound_event_weights = {
			0.3333333,
			0.3333333,
			0.3333333,
		},
		randomize_indexes = {},
	},
}

return settings("mission_vo_hm_strain_adamant_female_a", mission_vo_hm_strain_adamant_female_a)
