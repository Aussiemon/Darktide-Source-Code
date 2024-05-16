-- chunkname: @dialogues/generated/event_vo_scan_pilot_a.lua

local event_vo_scan_pilot_a = {
	event_scan_more_data = {
		randomize_indexes_n = 0,
		sound_events_n = 10,
		sound_events = {
			"loc_pilot_a__event_scan_more_data_01",
			"loc_pilot_a__event_scan_more_data_02",
			"loc_pilot_a__event_scan_more_data_03",
			"loc_pilot_a__event_scan_more_data_04",
			"loc_pilot_a__event_scan_more_data_05",
			"loc_pilot_a__event_scan_more_data_06",
			"loc_pilot_a__event_scan_more_data_07",
			"loc_pilot_a__event_scan_more_data_08",
			"loc_pilot_a__event_scan_more_data_09",
			"loc_pilot_a__event_scan_more_data_10",
		},
		sound_events_duration = {
			3.5805,
			4.306188,
			3.878229,
			4.707167,
			4.020625,
			4.376229,
			3.962396,
			4.855833,
			3.592167,
			4.710104,
		},
		randomize_indexes = {},
	},
	event_scan_skull_waiting = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_pilot_a__event_scan_skull_waiting_01",
			"loc_pilot_a__event_scan_skull_waiting_02",
			"loc_pilot_a__event_scan_skull_waiting_03",
			"loc_pilot_a__event_scan_skull_waiting_04",
		},
		sound_events_duration = {
			3.606417,
			4.938479,
			3.9065,
			6.595188,
		},
		randomize_indexes = {},
	},
	info_servo_skull_deployed = {
		randomize_indexes_n = 0,
		sound_events_n = 5,
		sound_events = {
			"loc_pilot_a__info_servo_skull_deployed_01",
			"loc_pilot_a__info_servo_skull_deployed_02",
			"loc_pilot_a__info_servo_skull_deployed_03",
			"loc_pilot_a__info_servo_skull_deployed_04",
			"loc_pilot_a__info_servo_skull_deployed_05",
		},
		sound_events_duration = {
			4.532875,
			5.867958,
			3.626438,
			2.781292,
			4.357938,
		},
		randomize_indexes = {},
	},
}

return settings("event_vo_scan_pilot_a", event_vo_scan_pilot_a)
