local combat_ranges = {
	starting_combat_range = "close",
	name = "renegade_captain",
	multi_config = {
		ranged = {
			far = {
				{
					switch_combat_range = "close",
					sticky_time = 3,
					distance = 10,
					distance_operator = "lesser",
					require_line_of_sight = true
				}
			},
			close = {
				{
					switch_combat_range = "far",
					distance_operator = "greater",
					distance = 12,
					sticky_time = 1
				}
			}
		},
		melee = {
			close = {
				{
					distance = 0,
					sticky_time = 5,
					activate_slot_system = true,
					distance_operator = "greater",
					switch_combat_range = "melee"
				}
			},
			melee = {
				{
					switch_combat_range = "close",
					distance_operator = "greater",
					sticky_time = 3,
					distance = math.huge
				}
			}
		},
		default = {
			far = {
				{
					activate_slot_system = true,
					locked_in_melee_distance = 6,
					distance = 4,
					switch_phase = true,
					distance_operator = "lesser",
					switch_combat_range = "melee",
					sticky_time = 5,
					require_line_of_sight = true,
					target_weapon_type_distance = {
						ranged = 2,
						melee = 5
					}
				},
				{
					switch_combat_range = "close",
					sticky_time = 3,
					distance = 25,
					switch_phase = true,
					distance_operator = "lesser",
					require_line_of_sight = true
				}
			},
			close = {
				{
					activate_slot_system = true,
					locked_in_melee_distance = 6,
					distance = 4,
					switch_phase = true,
					distance_operator = "lesser",
					switch_combat_range = "melee",
					sticky_time = 5,
					require_line_of_sight = true,
					target_weapon_type_distance = {
						ranged = 2,
						melee = 5
					}
				},
				{
					distance = 27,
					switch_phase = true,
					sticky_time = 3,
					distance_operator = "greater",
					switch_combat_range = "far"
				}
			},
			melee = {
				{
					distance = 27,
					switch_phase = true,
					sticky_time = 3,
					distance_operator = "greater",
					switch_combat_range = "far"
				},
				{
					locked_in_melee_distance = 6,
					sticky_time = 3,
					distance = 5,
					switch_phase = true,
					distance_operator = "greater",
					switch_combat_range = "close",
					target_weapon_type_distance = {
						ranged = 3,
						melee = 5
					}
				}
			}
		}
	}
}

return combat_ranges
