-- chunkname: @scripts/extension_systems/behavior/utility_considerations/chaos_daemonhost_torment_utility_considerations.lua

local considerations = {
	chaos_daemonhost_torment_warp_nova = {
		distance_to_target = {
			blackboard_component = "perception",
			component_field = "target_distance",
			max_value = 6,
			spline = {
				0,
				1,
				1,
				1,
			},
		},
	},
}

return considerations
