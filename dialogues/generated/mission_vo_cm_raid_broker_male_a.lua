-- chunkname: @dialogues/generated/mission_vo_cm_raid_broker_male_a.lua

local mission_vo_cm_raid_broker_male_a = {
	mission_raid_first_objective_response = {
		randomize_indexes_n = 0,
		sound_events_n = 5,
		sound_events = {
			"loc_broker_male_a__guidance_starting_area_01",
			"loc_broker_male_a__guidance_starting_area_02",
			"loc_broker_male_a__guidance_starting_area_03",
			"loc_broker_male_a__guidance_starting_area_04",
			"loc_broker_male_a__guidance_starting_area_05",
		},
		sound_events_duration = {
			4.146938,
			3.423625,
			2.380875,
			5.720115,
			2.603885,
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
			[1] = "loc_broker_male_a__mission_raid_trapped_a_01",
			[2] = "loc_broker_male_a__mission_raid_trapped_a_02",
		},
		sound_events_duration = {
			[1] = 1.874563,
			[2] = 2.62801,
		},
		randomize_indexes = {},
	},
	mission_raid_trapped_b = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_broker_male_a__mission_raid_trapped_b_01",
			[2] = "loc_broker_male_a__mission_raid_trapped_b_02",
		},
		sound_events_duration = {
			[1] = 2.742531,
			[2] = 2.941438,
		},
		randomize_indexes = {},
	},
}

return settings("mission_vo_cm_raid_broker_male_a", mission_vo_cm_raid_broker_male_a)
