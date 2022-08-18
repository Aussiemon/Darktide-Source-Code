local guidance_vo_sergeant_a = {
	info_asset_cult_breaking_wheel = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_sergeant_a__asset_cult_breaking_wheel_01",
			"loc_sergeant_a__asset_cult_breaking_wheel_02",
			"loc_sergeant_a__asset_cult_breaking_wheel_03",
			"loc_sergeant_a__asset_cult_breaking_wheel_04"
		},
		sound_events_duration = {
			6.667167,
			5.5565,
			5.825376,
			6.408855
		},
		sound_event_weights = {
			0.25,
			0.25,
			0.25,
			0.25
		},
		randomize_indexes = {}
	},
	info_asset_nurgle_growth = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_sergeant_a__asset_nurgle_growth_01",
			"loc_sergeant_a__asset_nurgle_growth_02",
			"loc_sergeant_a__asset_nurgle_growth_03",
			"loc_sergeant_a__asset_nurgle_growth_04"
		},
		sound_events_duration = {
			8.447042,
			5.964813,
			5.754958,
			4.521771
		},
		sound_event_weights = {
			0.25,
			0.25,
			0.25,
			0.25
		},
		randomize_indexes = {}
	}
}

return settings("guidance_vo_sergeant_a", guidance_vo_sergeant_a)
