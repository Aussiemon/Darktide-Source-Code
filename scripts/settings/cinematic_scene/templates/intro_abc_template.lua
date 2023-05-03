local cinematic_scene_templates = {
	intro_abc = {
		is_skippable = false,
		use_transition_ui = false,
		local_player_only = false,
		instant_black_screen_during_cutscene_loading = false,
		music = "mission_intro",
		hide_players = true,
		set_random_weapon_event = true,
		randomize_equipped_weapon = true,
		hotjoin_only = true,
		include_bots = true,
		mission_outro = false,
		ignored_slots = {
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
