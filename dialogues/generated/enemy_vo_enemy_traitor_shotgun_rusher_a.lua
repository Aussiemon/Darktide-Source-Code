local enemy_vo_enemy_traitor_shotgun_rusher_a = {
	call_backup = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_enemy_traitor_shotgun_rusher_a__call_backup_01",
			"loc_enemy_traitor_shotgun_rusher_a__call_backup_02",
			"loc_enemy_traitor_shotgun_rusher_a__call_backup_03",
			"loc_enemy_traitor_shotgun_rusher_a__call_backup_04"
		},
		sound_events_duration = {
			1.039479,
			1.006917,
			0.989083,
			1.572
		},
		randomize_indexes = {}
	},
	ranged_idle_player_low_on_health = {
		randomize_indexes_n = 0,
		sound_events_n = 4,
		sound_events = {
			"loc_enemy_traitor_shotgun_rusher_a__ranged_idle_player_low_on_health_01",
			"loc_enemy_traitor_shotgun_rusher_a__ranged_idle_player_low_on_health_02",
			"loc_enemy_traitor_shotgun_rusher_a__ranged_idle_player_low_on_health_03",
			"loc_enemy_traitor_shotgun_rusher_a__ranged_idle_player_low_on_health_04"
		},
		sound_events_duration = {
			0.892438,
			1.320792,
			1.833229,
			0.863396
		},
		sound_event_weights = {
			0.25,
			0.25,
			0.25,
			0.25
		},
		randomize_indexes = {}
	}
}

return settings("enemy_vo_enemy_traitor_shotgun_rusher_a", enemy_vo_enemy_traitor_shotgun_rusher_a)
