local enemy_vo_enemy_grenadier_a = {
	renegade_grenadier_skulking = {
		randomize_indexes_n = 0,
		sound_events_n = 10,
		sound_events = {
			"loc_enemy_grenadier_a__skulking_01",
			"loc_enemy_grenadier_a__skulking_02",
			"loc_enemy_grenadier_a__skulking_03",
			"loc_enemy_grenadier_a__skulking_04",
			"loc_enemy_grenadier_a__skulking_05",
			"loc_enemy_grenadier_a__skulking_06",
			"loc_enemy_grenadier_a__skulking_07",
			"loc_enemy_grenadier_a__skulking_08",
			"loc_enemy_grenadier_a__skulking_09",
			"loc_enemy_grenadier_a__skulking_10"
		},
		sound_events_duration = {
			2.177438,
			1.575667,
			1.7935,
			2.35525,
			1.322208,
			1.716938,
			1.605833,
			1.265521,
			1.632938,
			2.683208
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
			"loc_enemy_grenadier_a__spawned_01",
			"loc_enemy_grenadier_a__spawned_02",
			"loc_enemy_grenadier_a__spawned_03",
			"loc_enemy_grenadier_a__spawned_04"
		},
		sound_events_duration = {
			1.157188,
			1.583333,
			0.988958,
			1.319625
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
			"loc_enemy_grenadier_a__throwing_grenade_01",
			"loc_enemy_grenadier_a__throwing_grenade_02",
			"loc_enemy_grenadier_a__throwing_grenade_03",
			"loc_enemy_grenadier_a__throwing_grenade_04",
			"loc_enemy_grenadier_a__throwing_grenade_05",
			"loc_enemy_grenadier_a__throwing_grenade_06",
			"loc_enemy_grenadier_a__throwing_grenade_07",
			"loc_enemy_grenadier_a__throwing_grenade_08",
			"loc_enemy_grenadier_a__throwing_grenade_09",
			"loc_enemy_grenadier_a__throwing_grenade_10"
		},
		sound_events_duration = {
			1.185313,
			1.200521,
			1.457646,
			1.565313,
			1.458229,
			1.375188,
			1.425896,
			1.500917,
			1.408458,
			0.952417
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

return settings("enemy_vo_enemy_grenadier_a", enemy_vo_enemy_grenadier_a)
