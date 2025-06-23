-- chunkname: @scripts/ui/views/end_view/end_view_settings.lua

local end_view_settings = {
	viewport_name = "ui_end_world_viewport",
	back_row_additional_spacing_width = 0.3,
	total_blur_duration = 0.5,
	stay_in_party_vote_button = "hotkey_menu_special_1",
	viewport_type = "default",
	max_duration = 120,
	world_layer = 1,
	overlay_draw_layer = 300,
	character_spacing_width = 1.6,
	skip_grace_time = 0.5,
	back_row_additional_spacing_depth = 1.2,
	delay_before_summary = 5,
	timer_name = "ui",
	state_machine_id = "end_of_round_state_machine",
	min_delay_before_summary = 2,
	delay_after_summary = 10,
	alpha_fade_time = 0.15,
	viewport_layer = 1,
	stay_in_party_vote_text = "loc_eor_stay_in_party_vote_text",
	world_name = "ui_end_world",
	levels_by_id = {
		default = {
			shading_environment = "content/shading_environments/ui/ui_eor_background",
			level_name = "content/levels/ui/end_of_round/ui_eor_background"
		},
		horde = {
			shading_environment = "content/shading_environments/ui/ui_eor_background",
			level_name = "content/levels/ui/horde_end_of_round/horde_end_of_round"
		}
	},
	ignored_slots = {
		"slot_pocketable",
		"slot_pocketable_small",
		"slot_luggable",
		"slot_support_ability",
		"slot_combat_ability",
		"slot_grenade_ability"
	},
	animations_per_archetype = {
		psyker = {
			"eor_psyker_001",
			"eor_psyker_002",
			"eor_psyker_003",
			"eor_psyker_004",
			"eor_psyker_005"
		},
		veteran = {
			"eor_veteran_001",
			"eor_veteran_002",
			"eor_veteran_003",
			"eor_veteran_004",
			"eor_veteran_005"
		},
		zealot = {
			"eor_zealot_001",
			"eor_zealot_002",
			"eor_zealot_003",
			"eor_zealot_004",
			"eor_zealot_005"
		},
		ogryn = {
			"eor_ogryn_001",
			"eor_ogryn_002",
			"eor_ogryn_003",
			"eor_ogryn_004",
			"eor_ogryn_005"
		}
	},
	debrief_videos = {
		player_journey_011_B = "debriefing_16",
		player_journey_013_A = "debriefing_15",
		player_journey_07_A = "debriefing_07",
		player_journey_05 = "debriefing_05",
		player_journey_08 = "debriefing_10",
		player_journey_06_B = "debriefing_08",
		player_journey_014 = "debriefing_17",
		player_journey_06_A = "debriefing_06",
		player_journey_01 = "debriefing_01",
		player_journey_010 = "debriefing_12",
		player_journey_011_A = "debriefing_13",
		player_journey_012_A = "debriefing_14",
		player_journey_04 = "debriefing_04",
		player_journey_03 = "debriefing_03",
		player_journey_07_B = "debriefing_09",
		player_journey_02 = "debriefing_02",
		player_journey_09 = "debriefing_11"
	}
}

return settings("EndViewSettings", end_view_settings)
