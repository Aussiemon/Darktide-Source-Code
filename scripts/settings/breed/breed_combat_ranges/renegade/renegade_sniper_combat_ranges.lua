-- chunkname: @scripts/settings/breed/breed_combat_ranges/renegade/renegade_sniper_combat_ranges.lua

local combat_ranges = {
	name = "renegade_sniper",
	starting_combat_range = "far",
	config = {
		far = {
			{
				distance = 3,
				distance_operator = "lesser",
				locked_in_melee_distance = 3,
				require_line_of_sight = true,
				sticky_time = 4,
				switch_combat_range = "melee",
				target_weapon_type_distance = {
					melee = 3,
					ranged = 2,
				},
			},
			{
				distance = 15,
				distance_operator = "lesser",
				require_line_of_sight = true,
				sticky_time = 0,
				switch_combat_range = "close",
			},
		},
		close = {
			{
				distance = 3,
				distance_operator = "lesser",
				locked_in_melee_distance = 3,
				require_line_of_sight = true,
				sticky_time = 4,
				switch_combat_range = "melee",
				target_weapon_type_distance = {
					melee = 3,
					ranged = 2,
				},
			},
			{
				distance = 17,
				distance_operator = "greater",
				sticky_time = 0,
				switch_combat_range = "far",
			},
		},
		melee = {
			{
				distance = 12,
				distance_operator = "greater",
				sticky_time = 4,
				switch_combat_range = "far",
			},
			{
				distance = 3.5,
				distance_operator = "greater",
				locked_in_melee_distance = 3,
				sticky_time = 0,
				switch_combat_range = "close",
				target_weapon_type_distance = {
					melee = 3.5,
					ranged = 3.5,
				},
			},
		},
	},
}

return combat_ranges
