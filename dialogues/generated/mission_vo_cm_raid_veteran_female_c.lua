-- chunkname: @dialogues/generated/mission_vo_cm_raid_veteran_female_c.lua

local mission_vo_cm_raid_veteran_female_c = {
	mission_raid_first_objective_response = {
		randomize_indexes_n = 0,
		sound_events_n = 10,
		sound_events = {
			"loc_veteran_female_c__guidance_starting_area_01",
			"loc_veteran_female_c__guidance_starting_area_02",
			"loc_veteran_female_c__guidance_starting_area_03",
			"loc_veteran_female_c__guidance_starting_area_04",
			"loc_veteran_female_c__guidance_starting_area_05",
			"loc_veteran_female_c__guidance_starting_area_06",
			"loc_veteran_female_c__guidance_starting_area_07",
			"loc_veteran_female_c__guidance_starting_area_08",
			"loc_veteran_female_c__guidance_starting_area_09",
			"loc_veteran_female_c__guidance_starting_area_10",
		},
		sound_events_duration = {
			1.781354,
			2.374854,
			2.028573,
			2.545385,
			4.008042,
			2.618948,
			2.877021,
			2.45276,
			2.604781,
			4.225719,
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
	mission_raid_region_carnival = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_veteran_female_c__region_carnival_a_01",
			"loc_veteran_female_c__region_carnival_a_02",
			"loc_veteran_female_c__region_carnival_a_03",
		},
		sound_events_duration = {
			2.74175,
			4.143667,
			2.427771,
		},
		sound_event_weights = {
			0.3333333,
			0.3333333,
			0.3333333,
		},
		randomize_indexes = {},
	},
	mission_raid_trapped_a = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_veteran_female_c__mission_raid_trapped_a_01",
			"loc_veteran_female_c__mission_raid_trapped_a_02",
			"loc_veteran_female_c__mission_raid_trapped_a_03",
			"loc_veteran_female_c__mission_raid_trapped_a_04",
		},
		sound_events_duration = {
			1.265958,
			2.00001,
			1.838823,
			2.381438,
		},
		randomize_indexes = {},
	},
	mission_raid_trapped_b = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_veteran_female_c__mission_raid_trapped_b_01",
			"loc_veteran_female_c__mission_raid_trapped_b_02",
			"loc_veteran_female_c__mission_raid_trapped_b_03",
			"loc_veteran_female_c__mission_raid_trapped_b_04",
		},
		sound_events_duration = {
			1.246625,
			2.108052,
			1.33576,
			1.008979,
		},
		randomize_indexes = {},
	},
	mission_raid_trapped_c = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_veteran_female_c__mission_raid_trapped_c_01",
			"loc_veteran_female_c__mission_raid_trapped_c_02",
			"loc_veteran_female_c__mission_raid_trapped_c_03",
			"loc_veteran_female_c__mission_raid_trapped_c_04",
		},
		sound_events_duration = {
			2.25526,
			2.584125,
			2.31174,
			2.304365,
		},
		randomize_indexes = {},
	},
}

return settings("mission_vo_cm_raid_veteran_female_c", mission_vo_cm_raid_veteran_female_c)
