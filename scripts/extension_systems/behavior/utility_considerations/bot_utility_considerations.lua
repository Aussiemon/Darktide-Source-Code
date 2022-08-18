local considerations = {
	bot_combat = {
		distance_to_target = {
			component_field = "target_enemy_distance",
			blackboard_component = "perception",
			max_value = 40,
			spline = {
				0,
				1,
				0.25,
				0.25,
				0.75,
				0,
				1,
				0
			}
		}
	},
	bot_follow = {
		distance_to_target = {
			component_field = "target_ally_distance",
			blackboard_component = "perception",
			max_value = 40,
			spline = {
				0,
				0.1,
				0.25,
				0.2,
				0.75,
				1,
				1,
				1
			}
		}
	}
}

return considerations
