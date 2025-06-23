-- chunkname: @scripts/settings/breed/breed_combat_ranges/renegade/renegade_grenadier_combat_ranges.lua

local combat_ranges = {
	name = "renegade_grenadier",
	starting_combat_range = "far",
	config = {
		far = {
			{
				distance = 10,
				require_line_of_sight = true,
				sticky_time = 2,
				distance_operator = "lesser",
				switch_combat_range = "close"
			}
		},
		close = {
			{
				switch_combat_range = "far",
				distance_operator = "greater",
				distance = 12,
				sticky_time = 0
			}
		}
	}
}

return combat_ranges
