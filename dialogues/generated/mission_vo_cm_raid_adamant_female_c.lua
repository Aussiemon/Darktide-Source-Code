-- chunkname: @dialogues/generated/mission_vo_cm_raid_adamant_female_c.lua

local mission_vo_cm_raid_adamant_female_c = {
	mission_raid_first_objective_response = {
		randomize_indexes_n = 0,
		sound_events_n = 8,
		sound_events = {
			"loc_adamant_female_c__guidance_starting_area_01",
			"loc_adamant_female_c__guidance_starting_area_02",
			"loc_adamant_female_c__guidance_starting_area_03",
			"loc_adamant_female_c__guidance_starting_area_04",
			"loc_adamant_female_c__guidance_starting_area_05",
			"loc_adamant_female_c__guidance_starting_area_06",
			"loc_adamant_female_c__guidance_starting_area_07",
			"loc_adamant_female_c__guidance_starting_area_08",
		},
		sound_events_duration = {
			2.282708,
			2.790948,
			2.620156,
			2.567042,
			2.132865,
			2.604115,
			2.831365,
			2.629792,
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
			[1] = "loc_adamant_female_c__mission_raid_trapped_a_01",
			[2] = "loc_adamant_female_c__mission_raid_trapped_a_02",
		},
		sound_events_duration = {
			[1] = 0.684229,
			[2] = 1.88975,
		},
		randomize_indexes = {},
	},
	mission_raid_trapped_b = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_adamant_female_c__mission_raid_trapped_b_01",
			[2] = "loc_adamant_female_c__mission_raid_trapped_b_02",
		},
		sound_events_duration = {
			[1] = 1.572344,
			[2] = 2.566208,
		},
		randomize_indexes = {},
	},
}

return settings("mission_vo_cm_raid_adamant_female_c", mission_vo_cm_raid_adamant_female_c)
