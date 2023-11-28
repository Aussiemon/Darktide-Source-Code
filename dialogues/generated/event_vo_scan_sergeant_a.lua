-- chunkname: @dialogues/generated/event_vo_scan_sergeant_a.lua

local event_vo_scan_sergeant_a = {
	cmd_wandering_skull = {
		randomize_indexes_n = 0,
		sound_events_n = 5,
		sound_events = {
			"loc_sergeant_a__cmd_wandering_skull_01",
			"loc_sergeant_a__cmd_wandering_skull_02",
			"loc_sergeant_a__cmd_wandering_skull_03",
			"loc_sergeant_a__cmd_wandering_skull_04",
			"loc_sergeant_a__cmd_wandering_skull_05"
		},
		sound_events_duration = {
			3.315688,
			3.865896,
			3.360229,
			4.291333,
			3.550792
		},
		sound_event_weights = {
			0.2,
			0.2,
			0.2,
			0.2,
			0.2
		},
		randomize_indexes = {}
	},
	event_scan_all_targets_scanned = {
		randomize_indexes_n = 0,
		sound_events_n = 10,
		sound_events = {
			"loc_sergeant_a__event_scan_all_targets_scanned_a_01",
			"loc_sergeant_a__event_scan_all_targets_scanned_a_02",
			"loc_sergeant_a__event_scan_all_targets_scanned_a_03",
			"loc_sergeant_a__event_scan_all_targets_scanned_a_04",
			"loc_sergeant_a__event_scan_all_targets_scanned_a_05",
			"loc_sergeant_a__event_scan_all_targets_scanned_a_06",
			"loc_sergeant_a__event_scan_all_targets_scanned_a_07",
			"loc_sergeant_a__event_scan_all_targets_scanned_a_08",
			"loc_sergeant_a__event_scan_all_targets_scanned_a_09",
			"loc_sergeant_a__event_scan_all_targets_scanned_a_10"
		},
		sound_events_duration = {
			3.600021,
			4.443167,
			4.73725,
			4.347833,
			3.341083,
			3.685146,
			3.59825,
			4.936313,
			4.886604,
			4.295125
		},
		randomize_indexes = {}
	},
	event_scan_find_targets_first = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_sergeant_a__event_scan_find_targets_first_a_01",
			"loc_sergeant_a__event_scan_find_targets_first_a_02",
			"loc_sergeant_a__event_scan_find_targets_first_a_03",
			"loc_sergeant_a__event_scan_find_targets_first_a_04"
		},
		sound_events_duration = {
			5.112333,
			6.157938,
			4.157063,
			4.648479
		},
		randomize_indexes = {}
	},
	event_scan_find_targets_more = {
		randomize_indexes_n = 0,
		sound_events_n = 10,
		sound_events = {
			"loc_sergeant_a__event_scan_find_targets_more_a_01",
			"loc_sergeant_a__event_scan_find_targets_more_a_02",
			"loc_sergeant_a__event_scan_find_targets_more_a_03",
			"loc_sergeant_a__event_scan_find_targets_more_a_04",
			"loc_sergeant_a__event_scan_find_targets_more_a_05",
			"loc_sergeant_a__event_scan_find_targets_more_a_06",
			"loc_sergeant_a__event_scan_find_targets_more_a_07",
			"loc_sergeant_a__event_scan_find_targets_more_a_08",
			"loc_sergeant_a__event_scan_find_targets_more_a_09",
			"loc_sergeant_a__event_scan_find_targets_more_a_10"
		},
		sound_events_duration = {
			4.625521,
			4.283146,
			3.813833,
			4.320042,
			5.642229,
			5.074167,
			3.0295,
			4.073021,
			6.117771,
			3.793792
		},
		randomize_indexes = {}
	},
	event_scan_more_data = {
		randomize_indexes_n = 0,
		sound_events_n = 10,
		sound_events = {
			"loc_sergeant_a__event_scan_more_data_01",
			"loc_sergeant_a__event_scan_more_data_02",
			"loc_sergeant_a__event_scan_more_data_03",
			"loc_sergeant_a__event_scan_more_data_04",
			"loc_sergeant_a__event_scan_more_data_05",
			"loc_sergeant_a__event_scan_more_data_06",
			"loc_sergeant_a__event_scan_more_data_07",
			"loc_sergeant_a__event_scan_more_data_08",
			"loc_sergeant_a__event_scan_more_data_09",
			"loc_sergeant_a__event_scan_more_data_10"
		},
		sound_events_duration = {
			4.988458,
			3.485417,
			4.918,
			4.481083,
			3.874729,
			4.542896,
			4.508563,
			4.424104,
			3.695,
			4.450188
		},
		randomize_indexes = {}
	},
	event_scan_skull_waiting = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_sergeant_a__event_scan_skull_waiting_01",
			"loc_sergeant_a__event_scan_skull_waiting_02",
			"loc_sergeant_a__event_scan_skull_waiting_03",
			"loc_sergeant_a__event_scan_skull_waiting_04"
		},
		sound_events_duration = {
			4.417521,
			4.603,
			4.968708,
			4.828625
		},
		randomize_indexes = {}
	},
	info_servo_skull_deployed = {
		randomize_indexes_n = 0,
		sound_events_n = 5,
		sound_events = {
			"loc_sergeant_a__info_servo_skull_deployed_01",
			"loc_sergeant_a__info_servo_skull_deployed_02",
			"loc_sergeant_a__info_servo_skull_deployed_03",
			"loc_sergeant_a__info_servo_skull_deployed_04",
			"loc_sergeant_a__info_servo_skull_deployed_05"
		},
		sound_events_duration = {
			2.829854,
			1.942271,
			2.733583,
			3.482167,
			3.798104
		},
		randomize_indexes = {}
	}
}

return settings("event_vo_scan_sergeant_a", event_vo_scan_sergeant_a)
