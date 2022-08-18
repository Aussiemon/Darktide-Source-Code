local main_menu_background_view_settings = {
	shading_environment = "content/shading_environments/ui/main_menu",
	debug_character_count = 4,
	total_blur_duration = 0.5,
	timer_name = "ui",
	viewport_type = "default",
	back_row_additional_spacing_width = 0.3,
	viewport_name = "ui_main_menu_world_viewport",
	viewport_layer = 1,
	character_spacing_width = 1.6,
	level_name = "content/levels/ui/main_menu/main_menu",
	world_layer = 1,
	back_row_additional_spacing_depth = 1.2,
	world_name = "ui_main_menu_world",
	ignored_slots = {
		"slot_primary",
		"slot_secondary",
		"slot_pocketable",
		"slot_luggable",
		"slot_support_ability",
		"slot_combat_ability",
		"slot_grenade_ability"
	},
	animations_per_archetype = {
		psyker = {
			initial_event = "end_of_round_01",
			events = {
				"emote_psyker_01",
				"endorse_psyker_01"
			}
		},
		veteran = {
			initial_event = "end_of_round_02",
			events = {
				"emote_veteran_01",
				"endorse_veteran_01"
			}
		},
		zealot = {
			initial_event = "end_of_round_03",
			events = {
				"emote_zealot_01",
				"endorse_zealot_01"
			}
		},
		ogryn = {
			initial_event = "end_of_round_01",
			events = {
				"emote_ogryn_01",
				"endorse_ogryn_01"
			}
		}
	}
}

return settings("MainMenuBackgroundViewSettings", main_menu_background_view_settings)
