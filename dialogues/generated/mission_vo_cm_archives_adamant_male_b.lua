-- chunkname: @dialogues/generated/mission_vo_cm_archives_adamant_male_b.lua

local mission_vo_cm_archives_adamant_male_b = {
	mission_archives_front_door_a = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1] = "loc_adamant_male_b__mission_archives_front_door_a_01",
		},
		sound_events_duration = {
			[1] = 3.907438,
		},
		randomize_indexes = {},
	},
	mission_archives_start_banter_a = {
		randomize_indexes_n = 0,
		sound_events_n = 1,
		sound_events = {
			[1] = "loc_adamant_male_b__mission_archives_start_banter_a_01",
		},
		sound_events_duration = {
			[1] = 3.590708,
		},
		randomize_indexes = {},
	},
	mission_archives_start_banter_c = {
		randomize_indexes_n = 0,
		sound_events_n = 3,
		sound_events = {
			"loc_adamant_male_b__zone_throneside_01",
			"loc_adamant_male_b__zone_throneside_02",
			"loc_adamant_male_b__zone_throneside_03",
		},
		sound_events_duration = {
			4.751677,
			3.268323,
			3.579688,
		},
		sound_event_weights = {
			0.3333333,
			0.3333333,
			0.3333333,
		},
		randomize_indexes = {},
	},
}

return settings("mission_vo_cm_archives_adamant_male_b", mission_vo_cm_archives_adamant_male_b)
