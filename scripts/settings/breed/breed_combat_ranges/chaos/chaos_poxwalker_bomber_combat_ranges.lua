-- chunkname: @scripts/settings/breed/breed_combat_ranges/chaos/chaos_poxwalker_bomber_combat_ranges.lua

local combat_ranges = {
	name = "chaos_poxwalker_bomber",
	starting_combat_range = "far",
	config = {
		far = {
			{
				distance = 30,
				distance_operator = "lesser",
				sticky_time = 0,
				switch_combat_range = "close",
			},
		},
		close = {
			{
				distance = 10,
				distance_operator = "lesser",
				sticky_time = 1,
				switch_combat_range = "melee",
			},
			{
				distance = 32,
				distance_operator = "greater",
				sticky_time = 0,
				switch_combat_range = "far",
			},
		},
		melee = {
			{
				distance = 13,
				distance_operator = "greater",
				sticky_time = 0,
				switch_combat_range = "close",
			},
		},
	},
}

return combat_ranges
