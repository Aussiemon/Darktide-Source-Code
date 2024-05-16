-- chunkname: @dialogues/generated/mission_vo_cm_raid_veteran_female_b.lua

local mission_vo_cm_raid_veteran_female_b = {
	mission_raid_first_objective_response = {
		randomize_indexes_n = 0,
		sound_events_n = 10,
		sound_events = {
			"loc_veteran_female_b__guidance_starting_area_01",
			"loc_veteran_female_b__guidance_starting_area_02",
			"loc_veteran_female_b__guidance_starting_area_03",
			"loc_veteran_female_b__guidance_starting_area_04",
			"loc_veteran_female_b__guidance_starting_area_05",
			"loc_veteran_female_b__guidance_starting_area_06",
			"loc_veteran_female_b__guidance_starting_area_07",
			"loc_veteran_female_b__guidance_starting_area_08",
			"loc_veteran_female_b__guidance_starting_area_09",
			"loc_veteran_female_b__guidance_starting_area_10",
		},
		sound_events_duration = {
			2.784021,
			2.841854,
			3.674688,
			1.663688,
			1.961104,
			2.023521,
			2.891542,
			2.573583,
			3.490271,
			2.443458,
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
			"loc_veteran_female_b__region_carnival_a_01",
			"loc_veteran_female_b__region_carnival_a_02",
			"loc_veteran_female_b__region_carnival_a_03",
		},
		sound_events_duration = {
			3.8745,
			1.988208,
			3.406063,
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
			"loc_veteran_female_b__mission_raid_trapped_a_01",
			"loc_veteran_female_b__mission_raid_trapped_a_02",
			"loc_veteran_female_b__mission_raid_trapped_a_03",
			"loc_veteran_female_b__mission_raid_trapped_a_04",
		},
		sound_events_duration = {
			1.607125,
			2.621646,
			2.742875,
			1.652167,
		},
		randomize_indexes = {},
	},
	mission_raid_trapped_b = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_veteran_female_b__mission_raid_trapped_b_01",
			"loc_veteran_female_b__mission_raid_trapped_b_02",
			"loc_veteran_female_b__mission_raid_trapped_b_03",
			"loc_veteran_female_b__mission_raid_trapped_b_04",
		},
		sound_events_duration = {
			2.074167,
			1.228125,
			2.130938,
			2.041875,
		},
		randomize_indexes = {},
	},
	mission_raid_trapped_c = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_veteran_female_b__mission_raid_trapped_c_01",
			"loc_veteran_female_b__mission_raid_trapped_c_02",
			"loc_veteran_female_b__mission_raid_trapped_c_03",
			"loc_veteran_female_b__mission_raid_trapped_c_04",
		},
		sound_events_duration = {
			2.740771,
			2.213625,
			2.789313,
			2.052625,
		},
		randomize_indexes = {},
	},
}

return settings("mission_vo_cm_raid_veteran_female_b", mission_vo_cm_raid_veteran_female_b)
