local area_width = 600
local area_height = 642
local character_appearance_view_settings = {
	scrollbar_width = 10,
	timer_name = "ui",
	total_blur_duration = 0.5,
	world_layer = 2,
	viewport_type = "default",
	barber_level_name = "content/levels/ui/barber_character_appearance/barber_character_appearance",
	character_spacing_width = 1.6,
	back_row_additional_spacing_width = 0.3,
	icons_visual_margin = 1000,
	shading_environment = "content/shading_environments/ui/character_create",
	debug_character_count = 4,
	back_row_additional_spacing_depth = 1.2,
	viewport_name = "ui_character_create_viewport",
	viewport_layer = 1,
	level_name = "content/levels/ui/character_create/character_create",
	barber_shading_environment = "content/shading_environments/ui/barber_character_appearance",
	world_name = "ui_character_create",
	grid_size = {
		area_width,
		area_height
	},
	grid_spacing = {
		10,
		10
	},
	grid_blur_edge_size = {
		8,
		8
	},
	slot_icon_size = {
		90,
		90
	},
	planet_offset = {
		1400,
		540
	},
	area_grid_size = {
		480,
		670
	},
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
			initial_event = "character_customization_idle",
			events = {
				body = "character_customization_idle",
				head = "character_customization_idle_head"
			}
		},
		veteran = {
			initial_event = "character_customization_idle",
			events = {
				body = "character_customization_idle",
				head = "character_customization_idle_head"
			}
		},
		zealot = {
			initial_event = "character_customization_idle",
			events = {
				body = "character_customization_idle",
				head = "character_customization_idle_head"
			}
		},
		ogryn = {
			initial_event = "character_customization_idle",
			events = {
				body = "character_customization_idle",
				head = "character_customization_idle_head"
			}
		}
	},
	vo_event_vendor_purchase = {
		"barber_purchase"
	}
}

return settings("CharacterAppearanceViewSettings", character_appearance_view_settings)
