-- chunkname: @dialogues/generated/mission_vo_cm_raid_adamant_female_b.lua

local mission_vo_cm_raid_adamant_female_b = {
	mission_raid_first_objective_response = {
		randomize_indexes_n = 0,
		sound_events_n = 8,
		sound_events = {
			"loc_adamant_female_b__guidance_starting_area_01",
			"loc_adamant_female_b__guidance_starting_area_02",
			"loc_adamant_female_b__guidance_starting_area_03",
			"loc_adamant_female_b__guidance_starting_area_04",
			"loc_adamant_female_b__guidance_starting_area_05",
			"loc_adamant_female_b__guidance_starting_area_06",
			"loc_adamant_female_b__guidance_starting_area_07",
			"loc_adamant_female_b__guidance_starting_area_08",
		},
		sound_events_duration = {
			2.489438,
			2.14924,
			3.805177,
			3.799354,
			4.19201,
			3.705521,
			2.911885,
			3.076052,
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
			[1] = "loc_adamant_female_b__mission_raid_trapped_a_01",
			[2] = "loc_adamant_female_b__mission_raid_trapped_a_02",
		},
		sound_events_duration = {
			[1] = 2.432781,
			[2] = 2.573365,
		},
		randomize_indexes = {},
	},
	mission_raid_trapped_b = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_adamant_female_b__mission_raid_trapped_b_01",
			[2] = "loc_adamant_female_b__mission_raid_trapped_b_02",
		},
		sound_events_duration = {
			[1] = 4.117469,
			[2] = 3.459708,
		},
		randomize_indexes = {},
	},
}

return settings("mission_vo_cm_raid_adamant_female_b", mission_vo_cm_raid_adamant_female_b)
