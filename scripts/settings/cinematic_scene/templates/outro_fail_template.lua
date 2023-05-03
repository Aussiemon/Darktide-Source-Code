local cinematic_scene_templates = {
	outro_fail = {
		is_skippable = false,
		use_transition_ui = true,
		local_player_only = false,
		instant_black_screen_during_cutscene_loading = false,
		music = "defeat",
		hide_players = true,
		set_random_weapon_event = false,
		randomize_equipped_weapon = true,
		include_bots = true,
		mission_outro = false,
		ignored_slots = {
			"slot_primary",
			"slot_secondary",
			"slot_pocketable",
			"slot_luggable",
			"slot_support_ability",
			"slot_combat_ability",
			"slot_grenade_ability",
			"slot_attachment_1",
			"slot_attachment_2",
			"slot_attachment_3"
		},
		available_inventory_animation_events = {
			"cin_ready",
			"unready_idle",
			"ready"
		},
		available_weapon_animation_events = {
			"hero_walk_01",
			"hero_walk_02"
		}
	}
}

return cinematic_scene_templates
