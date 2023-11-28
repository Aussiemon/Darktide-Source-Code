-- chunkname: @dialogues/generated/event_vo_fortification_tech_priest_a.lua

local event_vo_fortification_tech_priest_a = {
	event_fortification_disable_the_skyfire = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_tech_priest_a__event_fortification_disable_the_skyfire_01",
			"loc_tech_priest_a__event_fortification_disable_the_skyfire_02",
			"loc_tech_priest_a__event_fortification_disable_the_skyfire_03",
			"loc_tech_priest_a__event_fortification_disable_the_skyfire_04"
		},
		sound_events_duration = {
			5.241729,
			4.960021,
			4.909083,
			5.684063
		},
		randomize_indexes = {}
	},
	event_fortification_fortification_survive = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_tech_priest_a__event_fortification_fortification_survive_01",
			"loc_tech_priest_a__event_fortification_fortification_survive_02",
			"loc_tech_priest_a__event_fortification_fortification_survive_03",
			"loc_tech_priest_a__event_fortification_fortification_survive_04"
		},
		sound_events_duration = {
			6.4685,
			7.591458,
			8.208271,
			6.209292
		},
		randomize_indexes = {}
	},
	event_fortification_kill_stragglers = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_tech_priest_a__info_event_demolition_corruptors_almost_done_03",
			[2] = "loc_tech_priest_a__info_event_demolition_corruptors_almost_done_04"
		},
		sound_events_duration = {
			[1] = 5.927896,
			[2] = 4.934208
		},
		sound_event_weights = {
			[1] = 0.5,
			[2] = 0.5
		},
		randomize_indexes = {}
	},
	event_fortification_power_up_gate = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_tech_priest_a__event_fortification_power_up_gate_01",
			"loc_tech_priest_a__event_fortification_power_up_gate_02",
			"loc_tech_priest_a__event_fortification_power_up_gate_03",
			"loc_tech_priest_a__event_fortification_power_up_gate_04"
		},
		sound_events_duration = {
			4.988208,
			5.501354,
			6.29925,
			5.719479
		},
		randomize_indexes = {}
	},
	event_fortification_set_landing_beacon = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_tech_priest_a__event_fortification_set_landing_beacon_01",
			"loc_tech_priest_a__event_fortification_set_landing_beacon_02",
			"loc_tech_priest_a__event_fortification_set_landing_beacon_03",
			"loc_tech_priest_a__event_fortification_set_landing_beacon_04"
		},
		sound_events_duration = {
			5.447396,
			7.109854,
			5.670833,
			6.751688
		},
		randomize_indexes = {}
	}
}

return settings("event_vo_fortification_tech_priest_a", event_vo_fortification_tech_priest_a)
