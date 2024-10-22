-- chunkname: @scripts/ui/views/cosmetics_vendor_view/cosmetics_vendor_view_settings.lua

local cosmetics_vendor_view_settings = {
	timer_name = "ui",
	total_blur_duration = 0.5,
	vo_event_vendor_greeting = {
		"reject_npc_hub_interact_a",
	},
	vo_event_vendor_purchase = {
		"reject_npc_purchase_a",
	},
	gear_level_settings = {
		level_name = "content/levels/ui/vendor_cosmetics_preview_gear/vendor_cosmetics_preview_gear",
		shading_environment = "content/shading_environments/ui/vendor_cosmetics_preview_gear",
		viewport_layer = 1,
		viewport_name = "ui_vendor_cosmetics_preview_gear_preview_viewport",
		viewport_type = "default",
		world_layer = 1,
		world_name = "ui_vendor_cosmetics_preview_gear_preview",
	},
}

return settings("CosmeticsVendorViewSettings", cosmetics_vendor_view_settings)
