local combat_vector_settings = {
	vector_types = table.enum("main", "left_flank", "right_flank"),
	location_types = {
		"left",
		"mid",
		"right"
	},
	main_vector_type = "main",
	flank_vector_types = {
		"left_flank",
		"right_flank"
	},
	range_types = table.enum("close", "far"),
	main_aggro_target_event_types = table.enum("killed_unit", "suppression"),
	target_side_id = 1,
	max_segments = 30,
	width = 35,
	flank_width = 14,
	main_path_distance = 50,
	min_segment_length = 3,
	from_update_distance_sq = 36,
	to_update_distance_sq = 144,
	combat_vector_update_frequency = 4,
	astar_frequency = 0.5,
	min_nav_mesh_location_radius = 0.4,
	num_locations_per_segment_meter = 1,
	num_flank_locations_per_segment_meter = 0,
	min_distance_sq = 900,
	max_distance_sq = 14400,
	main_aggro_target_stickyness = 10,
	max_main_aggro_score = 20,
	aggro_decay_speed = 3,
	locked_in_melee_cooldown = 5,
	locked_in_melee_range = 10,
	melee_minion_range = 7.5,
	nav_mesh_location_start_index = 5
}

return settings("CombatVectorSettings", combat_vector_settings)
