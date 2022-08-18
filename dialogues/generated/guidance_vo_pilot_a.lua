local guidance_vo_pilot_a = {
	info_asset_cult_breaking_wheel = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_pilot_a__asset_cult_breaking_wheel_01",
			"loc_pilot_a__asset_cult_breaking_wheel_02",
			"loc_pilot_a__asset_cult_breaking_wheel_03",
			"loc_pilot_a__asset_cult_breaking_wheel_04"
		},
		sound_events_duration = {
			6.167376,
			5.585835,
			6.669875,
			4.6475
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
			"loc_pilot_a__asset_nurgle_growth_01",
			"loc_pilot_a__asset_nurgle_growth_02",
			"loc_pilot_a__asset_nurgle_growth_03",
			"loc_pilot_a__asset_nurgle_growth_04"
		},
		sound_events_duration = {
			3.426,
			3.753229,
			5.721021,
			5.339396
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

return settings("guidance_vo_pilot_a", guidance_vo_pilot_a)
