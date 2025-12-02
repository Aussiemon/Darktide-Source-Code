-- chunkname: @dialogues/generated/mission_vo_cm_raid_adamant_male_a.lua

local mission_vo_cm_raid_adamant_male_a = {
	mission_raid_first_objective_response = {
		randomize_indexes_n = 0,
		sound_events_n = 8,
		sound_events = {
			"loc_adamant_male_a__guidance_starting_area_01",
			"loc_adamant_male_a__guidance_starting_area_02",
			"loc_adamant_male_a__guidance_starting_area_03",
			"loc_adamant_male_a__guidance_starting_area_04",
			"loc_adamant_male_a__guidance_starting_area_05",
			"loc_adamant_male_a__guidance_starting_area_06",
			"loc_adamant_male_a__guidance_starting_area_07",
			"loc_adamant_male_a__guidance_starting_area_08",
		},
		sound_events_duration = {
			1.677333,
			3.262667,
			3.306667,
			4.317333,
			3.72,
			4.964,
			2.613333,
			5.453333,
		},
		sound_event_weights = {
			0.125,
			0.125,
			0.125,
			0.125,
			0.125,
			0.125,
			0.125,
			0.125,
		},
		randomize_indexes = {},
	},
	mission_raid_trapped_a = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_adamant_male_a__mission_raid_trapped_a_01",
			[2] = "loc_adamant_male_a__mission_raid_trapped_a_02",
		},
		sound_events_duration = {
			[1] = 1.081677,
			[2] = 1.998344,
		},
		randomize_indexes = {},
	},
	mission_raid_trapped_b = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_adamant_male_a__mission_raid_trapped_b_01",
			[2] = "loc_adamant_male_a__mission_raid_trapped_b_02",
		},
		sound_events_duration = {
			[1] = 3.431677,
			[2] = 4.06501,
		},
		randomize_indexes = {},
	},
}

return settings("mission_vo_cm_raid_adamant_male_a", mission_vo_cm_raid_adamant_male_a)
