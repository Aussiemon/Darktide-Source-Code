-- chunkname: @scripts/settings/cinematic_scene/templates/cutscene_3.lua

local cinematic_scene_templates = {
	cutscene_3 = {
		is_skippable = true,
		local_player_only = true,
		use_transition_ui = true,
		music = "cinematic",
		hide_players = false,
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
