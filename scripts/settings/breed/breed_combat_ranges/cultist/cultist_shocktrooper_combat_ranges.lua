local combat_ranges = {
	name = "cultist_shocktrooper",
	starting_combat_range = "far",
	config = {
		far = {
			{
				locked_in_melee_distance = 3,
				require_line_of_sight = true,
				distance = 3,
				sticky_time = 4,
				distance_operator = "lesser",
				switch_combat_range = "melee",
				target_weapon_type_distance = {
					ranged = 2,
					melee = 3
				}
			},
			{
				distance = 22,
				require_line_of_sight = true,
				enter_combat_range_flag = true,
				sticky_time = 0,
				distance_operator = "lesser",
				switch_combat_range = "close"
			}
		},
		close = {
			{
				locked_in_melee_distance = 3,
				require_line_of_sight = true,
				distance = 3,
				sticky_time = 4,
				distance_operator = "lesser",
				switch_combat_range = "melee",
				target_weapon_type_distance = {
					ranged = 2,
					melee = 3
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
				switch_combat_range = "far",
				distance_operator = "greater",
				distance = 28,
				sticky_time = 0
			},
			{
				locked_in_melee_distance = 6,
				distance_operator = "greater",
				distance = 7,
				sticky_time = 1,
				z_distance = 1.9,
				switch_combat_range = "close",
				target_weapon_type_distance = {
					ranged = 1,
					melee = 6
				}
			}
		}
	}
}

return combat_ranges
