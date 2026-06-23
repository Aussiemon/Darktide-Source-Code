-- chunkname: @scripts/ui/views/character_appearance_view/character_appearance_view_settings.lua

local ArchetypeSettings = require("scripts/settings/archetype/archetype_settings")
local CharacterAppearanceViewArchetypePages = require("scripts/ui/views/character_appearance_view/character_appearance_view_archetype_pages")
local AREA_WIDTH = 600
local AREA_HEIGHT = 642
local SET_TO_NIL = "__NIL_VALUE__"
local LEVEL_NAMES = {
	default = "content/levels/ui/character_create/character_create",
}
local LEVEL_NAMES_ARCHETYPE_OVERRIDES = {
	broker = {
		home_planet = "content/levels/ui/cartel_selection/cartel_selection",
	},
	cryptic = {
		default = "content/levels/ui/character_create_cryptic/character_create_cryptic",
		home_planet = "content/levels/ui/forgeworld_selection/forgeworld_selection",
	},
}
local BARBER_LEVEL_NAMES = {
	appearance = "content/levels/ui/barber_character_appearance/barber_character_appearance",
	companion_appearance = "content/levels/ui/barber_character_appearance/barber_character_appearance",
	default = "content/levels/ui/barber_character_mindwipe/barber_character_mindwipe",
}
local BARBER_LEVEL_NAMES_ARCHETYPE_OVERRIDES = {
	broker = {
		home_planet = "content/levels/ui/cartel_selection/cartel_selection",
	},
	cryptic = {
		default = "content/levels/ui/barber_character_appearance_cryptic/barber_character_appearance_cryptic",
		home_planet = "content/levels/ui/forgeworld_selection/forgeworld_selection",
		appearance = SET_TO_NIL,
		companion_appearance = SET_TO_NIL,
	},
}
local level_names = {}
local barber_level_names = {}
local EMPTY_TABLE = {}

for archetype_name, _ in pairs(ArchetypeSettings.archetype_names) do
	local level_per_page = table.clone(LEVEL_NAMES)
	local barber_level_per_page = table.clone(BARBER_LEVEL_NAMES)
	local level_overrides = LEVEL_NAMES_ARCHETYPE_OVERRIDES[archetype_name] or EMPTY_TABLE
	local barber_level_overrides = BARBER_LEVEL_NAMES_ARCHETYPE_OVERRIDES[archetype_name] or EMPTY_TABLE

	for page, level_path in pairs(level_overrides) do
		if level_path == SET_TO_NIL then
			level_per_page[page] = nil
		else
			level_per_page[page] = level_path
		end
	end

	for page, level_path in pairs(barber_level_overrides) do
		if level_path == SET_TO_NIL then
			barber_level_per_page[page] = nil
		else
			barber_level_per_page[page] = level_path
		end
	end

	level_names[archetype_name] = level_per_page
	barber_level_names[archetype_name] = barber_level_per_page
end

