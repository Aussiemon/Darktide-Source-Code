-- chunkname: @scripts/settings/main_path/main_path_settings.lua

local main_path_settings = {
	main_path_version = "1.00",
	num_spawn_points_per_subgroup = 20,
	occluded_points_collision_filter = "filter_ray_aim_assist_line_of_sight",
	spawn_point_min_distance_to_others = 1.5,
	spawn_point_min_free_radius = 0.5,
	triangle_group_distance = 10,
	triangle_group_cutoff_values = {
		25,
		50,
		75,
	},
	spawn_point_forbidden_nav_tag_volume_types = {
		"content/volume_types/nav_tag_volumes/no_spawn",
	},
}

return settings("MainPathSettings", main_path_settings)
