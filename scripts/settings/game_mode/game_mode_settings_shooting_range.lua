-- chunkname: @scripts/settings/game_mode/game_mode_settings_shooting_range.lua

local settings = {
	bot_backfilling_allowed = false,
	class_file_name = "scripts/managers/game_mode/game_modes/game_mode_training_grounds",
	default_player_side_name = "heroes",
	disable_hologram = true,
	host_singleplay = true,
	name = "shooting_range",
	use_side_color = false,
	vaulting_allowed = true,
	states = {
		"loading",
		"in_game",
		"leaving_game",
		"training_complete",
	},
	side_compositions = {
		{
			color_name = "blue",
			name = "heroes",
			relations = {
				enemy = {
					"villains",
				},
			},
		},
		{
			color_name = "red",
			name = "villains",
			relations = {
				enemy = {
					"heroes",
				},
			},
		},
	},
	side_sub_faction_types = {
		villains = {
			"chaos",
			"cultist",
			"renegade",
		},
	},
	hud_settings = {
		player_composition = "party",
	},
	hotkeys = {
		hotkey_system = "system_view",
	},
	default_init_scripted_scenario = {
		alias = "shooting_range",
		name = "init",
	},
}

return settings
