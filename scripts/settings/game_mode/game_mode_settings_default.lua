local settings = {
	default_player_side_name = "heroes",
	name = "default",
	host_singleplay = false,
	presence_name = "mission",
	vaulting_allowed = true,
	bot_backfilling_allowed = false,
	class_file_name = "scripts/managers/game_mode/game_modes/game_mode_coop_complete_objective",
	force_third_person_mode = false,
	use_side_color = false,
	states = {
		"start_state",
		"second_state",
		"third_state"
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
		health_percentage = 1,
		time = 60,
		ammo_percentage = 0.5
	},
	hud_settings = {
		player_composition = "players"
	},
	hotkeys = {
		hotkey_system = "system_view"
	}
}

return settings
