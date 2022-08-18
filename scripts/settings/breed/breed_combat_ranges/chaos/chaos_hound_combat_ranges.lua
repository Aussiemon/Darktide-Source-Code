local EffectTemplates = require("scripts/settings/fx/effect_templates")
local combat_ranges = {
	name = "chaos_hound",
	starting_combat_range = "far",
	config = {
		far = {
			{
				switch_combat_range = "close",
				distance_operator = "lesser",
				distance = 30,
				sticky_time = 1
			}
		},
		close = {
			{
				switch_combat_range = "far",
				distance_operator = "greater",
				distance = 32,
				sticky_time = 0
			}
		}
	},
	start_effect_template = EffectTemplates.chaos_hound_approach
}

return combat_ranges
