-- chunkname: @dialogues/generated/event_vo_kill_adamant_male_b.lua

local event_vo_kill_adamant_male_b = {
	event_kill_target_damaged = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_adamant_male_b__event_kill_target_damaged_01",
			"loc_adamant_male_b__event_kill_target_damaged_02",
			"loc_adamant_male_b__event_kill_target_damaged_03",
			"loc_adamant_male_b__event_kill_target_damaged_04",
		},
		sound_events_duration = {
			2.23649,
			2.058135,
			2.457938,
			3.009406,
		},
		randomize_indexes = {},
	},
	event_kill_target_destroyed_a = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_adamant_male_b__event_kill_target_destroyed_a_01",
			"loc_adamant_male_b__event_kill_target_destroyed_a_02",
			"loc_adamant_male_b__event_kill_target_destroyed_a_03",
			"loc_adamant_male_b__event_kill_target_destroyed_a_04",
		},
		sound_events_duration = {
			2.146781,
			3.238854,
			2.181365,
			3.426031,
		},
		randomize_indexes = {},
	},
	event_kill_target_heavy_damage_a = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_adamant_male_b__event_kill_target_heavy_damage_a_01",
			"loc_adamant_male_b__event_kill_target_heavy_damage_a_02",
			"loc_adamant_male_b__event_kill_target_heavy_damage_a_03",
			"loc_adamant_male_b__event_kill_target_heavy_damage_a_04",
		},
		sound_events_duration = {
			1.829302,
			2.462958,
			2.868313,
			3.52674,
		},
		randomize_indexes = {},
	},
}

return settings("event_vo_kill_adamant_male_b", event_vo_kill_adamant_male_b)
