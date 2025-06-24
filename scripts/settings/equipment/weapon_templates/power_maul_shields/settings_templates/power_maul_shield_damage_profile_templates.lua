-- chunkname: @scripts/settings/equipment/weapon_templates/power_maul_shields/settings_templates/power_maul_shield_damage_profile_templates.lua

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

local linesman_light_default_am = {
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
}
local tank_heavy_default_am = {
	attack = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1,
		[armor_types.armored] = damage_lerp_values.lerp_0_9,
		[armor_types.resistant] = damage_lerp_values.lerp_0_8,
		[armor_types.player] = damage_lerp_values.lerp_1,
		[armor_types.berserker] = damage_lerp_values.lerp_0_8,
		[armor_types.super_armor] = damage_lerp_values.lerp_0_6,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
		[armor_types.void_shield] = damage_lerp_values.lerp_1_33,
	},
	impact = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1,
		[armor_types.armored] = damage_lerp_values.lerp_1,
		[armor_types.resistant] = damage_lerp_values.lerp_1,
		[armor_types.player] = damage_lerp_values.lerp_1,
		[armor_types.berserker] = damage_lerp_values.lerp_0_7,
		[armor_types.super_armor] = damage_lerp_values.lerp_1,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
		[armor_types.void_shield] = damage_lerp_values.lerp_1,
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
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
		[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
	},
}
local smiter_heavy_default_am = {
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
}

