-- chunkname: @scripts/settings/cinematic_scene/templates/outro_fail_template.lua

local cinematic_scene_templates = {
	outro_fail = {
		hide_players = true,
		include_bots = true,
		is_skippable = false,
		local_player_only = false,
		mission_outro = false,
		music = "defeat",
		randomize_equipped_weapon = true,
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
