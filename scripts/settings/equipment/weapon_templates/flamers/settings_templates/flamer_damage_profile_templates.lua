-- chunkname: @scripts/settings/equipment/weapon_templates/flamers/settings_templates/flamer_damage_profile_templates.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local DamageProfileSettings = require("scripts/settings/damage/damage_profile_settings")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local GibbingSettings = require("scripts/settings/gibbing/gibbing_settings")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local armor_types = ArmorSettings.types
local damage_lerp_values = DamageProfileSettings.damage_lerp_values
local damage_types = DamageSettings.damage_types
local gibbing_power = GibbingSettings.gibbing_power
local gibbing_types = GibbingSettings.gibbing_types
local damage_templates = {}
local overrides = {}

table.make_unique(damage_templates)
table.make_unique(overrides)

damage_templates.default_flamer_killshot = {
	ignore_shield = false,
	ignore_stagger_reduction = true,
	ragdoll_push_force = 750,
	stagger_category = "ranged",
	suppression_value = 4,
	cleave_distribution = {
		attack = 0.1,
		impact = 0.1,
	},
	ranges = {
		max = 30,
		min = 20,
	},
	armor_damage_modifier_ranged = {
		near = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_1,
				[armor_types.resistant] = damage_lerp_values.lerp_2,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_1,
				[armor_types.super_armor] = damage_lerp_values.lerp_2,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
				[armor_types.void_shield] = damage_lerp_values.lerp_1,
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_2,
				[armor_types.armored] = damage_lerp_values.lerp_3,
				[armor_types.resistant] = damage_lerp_values.lerp_2,
				[armor_types.player] = damage_lerp_values.lerp_2,
				[armor_types.berserker] = damage_lerp_values.lerp_2,
				[armor_types.super_armor] = damage_lerp_values.lerp_2,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_2_5,
				[armor_types.void_shield] = damage_lerp_values.lerp_2_5,
			},
		},
		far = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_1,
				[armor_types.resistant] = damage_lerp_values.lerp_2,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_1,
				[armor_types.super_armor] = damage_lerp_values.lerp_2,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
				[armor_types.void_shield] = damage_lerp_values.lerp_1,
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_2,
				[armor_types.armored] = damage_lerp_values.lerp_3,
				[armor_types.resistant] = damage_lerp_values.lerp_2,
				[armor_types.player] = damage_lerp_values.lerp_2,
				[armor_types.berserker] = damage_lerp_values.lerp_2,
				[armor_types.super_armor] = damage_lerp_values.lerp_2,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_2_5,
				[armor_types.void_shield] = damage_lerp_values.lerp_2_5,
			},
		},
	},
	power_distribution = {
		attack = 2,
		impact = 1.5,
	},
	damage_type = damage_types.plasma,
	gibbing_power = gibbing_power.medium,
	gibbing_type = gibbing_types.plasma,
	on_kill_area_suppression = {
		distance = 8,
		suppression_value = 10,
	},
	targets = {
		default_target = {
			boost_curve_multiplier_finesse = 0.5,
			boost_curve = PowerLevelSettings.boost_curves.default,
			finesse_boost = {
				[armor_types.unarmored] = 0.75,
			},
		},
	},
}
damage_templates.default_flamer_bfg = {
	ignore_shield = true,
	ignore_stagger_reduction = true,
	ragdoll_push_force = 100,
	stagger_category = "ranged",
	suppression_value = 8,
	cleave_distribution = {
		attack = 0.15,
		impact = 0.15,
	},
	ranges = {
		max = 20,
		min = 10,
	},
	armor_damage_modifier_ranged = {
		near = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_1,
				[armor_types.resistant] = damage_lerp_values.lerp_1,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_1,
				[armor_types.super_armor] = damage_lerp_values.no_damage,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
				[armor_types.void_shield] = damage_lerp_values.lerp_1,
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_2,
				[armor_types.armored] = damage_lerp_values.lerp_3,
				[armor_types.resistant] = damage_lerp_values.lerp_2,
				[armor_types.player] = damage_lerp_values.lerp_2,
				[armor_types.berserker] = damage_lerp_values.lerp_2,
				[armor_types.super_armor] = damage_lerp_values.no_damage,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_3,
				[armor_types.void_shield] = damage_lerp_values.lerp_3,
			},
		},
		far = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_1,
				[armor_types.resistant] = damage_lerp_values.lerp_1,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_1,
				[armor_types.super_armor] = damage_lerp_values.no_damage,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
				[armor_types.void_shield] = damage_lerp_values.lerp_1,
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_2,
				[armor_types.armored] = damage_lerp_values.lerp_3,
				[armor_types.resistant] = damage_lerp_values.lerp_2,
				[armor_types.player] = damage_lerp_values.lerp_2,
				[armor_types.berserker] = damage_lerp_values.lerp_2,
				[armor_types.super_armor] = damage_lerp_values.lerp_2,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_3,
				[armor_types.void_shield] = damage_lerp_values.lerp_3,
			},
		},
	},
	power_distribution = {
		attack = 4,
		impact = 4,
	},
	damage_type = damage_types.plasma,
	gibbing_power = gibbing_power.heavy,
	gibbing_type = gibbing_types.plasma,
	on_kill_area_suppression = {
		distance = 8,
		suppression_value = 10,
	},
	targets = {
		default_target = {
			boost_curve_multiplier_finesse = 1.2,
			boost_curve = PowerLevelSettings.boost_curves.default,
			finesse_boost = {
				[armor_types.unarmored] = 0.75,
			},
		},
	},
}
damage_templates.default_flamer_demolition = {
	ignore_stagger_reduction = true,
	ragdoll_push_force = 12,
	stagger_category = "ranged",
	suppression_value = 0.5,
	cleave_distribution = {
		attack = 0.1,
		impact = 0.1,
	},
	ranges = {
		max = 20,
		min = 10,
	},
	armor_damage_modifier_ranged = {
		near = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_1,
				[armor_types.resistant] = damage_lerp_values.lerp_1,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_1,
				[armor_types.super_armor] = damage_lerp_values.no_damage,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
				[armor_types.void_shield] = damage_lerp_values.lerp_1,
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_2,
				[armor_types.resistant] = damage_lerp_values.lerp_1,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_1,
				[armor_types.super_armor] = damage_lerp_values.no_damage,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_2,
				[armor_types.void_shield] = damage_lerp_values.lerp_2,
			},
		},
		far = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_1,
				[armor_types.resistant] = damage_lerp_values.lerp_1,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_1,
				[armor_types.super_armor] = damage_lerp_values.no_damage,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
				[armor_types.void_shield] = damage_lerp_values.lerp_1,
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_2,
				[armor_types.resistant] = damage_lerp_values.lerp_1,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_1,
				[armor_types.super_armor] = damage_lerp_values.no_damage,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_2,
				[armor_types.void_shield] = damage_lerp_values.lerp_2,
			},
		},
	},
	power_distribution = {
		attack = 1,
		impact = 3,
	},
	damage_type = damage_types.laser,
	gibbing_type = gibbing_types.plasma,
	gibbing_power = gibbing_power.heavy,
	targets = {
		default_target = {
			boost_curve_multiplier_finesse = 1.2,
			boost_curve = PowerLevelSettings.boost_curves.default,
			finesse_boost = {
				[armor_types.unarmored] = 0.75,
			},
		},
	},
}
overrides.light_flamer_demolition = {
	parent_template_name = "default_flamer_demolition",
	overrides = {
		{
			"power_distribution",
			"attack",
			0.25,
		},
		{
			"power_distribution",
			"impact",
			0.5,
		},
	},
}

