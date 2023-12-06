local mission_vo_cm_raid_zealot_male_a = {
	mission_raid_first_objective_response = {
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
			"loc_zealot_male_a__guidance_starting_area_10"
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
			2.869521
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
			"loc_zealot_male_a__region_carnival_a_01",
			"loc_zealot_male_a__region_carnival_a_02",
			"loc_zealot_male_a__region_carnival_a_03"
		},
		sound_events_duration = {
			4.421708,
			4.670771,
			3.697646
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
			"loc_zealot_male_a__mission_raid_trapped_a_01",
			"loc_zealot_male_a__mission_raid_trapped_a_02",
			"loc_zealot_male_a__mission_raid_trapped_a_03",
			"loc_zealot_male_a__mission_raid_trapped_a_04"
		},
		sound_events_duration = {
			1.494146,
			2.399354,
			1.884542,
			1.211625
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
			"loc_zealot_male_a__mission_raid_trapped_b_01",
			"loc_zealot_male_a__mission_raid_trapped_b_02",
			"loc_zealot_male_a__mission_raid_trapped_b_03",
			"loc_zealot_male_a__mission_raid_trapped_b_04"
		},
		sound_events_duration = {
			4.435417,
			4.193458,
			2.799,
			3.577188
		},
		sound_event_weights = {
			0.25,
			0.25,
			0.25,
			0.25
		},
		randomize_indexes = {}
	},
	mission_raid_trapped_c = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_zealot_male_a__mission_raid_trapped_c_01",
			"loc_zealot_male_a__mission_raid_trapped_c_02",
			"loc_zealot_male_a__mission_raid_trapped_c_03",
			"loc_zealot_male_a__mission_raid_trapped_c_04"
		},
		sound_events_duration = {
			3.019833,
			2.738271,
			3.704708,
			3.127292
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

return settings("mission_vo_cm_raid_zealot_male_a", mission_vo_cm_raid_zealot_male_a)
