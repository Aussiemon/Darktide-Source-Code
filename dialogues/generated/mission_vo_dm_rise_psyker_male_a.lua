-- chunkname: @dialogues/generated/mission_vo_dm_rise_psyker_male_a.lua

local mission_vo_dm_rise_psyker_male_a = {
	mission_rise_first_objective_response = {
		randomize_indexes_n = 0,
		sound_events_n = 10,
		sound_events = {
			"loc_psyker_male_a__guidance_starting_area_01",
			"loc_psyker_male_a__guidance_starting_area_02",
			"loc_psyker_male_a__guidance_starting_area_03",
			"loc_psyker_male_a__guidance_starting_area_04",
			"loc_psyker_male_a__guidance_starting_area_05",
			"loc_psyker_male_a__guidance_starting_area_06",
			"loc_psyker_male_a__guidance_starting_area_07",
			"loc_psyker_male_a__guidance_starting_area_08",
			"loc_psyker_male_a__guidance_starting_area_09",
			"loc_psyker_male_a__guidance_starting_area_10"
		},
		sound_events_duration = {
			4.460938,
			6.092438,
			2.789938,
			4.628729,
			6.292563,
			3.399583,
			5.082125,
			5.392583,
			3.9875,
			4.166396
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
			"loc_psyker_male_a__event_survive_almost_done_01",
			"loc_psyker_male_a__event_survive_almost_done_02",
			"loc_psyker_male_a__event_survive_almost_done_03",
			"loc_psyker_male_a__event_survive_almost_done_04"
		},
		sound_events_duration = {
			1.529229,
			1.69625,
			2.095833,
			2.139729
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
			"loc_psyker_male_a__region_habculum_01",
			"loc_psyker_male_a__region_habculum_02",
			"loc_psyker_male_a__region_habculum_03"
		},
		sound_events_duration = {
			4.298729,
			6.468,
			3.644604
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
			"loc_psyker_male_a__zone_transit_01",
			"loc_psyker_male_a__zone_transit_02",
			"loc_psyker_male_a__zone_transit_03"
		},
		sound_events_duration = {
			7.510313,
			3.483229,
			5.392188
		},
		sound_event_weights = {
			0.3333333,
			0.3333333,
			0.3333333
		},
		randomize_indexes = {}
	}
}

return settings("mission_vo_dm_rise_psyker_male_a", mission_vo_dm_rise_psyker_male_a)