local assault_flamer_armor_mod = {
	near = {
		attack = {
			[armor_types.unarmored] = 2,
			[armor_types.armored] = 1,
			[armor_types.resistant] = 2,
			[armor_types.player] = 1,
			[armor_types.berserker] = 2.5,
			[armor_types.super_armor] = 0.1,
			[armor_types.disgustingly_resilient] = 1.5,
			[armor_types.void_shield] = 1,
		},
		impact = {
			[armor_types.unarmored] = 1,
			[armor_types.armored] = 0.75,
			[armor_types.resistant] = 0.75,
			[armor_types.player] = 1,
			[armor_types.berserker] = 1,
			[armor_types.super_armor] = 0.1,
			[armor_types.disgustingly_resilient] = 1,
			[armor_types.void_shield] = 1,
		},
	},
	far = {
		attack = {
			[armor_types.unarmored] = 1,
			[armor_types.armored] = 0.5,
			[armor_types.resistant] = 1,
			[armor_types.player] = 1,
			[armor_types.berserker] = 1,
			[armor_types.super_armor] = 0,
			[armor_types.disgustingly_resilient] = 0.7,
			[armor_types.void_shield] = 1,
		},
		impact = {
			[armor_types.unarmored] = 0.75,
			[armor_types.armored] = 0.1,
			[armor_types.resistant] = 0.3,
			[armor_types.player] = 0,
			[armor_types.berserker] = 0.5,
			[armor_types.super_armor] = 0.01,
			[armor_types.disgustingly_resilient] = 0.75,
			[armor_types.void_shield] = 0.5,
		},
	},
}
local assault_flamer_burst_armor_mod = {
	near = {
		attack = {
			[armor_types.unarmored] = 1,
			[armor_types.armored] = 1.75,
			[armor_types.resistant] = 1,
			[armor_types.player] = 1,
			[armor_types.berserker] = 1.5,
			[armor_types.super_armor] = 0.25,
			[armor_types.disgustingly_resilient] = 1.5,
			[armor_types.void_shield] = 1,
		},
		impact = {
			[armor_types.unarmored] = 1,
			[armor_types.armored] = 1,
			[armor_types.resistant] = 0.75,
			[armor_types.player] = 1,
			[armor_types.berserker] = 1,
			[armor_types.super_armor] = 0.1,
			[armor_types.disgustingly_resilient] = 1,
			[armor_types.void_shield] = 1,
		},
	},
	far = {
		attack = {
			[armor_types.unarmored] = 0.75,
			[armor_types.armored] = 0.75,
			[armor_types.resistant] = 0.5,
			[armor_types.player] = 1,
			[armor_types.berserker] = 1,
			[armor_types.super_armor] = 0,
			[armor_types.disgustingly_resilient] = 0.7,
			[armor_types.void_shield] = 1,
		},
		impact = {
			[armor_types.unarmored] = 1,
			[armor_types.armored] = 1,
			[armor_types.resistant] = 0.75,
			[armor_types.player] = 0.5,
			[armor_types.berserker] = 0.5,
			[armor_types.super_armor] = 0.01,
			[armor_types.disgustingly_resilient] = 1,
			[armor_types.void_shield] = 1,
		},
	},
}

