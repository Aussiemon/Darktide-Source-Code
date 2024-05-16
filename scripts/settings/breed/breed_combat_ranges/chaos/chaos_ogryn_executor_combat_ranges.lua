-- chunkname: @scripts/settings/breed/breed_combat_ranges/chaos/chaos_ogryn_executor_combat_ranges.lua

local combat_ranges = {
	name = "chaos_ogryn_executor",
	starting_combat_range = "far",
	config = {
		far = {
			{
				activate_slot_system = true,
				distance = 30,
				distance_operator = "lesser",
				sticky_time = 1,
				switch_combat_range = "close",
			},
		},
		close = {
			{
				activate_slot_system = true,
				distance = 10,
				distance_operator = "lesser",
				sticky_time = 4,
				switch_combat_range = "melee",
			},
			{
				activate_slot_system = true,
				distance = 32,
				distance_operator = "greater",
				sticky_time = 0,
				switch_combat_range = "far",
			},
		},
		melee = {
			{
				activate_slot_system = true,
				distance = 12,
				distance_operator = "greater",
				sticky_time = 0,
				switch_combat_range = "close",
			},
		},
	},
}

return combat_ranges
