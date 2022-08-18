local mission_giver_vo_contract_vendor_a = {
	cmd_load_pneumatic = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_contract_vendor_a__cmd_load_pneumatic_01",
			"loc_contract_vendor_a__cmd_load_pneumatic_02",
			"loc_contract_vendor_a__cmd_load_pneumatic_03",
			"loc_contract_vendor_a__cmd_load_pneumatic_04"
		},
		sound_events_duration = {
			3.35725,
			3.501105,
			3.985605,
			4.167292
		},
		randomize_indexes = {}
	},
	cmd_mission_scavenge_hacking_event_start = {
		randomize_indexes_n = 0,
		sound_events_n = 8,
		sound_events = {
			"loc_contract_vendor_a__cmd_mission_scavenge_hacking_event_end_01",
			"loc_contract_vendor_a__cmd_mission_scavenge_hacking_event_end_02",
			"loc_contract_vendor_a__cmd_mission_scavenge_hacking_event_end_03",
			"loc_contract_vendor_a__cmd_mission_scavenge_hacking_event_end_04",
			"loc_contract_vendor_a__cmd_mission_scavenge_hacking_event_start_01",
			"loc_contract_vendor_a__cmd_mission_scavenge_hacking_event_start_02",
			"loc_contract_vendor_a__cmd_mission_scavenge_hacking_event_start_03",
			"loc_contract_vendor_a__cmd_mission_scavenge_hacking_event_start_04"
		},
		sound_events_duration = {
			3.45678,
			4.394396,
			5.257417,
			6.264271,
			3.538938,
			3.940167,
			5.143855,
			5.810042
		},
		randomize_indexes = {}
	},
	cmd_mission_scavenge_luggable_event_start = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_contract_vendor_a__cmd_mission_scavenge_luggable_event_start_01",
			"loc_contract_vendor_a__cmd_mission_scavenge_luggable_event_start_02",
			"loc_contract_vendor_a__cmd_mission_scavenge_luggable_event_start_03",
			"loc_contract_vendor_a__cmd_mission_scavenge_luggable_event_start_04"
		},
		sound_events_duration = {
			4.523084,
			4.530667,
			3.35725,
			6.779042
		},
		randomize_indexes = {}
	},
	info_all_players_required = {
		randomize_indexes_n = 0,
		sound_events_n = 5,
		sound_events = {
			"loc_contract_vendor_a__info_all_players_required_01",
			"loc_contract_vendor_a__info_all_players_required_02",
			"loc_contract_vendor_a__info_all_players_required_03",
			"loc_contract_vendor_a__info_all_players_required_04",
			"loc_contract_vendor_a__info_all_players_required_05"
		},
		sound_events_duration = {
			3.45678,
			3.45678,
			3.45678,
			3.45678,
			3.45678
		},
		randomize_indexes = {}
	},
	info_mission_scavenge_ship_elevator_vista = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_contract_vendor_a__info_mission_scavenge_ship_elevator_vista_01",
			"loc_contract_vendor_a__info_mission_scavenge_ship_elevator_vista_02",
			"loc_contract_vendor_a__info_mission_scavenge_ship_elevator_vista_03",
			"loc_contract_vendor_a__info_mission_scavenge_ship_elevator_vista_04"
		},
		sound_events_duration = {
			5.666209,
			5.037875,
			6.597355,
			6.332397
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

return settings("mission_giver_vo_contract_vendor_a", mission_giver_vo_contract_vendor_a)
