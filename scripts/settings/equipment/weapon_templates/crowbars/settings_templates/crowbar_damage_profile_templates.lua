-- chunkname: @scripts/settings/equipment/weapon_templates/crowbars/settings_templates/crowbar_damage_profile_templates.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local DamageProfileSettings = require("scripts/settings/damage/damage_profile_settings")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local GibbingSettings = require("scripts/settings/gibbing/gibbing_settings")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local WoundsTemplates = require("scripts/settings/damage/wounds_templates")
local armor_types = ArmorSettings.types
local crit_armor_mod = DamageProfileSettings.axe_crit_mod
local damage_lerp_values = DamageProfileSettings.damage_lerp_values
local damage_types = DamageSettings.damage_types
local gibbing_power = GibbingSettings.gibbing_power
local gibbing_types = GibbingSettings.gibbing_types
local melee_attack_strengths = AttackSettings.melee_attack_strength
local no_cleave = DamageProfileSettings.no_cleave
local double_cleave = DamageProfileSettings.double_cleave
local single_cleave = DamageProfileSettings.single_cleave
local medium_cleave = DamageProfileSettings.medium_cleave
local large_cleave = DamageProfileSettings.large_cleave
local big_cleave = DamageProfileSettings.big_cleave
local damage_templates = {}
local overrides = {}

table.make_unique(damage_templates)
table.make_unique(overrides)

local crowbar_am = {
	attack = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1,
		[armor_types.armored] = damage_lerp_values.lerp_0_75,
		[armor_types.resistant] = damage_lerp_values.lerp_0_75,
		[armor_types.player] = damage_lerp_values.lerp_0_25,
		[armor_types.berserker] = damage_lerp_values.lerp_0_9,
		[armor_types.super_armor] = damage_lerp_values.lerp_0_1,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
		[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
	},
	impact = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1,
		[armor_types.armored] = damage_lerp_values.lerp_1,
		[armor_types.resistant] = damage_lerp_values.lerp_1,
		[armor_types.player] = damage_lerp_values.lerp_1,
		[armor_types.berserker] = damage_lerp_values.lerp_1,
		[armor_types.super_armor] = damage_lerp_values.lerp_1,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
		[armor_types.void_shield] = damage_lerp_values.lerp_1,
	},
}

