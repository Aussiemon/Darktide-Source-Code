-- chunkname: @scripts/settings/breed/breed_combat_ranges/renegade/renegade_plasma_gunner_combat_ranges.lua

local combat_ranges = {
	calculate_target_velocity_dot = true,
	name = "renegade_plasma_gunner",
	starting_combat_range = "far",
	target_velocity_dot_reset = 0.5,
	config = {
		far = {
			{
				activate_slot_system = true,
				distance = 2,
				distance_operator = "lesser",
				locked_in_melee_distance = 4,
				max_z_distance = 1.5,
				sticky_time = 0,
				switch_combat_range = "melee",
				switch_weapon_slot = "slot_melee_weapon",
				target_weapon_type_distance = {
					melee = 4,
					ranged = 1,
				},
			},
			{
				distance = 22,
				distance_operator = "lesser",
				enter_combat_range_flag = true,
				require_line_of_sight = true,
				sticky_time = 0,
				switch_anim_state = "to_ranged",
				switch_combat_range = "close",
			},
		},
		close = {
			{
				activate_slot_system = true,
				distance = 2,
				distance_operator = "lesser",
				locked_in_melee_distance = 6,
				max_z_distance = 1.5,
				sticky_time = 2,
				switch_combat_range = "melee",
				switch_weapon_slot = "slot_melee_weapon",
				target_weapon_type_distance = {
					melee = 6,
					ranged = 1,
				},
				target_velocity_dot_duration_inverted = {
					6,
					4,
					4,
					3,
					2,
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
				switch_weapon_slot = "slot_ranged_weapon",
			},
			{
				distance = 7,
				distance_operator = "greater",
				locked_in_melee_distance = 7,
				sticky_time = 2,
				switch_anim_state = "to_ranged",
				switch_combat_range = "close",
				switch_weapon_slot = "slot_ranged_weapon",
				target_velocity_dot_distance = 6,
				z_distance = 1.9,
				target_weapon_type_distance = {
					melee = 6,
					ranged = 1,
				},
				target_velocity_dot_duration = {
					6,
					4,
					4,
					3,
					2,
				},
			},
		},
	},
}

return combat_ranges
