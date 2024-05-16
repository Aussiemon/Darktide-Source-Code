-- chunkname: @scripts/settings/breed/breed_combat_ranges/cultist/cultist_shocktrooper_combat_ranges.lua

local combat_ranges = {
	name = "cultist_shocktrooper",
	starting_combat_range = "far",
	config = {
		far = {
			{
				activate_slot_system = true,
				distance = 5,
				distance_operator = "lesser",
				locked_in_melee_distance = 7,
				require_line_of_sight = true,
				sticky_time = 4,
				switch_combat_range = "melee",
				target_weapon_type_distance = {
					melee = 6,
					ranged = 4,
				},
			},
			{
				distance = 22,
				distance_operator = "lesser",
				enter_combat_range_flag = true,
				require_line_of_sight = true,
				sticky_time = 0,
				switch_combat_range = "close",
			},
		},
		close = {
			{
				activate_slot_system = true,
				distance = 5,
				distance_operator = "lesser",
				locked_in_melee_distance = 7,
				require_line_of_sight = true,
				sticky_time = 4,
				switch_combat_range = "melee",
				target_weapon_type_distance = {
					melee = 6,
					ranged = 4,
				},
			},
			{
				distance = 28,
				distance_operator = "greater",
				sticky_time = 0,
				switch_combat_range = "far",
			},
		},
		melee = {
			{
				distance = 28,
				distance_operator = "greater",
				sticky_time = 0,
				switch_combat_range = "far",
			},
			{
				distance = 7,
				distance_operator = "greater",
				locked_in_melee_distance = 6,
				sticky_time = 1,
				switch_combat_range = "close",
				z_distance = 1.9,
				target_weapon_type_distance = {
					melee = 6,
					ranged = 1,
				},
			},
		},
	},
}

return combat_ranges
