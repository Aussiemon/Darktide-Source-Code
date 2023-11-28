-- chunkname: @dialogues/generated/circumstance_vo_ventilation_purge_explicator_a.lua

local circumstance_vo_ventilation_purge_explicator_a = {
	vent_circumstance_start_a = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_explicator_a__vent_circumstance_start_a_01",
			"loc_explicator_a__vent_circumstance_start_a_02",
			"loc_explicator_a__vent_circumstance_start_a_03",
			"loc_explicator_a__vent_circumstance_start_a_04"
		},
		sound_events_duration = {
			8.478374,
			6.874438,
			5.849333,
			6.208167
		},
		randomize_indexes = {}
	},
	vent_circumstance_start_b = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_explicator_a__vent_circumstance_start_b_01",
			"loc_explicator_a__vent_circumstance_start_b_02",
			"loc_explicator_a__vent_circumstance_start_b_03",
			"loc_explicator_a__vent_circumstance_start_b_04"
		},
		sound_events_duration = {
			5.099,
			5.110542,
			4.927292,
			6.201313
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

return settings("circumstance_vo_ventilation_purge_explicator_a", circumstance_vo_ventilation_purge_explicator_a)
