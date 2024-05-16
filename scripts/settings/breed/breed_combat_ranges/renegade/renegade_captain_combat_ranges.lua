-- chunkname: @scripts/settings/breed/breed_combat_ranges/renegade/renegade_captain_combat_ranges.lua

local combat_ranges = {
	name = "renegade_captain",
	starting_combat_range = "far",
	multi_config = {
		ranged = {
			far = {
				{
					distance = 10,
					distance_operator = "lesser",
					require_line_of_sight = true,
					sticky_time = 3,
					switch_combat_range = "close",
				},
			},
			close = {
				{
					distance = 12,
					distance_operator = "greater",
					sticky_time = 1,
					switch_combat_range = "far",
				},
			},
		},
		melee = {
			far = {
				{
					activate_slot_system = true,
					distance = 0,
					distance_operator = "greater",
					sticky_time = 5,
					switch_combat_range = "melee",
				},
			},
			melee = {
				{
					distance_operator = "greater",
					sticky_time = 3,
					switch_combat_range = "far",
					distance = math.huge,
				},
			},
		},
		default = {
			far = {
				{
					activate_slot_system = true,
					distance = 6,
					distance_operator = "lesser",
					locked_in_melee_distance = 6,
					require_line_of_sight = true,
					sticky_time = 12,
					switch_combat_range = "melee",
					switch_phase = true,
					target_weapon_type_distance = {
						melee = 6,
						ranged = 2,
					},
				},
			},
			melee = {
				{
					distance = 10,
					distance_operator = "greater",
					locked_in_melee_distance = 10,
					sticky_time = 8,
					switch_combat_range = "far",
					switch_phase = true,
					target_weapon_type_distance = {
						melee = 10,
						ranged = 7,
					},
				},
			},
		},
	},
}

return combat_ranges
