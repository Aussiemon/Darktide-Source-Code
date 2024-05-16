-- chunkname: @dialogues/generated/mission_vo_dm_rise_psyker_female_b.lua

local mission_vo_dm_rise_psyker_female_b = {
	mission_rise_first_objective_response = {
		randomize_indexes_n = 0,
		sound_events_n = 10,
		sound_events = {
			"loc_psyker_female_b__guidance_starting_area_01",
			"loc_psyker_female_b__guidance_starting_area_02",
			"loc_psyker_female_b__guidance_starting_area_03",
			"loc_psyker_female_b__guidance_starting_area_04",
			"loc_psyker_female_b__guidance_starting_area_05",
			"loc_psyker_female_b__guidance_starting_area_06",
			"loc_psyker_female_b__guidance_starting_area_07",
			"loc_psyker_female_b__guidance_starting_area_08",
			"loc_psyker_female_b__guidance_starting_area_09",
			"loc_psyker_female_b__guidance_starting_area_10",
		},
		sound_events_duration = {
			1.542875,
			1.689292,
			2.206854,
			1.794875,
			1.488542,
			2.45075,
			2.846729,
			2.258458,
			2.091063,
			3.238646,
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
			0.1,
		},
		randomize_indexes = {},
	},
	mission_rise_keep_coming_b = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_psyker_female_b__event_survive_almost_done_01",
			"loc_psyker_female_b__event_survive_almost_done_02",
			"loc_psyker_female_b__event_survive_almost_done_03",
			"loc_psyker_female_b__event_survive_almost_done_04",
		},
		sound_events_duration = {
			1.6365,
			2.538521,
			2.651583,
			2.526771,
		},
		sound_event_weights = {
			0.25,
			0.25,
			0.25,
			0.25,
		},
		randomize_indexes = {},
	},
	mission_rise_start_b_sergeant_branch = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_psyker_female_b__region_habculum_01",
			"loc_psyker_female_b__region_habculum_02",
			"loc_psyker_female_b__region_habculum_03",
		},
		sound_events_duration = {
			4.395063,
			6.283625,
			4.012771,
		},
		sound_event_weights = {
			0.3333333,
			0.3333333,
			0.3333333,
		},
		randomize_indexes = {},
	},
	mission_rise_start_b_sergeant_branch_response = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_psyker_female_b__zone_transit_01",
			"loc_psyker_female_b__zone_transit_02",
			"loc_psyker_female_b__zone_transit_03",
		},
		sound_events_duration = {
			4.612313,
			5.808125,
			5.116521,
		},
		sound_event_weights = {
			0.3333333,
			0.3333333,
			0.3333333,
		},
		randomize_indexes = {},
	},
}

return settings("mission_vo_dm_rise_psyker_female_b", mission_vo_dm_rise_psyker_female_b)
