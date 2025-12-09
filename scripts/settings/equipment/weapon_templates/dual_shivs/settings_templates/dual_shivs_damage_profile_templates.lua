-- chunkname: @scripts/settings/equipment/weapon_templates/dual_shivs/settings_templates/dual_shivs_damage_profile_templates.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local DamageProfileSettings = require("scripts/settings/damage/damage_profile_settings")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local GibbingSettings = require("scripts/settings/gibbing/gibbing_settings")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local WoundsTemplates = require("scripts/settings/damage/wounds_templates")
local armor_types = ArmorSettings.types
local damage_lerp_values = DamageProfileSettings.damage_lerp_values
local damage_types = DamageSettings.damage_types
local gibbing_power = GibbingSettings.gibbing_power
local gibbing_types = GibbingSettings.gibbing_types
local melee_attack_strengths = AttackSettings.melee_attack_strength
local double_cleave = DamageProfileSettings.double_cleave
local medium_cleave = DamageProfileSettings.medium_cleave
local no_cleave = DamageProfileSettings.no_cleave
local damage_templates = {}
local overrides = {}

table.make_unique(damage_templates)
table.make_unique(overrides)

local crit_mods = {
	ninja_fencer_crit_mod = {
		attack = {
			[armor_types.unarmored] = 0,
			[armor_types.armored] = 0.5,
			[armor_types.resistant] = 0.75,
			[armor_types.player] = 0,
			[armor_types.berserker] = 0.5,
			[armor_types.super_armor] = 0.2,
			[armor_types.disgustingly_resilient] = 0.25,
			[armor_types.void_shield] = 0,
		},
		impact = {
			[armor_types.unarmored] = 0.75,
			[armor_types.armored] = 0.75,
			[armor_types.resistant] = 0.75,
			[armor_types.player] = 0.75,
			[armor_types.berserker] = 0.75,
			[armor_types.super_armor] = 0.75,
			[armor_types.disgustingly_resilient] = 0.75,
			[armor_types.void_shield] = 0.75,
		},
	},
	medium_ninja_fencer_crit_mod = {
		attack = {
			[armor_types.unarmored] = 0,
			[armor_types.armored] = 0.25,
			[armor_types.resistant] = 0.75,
			[armor_types.player] = 0,
			[armor_types.berserker] = 0.5,
			[armor_types.super_armor] = 0.2,
			[armor_types.disgustingly_resilient] = 0.25,
			[armor_types.void_shield] = 0,
		},
		impact = {
			[armor_types.unarmored] = 0.75,
			[armor_types.armored] = 0.75,
			[armor_types.resistant] = 0.75,
			[armor_types.player] = 0.75,
			[armor_types.berserker] = 0.75,
			[armor_types.super_armor] = 0.75,
			[armor_types.disgustingly_resilient] = 0.75,
			[armor_types.void_shield] = 0.75,
		},
	},
}
local ninja_light_default_am = {
	attack = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1,
		[armor_types.armored] = damage_lerp_values.lerp_0_5,
		[armor_types.resistant] = damage_lerp_values.lerp_0_6,
		[armor_types.player] = damage_lerp_values.lerp_1,
		[armor_types.berserker] = damage_lerp_values.lerp_0_5,
		[armor_types.super_armor] = damage_lerp_values.lerp_0_05,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_9,
		[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
	},
	impact = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1,
		[armor_types.armored] = damage_lerp_values.lerp_0_5,
		[armor_types.resistant] = damage_lerp_values.lerp_1,
		[armor_types.player] = damage_lerp_values.lerp_1,
		[armor_types.berserker] = damage_lerp_values.lerp_0_5,
		[armor_types.super_armor] = damage_lerp_values.no_damage,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_5,
		[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
	},
}
local smiter_light_default_am = {
	attack = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1,
		[armor_types.armored] = damage_lerp_values.lerp_1,
		[armor_types.resistant] = damage_lerp_values.lerp_0_8,
		[armor_types.player] = damage_lerp_values.lerp_1,
		[armor_types.berserker] = damage_lerp_values.lerp_0_9,
		[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_9,
		[armor_types.void_shield] = damage_lerp_values.lerp_1_25,
	},
	impact = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1,
		[armor_types.armored] = damage_lerp_values.lerp_1,
		[armor_types.resistant] = damage_lerp_values.lerp_1,
		[armor_types.player] = damage_lerp_values.lerp_1,
		[armor_types.berserker] = damage_lerp_values.lerp_0_5,
		[armor_types.super_armor] = damage_lerp_values.lerp_1,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_75,
		[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
	},
}
local linesman_light_default_am = {
	attack = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1,
		[armor_types.armored] = damage_lerp_values.lerp_0_9,
		[armor_types.resistant] = damage_lerp_values.lerp_0_8,
		[armor_types.player] = damage_lerp_values.lerp_1,
		[armor_types.berserker] = damage_lerp_values.lerp_0_75,
		[armor_types.super_armor] = damage_lerp_values.lerp_0_4,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_9,
		[armor_types.void_shield] = damage_lerp_values.lerp_1_25,
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
}
local tank_heavy_default_am = {
	attack = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1,
		[armor_types.armored] = damage_lerp_values.lerp_0_9,
		[armor_types.resistant] = damage_lerp_values.lerp_0_8,
		[armor_types.player] = damage_lerp_values.lerp_1,
		[armor_types.berserker] = damage_lerp_values.lerp_0_8,
		[armor_types.super_armor] = damage_lerp_values.lerp_0_75,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
		[armor_types.void_shield] = damage_lerp_values.lerp_1_33,
	},
	impact = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1_25,
		[armor_types.armored] = damage_lerp_values.lerp_1_1,
		[armor_types.resistant] = damage_lerp_values.lerp_1,
		[armor_types.player] = damage_lerp_values.lerp_1,
		[armor_types.berserker] = damage_lerp_values.lerp_0_5,
		[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
		[armor_types.void_shield] = damage_lerp_values.lerp_1,
	},
}

