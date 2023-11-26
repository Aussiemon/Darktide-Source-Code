-- chunkname: @scripts/settings/game_mode/game_mode_settings_hub.lua

local settings = {
	default_player_orientation = "HubPlayerOrientation",
	name = "hub",
	use_hub_aim_extension = true,
	class_file_name = "scripts/managers/game_mode/game_modes/game_mode_coop_complete_objective",
	starting_character_state_name = "hub_jog",
	use_third_person_hub_camera = true,
	use_foot_ik = true,
	host_singleplay = false,
	bot_backfilling_allowed = false,
	use_side_color = false,
	player_unit_template_name_override = "player_character_social_hub",
	is_social_hub = true,
	disable_hologram = true,
	vaulting_allowed = false,
	default_player_side_name = "heroes",
	default_wielded_slot_name = "slot_unarmed",
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
		player_composition = "party"
	},
	hotkeys = {
		hotkey_inventory = "inventory_background_view",
		hotkey_system = "system_view"
	},
	default_inventory = {
		ogryn = {
			slot_unarmed = "content/items/weapons/player/melee/unarmed_hub_ogryn"
		},
		psyker = {
			slot_unarmed = "content/items/weapons/player/melee/unarmed_hub_psyker"
		},
		veteran = {
			slot_unarmed = "content/items/weapons/player/melee/unarmed_hub_veteran"
		},
		zealot = {
			slot_unarmed = "content/items/weapons/player/melee/unarmed_hub_zealot"
		}
	},
	afk_check = {
		include_menu_activity = true,
		location = "hub"
	}
}

return settings
