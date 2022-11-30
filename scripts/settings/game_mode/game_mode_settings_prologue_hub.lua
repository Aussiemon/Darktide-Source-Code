local settings = {
	use_prologue_profile = false,
	host_singleplay = true,
	use_hub_aim_extension = true,
	name = "prologue_hub",
	starting_character_state_name = "hub_jog",
	default_wielded_slot_name = "slot_unarmed",
	class_file_name = "scripts/managers/game_mode/game_modes/game_mode_prologue",
	use_third_person_hub_camera = true,
	use_foot_ik = true,
	cache_local_player_profile = false,
	bot_backfilling_allowed = false,
	default_player_orientation = "HubPlayerOrientation",
	use_side_color = false,
	disable_hologram = true,
	vaulting_allowed = false,
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
