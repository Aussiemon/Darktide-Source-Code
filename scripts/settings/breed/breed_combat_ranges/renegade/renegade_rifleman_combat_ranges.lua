local combat_ranges = {
	name = "renegade_rifleman",
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
				distance = 20,
				switch_on_wait_slot = true,
				sticky_time = 5,
				distance_operator = "greater",
				switch_combat_range = "far"
			},
			{
				locked_in_melee_distance = 6,
				distance_operator = "greater",
				distance = 7,
				sticky_time = 2,
				z_distance = 1.9,
				switch_combat_range = "close",
				target_weapon_type_distance = {
					ranged = 3,
					melee = 6
				}
			}
		}
	}
}

return combat_ranges
