﻿-- chunkname: @scripts/settings/cinematic_scene/templates/cutscene_5_hub.lua

local cinematic_scene_templates = {
	cutscene_5_hub = {
		hide_players = true,
		include_bots = false,
		is_skippable = true,
		local_player_only = true,
		mission_outro = false,
		music = "cinematic",
		randomize_equipped_weapon = false,
		set_random_weapon_event = false,
		use_transition_ui = true,
		ignored_slots = {
			"slot_primary",
			"slot_secondary",
			"slot_pocketable",
			"slot_pocketable_small",
			"slot_luggable",
			"slot_support_ability",
			"slot_combat_ability",
			"slot_grenade_ability",
			"slot_attachment_1",
			"slot_attachment_2",
			"slot_attachment_3",
		},
	},
}

return cinematic_scene_templates
