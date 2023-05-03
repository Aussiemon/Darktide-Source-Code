local chaos_spawn_settings = {
	offset_in_front_of_target = 3,
	max_leap_distance = 25,
	leap_short_fwd_check_distance = 2,
	leap_gravity = 20,
	leap_max_time_in_flight = 3,
	leap_fwd_check_distance = 9,
	short_leap_distance = 12,
	min_leap_distance = 10,
	leap_cooldown = 5,
	leap_speed = 15
}

return settings("ChaosSpawnSettings", chaos_spawn_settings)
