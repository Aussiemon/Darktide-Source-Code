-- chunkname: @dialogues/generated/mission_vo_op_no_mans_land_ogryn_d.lua

local mission_vo_op_no_mans_land_ogryn_d = {
	mission_trenches_first_objective_response = {
		randomize_indexes_n = 0,
		sound_events_n = 10,
		sound_events = {
			"loc_ogryn_d__guidance_starting_area_01",
			"loc_ogryn_d__guidance_starting_area_02",
			"loc_ogryn_d__guidance_starting_area_03",
			"loc_ogryn_d__guidance_starting_area_04",
			"loc_ogryn_d__guidance_starting_area_05",
			"loc_ogryn_d__guidance_starting_area_06",
			"loc_ogryn_d__guidance_starting_area_07",
			"loc_ogryn_d__guidance_starting_area_08",
			"loc_ogryn_d__guidance_starting_area_09",
			"loc_ogryn_d__guidance_starting_area_10",
		},
		sound_events_duration = {
			3.414156,
			5.921052,
			5.203438,
			5.783073,
			3.513135,
			4.039313,
			3.712104,
			4.885927,
			3.494604,
			4.877969,
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

return settings("mission_vo_op_no_mans_land_ogryn_d", mission_vo_op_no_mans_land_ogryn_d)
