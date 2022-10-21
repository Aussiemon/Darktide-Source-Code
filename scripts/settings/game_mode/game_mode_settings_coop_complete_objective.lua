local settings = {
	bot_backfilling_allowed = true,
	host_singleplay = false,
	name = "coop_complete_objective",
	class_file_name = "scripts/managers/game_mode/game_modes/game_mode_coop_complete_objective",
	mission_end_grace_time_dead = 4,
	mission_end_grace_time_disabled = 10,
	use_side_color = false,
	max_bots = 3,
	vaulting_allowed = true,
	default_player_side_name = "heroes",
	presence_name = "mission",
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
		max_permanent_damage_percent = 0.75,
		max_damage_percent = 0.75
	}
}

return settings
