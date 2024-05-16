-- chunkname: @dialogues/generated/event_vo_kill_psyker_female_b.lua

local event_vo_kill_psyker_female_b = {
	event_kill_target_damaged = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_psyker_female_b__event_kill_target_damaged_01",
			"loc_psyker_female_b__event_kill_target_damaged_02",
			"loc_psyker_female_b__event_kill_target_damaged_03",
			"loc_psyker_female_b__event_kill_target_damaged_04",
		},
		sound_events_duration = {
			4.247104,
			3.111583,
			2.511021,
			3.420708,
		},
		randomize_indexes = {},
	},
	event_kill_target_destroyed_a = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_psyker_female_b__event_kill_target_destroyed_a_01",
			"loc_psyker_female_b__event_kill_target_destroyed_a_02",
			"loc_psyker_female_b__event_kill_target_destroyed_a_03",
			"loc_psyker_female_b__event_kill_target_destroyed_a_04",
		},
		sound_events_duration = {
			2.834125,
			2.818667,
			2.341542,
			3.758146,
		},
		randomize_indexes = {},
	},
	event_kill_target_heavy_damage_a = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_psyker_female_b__event_kill_target_heavy_damage_a_01",
			"loc_psyker_female_b__event_kill_target_heavy_damage_a_02",
			"loc_psyker_female_b__event_kill_target_heavy_damage_a_03",
			"loc_psyker_female_b__event_kill_target_heavy_damage_a_04",
		},
		sound_events_duration = {
			2.118896,
			4.521667,
			6.441938,
			6.162521,
		},
		randomize_indexes = {},
	},
}

return settings("event_vo_kill_psyker_female_b", event_vo_kill_psyker_female_b)
