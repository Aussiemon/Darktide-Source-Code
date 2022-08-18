local cinematic_scene_templates = {
	outro_fail = {
		randomize_weapon = true,
		local_player_only = false,
		include_bots = true,
		music = "defeat",
		ignored_slots = {
			"slot_unarmed",
			"slot_primary",
			"slot_secondary",
			"slot_pocketable",
			"slot_luggable",
			"slot_support_ability",
			"slot_combat_ability",
			"slot_grenade_ability"
		}
	}
}

return cinematic_scene_templates
