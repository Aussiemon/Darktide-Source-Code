-- chunkname: @dialogues/generated/circumstance_vo_darkness_veteran_male_a.lua

local circumstance_vo_darkness_veteran_male_a = {
	combat_pause_circumstance_unnatural_dark_lights_a = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_veteran_male_a__asset_unnatural_dark_a_01",
			[2] = "loc_veteran_male_a__asset_unnatural_dark_a_03",
		},
		sound_events_duration = {
			[1] = 2.726938,
			[2] = 2.126063,
		},
		sound_event_weights = {
			[1] = 0.5,
			[2] = 0.5,
		},
		randomize_indexes = {},
	},
	combat_pause_circumstance_unnatural_dark_lights_b = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_veteran_male_a__asset_unnatural_dark_b_01",
			"loc_veteran_male_a__asset_unnatural_dark_b_03",
			"loc_veteran_male_a__asset_unnatural_dark_b_04",
		},
		sound_events_duration = {
			3.038063,
			3.403417,
			1.572333,
		},
		sound_event_weights = {
			0.3333333,
			0.3333333,
			0.3333333,
		},
		randomize_indexes = {},
	},
	combat_pause_circumstance_unnatural_dark_lurks_b = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1] = "loc_veteran_male_a__asset_unnatural_dark_b_04",
		},
		sound_events_duration = {
			[1] = 1.572333,
		},
		sound_event_weights = {
			[1] = 1,
		},
		randomize_indexes = {},
	},
	power_circumstance_start_b = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_veteran_male_a__power_circumstance_start_b_01",
			"loc_veteran_male_a__power_circumstance_start_b_02",
			"loc_veteran_male_a__power_circumstance_start_b_03",
			"loc_veteran_male_a__power_circumstance_start_b_04",
		},
		sound_events_duration = {
			2.540646,
			4.132917,
			2.480313,
			4.000604,
		},
		randomize_indexes = {},
	},
}

return settings("circumstance_vo_darkness_veteran_male_a", circumstance_vo_darkness_veteran_male_a)
