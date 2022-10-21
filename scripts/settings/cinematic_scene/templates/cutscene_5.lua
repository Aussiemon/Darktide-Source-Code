local cinematic_scene_templates = {
	cutscene_5 = {
		randomize_weapon = false,
		local_player_only = true,
		include_bots = false,
		music = "cinematic",
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
