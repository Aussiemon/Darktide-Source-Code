-- chunkname: @dialogues/generated/mission_vo_dm_rise_zealot_female_c.lua

local mission_vo_dm_rise_zealot_female_c = {
	mission_rise_first_objective_response = {
		randomize_indexes_n = 0,
		sound_events_n = 10,
		sound_events = {
			"loc_zealot_female_c__guidance_starting_area_01",
			"loc_zealot_female_c__guidance_starting_area_02",
			"loc_zealot_female_c__guidance_starting_area_03",
			"loc_zealot_female_c__guidance_starting_area_04",
			"loc_zealot_female_c__guidance_starting_area_05",
			"loc_zealot_female_c__guidance_starting_area_06",
			"loc_zealot_female_c__guidance_starting_area_07",
			"loc_zealot_female_c__guidance_starting_area_08",
			"loc_zealot_female_c__guidance_starting_area_09",
			"loc_zealot_female_c__guidance_starting_area_10"
		},
		sound_events_duration = {
			2.013073,
			2.763698,
			2.47225,
			3.058135,
			2.737188,
			3.309667,
			2.604698,
			4.724615,
			5.153125,
			3.011281
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
			"loc_zealot_female_c__event_survive_almost_done_01",
			"loc_zealot_female_c__event_survive_almost_done_02",
			"loc_zealot_female_c__event_survive_almost_done_03",
			"loc_zealot_female_c__event_survive_almost_done_04"
		},
		sound_events_duration = {
			3.287823,
			3.777885,
			3.593042,
			4.753688
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
			"loc_zealot_female_c__region_habculum_01",
			"loc_zealot_female_c__region_habculum_02",
			"loc_zealot_female_c__region_habculum_03"
		},
		sound_events_duration = {
			5.056771,
			2.704771,
			6.109292
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
			"loc_zealot_female_c__zone_transit_01",
			"loc_zealot_female_c__zone_transit_02",
			"loc_zealot_female_c__zone_transit_03"
		},
		sound_events_duration = {
			4.259958,
			3.895198,
			5.567094
		},
		sound_event_weights = {
			0.3333333,
			0.3333333,
			0.3333333
		},
		randomize_indexes = {}
	}
}

return settings("mission_vo_dm_rise_zealot_female_c", mission_vo_dm_rise_zealot_female_c)
