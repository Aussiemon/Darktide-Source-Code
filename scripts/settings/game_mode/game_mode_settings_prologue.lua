-- chunkname: @scripts/settings/game_mode/game_mode_settings_prologue.lua

local settings = {
	bot_backfilling_allowed = false,
	cache_local_player_profile = true,
	class_file_name = "scripts/managers/game_mode/game_modes/game_mode_prologue",
	default_player_side_name = "heroes",
	disable_hologram = true,
	host_singleplay = true,
	is_prologue = true,
	name = "prologue",
	talents_disabled = true,
	use_prologue_profile = true,
	use_side_color = false,
	vaulting_allowed = true,
	states = {
		"running",
		"prologue_complete",
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
	hud_settings = {
		player_composition = "players",
	},
	hotkeys = {
		hotkey_system = "system_view",
	},
	human_controlled_initial_items_excluded_slots = {
		"slot_secondary",
	},
}

return settings
