-- chunkname: @dialogues/generated/enemy_vo_enemy_grenadier_b.lua

local enemy_vo_enemy_grenadier_b = {
	renegade_grenadier_skulking = {
		randomize_indexes_n = 0,
		sound_events_n = 10,
		sound_events = {
			"loc_enemy_grenadier_b__skulking_01",
			"loc_enemy_grenadier_b__skulking_02",
			"loc_enemy_grenadier_b__skulking_03",
			"loc_enemy_grenadier_b__skulking_04",
			"loc_enemy_grenadier_b__skulking_05",
			"loc_enemy_grenadier_b__skulking_06",
			"loc_enemy_grenadier_b__skulking_07",
			"loc_enemy_grenadier_b__skulking_08",
			"loc_enemy_grenadier_b__skulking_09",
			"loc_enemy_grenadier_b__skulking_10"
		},
		sound_events_duration = {
			2.146,
			1.407,
			1.722,
			2.265,
			1.208,
			1.612,
			1.479,
			1.124,
			1.494,
			2.597
		},
		sound_event_weights = {
			0.1,
			0.1,
			0.1,
			0.1,
			0.1,
			0.1,
			0.1,
			0.1,
			0.1,
			0.1
		},
		randomize_indexes = {}
	},
	traitor_grenadier_spawned = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_enemy_grenadier_b__spawned_01",
			"loc_enemy_grenadier_b__spawned_02",
			"loc_enemy_grenadier_b__spawned_03",
			"loc_enemy_grenadier_b__spawned_04"
		},
		sound_events_duration = {
			1.15,
			1.483,
			0.844,
			1.247
		},
		sound_event_weights = {
			0.25,
			0.25,
			0.25,
			0.25
		},
		randomize_indexes = {}
	},
	traitor_grenadier_throwing_grenade = {
		randomize_indexes_n = 0,
		sound_events_n = 10,
		sound_events = {
			"loc_enemy_grenadier_b__throwing_grenade_01",
			"loc_enemy_grenadier_b__throwing_grenade_02",
			"loc_enemy_grenadier_b__throwing_grenade_03",
			"loc_enemy_grenadier_b__throwing_grenade_04",
			"loc_enemy_grenadier_b__throwing_grenade_05",
			"loc_enemy_grenadier_b__throwing_grenade_06",
			"loc_enemy_grenadier_b__throwing_grenade_07",
			"loc_enemy_grenadier_b__throwing_grenade_08",
			"loc_enemy_grenadier_b__throwing_grenade_09",
			"loc_enemy_grenadier_b__throwing_grenade_10"
		},
		sound_events_duration = {
			1.066,
			1.132,
			1.326,
			1.477,
			1.373,
			1.282,
			1.374,
			1.379,
			1.317,
			0.859
		},
		sound_event_weights = {
			0.1,
			0.1,
			0.1,
			0.1,
			0.1,
			0.1,
			0.1,
			0.1,
			0.1,
			0.1
		},
		randomize_indexes = {}
	}
}

return settings("enemy_vo_enemy_grenadier_b", enemy_vo_enemy_grenadier_b)
