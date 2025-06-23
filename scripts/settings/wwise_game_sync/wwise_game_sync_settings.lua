-- chunkname: @scripts/settings/wwise_game_sync/wwise_game_sync_settings.lua

local DEFAULT_GROUP_STATE = "None"
local wwise_game_sync_settings = {
	music_state_reset_time = 2,
	combat_state_horde_high_minimum_aggroed_minions = 10,
	ambush_horde_trigger_distance = 80,
	combat_state_horde_low_minimum_aggroed_minions = 5,
	vector_horde_trigger_distance = 80,
	boss_trigger_distance = 80,
	default_group_state = DEFAULT_GROUP_STATE,
	minion_aggro_intensity_settings = {
		num_threshold_high = 16,
		num_threshold_medium = 8,
		query_radius = 30,
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
			credits = "credits",
			defeat = "defeat",
			mission_ready = "mission_ready",
			mission_intro = "mission_intro",
			victory = "victory",
			mission_outro = "mission_outro",
			mission_start = "mission_start",
			mission_loading = "mission_loading",
			loading = "loading",
			cinematic = "cinematic",
			game_start = "game_start",
			loadout_ready = "loadout_ready",
			none = DEFAULT_GROUP_STATE
		},
		music_zone = {
			zone_6 = "zone_6",
			hub = "hub",
			zone_7 = "zone_7",
			zone_5 = "zone_5",
			zone_2 = "zone_2",
			prologue = "prologue",
			zone_1 = "zone_1",
			zone_4 = "zone_4",
			zone_3 = "zone_3",
			none = DEFAULT_GROUP_STATE
		},
		music_combat = {
			horde_high = "horde_high",
			normal = "normal",
			boss = "boss",
			horde_low = "horde_low",
			none = DEFAULT_GROUP_STATE
		},
		music_objective = {
			collect_event = "collect_event",
			control_event = "control_event",
			fortification_event = "fortification_event",
			prologue_combat = "prologue_combat",
			hacking_event = "hacking_event",
			kill_event = "kill_event",
			demolition_event = "demolition_event",
			last_man_standing = "last_man_standing",
			escape_event = "escape_event",
			none = DEFAULT_GROUP_STATE
		},
		music_objective_progression = {
			two = "two",
			one = "one",
			three = "three",
			none = DEFAULT_GROUP_STATE
		},
		music_circumstance = {
			none = DEFAULT_GROUP_STATE
		},
		options = {
			credit_store_menu = "credit_store_menu",
			appearance_menu = "appearance_menu",
			credits = "credits",
			vendor_menu = "vendor_menu",
			story_mission_menu = "story_mission_menu",
			ingame_menu = "ingame_menu",
			none = DEFAULT_GROUP_STATE
		},
		minion_aggro_intensity = {
			high = "high",
			medium = "medium",
			low = "low",
			none = DEFAULT_GROUP_STATE
		},
		event_intensity = {
			high = "high",
			low = "low",
			none = DEFAULT_GROUP_STATE
		},
		player_state = {
			none = DEFAULT_GROUP_STATE,
			character_state = {
				consumed = "consumed",
				warp_grabbed = "warp_grabbed",
				knocked_down = "knocked_down",
				ledge_hanging = "hanging",
				catapulted = "catapulted",
				dead = "dead",
				netted = "netted",
				minigame = "auspex_scanner",
				mutant_charged = "mutant_charged",
				pounced = "pounced"
			},
			character_status = {
				last_wound = "last_wound"
			},
			interaction = {
				scanning = "auspex_scanner"
			}
		},
		suppression_state = {
			high = "high",
			low = "low",
			none = DEFAULT_GROUP_STATE
		}
	}
}

return settings("WwiseGameSyncSettings", wwise_game_sync_settings)
