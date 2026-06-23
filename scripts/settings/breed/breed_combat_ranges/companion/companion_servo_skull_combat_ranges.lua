-- chunkname: @scripts/settings/breed/breed_combat_ranges/companion/companion_servo_skull_combat_ranges.lua

local combat_ranges = {
	name = "companion_servo_skull",
	starting_combat_range = "far",
	config = {
		far = {
			{
				activate_slot_system = true,
				distance = 3,
				distance_operator = "lesser",
				locked_in_melee_distance = 12,
				max_z_distance = 1.5,
				require_line_of_sight = true,
				sticky_time = 4,
				switch_combat_range = "melee",
				switch_weapon_slot = "slot_ranged_weapon",
			},
			{
				distance = 10,
				distance_operator = "lesser",
				require_line_of_sight = true,
				sticky_time = 0.25,
				switch_combat_range = "close",
			},
		},
		close = {
			{
				activate_slot_system = true,
				distance = 2,
				distance_operator = "lesser",
				locked_in_melee_distance = 12,
				max_z_distance = 1.5,
				require_line_of_sight = true,
				sticky_time = 4,
				switch_combat_range = "melee",
				switch_weapon_slot = "slot_ranged_weapon",
				target_weapon_type_distance = {
					melee = 3,
					ranged = 2,
				},
			},
			{
				distance = 13,
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
				switch_weapon_slot = "slot_ranged_weapon",
			},
			{
				distance = 4,
				distance_operator = "greater",
				locked_in_melee_distance = 4,
				sticky_time = 3,
				switch_anim_state = "to_riflemen",
				switch_combat_range = "close",
				switch_weapon_slot = "slot_ranged_weapon",
				z_distance = 1.9,
				target_weapon_type_distance = {
					melee = 4,
					ranged = 3,
				},
			},
		},
	},
}

return combat_ranges
