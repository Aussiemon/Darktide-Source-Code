-- chunkname: @dialogues/generated/event_vo_kill_psyker_male_b.lua

local event_vo_kill_psyker_male_b = {
	event_kill_target_damaged = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_psyker_male_b__event_kill_target_damaged_01",
			"loc_psyker_male_b__event_kill_target_damaged_02",
			"loc_psyker_male_b__event_kill_target_damaged_03",
			"loc_psyker_male_b__event_kill_target_damaged_04"
		},
		sound_events_duration = {
			3.935958,
			2.887104,
			3.440458,
			3.383833
		},
		randomize_indexes = {}
	},
	event_kill_target_destroyed_a = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_psyker_male_b__event_kill_target_destroyed_a_01",
			"loc_psyker_male_b__event_kill_target_destroyed_a_02",
			"loc_psyker_male_b__event_kill_target_destroyed_a_03",
			"loc_psyker_male_b__event_kill_target_destroyed_a_04"
		},
		sound_events_duration = {
			2.812292,
			2.960271,
			1.799667,
			3.031125
		},
		randomize_indexes = {}
	},
	event_kill_target_heavy_damage_a = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_psyker_male_b__event_kill_target_heavy_damage_a_01",
			"loc_psyker_male_b__event_kill_target_heavy_damage_a_02",
			"loc_psyker_male_b__event_kill_target_heavy_damage_a_03",
			"loc_psyker_male_b__event_kill_target_heavy_damage_a_04"
		},
		sound_events_duration = {
			2.095729,
			5.071438,
			5.629313,
			6.001479
		},
		randomize_indexes = {}
	}
}

return settings("event_vo_kill_psyker_male_b", event_vo_kill_psyker_male_b)
