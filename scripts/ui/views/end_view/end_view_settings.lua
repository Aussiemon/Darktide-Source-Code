﻿-- chunkname: @scripts/ui/views/end_view/end_view_settings.lua

local end_view_settings = {
	alpha_fade_time = 0.15,
	back_row_additional_spacing_depth = 1.2,
	back_row_additional_spacing_width = 0.3,
	character_spacing_width = 1.6,
	delay_after_summary = 10,
	delay_before_summary = 5,
	max_duration = 120,
	min_delay_before_summary = 2,
	overlay_draw_layer = 300,
	skip_grace_time = 0.5,
	state_machine_id = "end_of_round_state_machine",
	stay_in_party_vote_button = "hotkey_menu_special_1",
	stay_in_party_vote_text = "loc_eor_stay_in_party_vote_text",
	timer_name = "ui",
	total_blur_duration = 0.5,
	viewport_layer = 1,
	viewport_name = "ui_end_world_viewport",
	viewport_type = "default",
	world_layer = 1,
	world_name = "ui_end_world",
	levels_by_id = {
		default = {
			level_name = "content/levels/ui/end_of_round/ui_eor_background",
			shading_environment = "content/shading_environments/ui/ui_eor_background",
		},
		horde = {
			level_name = "content/levels/ui/horde_end_of_round/horde_end_of_round",
			shading_environment = "content/shading_environments/ui/ui_eor_background",
		},
	},
	ignored_slots = {
		"slot_pocketable",
		"slot_pocketable_small",
		"slot_luggable",
		"slot_support_ability",
		"slot_combat_ability",
		"slot_grenade_ability",
	},
	animations_per_archetype = {
		psyker = {
			"eor_psyker_001",
			"eor_psyker_002",
			"eor_psyker_003",
			"eor_psyker_004",
			"eor_psyker_005",
		},
		veteran = {
			"eor_veteran_001",
			"eor_veteran_002",
			"eor_veteran_003",
			"eor_veteran_004",
			"eor_veteran_005",
		},
		zealot = {
			"eor_zealot_001",
			"eor_zealot_002",
			"eor_zealot_003",
			"eor_zealot_004",
			"eor_zealot_005",
		},
		ogryn = {
			"eor_ogryn_001",
			"eor_ogryn_002",
			"eor_ogryn_003",
			"eor_ogryn_004",
			"eor_ogryn_005",
		},
	},
}

return settings("EndViewSettings", end_view_settings)