damage_templates.dual_shivs_light_ninja = {
	backstab_bonus = 0.1,
	finesse_ability_damage_multiplier = 3,
	ragdoll_push_force = 10,
	shield_override_stagger_strength = 4,
	stagger_category = "melee",
	cleave_distribution = {
		attack = {
			3,
			5,
		},
		impact = {
			3,
			5,
		},
	},
	damage_type = damage_types.metal_slashing_light,
	gibbing_type = gibbing_types.sawing,
	gibbing_power = gibbing_power.always,
	melee_attack_strength = melee_attack_strengths.light,
	wounds_template = WoundsTemplates.combat_knife,
	critical_strike = {
		gibbing_power = gibbing_power.light,
		gibbing_type = gibbing_types.sawing,
	},
	crit_mod = crit_mods.ninja_fencer_crit_mod,
	armor_damage_modifier = ninja_light_default_am,
	targets = {
		{
			crit_boost = 0.7,
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_5,
					[armor_types.resistant] = damage_lerp_values.lerp_0_6,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_7,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_05,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_5,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_5,
					[armor_types.super_armor] = damage_lerp_values.no_damage,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_5,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
				},
			},
			power_distribution = {
				attack = {
					65,
					100,
				},
				impact = {
					2,
					4,
				},
			},
			finesse_boost = PowerLevelSettings.ninjafencer_finesse_boost_amount,
			boost_curve = PowerLevelSettings.boost_curves.default,
			boost_curve_multiplier_finesse = {
				1.2,
				2.4,
			},
			power_level_multiplier = {
				0.75,
				1.25,
			},
		},
		{
			power_distribution = {
				attack = {
					20,
					40,
				},
				impact = {
					1,
					3,
				},
			},
			boost_curve_multiplier_finesse = {
				1,
				2,
			},
		},
		default_target = {
			power_distribution = {
				attack = {
					10,
					20,
				},
				impact = {
					1,
					3,
				},
			},
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
	gib_push_force = GibbingSettings.gib_push_force.sawing_light,
}
overrides.dual_shivs_light_ninja_stabby = {
	parent_template_name = "dual_shivs_light_ninja",
	overrides = {
		{
			"targets",
			1,
			"power_distribution",
			"attack",
			{
				65,
				110,
			},
		},
		{
			"targets",
			1,
			"crit_boost",
			0.8,
		},
		{
			"cleave_distribution",
			"attack",
			{
				2,
				4,
			},
		},
		{
			"cleave_distribution",
			"impact",
			{
				2,
				4,
			},
		},
		{
			"gibbing_power",
			gibbing_power.light,
		},
	},
}
overrides.dual_shivs_light_ninja_stabby_plus = {
	parent_template_name = "dual_shivs_light_ninja",
	overrides = {
		{
			"targets",
			1,
			"power_distribution",
			"attack",
			{
				70,
				120,
			},
		},
		{
			"targets",
			1,
			"crit_boost",
			0.8,
		},
		{
			"targets",
			1,
			"boost_curve_multiplier_finesse",
			{
				1.3,
				2.6,
			},
		},
		{
			"cleave_distribution",
			"attack",
			{
				1,
				2,
			},
		},
		{
			"cleave_distribution",
			"impact",
			{
				1,
				2,
			},
		},
		{
			"backstab_bonus",
			0.2,
		},
	},
}
damage_templates.dual_shivs_light_linesman = {
	finesse_ability_damage_multiplier = 3,
	ragdoll_push_force = 10,
	shield_override_stagger_strength = 4,
	stagger_category = "melee",
	cleave_distribution = {
		attack = {
			4,
			6,
		},
		impact = {
			4,
			6,
		},
	},
	damage_type = damage_types.metal_slashing_light,
	gibbing_type = gibbing_types.sawing,
	gibbing_power = gibbing_power.always,
	melee_attack_strength = melee_attack_strengths.light,
	wounds_template = WoundsTemplates.combat_knife,
	critical_strike = {
		gibbing_power = gibbing_power.light,
		gibbing_type = gibbing_types.sawing,
	},
	crit_mod = crit_mods.ninja_fencer_crit_mod,
	armor_damage_modifier = ninja_light_default_am,
	targets = {
		{
			crit_boost = 0.5,
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_5,
					[armor_types.resistant] = damage_lerp_values.lerp_0_6,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_7,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_05,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_5,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_5,
					[armor_types.super_armor] = damage_lerp_values.no_damage,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_5,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
				},
			},
			power_distribution = {
				attack = {
					50,
					90,
				},
				impact = {
					2,
					4,
				},
			},
			finesse_boost = PowerLevelSettings.ninjafencer_finesse_boost_amount,
			boost_curve = PowerLevelSettings.boost_curves.default,
			boost_curve_multiplier_finesse = {
				1.1,
				2.2,
			},
			power_level_multiplier = {
				0.75,
				1.25,
			},
		},
		{
			power_distribution = {
				attack = {
					30,
					60,
				},
				impact = {
					1,
					3,
				},
			},
			boost_curve_multiplier_finesse = {
				0.9,
				1.8,
			},
		},
		{
			power_distribution = {
				attack = {
					20,
					40,
				},
				impact = {
					1,
					3,
				},
			},
			boost_curve_multiplier_finesse = {
				0.7,
				1.4,
			},
		},
		default_target = {
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_25,
					[armor_types.resistant] = damage_lerp_values.lerp_0_4,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_5,
					[armor_types.super_armor] = damage_lerp_values.no_damage,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_75,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
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
				attack = {
					10,
					20,
				},
				impact = {
					1,
					3,
				},
			},
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
	gib_push_force = GibbingSettings.gib_push_force.sawing_light,
}
damage_templates.dual_shivs_heavy_double_stab = {
	backstab_bonus = 0.25,
	finesse_ability_damage_multiplier = 3,
	ragdoll_push_force = 10,
	shield_override_stagger_strength = 4,
	stagger_category = "melee",
	crit_mod = crit_mods.medium_ninja_fencer_crit_mod,
	cleave_distribution = {
		attack = {
			0.001,
			0.001,
		},
		impact = {
			0.001,
			0.001,
		},
	},
	damage_type = damage_types.metal_slashing_light,
	gibbing_type = gibbing_types.sawing,
	gibbing_power = gibbing_power.always,
	melee_attack_strength = melee_attack_strengths.heavy,
	wounds_template = WoundsTemplates.combat_knife,
	critical_strike = {
		gibbing_power = gibbing_power.light,
		gibbing_type = gibbing_types.sawing,
	},
	armor_damage_modifier = ninja_light_default_am,
	targets = {
		{
			crit_boost = 0.7,
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_75,
					[armor_types.resistant] = damage_lerp_values.lerp_0_8,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_9,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_5,
					[armor_types.resistant] = damage_lerp_values.lerp_0_5,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_5,
					[armor_types.super_armor] = damage_lerp_values.no_damage,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_9,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
				},
			},
			power_distribution = {
				attack = {
					105,
					210,
				},
				impact = {
					4,
					8,
				},
			},
			finesse_boost = PowerLevelSettings.ninjafencer_finesse_boost_amount,
			boost_curve = PowerLevelSettings.boost_curves.default,
			boost_curve_multiplier_finesse = {
				1.35,
				2.7,
			},
			power_level_multiplier = {
				0.8,
				1.4,
			},
		},
		{
			crit_boost = 0.7,
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_75,
					[armor_types.resistant] = damage_lerp_values.lerp_0_8,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_1,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_5,
					[armor_types.resistant] = damage_lerp_values.lerp_0_5,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_5,
					[armor_types.super_armor] = damage_lerp_values.no_damage,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_9,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
				},
			},
			power_distribution = {
				attack = {
					105,
					210,
				},
				impact = {
					4,
					8,
				},
			},
			finesse_boost = PowerLevelSettings.ninjafencer_finesse_boost_amount,
			boost_curve = PowerLevelSettings.boost_curves.default,
			boost_curve_multiplier_finesse = {
				1.35,
				2.7,
			},
			power_level_multiplier = {
				0.7,
				1.1,
			},
		},
		default_target = {
			crit_boost = 0.5,
			power_distribution = {
				attack = {
					30,
					60,
				},
				impact = {
					2,
					4,
				},
			},
			finesse_boost = PowerLevelSettings.ninjafencer_finesse_boost_amount,
			boost_curve = PowerLevelSettings.boost_curves.default,
			boost_curve_multiplier_finesse = {
				0.9,
				1.8,
			},
			power_level_multiplier = {
				0.5,
				1.5,
			},
		},
	},
	gib_push_force = GibbingSettings.gib_push_force.sawing_light,
}
damage_templates.dual_shivs_heavy_stab = {
	backstab_bonus = 0.25,
	finesse_ability_damage_multiplier = 3,
	ragdoll_push_force = 10,
	shield_override_stagger_strength = 4,
	stagger_category = "melee",
	crit_mod = crit_mods.medium_ninja_fencer_crit_mod,
	cleave_distribution = {
		attack = {
			3,
			5,
		},
		impact = {
			3,
			5,
		},
	},
	damage_type = damage_types.metal_slashing_light,
	gibbing_type = gibbing_types.sawing,
	gibbing_power = gibbing_power.always,
	melee_attack_strength = melee_attack_strengths.heavy,
	wounds_template = WoundsTemplates.combat_knife,
	critical_strike = {
		gibbing_power = gibbing_power.light,
		gibbing_type = gibbing_types.sawing,
	},
	armor_damage_modifier = ninja_light_default_am,
	targets = {
		{
			crit_boost = 0.7,
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_75,
					[armor_types.resistant] = damage_lerp_values.lerp_0_8,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_9,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_5,
					[armor_types.resistant] = damage_lerp_values.lerp_0_5,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_5,
					[armor_types.super_armor] = damage_lerp_values.no_damage,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_9,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
				},
			},
			power_distribution = {
				attack = {
					110,
					220,
				},
				impact = {
					4,
					8,
				},
			},
			finesse_boost = PowerLevelSettings.ninjafencer_finesse_boost_amount,
			boost_curve = PowerLevelSettings.boost_curves.default,
			boost_curve_multiplier_finesse = {
				1.35,
				2.7,
			},
			power_level_multiplier = {
				0.8,
				1.4,
			},
		},
		{
			crit_boost = 0.55,
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_75,
					[armor_types.resistant] = damage_lerp_values.lerp_0_8,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_9,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_5,
					[armor_types.resistant] = damage_lerp_values.lerp_0_5,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_5,
					[armor_types.super_armor] = damage_lerp_values.no_damage,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_9,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
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
			finesse_boost = PowerLevelSettings.ninjafencer_finesse_boost_amount,
			boost_curve = PowerLevelSettings.boost_curves.default,
			boost_curve_multiplier_finesse = {
				1,
				2,
			},
		},
		default_target = {
			crit_boost = 0.5,
			power_distribution = {
				attack = {
					30,
					60,
				},
				impact = {
					2,
					4,
				},
			},
			finesse_boost = PowerLevelSettings.ninjafencer_finesse_boost_amount,
			boost_curve = PowerLevelSettings.boost_curves.default,
			boost_curve_multiplier_finesse = {
				0.9,
				1.8,
			},
			power_level_multiplier = {
				0.5,
				1.5,
			},
		},
	},
	gib_push_force = GibbingSettings.gib_push_force.sawing_light,
}
damage_templates.dual_shivs_heavy_linesman = {
	backstab_bonus = 0.15,
	finesse_ability_damage_multiplier = 1.5,
	ragdoll_push_force = 10,
	stagger_category = "melee",
	crit_mod = crit_mods.medium_ninja_fencer_crit_mod,
	cleave_distribution = medium_cleave,
	damage_type = damage_types.metal_slashing_light,
	gibbing_type = gibbing_types.sawing,
	gibbing_power = gibbing_power.light,
	melee_attack_strength = melee_attack_strengths.heavy,
	wounds_template = WoundsTemplates.combat_knife,
	critical_strike = {
		gibbing_power = gibbing_power.medium,
		gibbing_type = gibbing_types.sawing,
	},
	targets = {
		{
			crit_boost = 0.6,
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_7,
					[armor_types.resistant] = damage_lerp_values.lerp_0_75,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_9,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_3,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_9,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_0_8,
					[armor_types.armored] = damage_lerp_values.lerp_0_5,
					[armor_types.resistant] = damage_lerp_values.lerp_0_5,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_5,
					[armor_types.super_armor] = damage_lerp_values.no_damage,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_5,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
				},
			},
			power_distribution = {
				attack = {
					90,
					160,
				},
				impact = {
					4,
					8,
				},
			},
			finesse_boost = PowerLevelSettings.ninjafencer_finesse_boost_amount,
			boost_curve = PowerLevelSettings.boost_curves.default,
			boost_curve_multiplier_finesse = {
				1.2,
				2.4,
			},
			power_level_multiplier = {
				0.75,
				1.25,
			},
		},
		{
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_7,
					[armor_types.resistant] = damage_lerp_values.lerp_0_75,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_9,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_3,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_9,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_0_7,
					[armor_types.armored] = damage_lerp_values.lerp_0_5,
					[armor_types.resistant] = damage_lerp_values.lerp_0_5,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_5,
					[armor_types.super_armor] = damage_lerp_values.no_damage,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_5,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
				},
			},
			power_distribution = {
				attack = {
					65,
					130,
				},
				impact = {
					2,
					5,
				},
			},
		},
		{
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_7,
					[armor_types.resistant] = damage_lerp_values.lerp_0_75,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_9,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_3,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_9,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_0_7,
					[armor_types.armored] = damage_lerp_values.lerp_0_5,
					[armor_types.resistant] = damage_lerp_values.lerp_0_5,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_5,
					[armor_types.super_armor] = damage_lerp_values.no_damage,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_5,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
				},
			},
			power_distribution = {
				attack = {
					50,
					100,
				},
				impact = {
					2,
					5,
				},
			},
		},
		default_target = {
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_7,
					[armor_types.resistant] = damage_lerp_values.lerp_0_7,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_9,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_3,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_9,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_0_6,
					[armor_types.armored] = damage_lerp_values.lerp_0_5,
					[armor_types.resistant] = damage_lerp_values.lerp_0_5,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_5,
					[armor_types.super_armor] = damage_lerp_values.no_damage,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_5,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
				},
			},
			power_distribution = {
				attack = {
					30,
					60,
				},
				impact = {
					2,
					5,
				},
			},
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
	gib_push_force = GibbingSettings.gib_push_force.sawing_light,
}
damage_templates.dual_shivs_throwing_knives = {
	stagger_category = "killshot",
	vo_no_headshot = true,
	ranges = {
		max = 15,
		min = 5,
	},
	armor_damage_modifier_ranged = {
		near = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_0_5,
				[armor_types.resistant] = damage_lerp_values.lerp_0_6,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_1,
				[armor_types.super_armor] = damage_lerp_values.no_damage,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_0_5,
				[armor_types.resistant] = damage_lerp_values.lerp_0_5,
				[armor_types.player] = damage_lerp_values.lerp_0_75,
				[armor_types.berserker] = damage_lerp_values.lerp_0_8,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_9,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
			},
		},
		far = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_0_9,
				[armor_types.armored] = damage_lerp_values.lerp_0_25,
				[armor_types.resistant] = damage_lerp_values.lerp_0_4,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_0_8,
				[armor_types.super_armor] = damage_lerp_values.no_damage,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_8,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_0_5,
				[armor_types.armored] = damage_lerp_values.lerp_0_25,
				[armor_types.resistant] = damage_lerp_values.lerp_0_5,
				[armor_types.player] = damage_lerp_values.lerp_0_75,
				[armor_types.berserker] = damage_lerp_values.lerp_0_5,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_25,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_5,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
			},
		},
	},
	cleave_distribution = {
		attack = 0,
		impact = 0,
	},
	power_distribution = {
		attack = 190,
		impact = 5,
	},
	gibbing_power = gibbing_power.always,
	gibbing_type = gibbing_types.ballistic,
	critical_strike = {
		gibbing_power = gibbing_power.light,
		gibbing_type = gibbing_types.ballistic,
	},
	targets = {
		default_target = {
			boost_curve_multiplier_finesse = 1.2,
			boost_curve = PowerLevelSettings.boost_curves.default,
			finesse_boost = {
				[armor_types.unarmored] = 0.65,
				[armor_types.berserker] = 0.55,
				[armor_types.disgustingly_resilient] = 0.65,
			},
		},
	},
}

return {
	base_templates = damage_templates,
	overrides = overrides,
}
