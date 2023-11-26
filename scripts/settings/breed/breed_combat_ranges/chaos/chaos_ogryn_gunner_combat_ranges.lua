-- chunkname: @scripts/settings/breed/breed_combat_ranges/chaos/chaos_ogryn_gunner_combat_ranges.lua

local combat_ranges = {
	name = "chaos_ogryn_gunner",
	starting_combat_range = "far",
	config = {
		far = {
			{
				switch_combat_range = "melee",
				sticky_time = 1,
				distance = 5,
				distance_operator = "lesser",
				require_line_of_sight = true
			}
		},
		melee = {
			{
				switch_combat_range = "far",
				distance_operator = "greater",
				distance = 7,
				sticky_time = 0
			}
		}
	}
}

return combat_ranges
