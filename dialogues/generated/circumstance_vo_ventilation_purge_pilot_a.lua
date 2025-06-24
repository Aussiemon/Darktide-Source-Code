-- chunkname: @dialogues/generated/circumstance_vo_ventilation_purge_pilot_a.lua

local circumstance_vo_ventilation_purge_pilot_a = {
	vent_circumstance_start_a = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_pilot_a__vent_circumstance_start_a_01",
			"loc_pilot_a__vent_circumstance_start_a_02",
			"loc_pilot_a__vent_circumstance_start_a_03",
			"loc_pilot_a__vent_circumstance_start_a_04",
		},
		sound_events_duration = {
			4.708104,
			5.421438,
			7.050271,
			6.501375,
		},
		randomize_indexes = {},
	},
}

return settings("circumstance_vo_ventilation_purge_pilot_a", circumstance_vo_ventilation_purge_pilot_a)
