local settings = {
	class_file_name = "scripts/managers/game_mode/game_modes/game_mode_coop_complete_objective",
	name = "hub",
	use_hub_aim_extension = true,
	default_wielded_slot_name = "slot_unarmed",
	starting_character_state_name = "hub_jog",
	use_third_person_hub_camera = true,
	use_foot_ik = true,
	host_singleplay = false,
	presence_name = "hub",
	bot_backfilling_allowed = false,
	force_third_person_mode = true,
	use_side_color = false,
	disable_hologram = true,
	vaulting_allowed = false,
	default_player_side_name = "heroes",
	default_player_orientation = "HubPlayerOrientation",
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
	}
}

return settings
