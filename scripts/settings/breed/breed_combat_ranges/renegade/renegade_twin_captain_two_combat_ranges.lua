-- chunkname: @scripts/settings/breed/breed_combat_ranges/renegade/renegade_twin_captain_two_combat_ranges.lua

local combat_ranges = {
	name = "renegade_twin_captain_two",
	starting_combat_range = "far",
	config = {
		far = {
			{
				activate_slot_system = true,
				distance = 10,
				distance_operator = "lesser",
				require_line_of_sight = true,
				sticky_time = 2,
				switch_combat_range = "close",
			},
		},
		close = {
			{
				activate_slot_system = true,
				distance = 12,
				distance_operator = "greater",
				sticky_time = 0,
				switch_combat_range = "far",
			},
		},
	},
}

return combat_ranges
