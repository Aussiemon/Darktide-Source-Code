-- chunkname: @dialogues/generated/mission_vo_dm_rise_zealot_female_b.lua

local mission_vo_dm_rise_zealot_female_b = {
	mission_rise_first_objective_response = {
		randomize_indexes_n = 0,
		sound_events_n = 10,
		sound_events = {
			"loc_zealot_female_b__guidance_starting_area_01",
			"loc_zealot_female_b__guidance_starting_area_02",
			"loc_zealot_female_b__guidance_starting_area_03",
			"loc_zealot_female_b__guidance_starting_area_04",
			"loc_zealot_female_b__guidance_starting_area_05",
			"loc_zealot_female_b__guidance_starting_area_06",
			"loc_zealot_female_b__guidance_starting_area_07",
			"loc_zealot_female_b__guidance_starting_area_08",
			"loc_zealot_female_b__guidance_starting_area_09",
			"loc_zealot_female_b__guidance_starting_area_10"
		},
		sound_events_duration = {
			1.610542,
			1.635375,
			3.170229,
			2.595125,
			3.769438,
			4.984063,
			2.656167,
			4.440458,
			3.321958,
			2.848896
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
			"loc_zealot_female_b__event_survive_almost_done_01",
			"loc_zealot_female_b__event_survive_almost_done_02",
			"loc_zealot_female_b__event_survive_almost_done_03",
			"loc_zealot_female_b__event_survive_almost_done_04"
		},
		sound_events_duration = {
			2.800208,
			3.527271,
			2.33125,
			2.504292
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
			"loc_zealot_female_b__region_habculum_01",
			"loc_zealot_female_b__region_habculum_02",
			"loc_zealot_female_b__region_habculum_03"
		},
		sound_events_duration = {
			4.296146,
			6.11475,
			2.481792
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
			"loc_zealot_female_b__zone_transit_01",
			"loc_zealot_female_b__zone_transit_02",
			"loc_zealot_female_b__zone_transit_03"
		},
		sound_events_duration = {
			4.234729,
			4.803896,
			3.656396
		},
		sound_event_weights = {
			0.3333333,
			0.3333333,
			0.3333333
		},
		randomize_indexes = {}
	}
}

return settings("mission_vo_dm_rise_zealot_female_b", mission_vo_dm_rise_zealot_female_b)
