-- chunkname: @dialogues/generated/mission_vo_op_no_mans_land_broker_female_b.lua

local mission_vo_op_no_mans_land_broker_female_b = {
	mission_trenches_first_objective_response = {
		randomize_indexes_n = 0,
		sound_events_n = 5,
		sound_events = {
			"loc_broker_female_b__guidance_starting_area_01",
			"loc_broker_female_b__guidance_starting_area_02",
			"loc_broker_female_b__guidance_starting_area_03",
			"loc_broker_female_b__guidance_starting_area_04",
			"loc_broker_female_b__guidance_starting_area_05",
		},
		sound_events_duration = {
			3.989708,
			3.952698,
			3.021573,
			3.366896,
			2.885917,
		},
		sound_event_weights = {
			0.2,
			0.2,
			0.2,
			0.2,
			0.2,
		},
		randomize_indexes = {},
	},
}

return settings("mission_vo_op_no_mans_land_broker_female_b", mission_vo_op_no_mans_land_broker_female_b)