damage_templates.default_flamer_assault = {
	accumulative_stagger_strength_multiplier = 0.5,
	duration_scale_bonus = 0.5,
	gibbing_power = 0,
	ragdoll_push_force = 10,
	stagger_category = "flamer",
	suppression_value = 10,
	cleave_distribution = {
		attack = 0.1,
		impact = 0.1,
	},
	ranges = {
		max = 15,
		min = 5,
	},
	armor_damage_modifier_ranged = assault_flamer_armor_mod,
	damage_type = damage_types.burning,
	gibbing_type = gibbing_types.plasma,
	targets = {
		{
			power_distribution = {
				attack = {
					16,
					24,
				},
				impact = {
					1,
					2,
				},
			},
		},
		{
			power_distribution = {
				attack = {
					20,
					32,
				},
				impact = {
					2,
					4,
				},
			},
		},
		{
			power_distribution = {
				attack = {
					24,
					40,
				},
				impact = {
					3,
					6,
				},
			},
		},
		{
			power_distribution = {
				attack = {
					30,
					60,
				},
				impact = {
					4,
					8,
				},
			},
		},
		{
			power_distribution = {
				attack = {
					35,
					70,
				},
				impact = {
					6,
					12,
				},
			},
		},
		{
			power_distribution = {
				attack = {
					40,
					80,
				},
				impact = {
					10,
					15,
				},
			},
		},
		default_target = {
			power_distribution = {
				attack = {
					60,
					100,
				},
				impact = {
					10,
					15,
				},
			},
		},
	},
}
damage_templates.default_flamer_assault_burst = {
	duration_scale_bonus = 0.1,
	gibbing_power = 0,
	ignore_stagger_reduction = true,
	ragdoll_push_force = 12,
	stagger_category = "flamer",
	suppression_value = 5,
	cleave_distribution = {
		attack = 0.1,
		impact = 0.1,
	},
	ranges = {
		max = 15,
		min = 5,
	},
	armor_damage_modifier_ranged = assault_flamer_burst_armor_mod,
	damage_type = damage_types.burning,
	gibbing_type = gibbing_types.plasma,
	power_distribution = {
		attack = {
			5,
			15,
		},
		impact = {
			5,
			10,
		},
	},
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default,
			power_distribution = {
				attack = {
					15,
					30,
				},
				impact = {
					10,
					15,
				},
			},
		},
	},
}

return {
	base_templates = damage_templates,
	overrides = overrides,
}
