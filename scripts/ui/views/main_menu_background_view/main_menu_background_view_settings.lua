-- chunkname: @scripts/ui/views/main_menu_background_view/main_menu_background_view_settings.lua

local main_menu_background_view_settings = {
	back_row_additional_spacing_depth = 1.2,
	back_row_additional_spacing_width = 0.3,
	character_spacing_width = 1.6,
	debug_character_count = 4,
	level_name = "content/levels/ui/main_menu/main_menu",
	shading_environment = "content/shading_environments/ui/main_menu",
	timer_name = "ui",
	total_blur_duration = 0.5,
	viewport_layer = 1,
	viewport_name = "ui_main_menu_world_viewport",
	viewport_type = "default",
	world_layer = 1,
	world_name = "ui_main_menu_world",
	ignored_slots = {
		"slot_primary",
		"slot_secondary",
		"slot_pocketable",
		"slot_pocketable_small",
		"slot_luggable",
		"slot_combat_ability",
		"slot_grenade_ability",
	},
	animations_per_archetype = {
		psyker = {
			initial_event = "end_of_round_01",
			events = {
				"emote_psyker_01",
				"endorse_psyker_01",
			},
		},
		veteran = {
			initial_event = "end_of_round_02",
			events = {
				"emote_veteran_01",
				"endorse_veteran_01",
			},
		},
		zealot = {
			initial_event = "end_of_round_03",
			events = {
				"emote_zealot_01",
				"endorse_zealot_01",
			},
		},
		ogryn = {
			initial_event = "end_of_round_01",
			events = {
				"emote_ogryn_01",
				"endorse_ogryn_01",
			},
		},
	},
}

return settings("MainMenuBackgroundViewSettings", main_menu_background_view_settings)
