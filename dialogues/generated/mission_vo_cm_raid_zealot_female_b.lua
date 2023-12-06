local mission_vo_cm_raid_zealot_female_b = {
	mission_raid_first_objective_response = {
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
	mission_raid_region_carnival = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_zealot_female_b__region_carnival_a_01",
			"loc_zealot_female_b__region_carnival_a_02",
			"loc_zealot_female_b__region_carnival_a_03"
		},
		sound_events_duration = {
			2.677,
			4.547146,
			3.835604
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
			"loc_zealot_female_b__surrounded_04",
			"loc_zealot_female_b__surrounded_06",
			"loc_zealot_female_b__surrounded_08",
			"loc_zealot_female_b__surrounded_10"
		},
		sound_events_duration = {
			2.834417,
			2.381979,
			2.215979,
			1.999979
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
			"loc_zealot_female_b__surrounded_response_02",
			"loc_zealot_female_b__surrounded_response_07",
			"loc_zealot_female_b__surrounded_response_08",
			"loc_zealot_female_b__surrounded_response_10"
		},
		sound_events_duration = {
			2.457958,
			1.977104,
			1.369667,
			3.155083
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

return settings("mission_vo_cm_raid_zealot_female_b", mission_vo_cm_raid_zealot_female_b)
