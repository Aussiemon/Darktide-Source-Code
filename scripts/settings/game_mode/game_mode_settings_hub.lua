-- chunkname: @scripts/settings/game_mode/game_mode_settings_hub.lua

local settings = {
	bot_backfilling_allowed = false,
	class_file_name = "scripts/managers/game_mode/game_modes/game_mode_coop_complete_objective",
	default_player_orientation = "HubPlayerOrientation",
	default_player_side_name = "heroes",
	default_wielded_slot_name = "slot_unarmed",
	disable_hologram = true,
	host_singleplay = false,
	is_premium_feature = true,
	is_social_hub = true,
	name = "hub",
	player_unit_template_name_override = "player_character_social_hub",
	starting_character_state_name = "hub_jog",
	use_foot_ik = true,
	use_hub_aim_extension = true,
	use_side_color = false,
	use_third_person_hub_camera = true,
	vaulting_allowed = false,
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
	hud_settings = {
		player_composition = "party",
	},
	hotkeys = {
		hotkey_inventory = "inventory_background_view",
		hotkey_system = "system_view",
	},
	default_inventory = {
		ogryn = {
			slot_unarmed = "content/items/weapons/player/melee/unarmed_hub_ogryn",
		},
		psyker = {
			slot_unarmed = "content/items/weapons/player/melee/unarmed_hub_psyker",
		},
		veteran = {
			slot_unarmed = "content/items/weapons/player/melee/unarmed_hub_veteran",
		},
		zealot = {
			slot_unarmed = "content/items/weapons/player/melee/unarmed_hub_zealot",
		},
	},
	afk_check = {
		include_menu_activity = true,
		location = "hub",
	},
}

return settings
