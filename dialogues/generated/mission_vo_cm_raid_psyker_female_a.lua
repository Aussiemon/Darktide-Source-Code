local mission_vo_cm_raid_psyker_female_a = {
	mission_raid_first_objective_response = {
		randomize_indexes_n = 0,
		sound_events_n = 10,
		sound_events = {
			"loc_psyker_female_a__guidance_starting_area_01",
			"loc_psyker_female_a__guidance_starting_area_02",
			"loc_psyker_female_a__guidance_starting_area_03",
			"loc_psyker_female_a__guidance_starting_area_04",
			"loc_psyker_female_a__guidance_starting_area_05",
			"loc_psyker_female_a__guidance_starting_area_06",
			"loc_psyker_female_a__guidance_starting_area_07",
			"loc_psyker_female_a__guidance_starting_area_08",
			"loc_psyker_female_a__guidance_starting_area_09",
			"loc_psyker_female_a__guidance_starting_area_10"
		},
		sound_events_duration = {
			2.839167,
			3.078688,
			2.140896,
			3.877604,
			4.417042,
			2.364021,
			4.030083,
			3.321792,
			3.639792,
			3.531688
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
			"loc_psyker_female_a__region_carnival_a_01",
			"loc_psyker_female_a__region_carnival_a_02",
			"loc_psyker_female_a__region_carnival_a_03"
		},
		sound_events_duration = {
			5.733333,
			3.894208,
			7.256188
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
			"loc_psyker_female_a__mission_raid_trapped_a_01",
			"loc_psyker_female_a__mission_raid_trapped_a_02",
			"loc_psyker_female_a__mission_raid_trapped_a_03",
			"loc_psyker_female_a__mission_raid_trapped_a_04"
		},
		sound_events_duration = {
			1.410063,
			1.736688,
			2.135833,
			2.724229
		},
		randomize_indexes = {}
	},
	mission_raid_trapped_b = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_psyker_female_a__mission_raid_trapped_b_01",
			"loc_psyker_female_a__mission_raid_trapped_b_02",
			"loc_psyker_female_a__mission_raid_trapped_b_03",
			"loc_psyker_female_a__mission_raid_trapped_b_04"
		},
		sound_events_duration = {
			5.376729,
			4.972563,
			4.565708,
			5.834542
		},
		randomize_indexes = {}
	},
	mission_raid_trapped_c = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_psyker_female_a__mission_raid_trapped_c_01",
			"loc_psyker_female_a__mission_raid_trapped_c_02",
			"loc_psyker_female_a__mission_raid_trapped_c_03",
			"loc_psyker_female_a__mission_raid_trapped_c_04"
		},
		sound_events_duration = {
			2.217354,
			4.357,
			3.042313,
			4.369479
		},
		randomize_indexes = {}
	}
}

return settings("mission_vo_cm_raid_psyker_female_a", mission_vo_cm_raid_psyker_female_a)
