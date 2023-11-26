-- chunkname: @scripts/ui/views/store_view/store_view_settings.lua

local store_view_settings = {
	shading_environment = "content/shading_environments/ui/store",
	min_time_to_disply_timer = 86400,
	timer_name = "ui",
	world_layer = 1,
	viewport_type = "default",
	wallet_sync_delay = 60,
	viewport_name = "ui_store_world_viewport",
	viewport_layer = 1,
	level_name = "content/levels/ui/store/store",
	world_name = "ui_store_world",
	vo_event_vendor_first_interaction = {
		"npc_first_interaction_purser_a",
		"npc_first_interaction_purser_b",
		"npc_first_interaction_purser_c",
		"npc_first_interaction_purser_d",
		"npc_first_interaction_purser_e"
	},
	vo_event_vendor_greeting = {
		"hub_interact_purser"
	}
}

return settings("StoreViewSettings", store_view_settings)
