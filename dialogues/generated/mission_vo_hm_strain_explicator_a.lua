-- chunkname: @dialogues/generated/mission_vo_hm_strain_explicator_a.lua

local mission_vo_hm_strain_explicator_a = {
	event_demolition_first_corruptor_destroyed_strain_b = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_explicator_a__event_demolition_last_corruptor_01",
			"loc_explicator_a__event_demolition_last_corruptor_02",
			"loc_explicator_a__event_demolition_last_corruptor_03",
			"loc_explicator_a__event_demolition_last_corruptor_04",
		},
		sound_events_duration = {
			3.450375,
			2.914479,
			4.606333,
			3.969813,
		},
		sound_event_weights = {
			0.25,
			0.25,
			0.25,
			0.25,
		},
		randomize_indexes = {},
	},
	info_get_out_strain = {
		randomize_indexes_n = 0,
		sound_events_n = 10,
		sound_events = {
			"loc_explicator_a__info_get_out_01",
			"loc_explicator_a__info_get_out_02",
			"loc_explicator_a__info_get_out_03",
			"loc_explicator_a__info_get_out_04",
			"loc_explicator_a__info_get_out_05",
			"loc_explicator_a__info_get_out_06",
			"loc_explicator_a__info_get_out_07",
			"loc_explicator_a__info_get_out_08",
			"loc_explicator_a__info_get_out_09",
			"loc_explicator_a__info_get_out_10",
		},
		sound_events_duration = {
			1.393354,
			2.655333,
			4.209417,
			3.388458,
			3.478438,
			2.274604,
			3.978875,
			3.242146,
			2.36175,
			3.263604,
		},
		sound_event_weights = {
			0.1,
			0.1,
			0.1,
			0.1,
			0.1,
			0.1,
			0.1,
			0.1,
			0.1,
			0.1,
		},
		randomize_indexes = {},
	},
}

return settings("mission_vo_hm_strain_explicator_a", mission_vo_hm_strain_explicator_a)
