-- chunkname: @dialogues/generated/mission_vo_cm_archives_ogryn_d.lua

local mission_vo_cm_archives_ogryn_d = {
	mission_archives_alarm = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_ogryn_d__mission_archives_alarm_01",
			[2] = "loc_ogryn_d__mission_archives_alarm_02",
		},
		sound_events_duration = {
			[1] = 2.163125,
			[2] = 2.724969,
		},
		randomize_indexes = {},
	},
	mission_archives_first_objective_response = {
		randomize_indexes_n = 0,
		sound_events_n = 10,
		sound_events = {
			"loc_ogryn_d__guidance_starting_area_01",
			"loc_ogryn_d__guidance_starting_area_02",
			"loc_ogryn_d__guidance_starting_area_03",
			"loc_ogryn_d__guidance_starting_area_04",
			"loc_ogryn_d__guidance_starting_area_05",
			"loc_ogryn_d__guidance_starting_area_06",
			"loc_ogryn_d__guidance_starting_area_07",
			"loc_ogryn_d__guidance_starting_area_08",
			"loc_ogryn_d__guidance_starting_area_09",
			"loc_ogryn_d__guidance_starting_area_10",
		},
		sound_events_duration = {
			3.414156,
			5.921052,
			5.203438,
			5.783073,
			3.513135,
			4.039313,
			3.712104,
			4.885927,
			3.494604,
			4.877969,
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
	mission_archives_front_door_a = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_ogryn_d__mission_archives_front_door_a_01",
			[2] = "loc_ogryn_d__mission_archives_front_door_a_02",
		},
		sound_events_duration = {
			[1] = 3.1105,
			[2] = 5.651229,
		},
		randomize_indexes = {},
	},
	mission_archives_keep_coming_b = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_ogryn_d__event_survive_almost_done_01",
			"loc_ogryn_d__event_survive_almost_done_02",
			"loc_ogryn_d__event_survive_almost_done_03",
			"loc_ogryn_d__event_survive_almost_done_04",
		},
		sound_events_duration = {
			2.259948,
			1.87799,
			2.267167,
			2.974094,
		},
		sound_event_weights = {
			0.25,
			0.25,
			0.25,
			0.25,
		},
		randomize_indexes = {},
	},
	mission_archives_mid_conversation_one_a = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_ogryn_d__mission_archives_mid_conversation_one_a_01",
			[2] = "loc_ogryn_d__mission_archives_mid_conversation_one_a_02",
		},
		sound_events_duration = {
			[1] = 6.262396,
			[2] = 3.095969,
		},
		randomize_indexes = {},
	},
	mission_archives_mid_conversation_three_a = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1] = "loc_ogryn_d__mission_archives_mid_conversation_three_a_02",
		},
		sound_events_duration = {
			[1] = 4.415021,
		},
		randomize_indexes = {},
	},
	mission_archives_mid_conversation_two_a = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_ogryn_d__mission_archives_mid_conversation_two_a_01",
			[2] = "loc_ogryn_d__mission_archives_mid_conversation_two_a_02",
		},
		sound_events_duration = {
			[1] = 5.156313,
			[2] = 5.396135,
		},
		randomize_indexes = {},
	},
	mission_archives_start_banter_a = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_ogryn_d__mission_archives_start_banter_a_01",
			[2] = "loc_ogryn_d__mission_archives_start_banter_a_02",
		},
		sound_events_duration = {
			[1] = 4.043656,
			[2] = 4.578542,
		},
		randomize_indexes = {},
	},
	mission_archives_start_banter_c = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_ogryn_d__zone_throneside_01",
			"loc_ogryn_d__zone_throneside_02",
			"loc_ogryn_d__zone_throneside_03",
		},
		sound_events_duration = {
			7.688771,
			7.85674,
			6.368104,
		},
		sound_event_weights = {
			0.3333333,
			0.3333333,
			0.3333333,
		},
		randomize_indexes = {},
	},
}

return settings("mission_vo_cm_archives_ogryn_d", mission_vo_cm_archives_ogryn_d)
