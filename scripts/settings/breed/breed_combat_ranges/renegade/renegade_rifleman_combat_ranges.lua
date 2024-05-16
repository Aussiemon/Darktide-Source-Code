-- chunkname: @scripts/settings/breed/breed_combat_ranges/renegade/renegade_rifleman_combat_ranges.lua

local combat_ranges = {
	calculate_target_velocity_dot = true,
	name = "renegade_rifleman",
	starting_combat_range = "far",
	target_velocity_dot_reset = 0.5,
	config = {
		far = {
			{
				activate_slot_system = true,
				distance = 4.5,
				distance_operator = "lesser",
				locked_in_melee_distance = 12,
				max_z_distance = 1.5,
				require_line_of_sight = true,
				sticky_time = 4,
				switch_anim_state = "to_bayonet",
				switch_combat_range = "melee",
				target_weapon_type_distance = {
					melee = 4,
					ranged = 2,
				},
			},
			{
				distance = 8,
				distance_operator = "lesser",
				require_line_of_sight = true,
				sticky_time = 0.25,
				switch_combat_range = "close",
			},
		},
		close = {
			{
				activate_slot_system = true,
				distance = 4.5,
				distance_operator = "lesser",
				locked_in_melee_distance = 12,
				max_z_distance = 1.5,
				require_line_of_sight = true,
				sticky_time = 4,
				switch_anim_state = "to_bayonet",
				switch_combat_range = "melee",
				target_weapon_type_distance = {
					melee = 4,
					ranged = 2,
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
				distance = 11,
				distance_operator = "greater",
				sticky_time = 4,
				switch_combat_range = "far",
			},
		},
		melee = {
			{
				distance = 20,
				distance_operator = "greater",
				sticky_time = 5,
				switch_anim_state = "to_riflemen",
				switch_combat_range = "far",
				switch_on_wait_slot = true,
			},
			{
				distance = 7,
				distance_operator = "greater",
				locked_in_melee_distance = 9,
				sticky_time = 3,
				switch_anim_state = "to_riflemen",
				switch_combat_range = "close",
				target_velocity_dot_distance = 6,
				z_distance = 1.9,
				target_weapon_type_distance = {
					melee = 9,
					ranged = 3,
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
