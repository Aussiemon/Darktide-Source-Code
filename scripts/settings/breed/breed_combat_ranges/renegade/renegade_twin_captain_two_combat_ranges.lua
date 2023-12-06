local combat_ranges = {
	name = "renegade_twin_captain_two",
	starting_combat_range = "far",
	config = {
		far = {
			{
				distance = 10,
				require_line_of_sight = true,
				sticky_time = 2,
				activate_slot_system = true,
				distance_operator = "lesser",
				switch_combat_range = "close"
			}
		},
		close = {
			{
				distance = 12,
				activate_slot_system = true,
				sticky_time = 0,
				distance_operator = "greater",
				switch_combat_range = "far"
			}
		}
	}
}

return combat_ranges
