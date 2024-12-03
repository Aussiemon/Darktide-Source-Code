-- chunkname: @scripts/settings/equipment/weapon_templates/thunder_hammers_2h/settings_templates/thunder_hammer_damage_profile_templates.lua

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
local crit_armor_mod = DamageProfileSettings.crit_armor_mod
local crit_impact_armor_mod = DamageProfileSettings.crit_impact_armor_mod
local damage_lerp_values = DamageProfileSettings.damage_lerp_values
local single_cleave = DamageProfileSettings.single_cleave
local double_cleave = DamageProfileSettings.double_cleave
local light_cleave = DamageProfileSettings.light_cleave
local medium_cleave = DamageProfileSettings.medium_cleave
local large_cleave = DamageProfileSettings.large_cleave
local hammer_smiter_light_am = {
	attack = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1,
		[armor_types.armored] = damage_lerp_values.lerp_0_5,
		[armor_types.resistant] = damage_lerp_values.lerp_1,
		[armor_types.player] = damage_lerp_values.no_damage,
		[armor_types.berserker] = damage_lerp_values.lerp_0_5,
		[armor_types.super_armor] = damage_lerp_values.lerp_0_01,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_75,
		[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
	},
	impact = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1,
		[armor_types.armored] = damage_lerp_values.lerp_0_75,
		[armor_types.resistant] = damage_lerp_values.lerp_1,
		[armor_types.player] = damage_lerp_values.no_damage,
		[armor_types.berserker] = damage_lerp_values.lerp_0_5,
		[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_75,
		[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
	},
}
local hammer_smiter_light_active_am = {
	attack = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1,
		[armor_types.armored] = damage_lerp_values.lerp_1,
		[armor_types.resistant] = damage_lerp_values.lerp_2,
		[armor_types.player] = damage_lerp_values.no_damage,
		[armor_types.berserker] = damage_lerp_values.lerp_1,
		[armor_types.super_armor] = damage_lerp_values.lerp_1,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
		[armor_types.void_shield] = damage_lerp_values.lerp_1,
	},
	impact = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1,
		[armor_types.armored] = damage_lerp_values.lerp_1,
		[armor_types.resistant] = damage_lerp_values.lerp_1,
		[armor_types.player] = damage_lerp_values.no_damage,
		[armor_types.berserker] = damage_lerp_values.lerp_1,
		[armor_types.super_armor] = damage_lerp_values.lerp_1,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
		[armor_types.void_shield] = damage_lerp_values.lerp_1,
	},
}
local hammer_smiter_light_default_am = {
	attack = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1,
		[armor_types.armored] = damage_lerp_values.lerp_0_5,
		[armor_types.resistant] = damage_lerp_values.lerp_1,
		[armor_types.player] = damage_lerp_values.no_damage,
		[armor_types.berserker] = damage_lerp_values.lerp_0_5,
		[armor_types.super_armor] = damage_lerp_values.no_damage,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_75,
		[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
	},
	impact = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1,
		[armor_types.armored] = damage_lerp_values.lerp_1,
		[armor_types.resistant] = damage_lerp_values.lerp_1,
		[armor_types.player] = damage_lerp_values.no_damage,
		[armor_types.berserker] = damage_lerp_values.lerp_1,
		[armor_types.super_armor] = damage_lerp_values.lerp_1,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
		[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
	},
}
local hammer_tank_heavy_first_am = {
	attack = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1,
		[armor_types.armored] = damage_lerp_values.lerp_0_9,
		[armor_types.resistant] = damage_lerp_values.lerp_1,
		[armor_types.player] = damage_lerp_values.no_damage,
		[armor_types.berserker] = damage_lerp_values.lerp_0_5,
		[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
		[armor_types.void_shield] = damage_lerp_values.lerp_1,
	},
	impact = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1,
		[armor_types.armored] = damage_lerp_values.lerp_1,
		[armor_types.resistant] = damage_lerp_values.lerp_1,
		[armor_types.player] = damage_lerp_values.no_damage,
		[armor_types.berserker] = damage_lerp_values.lerp_0_5,
		[armor_types.super_armor] = damage_lerp_values.lerp_1,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
		[armor_types.void_shield] = damage_lerp_values.lerp_1,
	},
}
local hammer_tank_heavy_first_active_am = {
	attack = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1_5,
		[armor_types.armored] = damage_lerp_values.lerp_1_5,
		[armor_types.resistant] = damage_lerp_values.lerp_3,
		[armor_types.player] = damage_lerp_values.no_damage,
		[armor_types.berserker] = damage_lerp_values.lerp_1_5,
		[armor_types.super_armor] = damage_lerp_values.lerp_1_5,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1_5,
		[armor_types.void_shield] = damage_lerp_values.lerp_1,
	},
	impact = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1,
		[armor_types.armored] = damage_lerp_values.lerp_1,
		[armor_types.resistant] = damage_lerp_values.lerp_1,
		[armor_types.player] = damage_lerp_values.no_damage,
		[armor_types.berserker] = damage_lerp_values.lerp_1,
		[armor_types.super_armor] = damage_lerp_values.lerp_1,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
		[armor_types.void_shield] = damage_lerp_values.lerp_1,
	},
}
local hammer_tank_heavy_am = {
	attack = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1,
		[armor_types.armored] = damage_lerp_values.lerp_0_5,
		[armor_types.resistant] = damage_lerp_values.lerp_1,
		[armor_types.player] = damage_lerp_values.no_damage,
		[armor_types.berserker] = damage_lerp_values.lerp_0_5,
		[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
		[armor_types.void_shield] = damage_lerp_values.lerp_1,
	},
	impact = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1,
		[armor_types.armored] = damage_lerp_values.lerp_1,
		[armor_types.resistant] = damage_lerp_values.lerp_1,
		[armor_types.player] = damage_lerp_values.no_damage,
		[armor_types.berserker] = damage_lerp_values.lerp_0_5,
		[armor_types.super_armor] = damage_lerp_values.lerp_1,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
		[armor_types.void_shield] = damage_lerp_values.lerp_1,
	},
}

