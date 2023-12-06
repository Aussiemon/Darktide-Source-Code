local mission_vo_cm_raid_psyker_male_b = {
	mission_raid_first_objective_response = {
		randomize_indexes_n = 0,
		sound_events_n = 10,
		sound_events = {
			"loc_psyker_male_b__guidance_starting_area_01",
			"loc_psyker_male_b__guidance_starting_area_02",
			"loc_psyker_male_b__guidance_starting_area_03",
			"loc_psyker_male_b__guidance_starting_area_04",
			"loc_psyker_male_b__guidance_starting_area_05",
			"loc_psyker_male_b__guidance_starting_area_06",
			"loc_psyker_male_b__guidance_starting_area_07",
			"loc_psyker_male_b__guidance_starting_area_08",
			"loc_psyker_male_b__guidance_starting_area_09",
			"loc_psyker_male_b__guidance_starting_area_10"
		},
		sound_events_duration = {
			1.998167,
			1.853771,
			2.238729,
			1.286896,
			1.377813,
			2.572667,
			3.0755,
			2.197708,
			2.287354,
			2.922938
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
			"loc_psyker_male_b__region_carnival_a_01",
			"loc_psyker_male_b__region_carnival_a_02",
			"loc_psyker_male_b__region_carnival_a_03"
		},
		sound_events_duration = {
			4.54375,
			3.567917,
			5.057646
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
			"loc_psyker_male_b__mission_raid_trapped_a_01",
			"loc_psyker_male_b__mission_raid_trapped_a_02",
			"loc_psyker_male_b__mission_raid_trapped_a_03",
			"loc_psyker_male_b__mission_raid_trapped_a_04"
		},
		sound_events_duration = {
			1.292771,
			2.750875,
			3.127083,
			3.591708
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
			"loc_psyker_male_b__mission_raid_trapped_b_01",
			"loc_psyker_male_b__mission_raid_trapped_b_02",
			"loc_psyker_male_b__mission_raid_trapped_b_03",
			"loc_psyker_male_b__mission_raid_trapped_b_04"
		},
		sound_events_duration = {
			3.077875,
			1.970104,
			2.560375,
			4.170563
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
			"loc_psyker_male_b__mission_raid_trapped_c_01",
			"loc_psyker_male_b__mission_raid_trapped_c_02",
			"loc_psyker_male_b__mission_raid_trapped_c_03",
			"loc_psyker_male_b__mission_raid_trapped_c_04"
		},
		sound_events_duration = {
			3.544,
			3.243271,
			2.133958,
			2.657854
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

return settings("mission_vo_cm_raid_psyker_male_b", mission_vo_cm_raid_psyker_male_b)
