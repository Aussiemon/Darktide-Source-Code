-- chunkname: @dialogues/generated/event_vo_kill_veteran_male_a.lua

local event_vo_kill_veteran_male_a = {
	event_kill_target_damaged = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_veteran_male_a__event_kill_target_damaged_01",
			"loc_veteran_male_a__event_kill_target_damaged_02",
			"loc_veteran_male_a__event_kill_target_damaged_03",
			"loc_veteran_male_a__event_kill_target_damaged_04"
		},
		sound_events_duration = {
			1.866979,
			1.704417,
			2.139667,
			2.388896
		},
		randomize_indexes = {}
	},
	event_kill_target_destroyed_a = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_veteran_male_a__event_kill_target_destroyed_a_01",
			"loc_veteran_male_a__event_kill_target_destroyed_a_02",
			"loc_veteran_male_a__event_kill_target_destroyed_a_03",
			"loc_veteran_male_a__event_kill_target_destroyed_a_04"
		},
		sound_events_duration = {
			2.675729,
			2.223521,
			2.552208,
			2.702125
		},
		randomize_indexes = {}
	},
	event_kill_target_heavy_damage_a = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_veteran_male_a__event_kill_target_heavy_damage_a_01",
			"loc_veteran_male_a__event_kill_target_heavy_damage_a_02",
			"loc_veteran_male_a__event_kill_target_heavy_damage_a_03",
			"loc_veteran_male_a__event_kill_target_heavy_damage_a_04"
		},
		sound_events_duration = {
			3.242021,
			3.902417,
			2.110396,
			2.518229
		},
		randomize_indexes = {}
	}
}

return settings("event_vo_kill_veteran_male_a", event_vo_kill_veteran_male_a)
