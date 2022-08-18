local hub_aim_constraint_settings = {
	passive_aim_angle_threshold = 120,
	head_look_up_offset = 25,
	turning_dot_threshold = 0.98,
	aim_weight_lerp_speed = 3,
	moving_threshold_sq = 1,
	states = table.index_lookup_table("idle", "passive", "walk", "jog", "sprint"),
	speed = {
		rate_of_change = 10,
		idle = {
			head = 6,
			torso = 2
		},
		passive = {
			head = 2,
			torso = 1
		},
		moving = {
			head = 10,
			torso = 9
		},
		moving_passive = {
			head = 6,
			torso = 3
		}
	},
	horizontal_weight = {
		idle = {
			head = 0.9,
			torso = 0.7
		},
		passive = {
			head = 0.7,
			torso = 0.5
		},
		moving = {
			head = 0.7,
			torso = 0.3
		},
		moving_passive = {
			head = 0.7,
			torso = 0.3
		}
	},
	vertical_weight = {
		idle = {
			head = 0.8,
			torso = 0.4
		},
		passive = {
			head = 0.7,
			torso = 0.5
		},
		moving = {
			head = 0.6,
			torso = 0.2
		},
		moving_passive = {
			head = 0.6,
			torso = 0.2
		},
		moving_passive_turn = {
			head = 0.6,
			torso = 0.2
		}
	},
	height_adjustment = {
		head = 1.5,
		torso = 0.9
	},
	aim_weight = {
		head = {
			passive = 0,
			jog = 0.4,
			idle = 0.3,
			sprint = 0.5,
			walk = 1
		},
		torso = {
			passive = 0,
			jog = 0.4,
			idle = 0.25,
			sprint = 0.3,
			walk = 1
		}
	}
}

return settings("HubAimConstraintSettings", hub_aim_constraint_settings)
