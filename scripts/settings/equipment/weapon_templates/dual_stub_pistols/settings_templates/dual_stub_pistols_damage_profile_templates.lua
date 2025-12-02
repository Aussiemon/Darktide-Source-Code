-- chunkname: @scripts/settings/equipment/weapon_templates/dual_stub_pistols/settings_templates/dual_stub_pistols_damage_profile_templates.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local DamageProfileSettings = require("scripts/settings/damage/damage_profile_settings")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local GibbingSettings = require("scripts/settings/gibbing/gibbing_settings")
local HerdingTemplates = require("scripts/settings/damage/herding_templates")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local WoundsTemplates = require("scripts/settings/damage/wounds_templates")
local armor_types = ArmorSettings.types
local crit_armor_mod = DamageProfileSettings.crit_armor_mod
local crit_impact_armor_mod = DamageProfileSettings.crit_impact_armor_mod
local damage_lerp_values = DamageProfileSettings.damage_lerp_values
local damage_types = DamageSettings.damage_types
local gibbing_power = GibbingSettings.gibbing_power
local gibbing_types = GibbingSettings.gibbing_types
local damage_templates = {}
local overrides = {}

table.make_unique(damage_templates)
table.make_unique(overrides)

local armor_modifiers = {
	default = {
		near = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_0_7,
				[armor_types.resistant] = damage_lerp_values.lerp_0_7,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_0_9,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_01,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_8,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_4,
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_0_6,
				[armor_types.resistant] = damage_lerp_values.lerp_0_7,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_0_8,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_05,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_8,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_4,
			},
		},
		far = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_0_8,
				[armor_types.armored] = damage_lerp_values.lerp_0_6,
				[armor_types.resistant] = damage_lerp_values.lerp_0_6,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_0_8,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_01,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_7,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_4,
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_0_9,
				[armor_types.armored] = damage_lerp_values.lerp_0_5,
				[armor_types.resistant] = damage_lerp_values.lerp_0_6,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_0_7,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_05,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_7,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_4,
			},
		},
	},
}

damage_templates.dual_stub_pistols_base = {
	shield_override_stagger_strength = 4,
	stagger_category = "ranged",
	cleave_distribution = DamageProfileSettings.double_cleave,
	ranges = {
		min = {
			10,
			20,
		},
		max = {
			20,
			30,
		},
	},
	herding_template = HerdingTemplates.shot,
	armor_damage_modifier_ranged = armor_modifiers.default,
	critical_strike = {
		gibbing_power = gibbing_power.light,
		gibbing_type = gibbing_types.ballistic,
		cleave_distribution = {
			attack = {
				3,
				5,
			},
			impact = {
				0.1,
				0.1,
			},
		},
	},
	power_distribution = {
		attack = {
			210,
			345,
		},
		impact = {
			3,
			6,
		},
	},
	accumulative_stagger_strength_multiplier = {
		1,
		1.5,
	},
	damage_type = damage_types.auto_bullet,
	gibbing_power = gibbing_power.always,
	gibbing_type = gibbing_types.ballistic,
	wounds_template = WoundsTemplates.autogun,
	suppression_value = {
		0.5,
		1.5,
	},
	on_kill_area_suppression = {
		suppression_value = {
			1,
			2,
		},
		distance = {
			3,
			5,
		},
	},
	ragdoll_push_force = {
		200,
		300,
	},
	gib_push_force = GibbingSettings.gib_push_force.ranged_light,
	targets = {
		default_target = {
			boost_curve_multiplier_finesse = 1.5,
			boost_curve = PowerLevelSettings.boost_curves.default,
			finesse_boost = {
				[armor_types.unarmored] = 0.75,
				[armor_types.resistant] = 0.5,
				[armor_types.armored] = 0.7,
				[armor_types.unarmored] = 0.5,
				[armor_types.berserker] = 0.5,
				[armor_types.super_armor] = 0.5,
				[armor_types.disgustingly_resilient] = 0.5,
				[armor_types.void_shield] = 0.5,
			},
		},
	},
}
damage_templates.dual_stub_pistols_special = {
	shield_override_stagger_strength = 4,
	stagger_category = "ranged",
	cleave_distribution = DamageProfileSettings.double_cleave,
	ranges = {
		min = {
			10,
			20,
		},
		max = {
			20,
			30,
		},
	},
	herding_template = HerdingTemplates.shot,
	armor_damage_modifier_ranged = armor_modifiers.default,
	critical_strike = {
		gibbing_power = gibbing_power.light,
		gibbing_type = gibbing_types.ballistic,
		cleave_distribution = {
			attack = {
				5,
				7,
			},
			impact = {
				0.1,
				0.1,
			},
		},
	},
	power_distribution = {
		attack = {
			210,
			345,
		},
		impact = {
			25,
			35,
		},
	},
	accumulative_stagger_strength_multiplier = {
		0.5,
		1.5,
	},
	damage_type = damage_types.auto_bullet,
	gibbing_power = gibbing_power.always,
	gibbing_type = gibbing_types.ballistic,
	wounds_template = WoundsTemplates.autogun,
	suppression_value = {
		0.5,
		1.5,
	},
	on_kill_area_suppression = {
		suppression_value = {
			1,
			2,
		},
		distance = {
			3,
			5,
		},
	},
	ragdoll_push_force = {
		200,
		300,
	},
	gib_push_force = GibbingSettings.gib_push_force.ranged_light,
	targets = {
		default_target = {
			crit_boost = 0.6,
			boost_curve = PowerLevelSettings.boost_curves.default,
			finesse_boost = {
				[armor_types.unarmored] = 0.75,
				[armor_types.resistant] = 0.5,
				[armor_types.armored] = 0.7,
				[armor_types.unarmored] = 0.5,
				[armor_types.berserker] = 0.5,
				[armor_types.super_armor] = 0.5,
				[armor_types.disgustingly_resilient] = 0.5,
				[armor_types.void_shield] = 0.5,
			},
			boost_curve_multiplier_finesse = {
				2.5,
				2.5,
			},
		},
	},
}

return {
	base_templates = damage_templates,
	overrides = overrides,
}