damage_templates.powermaul_shield_light_linesman = {
	ragdoll_only = true,
	ragdoll_push_force = 400,
	stagger_category = "melee",
	cleave_distribution = light_cleave,
	damage_type = damage_types.blunt,
	gibbing_power = gibbing_power.always,
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
					135,
					215,
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
damage_templates.powermaul_shield_light_tank = {
	ragdoll_only = true,
	ragdoll_push_force = 200,
	stagger_category = "melee",
	cleave_distribution = big_cleave,
	damage_type = damage_types.blunt,
	gibbing_power = gibbing_power.always,
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
				0.3,
				1,
			},
		},
	},
	gib_push_force = GibbingSettings.gib_push_force.blunt_heavy,
}
damage_templates.powermaul_shield_heavy_tank = {
	ragdoll_only = true,
	ragdoll_push_force = 300,
	stagger_category = "melee",
	cleave_distribution = big_cleave,
	damage_type = damage_types.blunt,
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
					120,
					295,
				},
				impact = {
					11,
					22,
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
					8,
					20,
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
					130,
				},
				impact = {
					6,
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
					35,
					60,
				},
				impact = {
					4,
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
					30,
					50,
				},
				impact = {
					3,
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
damage_templates.powermaul_shield_heavy_tank_shield = {
	ignore_stagger_reduction = true,
	ragdoll_only = true,
	ragdoll_push_force = 300,
	stagger_category = "melee",
	cleave_distribution = big_cleave,
	damage_type = damage_types.blunt_heavy,
	gibbing_power = gibbing_power.always,
	gibbing_type = gibbing_types.crushing,
	melee_attack_strength = melee_attack_strengths.heavy,
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
					315,
				},
				impact = {
					15,
					30,
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
					110,
					220,
				},
				impact = {
					9,
					24,
				},
			},
		},
		{
			power_distribution = {
				attack = {
					70,
					140,
				},
				impact = {
					7,
					19,
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
					15,
				},
			},
		},
		{
			power_distribution = {
				attack = {
					30,
					50,
				},
				impact = {
					4,
					12,
				},
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
					10,
				},
			},
		},
		default_target = {
			armor_damage_modifier = tank_heavy_default_am,
			power_distribution = {
				attack = {
					20,
					50,
				},
				impact = {
					3,
					10,
				},
			},
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
	gib_push_force = GibbingSettings.gib_push_force.blunt_heavy,
}
damage_templates.powermaul_shield_light_smiter = {
	ragdoll_only = true,
	ragdoll_push_force = 500,
	stagger_category = "melee",
	cleave_distribution = single_cleave,
	damage_type = damage_types.blunt,
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
					160,
					285,
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
damage_templates.powermaul_shield_light_smiter_shield = {
	ignore_stagger_reduction = true,
	ragdoll_only = true,
	ragdoll_push_force = 500,
	stagger_category = "melee",
	cleave_distribution = double_cleave,
	damage_type = damage_types.blunt_heavy,
	gibbing_power = gibbing_power.always,
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
					160,
					285,
				},
				impact = {
					10,
					25,
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
					55,
					110,
				},
				impact = {
					8,
					15,
				},
			},
		},
		{
			power_distribution = {
				attack = {
					30,
					60,
				},
				impact = {
					7,
					10,
				},
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
damage_templates.powermaul_shield_heavy_smiter = {
	ragdoll_only = true,
	ragdoll_push_force = 300,
	stagger_category = "melee",
	cleave_distribution = light_cleave,
	damage_type = damage_types.blunt,
	gibbing_power = gibbing_power.always,
	gibbing_type = gibbing_types.crushing,
	melee_attack_strength = melee_attack_strengths.heavy,
	wounds_template = WoundsTemplates.power_maul,
	stagger_duration_modifier = {
		0.1,
		0.5,
	},
	armor_damage_modifier = smiter_heavy_default_am,
	targets = {
		{
			power_distribution = {
				attack = {
					180,
					400,
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
					50,
					100,
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
damage_templates.powermaul_shield_heavy_smiter_shield = {
	ignore_stagger_reduction = true,
	ragdoll_only = true,
	ragdoll_push_force = 300,
	stagger_category = "melee",
	cleave_distribution = light_cleave,
	damage_type = damage_types.blunt,
	gibbing_power = gibbing_power.always,
	gibbing_type = gibbing_types.crushing,
	melee_attack_strength = melee_attack_strengths.heavy,
	wounds_template = WoundsTemplates.power_maul,
	stagger_duration_modifier = {
		0.1,
		0.5,
	},
	armor_damage_modifier = smiter_heavy_default_am,
	targets = {
		{
			power_distribution = {
				attack = {
					180,
					400,
				},
				impact = {
					20,
					35,
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
					100,
					200,
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
					60,
					120,
				},
				impact = {
					6,
					16,
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
					14,
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
					4,
					12,
				},
			},
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
	gib_push_force = GibbingSettings.gib_push_force.blunt_heavy,
}
overrides.powermaul_shield_weapon_special = {
	parent_template_name = "powermaul_shield_light_smiter",
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
damage_templates.shockmaul_shield_stun_interval_damage = {
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
damage_templates.powermaul_shield_block_special = {
	ignore_stagger_reduction = true,
	stagger_category = "flamer",
	suppression_value = 200,
	ranges = {
		max = 15,
		min = 7.5,
	},
	armor_damage_modifier_ranged = {
		near = {
			attack = {
				[armor_types.unarmored] = 0,
				[armor_types.armored] = 0,
				[armor_types.resistant] = 0,
				[armor_types.player] = 0,
				[armor_types.berserker] = 0,
				[armor_types.super_armor] = 0,
				[armor_types.disgustingly_resilient] = 0,
				[armor_types.void_shield] = 0,
			},
			impact = {
				[armor_types.unarmored] = 2,
				[armor_types.armored] = 3,
				[armor_types.resistant] = 3,
				[armor_types.player] = 2,
				[armor_types.berserker] = 2,
				[armor_types.super_armor] = 4,
				[armor_types.disgustingly_resilient] = 2,
				[armor_types.void_shield] = 0,
			},
		},
		far = {
			attack = {
				[armor_types.unarmored] = 0,
				[armor_types.armored] = 0,
				[armor_types.resistant] = 0,
				[armor_types.player] = 0,
				[armor_types.berserker] = 0,
				[armor_types.super_armor] = 0,
				[armor_types.disgustingly_resilient] = 0,
				[armor_types.void_shield] = 0,
			},
			impact = {
				[armor_types.unarmored] = 1,
				[armor_types.armored] = 1,
				[armor_types.resistant] = 1.5,
				[armor_types.player] = 0,
				[armor_types.berserker] = 1,
				[armor_types.super_armor] = 1.5,
				[armor_types.disgustingly_resilient] = 1,
				[armor_types.void_shield] = 0,
			},
		},
	},
	power_distribution_ranged = {
		attack = {
			far = 1,
			near = 1,
		},
		impact = {
			far = 1,
			near = 20,
		},
	},
	targets = {
		default_target = {},
	},
}

return {
	base_templates = damage_templates,
	overrides = overrides,
}
