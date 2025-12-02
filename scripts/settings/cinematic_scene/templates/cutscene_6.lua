-- chunkname: @scripts/settings/cinematic_scene/templates/cutscene_6.lua

local cinematic_scene_templates = {
	cutscene_6 = {
		hide_players = false,
		include_bots = false,
		is_skippable = true,
		local_player_only = true,
		mission_outro = false,
		music = "cinematic",
		randomize_equipped_weapon = false,
		set_random_weapon_event = false,
		use_transition_ui = true,
		ignored_slots = {
			"slot_primary",
			"slot_pocketable",
			"slot_pocketable_small",
			"slot_luggable",
			"slot_combat_ability",
			"slot_grenade_ability",
			"slot_attachment_1",
			"slot_attachment_2",
			"slot_attachment_3",
		},
	},
}

return cinematic_scene_templates
