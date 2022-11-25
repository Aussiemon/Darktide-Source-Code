local combat_ranges = {
	name = "renegade_rifleman",
	calculate_target_velocity_dot = true,
	target_velocity_dot_reset = 0.5,
	starting_combat_range = "far",
	config = {
		far = {
			{
				locked_in_melee_distance = 12,
				switch_combat_range = "melee",
				distance = 4.5,
				sticky_time = 4,
				distance_operator = "lesser",
				max_z_distance = 1.5,
				activate_slot_system = true,
				switch_anim_state = "to_bayonet",
				require_line_of_sight = true,
				target_weapon_type_distance = {
					ranged = 2,
					melee = 4
				}
			},
			{
				switch_combat_range = "close",
				sticky_time = 0.25,
				distance = 8,
				distance_operator = "lesser",
				require_line_of_sight = true
			}
		},
		close = {
			{
				locked_in_melee_distance = 12,
				switch_combat_range = "melee",
				distance = 4.5,
				sticky_time = 4,
				distance_operator = "lesser",
				max_z_distance = 1.5,
				activate_slot_system = true,
				switch_anim_state = "to_bayonet",
				require_line_of_sight = true,
				target_weapon_type_distance = {
					ranged = 2,
					melee = 4
				},
				target_velocity_dot_duration_inverted = {
					6,
					5,
					4,
					4,
					3
				}
			},
			{
				switch_combat_range = "far",
				distance_operator = "greater",
				distance = 11,
				sticky_time = 4
			}
		},
		melee = {
			{
				sticky_time = 5,
				switch_on_wait_slot = true,
				distance = 20,
				switch_anim_state = "to_riflemen",
				distance_operator = "greater",
				switch_combat_range = "far"
			},
			{
				locked_in_melee_distance = 9,
				target_velocity_dot_distance = 6,
				distance = 7,
				distance_operator = "greater",
				switch_combat_range = "close",
				sticky_time = 3,
				switch_anim_state = "to_riflemen",
				z_distance = 1.9,
				target_weapon_type_distance = {
					ranged = 3,
					melee = 9
				},
				target_velocity_dot_duration = {
					6,
					5,
					4,
					4,
					3
				}
			}
		}
	}
}

return combat_ranges
