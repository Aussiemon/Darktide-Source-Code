local EffectTemplates = require("scripts/settings/fx/effect_templates")
local combat_ranges = {
	name = "renegade_executor",
	starting_combat_range = "far",
	config = {
		far = {
			{
				distance = 30,
				sticky_time = 0,
				activate_slot_system = true,
				distance_operator = "lesser",
				switch_combat_range = "close"
			}
		},
		close = {
			{
				distance = 10,
				sticky_time = 4,
				activate_slot_system = true,
				distance_operator = "lesser",
				switch_combat_range = "melee"
			},
			{
				distance = 32,
				sticky_time = 0,
				activate_slot_system = true,
				distance_operator = "greater",
				switch_combat_range = "far"
			}
		},
		melee = {
			{
				distance = 12,
				sticky_time = 0,
				activate_slot_system = true,
				distance_operator = "greater",
				switch_combat_range = "close"
			},
			effect_template = EffectTemplates.renegade_executor_chainaxe
		}
	}
}

return combat_ranges
