-- chunkname: @dialogues/generated/circumstance_vo_darkness_psyker_male_b.lua

local circumstance_vo_darkness_psyker_male_b = {
	combat_pause_circumstance_unnatural_dark_lights_a = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_psyker_male_b__asset_unnatural_dark_a_03",
			[2] = "loc_psyker_male_b__asset_unnatural_dark_a_04",
		},
		sound_events_duration = {
			[1] = 3.219167,
			[2] = 3.220646,
		},
		sound_event_weights = {
			[1] = 0.5,
			[2] = 0.5,
		},
		randomize_indexes = {},
	},
	combat_pause_circumstance_unnatural_dark_lights_b = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_psyker_male_b__asset_unnatural_dark_b_01",
			"loc_psyker_male_b__asset_unnatural_dark_b_02",
			"loc_psyker_male_b__asset_unnatural_dark_b_03",
			"loc_psyker_male_b__asset_unnatural_dark_b_04",
		},
		sound_events_duration = {
			2.764229,
			3.376729,
			4.892813,
			5.903563,
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
		sound_events_n = 3,
		sound_events = {
			"loc_psyker_male_b__asset_unnatural_dark_b_02",
			"loc_psyker_male_b__asset_unnatural_dark_b_03",
			"loc_psyker_male_b__asset_unnatural_dark_b_04",
		},
		sound_events_duration = {
			3.376729,
			4.892813,
			5.903563,
		},
		sound_event_weights = {
			0.3333333,
			0.3333333,
			0.3333333,
		},
		randomize_indexes = {},
	},
	power_circumstance_start_b = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_psyker_male_b__power_circumstance_start_b_01",
			"loc_psyker_male_b__power_circumstance_start_b_02",
			"loc_psyker_male_b__power_circumstance_start_b_03",
			"loc_psyker_male_b__power_circumstance_start_b_04",
		},
		sound_events_duration = {
			3.000021,
			2.851479,
			3.340292,
			4.135625,
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

return settings("circumstance_vo_darkness_psyker_male_b", circumstance_vo_darkness_psyker_male_b)
