-- chunkname: @dialogues/generated/mission_vo_cm_raid_ogryn_d.lua

local mission_vo_cm_raid_ogryn_d = {
	mission_raid_first_objective_response = {
		randomize_indexes_n = 0,
		sound_events_n = 10,
		sound_events = {
			"loc_ogryn_d__guidance_starting_area_01",
			"loc_ogryn_d__guidance_starting_area_02",
			"loc_ogryn_d__guidance_starting_area_03",
			"loc_ogryn_d__guidance_starting_area_04",
			"loc_ogryn_d__guidance_starting_area_05",
			"loc_ogryn_d__guidance_starting_area_06",
			"loc_ogryn_d__guidance_starting_area_07",
			"loc_ogryn_d__guidance_starting_area_08",
			"loc_ogryn_d__guidance_starting_area_09",
			"loc_ogryn_d__guidance_starting_area_10",
		},
		sound_events_duration = {
			3.414156,
			5.921052,
			5.203438,
			5.783073,
			3.513135,
			4.039313,
			3.712104,
			4.885927,
			3.494604,
			4.877969,
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
			"loc_ogryn_d__region_carnival_a_01",
			"loc_ogryn_d__region_carnival_a_02",
			"loc_ogryn_d__region_carnival_a_03",
		},
		sound_events_duration = {
			3.762385,
			3.227917,
			7.033552,
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
			"loc_ogryn_d__mission_raid_trapped_a_01",
			"loc_ogryn_d__mission_raid_trapped_a_02",
			"loc_ogryn_d__mission_raid_trapped_a_03",
			"loc_ogryn_d__mission_raid_trapped_a_04",
		},
		sound_events_duration = {
			3.080792,
			2.20401,
			1.79974,
			4.205813,
		},
		randomize_indexes = {},
	},
	mission_raid_trapped_b = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_ogryn_d__mission_raid_trapped_b_01",
			"loc_ogryn_d__mission_raid_trapped_b_02",
			"loc_ogryn_d__mission_raid_trapped_b_03",
			"loc_ogryn_d__mission_raid_trapped_b_04",
		},
		sound_events_duration = {
			2.329271,
			2.341896,
			2.061083,
			2.4995,
		},
		randomize_indexes = {},
	},
	mission_raid_trapped_c = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_ogryn_d__mission_raid_trapped_c_01",
			"loc_ogryn_d__mission_raid_trapped_c_02",
			"loc_ogryn_d__mission_raid_trapped_c_03",
			"loc_ogryn_d__mission_raid_trapped_c_04",
		},
		sound_events_duration = {
			4.197333,
			3.054313,
			4.404135,
			6.333781,
		},
		randomize_indexes = {},
	},
}

return settings("mission_vo_cm_raid_ogryn_d", mission_vo_cm_raid_ogryn_d)
