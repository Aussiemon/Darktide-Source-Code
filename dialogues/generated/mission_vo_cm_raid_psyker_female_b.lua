-- chunkname: @dialogues/generated/mission_vo_cm_raid_psyker_female_b.lua

local mission_vo_cm_raid_psyker_female_b = {
	mission_raid_first_objective_response = {
		randomize_indexes_n = 0,
		sound_events_n = 10,
		sound_events = {
			"loc_psyker_female_b__guidance_starting_area_01",
			"loc_psyker_female_b__guidance_starting_area_02",
			"loc_psyker_female_b__guidance_starting_area_03",
			"loc_psyker_female_b__guidance_starting_area_04",
			"loc_psyker_female_b__guidance_starting_area_05",
			"loc_psyker_female_b__guidance_starting_area_06",
			"loc_psyker_female_b__guidance_starting_area_07",
			"loc_psyker_female_b__guidance_starting_area_08",
			"loc_psyker_female_b__guidance_starting_area_09",
			"loc_psyker_female_b__guidance_starting_area_10",
		},
		sound_events_duration = {
			1.542875,
			1.689292,
			2.206854,
			1.794875,
			1.488542,
			2.45075,
			2.846729,
			2.258458,
			2.091063,
			3.238646,
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
			"loc_psyker_female_b__region_carnival_a_01",
			"loc_psyker_female_b__region_carnival_a_02",
			"loc_psyker_female_b__region_carnival_a_03",
		},
		sound_events_duration = {
			4.597563,
			3.802979,
			4.770542,
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
			"loc_psyker_female_b__mission_raid_trapped_a_01",
			"loc_psyker_female_b__mission_raid_trapped_a_02",
			"loc_psyker_female_b__mission_raid_trapped_a_03",
			"loc_psyker_female_b__mission_raid_trapped_a_04",
		},
		sound_events_duration = {
			1.530208,
			3.088708,
			3.265688,
			3.148688,
		},
		randomize_indexes = {},
	},
	mission_raid_trapped_b = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_psyker_female_b__mission_raid_trapped_b_01",
			"loc_psyker_female_b__mission_raid_trapped_b_02",
			"loc_psyker_female_b__mission_raid_trapped_b_03",
			"loc_psyker_female_b__mission_raid_trapped_b_04",
		},
		sound_events_duration = {
			4.844125,
			3.353146,
			3.677104,
			5.927146,
		},
		randomize_indexes = {},
	},
	mission_raid_trapped_c = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_psyker_female_b__mission_raid_trapped_c_01",
			"loc_psyker_female_b__mission_raid_trapped_c_02",
			"loc_psyker_female_b__mission_raid_trapped_c_03",
			"loc_psyker_female_b__mission_raid_trapped_c_04",
		},
		sound_events_duration = {
			2.776021,
			3.664229,
			1.629917,
			3.649813,
		},
		randomize_indexes = {},
	},
}

return settings("mission_vo_cm_raid_psyker_female_b", mission_vo_cm_raid_psyker_female_b)
