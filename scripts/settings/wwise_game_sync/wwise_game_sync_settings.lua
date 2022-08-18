local wwise_game_sync_settings = {
	boss_trigger_distance = 80,
	vector_horde_trigger_distance = 80,
	ambush_horde_trigger_distance = 80,
	default_group_state = "None",
	state_groups = {
		music_game_state = {
			mission_intro = "mission_intro",
			main_menu = "main_menu",
			character_creation = "character_creation",
			mission = "mission",
			defeat = "defeat",
			title = "title",
			loadout = "loadout",
			mission_briefing = "mission_briefing",
			game_score = "game_score",
			mission_board = "mission_board",
			victory = "victory",
			mission_ready = "mission_ready",
			mission_loading = "mission_loading",
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
			boss = "boss",
			horde = "horde",
			normal = "normal",
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
			ingame_menu = "ingame_menu",
			none = "None"
		},
		sfx_combat = {
			boss = "boss",
			horde = "horde",
			normal = "normal",
			none = "None"
		},
		event_intensity = {
			high = "high",
			low = "low",
			none = "None"
		}
	},
	wwise_state_rules = {
		defeat = {
			next_states = {
				game_score = true
			}
		},
		victory = {
			next_states = {
				game_score = true
			}
		}
	}
}

return settings("WwiseGameSyncSettings", wwise_game_sync_settings)
