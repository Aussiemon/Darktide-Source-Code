-- chunkname: @scripts/settings/equipment/weapon_templates/bolt_pistols/settings_templates/boltpistol_damage_profile_templates.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local DamageProfileSettings = require("scripts/settings/damage/damage_profile_settings")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local GibbingSettings = require("scripts/settings/gibbing/gibbing_settings")
local WoundsTemplates = require("scripts/settings/damage/wounds_templates")
local GibbingPower = GibbingSettings.gibbing_power
local GibbingTypes = GibbingSettings.gibbing_types
local damage_types = DamageSettings.damage_types
local armor_types = ArmorSettings.types
local damage_templates = {}
local overrides = {}

table.make_unique(damage_templates)
table.make_unique(overrides)

local crit_armor_mod = DamageProfileSettings.crit_armor_mod
local crit_impact_armor_mod = DamageProfileSettings.crit_impact_armor_mod
local damage_lerp_values = DamageProfileSettings.damage_lerp_values
local no_cleave = DamageProfileSettings.no_cleave
local single_cleave = DamageProfileSettings.single_cleave
local double_cleave = DamageProfileSettings.double_cleave

damage_templates.default_boltpistol_damage = {
	ragdoll_only = true,
	ragdoll_push_force = 600,
	shield_multiplier = 10,
	stagger_category = "ranged",
	suppression_value = 3,
	cleave_distribution = no_cleave,
	ranges = {
		max = 30,
		min = 7.5,
	},
	armor_damage_modifier_ranged = {
		near = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_0_9,
				[armor_types.armored] = damage_lerp_values.lerp_1,
				[armor_types.resistant] = damage_lerp_values.lerp_1,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_1,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_4,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_5,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_25,
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_1,
				[armor_types.resistant] = damage_lerp_values.lerp_1,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_0_5,
				[armor_types.super_armor] = damage_lerp_values.lerp_1,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
				[armor_types.void_shield] = damage_lerp_values.lerp_1,
			},
		},
		far = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_1_1,
				[armor_types.resistant] = damage_lerp_values.lerp_1,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_1,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_4,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_5,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_25,
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_0_75,
				[armor_types.resistant] = damage_lerp_values.lerp_1,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_0_5,
				[armor_types.super_armor] = damage_lerp_values.lerp_1,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
				[armor_types.void_shield] = damage_lerp_values.lerp_1,
			},
		},
	},
	power_distribution = {
		attack = {
			330,
			660,
		},
		impact = {
			10,
			20,
		},
	},
	damage_type = damage_types.boltshell,
	gibbing_power = GibbingPower.heavy,
	gibbing_type = GibbingTypes.boltshell,
	wounds_template = WoundsTemplates.bolter,
	on_kill_area_suppression = {
		distance = 8,
		suppression_value = 12,
	},
	gib_push_force = GibbingSettings.gib_push_force.ranged_heavy,
	targets = {
		default_target = {
			boost_curve_multiplier_finesse = 1,
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
}
damage_templates.boltpistol_weapon_special = {
	is_push = true,
	stagger_category = "melee",
	stagger_override = "medium",
	power_distribution = {
		attack = 20,
		impact = 11,
	},
	cleave_distribution = double_cleave,
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = 1.3,
			[armor_types.armored] = 0.3,
			[armor_types.resistant] = 0.5,
			[armor_types.player] = 0,
			[armor_types.berserker] = 0.8,
			[armor_types.super_armor] = 0,
			[armor_types.disgustingly_resilient] = 1,
			[armor_types.void_shield] = 0.5,
		},
		impact = {
			[armor_types.unarmored] = 1.25,
			[armor_types.armored] = 1,
			[armor_types.resistant] = 1,
			[armor_types.player] = 0,
			[armor_types.berserker] = 0.7,
			[armor_types.super_armor] = 0.5,
			[armor_types.disgustingly_resilient] = 1,
			[armor_types.void_shield] = 0,
		},
	},
	gibbing_power = GibbingPower.always,
	gibbing_type = GibbingTypes.default,
	targets = {
		default_target = {},
	},
}
damage_templates.boltpistol_stop_explosion = {
	ragdoll_push_force = 200,
	stagger_category = "flamer",
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
				[armor_types.unarmored] = damage_lerp_values.no_damage,
				[armor_types.armored] = damage_lerp_values.no_damage,
				[armor_types.resistant] = damage_lerp_values.no_damage,
				[armor_types.player] = damage_lerp_values.no_damage,
				[armor_types.berserker] = damage_lerp_values.no_damage,
				[armor_types.super_armor] = damage_lerp_values.no_damage,
				[armor_types.disgustingly_resilient] = damage_lerp_values.no_damage,
				[armor_types.void_shield] = damage_lerp_values.no_damage,
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_1,
				[armor_types.resistant] = damage_lerp_values.lerp_1,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_1,
				[armor_types.super_armor] = damage_lerp_values.no_damage,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
				[armor_types.void_shield] = damage_lerp_values.lerp_1,
			},
		},
		far = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.no_damage,
				[armor_types.armored] = damage_lerp_values.no_damage,
				[armor_types.resistant] = damage_lerp_values.no_damage,
				[armor_types.player] = damage_lerp_values.no_damage,
				[armor_types.berserker] = damage_lerp_values.no_damage,
				[armor_types.super_armor] = damage_lerp_values.no_damage,
				[armor_types.disgustingly_resilient] = damage_lerp_values.no_damage,
				[armor_types.void_shield] = damage_lerp_values.no_damage,
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_0_25,
				[armor_types.armored] = damage_lerp_values.no_damage,
				[armor_types.resistant] = damage_lerp_values.lerp_0_25,
				[armor_types.player] = damage_lerp_values.lerp_0_25,
				[armor_types.berserker] = damage_lerp_values.lerp_0_25,
				[armor_types.super_armor] = damage_lerp_values.no_damage,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_25,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_25,
			},
		},
	},
	power_distribution = {
		attack = 0,
		impact = 16,
	},
	damage_type = damage_types.boltshell,
	gibbing_power = GibbingPower.heavy,
	gibbing_type = GibbingTypes.boltshell,
	wounds_template = WoundsTemplates.bolter,
	targets = {
		default_target = {
			boost_curve_multiplier_finesse = 1.2,
			boost_curve = PowerLevelSettings.boost_curves.default,
			finesse_boost = {
				[armor_types.unarmored] = 0.75,
			},
		},
	},
	gib_push_force = GibbingSettings.gib_push_force.ranged_heavy,
}
damage_templates.boltpistol_kill_explosion = {
	ragdoll_push_force = 200,
	stagger_category = "flamer",
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
				[armor_types.player] = damage_lerp_values.no_damage,
				[armor_types.berserker] = damage_lerp_values.lerp_1,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_8,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
				[armor_types.void_shield] = damage_lerp_values.lerp_1,
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_1,
				[armor_types.resistant] = damage_lerp_values.lerp_1,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_1,
				[armor_types.super_armor] = damage_lerp_values.no_damage,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
				[armor_types.void_shield] = damage_lerp_values.lerp_1,
			},
		},
		far = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_0_25,
				[armor_types.armored] = damage_lerp_values.lerp_0_1,
				[armor_types.resistant] = damage_lerp_values.lerp_0_25,
				[armor_types.player] = damage_lerp_values.no_damage,
				[armor_types.berserker] = damage_lerp_values.lerp_0_25,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_1,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_25,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_25,
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_0_25,
				[armor_types.armored] = damage_lerp_values.no_damage,
				[armor_types.resistant] = damage_lerp_values.lerp_0_25,
				[armor_types.player] = damage_lerp_values.lerp_0_25,
				[armor_types.berserker] = damage_lerp_values.lerp_0_25,
				[armor_types.super_armor] = damage_lerp_values.no_damage,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_25,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_25,
			},
		},
	},
	power_distribution = {
		attack = 50,
		impact = 16,
	},
	damage_type = damage_types.boltshell,
	gibbing_power = GibbingPower.heavy,
	gibbing_type = GibbingTypes.boltshell,
	wounds_template = WoundsTemplates.bolter,
	on_kill_area_suppression = {
		distance = 8,
		suppression_value = 12,
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
	gib_push_force = GibbingSettings.gib_push_force.ranged_heavy,
}

return {
	base_templates = damage_templates,
	overrides = overrides,
}