local character_appearance_view_settings = {
	back_row_additional_spacing_depth = 1.2,
	back_row_additional_spacing_width = 0.3,
	character_spacing_width = 1.6,
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
		AREA_WIDTH,
		AREA_HEIGHT,
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
	level_names = level_names,
	shading_environments = {
		default = {
			default = "content/shading_environments/ui/character_create",
		},
		archetype_overrides = {
			broker = {
				home_planet = "content/shading_environments/ui/cartel_selection",
			},
			cryptic = {
				default = "content/shading_environments/ui/character_create",
				home_planet = "content/shading_environments/ui/forge_world_selection",
			},
		},
	},
	barber_level_names = barber_level_names,
	barber_shading_environments = {
		default = {
			default = "content/shading_environments/ui/barber_character_appearance",
		},
		archetype_overrides = {
			broker = {
				home_planet = "content/shading_environments/ui/cartel_selection",
			},
			cryptic = {
				home_planet = "content/shading_environments/ui/forge_world_selection",
			},
		},
	},
	state_machines = {
		default = {},
	},
	barber_state_machines = {
		default = {
			default = {
				cryptic = nil,
				human = "content/characters/player/human/third_person/animations/menu/mindwipe",
				ogryn = "content/characters/player/ogryn/third_person/animations/menu/mindwipe",
			},
			appearance = {
				cryptic = nil,
				human = nil,
				ogryn = nil,
			},
			companion_appearance = {
				cryptic = nil,
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
			animations_per_page = {
				default = {
					default_event = "character_creation_idle",
					zoom_events = {
						slot_body_face = "character_creation_idle_head",
					},
				},
			},
		},
		broker = {
			animations_per_page = {
				default = {
					default_event = "character_creation_idle",
					zoom_events = {
						slot_body_face = "character_creation_idle_head",
					},
				},
			},
		},
		cryptic = {
			animations_per_page = {
				default = {
					barber_default_event = nil,
					barber_zoom_events = nil,
					default_event = "character_creation_idle",
					zoom_events = {
						slot_body_arms = "character_creation_idle_head",
						slot_body_face = "character_creation_idle_head",
						slot_body_legs = "character_creation_idle_head",
						slot_body_torso = "character_creation_idle",
					},
				},
				name = {
					barber_default_event = "character_creation_idle",
					default_event = "character_creation_idle_standing",
					zoom_events = {},
					barber_zoom_events = {},
				},
			},
		},
		ogryn = {
			animations_per_page = {
				default = {
					default_event = "character_creation_idle",
					zoom_events = {
						slot_body_face = "character_creation_idle_head",
					},
				},
			},
		},
		psyker = {
			animations_per_page = {
				default = {
					default_event = "character_creation_idle",
					zoom_events = {
						slot_body_face = "character_creation_idle_head",
					},
				},
			},
		},
		veteran = {
			animations_per_page = {
				default = {
					default_event = "character_creation_idle",
					zoom_events = {
						slot_body_face = "character_creation_idle_head",
					},
				},
			},
		},
		zealot = {
			animations_per_page = {
				default = {
					default_event = "character_creation_idle",
					zoom_events = {
						slot_body_face = "character_creation_idle_head",
					},
				},
			},
		},
	},
	vo_events = {
		vendor_purchase = {
			"barber_purchase",
		},
		mindwipe_select = {
			"hub_mindwipe_select_option_a",
		},
		mindwipe_backstory = {
			"hub_mindwipe_backstory_a",
		},
		mindwipe_body_type = {
			"hub_mindwipe_body_type_a",
		},
		mindwipe_personality = {
			"hub_mindwipe_personality_a",
		},
		mindwipe_conclusion = {
			"hub_mindwipe_conclusion_a",
		},
		mindwipe_frequent_customer = {
			"hub_mindwipe_frequent_customer_a",
		},
	},
	restriction_datas = {
		source = {
			icon_texture = "content/ui/textures/icons/generic/placeholder_childhood",
			title = "loc_item_source_obtained_title",
			uses_source = true,
		},
		class = {
			icon_texture = "content/ui/textures/icons/generic/placeholder_childhood",
			unique_reason = true,
		},
		full_body_tattoo = {
			disabling_reason = true,
			title = "loc_character_create_full_body_tattoo_selected",
		},
	},
	eye_types = {
		{
			icon_texture = "content/ui/textures/icons/appearances/eyes/eyes_r1_l1",
			name = "no_blind",
			sort_order = 1,
			search_params = {
				eye_blindness = 0,
				scalera_brightness = 1,
			},
		},
		{
			icon_texture = "content/ui/textures/icons/appearances/eyes/eyes_r0_l1",
			name = "blind_left",
			sort_order = 2,
			search_params = {
				eye_blindness = 2,
				scalera_brightness = 1,
			},
		},
		{
			icon_texture = "content/ui/textures/icons/appearances/eyes/eyes_r1_l0",
			name = "blind_right",
			sort_order = 3,
			search_params = {
				eye_blindness = 1,
				scalera_brightness = 1,
			},
		},
		{
			icon_texture = "content/ui/textures/icons/appearances/eyes/eyes_r0_l0",
			name = "blind_both",
			sort_order = 4,
			search_params = {
				eye_blindness = 3,
				scalera_brightness = 1,
			},
		},
		{
			icon_texture = "content/ui/textures/icons/appearances/eyes/eyes_r2_l2",
			name = "black_scalera",
			sort_order = 5,
			search_params = {
				eye_blindness = 0,
				scalera_brightness = 0,
			},
		},
	},
	archetype_pages = CharacterAppearanceViewArchetypePages,
}

return settings("CharacterAppearanceViewSettings", character_appearance_view_settings)
