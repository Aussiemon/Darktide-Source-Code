-- chunkname: @scripts/settings/game_mode/game_mode_settings_default.lua

local settings = {
	bot_backfilling_allowed = false,
	class_file_name = "scripts/managers/game_mode/game_modes/game_mode_coop_complete_objective",
	default_player_side_name = "heroes",
	host_singleplay = false,
	name = "default",
	use_side_color = false,
	vaulting_allowed = true,
	states = {
		"start_state",
		"second_state",
		"third_state",
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
	spawn = {
		ammo_percentage = 1,
		grenade_percentage = 1,
		health_percentage = 1,
	},
	respawn = {
		ammo_percentage = 0.5,
		grenade_percentage = 0,
		health_percentage = 1,
		time = 60,
	},
	hud_settings = {
		player_composition = "players",
	},
	hotkeys = {
		hotkey_system = "system_view",
	},
}

return settings
