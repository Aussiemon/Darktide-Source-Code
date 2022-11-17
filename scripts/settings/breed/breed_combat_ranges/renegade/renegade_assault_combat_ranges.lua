local combat_ranges = {
	name = "renegade_assault",
	calculate_target_velocity_dot = true,
	target_velocity_dot_reset = 1.5,
	starting_combat_range = "far",
	config = {
		far = {
			{
				switch_combat_range = "melee",
				locked_in_melee_distance = 8,
				distance = 3,
				switch_weapon_slot = "slot_melee_weapon",
				distance_operator = "lesser",
				max_z_distance = 1.5,
				sticky_time = 0,
				activate_slot_system = true,
				target_weapon_type_distance = {
					ranged = 1,
					melee = 3
				}
			},
			{
				distance = 25,
				require_line_of_sight = false,
				enter_combat_range_flag = true,
				sticky_time = 1,
				distance_operator = "lesser",
				switch_combat_range = "close"
			}
		},
		close = {
			{
				switch_combat_range = "melee",
				locked_in_melee_distance = 6,
				distance = 2,
				switch_weapon_slot = "slot_melee_weapon",
				distance_operator = "lesser",
				max_z_distance = 1.5,
				sticky_time = 1,
				target_velocity_dot_duration_inverted = 2,
				activate_slot_system = true,
				target_weapon_type_distance = {
					ranged = 1,
					melee = 4
				}
			},
			{
				switch_combat_range = "far",
				distance_operator = "greater",
				distance = 35,
				sticky_time = 0
			}
		},
		melee = {
			{
				sticky_time = 2,
				distance = 15,
				switch_weapon_slot = "slot_ranged_weapon",
				distance_operator = "greater",
				switch_combat_range = "far"
			},
			{
				locked_in_melee_distance = 8,
				distance = 7,
				switch_weapon_slot = "slot_ranged_weapon",
				target_velocity_dot_duration = 2,
				distance_operator = "greater",
				switch_combat_range = "close",
				sticky_time = 3,
				z_distance = 1.9,
				target_weapon_type_distance = {
					ranged = 1.25,
					melee = 8
				}
			}
		}
	}
}

return combat_ranges
