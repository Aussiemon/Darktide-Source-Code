local mission_vo_dm_rise_psyker_female_a = {
	mission_rise_first_objective_response = {
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
	mission_rise_keep_coming_b = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_psyker_female_a__event_survive_almost_done_01",
			"loc_psyker_female_a__event_survive_almost_done_02",
			"loc_psyker_female_a__event_survive_almost_done_03",
			"loc_psyker_female_a__event_survive_almost_done_04"
		},
		sound_events_duration = {
			1.320125,
			2.158938,
			1.877583,
			2.801604
		},
		sound_event_weights = {
			0.25,
			0.25,
			0.25,
			0.25
		},
		randomize_indexes = {}
	},
	mission_rise_start_b_sergeant_branch = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_psyker_female_a__region_habculum_01",
			"loc_psyker_female_a__region_habculum_02",
			"loc_psyker_female_a__region_habculum_03"
		},
		sound_events_duration = {
			3.069396,
			6.564333,
			3.171917
		},
		sound_event_weights = {
			0.3333333,
			0.3333333,
			0.3333333
		},
		randomize_indexes = {}
	},
	mission_rise_start_b_sergeant_branch_response = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_psyker_female_a__zone_transit_01",
			"loc_psyker_female_a__zone_transit_02",
			"loc_psyker_female_a__zone_transit_03"
		},
		sound_events_duration = {
			6.015896,
			3.499208,
			5.151208
		},
		sound_event_weights = {
			0.3333333,
			0.3333333,
			0.3333333
		},
		randomize_indexes = {}
	}
}

return settings("mission_vo_dm_rise_psyker_female_a", mission_vo_dm_rise_psyker_female_a)
