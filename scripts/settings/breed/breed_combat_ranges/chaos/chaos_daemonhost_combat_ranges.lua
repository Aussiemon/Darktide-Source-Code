-- chunkname: @scripts/settings/breed/breed_combat_ranges/chaos/chaos_daemonhost_combat_ranges.lua

local EffectTemplates = require("scripts/settings/fx/effect_templates")
local combat_ranges = {
	name = "chaos_daemonhost",
	starting_combat_range = "far",
	config = {
		far = {
			{
				activate_slot_system = true,
				distance = 30,
				distance_operator = "lesser",
				sticky_time = 1,
				switch_combat_range = "close",
			},
		},
		close = {
			{
				activate_slot_system = true,
				distance = 8,
				distance_operator = "lesser",
				sticky_time = 4,
				switch_combat_range = "melee",
			},
			{
				activate_slot_system = true,
				distance = 32,
				distance_operator = "greater",
				sticky_time = 0,
				switch_combat_range = "far",
			},
		},
		melee = {
			{
				activate_slot_system = true,
				distance = 12,
				distance_operator = "greater",
				sticky_time = 0,
				switch_combat_range = "close",
			},
		},
	},
	start_effect_template = EffectTemplates.chaos_daemonhost_ambience,
}

return combat_ranges
