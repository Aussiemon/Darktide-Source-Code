-- chunkname: @dialogues/generated/circumstance_vo_darkness_ogryn_b.lua

local circumstance_vo_darkness_ogryn_b = {
	combat_pause_circumstance_unnatural_dark_lights_b = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_ogryn_b__asset_unnatural_dark_b_02",
			"loc_ogryn_b__asset_unnatural_dark_b_03",
			"loc_ogryn_b__asset_unnatural_dark_b_04",
		},
		sound_events_duration = {
			2.870938,
			2.820344,
			2.042885,
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
			[1] = "loc_ogryn_b__asset_unnatural_dark_b_02",
			[2] = "loc_ogryn_b__asset_unnatural_dark_b_04",
		},
		sound_events_duration = {
			[1] = 2.870938,
			[2] = 2.042885,
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
			"loc_ogryn_b__power_circumstance_start_b_01",
			"loc_ogryn_b__power_circumstance_start_b_02",
			"loc_ogryn_b__power_circumstance_start_b_03",
			"loc_ogryn_b__power_circumstance_start_b_04",
		},
		sound_events_duration = {
			3.44276,
			3.686781,
			6.020031,
			4.585115,
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

return settings("circumstance_vo_darkness_ogryn_b", circumstance_vo_darkness_ogryn_b)
