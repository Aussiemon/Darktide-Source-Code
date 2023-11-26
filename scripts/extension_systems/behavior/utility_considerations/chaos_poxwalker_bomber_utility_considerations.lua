-- chunkname: @scripts/extension_systems/behavior/utility_considerations/chaos_poxwalker_bomber_utility_considerations.lua

local considerations = {
	chaos_poxwalker_bomber_explode = {
		distance_to_target = {
			component_field = "target_distance",
			blackboard_component = "perception",
			max_value = 5,
			spline = {
				0,
				1,
				0.589,
				1,
				0.60002,
				0,
				1,
				0
			}
		}
	}
}

return considerations
