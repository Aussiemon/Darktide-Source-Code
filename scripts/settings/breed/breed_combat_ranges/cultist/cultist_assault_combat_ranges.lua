-- chunkname: @scripts/settings/breed/breed_combat_ranges/cultist/cultist_assault_combat_ranges.lua

local combat_ranges = {
	calculate_target_velocity_dot = true,
	name = "cultist_assault",
	starting_combat_range = "far",
	target_velocity_dot_reset = 0.5,
	config = {
		far = {
			{
				activate_slot_system = true,
				distance = 4.5,
				distance_operator = "lesser",
				locked_in_melee_distance = 7,
				max_z_distance = 1.5,
				require_line_of_sight = true,
				sticky_time = 4,
				switch_combat_range = "melee",
				switch_weapon_slot = "slot_melee_weapon",
				target_weapon_type_distance = {
					melee = 6,
					ranged = 5,
				},
			},
			{
				distance = 9,
				distance_operator = "lesser",
				require_line_of_sight = true,
				sticky_time = 0.25,
				switch_anim_state = "to_assaulter",
				switch_combat_range = "close",
			},
		},
		close = {
			{
				activate_slot_system = true,
				distance = 4.5,
				distance_operator = "lesser",
				locked_in_melee_distance = 8,
				max_z_distance = 1.5,
				require_line_of_sight = true,
				sticky_time = 2,
				switch_combat_range = "melee",
				switch_weapon_slot = "slot_melee_weapon",
				target_weapon_type_distance = {
					melee = 6,
					ranged = 5,
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
				sticky_time = 2,
				switch_anim_state = "to_riflemen",
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
				switch_weapon_slot = "slot_ranged_weapon",
			},
			{
				distance = 7,
				distance_operator = "greater",
				locked_in_melee_distance = 9,
				sticky_time = 2,
				switch_combat_range = "close",
				switch_weapon_slot = "slot_ranged_weapon",
				target_velocity_dot_distance = 6,
				z_distance = 1.9,
				target_weapon_type_distance = {
					melee = 8,
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
