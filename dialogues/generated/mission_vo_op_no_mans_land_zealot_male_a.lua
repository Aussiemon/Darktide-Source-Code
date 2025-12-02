-- chunkname: @dialogues/generated/mission_vo_op_no_mans_land_zealot_male_a.lua

local mission_vo_op_no_mans_land_zealot_male_a = {
	mission_trenches_first_objective_response = {
		randomize_indexes_n = 0,
		sound_events_n = 10,
		sound_events = {
			"loc_zealot_male_a__guidance_starting_area_01",
			"loc_zealot_male_a__guidance_starting_area_02",
			"loc_zealot_male_a__guidance_starting_area_03",
			"loc_zealot_male_a__guidance_starting_area_04",
			"loc_zealot_male_a__guidance_starting_area_05",
			"loc_zealot_male_a__guidance_starting_area_06",
			"loc_zealot_male_a__guidance_starting_area_07",
			"loc_zealot_male_a__guidance_starting_area_08",
			"loc_zealot_male_a__guidance_starting_area_09",
			"loc_zealot_male_a__guidance_starting_area_10",
		},
		sound_events_duration = {
			1.120792,
			1.273313,
			1.124146,
			2.188063,
			2.252375,
			1.989813,
			2.571313,
			3.660875,
			2.525271,
			2.869521,
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

return settings("mission_vo_op_no_mans_land_zealot_male_a", mission_vo_op_no_mans_land_zealot_male_a)
