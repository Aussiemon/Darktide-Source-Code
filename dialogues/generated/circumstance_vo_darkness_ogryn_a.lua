-- chunkname: @dialogues/generated/circumstance_vo_darkness_ogryn_a.lua

local circumstance_vo_darkness_ogryn_a = {
	combat_pause_circumstance_unnatural_dark_lights_a = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1] = "loc_ogryn_a__asset_unnatural_dark_a_02",
		},
		sound_events_duration = {
			[1] = 1.801677,
		},
		sound_event_weights = {
			[1] = 1,
		},
		randomize_indexes = {},
	},
	combat_pause_circumstance_unnatural_dark_lights_b = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_ogryn_a__asset_unnatural_dark_b_01",
			"loc_ogryn_a__asset_unnatural_dark_b_02",
			"loc_ogryn_a__asset_unnatural_dark_b_03",
			"loc_ogryn_a__asset_unnatural_dark_b_04",
		},
		sound_events_duration = {
			2.297677,
			2.646979,
			2.924458,
			3.636021,
		},
		sound_event_weights = {
			0.25,
			0.25,
			0.25,
			0.25,
		},
		randomize_indexes = {},
	},
	combat_pause_circumstance_unnatural_dark_lurks_b = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1] = "loc_ogryn_a__asset_unnatural_dark_b_04",
		},
		sound_events_duration = {
			[1] = 3.636021,
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
			"loc_ogryn_a__power_circumstance_start_b_01",
			"loc_ogryn_a__power_circumstance_start_b_02",
			"loc_ogryn_a__power_circumstance_start_b_03",
			"loc_ogryn_a__power_circumstance_start_b_04",
		},
		sound_events_duration = {
			4.323313,
			5.077406,
			3.602052,
			3.952573,
		},
		randomize_indexes = {},
	},
}

return settings("circumstance_vo_darkness_ogryn_a", circumstance_vo_darkness_ogryn_a)
