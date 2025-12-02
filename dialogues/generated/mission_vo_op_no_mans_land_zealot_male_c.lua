-- chunkname: @dialogues/generated/mission_vo_op_no_mans_land_zealot_male_c.lua

local mission_vo_op_no_mans_land_zealot_male_c = {
	mission_trenches_first_objective_response = {
		randomize_indexes_n = 0,
		sound_events_n = 10,
		sound_events = {
			"loc_zealot_male_c__guidance_starting_area_01",
			"loc_zealot_male_c__guidance_starting_area_02",
			"loc_zealot_male_c__guidance_starting_area_03",
			"loc_zealot_male_c__guidance_starting_area_04",
			"loc_zealot_male_c__guidance_starting_area_05",
			"loc_zealot_male_c__guidance_starting_area_06",
			"loc_zealot_male_c__guidance_starting_area_07",
			"loc_zealot_male_c__guidance_starting_area_08",
			"loc_zealot_male_c__guidance_starting_area_09",
			"loc_zealot_male_c__guidance_starting_area_10",
		},
		sound_events_duration = {
			2.237354,
			3.021813,
			2.52375,
			3.301417,
			3.185729,
			3.474708,
			2.851688,
			4.621146,
			6.211156,
			3.073646,
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
}

return settings("mission_vo_op_no_mans_land_zealot_male_c", mission_vo_op_no_mans_land_zealot_male_c)
