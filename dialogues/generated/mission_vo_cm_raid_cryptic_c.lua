-- chunkname: @dialogues/generated/mission_vo_cm_raid_cryptic_c.lua

local mission_vo_cm_raid_cryptic_c = {
	mission_raid_first_objective_response = {
		randomize_indexes_n = 0,
		sound_events_n = 5,
		sound_events = {
			"loc_cryptic_c__guidance_starting_area_01",
			"loc_cryptic_c__guidance_starting_area_02",
			"loc_cryptic_c__guidance_starting_area_03",
			"loc_cryptic_c__guidance_starting_area_04",
			"loc_cryptic_c__guidance_starting_area_05",
		},
		sound_events_duration = {
			3.623542,
			3.451458,
			2.55001,
			3.043302,
			5.726906,
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
			[1] = "loc_cryptic_c__mission_raid_trapped_a_01",
			[2] = "loc_cryptic_c__mission_raid_trapped_a_02",
		},
		sound_events_duration = {
			[1] = 2.211542,
			[2] = 1.63726,
		},
		randomize_indexes = {},
	},
	mission_raid_trapped_b = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_cryptic_c__mission_raid_trapped_b_01",
			[2] = "loc_cryptic_c__mission_raid_trapped_b_02",
		},
		sound_events_duration = {
			[1] = 2.62451,
			[2] = 3.012344,
		},
		randomize_indexes = {},
	},
}

return settings("mission_vo_cm_raid_cryptic_c", mission_vo_cm_raid_cryptic_c)
