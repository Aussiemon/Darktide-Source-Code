-- chunkname: @dialogues/generated/circumstance_vo_darkness_veteran_female_b.lua

local circumstance_vo_darkness_veteran_female_b = {
	combat_pause_circumstance_unnatural_dark_lights_b = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_veteran_female_b__asset_unnatural_dark_b_01",
			"loc_veteran_female_b__asset_unnatural_dark_b_02",
			"loc_veteran_female_b__asset_unnatural_dark_b_04",
		},
		sound_events_duration = {
			2.525896,
			1.652917,
			1.556396,
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
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_veteran_female_b__asset_unnatural_dark_b_01",
			[2] = "loc_veteran_female_b__asset_unnatural_dark_b_04",
		},
		sound_events_duration = {
			[1] = 2.525896,
			[2] = 1.556396,
		},
		sound_event_weights = {
			[1] = 0.5,
			[2] = 0.5,
		},
		randomize_indexes = {},
	},
	power_circumstance_start_b = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_veteran_female_b__power_circumstance_start_b_01",
			"loc_veteran_female_b__power_circumstance_start_b_02",
			"loc_veteran_female_b__power_circumstance_start_b_03",
			"loc_veteran_female_b__power_circumstance_start_b_04",
		},
		sound_events_duration = {
			3.6885,
			3.31325,
			3.002833,
			4.174958,
		},
		randomize_indexes = {},
	},
}

return settings("circumstance_vo_darkness_veteran_female_b", circumstance_vo_darkness_veteran_female_b)
