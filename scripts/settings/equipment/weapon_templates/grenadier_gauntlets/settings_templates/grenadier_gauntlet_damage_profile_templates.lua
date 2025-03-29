-- chunkname: @scripts/settings/equipment/weapon_templates/grenadier_gauntlets/settings_templates/grenadier_gauntlet_damage_profile_templates.lua

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
local big_cleave = DamageProfileSettings.big_cleave
local medium_cleave = DamageProfileSettings.medium_cleave
local damage_templates = {}
local overrides = {}

table.make_unique(damage_templates)
table.make_unique(overrides)

damage_templates.light_grenadier_gauntlet_tank = {
	dead_ragdoll_mod = 1.5,
	ignore_stagger_reduction = true,
	ragdoll_only = true,
	ragdoll_push_force = 500,
	stagger_category = "melee",
	cleave_distribution = big_cleave,
	damage_type = damage_types.blunt_thunder,
	gibbing_type = gibbing_types.default,
	gibbing_power = gibbing_power.always,
	wounds_template = WoundsTemplates.gauntlet_melee,
	melee_attack_strength = melee_attack_strengths.light,
	targets = {
		{
			boost_curve_multiplier_finesse = 0.25,
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_75,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_5,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_1,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_1_5,
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_5,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_25,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_25,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_1_5,
				},
			},
			power_distribution = {
				attack = {
					80,
					160,
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
					40,
					80,
				},
				impact = {
					13,
					20,
				},
			},
		},
		{
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = {
					35,
					70,
				},
				impact = {
					13,
					20,
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
					11,
					17,
				},
			},
		},
		default_target = {
			boost_curve_multiplier_finesse = 0.25,
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_5,
					[armor_types.resistant] = damage_lerp_values.lerp_0_5,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_5,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_1,
					[armor_types.disgustingly_resilient] = damage_lerp_values.no_damage,
					[armor_types.void_shield] = damage_lerp_values.no_damage,
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_5,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_5,
					[armor_types.super_armor] = damage_lerp_values.no_damage,
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
overrides.heavy_grenadier_gauntlet_tank = {
	parent_template_name = "light_grenadier_gauntlet_tank",
	overrides = {
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
			"melee_attack_strength",
			melee_attack_strengths.heavy,
		},
	},
}
damage_templates.light_grenadier_gauntlet_smiter = {
	dead_ragdoll_mod = 1.4,
	ignore_shield = false,
	ragdoll_only = true,
	ragdoll_push_force = 850,
	stagger_category = "melee",
	cleave_distribution = medium_cleave,
	gibbing_power = gibbing_power.always,
	gibbing_type = gibbing_types.crushing,
	melee_attack_strength = melee_attack_strengths.light,
	wounds_template = WoundsTemplates.gauntlet_melee,
	stagger_duration_modifier = {
		0.1,
		0.5,
	},
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1_25,
			[armor_types.armored] = damage_lerp_values.lerp_1_25,
			[armor_types.resistant] = damage_lerp_values.lerp_1_5,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_1,
			[armor_types.super_armor] = damage_lerp_values.lerp_0_2,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1_25,
			[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
		},
		impact = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_1,
			[armor_types.resistant] = damage_lerp_values.lerp_1,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_1,
			[armor_types.super_armor] = damage_lerp_values.lerp_1,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_75,
			[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
		},
	},
	targets = {
		{
			boost_curve_multiplier_finesse = 1,
			power_distribution = {
				attack = {
					100,
					200,
				},
				impact = {
					10,
					20,
				},
			},
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_1_25,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_1,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1_25,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_1,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_1,
					[armor_types.super_armor] = damage_lerp_values.lerp_1,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_75,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
				},
			},
		},
		{
			boost_curve_multiplier_finesse = 0.5,
			power_distribution = {
				attack = {
					60,
					80,
				},
				impact = {
					8,
					13,
				},
			},
		},
		default_target = {
			power_distribution = {
				attack = {
					60,
					80,
				},
				impact = {
					6,
					10,
				},
			},
		},
	},
}
overrides.heavy_grenadier_gauntlet_smiter = {
	parent_template_name = "light_grenadier_gauntlet_smiter",
	overrides = {
		{
			"targets",
			1,
			"power_distribution",
			"attack",
			{
				175,
				350,
			},
		},
		{
			"melee_attack_strength",
			melee_attack_strengths.heavy,
		},
		{
			"targets",
			1,
			"armor_damage_modifier",
			"attack",
			"super_armor",
			damage_lerp_values.lerp_0_75,
		},
	},
}
damage_templates.special_grenadier_gauntlet_tank = {
	ignore_stagger_reduction = true,
	ragdoll_only = true,
	ragdoll_push_force = 800,
	stagger_category = "killshot",
	stagger_override = "killshot",
	cleave_distribution = {
		attack = 0.01,
		impact = 0.01,
	},
	damage_type = damage_types.blunt,
	gibbing_type = gibbing_types.default,
	gibbing_power = gibbing_power.always,
	melee_attack_strength = melee_attack_strengths.heavy,
	targets = {
		{
			boost_curve_multiplier_finesse = 0.25,
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_1,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_5,
					[armor_types.super_armor] = damage_lerp_values.lerp_1,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1_5,
					[armor_types.void_shield] = damage_lerp_values.lerp_1_5,
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_1,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_5,
					[armor_types.super_armor] = damage_lerp_values.lerp_1,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1_5,
					[armor_types.void_shield] = damage_lerp_values.lerp_1_5,
				},
			},
			power_distribution = {
				attack = 50,
				impact = 50,
			},
		},
		{
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = 0,
				impact = 50,
			},
		},
		{
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = 0,
				impact = 25,
			},
		},
		{
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = 0,
				impact = 15,
			},
		},
		default_target = {
			boost_curve_multiplier_finesse = 0.25,
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
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_5,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_5,
					[armor_types.super_armor] = damage_lerp_values.no_damage,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_1,
				},
			},
			power_distribution = {
				attack = 0,
				impact = 1,
			},
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
}
damage_templates.special_grenadier_gauntlet_smiter = {
	ignore_stagger_reduction = true,
	ragdoll_only = true,
	ragdoll_push_force = 800,
	stagger_category = "killshot",
	stagger_override = "killshot",
	cleave_distribution = {
		attack = 0.01,
		impact = 0.01,
	},
	damage_type = damage_types.blunt,
	gibbing_type = gibbing_types.default,
	gibbing_power = gibbing_power.always,
	melee_attack_strength = melee_attack_strengths.heavy,
	targets = {
		{
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_9,
					[armor_types.resistant] = damage_lerp_values.lerp_1_25,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_9,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_75,
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
				impact = 50,
				attack = {
					150,
					300,
				},
			},
		},
		{
			power_distribution = {
				impact = 25,
				attack = {
					60,
					80,
				},
			},
		},
		{
			power_distribution = {
				impact = 15,
				attack = {
					40,
					60,
				},
			},
		},
		default_target = {
			boost_curve_multiplier_finesse = 0.25,
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_5,
					[armor_types.resistant] = damage_lerp_values.lerp_0_5,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_5,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_1,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_8,
					[armor_types.void_shield] = damage_lerp_values.no_damage,
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_5,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_5,
					[armor_types.super_armor] = damage_lerp_values.no_damage,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_1,
				},
			},
			power_distribution = {
				attack = 0,
				impact = 1,
			},
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
}
damage_templates.default_gauntlet_bfg = {
	ignore_shield = true,
	ignore_stagger_reduction = true,
	ragdoll_push_force = 750,
	stagger_category = "ranged",
	suppression_value = 4,
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
				[armor_types.resistant] = damage_lerp_values.lerp_0_75,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_1,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
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
		far = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_0_75,
				[armor_types.armored] = damage_lerp_values.lerp_0_5,
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
	},
	power_distribution = {
		attack = {
			300,
			600,
		},
		impact = {
			40,
			80,
		},
	},
	damage_type = damage_types.blunt,
	gibbing_type = gibbing_types.default,
	gibbing_power = gibbing_power.always,
	wounds_template = WoundsTemplates.bolter,
	on_kill_area_suppression = {
		distance = 8,
		suppression_value = 10,
	},
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default,
			finesse_boost = {
				[armor_types.unarmored] = 0.75,
			},
			boost_curve_multiplier_finesse = {
				0.2,
				0.4,
			},
		},
	},
	gib_push_force = GibbingSettings.gib_push_force.explosive,
}
damage_templates.default_gauntlet_bfg_ignore_hitzone = {
	ignore_shield = true,
	ignore_stagger_reduction = true,
	ragdoll_push_force = 750,
	stagger_category = "ranged",
	suppression_value = 4,
	ignore_hitzone_multipliers_breed_tags = {
		"horde",
		"roamer",
		"elite",
		"special",
	},
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
				[armor_types.resistant] = damage_lerp_values.lerp_0_75,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_1,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
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
		far = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_0_75,
				[armor_types.armored] = damage_lerp_values.lerp_0_5,
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
	},
	power_distribution = {
		attack = {
			300,
			600,
		},
		impact = {
			40,
			80,
		},
	},
	damage_type = damage_types.blunt,
	gibbing_type = gibbing_types.default,
	gibbing_power = gibbing_power.always,
	wounds_template = WoundsTemplates.bolter,
	on_kill_area_suppression = {
		distance = 8,
		suppression_value = 10,
	},
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default,
			finesse_boost = {
				[armor_types.unarmored] = 0.75,
			},
			boost_curve_multiplier_finesse = {
				0.2,
				0.4,
			},
		},
	},
	gib_push_force = GibbingSettings.gib_push_force.explosive,
}
damage_templates.default_gauntlet_demolitions = {
	count_as_ranged_attack = true,
	ignore_stagger_reduction = false,
	opt_in_stagger_duration_multiplier = true,
	ragdoll_push_force = 400,
	stagger_category = "melee",
	suppression_value = 20,
	cleave_distribution = {
		attack = 0.15,
		impact = 0.15,
	},
	armor_damage_modifier_ranged = {
		near = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_0_5,
				[armor_types.resistant] = damage_lerp_values.lerp_0_2,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_0_2,
				[armor_types.super_armor] = damage_lerp_values.no_damage,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_25,
				[armor_types.void_shield] = damage_lerp_values.no_damage,
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
		far = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_0_1,
				[armor_types.armored] = damage_lerp_values.lerp_0_1,
				[armor_types.resistant] = damage_lerp_values.lerp_0_1,
				[armor_types.player] = damage_lerp_values.lerp_0_1,
				[armor_types.berserker] = damage_lerp_values.lerp_0_1,
				[armor_types.super_armor] = damage_lerp_values.no_damage,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_1,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_1,
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_0_5,
				[armor_types.armored] = damage_lerp_values.lerp_0_5,
				[armor_types.resistant] = damage_lerp_values.lerp_0_5,
				[armor_types.player] = damage_lerp_values.lerp_0_5,
				[armor_types.berserker] = damage_lerp_values.lerp_0_5,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_5,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
			},
		},
	},
	power_distribution_ranged = {
		attack = {
			near = {
				50,
				100,
			},
			far = {
				10,
				20,
			},
		},
		impact = {
			near = {
				25,
				50,
			},
			far = {
				5,
				10,
			},
		},
	},
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
	damage_type = damage_types.grenade_frag,
	gibbing_type = gibbing_types.explosion,
	gibbing_power = gibbing_power.heavy,
	gib_push_force = GibbingSettings.gib_push_force.explosive,
}
damage_templates.close_gauntlet_demolitions = {
	count_as_ranged_attack = true,
	ignore_stagger_reduction = true,
	ragdoll_push_force = 600,
	stagger_category = "melee",
	suppression_value = 20,
	cleave_distribution = {
		attack = 0.15,
		impact = 0.15,
	},
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_1_25,
			[armor_types.resistant] = damage_lerp_values.lerp_0_3,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_1,
			[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
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
			250,
			450,
		},
		impact = {
			40,
			80,
		},
	},
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
	damage_type = damage_types.grenade_frag,
	gibbing_type = gibbing_types.explosion,
	gibbing_power = gibbing_power.heavy,
	wounds_template = WoundsTemplates.bolter,
	gib_push_force = GibbingSettings.gib_push_force.explosive,
	on_kill_area_suppression = {
		distance = 8,
		suppression_value = 10,
	},
}
damage_templates.close_special_gauntlet_demolitions = {
	count_as_ranged_attack = true,
	ignore_stagger_reduction = true,
	ragdoll_push_force = 600,
	stagger_category = "melee",
	suppression_value = 20,
	cleave_distribution = {
		attack = 0.15,
		impact = 0.15,
	},
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1_25,
			[armor_types.armored] = damage_lerp_values.lerp_1_25,
			[armor_types.resistant] = damage_lerp_values.lerp_1,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_1,
			[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
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
			600,
			1000,
		},
		impact = {
			30,
			60,
		},
	},
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
	damage_type = damage_types.grenade_frag,
	gibbing_type = gibbing_types.explosion,
	gibbing_power = gibbing_power.heavy,
	wounds_template = WoundsTemplates.bolter,
	gib_push_force = GibbingSettings.gib_push_force.explosive,
	on_kill_area_suppression = {
		distance = 8,
		suppression_value = 10,
	},
}

return {
	base_templates = damage_templates,
	overrides = overrides,
}
