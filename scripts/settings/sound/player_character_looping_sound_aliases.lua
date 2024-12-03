-- chunkname: @scripts/settings/sound/player_character_looping_sound_aliases.lua

local PlayerCharacterLoopingSoundAliases = {
	ability_no_target_activating = {
		start = {
			event_alias = "play_ability_no_target_activating",
		},
		stop = {
			event_alias = "stop_ability_no_target_activating",
		},
	},
	ability_target_activating = {
		start = {
			event_alias = "play_ability_target_activating",
		},
		stop = {
			event_alias = "stop_ability_target_activating",
		},
	},
	catapulted = {
		start = {
			event_alias = "play_catapulted",
		},
		stop = {
			event_alias = "stop_catapulted",
		},
	},
	knocked_down = {
		start = {
			event_alias = "play_knocked_down",
		},
		stop = {
			event_alias = "stop_knocked_down",
		},
	},
	netted = {
		start = {
			event_alias = "play_netted",
		},
		stop = {
			event_alias = "stop_netted",
		},
	},
	ranged_charging = {
		has_husk_events = true,
		start = {
			event_alias = "play_ranged_charging",
		},
		stop = {
			event_alias = "stop_ranged_charging",
		},
	},
	ranged_fast_charging = {
		has_husk_events = true,
		start = {
			event_alias = "play_ranged_fast_charging",
		},
		stop = {
			event_alias = "stop_ranged_fast_charging",
		},
	},
	weapon_temperature = {
		exclude_from_unit_data_components = true,
		has_husk_events = false,
		start = {
			event_alias = "play_weapon_temperature",
		},
		stop = {
			event_alias = "stop_weapon_temperature",
		},
	},
	ranged_shooting = {
		has_husk_events = true,
		start = {
			event_alias = "play_ranged_shooting",
		},
		stop = {
			event_alias = "stop_ranged_shooting",
		},
	},
	ranged_braced_shooting = {
		has_husk_events = true,
		start = {
			event_alias = "play_ranged_braced_shooting",
		},
		stop = {
			event_alias = "stop_ranged_braced_shooting",
		},
	},
	toughness_loop = {
		start = {
			event_alias = "play_toughness_loop",
		},
		stop = {
			event_alias = "stop_toughness_loop",
		},
	},
	melee_sticky_loop = {
		exclude_from_unit_data_components = true,
		has_husk_events = true,
		start = {
			event_alias = "play_melee_sticky_loop",
		},
		stop = {
			event_alias = "stop_melee_sticky_loop",
		},
	},
	ranged_plasma_venting = {
		has_husk_events = true,
		start = {
			event_alias = "play_ranged_plasma_venting",
		},
		stop = {
			event_alias = "stop_ranged_plasma_venting",
		},
	},
	player_slide_loop = {
		has_husk_events = true,
		start = {
			event_alias = "play_player_slide_loop",
		},
		stop = {
			event_alias = "stop_player_slide_loop",
		},
	},
	psyker_smite_charge = {
		has_husk_events = true,
		start = {
			event_alias = "play_psyker_smite_charge",
		},
		stop = {
			event_alias = "stop_psyker_smite_charge",
		},
	},
	weapon_special_loop = {
		exclude_from_unit_data_components = true,
		has_husk_events = true,
		start = {
			event_alias = "play_weapon_special_loop",
		},
		stop = {
			event_alias = "stop_weapon_special_loop",
		},
	},
	weapon_overload_loop = {
		exclude_from_unit_data_components = true,
		has_husk_events = true,
		start = {
			event_alias = "play_weapon_overload_loop",
		},
		stop = {
			event_alias = "stop_weapon_overload_loop",
		},
	},
	force_weapon_block_loop = {
		exclude_from_unit_data_components = true,
		has_husk_events = true,
		start = {
			event_alias = "play_force_weapon_block_loop",
		},
		stop = {
			event_alias = "stop_force_weapon_block_loop",
		},
	},
	wind_slash_stage_loop = {
		exclude_from_unit_data_components = true,
		has_husk_events = true,
		start = {
			event_alias = "play_wind_slash_stage_loop",
		},
		stop = {
			event_alias = "stop_wind_slash_stage_loop",
		},
	},
	interact_loop = {
		is_2d = true,
		is_exclusive = true,
		start = {
			event_alias = "play_interact_loop",
		},
		stop = {
			event_alias = "stop_interact_loop",
		},
	},
	equipped_item_passive_loop = {
		exclude_from_unit_data_components = true,
		has_husk_events = true,
		start = {
			event_alias = "play_equipped_item_passive",
		},
		stop = {
			event_alias = "stop_equipped_item_passive",
		},
	},
	sfx_minigame_loop = {
		start = {
			event_alias = "play_sfx_minigame_loop",
		},
		stop = {
			event_alias = "stop_sfx_minigame_loop",
		},
	},
}

return PlayerCharacterLoopingSoundAliases
