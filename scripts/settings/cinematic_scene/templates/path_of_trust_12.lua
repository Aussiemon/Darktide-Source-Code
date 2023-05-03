local cinematic_scene_templates = {
	path_of_trust_12 = {
		is_skippable = true,
		use_transition_ui = false,
		local_player_only = true,
		instant_black_screen_during_cutscene_loading = false,
		music = "cinematic_pot",
		hide_players = false,
		set_random_weapon_event = false,
		randomize_equipped_weapon = false,
		include_bots = false,
		mission_outro = false,
		ignored_slots = {
			"slot_primary",
			"slot_pocketable",
			"slot_luggable",
			"slot_support_ability",
			"slot_combat_ability",
			"slot_grenade_ability",
			"slot_attachment_1",
			"slot_attachment_2",
			"slot_attachment_3"
		}
	}
}

return cinematic_scene_templates
