-- chunkname: @dialogues/generated/mission_vo_km_enforcer_twins_ogryn_d.lua

local mission_vo_km_enforcer_twins_ogryn_d = {
	enemy_kill_monster_twins = {
		randomize_indexes_n = 0,
		sound_events_n = 7,
		sound_events = {
			"loc_ogryn_d__enemy_kill_monster_01",
			"loc_ogryn_d__enemy_kill_monster_02",
			"loc_ogryn_d__enemy_kill_monster_03",
			"loc_ogryn_d__enemy_kill_monster_04",
			"loc_ogryn_d__enemy_kill_monster_05",
			"loc_ogryn_d__enemy_kill_monster_06",
			"loc_ogryn_d__enemy_kill_monster_07",
		},
		sound_events_duration = {
			3.551958,
			3.334219,
			4.846104,
			2.712146,
			4.420604,
			4.789115,
			3.952708,
		},
		sound_event_weights = {
			0.1428571,
			0.1428571,
			0.1428571,
			0.1428571,
			0.1428571,
			0.1428571,
			0.1428571,
		},
		randomize_indexes = {},
	},
	mission_twins_go_around = {
		randomize_indexes_n = 0,
		sound_events_n = 2,
		sound_events = {
			[1] = "loc_ogryn_d__mission_stockpile_main_access_01",
			[2] = "loc_ogryn_d__mission_stockpile_main_access_02",
		},
		sound_events_duration = {
			[1] = 2.733729,
			[2] = 3.793927,
		},
		sound_event_weights = {
			[1] = 0.5,
			[2] = 0.5,
		},
		randomize_indexes = {},
	},
	response_for_enemy_kill_monster_twins = {
		randomize_indexes_n = 0,
		sound_events_n = 7,
		sound_events = {
			"loc_ogryn_d__response_for_enemy_kill_monster_01",
			"loc_ogryn_d__response_for_enemy_kill_monster_02",
			"loc_ogryn_d__response_for_enemy_kill_monster_03",
			"loc_ogryn_d__response_for_enemy_kill_monster_04",
			"loc_ogryn_d__response_for_enemy_kill_monster_05",
			"loc_ogryn_d__response_for_enemy_kill_monster_06",
			"loc_ogryn_d__response_for_enemy_kill_monster_07",
		},
		sound_events_duration = {
			3.048771,
			2.822813,
			3.695375,
			3.410313,
			2.913198,
			4.079375,
			2.787719,
		},
		sound_event_weights = {
			0.1428571,
			0.1428571,
			0.1428571,
			0.1428571,
			0.1428571,
			0.1428571,
			0.1428571,
		},
		randomize_indexes = {},
	},
}

return settings("mission_vo_km_enforcer_twins_ogryn_d", mission_vo_km_enforcer_twins_ogryn_d)
