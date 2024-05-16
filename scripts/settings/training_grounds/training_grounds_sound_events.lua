-- chunkname: @scripts/settings/training_grounds/training_grounds_sound_events.lua

local sound_events = {
	hub_pod_interact_enter = "wwise/events/ui/play_ui_npc_interacts_psykhanium_enter",
	hub_pod_interact_exit = "wwise/events/ui/play_ui_npc_interacts_default_exit",
	tg_end_portal_entered = "wwise/events/ui/play_hud_tg_enter_exit_portal",
	tg_end_portal_spawned = "wwise/events/ui/play_hud_tg_exit_portal_loop",
	tg_enemy_dissolve_start = "wwise/events/ui/play_hud_tg_enemy_dissolve_start",
	tg_generic_despawn = "wwise/events/ui/play_hud_tg_dissolve",
	tg_generic_spawn = "wwise/events/ui/play_hud_tg_dissolve",
	tg_hub_button = "wwise/events/ui/play_ui_mission_request_accept",
	tg_level_enter = "wwise/events/ui/play_hud_new_zone",
	tg_level_exit = "wwise/events/ui/play_hud_tg_objective_complete",
	tg_minion_execute = "wwise/events/ui/stop_training_grounds_all_minion_sfx_and_vce",
	tg_objective_complete = "wwise/events/ui/play_hud_tg_objective_complete",
	tg_objective_new = "wwise/events/ui/play_hud_tg_new_objective",
	tg_objective_progress = "wwise/events/ui/play_hud_objective_part_done",
	tg_scenario_complete = "wwise/events/ui/play_ui_silence",
	tg_teleport_player = "wwise/events/ui/play_hud_tg_teleport_player",
}

return sound_events
