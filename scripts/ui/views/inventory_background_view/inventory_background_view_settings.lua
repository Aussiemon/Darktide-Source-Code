local inventory_background_view = {
	shading_environment = "content/shading_environments/ui/inventory",
	world_layer = 2,
	total_blur_duration = 0.5,
	timer_name = "ui",
	viewport_type = "default",
	viewport_name = "ui_inventory_viewport",
	viewport_layer = 1,
	level_name = "content/levels/ui/inventory/inventory",
	world_name = "ui_inventory",
	ignored_slots = {
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
