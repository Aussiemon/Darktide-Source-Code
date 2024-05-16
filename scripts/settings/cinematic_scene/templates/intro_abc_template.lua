﻿-- chunkname: @scripts/settings/cinematic_scene/templates/intro_abc_template.lua

local cinematic_scene_templates = {
	intro_abc = {
		hide_players = true,
		hotjoin_only = true,
		include_bots = true,
		instant_black_screen_during_cutscene_loading = false,
		is_skippable = false,
		local_player_only = false,
		mission_outro = false,
		music = "mission_intro",
		randomize_equipped_weapon = true,
		set_random_weapon_event = true,
		use_transition_ui = false,
		ignored_slots = {
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
		available_inventory_animation_events = {
			"cin_ready",
			"unready_idle",
			"ready",
		},
		available_weapon_animation_events = {
			"hero_walk_01",
			"hero_walk_02",
		},
	},
}

return cinematic_scene_templates
