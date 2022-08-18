local combat_ranges = {
	name = "chaos_ogryn_bulwark",
	starting_combat_range = "far",
	config = {
		far = {
			{
				distance = 10,
				sticky_time = 0.2,
				activate_slot_system = true,
				distance_operator = "lesser",
				switch_combat_range = "melee"
			}
		},
		melee = {
			{
				distance = 12,
				sticky_time = 0,
				activate_slot_system = true,
				distance_operator = "greater",
				switch_combat_range = "far"
			}
		}
	}
}

return combat_ranges
