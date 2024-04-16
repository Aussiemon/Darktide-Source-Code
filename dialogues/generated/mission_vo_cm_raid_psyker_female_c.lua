local mission_vo_cm_raid_psyker_female_c = {
	mission_raid_first_objective_response = {
		randomize_indexes_n = 0,
		sound_events_n = 10,
		sound_events = {
			"loc_psyker_female_c__guidance_starting_area_01",
			"loc_psyker_female_c__guidance_starting_area_02",
			"loc_psyker_female_c__guidance_starting_area_03",
			"loc_psyker_female_c__guidance_starting_area_04",
			"loc_psyker_female_c__guidance_starting_area_05",
			"loc_psyker_female_c__guidance_starting_area_06",
			"loc_psyker_female_c__guidance_starting_area_07",
			"loc_psyker_female_c__guidance_starting_area_08",
			"loc_psyker_female_c__guidance_starting_area_09",
			"loc_psyker_female_c__guidance_starting_area_10"
		},
		sound_events_duration = {
			4.751448,
			3.087969,
			2.863177,
			2.380927,
			4.205365,
			3.247052,
			3.539146,
			3.860083,
			3.383646,
			4.094688
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
			"loc_psyker_female_c__region_carnival_a_01",
			"loc_psyker_female_c__region_carnival_a_02",
			"loc_psyker_female_c__region_carnival_a_03"
		},
		sound_events_duration = {
			2.865823,
			3.957156,
			4.147396
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
			"loc_psyker_female_c__mission_raid_trapped_a_01",
			"loc_psyker_female_c__mission_raid_trapped_a_02",
			"loc_psyker_female_c__mission_raid_trapped_a_03",
			"loc_psyker_female_c__mission_raid_trapped_a_04"
		},
		sound_events_duration = {
			2.077646,
			1.947396,
			2.616177,
			3.339667
		},
		randomize_indexes = {}
	},
	mission_raid_trapped_b = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_psyker_female_c__mission_raid_trapped_b_01",
			"loc_psyker_female_c__mission_raid_trapped_b_02",
			"loc_psyker_female_c__mission_raid_trapped_b_03",
			"loc_psyker_female_c__mission_raid_trapped_b_04"
		},
		sound_events_duration = {
			5.858542,
			3.381917,
			3.924063,
			6.006573
		},
		randomize_indexes = {}
	},
	mission_raid_trapped_c = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_psyker_female_c__mission_raid_trapped_c_01",
			"loc_psyker_female_c__mission_raid_trapped_c_02",
			"loc_psyker_female_c__mission_raid_trapped_c_03",
			"loc_psyker_female_c__mission_raid_trapped_c_04"
		},
		sound_events_duration = {
			2.529531,
			3.416073,
			4.374208,
			4.61075
		},
		randomize_indexes = {}
	}
}

return settings("mission_vo_cm_raid_psyker_female_c", mission_vo_cm_raid_psyker_female_c)
