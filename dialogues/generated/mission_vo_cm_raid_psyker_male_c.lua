local mission_vo_cm_raid_psyker_male_c = {
	mission_raid_first_objective_response = {
		randomize_indexes_n = 0,
		sound_events_n = 10,
		sound_events = {
			"loc_psyker_male_c__guidance_starting_area_01",
			"loc_psyker_male_c__guidance_starting_area_02",
			"loc_psyker_male_c__guidance_starting_area_03",
			"loc_psyker_male_c__guidance_starting_area_04",
			"loc_psyker_male_c__guidance_starting_area_05",
			"loc_psyker_male_c__guidance_starting_area_06",
			"loc_psyker_male_c__guidance_starting_area_07",
			"loc_psyker_male_c__guidance_starting_area_08",
			"loc_psyker_male_c__guidance_starting_area_09",
			"loc_psyker_male_c__guidance_starting_area_10"
		},
		sound_events_duration = {
			4.944573,
			2.607427,
			2.896125,
			2.726979,
			4.333031,
			3.791271,
			3.497927,
			4.412458,
			4.215552,
			4.21376
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
			"loc_psyker_male_c__region_carnival_a_01",
			"loc_psyker_male_c__region_carnival_a_02",
			"loc_psyker_male_c__region_carnival_a_03"
		},
		sound_events_duration = {
			2.559656,
			3.539135,
			3.475688
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
			"loc_psyker_male_c__mission_raid_trapped_a_01",
			"loc_psyker_male_c__mission_raid_trapped_a_02",
			"loc_psyker_male_c__mission_raid_trapped_a_03",
			"loc_psyker_male_c__mission_raid_trapped_a_04"
		},
		sound_events_duration = {
			1.430083,
			1.794573,
			2.443948,
			3.304313
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
		sound_events_n = 4,
		sound_events = {
			"loc_psyker_male_c__mission_raid_trapped_b_01",
			"loc_psyker_male_c__mission_raid_trapped_b_02",
			"loc_psyker_male_c__mission_raid_trapped_b_03",
			"loc_psyker_male_c__mission_raid_trapped_b_04"
		},
		sound_events_duration = {
			5.130677,
			3.468906,
			4.518438,
			5.285427
		},
		sound_event_weights = {
			0.25,
			0.25,
			0.25,
			0.25
		},
		randomize_indexes = {}
	},
	mission_raid_trapped_c = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_psyker_male_c__mission_raid_trapped_c_01",
			"loc_psyker_male_c__mission_raid_trapped_c_02",
			"loc_psyker_male_c__mission_raid_trapped_c_03",
			"loc_psyker_male_c__mission_raid_trapped_c_04"
		},
		sound_events_duration = {
			2.850052,
			3.153906,
			4.586146,
			4.694719
		},
		sound_event_weights = {
			0.25,
			0.25,
			0.25,
			0.25
		},
		randomize_indexes = {}
	}
}

return settings("mission_vo_cm_raid_psyker_male_c", mission_vo_cm_raid_psyker_male_c)
