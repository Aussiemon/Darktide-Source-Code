-- chunkname: @dialogues/generated/mission_vo_cm_raid_adamant_female_b.lua

local mission_vo_cm_raid_adamant_female_b = {
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
