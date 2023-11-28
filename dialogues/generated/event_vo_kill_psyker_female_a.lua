-- chunkname: @dialogues/generated/event_vo_kill_psyker_female_a.lua

local event_vo_kill_psyker_female_a = {
	event_kill_target_damaged = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_psyker_female_a__event_kill_target_damaged_01",
			"loc_psyker_female_a__event_kill_target_damaged_02",
			"loc_psyker_female_a__event_kill_target_damaged_03",
			"loc_psyker_female_a__event_kill_target_damaged_04"
		},
		sound_events_duration = {
			2.096042,
			1.833521,
			1.730979,
			3.886375
		},
		randomize_indexes = {}
	},
	event_kill_target_destroyed_a = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_psyker_female_a__event_kill_target_destroyed_a_01",
			"loc_psyker_female_a__event_kill_target_destroyed_a_02",
			"loc_psyker_female_a__event_kill_target_destroyed_a_03",
			"loc_psyker_female_a__event_kill_target_destroyed_a_04"
		},
		sound_events_duration = {
			2.11825,
			2.377542,
			3.004938,
			1.564396
		},
		randomize_indexes = {}
	},
	event_kill_target_heavy_damage_a = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_psyker_female_a__event_kill_target_heavy_damage_a_01",
			"loc_psyker_female_a__event_kill_target_heavy_damage_a_02",
			"loc_psyker_female_a__event_kill_target_heavy_damage_a_03",
			"loc_psyker_female_a__event_kill_target_heavy_damage_a_04"
		},
		sound_events_duration = {
			1.4695,
			3.212958,
			2.457938,
			2.984458
		},
		randomize_indexes = {}
	}
}

return settings("event_vo_kill_psyker_female_a", event_vo_kill_psyker_female_a)
