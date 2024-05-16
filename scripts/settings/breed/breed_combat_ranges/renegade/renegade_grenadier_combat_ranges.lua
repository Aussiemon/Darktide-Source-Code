-- chunkname: @scripts/settings/breed/breed_combat_ranges/renegade/renegade_grenadier_combat_ranges.lua

local combat_ranges = {
	name = "renegade_grenadier",
	starting_combat_range = "far",
	config = {
		far = {
			{
				distance = 10,
				distance_operator = "lesser",
				require_line_of_sight = true,
				sticky_time = 2,
				switch_combat_range = "close",
			},
		},
		close = {
			{
				distance = 12,
				distance_operator = "greater",
				sticky_time = 0,
				switch_combat_range = "far",
			},
		},
	},
}

return combat_ranges