damage_templates.light_crowbar_tank = {
	finesse_ability_damage_multiplier = 2,
	ragdoll_only = true,
	ragdoll_push_force = 250,
	stagger_category = "melee",
	cleave_distribution = large_cleave,
	gibbing_power = gibbing_power.light,
	gibbing_type = gibbing_types.crushing,
	melee_attack_strength = melee_attack_strengths.light,
	gib_push_force = GibbingSettings.gib_push_force.blunt_light,
	wounds_template = WoundsTemplates.blunt,
	armor_damage_modifier = crowbar_am,
	crit_mod = crit_armor_mod,
	targets = {
		{
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_8,
					[armor_types.resistant] = damage_lerp_values.lerp_0_8,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_9,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_1,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_1,
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_1,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_1,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_1,
				},
			},
			power_distribution = {
				attack = {
					60,
					120,
				},
				impact = {
					8,
					14,
				},
			},
			boost_curve_multiplier_finesse = {
				0.4,
				0.8,
			},
			power_level_multiplier = {
				0.5,
				1.5,
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
					10,
				},
			},
		},
		{
			power_distribution = {
				attack = {
					22,
					50,
				},
				impact = {
					5,
					7,
				},
			},
		},
		{
			power_distribution = {
				attack = {
					15,
					35,
				},
				impact = {
					4,
					5,
				},
			},
		},
		default_target = {
			power_distribution = {
				attack = {
					10,
					25,
				},
				impact = {
					2,
					5,
				},
			},
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
}
damage_templates.heavy_crowbar_tank = {
	finesse_ability_damage_multiplier = 2,
	ragdoll_only = true,
	ragdoll_push_force = 250,
	stagger_category = "melee",
	cleave_distribution = big_cleave,
	gibbing_power = gibbing_power.always,
	gibbing_type = gibbing_types.crushing,
	melee_attack_strength = melee_attack_strengths.heavy,
	gib_push_force = GibbingSettings.gib_push_force.blunt_light,
	wounds_template = WoundsTemplates.blunt,
	armor_damage_modifier = crowbar_am,
	crit_mod = crit_armor_mod,
	targets = {
		{
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_8,
					[armor_types.resistant] = damage_lerp_values.lerp_0_8,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_1,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_25,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_1,
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_1,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_1,
					[armor_types.super_armor] = damage_lerp_values.lerp_1,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_1,
				},
			},
			power_distribution = {
				attack = {
					105,
					210,
				},
				impact = {
					10,
					20,
				},
			},
			boost_curve_multiplier_finesse = {
				0.4,
				0.8,
			},
			power_level_multiplier = {
				0.5,
				1.5,
			},
		},
		{
			power_distribution = {
				attack = {
					70,
					140,
				},
				impact = {
					8,
					16,
				},
			},
		},
		{
			power_distribution = {
				attack = {
					45,
					90,
				},
				impact = {
					7,
					14,
				},
			},
		},
		{
			power_distribution = {
				attack = {
					30,
					65,
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
					25,
					50,
				},
				impact = {
					5,
					10,
				},
			},
		},
		default_target = {
			power_distribution = {
				attack = {
					15,
					35,
				},
				impact = {
					5,
					10,
				},
			},
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
}
damage_templates.light_crowbar_smiter = {
	finesse_ability_damage_multiplier = 2,
	ragdoll_only = true,
	ragdoll_push_force = 250,
	stagger_category = "melee",
	cleave_distribution = double_cleave,
	gibbing_power = gibbing_power.light,
	gibbing_type = gibbing_types.crushing,
	melee_attack_strength = melee_attack_strengths.light,
	gib_push_force = GibbingSettings.gib_push_force.blunt_light,
	wounds_template = WoundsTemplates.blunt,
	armor_damage_modifier = crowbar_am,
	crit_mod = crit_armor_mod,
	targets = {
		{
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_9,
					[armor_types.resistant] = damage_lerp_values.lerp_0_9,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_1,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_25,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_1,
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_1,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_1,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_8,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_1,
				},
			},
			power_distribution = {
				attack = {
					90,
					180,
				},
				impact = {
					8,
					14,
				},
			},
			boost_curve_multiplier_finesse = {
				0.6,
				1.2,
			},
			power_level_multiplier = {
				0.5,
				1.5,
			},
		},
		{
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = {
					30,
					70,
				},
				impact = {
					6,
					10,
				},
			},
		},
		default_target = {
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = {
					10,
					20,
				},
				impact = {
					2,
					5,
				},
			},
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
}
damage_templates.heavy_crowbar_smiter = {
	finesse_ability_damage_multiplier = 2,
	ragdoll_only = true,
	ragdoll_push_force = 300,
	stagger_category = "melee",
	cleave_distribution = medium_cleave,
	gibbing_power = gibbing_power.always,
	gibbing_type = gibbing_types.crushing,
	melee_attack_strength = melee_attack_strengths.heavy,
	gib_push_force = GibbingSettings.gib_push_force.blunt_light,
	wounds_template = WoundsTemplates.blunt,
	armor_damage_modifier = crowbar_am,
	crit_mod = crit_armor_mod,
	targets = {
		{
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_9,
					[armor_types.resistant] = damage_lerp_values.lerp_0_9,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_1,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_4,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_1,
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_1,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_1,
					[armor_types.super_armor] = damage_lerp_values.lerp_1,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_1,
				},
			},
			power_distribution = {
				attack = {
					175,
					350,
				},
				impact = {
					12,
					24,
				},
			},
			boost_curve_multiplier_finesse = {
				0.8,
				1.6,
			},
			power_level_multiplier = {
				0.5,
				1.5,
			},
		},
		{
			power_distribution = {
				attack = {
					60,
					120,
				},
				impact = {
					8,
					16,
				},
			},
			boost_curve_multiplier_finesse = {
				0.4,
				0.8,
			},
		},
		{
			power_distribution = {
				attack = {
					25,
					50,
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
					15,
					30,
				},
				impact = {
					4,
					8,
				},
			},
		},
		default_target = {
			power_distribution = {
				attack = {
					10,
					25,
				},
				impact = {
					3,
					6,
				},
			},
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
}
damage_templates.light_crowbar_linesman = {
	finesse_ability_damage_multiplier = 2,
	ragdoll_push_force = 250,
	stagger_category = "melee",
	gibbing_power = gibbing_power.light,
	gibbing_type = gibbing_types.crushing,
	melee_attack_strength = melee_attack_strengths.light,
	gib_push_force = GibbingSettings.gib_push_force.sawing_medium,
	wounds_template = WoundsTemplates.blunt,
	armor_damage_modifier = crowbar_am,
	crit_mod = crit_armor_mod,
	targets = {
		{
			power_distribution = {
				attack = {
					60,
					125,
				},
				impact = {
					4,
					8,
				},
			},
			boost_curve_multiplier_finesse = {
				0.4,
				0.8,
			},
			power_level_multiplier = {
				0.5,
				1.5,
			},
		},
		{
			power_distribution = {
				attack = {
					45,
					90,
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
					25,
					55,
				},
				impact = {
					3,
					6,
				},
			},
		},
		default_target = {
			power_distribution = {
				attack = {
					10,
					30,
				},
				impact = {
					2,
					5,
				},
			},
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
}
overrides.light_crowbar_special = {
	parent_template_name = "light_crowbar_smiter",
	overrides = {
		{
			"stagger_category",
			"melee",
		},
		{
			"stagger_override",
			"light",
		},
		{
			"cleave_distribution",
			no_cleave,
		},
		{
			"damage_type",
			damage_types.sawing_stuck,
		},
		{
			"ignore_instant_ragdoll_chance",
			true,
		},
		{
			"targets",
			1,
			"power_distribution",
			"attack",
			{
				95,
				190,
			},
		},
		{
			"targets",
			1,
			"power_distribution",
			"impact",
			12,
		},
		{
			"targets",
			1,
			"armor_damage_modifier",
			"attack",
			"armored",
			damage_lerp_values.lerp_0_9,
		},
		{
			"targets",
			1,
			"armor_damage_modifier",
			"attack",
			"super_armor",
			damage_lerp_values.lerp_0_4,
		},
	},
}
overrides.light_crowbar_sticky = {
	parent_template_name = "light_crowbar_tank",
	overrides = {
		{
			"stagger_category",
			"melee",
		},
		{
			"stagger_override",
			"light",
		},
		{
			"damage_type",
			damage_types.sawing_stuck,
		},
		{
			"ignore_instant_ragdoll_chance",
			true,
		},
		{
			"ignore_stagger_reduction",
			true,
		},
		{
			"targets",
			1,
			"power_distribution",
			"attack",
			{
				70,
				140,
			},
		},
		{
			"targets",
			1,
			"power_distribution",
			"impact",
			16,
		},
		{
			"targets",
			1,
			"armor_damage_modifier",
			"attack",
			"armored",
			damage_lerp_values.lerp_1,
		},
		{
			"targets",
			1,
			"armor_damage_modifier",
			"attack",
			"super_armor",
			damage_lerp_values.lerp_0_4,
		},
	},
}
overrides.heavy_crowbar_special = {
	parent_template_name = "heavy_crowbar_tank",
	overrides = {
		{
			"stagger_category",
			"sticky",
		},
		{
			"cleave_distribution",
			no_cleave,
		},
		{
			"damage_type",
			damage_types.sawing_stuck,
		},
		{
			"ignore_instant_ragdoll_chance",
			true,
		},
		{
			"targets",
			1,
			"power_distribution",
			"attack",
			{
				190,
				380,
			},
		},
		{
			"targets",
			1,
			"armor_damage_modifier",
			"attack",
			"armored",
			damage_lerp_values.lerp_0_9,
		},
		{
			"targets",
			1,
			"armor_damage_modifier",
			"attack",
			"super_armor",
			damage_lerp_values.lerp_0_7,
		},
		{
			"targets",
			1,
			"power_distribution",
			"impact",
			25,
		},
	},
}
overrides.heavy_crowbar_sticky = {
	parent_template_name = "heavy_crowbar_tank",
	overrides = {
		{
			"damage_type",
			damage_types.sawing_stuck,
		},
		{
			"stagger_override",
			"medium",
		},
		{
			"ignore_instant_ragdoll_chance",
			true,
		},
		{
			"ignore_stagger_reduction",
			true,
		},
		{
			"targets",
			1,
			"power_distribution",
			"attack",
			{
				120,
				240,
			},
		},
		{
			"targets",
			1,
			"armor_damage_modifier",
			"attack",
			"armored",
			damage_lerp_values.lerp_1,
		},
		{
			"targets",
			1,
			"armor_damage_modifier",
			"attack",
			"super_armor",
			damage_lerp_values.lerp_0_8,
		},
		{
			"targets",
			1,
			"power_distribution",
			"impact",
			30,
		},
	},
}

return {
	base_templates = damage_templates,
	overrides = overrides,
}
