-- chunkname: @scripts/settings/equipment/weapon_templates/ogryn_axes_2h/settings_templates/ogryn_pickaxe_damage_profile_templates.lua

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
local medium_cleave = DamageProfileSettings.medium_cleave
local big_cleave = DamageProfileSettings.big_cleave
local large_cleave = DamageProfileSettings.large_cleave
local am_default = {
	attack = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1,
		[armor_types.armored] = damage_lerp_values.lerp_0_9,
		[armor_types.resistant] = damage_lerp_values.lerp_1_2,
		[armor_types.player] = damage_lerp_values.lerp_1,
		[armor_types.berserker] = damage_lerp_values.lerp_0_8,
		[armor_types.super_armor] = damage_lerp_values.lerp_0_75,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_8,
		[armor_types.void_shield] = damage_lerp_values.lerp_1_33,
	},
	impact = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1,
		[armor_types.armored] = damage_lerp_values.lerp_1,
		[armor_types.resistant] = damage_lerp_values.lerp_0_8,
		[armor_types.player] = damage_lerp_values.lerp_1,
		[armor_types.berserker] = damage_lerp_values.lerp_0_75,
		[armor_types.super_armor] = damage_lerp_values.lerp_0_65,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
		[armor_types.void_shield] = damage_lerp_values.lerp_1,
	},
}

