-- chunkname: @scripts/settings/game_mode/game_mode_settings_survival.lua

local settings = {
	bot_backfilling_allowed = true,
	class_file_name = "scripts/managers/game_mode/game_modes/game_mode_survival",
	default_player_side_name = "heroes",
	host_singleplay = false,
	is_premium_feature = true,
	max_bots = 3,
	mission_end_grace_time_dead = 4,
	mission_end_grace_time_disabled = 10,
	name = "survival",
	use_side_color = false,
	vaulting_allowed = true,
	states = {
		"running",
		"about_to_fail_disabled",
		"about_to_fail_dead",
		"outro_cinematic",
		"done",
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
		health_percentage = 0.5,
		respawn_time = 20,
	},
	hud_settings = {
		player_composition = "game_session_players",
	},
	hotkeys = {
		hotkey_system = "system_view",
	},
	persistent_player_data_settings = {
		max_damage_percent_from_bot = 0.75,
		max_damage_percent_from_self = 1,
		max_permanent_damage_percent_from_bot = 0.75,
		max_permanent_damage_percent_from_self = 1,
		respawn_dead_from_character_states = {
			"hogtied",
			"dead",
			"knocked_down",
		},
	},
	afk_check = {
		ignore_disabled_players = true,
		location = "mission",
	},
}

return settings
