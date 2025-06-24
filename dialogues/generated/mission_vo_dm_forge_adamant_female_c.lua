-- chunkname: @dialogues/generated/mission_vo_dm_forge_adamant_female_c.lua

local mission_vo_dm_forge_adamant_female_c = {
	event_demolition_first_corruptor_destroyed_a_enginseer = {
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
	mission_forge_main_entrance_response = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_adamant_female_c__region_mechanicus_02",
			[2] = "loc_adamant_female_c__region_mechanicus_03",
		},
		sound_events_duration = {
			[1] = 3.516042,
			[2] = 3.609,
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
			[1] = "loc_adamant_female_c__mission_forge_start_banter_a_01",
		},
		sound_events_duration = {
			[1] = 4.397594,
		},
		randomize_indexes = {},
	},
	mission_forge_start_banter_c = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_adamant_female_c__zone_tank_foundry_01",
			"loc_adamant_female_c__zone_tank_foundry_02",
			"loc_adamant_female_c__zone_tank_foundry_03",
		},
		sound_events_duration = {
			2.826583,
			4.40949,
			4.1895,
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
			[1] = "loc_adamant_female_c__mission_forge_strategic_asset_01",
		},
		sound_events_duration = {
			[1] = 5.656938,
		},
		randomize_indexes = {},
	},
}

return settings("mission_vo_dm_forge_adamant_female_c", mission_vo_dm_forge_adamant_female_c)
