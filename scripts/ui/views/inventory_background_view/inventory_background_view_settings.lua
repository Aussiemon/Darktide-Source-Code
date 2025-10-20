-- chunkname: @scripts/ui/views/inventory_background_view/inventory_background_view_settings.lua

local inventory_background_view = {
	camera_time = 0.5,
	default_slot = "slot_primary",
	level_name = "content/levels/ui/inventory/inventory",
	loadout_update_timeout = 3,
	shading_environment = "content/shading_environments/ui/inventory",
	timer_name = "ui",
	total_blur_duration = 0.5,
	viewport_layer = 1,
	viewport_name = "ui_inventory_viewport",
	viewport_type = "default",
	world_layer = 2,
	world_name = "ui_inventory",
	allowed_slots = {
		"slot_primary",
		"slot_secondary",
	},
	ignored_slots = {
		"slot_pocketable",
		"slot_pocketable_small",
		"slot_luggable",
		"slot_support_ability",
		"slot_combat_ability",
		"slot_grenade_ability",
	},
	allowed_duplicate_slots = {
		slot_animation_emote_1 = true,
		slot_animation_emote_2 = true,
		slot_animation_emote_3 = true,
		slot_animation_emote_4 = true,
		slot_animation_emote_5 = true,
	},
	allowed_empty_slots = {
		slot_attachment_1 = true,
		slot_attachment_2 = true,
		slot_attachment_3 = true,
	},
	ignored_validation_slots = {},
	animations_per_archetype = {
		adamant = {
			initial_event = "character_customization_idle",
			events = {
				"character_customization_crime_select_idle",
				"character_customization_idle",
			},
		},
		psyker = {
			initial_event = "character_customization_idle",
			events = {
				"character_customization_crime_select_idle",
				"character_customization_idle",
			},
		},
		veteran = {
			initial_event = "character_customization_idle",
			events = {
				"character_customization_crime_select_idle",
				"character_customization_idle",
			},
		},
		zealot = {
			initial_event = "character_customization_idle",
			events = {
				"character_customization_crime_select_idle",
				"character_customization_idle",
			},
		},
		ogryn = {
			initial_event = "character_customization_idle",
			events = {
				"character_customization_crime_select_idle",
				"character_customization_idle",
			},
		},
	},
}

return settings("InventoryBackgroundViewSettings", inventory_background_view)
