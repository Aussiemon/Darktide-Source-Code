-- chunkname: @dialogues/generated/mission_vo_cm_raid_broker_male_b.lua

local mission_vo_cm_raid_broker_male_b = {
	mission_raid_first_objective_response = {
		randomize_indexes_n = 0,
		sound_events_n = 5,
		sound_events = {
			"loc_broker_male_b__guidance_starting_area_01",
			"loc_broker_male_b__guidance_starting_area_02",
			"loc_broker_male_b__guidance_starting_area_03",
			"loc_broker_male_b__guidance_starting_area_04",
			"loc_broker_male_b__guidance_starting_area_05",
		},
		sound_events_duration = {
			4.301698,
			4.961719,
			3.475271,
			3.448771,
			3.366354,
		},
		sound_event_weights = {
			0.2,
			0.2,
			0.2,
			0.2,
			0.2,
		},
		randomize_indexes = {},
	},
	mission_raid_trapped_a = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_broker_male_b__mission_raid_trapped_a_01",
			[2] = "loc_broker_male_b__mission_raid_trapped_a_02",
		},
		sound_events_duration = {
			[1] = 4.026906,
			[2] = 1.974625,
		},
		randomize_indexes = {},
	},
	mission_raid_trapped_b = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_broker_male_b__mission_raid_trapped_b_01",
			[2] = "loc_broker_male_b__mission_raid_trapped_b_02",
		},
		sound_events_duration = {
			[1] = 2.744698,
			[2] = 3.774156,
		},
		randomize_indexes = {},
	},
}

return settings("mission_vo_cm_raid_broker_male_b", mission_vo_cm_raid_broker_male_b)
