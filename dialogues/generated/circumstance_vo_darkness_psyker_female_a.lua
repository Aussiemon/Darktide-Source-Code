-- chunkname: @dialogues/generated/circumstance_vo_darkness_psyker_female_a.lua

local circumstance_vo_darkness_psyker_female_a = {
	combat_pause_circumstance_unnatural_dark_lights_b = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_psyker_female_a__asset_unnatural_dark_b_02",
			[2] = "loc_psyker_female_a__asset_unnatural_dark_b_03",
		},
		sound_events_duration = {
			[1] = 3.266396,
			[2] = 2.714042,
		},
		sound_event_weights = {
			[1] = 0.5,
			[2] = 0.5,
		},
		randomize_indexes = {},
	},
	combat_pause_circumstance_unnatural_dark_lurks_b = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_psyker_female_a__asset_unnatural_dark_b_02",
			[2] = "loc_psyker_female_a__asset_unnatural_dark_b_03",
		},
		sound_events_duration = {
			[1] = 3.266396,
			[2] = 2.714042,
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
			"loc_psyker_female_a__power_circumstance_start_b_01",
			"loc_psyker_female_a__power_circumstance_start_b_02",
			"loc_psyker_female_a__power_circumstance_start_b_03",
			"loc_psyker_female_a__power_circumstance_start_b_04",
		},
		sound_events_duration = {
			3.133417,
			5.136042,
			4.278208,
			4.052521,
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

return settings("circumstance_vo_darkness_psyker_female_a", circumstance_vo_darkness_psyker_female_a)
