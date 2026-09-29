-- chunkname: @dialogues/generated/event_vo_kill_zealot_male_c.lua

local event_vo_kill_zealot_male_c = {
	event_kill_target_damaged = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_zealot_male_c__event_kill_target_damaged_01",
			"loc_zealot_male_c__event_kill_target_damaged_02",
			"loc_zealot_male_c__event_kill_target_damaged_03",
			"loc_zealot_male_c__event_kill_target_damaged_04"
		},
		sound_events_duration = {
			2.023177,
			0.866958,
			1.759333,
			2.411292
		},
		randomize_indexes = {}
	},
	event_kill_target_destroyed_a = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_zealot_male_c__event_kill_target_destroyed_a_01",
			"loc_zealot_male_c__event_kill_target_destroyed_a_02",
			"loc_zealot_male_c__event_kill_target_destroyed_a_03",
			"loc_zealot_male_c__event_kill_target_destroyed_a_04"
		},
		sound_events_duration = {
			1.642969,
			3.409063,
			1.808156,
			3.277979
		},
		randomize_indexes = {}
	},
	event_kill_target_heavy_damage_a = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_zealot_male_c__event_kill_target_heavy_damage_a_01",
			"loc_zealot_male_c__event_kill_target_heavy_damage_a_02",
			"loc_zealot_male_c__event_kill_target_heavy_damage_a_03",
			"loc_zealot_male_c__event_kill_target_heavy_damage_a_04"
		},
		sound_events_duration = {
			2.179146,
			2.480208,
			2.194615,
			2.015708
		},
		randomize_indexes = {}
	}
}

return settings("event_vo_kill_zealot_male_c", event_vo_kill_zealot_male_c)
