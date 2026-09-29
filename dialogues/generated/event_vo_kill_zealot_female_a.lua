-- chunkname: @dialogues/generated/event_vo_kill_zealot_female_a.lua

local event_vo_kill_zealot_female_a = {
	event_kill_target_damaged = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_zealot_female_a__event_kill_target_damaged_01",
			"loc_zealot_female_a__event_kill_target_damaged_02",
			"loc_zealot_female_a__event_kill_target_damaged_03",
			"loc_zealot_female_a__event_kill_target_damaged_04"
		},
		sound_events_duration = {
			2.090563,
			2.57875,
			3.41175,
			1.937875
		},
		randomize_indexes = {}
	},
	event_kill_target_destroyed_a = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_zealot_female_a__event_kill_target_destroyed_a_01",
			"loc_zealot_female_a__event_kill_target_destroyed_a_02",
			"loc_zealot_female_a__event_kill_target_destroyed_a_03",
			"loc_zealot_female_a__event_kill_target_destroyed_a_04"
		},
		sound_events_duration = {
			2.87425,
			3.539708,
			2.226521,
			3.484938
		},
		randomize_indexes = {}
	},
	event_kill_target_heavy_damage_a = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_zealot_female_a__event_kill_target_heavy_damage_a_01",
			"loc_zealot_female_a__event_kill_target_heavy_damage_a_02",
			"loc_zealot_female_a__event_kill_target_heavy_damage_a_03",
			"loc_zealot_female_a__event_kill_target_heavy_damage_a_04"
		},
		sound_events_duration = {
			2.946229,
			2.149563,
			3.243479,
			3.647083
		},
		randomize_indexes = {}
	}
}

return settings("event_vo_kill_zealot_female_a", event_vo_kill_zealot_female_a)
