-- chunkname: @scripts/settings/game_mode/game_mode_settings_survival.lua

local settings = {
	host_singleplay = false,
	bot_backfilling_allowed = true,
	name = "survival",
	class_file_name = "scripts/managers/game_mode/game_modes/game_mode_survival",
	is_premium_feature = true,
	mission_end_grace_time_dead = 4,
	mission_end_grace_time_disabled = 10,
	use_side_color = false,
	max_bots = 3,
	vaulting_allowed = true,
	default_player_side_name = "heroes",
	states = {
		"running",
		"about_to_fail_disabled",
		"about_to_fail_dead",
		"outro_cinematic",
		"done"
	},
	side_compositions = {
		{
			name = "heroes",
			color_name = "blue",
			relations = {
				enemy = {
					"villains"
				}
			}
		},
		{
			name = "villains",
			color_name = "red",
			relations = {
				enemy = {
					"heroes"
				}
			}
		}
	},
	side_sub_faction_types = {
		villains = {
			"chaos",
			"cultist",
			"renegade"
		}
	},
	spawn = {
		grenade_percentage = 1,
		health_percentage = 1,
		ammo_percentage = 1
	},
	respawn = {
		grenade_percentage = 0,
		respawn_time = 20,
		health_percentage = 0.5,
		ammo_percentage = 0.5
	},
	hud_settings = {
		player_composition = "game_session_players"
	},
	hotkeys = {
		hotkey_system = "system_view"
	},
	persistent_player_data_settings = {
		max_permanent_damage_percent_from_bot = 0.75,
		max_damage_percent_from_self = 1,
		max_permanent_damage_percent_from_self = 1,
		max_damage_percent_from_bot = 0.75,
		respawn_dead_from_character_states = {
			"hogtied",
			"dead",
			"knocked_down"
		}
	},
	afk_check = {
		ignore_disabled_players = true,
		location = "mission"
	}
}

return settings
