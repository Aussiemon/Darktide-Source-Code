-- chunkname: @scripts/ui/views/store_item_detail_view/store_item_detail_view_settings.lua

local store_item_detail_view_settings = {
	timer_name = "ui",
	vo_event_vendor_purchase = {
		"purser_purchase"
	},
	level_settings = {
		viewport_layer = 1,
		level_name = "content/levels/ui/vendor_cosmetics_preview_gear/vendor_cosmetics_preview_gear",
		world_layer = 1,
		shading_environment = "content/shading_environments/ui/vendor_cosmetics_preview_gear",
		viewport_type = "default",
		viewport_name = "ui_vendor_cosmetics_preview_gear_preview_viewport",
		world_name = "ui_vendor_cosmetics_preview_gear_preview"
	},
	grid_size = {
		500,
		500
	}
}

return settings("StoreItemDetailViewSettings", store_item_detail_view_settings)
