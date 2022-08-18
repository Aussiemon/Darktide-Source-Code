local settings = {
	host_singleplay = true,
	bot_backfilling_allowed = false,
	is_prologue = true,
	name = "prologue",
	class_file_name = "scripts/managers/game_mode/game_modes/game_mode_coop_complete_objective",
	force_third_person_mode = false,
	use_side_color = false,
	specializations_disabled = true,
	disable_hologram = true,
	vaulting_allowed = true,
	default_player_side_name = "heroes",
	presence_name = "prologue",
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
