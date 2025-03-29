-- chunkname: @scripts/settings/equipment/weapon_templates/power_mauls/settings_templates/power_maul_damage_profile_templates.lua

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
local double_cleave = DamageProfileSettings.double_cleave
local light_cleave = DamageProfileSettings.light_cleave
local single_cleave = DamageProfileSettings.single_cleave
local damage_templates = {}
local overrides = {}

table.make_unique(damage_templates)
table.make_unique(overrides)

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

damage_templates.powermaul_light_smiter = {
	ragdoll_only = true,
	ragdoll_push_force = 500,
	stagger_category = "melee",
	cleave_distribution = single_cleave,
	damage_type = damage_types.spiked_blunt,
	gibbing_power = gibbing_power.light,
	gibbing_type = gibbing_types.crushing,
	melee_attack_strength = melee_attack_strengths.light,
	wounds_template = WoundsTemplates.power_maul,
	stagger_duration_modifier = {
		0.1,
		2.5,
	},
	armor_damage_modifier = smiter_light_default_am,
	targets = {
		{
			power_distribution = {
				attack = {
					100,
					200,
				},
				impact = {
					5,
					20,
				},
			},
			boost_curve_multiplier_finesse = {
				0.5,
				1.5,
			},
		},
		{
			power_distribution = {
				attack = {
					30,
					50,
				},
				impact = {
					7,
					10,
				},
			},
			boost_curve_multiplier_finesse = {
				0.5,
				1.5,
			},
		},
		default_target = {
			power_distribution = {
				impact = 5,
				attack = {
					20,
					40,
				},
			},
		},
	},
	gib_push_force = GibbingSettings.gib_push_force.blunt_heavy,
}
damage_templates.powermaul_light_linesman = {
	ragdoll_only = true,
	ragdoll_push_force = 400,
	stagger_category = "melee",
	cleave_distribution = light_cleave,
	damage_type = damage_types.spiked_blunt,
	gibbing_power = gibbing_power.light,
	gibbing_type = gibbing_types.crushing,
	melee_attack_strength = melee_attack_strengths.light,
	wounds_template = WoundsTemplates.power_maul,
	stagger_duration_modifier = {
		0.1,
		0.5,
	},
	armor_damage_modifier = linesman_light_default_am,
	targets = {
		{
			power_distribution = {
				attack = {
					100,
					150,
				},
				impact = {
					5,
					11,
				},
			},
			boost_curve_multiplier_finesse = {
				0.5,
				1.5,
			},
		},
		{
			power_distribution = {
				attack = {
					90,
					135,
				},
				impact = {
					4,
					8,
				},
			},
			boost_curve_multiplier_finesse = {
				0.5,
				1.5,
			},
		},
		{
			power_distribution = {
				attack = {
					60,
					100,
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
		default_target = {
			power_distribution = {
				attack = {
					20,
					40,
				},
				impact = {
					3,
					6,
				},
			},
			boost_curve = PowerLevelSettings.boost_curves.default,
			boost_curve_multiplier_finesse = {
				0.5,
				1.5,
			},
		},
	},
	gib_push_force = GibbingSettings.gib_push_force.blunt_heavy,
}
damage_templates.powermaul_heavy_tank = {
	ragdoll_only = true,
	ragdoll_push_force = 300,
	stagger_category = "melee",
	cleave_distribution = big_cleave,
	damage_type = damage_types.spiked_blunt,
	gibbing_power = gibbing_power.medium,
	gibbing_type = gibbing_types.crushing,
	melee_attack_strength = melee_attack_strengths.heavy,
	wounds_template = WoundsTemplates.power_maul,
	stagger_duration_modifier = {
		0.1,
		0.5,
	},
	armor_damage_modifier = tank_heavy_default_am,
	targets = {
		{
			power_distribution = {
				attack = {
					110,
					260,
				},
				impact = {
					9,
					22,
				},
			},
			boost_curve_multiplier_finesse = {
				0.5,
				1.5,
			},
		},
		{
			power_distribution = {
				attack = {
					90,
					200,
				},
				impact = {
					8,
					20,
				},
			},
			boost_curve_multiplier_finesse = {
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
					4,
					15,
				},
			},
			boost_curve_multiplier_finesse = {
				0.5,
				1.5,
			},
		},
		{
			power_distribution = {
				attack = {
					30,
					50,
				},
				impact = {
					3,
					12,
				},
			},
			boost_curve_multiplier_finesse = {
				0.5,
				1.5,
			},
		},
		default_target = {
			armor_damage_modifier = tank_heavy_default_am,
			power_distribution = {
				attack = {
					20,
					40,
				},
				impact = {
					3,
					10,
				},
			},
			boost_curve = PowerLevelSettings.boost_curves.default,
			boost_curve_multiplier_finesse = {
				0.5,
				1.5,
			},
		},
	},
	gib_push_force = GibbingSettings.gib_push_force.blunt_heavy,
}
overrides.powermaul_heavy_smite = {
	parent_template_name = "powermaul_heavy_tank",
	overrides = {
		{
			"targets",
			1,
			"power_distribution",
			"attack",
			{
				140,
				350,
			},
		},
		{
			"targets",
			1,
			"power_distribution",
			"impact",
			{
				10,
				25,
			},
		},
		{
			"targets",
			2,
			"power_distribution",
			"attack",
			{
				60,
				220,
			},
		},
		{
			"targets",
			3,
			"power_distribution",
			"attack",
			{
				30,
				60,
			},
		},
		{
			"targets",
			4,
			"power_distribution",
			"attack",
			{
				0,
				0,
			},
		},
	},
}
damage_templates.powermaul_light_tank = {
	ragdoll_only = true,
	ragdoll_push_force = 200,
	stagger_category = "melee",
	cleave_distribution = big_cleave,
	damage_type = damage_types.spiked_blunt,
	gibbing_power = gibbing_power.light,
	gibbing_type = gibbing_types.crushing,
	melee_attack_strength = melee_attack_strengths.light,
	wounds_template = WoundsTemplates.power_maul,
	stagger_duration_modifier = {
		0.1,
		0.5,
	},
	armor_damage_modifier = tank_heavy_default_am,
	targets = {
		{
			power_distribution = {
				attack = {
					80,
					150,
				},
				impact = {
					7,
					15,
				},
			},
			boost_curve_multiplier_finesse = {
				0.5,
				1.5,
			},
		},
		{
			power_distribution = {
				attack = {
					60,
					110,
				},
				impact = {
					6,
					12,
				},
			},
			boost_curve_multiplier_finesse = {
				0.5,
				1.5,
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
					11,
				},
			},
			boost_curve_multiplier_finesse = {
				0.5,
				1.5,
			},
		},
		{
			power_distribution = {
				attack = {
					25,
					60,
				},
				impact = {
					3,
					10,
				},
			},
			boost_curve_multiplier_finesse = {
				0.5,
				1.5,
			},
		},
		default_target = {
			armor_damage_modifier = tank_heavy_default_am,
			power_distribution = {
				attack = {
					10,
					30,
				},
				impact = {
					3,
					10,
				},
			},
			boost_curve = PowerLevelSettings.boost_curves.default,
			boost_curve_multiplier_finesse = {
				0.5,
				1.5,
			},
		},
	},
	gib_push_force = GibbingSettings.gib_push_force.blunt_heavy,
}
overrides.powermaul_weapon_special = {
	parent_template_name = "powermaul_light_smiter",
	overrides = {
		{
			"stagger_category",
			"sticky",
		},
		{
			"stagger_override",
			"sticky",
		},
		{
			"shield_stagger_category",
			"melee",
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
			false,
		},
		{
			"ignore_shield",
			true,
		},
		{
			"gibbing_power",
			gibbing_power.always,
		},
		{
			"sticky_attack",
			true,
		},
		{
			"gibbing_type",
			gibbing_types.default,
		},
		{
			"wounds_template",
			WoundsTemplates.power_maul,
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
				10,
				70,
			},
		},
		{
			"targets",
			1,
			"power_distribution",
			"impact",
			{
				4,
				8,
			},
		},
		{
			"targets",
			1,
			"boost_curve_multiplier_finesse",
			0.05,
		},
		{
			"targets",
			2,
			"boost_curve_multiplier_finesse",
			0.05,
		},
		{
			"weapon_special",
			true,
		},
		{
			"skip_on_hit_proc",
			true,
		},
		{
			"stagger_duration_modifier",
			{
				2,
				5,
			},
		},
		{
			"ragdoll_push_force",
			50,
		},
	},
}
damage_templates.shockmaul_stun_interval_damage = {
	ignore_shield = true,
	ragdoll_push_force = 50,
	stagger_category = "sticky",
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = damage_lerp_values.lerp_0_5,
			[armor_types.armored] = damage_lerp_values.lerp_1,
			[armor_types.resistant] = damage_lerp_values.lerp_1,
			[armor_types.player] = damage_lerp_values.lerp_0_75,
			[armor_types.berserker] = damage_lerp_values.lerp_1,
			[armor_types.super_armor] = damage_lerp_values.lerp_0_8,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_5,
			[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
		},
		impact = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_2,
			[armor_types.resistant] = damage_lerp_values.lerp_1,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_1,
			[armor_types.super_armor] = damage_lerp_values.lerp_1_5,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
			[armor_types.void_shield] = damage_lerp_values.lerp_1,
		},
	},
	cleave_distribution = {
		attack = 5,
		impact = 20,
	},
	power_distribution = {
		impact = 100,
		attack = {
			40,
			50,
		},
	},
	damage_type = damage_types.electrocution,
	targets = {
		default_target = {},
	},
}

return {
	base_templates = damage_templates,
	overrides = overrides,
}
