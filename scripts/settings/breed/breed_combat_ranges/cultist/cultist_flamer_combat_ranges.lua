-- chunkname: @scripts/settings/breed/breed_combat_ranges/cultist/cultist_flamer_combat_ranges.lua

local EffectTemplates = require("scripts/settings/fx/effect_templates")
local combat_ranges = {
	name = "cultist_flamer",
	starting_combat_range = "far",
	config = {
		far = {
			{
				locked_in_melee_distance = 3,
				require_line_of_sight = true,
				distance = 3,
				sticky_time = 4,
				distance_operator = "lesser",
				switch_combat_range = "melee",
				target_weapon_type_distance = {
					ranged = 2,
					melee = 3
				}
			},
			{
				switch_combat_range = "close",
				sticky_time = 0,
				distance = 15,
				distance_operator = "lesser",
				require_line_of_sight = true
			}
		},
		close = {
			{
				locked_in_melee_distance = 3,
				require_line_of_sight = true,
				distance = 3,
				sticky_time = 4,
				distance_operator = "lesser",
				switch_combat_range = "melee",
				target_weapon_type_distance = {
					ranged = 2,
					melee = 3
				}
			},
			{
				switch_combat_range = "far",
				distance_operator = "greater",
				distance = 17,
				sticky_time = 0
			}
		},
		melee = {
			{
				switch_combat_range = "far",
				distance_operator = "greater",
				distance = 12,
				sticky_time = 4
			},
			{
				locked_in_melee_distance = 3,
				sticky_time = 0,
				distance = 3.5,
				distance_operator = "greater",
				switch_combat_range = "close",
				target_weapon_type_distance = {
					ranged = 3.5,
					melee = 3.5
				}
			}
		}
	},
	start_effect_template = EffectTemplates.cultist_flamer_approach
}

return combat_ranges
