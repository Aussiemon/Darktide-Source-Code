-- chunkname: @dialogues/generated/circumstance_vo_darkness_veteran_female_a.lua

local circumstance_vo_darkness_veteran_female_a = {
	combat_pause_circumstance_unnatural_dark_lights_a = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_veteran_female_a__asset_unnatural_dark_a_01",
			[2] = "loc_veteran_female_a__asset_unnatural_dark_a_03",
		},
		sound_events_duration = {
			[1] = 1.658188,
			[2] = 1.827083,
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
			"loc_veteran_female_a__asset_unnatural_dark_b_01",
			"loc_veteran_female_a__asset_unnatural_dark_b_03",
			"loc_veteran_female_a__asset_unnatural_dark_b_04",
		},
		sound_events_duration = {
			2.632938,
			2.693625,
			1.908958,
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
			[1] = "loc_veteran_female_a__asset_unnatural_dark_b_04",
		},
		sound_events_duration = {
			[1] = 1.908958,
		},
		sound_event_weights = {
			[1] = 1,
		},
		randomize_indexes = {},
	},
}

return settings("circumstance_vo_darkness_veteran_female_a", circumstance_vo_darkness_veteran_female_a)
