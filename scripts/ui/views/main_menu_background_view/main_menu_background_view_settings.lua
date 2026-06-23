-- chunkname: @scripts/ui/views/main_menu_background_view/main_menu_background_view_settings.lua

local main_menu_background_view_settings = {
	back_row_additional_spacing_depth = 1.2,
	back_row_additional_spacing_width = 0.3,
	character_spacing_width = 1.6,
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
		adamant = {
			initial_event = "main_menu_idle",
		},
		cryptic = {
			initial_event = "main_menu_idle",
		},
		ogryn = {
			initial_event = "main_menu_idle",
		},
		psyker = {
			initial_event = "main_menu_idle",
		},
		veteran = {
			initial_event = "main_menu_idle",
		},
		zealot = {
			initial_event = "main_menu_idle",
		},
		broker = {
			initial_event = "main_menu_idle",
		},
	},
}

return settings("MainMenuBackgroundViewSettings", main_menu_background_view_settings)
