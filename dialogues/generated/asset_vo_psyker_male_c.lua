local asset_vo_psyker_male_c = {
	asset_foul_smoke = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_psyker_male_c__asset_foul_smoke_01",
			"loc_psyker_male_c__asset_foul_smoke_02",
			"loc_psyker_male_c__asset_foul_smoke_03",
			"loc_psyker_male_c__asset_foul_smoke_04"
		},
		sound_events_duration = {
			6.360344,
			2.605229,
			1.838198,
			2.400354
		},
		randomize_indexes = {}
	},
	asset_grease_pit = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_psyker_male_c__asset_grease_pit_01",
			[2.0] = "loc_psyker_male_c__asset_grease_pit_02"
		},
		sound_events_duration = {
			[1.0] = 1.347375,
			[2.0] = 1.078469
		},
		randomize_indexes = {}
	},
	asset_sigil = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_psyker_male_c__asset_sigil_01",
			[2.0] = "loc_psyker_male_c__asset_sigil_02"
		},
		sound_events_duration = {
			[1.0] = 2.713323,
			[2.0] = 3.986688
		},
		randomize_indexes = {}
	},
	asset_unnatural_dark_a = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_psyker_male_c__asset_unnatural_dark_a_01",
			"loc_psyker_male_c__asset_unnatural_dark_a_02",
			"loc_psyker_male_c__asset_unnatural_dark_a_03",
			"loc_psyker_male_c__asset_unnatural_dark_a_04"
		},
		sound_events_duration = {
			1.215177,
			0.928208,
			2.326292,
			2.075552
		},
		randomize_indexes = {}
	},
	asset_unnatural_dark_b = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_psyker_male_c__asset_unnatural_dark_b_01",
			"loc_psyker_male_c__asset_unnatural_dark_b_02",
			"loc_psyker_male_c__asset_unnatural_dark_b_03",
			"loc_psyker_male_c__asset_unnatural_dark_b_04"
		},
		sound_events_duration = {
			0.766896,
			1.340406,
			1.594281,
			1.421021
		},
		randomize_indexes = {}
	}
}

return settings("asset_vo_psyker_male_c", asset_vo_psyker_male_c)
