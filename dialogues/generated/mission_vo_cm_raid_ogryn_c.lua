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
			"loc_ogryn_c__guidance_starting_area_10"
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
			3.747969
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
			0.1
		},
		randomize_indexes = {}
	},
	mission_raid_region_carnival = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_ogryn_c__region_carnival_a_01",
			"loc_ogryn_c__region_carnival_a_02",
			"loc_ogryn_c__region_carnival_a_03"
		},
		sound_events_duration = {
			2.998688,
			2.43274,
			3.723771
		},
		sound_event_weights = {
			0.3333333,
			0.3333333,
			0.3333333
		},
		randomize_indexes = {}
	},
	mission_raid_trapped_a = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_ogryn_c__surrounded_03",
			"loc_ogryn_c__surrounded_05",
			"loc_ogryn_c__surrounded_06",
			"loc_ogryn_c__surrounded_07"
		},
		sound_events_duration = {
			3.0605,
			3.019948,
			4.931115,
			3.696396
		},
		sound_event_weights = {
			0.25,
			0.25,
			0.25,
			0.25
		},
		randomize_indexes = {}
	},
	mission_raid_trapped_b = {
		randomize_indexes_n = 0,
		sound_events_n = 5,
		sound_events = {
			"loc_ogryn_c__surrounded_response_02",
			"loc_ogryn_c__surrounded_response_04",
			"loc_ogryn_c__surrounded_response_06",
			"loc_ogryn_c__surrounded_response_08",
			"loc_ogryn_c__surrounded_response_10"
		},
		sound_events_duration = {
			5.63426,
			4.112083,
			2.986313,
			2.703781,
			4.085521
		},
		sound_event_weights = {
			0.2,
			0.2,
			0.2,
			0.2,
			0.2
		},
		randomize_indexes = {}
	}
}

return settings("mission_vo_cm_raid_ogryn_c", mission_vo_cm_raid_ogryn_c)
