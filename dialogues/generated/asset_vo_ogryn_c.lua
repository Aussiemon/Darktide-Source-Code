local asset_vo_ogryn_c = {
	asset_acid_clouds = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_ogryn_c__zone_watertown_acid_clouds_01",
			[2.0] = "loc_ogryn_c__zone_watertown_acid_clouds_02"
		},
		sound_events_duration = {
			[1.0] = 4.061781,
			[2.0] = 5.505531
		},
		sound_event_weights = {
			[1.0] = 0.5,
			[2.0] = 0.5
		},
		randomize_indexes = {}
	},
	asset_foul_smoke = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_ogryn_c__asset_foul_smoke_01",
			"loc_ogryn_c__asset_foul_smoke_02",
			"loc_ogryn_c__asset_foul_smoke_03",
			"loc_ogryn_c__asset_foul_smoke_04"
		},
		sound_events_duration = {
			3.572219,
			5.446063,
			2.202198,
			3.355781
		},
		randomize_indexes = {}
	},
	asset_grease_pit = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_ogryn_c__asset_grease_pit_01",
			[2.0] = "loc_ogryn_c__asset_grease_pit_02"
		},
		sound_events_duration = {
			[1.0] = 3.335875,
			[2.0] = 3.323125
		},
		randomize_indexes = {}
	},
	asset_sigil = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1.0] = "loc_ogryn_c__asset_sigil_01",
			[2.0] = "loc_ogryn_c__asset_sigil_02"
		},
		sound_events_duration = {
			[1.0] = 3.096677,
			[2.0] = 2.026708
		},
		randomize_indexes = {}
	},
	asset_unnatural_dark_a = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_ogryn_c__asset_unnatural_dark_a_01",
			"loc_ogryn_c__asset_unnatural_dark_a_02",
			"loc_ogryn_c__asset_unnatural_dark_a_03",
			"loc_ogryn_c__asset_unnatural_dark_a_04"
		},
		sound_events_duration = {
			1.46626,
			2.228625,
			3.419365,
			3.164604
		},
		randomize_indexes = {}
	},
	asset_unnatural_dark_b = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_ogryn_c__asset_unnatural_dark_b_01",
			"loc_ogryn_c__asset_unnatural_dark_b_02",
			"loc_ogryn_c__asset_unnatural_dark_b_03",
			"loc_ogryn_c__asset_unnatural_dark_b_04"
		},
		sound_events_duration = {
			3.470688,
			4.993167,
			3.040063,
			5.480031
		},
		randomize_indexes = {}
	}
}

return settings("asset_vo_ogryn_c", asset_vo_ogryn_c)
