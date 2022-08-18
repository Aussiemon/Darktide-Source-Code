local end_view_settings = {
	level_name = "content/levels/ui/end_of_round/ui_eor_background",
	viewport_name = "ui_end_world_viewport",
	total_blur_duration = 0.5,
	shading_environment = "content/shading_environments/ui/ui_eor_background",
	viewport_type = "default",
	max_duration = 45,
	world_layer = 1,
	overlay_draw_layer = 300,
	character_spacing_width = 1.6,
	back_row_additional_spacing_depth = 1.2,
	delay_before_summary = 5,
	timer_name = "ui",
	state_machine_id = "end_of_round_state_machine",
	min_delay_before_summary = 2,
	alpha_fade_time = 0.15,
	viewport_layer = 1,
	back_row_additional_spacing_width = 0.3,
	world_name = "ui_end_world",
	ignored_slots = {
		"slot_pocketable",
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
	}
}

return settings("EndViewSettings", end_view_settings)
