-- chunkname: @scripts/settings/breed/breed_combat_ranges/chaos/chaos_hound_mutator_combat_ranges.lua

local EffectTemplates = require("scripts/settings/fx/effect_templates")
local combat_ranges = {
	name = "chaos_hound_mutator",
	starting_combat_range = "far",
	config = {
		far = {
			{
				distance = 30,
				distance_operator = "lesser",
				sticky_time = 1,
				switch_combat_range = "close",
			},
		},
		close = {
			{
				distance = 32,
				distance_operator = "greater",
				sticky_time = 0,
				switch_combat_range = "far",
			},
		},
	},
	start_effect_template = EffectTemplates.chaos_hound_mutator_approach,
}

return combat_ranges
