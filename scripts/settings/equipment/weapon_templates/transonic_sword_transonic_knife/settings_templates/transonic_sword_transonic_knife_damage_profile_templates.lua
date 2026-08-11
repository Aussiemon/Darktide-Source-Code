-- chunkname: @scripts/settings/equipment/weapon_templates/transonic_sword_transonic_knife/settings_templates/transonic_sword_transonic_knife_damage_profile_templates.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local DamageProfileSettings = require("scripts/settings/damage/damage_profile_settings")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local GibbingSettings = require("scripts/settings/gibbing/gibbing_settings")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local armor_types = ArmorSettings.types
local crit_armor_mod = DamageProfileSettings.transonic_crit_mod
local damage_lerp_values = DamageProfileSettings.damage_lerp_values
local damage_types = DamageSettings.damage_types
local gibbing_power = GibbingSettings.gibbing_power
local gibbing_types = GibbingSettings.gibbing_types
local melee_attack_strengths = AttackSettings.melee_attack_strength
local light_cleave = DamageProfileSettings.light_cleave
local double_cleave = DamageProfileSettings.double_cleave
local medium_cleave = DamageProfileSettings.medium_cleave
local large_cleave = DamageProfileSettings.large_cleave
local big_cleave = DamageProfileSettings.big_cleave
local damage_templates = {}
local overrides = {}

table.make_unique(damage_templates)
table.make_unique(overrides)