damage_templates.ogryn_pickaxe_light_linesman = {
	ragdoll_only = true,
	ragdoll_push_force = 350,
	stagger_category = "melee",
	cleave_distribution = medium_cleave,
	gibbing_power = GibbingPower.light,
	gibbing_type = GibbingTypes.sawing,
	melee_attack_strength = melee_attack_strengths.light,
	wounds_template = WoundsTemplates.pickaxe,
	armor_damage_modifier = am_default,
	stagger_duration_modifier = {
		0.2,
		0.7,
	},
	targets = {
		{
			boost_curve_multiplier_finesse = 0.2,
			power_distribution = {
				attack = {
					140,
					350,
				},
				impact = {
					9,
					19,
				},
			},
			finesse_boost = {
				[armor_types.unarmored] = 0.4,
				[armor_types.armored] = 0.5,
				[armor_types.resistant] = 0.4,
				[armor_types.player] = 0.1,
				[armor_types.berserker] = 0.4,
				[armor_types.super_armor] = 0.5,
				[armor_types.disgustingly_resilient] = 0.4,
				[armor_types.void_shield] = 0.4,
			},
			power_level_multiplier = {
				0.5,
				1.5,
			},
		},
		{
			boost_curve_multiplier_finesse = 0.15,
			power_distribution = {
				attack = {
					110,
					270,
				},
				impact = {
					8,
					17,
				},
			},
		},
		{
			boost_curve_multiplier_finesse = 0.15,
			power_distribution = {
				attack = {
					75,
					160,
				},
				impact = {
					5,
					13,
				},
			},
		},
		{
			boost_curve_multiplier_finesse = 0.1,
			power_distribution = {
				attack = {
					50,
					80,
				},
				impact = {
					5,
					8,
				},
			},
		},
		{
			boost_curve_multiplier_finesse = 0.1,
			power_distribution = {
				attack = {
					30,
					60,
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
					20,
					50,
				},
				impact = {
					3,
					6,
				},
			},
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
	gib_push_force = GibbingSettings.gib_push_force.sawing_heavy,
}
overrides.ogryn_pickaxe_light_linesman_m1 = {
	parent_template_name = "ogryn_pickaxe_light_linesman",
	overrides = {
		{
			"targets",
			1,
			"power_distribution",
			"impact",
			{
				8,
				25,
			},
		},
	},
}
damage_templates.ogryn_pickaxe_light_smiter = {
	ragdoll_only = true,
	ragdoll_push_force = 800,
	stagger_category = "melee",
	cleave_distribution = double_cleave,
	damage_type = damage_types.shovel_heavy,
	gibbing_power = GibbingPower.light,
	gibbing_type = GibbingTypes.crushing,
	melee_attack_strength = melee_attack_strengths.light,
	wounds_template = WoundsTemplates.pickaxe,
	armor_damage_modifier = am_default,
	stagger_duration_modifier = {
		0.2,
		0.7,
	},
	targets = {
		{
			boost_curve_multiplier_finesse = 0.5,
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_9,
					[armor_types.resistant] = damage_lerp_values.lerp_1_2,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_9,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_75,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_8,
					[armor_types.void_shield] = damage_lerp_values.lerp_1_33,
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_1,
					[armor_types.resistant] = damage_lerp_values.lerp_0_8,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_75,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_65,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_1,
				},
			},
			power_distribution = {
				attack = {
					145,
					385,
				},
				impact = {
					15,
					40,
				},
			},
			power_level_multiplier = {
				0.5,
				1.5,
			},
		},
		{
			boost_curve_multiplier_finesse = 0.3,
			power_distribution = {
				attack = {
					60,
					100,
				},
				impact = {
					5,
					10,
				},
			},
		},
		default_target = {
			boost_curve_multiplier_finesse = 0.3,
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_1,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_5,
					[armor_types.super_armor] = damage_lerp_values.no_damage,
					[armor_types.disgustingly_resilient] = damage_lerp_values.no_damage,
					[armor_types.void_shield] = damage_lerp_values.no_damage,
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_1,
					[armor_types.resistant] = damage_lerp_values.lerp_0_8,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_8,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_7,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_75,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
				},
			},
			power_distribution = {
				attack = {
					20,
					30,
				},
				impact = {
					5,
					10,
				},
			},
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
	gib_push_force = GibbingSettings.gib_push_force.sawing_heavy,
}
overrides.ogryn_pickaxe_light_smiter_m1 = {
	parent_template_name = "ogryn_pickaxe_light_smiter",
	overrides = {
		{
			"targets",
			1,
			"power_distribution",
			"attack",
			{
				160,
				450,
			},
		},
		{
			"targets",
			1,
			"power_distribution",
			"impact",
			{
				25,
				50,
			},
		},
	},
}
damage_templates.ogryn_pickaxe_heavy_smiter = {
	ragdoll_only = true,
	ragdoll_push_force = 1500,
	stagger_category = "melee",
	cleave_distribution = double_cleave,
	gibbing_power = GibbingPower.medium,
	gibbing_type = GibbingTypes.sawing,
	melee_attack_strength = melee_attack_strengths.heavy,
	wounds_template = WoundsTemplates.pickaxe,
	armor_damage_modifier = am_default,
	stagger_duration_modifier = {
		0.2,
		0.7,
	},
	targets = {
		{
			boost_curve_multiplier_finesse = 0.5,
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_1,
					[armor_types.resistant] = damage_lerp_values.lerp_1_2,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_1,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_9,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_9,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_1,
					[armor_types.resistant] = damage_lerp_values.lerp_0_8,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_8,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_7,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_9,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
				},
			},
			power_distribution = {
				attack = {
					240,
					750,
				},
				impact = {
					30,
					65,
				},
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
					80,
					350,
				},
				impact = {
					10,
					20,
				},
			},
		},
		default_target = {
			boost_curve_multiplier_finesse = 0.25,
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_1,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_5,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_5,
					[armor_types.void_shield] = damage_lerp_values.no_damage,
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_1,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_5,
					[armor_types.super_armor] = damage_lerp_values.lerp_1,
					[armor_types.disgustingly_resilient] = damage_lerp_values.no_damage,
					[armor_types.void_shield] = damage_lerp_values.no_damage,
				},
			},
			power_distribution = {
				attack = {
					20,
					30,
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
	gib_push_force = GibbingSettings.gib_push_force.sawing_heavy,
}
overrides.ogryn_pickaxe_heavy_smiter_m1 = {
	parent_template_name = "ogryn_pickaxe_heavy_smiter",
	overrides = {
		{
			"targets",
			1,
			"power_distribution",
			"attack",
			{
				300,
				900,
			},
		},
		{
			"targets",
			1,
			"power_distribution",
			"impact",
			{
				40,
				85,
			},
		},
	},
}
damage_templates.ogryn_pickaxe_heavy_linesman = {
	ragdoll_only = true,
	ragdoll_push_force = 1000,
	stagger_category = "melee",
	cleave_distribution = {
		attack = {
			5,
			25,
		},
		impact = {
			5,
			25,
		},
	},
	gibbing_power = GibbingPower.medium,
	gibbing_type = GibbingTypes.sawing,
	melee_attack_strength = melee_attack_strengths.heavy,
	wounds_template = WoundsTemplates.pickaxe,
	armor_damage_modifier = am_default,
	stagger_duration_modifier = {
		0.2,
		0.6,
	},
	targets = {
		{
			boost_curve_multiplier_finesse = 0.25,
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_1,
					[armor_types.resistant] = damage_lerp_values.lerp_0_9,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_8,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_75,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_9,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_1,
					[armor_types.resistant] = damage_lerp_values.lerp_0_8,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_75,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_65,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
				},
			},
			power_distribution = {
				attack = {
					205,
					530,
				},
				impact = {
					22,
					50,
				},
			},
			finesse_boost = {
				[armor_types.unarmored] = 0.4,
				[armor_types.armored] = 0.5,
				[armor_types.resistant] = 0.4,
				[armor_types.player] = 0.1,
				[armor_types.berserker] = 0.4,
				[armor_types.super_armor] = 0.5,
				[armor_types.disgustingly_resilient] = 0.4,
				[armor_types.void_shield] = 0.4,
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
					120,
					350,
				},
				impact = {
					10,
					30,
				},
			},
		},
		{
			power_distribution = {
				attack = {
					110,
					260,
				},
				impact = {
					10,
					22,
				},
			},
		},
		{
			power_distribution = {
				attack = {
					80,
					220,
				},
				impact = {
					10,
					20,
				},
			},
		},
		{
			power_distribution = {
				attack = {
					80,
					100,
				},
				impact = {
					5,
					12,
				},
			},
		},
		{
			power_distribution = {
				attack = {
					30,
					80,
				},
				impact = {
					5,
					11,
				},
			},
		},
		default_target = {
			boost_curve_multiplier_finesse = 0.25,
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_1,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_5,
					[armor_types.super_armor] = damage_lerp_values.no_damage,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.no_damage,
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_1,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_5,
					[armor_types.super_armor] = damage_lerp_values.lerp_1,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.no_damage,
				},
			},
			power_distribution = {
				attack = {
					20,
					30,
				},
				impact = {
					2,
					10,
				},
			},
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
	gib_push_force = GibbingSettings.gib_push_force.sawing_heavy,
}
damage_templates.ogryn_pickaxe_pushfollowup_m2 = {
	ragdoll_only = true,
	ragdoll_push_force = 550,
	stagger_category = "melee",
	cleave_distribution = big_cleave,
	gibbing_power = GibbingPower.always,
	gibbing_type = GibbingTypes.default,
	melee_attack_strength = melee_attack_strengths.light,
	wounds_template = WoundsTemplates.ogryn_club,
	armor_damage_modifier = am_default,
	targets = {
		{
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = {
					90,
					220,
				},
				impact = {
					9,
					20,
				},
			},
		},
		{
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = {
					70,
					170,
				},
				impact = {
					8,
					16,
				},
			},
		},
		{
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = {
					50,
					120,
				},
				impact = {
					5,
					14,
				},
			},
		},
		default_target = {
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = {
					15,
					50,
				},
				impact = {
					5,
					12,
				},
			},
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
	gib_push_force = GibbingSettings.gib_push_force.blunt_heavy,
}
damage_templates.ogryn_pickaxe_pushfollowup_m1 = {
	ragdoll_only = true,
	ragdoll_push_force = 550,
	stagger_category = "melee",
	cleave_distribution = medium_cleave,
	gibbing_power = GibbingPower.always,
	gibbing_type = GibbingTypes.default,
	melee_attack_strength = melee_attack_strengths.light,
	wounds_template = WoundsTemplates.pickaxe,
	armor_damage_modifier = am_default,
	targets = {
		{
			boost_curve_multiplier_finesse = 0.6,
			power_distribution = {
				attack = {
					140,
					360,
				},
				impact = {
					8,
					13,
				},
			},
		},
		{
			boost_curve_multiplier_finesse = 0.6,
			power_distribution = {
				attack = {
					120,
					330,
				},
				impact = {
					6,
					11,
				},
			},
		},
		{
			boost_curve_multiplier_finesse = 0.3,
			power_distribution = {
				attack = {
					50,
					100,
				},
				impact = {
					4,
					9,
				},
			},
		},
		{
			boost_curve_multiplier_finesse = 0.3,
			power_distribution = {
				attack = {
					45,
					90,
				},
				impact = {
					4,
					8,
				},
			},
		},
		default_target = {
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = {
					15,
					50,
				},
				impact = {
					5,
					9,
				},
			},
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
	gib_push_force = GibbingSettings.gib_push_force.blunt_heavy,
}
damage_templates.ogryn_pickaxe_blunt = {
	ragdoll_only = true,
	ragdoll_push_force = 400,
	stagger_category = "melee",
	weapon_special = true,
	cleave_distribution = big_cleave,
	damage_type = damage_types.ogryn_pipe_club_heavy,
	gibbing_power = GibbingPower.always,
	gibbing_type = GibbingTypes.default,
	melee_attack_strength = melee_attack_strengths.light,
	wounds_template = WoundsTemplates.ogryn_club,
	armor_damage_modifier = am_default,
	targets = {
		{
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = {
					65,
					150,
				},
				impact = {
					16,
					33,
				},
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
					8,
					20,
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
					6,
					18,
				},
			},
		},
		{
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = {
					30,
					40,
				},
				impact = {
					5,
					16,
				},
			},
		},
		{
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = {
					30,
					35,
				},
				impact = {
					5,
					12,
				},
			},
		},
		{
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = {
					30,
					35,
				},
				impact = {
					5,
					11,
				},
			},
		},
		default_target = {
			power_distribution = {
				attack = {
					15,
					30,
				},
				impact = {
					5,
					10,
				},
			},
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
	gib_push_force = GibbingSettings.gib_push_force.blunt_heavy,
}
damage_templates.ogryn_pickaxe_blunt_m3 = {
	ragdoll_only = true,
	ragdoll_push_force = 600,
	stagger_category = "killshot",
	stagger_override = "medium",
	cleave_distribution = big_cleave,
	damage_type = damage_types.ogryn_pipe_club_heavy,
	gibbing_power = GibbingPower.always,
	gibbing_type = GibbingTypes.default,
	melee_attack_strength = melee_attack_strengths.light,
	wounds_template = WoundsTemplates.ogryn_club,
	armor_damage_modifier = am_default,
	targets = {
		{
			boost_curve_multiplier_finesse = 0.45,
			power_distribution = {
				attack = {
					50,
					160,
				},
				impact = {
					20,
					60,
				},
			},
		},
		{
			boost_curve_multiplier_finesse = 0.4,
			power_distribution = {
				attack = {
					50,
					140,
				},
				impact = {
					10,
					60,
				},
			},
		},
		{
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = {
					30,
					100,
				},
				impact = {
					10,
					35,
				},
			},
		},
		default_target = {
			power_distribution = {
				attack = {
					15,
					50,
				},
				impact = {
					5,
					10,
				},
			},
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
	gib_push_force = GibbingSettings.gib_push_force.blunt_heavy,
}
damage_templates.special_pull = {
	ignore_shield = true,
	ignore_stagger_reduction = true,
	ragdoll_only = true,
	ragdoll_push_force = 400,
	stagger_category = "uppercut",
	weakspot_stagger_resistance_modifier = 0.08,
	weapon_special = true,
	cleave_distribution = big_cleave,
	damage_type = damage_types.blunt_thunder,
	gibbing_power = GibbingPower.always,
	gibbing_type = GibbingTypes.default,
	melee_attack_strength = melee_attack_strengths.light,
	stagger_duration_modifier = {
		0.25,
		0.5,
	},
	targets = {
		{
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_8,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_5,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_1_5,
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1_1,
					[armor_types.armored] = damage_lerp_values.lerp_1_25,
					[armor_types.resistant] = damage_lerp_values.lerp_2,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_1_25,
					[armor_types.super_armor] = damage_lerp_values.lerp_2_5,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_1_5,
				},
			},
			power_distribution = {
				attack = {
					10,
					30,
				},
				impact = {
					20,
					20,
				},
			},
			power_level_multiplier = {
				0.6,
				1.4,
			},
		},
		default_target = {
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.no_damage,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_5,
					[armor_types.super_armor] = damage_lerp_values.no_damage,
					[armor_types.disgustingly_resilient] = damage_lerp_values.no_damage,
					[armor_types.void_shield] = damage_lerp_values.no_damage,
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1_1,
					[armor_types.armored] = damage_lerp_values.lerp_1_25,
					[armor_types.resistant] = damage_lerp_values.lerp_1_75,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_1_25,
					[armor_types.super_armor] = damage_lerp_values.lerp_1_75,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_1_5,
				},
			},
			power_distribution = {
				attack = 15,
				impact = {
					10,
					20,
				},
			},
			boost_curve = PowerLevelSettings.boost_curves.default,
			power_level_multiplier = {
				0.6,
				1.1,
			},
		},
	},
	gib_push_force = GibbingSettings.gib_push_force.sawing_heavy,
}

return {
	base_templates = damage_templates,
	overrides = overrides,
}
