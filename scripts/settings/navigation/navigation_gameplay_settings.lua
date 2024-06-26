-- chunkname: @scripts/settings/navigation/navigation_gameplay_settings.lua

local navigation_gameplay_settings = {
	nav_world_config = {
		budget = {
			pathfinder_outside_world_update = 0.005,
			pathfinder_working_memory = 10,
			pathfinder_world_update = 0.001,
		},
		crowd_dispersion = {
			max_check_distance = 60,
			min_check_distance = 1,
		},
	},
}

return settings("NavigationGameplaySettings", navigation_gameplay_settings)
