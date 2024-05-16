-- chunkname: @dialogues/generated/event_vo_kill_sergeant_a.lua

local event_vo_kill_sergeant_a = {
	event_kill_kill_the_target = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_sergeant_a__event_kill_kill_the_target_01",
			"loc_sergeant_a__event_kill_kill_the_target_02",
			"loc_sergeant_a__event_kill_kill_the_target_03",
			"loc_sergeant_a__event_kill_kill_the_target_04",
		},
		sound_events_duration = {
			2.901438,
			4.735833,
			3.569354,
			3.825021,
		},
		randomize_indexes = {},
	},
	event_kill_target_destroyed_b = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_sergeant_a__event_kill_target_destroyed_b_01",
			"loc_sergeant_a__event_kill_target_destroyed_b_02",
			"loc_sergeant_a__event_kill_target_destroyed_b_03",
			"loc_sergeant_a__event_kill_target_destroyed_b_04",
		},
		sound_events_duration = {
			3.844708,
			2.253021,
			2.635167,
			3.818229,
		},
		randomize_indexes = {},
	},
	event_kill_target_heavy_damage_b = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_sergeant_a__event_kill_target_heavy_damage_b_01",
			"loc_sergeant_a__event_kill_target_heavy_damage_b_02",
			"loc_sergeant_a__event_kill_target_heavy_damage_b_03",
			"loc_sergeant_a__event_kill_target_heavy_damage_b_04",
		},
		sound_events_duration = {
			1.659938,
			1.722625,
			2.196583,
			2.269125,
		},
		randomize_indexes = {},
	},
}

return settings("event_vo_kill_sergeant_a", event_vo_kill_sergeant_a)
