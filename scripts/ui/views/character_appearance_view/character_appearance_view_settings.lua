-- chunkname: @scripts/ui/views/character_appearance_view/character_appearance_view_settings.lua

local area_width = 600
local area_height = 642
local character_appearance_view_settings = {
	back_row_additional_spacing_depth = 1.2,
	back_row_additional_spacing_width = 0.3,
	character_spacing_width = 1.6,
	debug_character_count = 4,
	icons_visual_margin = 1000,
	scrollbar_width = 10,
	timer_name = "ui",
	total_blur_duration = 0.5,
	viewport_layer = 1,
	viewport_name = "ui_character_create_viewport",
	viewport_type = "default",
	world_layer = 2,
	world_name_prefix = "ui_character_create",
	grid_size = {
		area_width,
		area_height,
	},
	grid_spacing = {
		10,
		10,
	},
	grid_blur_edge_size = {
		8,
		8,
	},
	slot_icon_size = {
		90,
		90,
	},
	level_names = {
		default = {
			default = "content/levels/ui/character_create/character_create",
		},
		archetype_overrides = {
			broker = {
				crime = "content/levels/ui/cartel_selection/cartel_selection",
			},
		},
	},
	shading_environments = {
		default = {
			default = "content/shading_environments/ui/character_create",
		},
		archetype_overrides = {
			broker = {
				crime = "content/shading_environments/ui/cartel_selection",
			},
		},
	},
	barber_level_names = {
		default = {
			appearance = "content/levels/ui/barber_character_appearance/barber_character_appearance",
			companion_appearance = "content/levels/ui/barber_character_appearance/barber_character_appearance",
			default = "content/levels/ui/barber_character_mindwipe/barber_character_mindwipe",
		},
		archetype_overrides = {
			broker = {
				crime = "content/levels/ui/cartel_selection/cartel_selection",
			},
		},
	},
	barber_shading_environments = {
		default = {
			default = "content/shading_environments/ui/barber_character_appearance",
		},
		archetype_overrides = {
			broker = {
				crime = "content/shading_environments/ui/cartel_selection",
			},
		},
	},
	state_machines = {
		default = {},
	},
	barber_state_machines = {
		default = {
			default = {
				human = "content/characters/player/human/third_person/animations/menu/mindwipe",
				ogryn = "content/characters/player/ogryn/third_person/animations/menu/mindwipe",
			},
			appearance = {
				human = nil,
				ogryn = nil,
			},
		},
	},
	planet_offset = {
		1400,
		540,
	},
	area_grid_size = {
		480,
		670,
	},
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
			initial_event = "character_customization_idle",
			events = {
				body = "character_customization_idle",
				head = "character_customization_idle_head",
			},
		},
		ogryn = {
			initial_event = "character_customization_idle",
			events = {
				body = "character_customization_idle",
				head = "character_customization_idle_head",
			},
		},
		psyker = {
			initial_event = "character_customization_idle",
			events = {
				body = "character_customization_idle",
				head = "character_customization_idle_head",
			},
		},
		veteran = {
			initial_event = "character_customization_idle",
			events = {
				body = "character_customization_idle",
				head = "character_customization_idle_head",
			},
		},
		zealot = {
			initial_event = "character_customization_idle",
			events = {
				body = "character_customization_idle",
				head = "character_customization_idle_head",
			},
		},
		broker = {
			initial_event = "character_customization_idle",
			events = {
				body = "character_customization_idle",
				head = "character_customization_idle_head",
			},
		},
	},
	vo_event_vendor_purchase = {
		"barber_purchase",
	},
	vo_event_mindwipe_select = {
		"hub_mindwipe_select_option_a",
	},
	vo_event_mindwipe_backstory = {
		"hub_mindwipe_backstory_a",
	},
	vo_event_mindwipe_body_type = {
		"hub_mindwipe_body_type_a",
	},
	vo_event_mindwipe_personality = {
		"hub_mindwipe_personality_a",
	},
	vo_event_mindwipe_conclusion = {
		"hub_mindwipe_conclusion_a",
	},
	vo_event_mindwipe_frequent_customer = {
		"hub_mindwipe_frequent_customer_a",
	},
}

return settings("CharacterAppearanceViewSettings", character_appearance_view_settings)
