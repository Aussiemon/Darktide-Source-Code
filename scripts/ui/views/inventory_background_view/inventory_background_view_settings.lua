-- chunkname: @scripts/ui/views/inventory_background_view/inventory_background_view_settings.lua

local discard_items_popup_window_size = {
	800,
	800
}
local discard_items_popup_grid_size = {
	discard_items_popup_window_size[1] - 40,
	discard_items_popup_window_size[2] - 100
}
local inventory_background_view = {
	timer_name = "ui",
	total_blur_duration = 0.5,
	world_layer = 2,
	viewport_type = "default",
	camera_time = 0.5,
	default_slot = "slot_primary",
	shading_environment = "content/shading_environments/ui/inventory",
	viewport_name = "ui_inventory_viewport",
	viewport_layer = 1,
	level_name = "content/levels/ui/inventory/inventory",
	loadout_update_timeout = 3,
	world_name = "ui_inventory",
	discard_items_popup_window_size = discard_items_popup_window_size,
	discard_items_popup_grid_size = discard_items_popup_grid_size,
	allowed_slots = {
		"slot_primary",
		"slot_secondary"
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
		adamant = {
			initial_event = "character_customization_idle",
			events = {
				"character_customization_crime_select_idle",
				"character_customization_idle"
			}
		},
		psyker = {
			initial_event = "character_customization_idle",
			events = {
				"character_customization_crime_select_idle",
				"character_customization_idle"
			}
		},
		veteran = {
			initial_event = "character_customization_idle",
			events = {
				"character_customization_crime_select_idle",
				"character_customization_idle"
			}
		},
		zealot = {
			initial_event = "character_customization_idle",
			events = {
				"character_customization_crime_select_idle",
				"character_customization_idle"
			}
		},
		ogryn = {
			initial_event = "character_customization_idle",
			events = {
				"character_customization_crime_select_idle",
				"character_customization_idle"
			}
		}
	}
}

return settings("InventoryBackgroundViewSettings", inventory_background_view)
