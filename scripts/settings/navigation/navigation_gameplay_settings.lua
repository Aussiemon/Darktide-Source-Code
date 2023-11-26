-- chunkname: @scripts/settings/navigation/navigation_gameplay_settings.lua

local navigation_gameplay_settings = {
	nav_world_config = {
		budget = {
			pathfinder_outside_world_update = 0.01,
			pathfinder_world_update = 0,
			pathfinder_working_memory = 10
		},
		crowd_dispersion = {
			min_check_distance = 1,
			max_check_distance = 60
		}
	}
}

return settings("NavigationGameplaySettings", navigation_gameplay_settings)
