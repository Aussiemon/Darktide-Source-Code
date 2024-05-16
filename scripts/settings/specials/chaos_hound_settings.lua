-- chunkname: @scripts/settings/specials/chaos_hound_settings.lua

local chaos_hound_settings = {
	collision_radius = 0.8,
	dodge_collision_radius = 0.65,
	leap_acceptable_accuracy = 0.1,
	leap_collision_filter = "filter_minion_mover",
	leap_gravity = 13.82,
	leap_max_time_in_flight = 10,
	leap_num_sections = 10,
	leap_radius = 0.75,
	leap_speed = 21,
	leap_target_node_name = "j_spine",
	leap_target_z_offset = -0.1,
	long_leap_min_speed = 6,
	long_leap_start_offset_distance = 8,
	short_distance = 14,
}

return settings("ChaosHoundSettings", chaos_hound_settings)
