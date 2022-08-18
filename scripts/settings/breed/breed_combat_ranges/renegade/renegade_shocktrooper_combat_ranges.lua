local combat_ranges = {
	name = "renegade_shocktrooper",
	starting_combat_range = "far",
	config = {
		far = {
			{
				switch_combat_range = "melee",
				locked_in_melee_distance = 4,
				distance = 2,
				switch_weapon_slot = "slot_melee_weapon",
				distance_operator = "lesser",
				max_z_distance = 1.5,
				sticky_time = 0,
				activate_slot_system = true,
				target_weapon_type_distance = {
					ranged = 1,
					melee = 4
				}
			},
			{
				distance = 22,
				require_line_of_sight = true,
				enter_combat_range_flag = true,
				sticky_time = 0,
				switch_anim_state = "to_ranged",
				distance_operator = "lesser",
				switch_combat_range = "close"
			}
		},
		close = {
			{
				switch_combat_range = "melee",
				locked_in_melee_distance = 4,
				distance = 2,
				switch_weapon_slot = "slot_melee_weapon",
				distance_operator = "lesser",
				max_z_distance = 1.5,
				sticky_time = 0,
				activate_slot_system = true,
				target_weapon_type_distance = {
					ranged = 1,
					melee = 4
				}
			},
			{
				switch_combat_range = "far",
				distance_operator = "greater",
				distance = 28,
				sticky_time = 0
			}
		},
		melee = {
			{
				sticky_time = 0,
				distance = 28,
				switch_weapon_slot = "slot_ranged_weapon",
				distance_operator = "greater",
				switch_combat_range = "far"
			},
			{
				sticky_time = 1,
				distance = 7,
				switch_weapon_slot = "slot_ranged_weapon",
				distance_operator = "greater",
				switch_combat_range = "close",
				locked_in_melee_distance = 6,
				switch_anim_state = "to_ranged",
				z_distance = 1.9,
				target_weapon_type_distance = {
					ranged = 1,
					melee = 6
				}
			}
		}
	}
}

return combat_ranges
