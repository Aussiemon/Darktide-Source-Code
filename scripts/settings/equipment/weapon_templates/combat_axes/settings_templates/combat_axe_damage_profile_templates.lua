-- chunkname: @scripts/settings/equipment/weapon_templates/combat_axes/settings_templates/combat_axe_damage_profile_templates.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local DamageProfileSettings = require("scripts/settings/damage/damage_profile_settings")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local GibbingSettings = require("scripts/settings/gibbing/gibbing_settings")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local WoundsTemplates = require("scripts/settings/damage/wounds_templates")
local GibbingPower = GibbingSettings.gibbing_power
local GibbingTypes = GibbingSettings.gibbing_types
local damage_types = DamageSettings.damage_types
local armor_types = ArmorSettings.types
local damage_templates = {}
local overrides = {}

table.make_unique(damage_templates)
table.make_unique(overrides)

local melee_attack_strengths = AttackSettings.melee_attack_strength
local crit_armor_mod = DamageProfileSettings.axe_crit_mod
local crit_impact_armor_mod = DamageProfileSettings.crit_impact_armor_mod
local damage_lerp_values = DamageProfileSettings.damage_lerp_values
local single_cleave = DamageProfileSettings.single_cleave
local no_cleave = DamageProfileSettings.no_cleave
local double_cleave = DamageProfileSettings.double_cleave
local light_cleave = DamageProfileSettings.light_cleave
local medium_cleave = DamageProfileSettings.medium_cleave
local large_cleave = DamageProfileSettings.large_cleave
local big_cleave = DamageProfileSettings.big_cleave
local fold_cleave = DamageProfileSettings.fold_cleave
local cutting_am = {
	attack = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1,
		[armor_types.armored] = damage_lerp_values.lerp_1,
		[armor_types.resistant] = damage_lerp_values.lerp_0_5,
		[armor_types.player] = damage_lerp_values.lerp_0_25,
		[armor_types.berserker] = damage_lerp_values.lerp_1,
		[armor_types.super_armor] = damage_lerp_values.lerp_0_075,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
		[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
	},
	impact = {
		[armor_types.unarmored] = damage_lerp_values.lerp_0_5,
		[armor_types.armored] = damage_lerp_values.lerp_1,
		[armor_types.resistant] = damage_lerp_values.lerp_1,
		[armor_types.player] = damage_lerp_values.lerp_1,
		[armor_types.berserker] = damage_lerp_values.lerp_1,
		[armor_types.super_armor] = damage_lerp_values.lerp_1,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_5,
		[armor_types.void_shield] = damage_lerp_values.lerp_1,
	},
}
local shovel_am = {
	attack = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1,
		[armor_types.armored] = damage_lerp_values.lerp_0_75,
		[armor_types.resistant] = damage_lerp_values.lerp_0_5,
		[armor_types.player] = damage_lerp_values.lerp_0_25,
		[armor_types.berserker] = damage_lerp_values.lerp_1,
		[armor_types.super_armor] = damage_lerp_values.no_damage,
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

damage_templates.heavy_axe = {
	finesse_ability_damage_multiplier = 2,
	ragdoll_only = true,
	ragdoll_push_force = 500,
	stagger_category = "uppercut",
	cleave_distribution = single_cleave,
	damage_type = damage_types.axe_light,
	gibbing_power = GibbingPower.medium,
	gibbing_type = GibbingTypes.sawing,
	melee_attack_strength = melee_attack_strengths.heavy,
	gib_push_force = GibbingSettings.gib_push_force.sawing_medium,
	wounds_template = WoundsTemplates.combat_axe,
	armor_damage_modifier = cutting_am,
	crit_mod = crit_armor_mod,
	targets = {
		{
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_1,
					[armor_types.resistant] = damage_lerp_values.lerp_2,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_1,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_75,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_1,
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_1,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_75,
					[armor_types.super_armor] = damage_lerp_values.lerp_1_5,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_1,
				},
			},
			power_distribution = {
				attack = {
					150,
					300,
				},
				impact = {
					10,
					20,
				},
			},
			boost_curve_multiplier_finesse = {
				0.7,
				1.4,
			},
			power_level_multiplier = {
				0.5,
				1.5,
			},
		},
		{
			boost_curve_multiplier_finesse = 0.5,
			power_distribution = {
				attack = {
					50,
					75,
				},
				impact = {
					5,
					10,
				},
			},
		},
		default_target = {
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = {
					10,
					15,
				},
				impact = {
					4,
					8,
				},
			},
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
}
damage_templates.heavy_axe_spike = {
	finesse_ability_damage_multiplier = 1.75,
	ragdoll_only = true,
	ragdoll_push_force = 200,
	stagger_category = "melee",
	cleave_distribution = no_cleave,
	damage_type = damage_types.axe_light,
	gibbing_power = GibbingPower.medium,
	gibbing_type = GibbingTypes.sawing,
	melee_attack_strength = melee_attack_strengths.heavy,
	gib_push_force = GibbingSettings.gib_push_force.sawing_medium,
	wounds_template = WoundsTemplates.combat_axe,
	armor_damage_modifier = cutting_am,
	crit_mod = crit_armor_mod,
	targets = {
		{
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_1,
					[armor_types.resistant] = damage_lerp_values.lerp_1_75,
					[armor_types.player] = damage_lerp_values.lerp_1,
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
					[armor_types.berserker] = damage_lerp_values.lerp_0_75,
					[armor_types.super_armor] = damage_lerp_values.lerp_1,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_1,
				},
			},
			power_distribution = {
				attack = {
					150,
					300,
				},
				impact = {
					8,
					16,
				},
			},
			boost_curve_multiplier_finesse = {
				0.7,
				1.4,
			},
			power_level_multiplier = {
				0.5,
				1.5,
			},
		},
		{
			power_distribution = {
				attack = {
					125,
					200,
				},
				impact = {
					5,
					10,
				},
			},
			boost_curve_multiplier_finesse = {
				0.6,
				1.2,
			},
		},
		default_target = {
			power_distribution = {
				attack = {
					10,
					15,
				},
				impact = {
					4,
					8,
				},
			},
			boost_curve = PowerLevelSettings.boost_curves.default,
			boost_curve_multiplier_finesse = {
				0.6,
				1.2,
			},
		},
	},
}
overrides.heavy_axe_sticky = {
	parent_template_name = "heavy_axe",
	overrides = {
		{
			"stagger_category",
			"sticky",
		},
		{
			"damage_type",
			damage_types.axe_light,
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
			1,
		},
	},
}
damage_templates.heavy_axe_linesman = {
	finesse_ability_damage_multiplier = 1.75,
	ragdoll_only = true,
	ragdoll_push_force = 500,
	stagger_category = "melee",
	cleave_distribution = double_cleave,
	damage_type = damage_types.axe_light,
	gibbing_power = GibbingPower.medium,
	gibbing_type = GibbingTypes.sawing,
	melee_attack_strength = melee_attack_strengths.heavy,
	gib_push_force = GibbingSettings.gib_push_force.sawing_medium,
	wounds_template = WoundsTemplates.combat_axe,
	armor_damage_modifier = cutting_am,
	crit_mod = crit_armor_mod,
	targets = {
		{
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_1,
					[armor_types.resistant] = damage_lerp_values.lerp_1_5,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_5,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_75,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_1,
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_1,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_5,
					[armor_types.super_armor] = damage_lerp_values.lerp_1_5,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_1,
				},
			},
			power_distribution = {
				attack = {
					100,
					250,
				},
				impact = {
					7,
					15,
				},
			},
			boost_curve_multiplier_finesse = {
				0.2,
				0.8,
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
					50,
					75,
				},
				impact = {
					5,
					10,
				},
			},
		},
		default_target = {
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = {
					10,
					15,
				},
				impact = {
					4,
					8,
				},
			},
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
}
damage_templates.default_light_axe = {
	finesse_ability_damage_multiplier = 2,
	ragdoll_only = true,
	ragdoll_push_force = 250,
	stagger_category = "melee",
	cleave_distribution = single_cleave,
	damage_type = damage_types.axe_light,
	gibbing_power = GibbingPower.light,
	gibbing_type = GibbingTypes.sawing,
	melee_attack_strength = melee_attack_strengths.light,
	gib_push_force = GibbingSettings.gib_push_force.sawing_medium,
	wounds_template = WoundsTemplates.combat_axe,
	armor_damage_modifier = cutting_am,
	crit_mod = crit_armor_mod,
	targets = {
		{
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_1,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_1,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_2,
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
					140,
					280,
				},
				impact = {
					8,
					16,
				},
			},
			boost_curve_multiplier_finesse = {
				0.4,
				1,
			},
			power_level_multiplier = {
				0.5,
				1.5,
			},
		},
		{
			power_distribution = {
				attack = {
					100,
					200,
				},
				impact = {
					7,
					14,
				},
			},
			boost_curve_multiplier_finesse = {
				0.4,
				1,
			},
		},
		default_target = {
			boost_curve_multiplier_finesse = 0.5,
			power_distribution = {
				attack = {
					80,
					160,
				},
				impact = {
					6,
					12,
				},
			},
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
}
overrides.light_axe_smiter = {
	parent_template_name = "default_light_axe",
	overrides = {
		{
			"cleave_distribution",
			no_cleave,
		},
	},
}
overrides.light_axe_sticky = {
	parent_template_name = "default_light_axe",
	overrides = {
		{
			"stagger_category",
			"sticky",
		},
		{
			"damage_type",
			damage_types.axe_light,
		},
		{
			"ignore_instant_ragdoll_chance",
			true,
		},
		{
			"gibbing_power",
			GibbingPower.heavy,
		},
		{
			"gibbing_type",
			GibbingTypes.sawing,
		},
		{
			"melee_attack_strength",
			melee_attack_strengths.light,
		},
		{
			"targets",
			1,
			"power_distribution",
			"attack",
			2,
		},
	},
}
damage_templates.medium_axe_tank = {
	finesse_ability_damage_multiplier = 2,
	ignore_gib_push = true,
	ignore_stagger_reduction = true,
	ragdoll_only = true,
	ragdoll_push_force = 500,
	stagger_category = "melee",
	cleave_distribution = large_cleave,
	gibbing_power = GibbingPower.light,
	gibbing_type = GibbingTypes.sawing,
	melee_attack_strength = melee_attack_strengths.light,
	gib_push_force = GibbingSettings.gib_push_force.sawing_medium,
	wounds_template = WoundsTemplates.combat_axe,
	armor_damage_modifier = cutting_am,
	crit_mod = crit_armor_mod,
	targets = {
		{
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_5,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_1,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_05,
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
					55,
					105,
				},
				impact = {
					6,
					12,
				},
			},
			boost_curve_multiplier_finesse = {
				0.2,
				0.8,
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
					35,
					65,
				},
				impact = {
					5,
					10,
				},
			},
		},
		{
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = {
					15,
					30,
				},
				impact = {
					4,
					6,
				},
			},
		},
		default_target = {
			power_distribution = {
				attack = {
					10,
					20,
				},
				impact = {
					3,
					5,
				},
			},
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
}
damage_templates.medium_axe_linesman = {
	finesse_ability_damage_multiplier = 2,
	ignore_gib_push = true,
	ignore_stagger_reduction = true,
	ragdoll_only = true,
	ragdoll_push_force = 500,
	stagger_category = "melee",
	cleave_distribution = large_cleave,
	gibbing_power = GibbingPower.light,
	gibbing_type = GibbingTypes.sawing,
	melee_attack_strength = melee_attack_strengths.light,
	gib_push_force = GibbingSettings.gib_push_force.sawing_medium,
	wounds_template = WoundsTemplates.combat_axe,
	armor_damage_modifier = cutting_am,
	crit_mod = crit_armor_mod,
	targets = {
		{
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_1,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_1,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_05,
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
					80,
					160,
				},
				impact = {
					6,
					12,
				},
			},
			boost_curve_multiplier_finesse = {
				0.2,
				0.8,
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
					60,
					120,
				},
				impact = {
					5,
					10,
				},
			},
		},
		{
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = {
					40,
					80,
				},
				impact = {
					4,
					6,
				},
			},
		},
		default_target = {
			power_distribution = {
				attack = {
					10,
					20,
				},
				impact = {
					3,
					5,
				},
			},
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
}
damage_templates.light_axe_linesman = {
	finesse_ability_damage_multiplier = 2,
	ragdoll_push_force = 250,
	stagger_category = "melee",
	damage_type = damage_types.axe_light,
	gibbing_power = GibbingPower.always,
	gibbing_type = GibbingTypes.sawing,
	melee_attack_strength = melee_attack_strengths.light,
	gib_push_force = GibbingSettings.gib_push_force.sawing_medium,
	wounds_template = WoundsTemplates.combat_axe,
	targets = {
		{
			boost_curve_multiplier_finesse = 0.5,
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_75,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_5,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_75,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_75,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_5,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_5,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_75,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
				},
			},
			power_distribution = {
				attack = 0.3,
				impact = 0.5,
			},
			power_level_multiplier = {
				0.5,
				1.5,
			},
		},
		{
			power_distribution = {
				attack = 0.1,
				impact = 0.25,
			},
		},
		default_target = {
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_25,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_5,
					[armor_types.super_armor] = damage_lerp_values.no_damage,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_5,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.no_damage,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_5,
					[armor_types.super_armor] = damage_lerp_values.no_damage,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_5,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
				},
			},
			power_distribution = {
				attack = 0.07,
				impact = 0.2,
			},
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
}
damage_templates.axe_uppercut = {
	finesse_ability_damage_multiplier = 2,
	ignore_stagger_reduction = true,
	ragdoll_only = true,
	ragdoll_push_force = 250,
	stagger_category = "melee",
	weapon_special = true,
	cleave_distribution = single_cleave,
	damage_type = damage_types.axe_light,
	gibbing_power = GibbingPower.light,
	gibbing_type = GibbingTypes.sawing,
	melee_attack_strength = melee_attack_strengths.light,
	gib_push_force = GibbingSettings.gib_push_force.sawing_medium,
	wounds_template = WoundsTemplates.combat_axe,
	armor_damage_modifier = cutting_am,
	crit_mod = crit_armor_mod,
	targets = {
		{
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_1,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
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
					[armor_types.super_armor] = damage_lerp_values.lerp_1_5,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_1,
				},
			},
			power_distribution = {
				attack = {
					60,
					100,
				},
				impact = {
					6,
					12,
				},
			},
			boost_curve_multiplier_finesse = {
				0.2,
				0.8,
			},
			power_level_multiplier = {
				0.5,
				1.5,
			},
		},
		default_target = {
			boost_curve_multiplier_finesse = 0.25,
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_5,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_5,
					[armor_types.super_armor] = damage_lerp_values.no_damage,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_75,
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
			},
			power_distribution = {
				attack = {
					20,
					40,
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
damage_templates.axe_stab = {
	finesse_ability_damage_multiplier = 2,
	ignore_stagger_reduction = true,
	ragdoll_only = true,
	ragdoll_push_force = 250,
	stagger_category = "uppercut",
	weakspot_stagger_resistance_modifier = 0.0001,
	weapon_special = true,
	cleave_distribution = single_cleave,
	damage_type = damage_types.axe_light,
	gibbing_power = GibbingPower.always,
	gibbing_type = GibbingTypes.sawing,
	melee_attack_strength = melee_attack_strengths.light,
	gib_push_force = GibbingSettings.gib_push_force.sawing_medium,
	wounds_template = WoundsTemplates.combat_axe,
	armor_damage_modifier = cutting_am,
	crit_mod = crit_armor_mod,
	targets = {
		{
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_1,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
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
					[armor_types.super_armor] = damage_lerp_values.lerp_1_5,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_1,
				},
			},
			power_distribution = {
				attack = {
					30,
					60,
				},
				impact = {
					10,
					20,
				},
			},
			boost_curve_multiplier_finesse = {
				1,
				2,
			},
			power_level_multiplier = {
				0.5,
				1.5,
			},
		},
		default_target = {
			boost_curve_multiplier_finesse = 0.25,
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_5,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_5,
					[armor_types.super_armor] = damage_lerp_values.no_damage,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_75,
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
			},
			power_distribution = {
				attack = {
					20,
					40,
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
damage_templates.default_light_hatchet = {
	finesse_ability_damage_multiplier = 2,
	gibbing_power = 0,
	ragdoll_only = true,
	ragdoll_push_force = 150,
	stagger_category = "melee",
	cleave_distribution = double_cleave,
	damage_type = damage_types.axe_light,
	gibbing_type = GibbingTypes.sawing,
	melee_attack_strength = melee_attack_strengths.light,
	wounds_template = WoundsTemplates.combat_axe,
	armor_damage_modifier = cutting_am,
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
					4,
					8,
				},
			},
			boost_curve_multiplier_finesse = {
				1,
				2,
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
					40,
					80,
				},
				impact = {
					3,
					6,
				},
			},
		},
		default_target = {
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = {
					20,
					40,
				},
				impact = {
					3,
					5,
				},
			},
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
}
damage_templates.default_light_hatchet_smiter = {
	finesse_ability_damage_multiplier = 2,
	gibbing_power = 0,
	ragdoll_only = true,
	ragdoll_push_force = 150,
	stagger_category = "melee",
	cleave_distribution = single_cleave,
	damage_type = damage_types.axe_light,
	gibbing_type = GibbingTypes.sawing,
	melee_attack_strength = melee_attack_strengths.light,
	wounds_template = WoundsTemplates.combat_axe,
	armor_damage_modifier = cutting_am,
	crit_mod = crit_armor_mod,
	targets = {
		{
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_1,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
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
					[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_1,
				},
			},
			power_distribution = {
				attack = {
					70,
					140,
				},
				impact = {
					3,
					6,
				},
			},
			boost_curve_multiplier_finesse = {
				1,
				2,
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
					35,
					50,
				},
				impact = {
					3,
					6,
				},
			},
		},
		default_target = {
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = {
					20,
					40,
				},
				impact = {
					3,
					5,
				},
			},
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
}
damage_templates.medium_hatchet = {
	finesse_ability_damage_multiplier = 2,
	ignore_gib_push = true,
	ignore_stagger_reduction = true,
	ragdoll_only = true,
	ragdoll_push_force = 250,
	stagger_category = "melee",
	cleave_distribution = double_cleave,
	critical_strike = {
		gibbing_power = GibbingPower.light,
		gibbing_type = GibbingTypes.sawing,
	},
	gibbing_power = GibbingPower.always,
	gibbing_type = GibbingTypes.sawing,
	melee_attack_strength = melee_attack_strengths.heavy,
	wounds_template = WoundsTemplates.combat_axe,
	armor_damage_modifier = cutting_am,
	crit_mod = crit_armor_mod,
	targets = {
		{
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_1,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
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
					100,
					200,
				},
				impact = {
					6,
					12,
				},
			},
			boost_curve_multiplier_finesse = {
				1,
				2,
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
					60,
					120,
				},
				impact = {
					5,
					10,
				},
			},
		},
		{
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = {
					40,
					80,
				},
				impact = {
					4,
					6,
				},
			},
		},
		default_target = {
			power_distribution = {
				attack = {
					0,
					0,
				},
				impact = {
					3,
					5,
				},
			},
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
}
overrides.light_axe_p2_special = {
	parent_template_name = "axe_stab",
	overrides = {
		{
			"ignore_stagger_reduction",
			true,
		},
		{
			"stagger_category",
			"hatchet",
		},
		{
			"damage_type",
			damage_types.blunt,
		},
		{
			"ignore_instant_ragdoll_chance",
			true,
		},
		{
			"melee_attack_strength",
			melee_attack_strengths.light,
		},
		{
			"targets",
			1,
			"power_distribution",
			"attack",
			{
				25,
				50,
			},
		},
		{
			"targets",
			1,
			"power_distribution",
			"impact",
			{
				8,
				16,
			},
		},
	},
}
overrides.light_axe_p2_special_2 = {
	parent_template_name = "axe_stab",
	overrides = {
		{
			"ignore_stagger_reduction",
			true,
		},
		{
			"stagger_category",
			"hatchet",
		},
		{
			"damage_type",
			damage_types.blunt,
		},
		{
			"ignore_instant_ragdoll_chance",
			true,
		},
		{
			"gibbing_power",
			0,
		},
		{
			"gibbing_type",
			GibbingTypes.sawing,
		},
		{
			"melee_attack_strength",
			melee_attack_strengths.light,
		},
		{
			"targets",
			1,
			"power_distribution",
			"attack",
			{
				25,
				50,
			},
		},
		{
			"targets",
			1,
			"power_distribution",
			"impact",
			{
				8,
				16,
			},
		},
	},
}
damage_templates.heavy_shovel_tank = {
	finesse_ability_damage_multiplier = 2,
	ragdoll_only = true,
	ragdoll_push_force = 250,
	stagger_category = "melee",
	cleave_distribution = big_cleave,
	damage_type = damage_types.shovel_medium,
	gibbing_power = GibbingPower.always,
	gibbing_type = GibbingTypes.default,
	melee_attack_strength = melee_attack_strengths.heavy,
	gib_push_force = GibbingSettings.gib_push_force.sawing_medium,
	wounds_template = WoundsTemplates.shovel,
	armor_damage_modifier = cutting_am,
	crit_mod = crit_armor_mod,
	targets = {
		{
			boost_curve_multiplier_finesse = 0.5,
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_75,
					[armor_types.resistant] = damage_lerp_values.lerp_0_75,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_75,
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
					110,
					225,
				},
				impact = {
					10,
					20,
				},
			},
			power_level_multiplier = {
				0.5,
				1.5,
			},
		},
		{
			power_distribution = {
				attack = {
					75,
					150,
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
					40,
					80,
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
					35,
					70,
				},
				impact = {
					5,
					10,
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
					5,
					10,
				},
			},
		},
		default_target = {
			power_distribution = {
				attack = {
					20,
					40,
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
overrides.heavy_shovel_special = {
	parent_template_name = "heavy_shovel_tank",
	overrides = {
		{
			"stagger_category",
			"sticky",
		},
		{
			"cleave_distribution",
			fold_cleave,
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
				250,
				550,
			},
		},
		{
			"targets",
			1,
			"armor_damage_modifier",
			"attack",
			"super_armor",
			damage_lerp_values.lerp_1,
		},
		{
			"targets",
			1,
			"armor_damage_modifier",
			"attack",
			"berserker",
			damage_lerp_values.lerp_1_33,
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
overrides.heavy_shovel_sticky = {
	parent_template_name = "heavy_shovel_tank",
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
				100,
				350,
			},
		},
		{
			"targets",
			1,
			"armor_damage_modifier",
			"attack",
			"super_armor",
			damage_lerp_values.lerp_0_5,
		},
		{
			"targets",
			1,
			"power_distribution",
			"impact",
			15,
		},
	},
}
overrides.heavy_shovel_smite = {
	parent_template_name = "heavy_shovel_tank",
	overrides = {
		{
			"cleave_distribution",
			double_cleave,
		},
		{
			"targets",
			1,
			"power_distribution",
			"attack",
			{
				125,
				275,
			},
		},
		{
			"targets",
			1,
			"power_distribution",
			"impact",
			15,
		},
	},
}
damage_templates.default_light_shovel = {
	finesse_ability_damage_multiplier = 2,
	ragdoll_only = true,
	ragdoll_push_force = 250,
	stagger_category = "melee",
	cleave_distribution = double_cleave,
	gibbing_power = GibbingPower.light,
	gibbing_type = GibbingTypes.sawing,
	melee_attack_strength = melee_attack_strengths.light,
	gib_push_force = GibbingSettings.gib_push_force.sawing_medium,
	wounds_template = WoundsTemplates.shovel,
	armor_damage_modifier = cutting_am,
	crit_mod = crit_armor_mod,
	targets = {
		{
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_75,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_1_1,
					[armor_types.super_armor] = damage_lerp_values.no_damage,
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
					80,
					160,
				},
				impact = {
					3,
					6,
				},
			},
			boost_curve_multiplier_finesse = {
				0.4,
				1.3,
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
					50,
					100,
				},
				impact = {
					2.5,
					5,
				},
			},
		},
		default_target = {
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = {
					20,
					40,
				},
				impact = {
					2,
					4,
				},
			},
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
}
overrides.light_shovel_marks_single_target = {
	parent_template_name = "default_light_shovel",
	overrides = {
		{
			"targets",
			1,
			"power_distribution",
			"attack",
			{
				95,
				180,
			},
		},
	},
}
overrides.light_shovel_special = {
	parent_template_name = "default_light_shovel",
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
				150,
				470,
			},
		},
		{
			"targets",
			1,
			"power_distribution",
			"impact",
			10,
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
overrides.light_shovel_sticky = {
	parent_template_name = "default_light_shovel",
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
			"targets",
			1,
			"power_distribution",
			"attack",
			{
				25,
				75,
			},
		},
		{
			"targets",
			1,
			"power_distribution",
			"impact",
			20,
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
damage_templates.light_shovel_linesman = {
	finesse_ability_damage_multiplier = 2,
	ragdoll_push_force = 250,
	stagger_category = "melee",
	damage_type = damage_types.metal_slashing_light,
	gibbing_power = GibbingPower.light,
	gibbing_type = GibbingTypes.sawing,
	melee_attack_strength = melee_attack_strengths.light,
	gib_push_force = GibbingSettings.gib_push_force.sawing_medium,
	wounds_template = WoundsTemplates.shovel,
	targets = {
		{
			boost_curve_multiplier_finesse = 0.5,
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_75,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_5,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_75,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_75,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_5,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_5,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_75,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
				},
			},
			power_distribution = {
				attack = 0.3,
				impact = 0.5,
			},
			power_level_multiplier = {
				0.5,
				1.5,
			},
		},
		{
			power_distribution = {
				attack = 0.1,
				impact = 0.25,
			},
		},
		default_target = {
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_25,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_5,
					[armor_types.super_armor] = damage_lerp_values.no_damage,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_5,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.no_damage,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_5,
					[armor_types.super_armor] = damage_lerp_values.no_damage,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_5,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
				},
			},
			power_distribution = {
				attack = 0.07,
				impact = 0.2,
			},
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
}
damage_templates.default_light_shovel_smack = {
	finesse_ability_damage_multiplier = 2,
	ragdoll_push_force = 350,
	stagger_category = "melee",
	cleave_distribution = single_cleave,
	gibbing_power = GibbingPower.light,
	gibbing_type = GibbingTypes.sawing,
	melee_attack_strength = melee_attack_strengths.light,
	gib_push_force = GibbingSettings.gib_push_force.sawing_medium,
	wounds_template = WoundsTemplates.shovel,
	armor_damage_modifier = cutting_am,
	crit_mod = crit_armor_mod,
	targets = {
		{
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_1,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_5,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_25,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_1,
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_1,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_5,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_1,
				},
			},
			power_distribution = {
				attack = {
					110,
					250,
				},
				impact = {
					4,
					8,
				},
			},
			boost_curve_multiplier_finesse = {
				1,
				2,
			},
			power_level_multiplier = {
				0.5,
				1.5,
			},
		},
		{
			power_distribution = {
				attack = {
					50,
					100,
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
					30,
					60,
				},
				impact = {
					4,
					8,
				},
			},
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
}
damage_templates.default_light_shovel_tank = {
	finesse_ability_damage_multiplier = 2,
	ragdoll_only = true,
	ragdoll_push_force = 250,
	stagger_category = "melee",
	cleave_distribution = large_cleave,
	gibbing_power = GibbingPower.light,
	gibbing_type = GibbingTypes.sawing,
	melee_attack_strength = melee_attack_strengths.light,
	gib_push_force = GibbingSettings.gib_push_force.sawing_medium,
	wounds_template = WoundsTemplates.shovel,
	armor_damage_modifier = shovel_am,
	crit_mod = crit_armor_mod,
	targets = {
		{
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_75,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_1,
					[armor_types.super_armor] = damage_lerp_values.no_damage,
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
					55,
					120,
				},
				impact = {
					8,
					14,
				},
			},
			boost_curve_multiplier_finesse = {
				0.4,
				1,
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
					80,
				},
				impact = {
					6,
					10,
				},
			},
		},
		{
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = {
					30,
					50,
				},
				impact = {
					5,
					6,
				},
			},
		},
		{
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = {
					20,
					40,
				},
				impact = {
					5,
					5,
				},
			},
		},
		default_target = {
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = {
					0,
					0,
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

return {
	base_templates = damage_templates,
	overrides = overrides,
}
