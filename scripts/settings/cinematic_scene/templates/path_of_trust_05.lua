local cinematic_scene_templates = {
	path_of_trust_05 = {
		is_skippable = true,
		use_transition_ui = false,
		local_player_only = true,
		wait_for_player_input = true,
		instant_black_screen_during_cutscene_loading = false,
		music = "cinematic_pot",
		hide_players = false,
		set_random_weapon_event = false,
		randomize_equipped_weapon = false,
		include_bots = false,
		mission_outro = false,
		ignored_slots = {
			"slot_unarmed",
			"slot_primary",
			"slot_secondary",
			"slot_pocketable",
			"slot_luggable",
			"slot_support_ability",
			"slot_combat_ability",
			"slot_grenade_ability"
		},
		popup_info = {
			header_text = "loc_popup_path_of_trust_cutscene_waiting_strategium_header",
			button_text = "loc_popup_button_path_of_trust_accept_cutscene",
			description_text = "loc_popup_path_of_trust_cutscene_waiting_strategium_description"
		}
	}
}

return cinematic_scene_templates
