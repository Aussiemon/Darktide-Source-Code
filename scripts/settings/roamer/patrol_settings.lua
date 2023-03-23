local patrol_settings = {
	max_num_failed_astar_queries = 10,
	min_patrol_distance = 7.5,
	num_patrols_per_zone = 4,
	min_members_in_patrol = 1
}

return settings("PatrolSettings", patrol_settings)
