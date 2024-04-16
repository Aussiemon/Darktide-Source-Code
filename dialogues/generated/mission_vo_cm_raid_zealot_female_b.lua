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
			"loc_zealot_female_b__mission_raid_trapped_a_01",
			"loc_zealot_female_b__mission_raid_trapped_a_02",
			"loc_zealot_female_b__mission_raid_trapped_a_03",
			"loc_zealot_female_b__mission_raid_trapped_a_04"
		},
		sound_events_duration = {
			0.793458,
			1.339208,
			0.938021,
			1.637542
		},
		randomize_indexes = {}
	},
	mission_raid_trapped_b = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_zealot_female_b__mission_raid_trapped_b_01",
			"loc_zealot_female_b__mission_raid_trapped_b_02",
			"loc_zealot_female_b__mission_raid_trapped_b_03",
			"loc_zealot_female_b__mission_raid_trapped_b_04"
		},
		sound_events_duration = {
			2.174063,
			3.808292,
			2.245021,
			3.581542
		},
		randomize_indexes = {}
	},
	mission_raid_trapped_c = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_zealot_female_b__mission_raid_trapped_c_03",
			[2.0] = "loc_zealot_female_b__mission_raid_trapped_c_04"
		},
		sound_events_duration = {
			[1.0] = 1.453667,
			[2.0] = 2.421438
		},
		randomize_indexes = {}
	}
}

return settings("mission_vo_cm_raid_zealot_female_b", mission_vo_cm_raid_zealot_female_b)
