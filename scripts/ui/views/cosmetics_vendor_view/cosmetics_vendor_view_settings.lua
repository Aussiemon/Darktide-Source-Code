local cosmetics_vendor_view_settings = {
	timer_name = "ui",
	total_blur_duration = 0.5,
	vo_event_vendor_greeting = {
		"reject_npc_hub_interact_a"
	},
	vo_event_vendor_purchase = {
		"reject_npc_purchase_a"
	},
	gear_level_settings = {
		viewport_layer = 1,
		level_name = "content/levels/ui/vendor_cosmetics_preview_gear/vendor_cosmetics_preview_gear",
		world_layer = 1,
		shading_environment = "content/shading_environments/ui/vendor_cosmetics_preview_gear",
		viewport_type = "default",
		viewport_name = "ui_vendor_cosmetics_preview_gear_preview_viewport",
		world_name = "ui_vendor_cosmetics_preview_gear_preview"
	},
	weapon_level_settings = {
		viewport_layer = 1,
		level_name = "content/levels/ui/vendor_cosmetics_preview_weapon/vendor_cosmetics_preview_weapon",
		world_layer = 1,
		shading_environment = "content/shading_environments/ui/vendor_cosmetics_preview_weapon",
		viewport_type = "default",
		viewport_name = "ui_vendor_cosmetics_preview_weapon_preview_viewport",
		world_name = "ui_vendor_cosmetics_preview_weapon_preview"
	}
}

return settings("CosmeticsVendorViewSettings", cosmetics_vendor_view_settings)
