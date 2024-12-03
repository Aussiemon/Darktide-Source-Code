-- chunkname: @scripts/settings/cinematic_scene/templates/path_of_trust_03.lua

local cinematic_scene_templates = {
	path_of_trust_03 = {
		hide_players = false,
		include_bots = false,
		is_skippable = true,
		local_player_only = true,
		mission_outro = false,
		music = "cinematic_pot",
		randomize_equipped_weapon = false,
		set_random_weapon_event = false,
		use_transition_ui = false,
		wait_for_player_input = true,
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
		popup_info = {
			button_text = "loc_popup_cutscene_strategium_accept_button",
			description_text = "loc_popup_cutscene_waiting_strategium_description",
			header_text = "loc_popup_cutscene_waiting_strategium_header",
		},
	},
}

return cinematic_scene_templates
