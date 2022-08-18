local mission_objective_scanning = {
	servo_skull = {
		pulse_fx_travel_time_per_meter = 0.07,
		wandering_distance = 15,
		pulse_fx_interval = 2,
		vo_trigger_time = 5,
		scannable_check_interval = 0.5
	},
	servo_skull_marker_types = table.enum("objective"),
	vo_settings = {
		concept = "mission_info"
	},
	vo_trigger_ids = table.enum("scan_performed", "auspex_full", "event_scan_skull_waiting", "cmd_wandering_skull", "all_targets_scanned"),
	zone_settings = {
		vo_trigger_time = 30
	}
}

return mission_objective_scanning
