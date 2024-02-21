local settings = {
	use_prologue_profile = true,
	bot_backfilling_allowed = false,
	host_singleplay = true,
	name = "prologue",
	talents_disabled = true,
	class_file_name = "scripts/managers/game_mode/game_modes/game_mode_prologue",
	cache_local_player_profile = true,
	use_side_color = false,
	disable_hologram = true,
	vaulting_allowed = true,
	default_player_side_name = "heroes",
	is_prologue = true,
	states = {
		"running",
		"prologue_complete"
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
	hud_settings = {
		player_composition = "players"
	},
	hotkeys = {
		hotkey_system = "system_view"
	},
	human_controlled_initial_items_excluded_slots = {
		"slot_secondary"
	}
}

return settings
