local cinematic_scene_templates = {
	traitor_captain_intro = {
		is_skippable = false,
		use_transition_ui = true,
		local_player_only = false,
		instant_black_screen_during_cutscene_loading = false,
		music = "cinematic_pot",
		hide_players = true,
		set_random_weapon_event = false,
		randomize_equipped_weapon = false,
		include_bots = true,
		mission_outro = false,
		ignored_slots = {
			"slot_unarmed",
			"slot_pocketable",
			"slot_luggable",
			"slot_support_ability",
			"slot_combat_ability",
			"slot_grenade_ability"
		}
	}
}

return cinematic_scene_templates
