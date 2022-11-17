local wwise_game_sync_settings = {
	boss_trigger_distance = 80,
	combat_state_horde_low_minimum_aggroed_minions = 5,
	vector_horde_trigger_distance = 80,
	combat_state_horde_high_minimum_aggroed_minions = 10,
	ambush_horde_trigger_distance = 80,
	default_group_state = "None",
	minion_aggro_intensity_settings = {
		num_threshold_high = 15,
		num_threshold_medium = 8,
		query_radius = 20,
		num_threshold_low = 4
	},
	state_groups = {
		music_game_state = {
			mission_board = "mission_board",
			main_menu = "main_menu",
			character_creation = "character_creation",
			game_score_win = "game_score_win",
			loadout = "loadout",
			title = "title",
			mission = "mission",
			mission_briefing = "mission_briefing",
			game_score = "game_score",
			game_score_lose = "game_score_lose",
			mission_loading = "mission_loading",
			defeat = "defeat",
			mission_ready = "mission_ready",
			mission_intro = "mission_intro",
			victory = "victory",
			mission_outro = "mission_outro",
			mission_start = "mission_start",
			loading = "loading",
			none = "None",
			cinematic = "cinematic",
			game_start = "game_start",
			loadout_ready = "loadout_ready"
		},
		music_zone = {
			zone_6 = "zone_6",
			hub = "hub",
			zone_7 = "zone_7",
			zone_5 = "zone_5",
			none = "None",
			zone_2 = "zone_2",
			prologue = "prologue",
			zone_1 = "zone_1",
			zone_4 = "zone_4",
			zone_3 = "zone_3"
		},
		music_combat = {
			horde_high = "horde_high",
			normal = "normal",
			boss = "boss",
			horde_low = "horde_low",
			none = "None"
		},
		music_objective = {
			collect_event = "collect_event",
			control_event = "control_event",
			fortification_event = "fortification_event",
			prologue_combat = "prologue_combat",
			hacking_event = "hacking_event",
			kill_event = "kill_event",
			demolition_event = "demolition_event",
			none = "None",
			last_man_standing = "last_man_standing",
			escape_event = "escape_event"
		},
		music_objective_progression = {
			two = "two",
			one = "one",
			three = "three",
			none = "None"
		},
		music_circumstance = {
			none = "None"
		},
		options = {
			credit_store_menu = "credit_store_menu",
			appearance_menu = "appearance_menu",
			vendor_menu = "vendor_menu",
			ingame_menu = "ingame_menu",
			none = "None"
		},
		minion_aggro_intensity = {
			high = "high",
			medium = "medium",
			low = "low",
			none = "None"
		},
		event_intensity = {
			high = "high",
			low = "low",
			none = "None"
		}
	}
}

return settings("WwiseGameSyncSettings", wwise_game_sync_settings)
