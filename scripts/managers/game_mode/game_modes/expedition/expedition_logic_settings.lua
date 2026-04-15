-- chunkname: @scripts/managers/game_mode/game_modes/expedition/expedition_logic_settings.lua

local CLIENT_RPCS = {
	"rpc_load_and_spawn_location",
	"rpc_expedition_start_despawning_levels",
	"rpc_can_proceed_to_safe_zone_exit",
	"rpc_register_expedition_level",
	"rpc_register_safe_zone_store_unit",
	"rpc_register_safe_zone_pickup_unit_by_pickup_spawner_unit",
	"rpc_expedition_on_gameplay_pause",
	"rpc_expedition_clear_location_systems",
	"rpc_expedition_on_gameplay_resume",
	"rpc_expedition_on_location_setup",
	"rpc_client_expedition_on_purchase_performed",
	"rpc_expedition_navigation_complete_level",
	"rpc_expedition_navigation_set_slot_mark",
	"rpc_expedition_navigation_clear_slot_mark",
	"rpc_expedition_timer_set_active",
	"rpc_spawn_expedition_airstrike",
	"rpc_register_expedition_danger_zone",
	"rpc_unregister_expedition_danger_zone",
	"rpc_expedition_start_event",
	"rpc_expedition_top_event",
	"rpc_expedition_start_location_events",
	"rpc_expedition_stop_all_events",
	"rpc_expedition_set_navigation_active",
	"rpc_expedition_navigation_remove_exit",
}
local SERVER_RPCS = {
	"rpc_expedition_navigation_set_slot_mark",
	"rpc_expedition_navigation_clear_slot_mark",
	"rpc_server_location_loaded_and_spawned_by_player",
	"rpc_server_expedition_levels_despawned_by_player",
}
local expedition_logic_settings = {
	client_rpcs = CLIENT_RPCS,
	server_rpcs = SERVER_RPCS,
}

return settings("ExpeditionLogicSettings", expedition_logic_settings)
