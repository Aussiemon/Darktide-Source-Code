local combat_ranges = {
	name = "cultist_berzerker",
	starting_combat_range = "far",
	config = {
		far = {
			{
				distance = 30,
				sticky_time = 0,
				activate_slot_system = true,
				distance_operator = "lesser",
				switch_combat_range = "close"
			}
		},
		close = {
			{
				distance = 10,
				sticky_time = 4,
				activate_slot_system = true,
				distance_operator = "lesser",
				switch_combat_range = "melee"
			},
			{
				distance = 32,
				sticky_time = 0,
				activate_slot_system = true,
				distance_operator = "greater",
				switch_combat_range = "far"
			}
		},
		melee = {
			{
				distance = 12,
				sticky_time = 0,
				activate_slot_system = true,
				distance_operator = "greater",
				switch_combat_range = "close"
			}
		}
	}
}

return combat_ranges
