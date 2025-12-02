-- chunkname: @dialogues/generated/mission_vo_dm_forge_adamant_male_c.lua

local mission_vo_dm_forge_adamant_male_c = {
	event_demolition_first_corruptor_destroyed_a_enginseer = {
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
	mission_forge_first_objective_response = {
		randomize_indexes_n = 0,
		sound_events_n = 8,
		sound_events = {
			"loc_adamant_male_c__guidance_starting_area_01",
			"loc_adamant_male_c__guidance_starting_area_02",
			"loc_adamant_male_c__guidance_starting_area_03",
			"loc_adamant_male_c__guidance_starting_area_04",
			"loc_adamant_male_c__guidance_starting_area_05",
			"loc_adamant_male_c__guidance_starting_area_06",
			"loc_adamant_male_c__guidance_starting_area_07",
			"loc_adamant_male_c__guidance_starting_area_08",
		},
		sound_events_duration = {
			2.312833,
			3.367219,
			2.002302,
			2.842625,
			1.900979,
			2.532229,
			2.363865,
			2.993396,
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
	mission_forge_main_entrance_response = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_adamant_male_c__region_mechanicus_02",
			[2] = "loc_adamant_male_c__region_mechanicus_03",
		},
		sound_events_duration = {
			[1] = 4.177969,
			[2] = 5.495927,
		},
		sound_event_weights = {
			[1] = 0.5,
			[2] = 0.5,
		},
		randomize_indexes = {},
	},
	mission_forge_start_banter_a = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1] = "loc_adamant_male_c__mission_forge_start_banter_a_01",
		},
		sound_events_duration = {
			[1] = 5.510521,
		},
		randomize_indexes = {},
	},
	mission_forge_start_banter_c = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_adamant_male_c__zone_tank_foundry_01",
			"loc_adamant_male_c__zone_tank_foundry_02",
			"loc_adamant_male_c__zone_tank_foundry_03",
		},
		sound_events_duration = {
			3.808,
			4.590667,
			4.961333,
		},
		sound_event_weights = {
			0.3333333,
			0.3333333,
			0.3333333,
		},
		randomize_indexes = {},
	},
	mission_forge_strategic_asset = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1] = "loc_adamant_male_c__mission_forge_strategic_asset_01",
		},
		sound_events_duration = {
			[1] = 5.902969,
		},
		randomize_indexes = {},
	},
}

return settings("mission_vo_dm_forge_adamant_male_c", mission_vo_dm_forge_adamant_male_c)
