-- chunkname: @scripts/ui/views/crafting_mechanicus_barter_items_view/crafting_mechanicus_barter_items_view_settings.lua

local crafting_mechanicus_barter_items_view_settings = {
	world_layer = 10,
	shading_environment = "content/shading_environments/ui/vendor_cosmetics_preview_gear",
	total_blur_duration = 0.5,
	timer_name = "ui",
	viewport_type = "default",
	viewport_name = "ui_crafting_view_sacrifice_viewport",
	viewport_layer = 1,
	level_name = "content/levels/ui/crafting_view_sacrifice/world",
	world_name = "ui_crafting_view_sacrifice"
}

return settings("CraftingMechanicusBarterItemsViewSettings", crafting_mechanicus_barter_items_view_settings)
