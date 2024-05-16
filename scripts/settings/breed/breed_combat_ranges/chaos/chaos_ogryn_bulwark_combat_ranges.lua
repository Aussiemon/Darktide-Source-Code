-- chunkname: @scripts/settings/breed/breed_combat_ranges/chaos/chaos_ogryn_bulwark_combat_ranges.lua

local combat_ranges = {
	name = "chaos_ogryn_bulwark",
	starting_combat_range = "far",
	config = {
		far = {
			{
				activate_slot_system = true,
				distance = 10,
				distance_operator = "lesser",
				sticky_time = 0.2,
				switch_combat_range = "melee",
			},
		},
		melee = {
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
