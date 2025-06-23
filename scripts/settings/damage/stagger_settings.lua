-- chunkname: @scripts/settings/damage/stagger_settings.lua

local stagger_settings = {}
local stagger_types = table.enum("light", "medium", "heavy", "light_ranged", "sticky", "electrocuted", "killshot", "shield_block", "shield_heavy_block", "shield_broken", "explosion", "wall_collision", "blinding")

stagger_settings.stagger_types = stagger_types
stagger_settings.stagger_categories = {
	melee = {
		stagger_types.light,
		stagger_types.medium,
		stagger_types.heavy
	},
	stab = {
		stagger_types.light_ranged,
		stagger_types.medium,
		stagger_types.heavy
	},
	sticky = {
		stagger_types.sticky
	},
	electrocuted = {
		stagger_types.electrocuted
	},
	flamer = {
		stagger_types.killshot,
		stagger_types.medium
	},
	hatchet = {
		stagger_types.killshot
	},
	uppercut = {
		stagger_types.light,
		stagger_types.medium
	},
	killshot = {
		stagger_types.killshot,
		stagger_types.medium,
		stagger_types.heavy
	},
	ranged = {
		stagger_types.light_ranged,
		stagger_types.medium,
		stagger_types.heavy
	},
	explosion = {
		stagger_types.light,
		stagger_types.medium,
		stagger_types.heavy,
		stagger_types.explosion
	},
	force_field = {
		stagger_types.light
	},
	blinding = {
		stagger_types.blinding
	}
}
stagger_settings.stagger_duration_scale = {
	0.75,
	1.25
}
stagger_settings.stagger_length_scale = {
	0.8,
	1.2
}
stagger_settings.default_stagger_thresholds = {
	[stagger_types.light] = 1,
	[stagger_types.medium] = 10,
	[stagger_types.heavy] = 20,
	[stagger_types.explosion] = 40,
	[stagger_types.light_ranged] = 5,
	[stagger_types.sticky] = 0.25,
	[stagger_types.electrocuted] = 0.25,
	[stagger_types.killshot] = 2,
	[stagger_types.shield_block] = 0.25,
	[stagger_types.shield_heavy_block] = 5,
	[stagger_types.shield_broken] = 10,
	[stagger_types.wall_collision] = 0.25,
	[stagger_types.blinding] = 0.25
}
stagger_settings.stagger_impact_comparison = {
	[stagger_types.explosion] = 4,
	[stagger_types.heavy] = 3,
	[stagger_types.shield_broken] = 3,
	[stagger_types.wall_collision] = 3,
	[stagger_types.medium] = 2,
	[stagger_types.shield_heavy_block] = 2,
	[stagger_types.killshot] = 1,
	[stagger_types.light] = 1,
	[stagger_types.light_ranged] = 1,
	[stagger_types.shield_block] = 1,
	[stagger_types.sticky] = 3,
	[stagger_types.electrocuted] = 1,
	[stagger_types.blinding] = 1
}
stagger_settings.default_stagger_resistance = 1
stagger_settings.max_excessive_force = 5
stagger_settings.default_stagger_count_multiplier = 1.5
stagger_settings.stagger_pool_decay_time = 1
stagger_settings.stagger_pool_decay_delay = 0.2
stagger_settings.rending_stagger_strength_modifier = 2

for _, stagger_type in pairs(stagger_types) do
	local stagger_threshold = stagger_settings.default_stagger_thresholds[stagger_type]
end

return settings("StaggerSettings", stagger_settings)
