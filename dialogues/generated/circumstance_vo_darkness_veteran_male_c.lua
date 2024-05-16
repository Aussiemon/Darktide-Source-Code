-- chunkname: @dialogues/generated/circumstance_vo_darkness_veteran_male_c.lua

local circumstance_vo_darkness_veteran_male_c = {
	combat_pause_circumstance_unnatural_dark_lurks_a = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1] = "loc_veteran_male_c__asset_unnatural_dark_a_03",
		},
		sound_events_duration = {
			[1] = 3.123635,
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
			"loc_veteran_male_c__power_circumstance_start_b_01",
			"loc_veteran_male_c__power_circumstance_start_b_02",
			"loc_veteran_male_c__power_circumstance_start_b_03",
			"loc_veteran_male_c__power_circumstance_start_b_04",
		},
		sound_events_duration = {
			2.792854,
			2.519792,
			1.742875,
			1.985135,
		},
		sound_event_weights = {
			0.25,
			0.25,
			0.25,
			0.25,
		},
		randomize_indexes = {},
	},
}

return settings("circumstance_vo_darkness_veteran_male_c", circumstance_vo_darkness_veteran_male_c)
