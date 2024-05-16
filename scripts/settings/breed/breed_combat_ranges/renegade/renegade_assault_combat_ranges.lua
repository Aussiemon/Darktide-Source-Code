-- chunkname: @scripts/settings/breed/breed_combat_ranges/renegade/renegade_assault_combat_ranges.lua

local combat_ranges = {
	calculate_target_velocity_dot = true,
	name = "renegade_assault",
	starting_combat_range = "far",
	target_velocity_dot_reset = 0.5,
	config = {
		far = {
			{
				activate_slot_system = true,
				distance = 3,
				distance_operator = "lesser",
				locked_in_melee_distance = 8,
				max_z_distance = 1.5,
				sticky_time = 0,
				switch_combat_range = "melee",
				switch_weapon_slot = "slot_melee_weapon",
				target_weapon_type_distance = {
					melee = 4.5,
					ranged = 4,
				},
			},
			{
				distance = 25,
				distance_operator = "lesser",
				enter_combat_range_flag = true,
				require_line_of_sight = false,
				sticky_time = 1,
				switch_combat_range = "close",
			},
		},
		close = {
			{
				activate_slot_system = true,
				distance = 3,
				distance_operator = "lesser",
				locked_in_melee_distance = 7.5,
				max_z_distance = 1.5,
				sticky_time = 1,
				switch_combat_range = "melee",
				switch_weapon_slot = "slot_melee_weapon",
				target_weapon_type_distance = {
					melee = 5.5,
					ranged = 4,
				},
				target_velocity_dot_duration_inverted = {
					6,
					5,
					4,
					4,
					3,
				},
			},
			{
				distance = 35,
				distance_operator = "greater",
				sticky_time = 0,
				switch_combat_range = "far",
			},
		},
		melee = {
			{
				distance = 15,
				distance_operator = "greater",
				sticky_time = 2,
				switch_combat_range = "far",
				switch_weapon_slot = "slot_ranged_weapon",
			},
			{
				distance = 7,
				distance_operator = "greater",
				locked_in_melee_distance = 12,
				sticky_time = 3,
				switch_combat_range = "close",
				switch_weapon_slot = "slot_ranged_weapon",
				target_velocity_dot_distance = 6,
				z_distance = 1.9,
				target_weapon_type_distance = {
					melee = 10,
					ranged = 6,
				},
				target_velocity_dot_duration = {
					6,
					5,
					4,
					4,
					3,
				},
			},
		},
	},
}

return combat_ranges
