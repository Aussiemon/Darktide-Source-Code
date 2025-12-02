-- chunkname: @dialogues/generated/mission_vo_cm_raid_broker_female_c.lua

local mission_vo_cm_raid_broker_female_c = {
	mission_raid_first_objective_response = {
		randomize_indexes_n = 0,
		sound_events_n = 5,
		sound_events = {
			"loc_broker_female_c__guidance_starting_area_01",
			"loc_broker_female_c__guidance_starting_area_02",
			"loc_broker_female_c__guidance_starting_area_03",
			"loc_broker_female_c__guidance_starting_area_04",
			"loc_broker_female_c__guidance_starting_area_05",
		},
		sound_events_duration = {
			3.094688,
			3.616292,
			3.610115,
			3.666156,
			3.74175,
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
			[1] = "loc_broker_female_c__mission_raid_trapped_a_01",
			[2] = "loc_broker_female_c__mission_raid_trapped_a_02",
		},
		sound_events_duration = {
			[1] = 1.814333,
			[2] = 1.947563,
		},
		randomize_indexes = {},
	},
	mission_raid_trapped_b = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_broker_female_c__mission_raid_trapped_b_01",
			[2] = "loc_broker_female_c__mission_raid_trapped_b_02",
		},
		sound_events_duration = {
			[1] = 3.248073,
			[2] = 2.79075,
		},
		randomize_indexes = {},
	},
}

return settings("mission_vo_cm_raid_broker_female_c", mission_vo_cm_raid_broker_female_c)
