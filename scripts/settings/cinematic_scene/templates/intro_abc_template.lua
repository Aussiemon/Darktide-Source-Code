local cinematic_scene_templates = {
	intro_abc = {
		local_player_only = false,
		hotjoin_only = true,
		randomize_weapon = true,
		include_bots = true,
		music = "mission_intro",
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
