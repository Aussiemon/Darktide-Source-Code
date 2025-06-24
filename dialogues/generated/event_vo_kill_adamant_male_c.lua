-- chunkname: @dialogues/generated/event_vo_kill_adamant_male_c.lua

local event_vo_kill_adamant_male_c = {
	event_kill_target_damaged = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_adamant_male_c__event_kill_target_damaged_01",
			"loc_adamant_male_c__event_kill_target_damaged_02",
			"loc_adamant_male_c__event_kill_target_damaged_03",
			"loc_adamant_male_c__event_kill_target_damaged_04",
		},
		sound_events_duration = {
			2.432,
			3.404,
			2.546667,
			3.301333,
		},
		randomize_indexes = {},
	},
	event_kill_target_destroyed_a = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_adamant_male_c__event_kill_target_destroyed_a_01",
			"loc_adamant_male_c__event_kill_target_destroyed_a_02",
			"loc_adamant_male_c__event_kill_target_destroyed_a_03",
			"loc_adamant_male_c__event_kill_target_destroyed_a_04",
		},
		sound_events_duration = {
			3.878,
			2.906667,
			3.754667,
			2.08,
		},
		randomize_indexes = {},
	},
	event_kill_target_heavy_damage_a = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_adamant_male_c__event_kill_target_heavy_damage_a_01",
			"loc_adamant_male_c__event_kill_target_heavy_damage_a_02",
			"loc_adamant_male_c__event_kill_target_heavy_damage_a_03",
			"loc_adamant_male_c__event_kill_target_heavy_damage_a_04",
		},
		sound_events_duration = {
			2.472667,
			2.8,
			2.131333,
			3.023375,
		},
		randomize_indexes = {},
	},
}

return settings("event_vo_kill_adamant_male_c", event_vo_kill_adamant_male_c)
