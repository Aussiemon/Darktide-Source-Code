local combat_ranges = {
	name = "cultist_assault",
	starting_combat_range = "far",
	config = {
		far = {
			{
				switch_combat_range = "melee",
				locked_in_melee_distance = 7,
				distance = 4.5,
				switch_weapon_slot = "slot_melee_weapon",
				distance_operator = "lesser",
				max_z_distance = 1.5,
				sticky_time = 4,
				activate_slot_system = true,
				require_line_of_sight = true,
				target_weapon_type_distance = {
					ranged = 2,
					melee = 6
				}
			},
			{
				require_line_of_sight = true,
				sticky_time = 0.25,
				distance = 9,
				switch_anim_state = "to_assaulter",
				distance_operator = "lesser",
				switch_combat_range = "close"
			}
		},
		close = {
			{
				switch_combat_range = "melee",
				locked_in_melee_distance = 10,
				distance = 4.5,
				switch_weapon_slot = "slot_melee_weapon",
				distance_operator = "lesser",
				max_z_distance = 1.5,
				sticky_time = 2,
				activate_slot_system = true,
				require_line_of_sight = true,
				target_weapon_type_distance = {
					ranged = 2,
					melee = 6
				}
			},
			{
				sticky_time = 2,
				distance = 11,
				switch_anim_state = "to_riflemen",
				distance_operator = "greater",
				switch_combat_range = "far"
			}
		},
		melee = {
			{
				sticky_time = 5,
				switch_on_wait_slot = true,
				distance = 20,
				switch_weapon_slot = "slot_ranged_weapon",
				switch_anim_state = "to_riflemen",
				distance_operator = "greater",
				switch_combat_range = "far"
			},
			{
				switch_weapon_slot = "slot_ranged_weapon",
				sticky_time = 2,
				distance = 7,
				distance_operator = "greater",
				switch_combat_range = "close",
				locked_in_melee_distance = 12,
				switch_anim_state = "to_assaulter",
				z_distance = 1.9,
				target_weapon_type_distance = {
					ranged = 3,
					melee = 9
				}
			}
		}
	}
}

return combat_ranges
