local mission_vo_cm_raid_ogryn_b = {
	mission_raid_first_objective_response = {
		randomize_indexes_n = 0,
		sound_events_n = 10,
		sound_events = {
			"loc_ogryn_b__guidance_starting_area_01",
			"loc_ogryn_b__guidance_starting_area_02",
			"loc_ogryn_b__guidance_starting_area_03",
			"loc_ogryn_b__guidance_starting_area_04",
			"loc_ogryn_b__guidance_starting_area_05",
			"loc_ogryn_b__guidance_starting_area_06",
			"loc_ogryn_b__guidance_starting_area_07",
			"loc_ogryn_b__guidance_starting_area_08",
			"loc_ogryn_b__guidance_starting_area_09",
			"loc_ogryn_b__guidance_starting_area_10"
		},
		sound_events_duration = {
			2.409448,
			3.01275,
			1.793698,
			2.30924,
			3.229344,
			5.244063,
			3.821292,
			2.978958,
			3.775854,
			5.305125
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
			"loc_ogryn_b__region_carnival_a_01",
			"loc_ogryn_b__region_carnival_a_02",
			"loc_ogryn_b__region_carnival_a_03"
		},
		sound_events_duration = {
			4.459042,
			2.33175,
			2.5395
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
			"loc_ogryn_b__mission_raid_trapped_a_01",
			"loc_ogryn_b__mission_raid_trapped_a_02",
			"loc_ogryn_b__mission_raid_trapped_a_03",
			"loc_ogryn_b__mission_raid_trapped_a_04"
		},
		sound_events_duration = {
			1.814969,
			3.541958,
			2.539656,
			2.719146
		},
		randomize_indexes = {}
	},
	mission_raid_trapped_b = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_ogryn_b__mission_raid_trapped_b_01",
			"loc_ogryn_b__mission_raid_trapped_b_02",
			"loc_ogryn_b__mission_raid_trapped_b_03",
			"loc_ogryn_b__mission_raid_trapped_b_04"
		},
		sound_events_duration = {
			3.115302,
			3.265208,
			4.624833,
			4.627156
		},
		randomize_indexes = {}
	},
	mission_raid_trapped_c = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_ogryn_b__mission_raid_trapped_c_01",
			"loc_ogryn_b__mission_raid_trapped_c_02",
			"loc_ogryn_b__mission_raid_trapped_c_03",
			"loc_ogryn_b__mission_raid_trapped_c_04"
		},
		sound_events_duration = {
			3.449229,
			3.449781,
			3.425833,
			3.527313
		},
		randomize_indexes = {}
	}
}

return settings("mission_vo_cm_raid_ogryn_b", mission_vo_cm_raid_ogryn_b)