damage_templates.transonic_sword_transonic_knife_light_linesman = {
	crit_boost = 0.25,
	finesse_ability_damage_multiplier = 3,
	ragdoll_push_force = 10,
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
	gibbing_power = gibbing_power.light,
	melee_attack_strength = melee_attack_strengths.light,
	critical_strike = {
		gibbing_power = gibbing_power.medium,
		gibbing_type = gibbing_types.sawing,
	},
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_0_7,
			[armor_types.resistant] = damage_lerp_values.lerp_0_8,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_0_8,
			[armor_types.super_armor] = damage_lerp_values.lerp_0_1,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_9,
			[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
		},
		impact = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_0_5,
			[armor_types.resistant] = damage_lerp_values.lerp_0_8,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_0_8,
			[armor_types.super_armor] = damage_lerp_values.no_damage,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
			[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
		},
	},
	crit_mod = crit_armor_mod,
	targets = {
		{
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_75,
					[armor_types.resistant] = damage_lerp_values.lerp_0_9,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_9,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_2,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_5,
					[armor_types.resistant] = damage_lerp_values.lerp_0_85,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_85,
					[armor_types.super_armor] = damage_lerp_values.no_damage,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
				},
			},
			power_distribution = {
				attack = {
					70,
					140,
				},
				impact = {
					3,
					7,
				},
			},
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
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_7,
					[armor_types.resistant] = damage_lerp_values.lerp_0_8,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_8,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_1,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_9,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_5,
					[armor_types.resistant] = damage_lerp_values.lerp_0_8,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_8,
					[armor_types.super_armor] = damage_lerp_values.no_damage,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
				},
			},
			power_distribution = {
				attack = {
					40,
					80,
				},
				impact = {
					2,
					5,
				},
			},
			boost_curve_multiplier_finesse = {
				0.9,
				1.8,
			},
		},
		{
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_7,
					[armor_types.resistant] = damage_lerp_values.lerp_0_8,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_8,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_1,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_9,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_5,
					[armor_types.resistant] = damage_lerp_values.lerp_0_8,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_8,
					[armor_types.super_armor] = damage_lerp_values.no_damage,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
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
					4,
				},
			},
			boost_curve_multiplier_finesse = {
				0.7,
				1.4,
			},
		},
		{
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_7,
					[armor_types.resistant] = damage_lerp_values.lerp_0_8,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_8,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_1,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_9,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_5,
					[armor_types.resistant] = damage_lerp_values.lerp_0_8,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_8,
					[armor_types.super_armor] = damage_lerp_values.no_damage,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
				},
			},
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
			boost_curve_multiplier_finesse = {
				0.7,
				1.4,
			},
		},
		default_target = {
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_7,
					[armor_types.resistant] = damage_lerp_values.lerp_0_8,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_8,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_1,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_9,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_5,
					[armor_types.resistant] = damage_lerp_values.lerp_0_8,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_8,
					[armor_types.super_armor] = damage_lerp_values.no_damage,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
				},
			},
			power_distribution = {
				attack = {
					15,
					30,
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
damage_templates.transonic_sword_transonic_knife_light_ninja = {
	backstab_bonus = 0.1,
	crit_boost = 0.35,
	finesse_ability_damage_multiplier = 3,
	ragdoll_push_force = 10,
	stagger_category = "melee",
	cleave_distribution = light_cleave,
	damage_type = damage_types.metal_slashing_light,
	gibbing_type = gibbing_types.sawing,
	gibbing_power = gibbing_power.light,
	melee_attack_strength = melee_attack_strengths.light,
	critical_strike = {
		gibbing_power = gibbing_power.medium,
		gibbing_type = gibbing_types.sawing,
	},
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_0_7,
			[armor_types.resistant] = damage_lerp_values.lerp_0_8,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_0_8,
			[armor_types.super_armor] = damage_lerp_values.lerp_0_1,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_9,
			[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
		},
		impact = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_0_5,
			[armor_types.resistant] = damage_lerp_values.lerp_0_8,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_0_8,
			[armor_types.super_armor] = damage_lerp_values.no_damage,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
			[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
		},
	},
	crit_mod = crit_armor_mod,
	targets = {
		{
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_75,
					[armor_types.resistant] = damage_lerp_values.lerp_0_9,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_9,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_3,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_5,
					[armor_types.resistant] = damage_lerp_values.lerp_0_8,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_8,
					[armor_types.super_armor] = damage_lerp_values.no_damage,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
				},
			},
			power_distribution = {
				attack = {
					75,
					150,
				},
				impact = {
					2,
					5,
				},
			},
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
					[armor_types.resistant] = damage_lerp_values.lerp_0_8,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_8,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_1,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_9,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_5,
					[armor_types.resistant] = damage_lerp_values.lerp_0_8,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_8,
					[armor_types.super_armor] = damage_lerp_values.no_damage,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
				},
			},
			power_distribution = {
				attack = {
					35,
					70,
				},
				impact = {
					2,
					4,
				},
			},
			boost_curve_multiplier_finesse = {
				1,
				2,
			},
		},
		{
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_7,
					[armor_types.resistant] = damage_lerp_values.lerp_0_8,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_8,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_1,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_9,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_5,
					[armor_types.resistant] = damage_lerp_values.lerp_0_8,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_8,
					[armor_types.super_armor] = damage_lerp_values.no_damage,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
				},
			},
			power_distribution = {
				attack = {
					20,
					45,
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
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_7,
					[armor_types.resistant] = damage_lerp_values.lerp_0_8,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_8,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_1,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_9,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_5,
					[armor_types.resistant] = damage_lerp_values.lerp_0_8,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_8,
					[armor_types.super_armor] = damage_lerp_values.no_damage,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
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
damage_templates.transonic_sword_transonic_knife_light_smiter = {
	crit_boost = 0.25,
	finesse_ability_damage_multiplier = 3,
	ragdoll_push_force = 10,
	stagger_category = "melee",
	cleave_distribution = double_cleave,
	damage_type = damage_types.metal_slashing_light,
	gibbing_type = gibbing_types.sawing,
	gibbing_power = gibbing_power.light,
	melee_attack_strength = melee_attack_strengths.light,
	critical_strike = {
		gibbing_power = gibbing_power.medium,
		gibbing_type = gibbing_types.sawing,
	},
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_0_7,
			[armor_types.resistant] = damage_lerp_values.lerp_0_9,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_0_8,
			[armor_types.super_armor] = damage_lerp_values.lerp_0_1,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_9,
			[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
		},
		impact = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_0_5,
			[armor_types.resistant] = damage_lerp_values.lerp_0_8,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_0_8,
			[armor_types.super_armor] = damage_lerp_values.no_damage,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
			[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
		},
	},
	crit_mod = crit_armor_mod,
	targets = {
		{
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_75,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_9,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_3,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_5,
					[armor_types.resistant] = damage_lerp_values.lerp_0_8,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_8,
					[armor_types.super_armor] = damage_lerp_values.no_damage,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
				},
			},
			power_distribution = {
				attack = {
					90,
					170,
				},
				impact = {
					4,
					8,
				},
			},
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
					[armor_types.resistant] = damage_lerp_values.lerp_0_9,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_8,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_1,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_9,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_5,
					[armor_types.resistant] = damage_lerp_values.lerp_0_8,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_8,
					[armor_types.super_armor] = damage_lerp_values.no_damage,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
				},
			},
			power_distribution = {
				attack = {
					35,
					70,
				},
				impact = {
					2,
					5,
				},
			},
			boost_curve_multiplier_finesse = {
				1,
				2,
			},
		},
		{
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_7,
					[armor_types.resistant] = damage_lerp_values.lerp_0_9,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_8,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_1,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_9,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_5,
					[armor_types.resistant] = damage_lerp_values.lerp_0_8,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_8,
					[armor_types.super_armor] = damage_lerp_values.no_damage,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
				},
			},
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
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_7,
					[armor_types.resistant] = damage_lerp_values.lerp_0_9,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_8,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_1,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_9,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_5,
					[armor_types.resistant] = damage_lerp_values.lerp_0_8,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_8,
					[armor_types.super_armor] = damage_lerp_values.no_damage,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
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
damage_templates.transonic_sword_transonic_knife_light_linesman_ap = {
	crit_boost = 0.25,
	finesse_ability_damage_multiplier = 3,
	ragdoll_push_force = 10,
	stagger_category = "melee",
	cleave_distribution = light_cleave,
	damage_type = damage_types.metal_slashing_light,
	gibbing_type = gibbing_types.sawing,
	gibbing_power = gibbing_power.light,
	melee_attack_strength = melee_attack_strengths.light,
	critical_strike = {
		gibbing_power = gibbing_power.medium,
		gibbing_type = gibbing_types.sawing,
	},
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = damage_lerp_values.lerp_0_8,
			[armor_types.armored] = damage_lerp_values.lerp_0_8,
			[armor_types.resistant] = damage_lerp_values.lerp_0_7,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_0_7,
			[armor_types.super_armor] = damage_lerp_values.lerp_0_2,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_8,
			[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
		},
		impact = {
			[armor_types.unarmored] = damage_lerp_values.lerp_0_9,
			[armor_types.armored] = damage_lerp_values.lerp_0_7,
			[armor_types.resistant] = damage_lerp_values.lerp_0_8,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_0_8,
			[armor_types.super_armor] = damage_lerp_values.no_damage,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_9,
			[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
		},
	},
	crit_mod = crit_armor_mod,
	targets = {
		{
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_0_9,
					[armor_types.armored] = damage_lerp_values.lerp_1_0,
					[armor_types.resistant] = damage_lerp_values.lerp_0_7,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_8,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_3,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_9,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_8,
					[armor_types.resistant] = damage_lerp_values.lerp_0_85,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_85,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_2,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
				},
			},
			power_distribution = {
				attack = {
					70,
					140,
				},
				impact = {
					3,
					7,
				},
			},
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
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_0_8,
					[armor_types.armored] = damage_lerp_values.lerp_0_8,
					[armor_types.resistant] = damage_lerp_values.lerp_0_7,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_7,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_2,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_8,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_0_9,
					[armor_types.armored] = damage_lerp_values.lerp_0_7,
					[armor_types.resistant] = damage_lerp_values.lerp_0_8,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_8,
					[armor_types.super_armor] = damage_lerp_values.no_damage,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_9,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
				},
			},
			power_distribution = {
				attack = {
					45,
					90,
				},
				impact = {
					2,
					5,
				},
			},
			boost_curve_multiplier_finesse = {
				0.9,
				1.8,
			},
		},
		{
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_0_8,
					[armor_types.armored] = damage_lerp_values.lerp_0_8,
					[armor_types.resistant] = damage_lerp_values.lerp_0_7,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_7,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_2,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_8,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_0_9,
					[armor_types.armored] = damage_lerp_values.lerp_0_7,
					[armor_types.resistant] = damage_lerp_values.lerp_0_8,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_8,
					[armor_types.super_armor] = damage_lerp_values.no_damage,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_9,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
				},
			},
			power_distribution = {
				attack = {
					25,
					50,
				},
				impact = {
					2,
					4,
				},
			},
			boost_curve_multiplier_finesse = {
				0.7,
				1.4,
			},
		},
		{
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_0_8,
					[armor_types.armored] = damage_lerp_values.lerp_0_8,
					[armor_types.resistant] = damage_lerp_values.lerp_0_7,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_7,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_2,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_8,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_0_9,
					[armor_types.armored] = damage_lerp_values.lerp_0_7,
					[armor_types.resistant] = damage_lerp_values.lerp_0_8,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_8,
					[armor_types.super_armor] = damage_lerp_values.no_damage,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_9,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
				},
			},
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
			boost_curve_multiplier_finesse = {
				0.7,
				1.4,
			},
		},
		default_target = {
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_0_8,
					[armor_types.armored] = damage_lerp_values.lerp_0_8,
					[armor_types.resistant] = damage_lerp_values.lerp_0_7,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_7,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_2,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_8,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_0_9,
					[armor_types.armored] = damage_lerp_values.lerp_0_7,
					[armor_types.resistant] = damage_lerp_values.lerp_0_8,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_8,
					[armor_types.super_armor] = damage_lerp_values.no_damage,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_9,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
				},
			},
			power_distribution = {
				attack = {
					15,
					30,
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
damage_templates.transonic_sword_transonic_knife_light_ninja_ap = {
	backstab_bonus = 0.1,
	crit_boost = 0.35,
	finesse_ability_damage_multiplier = 3,
	ragdoll_push_force = 10,
	stagger_category = "melee",
	cleave_distribution = double_cleave,
	damage_type = damage_types.metal_slashing_light,
	gibbing_type = gibbing_types.sawing,
	gibbing_power = gibbing_power.light,
	melee_attack_strength = melee_attack_strengths.light,
	critical_strike = {
		gibbing_power = gibbing_power.medium,
		gibbing_type = gibbing_types.sawing,
	},
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = damage_lerp_values.lerp_0_8,
			[armor_types.armored] = damage_lerp_values.lerp_0_8,
			[armor_types.resistant] = damage_lerp_values.lerp_0_7,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_0_7,
			[armor_types.super_armor] = damage_lerp_values.lerp_0_2,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_8,
			[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
		},
		impact = {
			[armor_types.unarmored] = damage_lerp_values.lerp_0_9,
			[armor_types.armored] = damage_lerp_values.lerp_0_7,
			[armor_types.resistant] = damage_lerp_values.lerp_0_8,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_0_8,
			[armor_types.super_armor] = damage_lerp_values.no_damage,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_9,
			[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
		},
	},
	crit_mod = crit_armor_mod,
	targets = {
		{
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_0_9,
					[armor_types.armored] = damage_lerp_values.lerp_1_0,
					[armor_types.resistant] = damage_lerp_values.lerp_0_8,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_8,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_4,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_9,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_8,
					[armor_types.resistant] = damage_lerp_values.lerp_0_85,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_85,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_2,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
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
					[armor_types.unarmored] = damage_lerp_values.lerp_0_8,
					[armor_types.armored] = damage_lerp_values.lerp_0_8,
					[armor_types.resistant] = damage_lerp_values.lerp_0_7,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_7,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_2,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_8,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_0_9,
					[armor_types.armored] = damage_lerp_values.lerp_0_7,
					[armor_types.resistant] = damage_lerp_values.lerp_0_8,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_8,
					[armor_types.super_armor] = damage_lerp_values.no_damage,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_9,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
				},
			},
			power_distribution = {
				attack = {
					35,
					70,
				},
				impact = {
					2,
					4,
				},
			},
			boost_curve_multiplier_finesse = {
				1,
				2,
			},
		},
		{
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_0_8,
					[armor_types.armored] = damage_lerp_values.lerp_0_8,
					[armor_types.resistant] = damage_lerp_values.lerp_0_7,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_7,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_2,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_8,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_0_9,
					[armor_types.armored] = damage_lerp_values.lerp_0_7,
					[armor_types.resistant] = damage_lerp_values.lerp_0_8,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_8,
					[armor_types.super_armor] = damage_lerp_values.no_damage,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_9,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
				},
			},
			power_distribution = {
				attack = {
					20,
					45,
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
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_0_8,
					[armor_types.armored] = damage_lerp_values.lerp_0_8,
					[armor_types.resistant] = damage_lerp_values.lerp_0_7,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_7,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_2,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_8,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_0_9,
					[armor_types.armored] = damage_lerp_values.lerp_0_7,
					[armor_types.resistant] = damage_lerp_values.lerp_0_8,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_8,
					[armor_types.super_armor] = damage_lerp_values.no_damage,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_9,
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
damage_templates.transonic_sword_transonic_knife_light_smiter_ap = {
	crit_boost = 0.25,
	finesse_ability_damage_multiplier = 3,
	ragdoll_push_force = 10,
	stagger_category = "melee",
	cleave_distribution = double_cleave,
	damage_type = damage_types.metal_slashing_light,
	gibbing_type = gibbing_types.sawing,
	gibbing_power = gibbing_power.light,
	melee_attack_strength = melee_attack_strengths.light,
	critical_strike = {
		gibbing_power = gibbing_power.medium,
		gibbing_type = gibbing_types.sawing,
	},
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = damage_lerp_values.lerp_0_8,
			[armor_types.armored] = damage_lerp_values.lerp_0_9,
			[armor_types.resistant] = damage_lerp_values.lerp_0_7,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_0_7,
			[armor_types.super_armor] = damage_lerp_values.lerp_0_2,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_8,
			[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
		},
		impact = {
			[armor_types.unarmored] = damage_lerp_values.lerp_0_9,
			[armor_types.armored] = damage_lerp_values.lerp_0_7,
			[armor_types.resistant] = damage_lerp_values.lerp_0_8,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_0_8,
			[armor_types.super_armor] = damage_lerp_values.no_damage,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_9,
			[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
		},
	},
	crit_mod = crit_armor_mod,
	targets = {
		{
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_0_9,
					[armor_types.armored] = damage_lerp_values.lerp_1_0,
					[armor_types.resistant] = damage_lerp_values.lerp_0_8,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_8,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_4,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_9,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_8,
					[armor_types.resistant] = damage_lerp_values.lerp_0_85,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_85,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_3,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
				},
			},
			power_distribution = {
				attack = {
					90,
					170,
				},
				impact = {
					4,
					8,
				},
			},
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
					[armor_types.unarmored] = damage_lerp_values.lerp_0_8,
					[armor_types.armored] = damage_lerp_values.lerp_0_9,
					[armor_types.resistant] = damage_lerp_values.lerp_0_7,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_7,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_2,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_8,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_0_9,
					[armor_types.armored] = damage_lerp_values.lerp_0_7,
					[armor_types.resistant] = damage_lerp_values.lerp_0_8,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_8,
					[armor_types.super_armor] = damage_lerp_values.no_damage,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_9,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
				},
			},
			power_distribution = {
				attack = {
					35,
					70,
				},
				impact = {
					2,
					5,
				},
			},
			boost_curve_multiplier_finesse = {
				1,
				2,
			},
		},
		{
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_0_8,
					[armor_types.armored] = damage_lerp_values.lerp_0_9,
					[armor_types.resistant] = damage_lerp_values.lerp_0_7,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_7,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_2,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_8,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_0_9,
					[armor_types.armored] = damage_lerp_values.lerp_0_7,
					[armor_types.resistant] = damage_lerp_values.lerp_0_8,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_8,
					[armor_types.super_armor] = damage_lerp_values.no_damage,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_9,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
				},
			},
			power_distribution = {
				attack = {
					20,
					45,
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
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_0_8,
					[armor_types.armored] = damage_lerp_values.lerp_0_9,
					[armor_types.resistant] = damage_lerp_values.lerp_0_7,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_7,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_2,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_8,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_0_9,
					[armor_types.armored] = damage_lerp_values.lerp_0_7,
					[armor_types.resistant] = damage_lerp_values.lerp_0_8,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_8,
					[armor_types.super_armor] = damage_lerp_values.no_damage,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_9,
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
damage_templates.transonic_sword_transonic_knife_heavy_double_linesman = {
	crit_boost = 0.25,
	finesse_ability_damage_multiplier = 1.5,
	ragdoll_push_force = 10,
	stagger_category = "melee",
	cleave_distribution = big_cleave,
	damage_type = damage_types.metal_slashing_light,
	gibbing_type = gibbing_types.sawing,
	gibbing_power = gibbing_power.medium,
	melee_attack_strength = melee_attack_strengths.heavy,
	critical_strike = {
		gibbing_power = gibbing_power.heavy,
		gibbing_type = gibbing_types.sawing,
	},
	crit_mod = crit_armor_mod,
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_0_7,
			[armor_types.resistant] = damage_lerp_values.lerp_0_8,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_0_8,
			[armor_types.super_armor] = damage_lerp_values.lerp_0_2,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
			[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
		},
		impact = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_0_5,
			[armor_types.resistant] = damage_lerp_values.lerp_0_8,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_0_8,
			[armor_types.super_armor] = damage_lerp_values.no_damage,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
			[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
		},
	},
	targets = {
		{
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_75,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_1,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_2,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_5,
					[armor_types.resistant] = damage_lerp_values.lerp_0_8,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_8,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_1,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
				},
			},
			power_distribution = {
				attack = {
					120,
					240,
				},
				impact = {
					5,
					9,
				},
			},
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
					[armor_types.unarmored] = damage_lerp_values.lerp_0_8,
					[armor_types.armored] = damage_lerp_values.lerp_0_75,
					[armor_types.resistant] = damage_lerp_values.lerp_0_8,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_8,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_2,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_8,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_5,
					[armor_types.resistant] = damage_lerp_values.lerp_0_8,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_8,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_1,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
				},
			},
			power_distribution = {
				attack = {
					120,
					240,
				},
				impact = {
					5,
					9,
				},
			},
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
					60,
					120,
				},
				impact = {
					3,
					6,
				},
			},
		},
		{
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_7,
					[armor_types.resistant] = damage_lerp_values.lerp_0_8,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_8,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_2,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_5,
					[armor_types.resistant] = damage_lerp_values.lerp_0_8,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_8,
					[armor_types.super_armor] = damage_lerp_values.no_damage,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
				},
			},
			power_distribution = {
				attack = {
					60,
					120,
				},
				impact = {
					3,
					6,
				},
			},
		},
		{
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_7,
					[armor_types.resistant] = damage_lerp_values.lerp_0_8,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_8,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_2,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_5,
					[armor_types.resistant] = damage_lerp_values.lerp_0_8,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_8,
					[armor_types.super_armor] = damage_lerp_values.no_damage,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
				},
			},
			power_distribution = {
				attack = {
					40,
					80,
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
					[armor_types.resistant] = damage_lerp_values.lerp_0_8,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_8,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_2,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_5,
					[armor_types.resistant] = damage_lerp_values.lerp_0_8,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_8,
					[armor_types.super_armor] = damage_lerp_values.no_damage,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
				},
			},
			power_distribution = {
				attack = {
					40,
					80,
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
					[armor_types.resistant] = damage_lerp_values.lerp_0_8,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_8,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_2,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_5,
					[armor_types.resistant] = damage_lerp_values.lerp_0_8,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_8,
					[armor_types.super_armor] = damage_lerp_values.no_damage,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
				},
			},
			power_distribution = {
				attack = {
					20,
					40,
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
damage_templates.transonic_sword_transonic_knife_heavy_linesman = {
	crit_boost = 0.25,
	finesse_ability_damage_multiplier = 1.5,
	ragdoll_push_force = 10,
	stagger_category = "melee",
	cleave_distribution = big_cleave,
	damage_type = damage_types.metal_slashing_light,
	gibbing_type = gibbing_types.sawing,
	gibbing_power = gibbing_power.medium,
	melee_attack_strength = melee_attack_strengths.heavy,
	critical_strike = {
		gibbing_power = gibbing_power.heavy,
		gibbing_type = gibbing_types.sawing,
	},
	crit_mod = crit_armor_mod,
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_0_6,
			[armor_types.resistant] = damage_lerp_values.lerp_0_8,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_0_8,
			[armor_types.super_armor] = damage_lerp_values.lerp_0_1,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
			[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
		},
		impact = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_0_5,
			[armor_types.resistant] = damage_lerp_values.lerp_0_8,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_0_8,
			[armor_types.super_armor] = damage_lerp_values.no_damage,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
			[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
		},
	},
	targets = {
		{
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_75,
					[armor_types.resistant] = damage_lerp_values.lerp_0_9,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_1,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_2,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_5,
					[armor_types.resistant] = damage_lerp_values.lerp_0_8,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_8,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_1,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
				},
			},
			power_distribution = {
				attack = {
					125,
					250,
				},
				impact = {
					5,
					9,
				},
			},
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
					[armor_types.armored] = damage_lerp_values.lerp_0_6,
					[armor_types.resistant] = damage_lerp_values.lerp_0_8,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_8,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_1,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_5,
					[armor_types.resistant] = damage_lerp_values.lerp_0_8,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_8,
					[armor_types.super_armor] = damage_lerp_values.no_damage,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
				},
			},
			power_distribution = {
				attack = {
					100,
					200,
				},
				impact = {
					4,
					7,
				},
			},
			boost_curve_multiplier_finesse = {
				1,
				2,
			},
		},
		{
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_6,
					[armor_types.resistant] = damage_lerp_values.lerp_0_8,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_8,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_1,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_5,
					[armor_types.resistant] = damage_lerp_values.lerp_0_8,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_8,
					[armor_types.super_armor] = damage_lerp_values.no_damage,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
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
				0.5,
				1.5,
			},
		},
		{
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_6,
					[armor_types.resistant] = damage_lerp_values.lerp_0_8,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_8,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_1,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_5,
					[armor_types.resistant] = damage_lerp_values.lerp_0_8,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_8,
					[armor_types.super_armor] = damage_lerp_values.no_damage,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
				},
			},
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
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_6,
					[armor_types.resistant] = damage_lerp_values.lerp_0_8,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_8,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_1,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_5,
					[armor_types.resistant] = damage_lerp_values.lerp_0_8,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_8,
					[armor_types.super_armor] = damage_lerp_values.no_damage,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
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
		},
		default_target = {
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_6,
					[armor_types.resistant] = damage_lerp_values.lerp_0_8,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_8,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_1,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_5,
					[armor_types.resistant] = damage_lerp_values.lerp_0_8,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_8,
					[armor_types.super_armor] = damage_lerp_values.no_damage,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
				},
			},
			power_distribution = {
				attack = {
					20,
					40,
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
damage_templates.transonic_sword_transonic_knife_heavy_double_smiter_ap = {
	crit_boost = 0.25,
	finesse_ability_damage_multiplier = 3,
	ragdoll_push_force = 10,
	stagger_category = "melee",
	cleave_distribution = medium_cleave,
	damage_type = damage_types.metal_slashing_light,
	gibbing_type = gibbing_types.sawing,
	gibbing_power = gibbing_power.medium,
	melee_attack_strength = melee_attack_strengths.heavy,
	critical_strike = {
		gibbing_power = gibbing_power.heavy,
		gibbing_type = gibbing_types.sawing,
	},
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = damage_lerp_values.lerp_0_8,
			[armor_types.armored] = damage_lerp_values.lerp_0_9,
			[armor_types.resistant] = damage_lerp_values.lerp_0_7,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_0_7,
			[armor_types.super_armor] = damage_lerp_values.lerp_0_3,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_8,
			[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
		},
		impact = {
			[armor_types.unarmored] = damage_lerp_values.lerp_0_9,
			[armor_types.armored] = damage_lerp_values.lerp_0_7,
			[armor_types.resistant] = damage_lerp_values.lerp_0_8,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_0_8,
			[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_9,
			[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
		},
	},
	crit_mod = crit_armor_mod,
	targets = {
		{
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_0_9,
					[armor_types.armored] = damage_lerp_values.lerp_1,
					[armor_types.resistant] = damage_lerp_values.lerp_0_8,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_8,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_6,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_9,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_8,
					[armor_types.resistant] = damage_lerp_values.lerp_0_75,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_5,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_75,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_9,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
				},
			},
			power_distribution = {
				attack = {
					160,
					320,
				},
				impact = {
					4,
					9,
				},
			},
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
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_0_7,
					[armor_types.armored] = damage_lerp_values.lerp_1,
					[armor_types.resistant] = damage_lerp_values.lerp_0_6,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_6,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_7,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_7,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_8,
					[armor_types.resistant] = damage_lerp_values.lerp_0_75,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_5,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_75,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_9,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
				},
			},
			power_distribution = {
				attack = {
					160,
					320,
				},
				impact = {
					4,
					9,
				},
			},
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
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_0_8,
					[armor_types.armored] = damage_lerp_values.lerp_0_9,
					[armor_types.resistant] = damage_lerp_values.lerp_0_7,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_7,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_3,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_8,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_0_9,
					[armor_types.armored] = damage_lerp_values.lerp_0_7,
					[armor_types.resistant] = damage_lerp_values.lerp_0_8,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_8,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_9,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
				},
			},
			power_distribution = {
				attack = {
					50,
					100,
				},
				impact = {
					3,
					6,
				},
			},
			boost_curve_multiplier_finesse = {
				0.8,
				1.6,
			},
		},
		{
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_0_8,
					[armor_types.armored] = damage_lerp_values.lerp_0_9,
					[armor_types.resistant] = damage_lerp_values.lerp_0_7,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_7,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_3,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_8,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_0_9,
					[armor_types.armored] = damage_lerp_values.lerp_0_7,
					[armor_types.resistant] = damage_lerp_values.lerp_0_8,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_8,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_9,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
				},
			},
			power_distribution = {
				attack = {
					50,
					100,
				},
				impact = {
					3,
					6,
				},
			},
			boost_curve_multiplier_finesse = {
				0.8,
				1.6,
			},
		},
		default_target = {
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_0_8,
					[armor_types.armored] = damage_lerp_values.lerp_0_9,
					[armor_types.resistant] = damage_lerp_values.lerp_0_7,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_7,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_3,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_8,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_0_9,
					[armor_types.armored] = damage_lerp_values.lerp_0_7,
					[armor_types.resistant] = damage_lerp_values.lerp_0_8,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_8,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_9,
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
					4,
				},
			},
			boost_curve_multiplier_finesse = {
				0.5,
				1,
			},
		},
	},
	gib_push_force = GibbingSettings.gib_push_force.sawing_light,
}
damage_templates.transonic_sword_transonic_knife_heavy_smiter_ap = {
	crit_boost = 0.25,
	finesse_ability_damage_multiplier = 3,
	ragdoll_push_force = 10,
	stagger_category = "melee",
	cleave_distribution = light_cleave,
	damage_type = damage_types.metal_slashing_light,
	gibbing_type = gibbing_types.sawing,
	gibbing_power = gibbing_power.medium,
	melee_attack_strength = melee_attack_strengths.heavy,
	critical_strike = {
		gibbing_power = gibbing_power.heavy,
		gibbing_type = gibbing_types.sawing,
	},
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = damage_lerp_values.lerp_0_8,
			[armor_types.armored] = damage_lerp_values.lerp_0_9,
			[armor_types.resistant] = damage_lerp_values.lerp_0_7,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_0_7,
			[armor_types.super_armor] = damage_lerp_values.lerp_0_3,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_8,
			[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
		},
		impact = {
			[armor_types.unarmored] = damage_lerp_values.lerp_0_9,
			[armor_types.armored] = damage_lerp_values.lerp_0_7,
			[armor_types.resistant] = damage_lerp_values.lerp_0_8,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_0_8,
			[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_9,
			[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
		},
	},
	crit_mod = crit_armor_mod,
	targets = {
		{
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_0_9,
					[armor_types.armored] = damage_lerp_values.lerp_1,
					[armor_types.resistant] = damage_lerp_values.lerp_0_8,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_8,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_6,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_9,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_8,
					[armor_types.resistant] = damage_lerp_values.lerp_0_75,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_5,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_75,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_9,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
				},
			},
			power_distribution = {
				attack = {
					175,
					350,
				},
				impact = {
					5,
					7,
				},
			},
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
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_0_8,
					[armor_types.armored] = damage_lerp_values.lerp_0_9,
					[armor_types.resistant] = damage_lerp_values.lerp_0_7,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_7,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_3,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_8,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_0_9,
					[armor_types.armored] = damage_lerp_values.lerp_0_7,
					[armor_types.resistant] = damage_lerp_values.lerp_0_8,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_8,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_9,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
				},
			},
			power_distribution = {
				attack = {
					80,
					160,
				},
				impact = {
					4,
					6,
				},
			},
			boost_curve_multiplier_finesse = {
				1,
				2,
			},
		},
		{
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_0_8,
					[armor_types.armored] = damage_lerp_values.lerp_0_9,
					[armor_types.resistant] = damage_lerp_values.lerp_0_7,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_7,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_3,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_8,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_0_9,
					[armor_types.armored] = damage_lerp_values.lerp_0_7,
					[armor_types.resistant] = damage_lerp_values.lerp_0_8,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_8,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_9,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
				},
			},
			power_distribution = {
				attack = {
					30,
					65,
				},
				impact = {
					3,
					6,
				},
			},
			boost_curve_multiplier_finesse = {
				0.8,
				1.6,
			},
		},
		default_target = {
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_0_8,
					[armor_types.armored] = damage_lerp_values.lerp_0_9,
					[armor_types.resistant] = damage_lerp_values.lerp_0_7,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_7,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_3,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_8,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_0_9,
					[armor_types.armored] = damage_lerp_values.lerp_0_7,
					[armor_types.resistant] = damage_lerp_values.lerp_0_8,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_8,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_9,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
				},
			},
			power_distribution = {
				attack = {
					25,
					50,
				},
				impact = {
					2,
					4,
				},
			},
			boost_curve_multiplier_finesse = {
				0.5,
				1,
			},
		},
	},
	gib_push_force = GibbingSettings.gib_push_force.sawing_light,
}
overrides.transonic_sword_transonic_knife_special_linesman = {
	parent_template_name = "transonic_sword_transonic_knife_heavy_linesman",
	overrides = {
		{
			"stagger_category",
			"uppercut",
		},
		{
			"ignore_stagger_reduction",
			true,
		},
		{
			"weakspot_stagger_resistance_modifier",
			0.2,
		},
		{
			"weapon_special",
			true,
		},
	},
}
overrides.transonic_sword_transonic_knife_special_smiter_ap = {
	parent_template_name = "transonic_sword_transonic_knife_heavy_smiter_ap",
	overrides = {
		{
			"stagger_category",
			"uppercut",
		},
		{
			"ignore_stagger_reduction",
			true,
		},
		{
			"weakspot_stagger_resistance_modifier",
			0.2,
		},
		{
			"weapon_special",
			true,
		},
	},
}

return {
	base_templates = damage_templates,
	overrides = overrides,
}
