-- chunkname: @scripts/settings/breed/breed_combat_ranges/renegade/renegade_captain_combat_ranges.lua

local combat_ranges = {
	starting_combat_range = "far",
	name = "renegade_captain",
	multi_config = {
		ranged = {
			far = {
				{
					switch_combat_range = "close",
					sticky_time = 3,
					distance = 10,
					distance_operator = "lesser",
					require_line_of_sight = true
				}
			},
			close = {
				{
					switch_combat_range = "far",
					distance_operator = "greater",
					distance = 12,
					sticky_time = 1
				}
			}
		},
		melee = {
			far = {
				{
					distance = 0,
					sticky_time = 5,
					activate_slot_system = true,
					distance_operator = "greater",
					switch_combat_range = "melee"
				}
			},
			melee = {
				{
					switch_combat_range = "far",
					distance_operator = "greater",
					sticky_time = 3,
					distance = math.huge
				}
			}
		},
		default = {
			far = {
				{
					activate_slot_system = true,
					locked_in_melee_distance = 6,
					distance = 6,
					switch_phase = true,
					distance_operator = "lesser",
					switch_combat_range = "melee",
					sticky_time = 12,
					require_line_of_sight = true,
					target_weapon_type_distance = {
						ranged = 2,
						melee = 6
					}
				}
			},
			melee = {
				{
					locked_in_melee_distance = 10,
					sticky_time = 8,
					distance = 10,
					switch_phase = true,
					distance_operator = "greater",
					switch_combat_range = "far",
					target_weapon_type_distance = {
						ranged = 7,
						melee = 10
					}
				}
			}
		}
	}
}

return combat_ranges
