-- chunkname: @dialogues/generated/mission_vo_cm_raid_zealot_male_b.lua

local mission_vo_cm_raid_zealot_male_b = {
	mission_raid_first_objective_response = {
		randomize_indexes_n = 0,
		sound_events_n = 10,
		sound_events = {
			"loc_zealot_male_b__guidance_starting_area_01",
			"loc_zealot_male_b__guidance_starting_area_02",
			"loc_zealot_male_b__guidance_starting_area_03",
			"loc_zealot_male_b__guidance_starting_area_04",
			"loc_zealot_male_b__guidance_starting_area_05",
			"loc_zealot_male_b__guidance_starting_area_06",
			"loc_zealot_male_b__guidance_starting_area_07",
			"loc_zealot_male_b__guidance_starting_area_08",
			"loc_zealot_male_b__guidance_starting_area_09",
			"loc_zealot_male_b__guidance_starting_area_10",
		},
		sound_events_duration = {
			1.607604,
			1.4465,
			3.353021,
			3.354813,
			4.893125,
			4.905875,
			3.656563,
			4.080854,
			4.515563,
			3.091354,
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
			"loc_zealot_male_b__region_carnival_a_01",
			"loc_zealot_male_b__region_carnival_a_02",
			"loc_zealot_male_b__region_carnival_a_03",
		},
		sound_events_duration = {
			3.069438,
			7.010875,
			4.752646,
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
			"loc_zealot_male_b__mission_raid_trapped_a_01",
			"loc_zealot_male_b__mission_raid_trapped_a_02",
			"loc_zealot_male_b__mission_raid_trapped_a_03",
			"loc_zealot_male_b__mission_raid_trapped_a_04",
		},
		sound_events_duration = {
			0.760896,
			1.329813,
			1.222958,
			1.960167,
		},
		randomize_indexes = {},
	},
	mission_raid_trapped_b = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_zealot_male_b__mission_raid_trapped_b_01",
			"loc_zealot_male_b__mission_raid_trapped_b_02",
			"loc_zealot_male_b__mission_raid_trapped_b_03",
			"loc_zealot_male_b__mission_raid_trapped_b_04",
		},
		sound_events_duration = {
			1.419708,
			2.948708,
			2.442958,
			3.269792,
		},
		randomize_indexes = {},
	},
	mission_raid_trapped_c = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_zealot_male_b__mission_raid_trapped_c_03",
			[2] = "loc_zealot_male_b__mission_raid_trapped_c_04",
		},
		sound_events_duration = {
			[1] = 1.460688,
			[2] = 2.203271,
		},
		randomize_indexes = {},
	},
}

return settings("mission_vo_cm_raid_zealot_male_b", mission_vo_cm_raid_zealot_male_b)
