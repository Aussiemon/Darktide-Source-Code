-- chunkname: @scripts/settings/game_mode/game_mode_settings_shooting_range.lua

local settings = {
	default_player_side_name = "heroes",
	name = "shooting_range",
	host_singleplay = true,
	vaulting_allowed = true,
	bot_backfilling_allowed = false,
	class_file_name = "scripts/managers/game_mode/game_modes/game_mode_training_grounds",
	disable_hologram = true,
	use_side_color = false,
	states = {
		"loading",
		"in_game",
		"leaving_game",
		"training_complete"
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
		player_composition = "party"
	},
	hotkeys = {
		hotkey_system = "system_view"
	},
	default_init_scripted_scenario = {
		alias = "shooting_range",
		name = "init"
	}
}

return settings
