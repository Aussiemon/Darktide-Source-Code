-- chunkname: @dialogues/generated/mission_vo_dm_forge_adamant_female_a.lua

local mission_vo_dm_forge_adamant_female_a = {
	event_demolition_first_corruptor_destroyed_a_enginseer = {
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
	mission_forge_main_entrance_response = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_adamant_female_a__region_mechanicus_01",
			"loc_adamant_female_a__region_mechanicus_02",
			"loc_adamant_female_a__region_mechanicus_03",
		},
		sound_events_duration = {
			3.359177,
			3.79026,
			2.889688,
		},
		sound_event_weights = {
			0.3333333,
			0.3333333,
			0.3333333,
		},
		randomize_indexes = {},
	},
	mission_forge_start_banter_a = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1] = "loc_adamant_female_a__mission_forge_start_banter_a_01",
		},
		sound_events_duration = {
			[1] = 3.174917,
		},
		randomize_indexes = {},
	},
	mission_forge_start_banter_c = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_adamant_female_a__zone_tank_foundry_01",
			"loc_adamant_female_a__zone_tank_foundry_02",
			"loc_adamant_female_a__zone_tank_foundry_03",
		},
		sound_events_duration = {
			2.576302,
			3.465802,
			4.171031,
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
			[1] = "loc_adamant_female_a__mission_forge_strategic_asset_01",
		},
		sound_events_duration = {
			[1] = 4.148875,
		},
		randomize_indexes = {},
	},
}

return settings("mission_vo_dm_forge_adamant_female_a", mission_vo_dm_forge_adamant_female_a)
