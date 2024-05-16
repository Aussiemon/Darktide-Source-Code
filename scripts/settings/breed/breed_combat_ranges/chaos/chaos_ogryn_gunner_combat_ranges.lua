-- chunkname: @scripts/settings/breed/breed_combat_ranges/chaos/chaos_ogryn_gunner_combat_ranges.lua

local combat_ranges = {
	name = "chaos_ogryn_gunner",
	starting_combat_range = "far",
	config = {
		far = {
			{
				distance = 5,
				distance_operator = "lesser",
				require_line_of_sight = true,
				sticky_time = 1,
				switch_combat_range = "melee",
			},
		},
		melee = {
			{
				distance = 7,
				distance_operator = "greater",
				sticky_time = 0,
				switch_combat_range = "far",
			},
		},
	},
}

return combat_ranges
