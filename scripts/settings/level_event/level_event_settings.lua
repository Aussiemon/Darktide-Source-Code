-- chunkname: @scripts/settings/level_event/level_event_settings.lua

LevelEventSettings = {}
LevelEventSettings.scanning_station = {
	scanning_station_check_radius = 4,
}
LevelEventSettings.scanning_device = {
	acceleration_to_max_speed = 2.5,
	bonus_speed_per_close_player = 2,
	end_position_height = 2,
	max_speed_no_player_close = 1,
	max_speed_player_close = 6.6,
	proximity_check_radius = 10,
	should_move_to_end_position = true,
	should_move_to_start_spline = true,
	to_end_position_speed = 2,
	to_start_spline_speed = 2,
}
LevelEventSettings.spline_follower = {
	connect_spline_distance = 0.1,
	spline_connection_radius = 3,
}
LevelEventSettings.spline_follower.servo_skull = {
	acceleration_to_max_speed = 8,
	deceleration_to_min_speed = 4,
	proximity_check_distance_squared = 100,
	servo_skull_default_speed = 0.5,
}
LevelEventSettings.mission_objective_zone_scannable = {
	particle_scale_modifier = 5,
}

return LevelEventSettings
