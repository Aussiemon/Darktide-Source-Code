﻿-- chunkname: @scripts/settings/monster/chaos_spawn_settings.lua

local chaos_spawn_settings = {
	offset_in_front_of_target = 3,
	max_leap_distance = 25,
	leap_short_fwd_check_distance = 2,
	trajectory_collision_filter = "filter_minion_mover",
	leap_gravity = 20,
	leap_cooldown = 5,
	leap_max_time_in_flight = 3,
	leap_fwd_check_distance = 7,
	trajectory_acceptable_accuracy = 0.1,
	trajectory_num_sections = 15,
	short_leap_distance = 16,
	min_leap_distance = 11,
	trajectory_radius = 1.5,
	shortest_leap_distance = 13,
	leap_speed = 15
}

return settings("ChaosSpawnSettings", chaos_spawn_settings)
