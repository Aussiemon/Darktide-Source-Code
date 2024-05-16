-- chunkname: @scripts/settings/monster/chaos_spawn_settings.lua

local chaos_spawn_settings = {
	leap_cooldown = 5,
	leap_fwd_check_distance = 7,
	leap_gravity = 20,
	leap_max_time_in_flight = 3,
	leap_short_fwd_check_distance = 2,
	leap_speed = 15,
	max_leap_distance = 25,
	min_leap_distance = 11,
	offset_in_front_of_target = 3,
	short_leap_distance = 16,
	shortest_leap_distance = 13,
	trajectory_acceptable_accuracy = 0.1,
	trajectory_collision_filter = "filter_minion_mover",
	trajectory_num_sections = 15,
	trajectory_radius = 1.5,
}

return settings("ChaosSpawnSettings", chaos_spawn_settings)
