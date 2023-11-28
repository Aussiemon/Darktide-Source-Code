-- chunkname: @dialogues/generated/event_vo_kill_veteran_male_c.lua

local event_vo_kill_veteran_male_c = {
	event_kill_target_damaged = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_veteran_male_c__event_kill_target_damaged_01",
			"loc_veteran_male_c__event_kill_target_damaged_02",
			"loc_veteran_male_c__event_kill_target_damaged_03",
			"loc_veteran_male_c__event_kill_target_damaged_04"
		},
		sound_events_duration = {
			1.310646,
			1.826563,
			1.309938,
			1.628625
		},
		randomize_indexes = {}
	},
	event_kill_target_destroyed_a = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_veteran_male_c__event_kill_target_destroyed_a_01",
			"loc_veteran_male_c__event_kill_target_destroyed_a_02",
			"loc_veteran_male_c__event_kill_target_destroyed_a_03",
			"loc_veteran_male_c__event_kill_target_destroyed_a_04"
		},
		sound_events_duration = {
			1.411667,
			1.78825,
			1.552156,
			1.748146
		},
		randomize_indexes = {}
	},
	event_kill_target_heavy_damage_a = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_veteran_male_c__event_kill_target_heavy_damage_a_01",
			"loc_veteran_male_c__event_kill_target_heavy_damage_a_02",
			"loc_veteran_male_c__event_kill_target_heavy_damage_a_03",
			"loc_veteran_male_c__event_kill_target_heavy_damage_a_04"
		},
		sound_events_duration = {
			1.653813,
			2.186979,
			1.156333,
			0.948563
		},
		randomize_indexes = {}
	}
}

return settings("event_vo_kill_veteran_male_c", event_vo_kill_veteran_male_c)
