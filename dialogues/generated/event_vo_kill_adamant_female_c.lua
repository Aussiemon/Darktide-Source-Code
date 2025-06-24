-- chunkname: @dialogues/generated/event_vo_kill_adamant_female_c.lua

local event_vo_kill_adamant_female_c = {
	event_kill_target_damaged = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_adamant_female_c__event_kill_target_damaged_01",
			"loc_adamant_female_c__event_kill_target_damaged_02",
			"loc_adamant_female_c__event_kill_target_damaged_03",
			"loc_adamant_female_c__event_kill_target_damaged_04",
		},
		sound_events_duration = {
			2.003458,
			3.097813,
			1.681813,
			2.83699,
		},
		randomize_indexes = {},
	},
	event_kill_target_destroyed_a = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_adamant_female_c__event_kill_target_destroyed_a_01",
			"loc_adamant_female_c__event_kill_target_destroyed_a_02",
			"loc_adamant_female_c__event_kill_target_destroyed_a_03",
			"loc_adamant_female_c__event_kill_target_destroyed_a_04",
		},
		sound_events_duration = {
			3.180385,
			2.997896,
			3.253688,
			1.334,
		},
		randomize_indexes = {},
	},
	event_kill_target_heavy_damage_a = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_adamant_female_c__event_kill_target_heavy_damage_a_01",
			"loc_adamant_female_c__event_kill_target_heavy_damage_a_02",
			"loc_adamant_female_c__event_kill_target_heavy_damage_a_03",
			"loc_adamant_female_c__event_kill_target_heavy_damage_a_04",
		},
		sound_events_duration = {
			1.776875,
			2.529146,
			1.84649,
			2.302813,
		},
		randomize_indexes = {},
	},
}

return settings("event_vo_kill_adamant_female_c", event_vo_kill_adamant_female_c)
