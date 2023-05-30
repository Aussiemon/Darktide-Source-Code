local cosmetics_inspect_view_settings = {
	shading_environment = "content/shading_environments/ui/inventory",
	world_layer = 1,
	total_blur_duration = 0.5,
	timer_name = "ui",
	viewport_type = "default",
	grid_height = 840,
	viewport_name = "ui_cosmetics_inspect_preview_viewport",
	viewport_layer = 1,
	level_name = "content/levels/ui/cosmetics_preview/cosmetics_preview",
	weapon_spawn_depth = 1.2,
	world_name = "ui_cosmetics_inspect_preview",
	ignored_slots = {
		"slot_primary",
		"slot_pocketable",
		"slot_luggable",
		"slot_support_ability",
		"slot_combat_ability",
		"slot_grenade_ability"
	}
}

return settings("CosmeticsInspectViewSettings", cosmetics_inspect_view_settings)
