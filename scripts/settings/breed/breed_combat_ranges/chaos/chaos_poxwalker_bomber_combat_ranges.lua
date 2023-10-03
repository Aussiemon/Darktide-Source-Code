local combat_ranges = {
	name = "chaos_poxwalker_bomber",
	starting_combat_range = "far",
	config = {
		far = {
			{
				switch_combat_range = "close",
				distance_operator = "lesser",
				distance = 30,
				sticky_time = 0
			}
		},
		close = {
			{
				switch_combat_range = "melee",
				distance_operator = "lesser",
				distance = 9,
				sticky_time = 1
			},
			{
				switch_combat_range = "far",
				distance_operator = "greater",
				distance = 32,
				sticky_time = 0
			}
		},
		melee = {
			{
				switch_combat_range = "close",
				distance_operator = "greater",
				distance = 13,
				sticky_time = 0
			}
		}
	}
}

return combat_ranges
