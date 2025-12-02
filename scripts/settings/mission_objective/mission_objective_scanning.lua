-- chunkname: @scripts/settings/mission_objective/mission_objective_scanning.lua

local mission_objective_scanning = {}

mission_objective_scanning.servo_skull = {
	pulse_fx_interval = 2,
	pulse_fx_travel_time_per_meter = 0.07,
	scannable_check_interval = 0.5,
	vo_trigger_time = 5,
	wandering_distance = 15,
}
mission_objective_scanning.vo_settings = {
	concept = "mission_info",
}
mission_objective_scanning.vo_trigger_ids = table.enum("scan_performed", "auspex_full", "event_scan_skull_waiting", "cmd_wandering_skull", "all_targets_scanned")
mission_objective_scanning.zone_settings = {
	vo_trigger_time = 30,
}
mission_objective_scanning.go_to_marker_activation_range = 30

return mission_objective_scanning
