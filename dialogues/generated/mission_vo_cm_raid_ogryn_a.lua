-- chunkname: @dialogues/generated/mission_vo_cm_raid_ogryn_a.lua

local mission_vo_cm_raid_ogryn_a = {
	mission_raid_first_objective_response = {
		randomize_indexes_n = 0,
		sound_events_n = 10,
		sound_events = {
			"loc_ogryn_a__guidance_starting_area_01",
			"loc_ogryn_a__guidance_starting_area_02",
			"loc_ogryn_a__guidance_starting_area_03",
			"loc_ogryn_a__guidance_starting_area_04",
			"loc_ogryn_a__guidance_starting_area_05",
			"loc_ogryn_a__guidance_starting_area_06",
			"loc_ogryn_a__guidance_starting_area_07",
			"loc_ogryn_a__guidance_starting_area_08",
			"loc_ogryn_a__guidance_starting_area_09",
			"loc_ogryn_a__guidance_starting_area_10",
		},
		sound_events_duration = {
			1.048844,
			1.904646,
			2.28326,
			1.733802,
			2.825177,
			3.4055,
			1.868063,
			2.969396,
			2.054813,
			2.613104,
		},
		sound_event_weights = {
			0.1,
			0.1,
			0.1,
			0.1,
			0.1,
			0.1,
			0.1,
			0.1,
			0.1,
			0.1,
		},
		randomize_indexes = {},
	},
	mission_raid_region_carnival = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_ogryn_a__region_carnival_a_01",
			"loc_ogryn_a__region_carnival_a_02",
			"loc_ogryn_a__region_carnival_a_03",
		},
		sound_events_duration = {
			6.684208,
			4.149302,
			5.410521,
		},
		sound_event_weights = {
			0.3333333,
			0.3333333,
			0.3333333,
		},
		randomize_indexes = {},
	},
	mission_raid_trapped_a = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_ogryn_a__mission_raid_trapped_a_01",
			"loc_ogryn_a__mission_raid_trapped_a_02",
			"loc_ogryn_a__mission_raid_trapped_a_03",
			"loc_ogryn_a__mission_raid_trapped_a_04",
		},
		sound_events_duration = {
			2.112146,
			2.585198,
			3.842771,
			2.378094,
		},
		randomize_indexes = {},
	},
	mission_raid_trapped_b = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_ogryn_a__mission_raid_trapped_b_01",
			"loc_ogryn_a__mission_raid_trapped_b_02",
			"loc_ogryn_a__mission_raid_trapped_b_03",
			"loc_ogryn_a__mission_raid_trapped_b_04",
		},
		sound_events_duration = {
			2.189917,
			2.510417,
			5.351156,
			2.704,
		},
		randomize_indexes = {},
	},
	mission_raid_trapped_c = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_ogryn_a__mission_raid_trapped_c_01",
			"loc_ogryn_a__mission_raid_trapped_c_02",
			"loc_ogryn_a__mission_raid_trapped_c_03",
			"loc_ogryn_a__mission_raid_trapped_c_04",
		},
		sound_events_duration = {
			3.556604,
			1.691885,
			4.075083,
			5.736281,
		},
		randomize_indexes = {},
	},
}

return settings("mission_vo_cm_raid_ogryn_a", mission_vo_cm_raid_ogryn_a)
