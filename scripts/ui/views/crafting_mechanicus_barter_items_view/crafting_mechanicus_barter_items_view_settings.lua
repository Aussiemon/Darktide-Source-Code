-- chunkname: @scripts/ui/views/crafting_mechanicus_barter_items_view/crafting_mechanicus_barter_items_view_settings.lua

local crafting_mechanicus_barter_items_view_settings = {
	level_name = "content/levels/ui/crafting_view_sacrifice/world",
	shading_environment = "content/shading_environments/ui/vendor_cosmetics_preview_gear",
	timer_name = "ui",
	total_blur_duration = 0.5,
	viewport_layer = 1,
	viewport_name = "ui_crafting_view_sacrifice_viewport",
	viewport_type = "default",
	world_layer = 10,
	world_name = "ui_crafting_view_sacrifice",
}

return settings("CraftingMechanicusBarterItemsViewSettings", crafting_mechanicus_barter_items_view_settings)
