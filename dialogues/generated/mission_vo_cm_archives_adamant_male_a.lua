-- chunkname: @dialogues/generated/mission_vo_cm_archives_adamant_male_a.lua

local mission_vo_cm_archives_adamant_male_a = {
	mission_archives_front_door_a = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1] = "loc_adamant_male_a__mission_archives_front_door_a_01",
		},
		sound_events_duration = {
			[1] = 2.76501,
		},
		randomize_indexes = {},
	},
	mission_archives_start_banter_a = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1] = "loc_adamant_male_a__mission_archives_start_banter_a_01",
		},
		sound_events_duration = {
			[1] = 2.944615,
		},
		randomize_indexes = {},
	},
	mission_archives_start_banter_c = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_adamant_male_a__zone_throneside_01",
			"loc_adamant_male_a__zone_throneside_02",
			"loc_adamant_male_a__zone_throneside_03",
		},
		sound_events_duration = {
			3.03001,
			1.749344,
			3.894677,
		},
		sound_event_weights = {
			0.3333333,
			0.3333333,
			0.3333333,
		},
		randomize_indexes = {},
	},
}

return settings("mission_vo_cm_archives_adamant_male_a", mission_vo_cm_archives_adamant_male_a)
