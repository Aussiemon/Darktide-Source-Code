-- chunkname: @dialogues/generated/mission_vo_cm_raid_ogryn_c.lua

local mission_vo_cm_raid_ogryn_c = {
	mission_raid_first_objective_response = {
		randomize_indexes_n = 0,
		sound_events_n = 10,
		sound_events = {
			"loc_ogryn_c__guidance_starting_area_01",
			"loc_ogryn_c__guidance_starting_area_02",
			"loc_ogryn_c__guidance_starting_area_03",
			"loc_ogryn_c__guidance_starting_area_04",
			"loc_ogryn_c__guidance_starting_area_05",
			"loc_ogryn_c__guidance_starting_area_06",
			"loc_ogryn_c__guidance_starting_area_07",
			"loc_ogryn_c__guidance_starting_area_08",
			"loc_ogryn_c__guidance_starting_area_09",
			"loc_ogryn_c__guidance_starting_area_10",
		},
		sound_events_duration = {
			2.687979,
			2.8775,
			3.552531,
			2.388438,
			3.068083,
			4.558521,
			3.969979,
			3.13975,
			3.403104,
			3.747969,
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
			"loc_ogryn_c__region_carnival_a_01",
			"loc_ogryn_c__region_carnival_a_02",
			"loc_ogryn_c__region_carnival_a_03",
		},
		sound_events_duration = {
			2.998688,
			2.43274,
			3.723771,
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
			"loc_ogryn_c__mission_raid_trapped_a_01",
			"loc_ogryn_c__mission_raid_trapped_a_02",
			"loc_ogryn_c__mission_raid_trapped_a_03",
			"loc_ogryn_c__mission_raid_trapped_a_04",
		},
		sound_events_duration = {
			1.938625,
			1.787958,
			1.514583,
			3.833344,
		},
		randomize_indexes = {},
	},
	mission_raid_trapped_b = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_ogryn_c__mission_raid_trapped_b_01",
			"loc_ogryn_c__mission_raid_trapped_b_02",
			"loc_ogryn_c__mission_raid_trapped_b_03",
			"loc_ogryn_c__mission_raid_trapped_b_04",
		},
		sound_events_duration = {
			2.933344,
			1.70001,
			3.233344,
			2.20001,
		},
		randomize_indexes = {},
	},
	mission_raid_trapped_c = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_ogryn_c__mission_raid_trapped_c_01",
			"loc_ogryn_c__mission_raid_trapped_c_02",
			"loc_ogryn_c__mission_raid_trapped_c_03",
			"loc_ogryn_c__mission_raid_trapped_c_04",
		},
		sound_events_duration = {
			2.90001,
			3.30001,
			3.633344,
			2.866677,
		},
		randomize_indexes = {},
	},
}

return settings("mission_vo_cm_raid_ogryn_c", mission_vo_cm_raid_ogryn_c)
