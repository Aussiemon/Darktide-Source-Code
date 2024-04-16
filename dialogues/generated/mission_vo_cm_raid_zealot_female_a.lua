local mission_vo_cm_raid_zealot_female_a = {
	mission_raid_first_objective_response = {
		randomize_indexes_n = 0,
		sound_events_n = 10,
		sound_events = {
			"loc_zealot_female_a__guidance_starting_area_01",
			"loc_zealot_female_a__guidance_starting_area_02",
			"loc_zealot_female_a__guidance_starting_area_03",
			"loc_zealot_female_a__guidance_starting_area_04",
			"loc_zealot_female_a__guidance_starting_area_05",
			"loc_zealot_female_a__guidance_starting_area_06",
			"loc_zealot_female_a__guidance_starting_area_07",
			"loc_zealot_female_a__guidance_starting_area_08",
			"loc_zealot_female_a__guidance_starting_area_09",
			"loc_zealot_female_a__guidance_starting_area_10"
		},
		sound_events_duration = {
			1.147604,
			2.041,
			1.56625,
			1.863583,
			2.258104,
			2.178771,
			1.645542,
			3.153792,
			3.300042,
			2.505625
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
			"loc_zealot_female_a__region_carnival_a_01",
			"loc_zealot_female_a__region_carnival_a_02",
			"loc_zealot_female_a__region_carnival_a_03"
		},
		sound_events_duration = {
			4.500813,
			3.714167,
			3.260729
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
			"loc_zealot_female_a__mission_raid_trapped_a_01",
			"loc_zealot_female_a__mission_raid_trapped_a_02",
			"loc_zealot_female_a__mission_raid_trapped_a_03",
			"loc_zealot_female_a__mission_raid_trapped_a_04"
		},
		sound_events_duration = {
			1.954729,
			2.198813,
			1.635771,
			1.003667
		},
		randomize_indexes = {}
	},
	mission_raid_trapped_b = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_zealot_female_a__mission_raid_trapped_b_01",
			"loc_zealot_female_a__mission_raid_trapped_b_02",
			"loc_zealot_female_a__mission_raid_trapped_b_03",
			"loc_zealot_female_a__mission_raid_trapped_b_04"
		},
		sound_events_duration = {
			3.981063,
			3.596625,
			2.607875,
			2.655479
		},
		randomize_indexes = {}
	},
	mission_raid_trapped_c = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_zealot_female_a__mission_raid_trapped_c_01",
			"loc_zealot_female_a__mission_raid_trapped_c_02",
			"loc_zealot_female_a__mission_raid_trapped_c_03",
			"loc_zealot_female_a__mission_raid_trapped_c_04"
		},
		sound_events_duration = {
			2.358,
			2.901896,
			3.131708,
			2.373104
		},
		randomize_indexes = {}
	}
}

return settings("mission_vo_cm_raid_zealot_female_a", mission_vo_cm_raid_zealot_female_a)
