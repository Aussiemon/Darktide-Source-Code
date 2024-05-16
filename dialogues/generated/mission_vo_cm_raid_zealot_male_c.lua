-- chunkname: @dialogues/generated/mission_vo_cm_raid_zealot_male_c.lua

local mission_vo_cm_raid_zealot_male_c = {
	mission_raid_first_objective_response = {
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
	mission_raid_region_carnival = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_zealot_male_c__region_carnival_a_01",
			"loc_zealot_male_c__region_carnival_a_02",
			"loc_zealot_male_c__region_carnival_a_03",
		},
		sound_events_duration = {
			5.4035,
			5.808104,
			7.725198,
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
			"loc_zealot_male_c__mission_raid_trapped_a_01",
			"loc_zealot_male_c__mission_raid_trapped_a_02",
			"loc_zealot_male_c__mission_raid_trapped_a_03",
			"loc_zealot_male_c__mission_raid_trapped_a_04",
		},
		sound_events_duration = {
			1.507917,
			1.943094,
			2.287177,
			1.48025,
		},
		randomize_indexes = {},
	},
	mission_raid_trapped_b = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_zealot_male_c__mission_raid_trapped_b_01",
			"loc_zealot_male_c__mission_raid_trapped_b_02",
			"loc_zealot_male_c__mission_raid_trapped_b_03",
			"loc_zealot_male_c__mission_raid_trapped_b_04",
		},
		sound_events_duration = {
			2.267583,
			3.005708,
			1.7635,
			2.63125,
		},
		randomize_indexes = {},
	},
	mission_raid_trapped_c = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_zealot_male_c__mission_raid_trapped_c_01",
			"loc_zealot_male_c__mission_raid_trapped_c_02",
			"loc_zealot_male_c__mission_raid_trapped_c_03",
			"loc_zealot_male_c__mission_raid_trapped_c_04",
		},
		sound_events_duration = {
			2.145271,
			2.697042,
			2.909573,
			3.13725,
		},
		randomize_indexes = {},
	},
}

return settings("mission_vo_cm_raid_zealot_male_c", mission_vo_cm_raid_zealot_male_c)
