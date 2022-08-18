local gameplay_vo_enemy_grenadier_a = {
	throwing_grenade = {
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
		randomize_indexes = {}
	}
}

return settings("gameplay_vo_enemy_grenadier_a", gameplay_vo_enemy_grenadier_a)
