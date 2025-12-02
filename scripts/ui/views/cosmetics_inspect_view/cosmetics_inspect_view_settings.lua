-- chunkname: @scripts/ui/views/cosmetics_inspect_view/cosmetics_inspect_view_settings.lua

local cosmetics_inspect_view_settings = {
	grid_height = 840,
	level_name = "content/levels/ui/cosmetics_preview/cosmetics_preview",
	shading_environment = "content/shading_environments/ui/inventory",
	timer_name = "ui",
	total_blur_duration = 0.5,
	viewport_layer = 1,
	viewport_name = "ui_cosmetics_inspect_preview_viewport",
	viewport_type = "default",
	weapon_spawn_depth = 1.2,
	world_layer = 1,
	world_name = "ui_cosmetics_inspect_preview",
	ignored_slots = {
		"slot_primary",
		"slot_pocketable",
		"slot_pocketable_small",
		"slot_luggable",
		"slot_combat_ability",
		"slot_grenade_ability",
	},
}

return settings("CosmeticsInspectViewSettings", cosmetics_inspect_view_settings)
