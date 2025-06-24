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
local large_cleave = DamageProfileSettings.large_cleave
local light_cleave = DamageProfileSettings.light_cleave
local medium_cleave = DamageProfileSettings.medium_cleave
local single_cleave = DamageProfileSettings.single_cleave
local no_cleave = DamageProfileSettings.no_cleave
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
					115,
					210,
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
	cleave_distribution = medium_cleave,
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
					110,
					165,
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
					120,
					270,
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
				160,
				390,
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
			"cleave_distribution",
			light_cleave,
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
	armor_damage_modifier = {
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
			[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
			[armor_types.void_shield] = damage_lerp_values.lerp_1,
		},
	},
	targets = {
		{
			power_distribution = {
				attack = {
					90,
					165,
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
				30,
				80,
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
			50,
			65,
		},
	},
	damage_type = damage_types.electrocution,
	targets = {
		default_target = {},
	},
}
damage_templates.powermaul_p2_light_smiter = {
	ragdoll_only = true,
	ragdoll_push_force = 500,
	stagger_category = "melee",
	cleave_distribution = single_cleave,
	damage_type = damage_types.spiked_blunt,
	gibbing_power = gibbing_power.always,
	gibbing_type = gibbing_types.crushing,
	melee_attack_strength = melee_attack_strengths.light,
	wounds_template = WoundsTemplates.power_maul,
	stagger_duration_modifier = {
		0.1,
		2.5,
	},
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_1,
			[armor_types.resistant] = damage_lerp_values.lerp_0_9,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_0_9,
			[armor_types.super_armor] = damage_lerp_values.lerp_0_6,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
			[armor_types.void_shield] = damage_lerp_values.lerp_1_33,
		},
		impact = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_1,
			[armor_types.resistant] = damage_lerp_values.lerp_1,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_0_6,
			[armor_types.super_armor] = damage_lerp_values.lerp_1,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
			[armor_types.void_shield] = damage_lerp_values.lerp_1,
		},
	},
	targets = {
		{
			power_distribution = {
				attack = {
					170,
					295,
				},
				impact = {
					10,
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
					55,
					110,
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
			boost_curve_multiplier_finesse = {
				0.3,
				1,
			},
		},
	},
	gib_push_force = GibbingSettings.gib_push_force.blunt_heavy,
}
overrides.powermaul_p2_light_smiter_special = {
	parent_template_name = "powermaul_p2_light_smiter",
	overrides = {
		{
			"cleave_distribution",
			no_cleave,
		},
		{
			"targets",
			1,
			"power_distribution",
			"attack",
			{
				75,
				150,
			},
		},
		{
			"targets",
			1,
			"power_distribution",
			"impact",
			{
				10,
				24,
			},
		},
		{
			"targets",
			2,
			"power_distribution",
			"attack",
			{
				40,
				80,
			},
		},
		{
			"targets",
			2,
			"power_distribution",
			"impact",
			{
				8,
				14,
			},
		},
	},
}
damage_templates.powermaul_p2_light_linesman = {
	ragdoll_only = true,
	ragdoll_push_force = 400,
	stagger_category = "melee",
	cleave_distribution = light_cleave,
	damage_type = damage_types.spiked_blunt,
	gibbing_power = gibbing_power.always,
	gibbing_type = gibbing_types.crushing,
	melee_attack_strength = melee_attack_strengths.light,
	wounds_template = WoundsTemplates.power_maul,
	stagger_duration_modifier = {
		0.1,
		0.5,
	},
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_0_9,
			[armor_types.resistant] = damage_lerp_values.lerp_0_8,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_0_75,
			[armor_types.super_armor] = damage_lerp_values.lerp_0_3,
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
	},
	targets = {
		{
			power_distribution = {
				attack = {
					145,
					230,
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
					90,
					155,
				},
				impact = {
					4,
					8,
				},
			},
			boost_curve_multiplier_finesse = {
				0.3,
				1,
			},
		},
		{
			power_distribution = {
				attack = {
					65,
					110,
				},
				impact = {
					3,
					6,
				},
			},
			boost_curve_multiplier_finesse = {
				0.3,
				1,
			},
		},
		{
			power_distribution = {
				attack = {
					45,
					80,
				},
				impact = {
					3,
					6,
				},
			},
			boost_curve_multiplier_finesse = {
				0.3,
				1,
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
		},
	},
	gib_push_force = GibbingSettings.gib_push_force.blunt_heavy,
}
overrides.powermaul_p2_light_linesman_special = {
	parent_template_name = "powermaul_p2_light_linesman",
	overrides = {
		{
			"targets",
			1,
			"power_distribution",
			"attack",
			{
				60,
				120,
			},
		},
		{
			"targets",
			1,
			"power_distribution",
			"impact",
			{
				7,
				16,
			},
		},
		{
			"targets",
			2,
			"power_distribution",
			"attack",
			{
				40,
				85,
			},
		},
		{
			"targets",
			2,
			"power_distribution",
			"impact",
			{
				5,
				10,
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
			3,
			"power_distribution",
			"impact",
			{
				4,
				8,
			},
		},
		{
			"targets",
			4,
			"power_distribution",
			"attack",
			{
				20,
				40,
			},
		},
		{
			"targets",
			4,
			"power_distribution",
			"impact",
			{
				4,
				8,
			},
		},
		{
			"cleave_distribution",
			single_cleave,
		},
	},
}
damage_templates.powermaul_p2_light_tank = {
	ragdoll_only = true,
	ragdoll_push_force = 200,
	stagger_category = "melee",
	cleave_distribution = big_cleave,
	damage_type = damage_types.spiked_blunt,
	gibbing_power = gibbing_power.always,
	gibbing_type = gibbing_types.crushing,
	melee_attack_strength = melee_attack_strengths.light,
	wounds_template = WoundsTemplates.power_maul,
	stagger_duration_modifier = {
		0.1,
		0.5,
	},
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_0_9,
			[armor_types.resistant] = damage_lerp_values.lerp_0_8,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_0_8,
			[armor_types.super_armor] = damage_lerp_values.lerp_0_4,
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
	},
	targets = {
		{
			power_distribution = {
				attack = {
					110,
					190,
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
					65,
					120,
				},
				impact = {
					6,
					12,
				},
			},
			boost_curve_multiplier_finesse = {
				0.3,
				1,
			},
		},
		{
			power_distribution = {
				attack = {
					45,
					90,
				},
				impact = {
					5,
					11,
				},
			},
			boost_curve_multiplier_finesse = {
				0.3,
				1,
			},
		},
		{
			power_distribution = {
				attack = {
					30,
					65,
				},
				impact = {
					3,
					10,
				},
			},
			boost_curve_multiplier_finesse = {
				0.3,
				1,
			},
		},
		default_target = {
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
				0.3,
				1,
			},
		},
	},
	gib_push_force = GibbingSettings.gib_push_force.blunt_heavy,
}
overrides.powermaul_p2_light_tank_pushfollow = {
	parent_template_name = "powermaul_p2_light_tank",
	overrides = {
		{
			"targets",
			1,
			"power_distribution",
			"impact",
			{
				10,
				20,
			},
		},
		{
			"targets",
			2,
			"power_distribution",
			"impact",
			{
				8,
				16,
			},
		},
	},
}
overrides.powermaul_p2_light_tank_special = {
	parent_template_name = "powermaul_p2_light_tank",
	overrides = {
		{
			"targets",
			1,
			"power_distribution",
			"attack",
			{
				50,
				100,
			},
		},
		{
			"targets",
			1,
			"power_distribution",
			"impact",
			{
				10,
				20,
			},
		},
		{
			"targets",
			2,
			"power_distribution",
			"attack",
			{
				35,
				70,
			},
		},
		{
			"targets",
			2,
			"power_distribution",
			"impact",
			{
				8,
				16,
			},
		},
		{
			"targets",
			3,
			"power_distribution",
			"attack",
			{
				25,
				50,
			},
		},
		{
			"targets",
			3,
			"power_distribution",
			"impact",
			{
				7,
				14,
			},
		},
		{
			"targets",
			4,
			"power_distribution",
			"attack",
			{
				15,
				35,
			},
		},
		{
			"targets",
			4,
			"power_distribution",
			"impact",
			{
				6,
				12,
			},
		},
		{
			"cleave_distribution",
			single_cleave,
		},
	},
}
damage_templates.powermaul_p2_heavy_tank = {
	ignore_stagger_reduction = true,
	ragdoll_only = true,
	ragdoll_push_force = 300,
	stagger_category = "melee",
	cleave_distribution = big_cleave,
	damage_type = damage_types.spiked_blunt,
	gibbing_power = gibbing_power.always,
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
					150,
					300,
				},
				impact = {
					14,
					28,
				},
			},
			boost_curve_multiplier_finesse = {
				0.4,
				1.4,
			},
		},
		{
			power_distribution = {
				attack = {
					100,
					200,
				},
				impact = {
					10,
					22,
				},
			},
			boost_curve_multiplier_finesse = {
				0.3,
				1.3,
			},
		},
		{
			power_distribution = {
				attack = {
					65,
					130,
				},
				impact = {
					9,
					18,
				},
			},
			boost_curve_multiplier_finesse = {
				0.2,
				1.2,
			},
		},
		{
			power_distribution = {
				attack = {
					35,
					60,
				},
				impact = {
					7,
					15,
				},
			},
			boost_curve_multiplier_finesse = {
				0.3,
				1,
			},
		},
		{
			power_distribution = {
				attack = {
					30,
					50,
				},
				impact = {
					5,
					12,
				},
			},
			boost_curve_multiplier_finesse = {
				0.3,
				1,
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
					10,
				},
			},
			boost_curve = PowerLevelSettings.boost_curves.default,
			boost_curve_multiplier_finesse = {
				0.3,
				1,
			},
		},
	},
	gib_push_force = GibbingSettings.gib_push_force.blunt_heavy,
}
overrides.powermaul_p2_heavy_tank_special = {
	parent_template_name = "powermaul_p2_heavy_tank",
	overrides = {
		{
			"targets",
			1,
			"power_distribution",
			"attack",
			{
				90,
				200,
			},
		},
		{
			"targets",
			1,
			"power_distribution",
			"impact",
			{
				15,
				30,
			},
		},
		{
			"targets",
			2,
			"power_distribution",
			"attack",
			{
				65,
				130,
			},
		},
		{
			"targets",
			2,
			"power_distribution",
			"impact",
			{
				10,
				25,
			},
		},
		{
			"targets",
			3,
			"power_distribution",
			"attack",
			{
				40,
				80,
			},
		},
		{
			"targets",
			3,
			"power_distribution",
			"impact",
			{
				9,
				20,
			},
		},
		{
			"targets",
			4,
			"power_distribution",
			"attack",
			{
				20,
				40,
			},
		},
		{
			"targets",
			4,
			"power_distribution",
			"impact",
			{
				7,
				16,
			},
		},
		{
			"targets",
			5,
			"power_distribution",
			"attack",
			{
				20,
				40,
			},
		},
		{
			"targets",
			5,
			"power_distribution",
			"impact",
			{
				6,
				14,
			},
		},
		{
			"cleave_distribution",
			light_cleave,
		},
	},
}
damage_templates.powermaul_p2_heavy_smiter = {
	ragdoll_push_force = 300,
	stagger_category = "melee",
	cleave_distribution = light_cleave,
	damage_type = damage_types.spiked_blunt,
	gibbing_power = gibbing_power.always,
	gibbing_type = gibbing_types.crushing,
	melee_attack_strength = melee_attack_strengths.heavy,
	wounds_template = WoundsTemplates.power_maul,
	stagger_duration_modifier = {
		0.1,
		0.5,
	},
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_1,
			[armor_types.resistant] = damage_lerp_values.lerp_0_9,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_0_9,
			[armor_types.super_armor] = damage_lerp_values.lerp_0_75,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
			[armor_types.void_shield] = damage_lerp_values.lerp_1_33,
		},
		impact = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_1,
			[armor_types.resistant] = damage_lerp_values.lerp_1,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_0_8,
			[armor_types.super_armor] = damage_lerp_values.lerp_1,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
			[armor_types.void_shield] = damage_lerp_values.lerp_1,
		},
	},
	targets = {
		{
			power_distribution = {
				attack = {
					200,
					430,
				},
				impact = {
					12,
					26,
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
					100,
					220,
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
					55,
					110,
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
		default_target = {
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
overrides.powermaul_p2_heavy_smiter_special = {
	parent_template_name = "powermaul_p2_heavy_smiter",
	overrides = {
		{
			"cleave_distribution",
			no_cleave,
		},
		{
			"targets",
			1,
			"power_distribution",
			"attack",
			{
				120,
				290,
			},
		},
		{
			"targets",
			1,
			"power_distribution",
			"impact",
			{
				15,
				30,
			},
		},
		{
			"targets",
			2,
			"power_distribution",
			"attack",
			{
				75,
				150,
			},
		},
		{
			"targets",
			2,
			"power_distribution",
			"impact",
			{
				10,
				24,
			},
		},
		{
			"targets",
			3,
			"power_distribution",
			"attack",
			{
				40,
				80,
			},
		},
		{
			"targets",
			3,
			"power_distribution",
			"impact",
			{
				8,
				18,
			},
		},
	},
}
damage_templates.powermaul_p2_stun_interval = {
	ignore_shield = true,
	stagger_category = "sticky",
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = damage_lerp_values.lerp_0_8,
			[armor_types.armored] = damage_lerp_values.lerp_1_25,
			[armor_types.resistant] = damage_lerp_values.lerp_0_8,
			[armor_types.player] = damage_lerp_values.lerp_0_75,
			[armor_types.berserker] = damage_lerp_values.lerp_0_8,
			[armor_types.super_armor] = damage_lerp_values.lerp_1_25,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_75,
			[armor_types.void_shield] = damage_lerp_values.lerp_0_1,
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
		attack = 75,
		impact = 100,
	},
	damage_type = damage_types.electrocution,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
}
damage_templates.powermaul_p2_stun_interval_basic = {
	ignore_shield = true,
	stagger_category = "sticky",
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = damage_lerp_values.lerp_0_8,
			[armor_types.armored] = damage_lerp_values.lerp_1_25,
			[armor_types.resistant] = damage_lerp_values.lerp_0_8,
			[armor_types.player] = damage_lerp_values.lerp_0_75,
			[armor_types.berserker] = damage_lerp_values.lerp_0_8,
			[armor_types.super_armor] = damage_lerp_values.lerp_1_25,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_75,
			[armor_types.void_shield] = damage_lerp_values.lerp_0_1,
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
		attack = 40,
		impact = 65,
	},
	damage_type = damage_types.electrocution,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
}

return {
	base_templates = damage_templates,
	overrides = overrides,
}
