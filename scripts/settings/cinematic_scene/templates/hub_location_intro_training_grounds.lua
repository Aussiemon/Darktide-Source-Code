-- chunkname: @scripts/settings/cinematic_scene/templates/hub_location_intro_training_grounds.lua

local cinematic_scene_templates = {
	hub_location_intro_training_grounds = {
		is_skippable = true,
		local_player_only = true,
		use_transition_ui = false,
		music = "cinematic_pot",
		hide_players = true,
		set_random_weapon_event = false,
		randomize_equipped_weapon = false,
		include_bots = false,
		mission_outro = false,
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
			"slot_attachment_3"
		}
	}
}

return cinematic_scene_templates
