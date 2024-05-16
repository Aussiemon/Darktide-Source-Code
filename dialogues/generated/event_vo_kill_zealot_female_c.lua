-- chunkname: @dialogues/generated/event_vo_kill_zealot_female_c.lua

local event_vo_kill_zealot_female_c = {
	event_kill_target_damaged = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_zealot_female_c__event_kill_target_damaged_01",
			"loc_zealot_female_c__event_kill_target_damaged_02",
			"loc_zealot_female_c__event_kill_target_damaged_03",
			"loc_zealot_female_c__event_kill_target_damaged_04",
		},
		sound_events_duration = {
			2.934302,
			1.604365,
			2.561875,
			3.504156,
		},
		randomize_indexes = {},
	},
	event_kill_target_destroyed_a = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_zealot_female_c__event_kill_target_destroyed_a_01",
			"loc_zealot_female_c__event_kill_target_destroyed_a_02",
			"loc_zealot_female_c__event_kill_target_destroyed_a_03",
			"loc_zealot_female_c__event_kill_target_destroyed_a_04",
		},
		sound_events_duration = {
			2.218698,
			4.198208,
			2.28075,
			3.516115,
		},
		randomize_indexes = {},
	},
	event_kill_target_heavy_damage_a = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_zealot_female_c__event_kill_target_heavy_damage_a_01",
			"loc_zealot_female_c__event_kill_target_heavy_damage_a_02",
			"loc_zealot_female_c__event_kill_target_heavy_damage_a_03",
			"loc_zealot_female_c__event_kill_target_heavy_damage_a_04",
		},
		sound_events_duration = {
			2.690135,
			2.680938,
			3.226292,
			2.098031,
		},
		randomize_indexes = {},
	},
}

return settings("event_vo_kill_zealot_female_c", event_vo_kill_zealot_female_c)
