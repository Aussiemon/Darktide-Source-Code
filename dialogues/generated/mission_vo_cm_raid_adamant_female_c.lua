-- chunkname: @dialogues/generated/mission_vo_cm_raid_adamant_female_c.lua

local mission_vo_cm_raid_adamant_female_c = {
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
