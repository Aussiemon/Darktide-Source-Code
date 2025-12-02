-- chunkname: @scripts/settings/game_mode/game_mode_settings_prologue_hub.lua

local settings = {
	bot_backfilling_allowed = false,
	cache_local_player_profile = false,
	class_file_name = "scripts/managers/game_mode/game_modes/game_mode_prologue",
	default_player_orientation = "HubPlayerOrientation",
	default_player_side_name = "heroes",
	default_wielded_slot_name = "slot_unarmed",
	disable_hologram = true,
	host_singleplay = true,
	is_prologue = true,
	name = "prologue_hub",
	player_unit_template_name_override = "player_character_social_hub",
	starting_character_state_name = "hub_jog",
	use_foot_ik = true,
	use_prologue_profile = false,
	use_side_color = false,
	use_third_person_hub_camera = true,
	vaulting_allowed = false,
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
	side_sub_faction_types = {
		villains = {
			"chaos",
			"cultist",
			"renegade",
		},
	},
	hud_settings = {
		player_composition = "players",
	},
	hotkeys = {
		hotkey_inventory = "inventory_background_view",
		hotkey_system = "system_view",
	},
	default_inventory = {
		adamant = {
			slot_unarmed = "content/items/weapons/player/melee/unarmed_hub_human",
		},
		broker = {
			slot_unarmed = "content/items/weapons/player/melee/unarmed_hub_human",
		},
		ogryn = {
			slot_unarmed = "content/items/weapons/player/melee/unarmed_hub_ogryn",
		},
		psyker = {
			slot_unarmed = "content/items/weapons/player/melee/unarmed_hub_human",
		},
		veteran = {
			slot_unarmed = "content/items/weapons/player/melee/unarmed_hub_human",
		},
		zealot = {
			slot_unarmed = "content/items/weapons/player/melee/unarmed_hub_human",
		},
	},
}

return settings
