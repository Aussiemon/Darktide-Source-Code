-- chunkname: @dialogues/generated/mission_vo_fm_cargo_adamant_male_a.lua

local mission_vo_fm_cargo_adamant_male_a = {
	mission_cargo_start_banter_a = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1] = "loc_adamant_male_a__mission_cargo_start_banter_a_01",
		},
		sound_events_duration = {
			[1] = 6.087594,
		},
		randomize_indexes = {},
	},
	mission_cargo_start_banter_c = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_adamant_male_a__region_mechanicus_01",
			"loc_adamant_male_a__region_mechanicus_02",
			"loc_adamant_male_a__region_mechanicus_03",
		},
		sound_events_duration = {
			3.853333,
			4.972667,
			3.618667,
		},
		sound_event_weights = {
			0.3333333,
			0.3333333,
			0.3333333,
		},
		randomize_indexes = {},
	},
	mission_cargo_start_banter_d = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_adamant_male_a__zone_tank_foundry_01",
			"loc_adamant_male_a__zone_tank_foundry_02",
			"loc_adamant_male_a__zone_tank_foundry_03",
		},
		sound_events_duration = {
			2.93801,
			3.430677,
			4.086677,
		},
		sound_event_weights = {
			0.3333333,
			0.3333333,
			0.3333333,
		},
		randomize_indexes = {},
	},
}

return settings("mission_vo_fm_cargo_adamant_male_a", mission_vo_fm_cargo_adamant_male_a)