damage_templates.thunderhammer_light = {
	finesse_ability_damage_multiplier = 1.5,
	ragdoll_only = true,
	ragdoll_push_force = 500,
	stagger_category = "melee",
	cleave_distribution = single_cleave,
	damage_type = damage_types.blunt_thunder,
	gibbing_power = GibbingPower.always,
	gibbing_type = GibbingTypes.crushing,
	melee_attack_strength = melee_attack_strengths.light,
	wounds_template = WoundsTemplates.thunder_hammer,
	armor_damage_modifier = hammer_smiter_light_default_am,
	stagger_duration_modifier = {
		0.1,
		0.5,
	},
	targets = {
		{
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_9,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
					[armor_types.player] = damage_lerp_values.no_damage,
					[armor_types.berserker] = damage_lerp_values.lerp_0_5,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_75,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_1,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
					[armor_types.player] = damage_lerp_values.no_damage,
					[armor_types.berserker] = damage_lerp_values.lerp_1,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_75,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
				},
			},
			power_distribution = {
				attack = {
					180,
					350,
				},
				impact = {
					8,
					22,
				},
			},
			finesse_boost = {
				[armor_types.unarmored] = 0.5,
				[armor_types.armored] = 0.5,
				[armor_types.resistant] = 0.5,
				[armor_types.player] = 0.3,
				[armor_types.berserker] = 0.5,
				[armor_types.super_armor] = 0.5,
				[armor_types.disgustingly_resilient] = 0.5,
				[armor_types.void_shield] = 0.3,
			},
			boost_curve_multiplier_finesse = {
				0.5,
				1.5,
			},
			power_level_multiplier = {
				0.75,
				1.25,
			},
		},
		{
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = {
					15,
					25,
				},
				impact = {
					9,
					11,
				},
			},
		},
		default_target = {
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = {
					8,
					12,
				},
				impact = {
					5,
					5,
				},
			},
			boost_curve = PowerLevelSettings.boost_curves.default,
			finesse_boost = {
				[armor_types.unarmored] = 0.1,
				[armor_types.armored] = 0.5,
				[armor_types.resistant] = 0.1,
				[armor_types.player] = 0.1,
				[armor_types.berserker] = 0.1,
				[armor_types.super_armor] = 0.1,
				[armor_types.disgustingly_resilient] = 0.5,
				[armor_types.void_shield] = 0.5,
			},
		},
	},
	gib_push_force = GibbingSettings.gib_push_force.blunt_light,
}
damage_templates.thunderhammer_light_plus = {
	finesse_ability_damage_multiplier = 1.5,
	ragdoll_only = true,
	ragdoll_push_force = 500,
	stagger_category = "melee",
	cleave_distribution = single_cleave,
	damage_type = damage_types.blunt_thunder,
	gibbing_power = GibbingPower.always,
	gibbing_type = GibbingTypes.crushing,
	melee_attack_strength = melee_attack_strengths.light,
	wounds_template = WoundsTemplates.thunder_hammer,
	armor_damage_modifier = hammer_smiter_light_default_am,
	stagger_duration_modifier = {
		0.1,
		0.5,
	},
	targets = {
		{
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_9,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
					[armor_types.player] = damage_lerp_values.no_damage,
					[armor_types.berserker] = damage_lerp_values.lerp_0_5,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_75,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_1,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
					[armor_types.player] = damage_lerp_values.no_damage,
					[armor_types.berserker] = damage_lerp_values.lerp_1,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_75,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
				},
			},
			power_distribution = {
				attack = {
					200,
					380,
				},
				impact = {
					8,
					22,
				},
			},
			finesse_boost = {
				[armor_types.unarmored] = 0.75,
				[armor_types.armored] = 0.6,
				[armor_types.resistant] = 0.5,
				[armor_types.player] = 0.3,
				[armor_types.berserker] = 0.5,
				[armor_types.super_armor] = 0.5,
				[armor_types.disgustingly_resilient] = 0.5,
				[armor_types.void_shield] = 0.3,
			},
			boost_curve_multiplier_finesse = {
				1,
				2,
			},
			power_level_multiplier = {
				0.75,
				1.25,
			},
		},
		{
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = {
					15,
					25,
				},
				impact = {
					9,
					11,
				},
			},
		},
		default_target = {
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = {
					8,
					12,
				},
				impact = {
					5,
					5,
				},
			},
			boost_curve = PowerLevelSettings.boost_curves.default,
			finesse_boost = {
				[armor_types.unarmored] = 0.1,
				[armor_types.armored] = 0.5,
				[armor_types.resistant] = 0.1,
				[armor_types.player] = 0.1,
				[armor_types.berserker] = 0.1,
				[armor_types.super_armor] = 0.1,
				[armor_types.disgustingly_resilient] = 0.5,
				[armor_types.void_shield] = 0.5,
			},
		},
	},
	gib_push_force = GibbingSettings.gib_push_force.blunt_light,
}
damage_templates.thunderhammer_light_linesman = {
	finesse_ability_damage_multiplier = 1.5,
	ragdoll_only = true,
	ragdoll_push_force = 800,
	stagger_category = "melee",
	cleave_distribution = large_cleave,
	damage_type = damage_types.blunt_thunder,
	gibbing_power = GibbingPower.always,
	gibbing_type = GibbingTypes.crushing,
	melee_attack_strength = melee_attack_strengths.light,
	wounds_template = WoundsTemplates.thunder_hammer,
	armor_damage_modifier = hammer_smiter_light_default_am,
	stagger_duration_modifier = {
		0.1,
		0.5,
	},
	targets = {
		{
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_9,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
					[armor_types.player] = damage_lerp_values.no_damage,
					[armor_types.berserker] = damage_lerp_values.lerp_0_5,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_25,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_75,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_1,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
					[armor_types.player] = damage_lerp_values.no_damage,
					[armor_types.berserker] = damage_lerp_values.lerp_1,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_75,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
				},
			},
			power_distribution = {
				attack = {
					100,
					200,
				},
				impact = {
					8,
					22,
				},
			},
			finesse_boost = {
				[armor_types.unarmored] = 0.5,
				[armor_types.armored] = 0.5,
				[armor_types.resistant] = 0.5,
				[armor_types.player] = 0.3,
				[armor_types.berserker] = 0.5,
				[armor_types.super_armor] = 0.5,
				[armor_types.disgustingly_resilient] = 0.5,
				[armor_types.void_shield] = 0.3,
			},
			boost_curve_multiplier_finesse = {
				0.5,
				1.5,
			},
			power_level_multiplier = {
				0.75,
				1.25,
			},
		},
		{
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = {
					80,
					160,
				},
				impact = {
					9,
					18,
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
					5,
					10,
				},
			},
			boost_curve = PowerLevelSettings.boost_curves.default,
			finesse_boost = {
				[armor_types.unarmored] = 0.1,
				[armor_types.armored] = 0.5,
				[armor_types.resistant] = 0.1,
				[armor_types.player] = 0.1,
				[armor_types.berserker] = 0.1,
				[armor_types.super_armor] = 0.1,
				[armor_types.disgustingly_resilient] = 0.5,
				[armor_types.void_shield] = 0.5,
			},
		},
	},
	gib_push_force = GibbingSettings.gib_push_force.blunt_light,
}
overrides.thunderhammer_light_linesman_active_sweep = {
	parent_template_name = "thunderhammer_light_linesman",
	overrides = {
		{
			"cleave_distribution",
			"attack",
			{
				4,
				8,
			},
		},
		{
			"cleave_distribution",
			"impact",
			{
				3,
				3,
			},
		},
		{
			"targets",
			1,
			"power_distribution",
			"attack",
			{
				110,
				250,
			},
		},
		{
			"targets",
			1,
			"power_distribution",
			"impact",
			{
				12,
				24,
			},
		},
		{
			"targets",
			2,
			"power_distribution",
			"attack",
			{
				55,
				135,
			},
		},
		{
			"targets",
			2,
			"power_distribution",
			"impact",
			{
				10,
				20,
			},
		},
	},
}
damage_templates.thunderhammer_light_tank = {
	finesse_ability_damage_multiplier = 1.5,
	ragdoll_only = true,
	ragdoll_push_force = 500,
	stagger_category = "melee",
	cleave_distribution = large_cleave,
	damage_type = damage_types.blunt_thunder,
	gibbing_power = GibbingPower.always,
	gibbing_type = GibbingTypes.crushing,
	melee_attack_strength = melee_attack_strengths.light,
	wounds_template = WoundsTemplates.thunder_hammer,
	armor_damage_modifier = hammer_smiter_light_default_am,
	stagger_duration_modifier = {
		0.1,
		0.5,
	},
	targets = {
		{
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_9,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
					[armor_types.player] = damage_lerp_values.no_damage,
					[armor_types.berserker] = damage_lerp_values.lerp_0_5,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_25,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_75,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_75,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
					[armor_types.player] = damage_lerp_values.no_damage,
					[armor_types.berserker] = damage_lerp_values.lerp_0_5,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_75,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_75,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
				},
			},
			power_distribution = {
				attack = {
					100,
					200,
				},
				impact = {
					8,
					20,
				},
			},
			finesse_boost = {
				[armor_types.unarmored] = 0.5,
				[armor_types.armored] = 0.5,
				[armor_types.resistant] = 0.5,
				[armor_types.player] = 0.3,
				[armor_types.berserker] = 0.5,
				[armor_types.super_armor] = 0.5,
				[armor_types.disgustingly_resilient] = 0.5,
				[armor_types.void_shield] = 0.3,
			},
			boost_curve_multiplier_finesse = {
				0.5,
				1.5,
			},
			power_level_multiplier = {
				0.75,
				1.25,
			},
		},
		{
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = {
					50,
					70,
				},
				impact = {
					9,
					18,
				},
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
					16,
				},
			},
		},
		{
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = {
					15,
					25,
				},
				impact = {
					5,
					7,
				},
			},
		},
		default_target = {
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = {
					8,
					12,
				},
				impact = {
					5,
					5,
				},
			},
			boost_curve = PowerLevelSettings.boost_curves.default,
			finesse_boost = {
				[armor_types.unarmored] = 0.1,
				[armor_types.armored] = 0.5,
				[armor_types.resistant] = 0.1,
				[armor_types.player] = 0.1,
				[armor_types.berserker] = 0.1,
				[armor_types.super_armor] = 0.1,
				[armor_types.disgustingly_resilient] = 0.5,
				[armor_types.void_shield] = 0.5,
			},
		},
	},
	gib_push_force = GibbingSettings.gib_push_force.blunt_light,
}
damage_templates.thunderhammer_light_active = {
	finesse_ability_damage_multiplier = 1.5,
	gibbing_power = 0,
	ignore_stagger_reduction = true,
	ragdoll_only = true,
	ragdoll_push_force = 1000,
	shield_override_stagger_strength = 500,
	stagger_category = "melee",
	weapon_special = true,
	cleave_distribution = {
		attack = 0.01,
		impact = 0.01,
	},
	damage_type = damage_types.blunt_thunder,
	gibbing_type = GibbingTypes.default,
	melee_attack_strength = melee_attack_strengths.light,
	wounds_template = WoundsTemplates.thunder_hammer_active,
	armor_damage_modifier = hammer_smiter_light_default_am,
	targets = {
		{
			armor_damage_modifier = hammer_smiter_light_active_am,
			power_distribution = {
				attack = {
					400,
					750,
				},
				impact = {
					25,
					35,
				},
			},
			finesse_boost = {
				[armor_types.unarmored] = 1,
				[armor_types.armored] = 1,
				[armor_types.resistant] = 0.3,
				[armor_types.player] = 0.3,
				[armor_types.berserker] = 0.5,
				[armor_types.super_armor] = 0.5,
				[armor_types.disgustingly_resilient] = 0.3,
				[armor_types.void_shield] = 0.3,
			},
			boost_curve_multiplier_finesse = {
				0.65,
				1.15,
			},
			power_level_multiplier = {
				0.75,
				1.25,
			},
		},
		{
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = {
					15,
					25,
				},
				impact = {
					8,
					12,
				},
			},
		},
		default_target = {
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = {
					8,
					12,
				},
				impact = {
					4,
					6,
				},
			},
			boost_curve = PowerLevelSettings.boost_curves.default,
			finesse_boost = {
				[armor_types.unarmored] = 0.1,
				[armor_types.armored] = 0.5,
				[armor_types.resistant] = 0.1,
				[armor_types.player] = 0.1,
				[armor_types.berserker] = 0.1,
				[armor_types.super_armor] = 0.1,
				[armor_types.disgustingly_resilient] = 0.5,
				[armor_types.void_shield] = 0.5,
			},
		},
	},
	gib_push_force = GibbingSettings.gib_push_force.blunt_heavy,
}
overrides.thunderhammer_pushfollow_active = {
	parent_template_name = "thunderhammer_light_active",
	overrides = {
		{
			"cleave_distribution",
			"attack",
			0.01,
		},
		{
			"cleave_distribution",
			"impact",
			0.01,
		},
	},
}
overrides.thunderhammer_pushfollow = {
	parent_template_name = "thunderhammer_light_tank",
	overrides = {
		{
			"ragdoll_push_force",
			250,
		},
	},
}
damage_templates.thunderhammer_heavy = {
	finesse_ability_damage_multiplier = 1.5,
	ragdoll_only = true,
	ragdoll_push_force = 750,
	stagger_category = "melee",
	armor_damage_modifier = hammer_tank_heavy_am,
	cleave_distribution = {
		attack = {
			10,
			20,
		},
		impact = {
			10,
			20,
		},
	},
	damage_type = damage_types.blunt_thunder,
	gibbing_power = GibbingPower.always,
	gibbing_type = GibbingTypes.crushing,
	melee_attack_strength = melee_attack_strengths.heavy,
	wounds_template = WoundsTemplates.thunder_hammer,
	stagger_duration_modifier = {
		0.3,
		0.6,
	},
	targets = {
		{
			armor_damage_modifier = hammer_tank_heavy_first_am,
			power_distribution = {
				attack = {
					180,
					350,
				},
				impact = {
					25,
					35,
				},
			},
			boost_curve_multiplier_finesse = {
				0.25,
				0.75,
			},
			power_level_multiplier = {
				0.75,
				1.25,
			},
		},
		{
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = {
					100,
					200,
				},
				impact = {
					20,
					30,
				},
			},
		},
		{
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = {
					75,
					150,
				},
				impact = {
					14,
					24,
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
					10,
					24,
				},
			},
		},
		{
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = {
					30,
					60,
				},
				impact = {
					8,
					16,
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
					8,
					16,
				},
			},
			armor_damage_modifier = hammer_tank_heavy_am,
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
	gib_push_force = GibbingSettings.gib_push_force.blunt_light,
}
overrides.thunderhammer_heavy_active_sweep = {
	parent_template_name = "thunderhammer_heavy",
	overrides = {
		{
			"cleave_distribution",
			"attack",
			{
				10,
				20,
			},
		},
		{
			"cleave_distribution",
			"impact",
			{
				4,
				8,
			},
		},
		{
			"targets",
			1,
			"power_distribution",
			"attack",
			{
				250,
				500,
			},
		},
		{
			"targets",
			1,
			"power_distribution",
			"impact",
			{
				35,
				45,
			},
		},
		{
			"targets",
			2,
			"power_distribution",
			"attack",
			{
				200,
				400,
			},
		},
		{
			"targets",
			2,
			"power_distribution",
			"impact",
			{
				30,
				40,
			},
		},
		{
			"targets",
			3,
			"power_distribution",
			"attack",
			{
				150,
				300,
			},
		},
		{
			"targets",
			3,
			"power_distribution",
			"impact",
			{
				25,
				35,
			},
		},
		{
			"targets",
			4,
			"power_distribution",
			"attack",
			{
				120,
				240,
			},
		},
		{
			"targets",
			4,
			"power_distribution",
			"impact",
			{
				20,
				30,
			},
		},
		{
			"targets",
			5,
			"power_distribution",
			"attack",
			{
				80,
				160,
			},
		},
		{
			"targets",
			5,
			"power_distribution",
			"impact",
			{
				15,
				25,
			},
		},
		{
			"targets",
			"default_target",
			"power_distribution",
			"attack",
			{
				50,
				100,
			},
		},
		{
			"targets",
			"default_target",
			"power_distribution",
			"impact",
			{
				10,
				20,
			},
		},
		{
			"ragdoll_push_force",
			1250,
		},
	},
}
overrides.thunderhammer_heavy_active_sweep_m1 = {
	parent_template_name = "thunderhammer_heavy",
	overrides = {
		{
			"cleave_distribution",
			"attack",
			{
				1,
				3,
			},
		},
		{
			"cleave_distribution",
			"impact",
			{
				1,
				3,
			},
		},
		{
			"targets",
			1,
			"power_distribution",
			"attack",
			{
				400,
				800,
			},
		},
		{
			"targets",
			1,
			"power_distribution",
			"impact",
			{
				35,
				45,
			},
		},
		{
			"targets",
			2,
			"power_distribution",
			"attack",
			{
				200,
				400,
			},
		},
		{
			"targets",
			2,
			"power_distribution",
			"impact",
			{
				30,
				40,
			},
		},
		{
			"targets",
			3,
			"power_distribution",
			"attack",
			{
				150,
				300,
			},
		},
		{
			"targets",
			3,
			"power_distribution",
			"impact",
			{
				25,
				35,
			},
		},
		{
			"targets",
			4,
			"power_distribution",
			"attack",
			{
				120,
				240,
			},
		},
		{
			"targets",
			4,
			"power_distribution",
			"impact",
			{
				20,
				30,
			},
		},
		{
			"targets",
			5,
			"power_distribution",
			"attack",
			{
				80,
				160,
			},
		},
		{
			"targets",
			5,
			"power_distribution",
			"impact",
			{
				15,
				25,
			},
		},
		{
			"targets",
			"default_target",
			"power_distribution",
			"attack",
			{
				50,
				100,
			},
		},
		{
			"targets",
			"default_target",
			"power_distribution",
			"impact",
			{
				10,
				20,
			},
		},
		{
			"ragdoll_push_force",
			1250,
		},
	},
}
damage_templates.thunderhammer_m2_heavy_active_strikedown = {
	finesse_ability_damage_multiplier = 2,
	gibbing_power = 0,
	ignore_stagger_reduction = true,
	ragdoll_only = true,
	ragdoll_push_force = 1000,
	shield_override_stagger_strength = 500,
	stagger_category = "melee",
	weapon_special = true,
	armor_damage_modifier = hammer_tank_heavy_am,
	cleave_distribution = {
		attack = 0.01,
		impact = 0.01,
	},
	damage_type = damage_types.blunt_thunder,
	gibbing_type = GibbingTypes.explosion,
	melee_attack_strength = melee_attack_strengths.heavy,
	wounds_template = WoundsTemplates.thunder_hammer_active,
	targets = {
		{
			boost_curve_multiplier_finesse = 0.5,
			armor_damage_modifier = hammer_tank_heavy_first_active_am,
			power_distribution = {
				attack = {
					450,
					900,
				},
				impact = {
					45,
					55,
				},
			},
			power_level_multiplier = {
				0.75,
				1.25,
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
					25,
					35,
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
					5,
					15,
				},
			},
			armor_damage_modifier = hammer_tank_heavy_am,
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
	gib_push_force = GibbingSettings.gib_push_force.blunt_heavy,
}
damage_templates.thunderhammer_heavy_smiter = {
	finesse_ability_damage_multiplier = 1.5,
	ragdoll_only = true,
	ragdoll_push_force = 750,
	stagger_category = "melee",
	armor_damage_modifier = hammer_tank_heavy_am,
	cleave_distribution = double_cleave,
	damage_type = damage_types.blunt_thunder,
	gibbing_power = GibbingPower.always,
	gibbing_type = GibbingTypes.crushing,
	melee_attack_strength = melee_attack_strengths.heavy,
	wounds_template = WoundsTemplates.thunder_hammer,
	stagger_duration_modifier = {
		0.3,
		0.6,
	},
	targets = {
		{
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_1,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
					[armor_types.player] = damage_lerp_values.no_damage,
					[armor_types.berserker] = damage_lerp_values.lerp_0_75,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_75,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_1,
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_1,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
					[armor_types.player] = damage_lerp_values.no_damage,
					[armor_types.berserker] = damage_lerp_values.lerp_1,
					[armor_types.super_armor] = damage_lerp_values.lerp_1,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_1,
				},
			},
			power_distribution = {
				attack = {
					300,
					600,
				},
				impact = {
					25,
					50,
				},
			},
			boost_curve_multiplier_finesse = {
				0.25,
				0.95,
			},
			power_level_multiplier = {
				0.75,
				1.25,
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
					20,
					30,
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
					8,
					16,
				},
			},
			armor_damage_modifier = hammer_tank_heavy_am,
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
	gib_push_force = GibbingSettings.gib_push_force.blunt_light,
}
damage_templates.thunderhammer_heavy_active = {
	finesse_ability_damage_multiplier = 2,
	gibbing_power = 0,
	ignore_stagger_reduction = true,
	ragdoll_only = true,
	ragdoll_push_force = 1000,
	shield_override_stagger_strength = 500,
	stagger_category = "melee",
	weapon_special = true,
	armor_damage_modifier = hammer_tank_heavy_am,
	cleave_distribution = {
		attack = 0.01,
		impact = 0.01,
	},
	damage_type = damage_types.blunt_thunder,
	gibbing_type = GibbingTypes.explosion,
	melee_attack_strength = melee_attack_strengths.heavy,
	wounds_template = WoundsTemplates.thunder_hammer_active,
	targets = {
		{
			boost_curve_multiplier_finesse = 0.5,
			armor_damage_modifier = hammer_tank_heavy_first_active_am,
			power_distribution = {
				attack = {
					500,
					1000,
				},
				impact = {
					45,
					55,
				},
			},
			power_level_multiplier = {
				0.75,
				1.25,
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
					25,
					35,
				},
			},
		},
		{
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = {
					10,
					40,
				},
				impact = {
					15,
					25,
				},
			},
		},
		{
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = {
					0,
					0,
				},
				impact = {
					10,
					20,
				},
			},
		},
		{
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = {
					0,
					0,
				},
				impact = {
					10,
					20,
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
					5,
					15,
				},
			},
			armor_damage_modifier = hammer_tank_heavy_am,
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
	gib_push_force = GibbingSettings.gib_push_force.blunt_heavy,
}
damage_templates.thunderhammer_m1_heavy_active = {
	finesse_ability_damage_multiplier = 2,
	gibbing_power = 0,
	ignore_stagger_reduction = true,
	ragdoll_only = true,
	ragdoll_push_force = 1000,
	shield_override_stagger_strength = 500,
	stagger_category = "melee",
	weapon_special = true,
	armor_damage_modifier = hammer_tank_heavy_am,
	cleave_distribution = {
		attack = 0.01,
		impact = 0.01,
	},
	damage_type = damage_types.blunt_thunder,
	gibbing_type = GibbingTypes.explosion,
	melee_attack_strength = melee_attack_strengths.heavy,
	wounds_template = WoundsTemplates.thunder_hammer_active,
	targets = {
		default_target = {
			boost_curve_multiplier_finesse = 0.5,
			armor_damage_modifier = hammer_tank_heavy_first_active_am,
			power_distribution = {
				attack = {
					500,
					1000,
				},
				impact = {
					45,
					55,
				},
			},
			power_level_multiplier = {
				0.75,
				1.25,
			},
		},
	},
	gib_push_force = GibbingSettings.gib_push_force.blunt_heavy,
}
damage_templates.thunderhammer_m2_heavy_active = {
	finesse_ability_damage_multiplier = 2,
	gibbing_power = 0,
	ignore_stagger_reduction = true,
	ragdoll_only = true,
	ragdoll_push_force = 1000,
	shield_override_stagger_strength = 500,
	stagger_category = "melee",
	weapon_special = true,
	armor_damage_modifier = hammer_tank_heavy_am,
	cleave_distribution = {
		attack = 0.01,
		impact = 0.01,
	},
	damage_type = damage_types.blunt_thunder,
	gibbing_type = GibbingTypes.explosion,
	melee_attack_strength = melee_attack_strengths.heavy,
	wounds_template = WoundsTemplates.thunder_hammer_active,
	targets = {
		default_target = {
			boost_curve_multiplier_finesse = 0.5,
			armor_damage_modifier = hammer_tank_heavy_first_active_am,
			power_distribution = {
				attack = {
					400,
					800,
				},
				impact = {
					45,
					55,
				},
			},
			power_level_multiplier = {
				0.75,
				1.25,
			},
		},
	},
	gib_push_force = GibbingSettings.gib_push_force.blunt_heavy,
}
damage_templates.thunderhammer_m2_light_active = {
	finesse_ability_damage_multiplier = 1.5,
	gibbing_power = 0,
	ignore_stagger_reduction = true,
	ragdoll_only = true,
	ragdoll_push_force = 1000,
	shield_override_stagger_strength = 500,
	stagger_category = "melee",
	weapon_special = true,
	cleave_distribution = {
		attack = 0.01,
		impact = 0.01,
	},
	damage_type = damage_types.blunt_thunder,
	gibbing_type = GibbingTypes.default,
	melee_attack_strength = melee_attack_strengths.light,
	wounds_template = WoundsTemplates.thunder_hammer_active,
	armor_damage_modifier = hammer_smiter_light_default_am,
	targets = {
		default_target = {
			boost_curve_multiplier_finesse = 0.65,
			armor_damage_modifier = hammer_smiter_light_active_am,
			power_distribution = {
				attack = {
					300,
					600,
				},
				impact = {
					25,
					35,
				},
			},
			finesse_boost = {
				[armor_types.unarmored] = 1,
				[armor_types.armored] = 1,
				[armor_types.resistant] = 0.75,
				[armor_types.player] = 0.1,
				[armor_types.berserker] = 0.75,
				[armor_types.super_armor] = 0.75,
				[armor_types.disgustingly_resilient] = 0.75,
				[armor_types.void_shield] = 0.25,
			},
			power_level_multiplier = {
				0.75,
				1.25,
			},
		},
	},
	gib_push_force = GibbingSettings.gib_push_force.blunt_heavy,
}
overrides.thunderhammer_m2_pushfollow_active = {
	parent_template_name = "thunderhammer_m2_light_active",
	overrides = {
		{
			"cleave_distribution",
			"attack",
			0.01,
		},
		{
			"cleave_distribution",
			"impact",
			0.01,
		},
	},
}

return {
	base_templates = damage_templates,
	overrides = overrides,
}
