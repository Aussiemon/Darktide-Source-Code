-- chunkname: @scripts/settings/breed/breed_combat_ranges/chaos/chaos_daemonhost_combat_ranges.lua

local EffectTemplates = require("scripts/settings/fx/effect_templates")
local combat_ranges = {
	name = "chaos_daemonhost",
	starting_combat_range = "far",
	config = {
		far = {
			{
				distance = 30,
				sticky_time = 1,
				activate_slot_system = true,
				distance_operator = "lesser",
				switch_combat_range = "close"
			}
		},
		close = {
			{
				distance = 8,
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
			}
		}
	},
	start_effect_template = EffectTemplates.chaos_daemonhost_ambience
}

return combat_ranges
