-- chunkname: @dialogues/generated/event_vo_kill_adamant_male_a.lua

local event_vo_kill_adamant_male_a = {
	event_kill_target_damaged = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_adamant_male_a__event_kill_target_damaged_01",
			"loc_adamant_male_a__event_kill_target_damaged_02",
			"loc_adamant_male_a__event_kill_target_damaged_03",
			"loc_adamant_male_a__event_kill_target_damaged_04",
		},
		sound_events_duration = {
			1.966813,
			2.7685,
			2.152802,
			1.715958,
		},
		randomize_indexes = {},
	},
	event_kill_target_destroyed_a = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_adamant_male_a__event_kill_target_destroyed_a_01",
			"loc_adamant_male_a__event_kill_target_destroyed_a_02",
			"loc_adamant_male_a__event_kill_target_destroyed_a_03",
			"loc_adamant_male_a__event_kill_target_destroyed_a_04",
		},
		sound_events_duration = {
			4.01551,
			1.97025,
			2.427167,
			3.057583,
		},
		randomize_indexes = {},
	},
	event_kill_target_heavy_damage_a = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_adamant_male_a__event_kill_target_heavy_damage_a_01",
			"loc_adamant_male_a__event_kill_target_heavy_damage_a_02",
			"loc_adamant_male_a__event_kill_target_heavy_damage_a_03",
			"loc_adamant_male_a__event_kill_target_heavy_damage_a_04",
		},
		sound_events_duration = {
			2.958052,
			4.581646,
			3.5,
			2.535188,
		},
		randomize_indexes = {},
	},
}

return settings("event_vo_kill_adamant_male_a", event_vo_kill_adamant_male_a)
