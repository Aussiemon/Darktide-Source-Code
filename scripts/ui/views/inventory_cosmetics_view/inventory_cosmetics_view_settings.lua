-- chunkname: @scripts/ui/views/inventory_cosmetics_view/inventory_cosmetics_view_settings.lua

local grid_size = {
	424,
	750
}
local grid_width = grid_size[1]
local grid_height = grid_size[2]
local grid_spacing = {
	20,
	20
}
local mask_size = {
	grid_width + grid_spacing[1] * 4,
	grid_height
}
local inventory_cosmetics_view = {
	stats_spacing = 30,
	total_blur_duration = 0.5,
	timer_name = "ui",
	viewport_type = "default",
	world_layer = 35,
	scrollbar_width = 7,
	trait_spacing = -10,
	item_discard_hold_duration = 0.3,
	item_discard_anim_duration = 0.3,
	shading_environment = "content/shading_environments/ui/inventory",
	viewport_name = "ui_cosmetics_preview_viewport",
	viewport_layer = 1,
	stats_anim_duration = 1,
	level_name = "content/levels/ui/cosmetics_preview/cosmetics_preview",
	weapon_spawn_depth = 1.2,
	world_name = "ui_cosmetics_preview",
	ignored_slots = {
		"slot_primary",
		"slot_pocketable",
		"slot_pocketable_small",
		"slot_luggable",
		"slot_support_ability",
		"slot_combat_ability",
		"slot_grenade_ability"
	},
	grid_spacing = grid_spacing,
	grid_size = grid_size,
	mask_size = mask_size,
	stats_size = {
		440,
		6
	},
	trait_size = {
		64,
		64
	}
}

return settings("InventoryCosmeticsViewSettings", inventory_cosmetics_view)
