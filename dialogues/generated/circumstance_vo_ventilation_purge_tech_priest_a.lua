local circumstance_vo_ventilation_purge_tech_priest_a = {
	vent_circumstance_start_a = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_tech_priest_a__vent_circumstance_start_a_01",
			"loc_tech_priest_a__vent_circumstance_start_a_02",
			"loc_tech_priest_a__vent_circumstance_start_a_03",
			"loc_tech_priest_a__vent_circumstance_start_a_04"
		},
		sound_events_duration = {
			10.13946,
			7.937812,
			10.14238,
			8.824271
		},
		randomize_indexes = {}
	},
	vent_circumstance_start_b = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_tech_priest_a__vent_circumstance_start_b_01",
			"loc_tech_priest_a__vent_circumstance_start_b_02",
			"loc_tech_priest_a__vent_circumstance_start_b_03",
			"loc_tech_priest_a__vent_circumstance_start_b_04"
		},
		sound_events_duration = {
			6.116542,
			6.273542,
			6.219542,
			5.866479
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

return settings("circumstance_vo_ventilation_purge_tech_priest_a", circumstance_vo_ventilation_purge_tech_priest_a)
