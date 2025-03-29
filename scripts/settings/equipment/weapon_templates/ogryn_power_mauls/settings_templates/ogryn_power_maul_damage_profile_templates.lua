-- chunkname: @scripts/settings/equipment/weapon_templates/ogryn_power_mauls/settings_templates/ogryn_power_maul_damage_profile_templates.lua

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
local single_cleave = DamageProfileSettings.single_cleave
local damage_templates = {}
local overrides = {}

table.make_unique(damage_templates)
table.make_unique(overrides)

local smiter_light_default_am = {
	attack = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1,
		[armor_types.armored] = damage_lerp_values.lerp_0_9,
		[armor_types.resistant] = damage_lerp_values.lerp_0_75,
		[armor_types.player] = damage_lerp_values.lerp_1,
		[armor_types.berserker] = damage_lerp_values.lerp_0_75,
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
		[armor_types.berserker] = damage_lerp_values.lerp_0_7,
		[armor_types.super_armor] = damage_lerp_values.lerp_0_65,
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
local light_active_am = {
	attack = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1,
		[armor_types.armored] = damage_lerp_values.lerp_1,
		[armor_types.resistant] = damage_lerp_values.lerp_1_5,
		[armor_types.player] = damage_lerp_values.no_damage,
		[armor_types.berserker] = damage_lerp_values.lerp_1,
		[armor_types.super_armor] = damage_lerp_values.lerp_1,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
		[armor_types.void_shield] = damage_lerp_values.lerp_1,
	},
	impact = {
		[armor_types.unarmored] = damage_lerp_values.lerp_2,
		[armor_types.armored] = damage_lerp_values.lerp_2,
		[armor_types.resistant] = damage_lerp_values.lerp_1,
		[armor_types.player] = damage_lerp_values.no_damage,
		[armor_types.berserker] = damage_lerp_values.lerp_1,
		[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_2,
		[armor_types.void_shield] = damage_lerp_values.lerp_2,
	},
}
local tank_heavy_active_am = {
	attack = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1,
		[armor_types.armored] = damage_lerp_values.lerp_1,
		[armor_types.resistant] = damage_lerp_values.lerp_1_5,
		[armor_types.player] = damage_lerp_values.no_damage,
		[armor_types.berserker] = damage_lerp_values.lerp_1,
		[armor_types.super_armor] = damage_lerp_values.lerp_1,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
		[armor_types.void_shield] = damage_lerp_values.lerp_1,
	},
	impact = {
		[armor_types.unarmored] = damage_lerp_values.lerp_2,
		[armor_types.armored] = damage_lerp_values.lerp_2,
		[armor_types.resistant] = damage_lerp_values.lerp_1,
		[armor_types.player] = damage_lerp_values.no_damage,
		[armor_types.berserker] = damage_lerp_values.lerp_1,
		[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_2,
		[armor_types.void_shield] = damage_lerp_values.lerp_2,
	},
}

damage_templates.ogryn_powermaul_light_smiter = {
	ignore_shield = false,
	ragdoll_only = true,
	ragdoll_push_force = 800,
	stagger_category = "melee",
	cleave_distribution = single_cleave,
	gibbing_power = gibbing_power.always,
	gibbing_type = gibbing_types.crushing,
	melee_attack_strength = melee_attack_strengths.light,
	wounds_template = WoundsTemplates.ogryn_power_maul,
	stagger_duration_modifier = {
		0.1,
		2.5,
	},
	armor_damage_modifier = smiter_light_default_am,
	targets = {
		{
			boost_curve_multiplier_finesse = 1,
			power_distribution = {
				attack = {
					110,
					220,
				},
				impact = {
					10,
					20,
				},
			},
			armor_damage_modifier = smiter_light_default_am,
			finesse_boost = {
				[armor_types.unarmored] = 0.5,
				[armor_types.armored] = 0.5,
				[armor_types.resistant] = 0.5,
				[armor_types.player] = 0.5,
				[armor_types.berserker] = 0.5,
				[armor_types.super_armor] = 0.5,
				[armor_types.disgustingly_resilient] = 0.5,
				[armor_types.void_shield] = 0.5,
			},
		},
		{
			boost_curve_multiplier_finesse = 1,
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
				impact = 12,
				attack = {
					20,
					40,
				},
			},
		},
	},
}
overrides.ogryn_powermaul_shield_light_smiter = {
	parent_template_name = "ogryn_powermaul_light_smiter",
	overrides = {
		{
			"armor_damage_modifier",
			light_active_am,
		},
		{
			"targets",
			1,
			"power_distribution",
			"attack",
			{
				150,
				300,
			},
		},
		{
			"targets",
			1,
			"boost_curve_multiplier_finesse",
			1,
		},
	},
}
overrides.ogryn_powermaul_light_smiter_active = {
	parent_template_name = "ogryn_powermaul_light_smiter",
	overrides = {
		{
			"ignore_shield",
			true,
		},
		{
			"cleave_distribution",
			"impact",
			0.01,
		},
		{
			"stagger_duration_modifier",
			{
				0.1,
				0.2,
			},
		},
		{
			"armor_damage_modifier",
			light_active_am,
		},
		{
			"targets",
			1,
			"power_distribution",
			"attack",
			{
				220,
				440,
			},
		},
		{
			"targets",
			1,
			"power_distribution",
			"impact",
			{
				40,
				80,
			},
		},
		{
			"targets",
			1,
			"armor_damage_modifier",
			light_active_am,
		},
		{
			"gibbing_power",
			gibbing_power.always,
		},
		{
			"gibbing_type",
			gibbing_types.crushing,
		},
		{
			"wounds_template",
			WoundsTemplates.ogryn_power_maul_activated,
		},
		{
			"cleave_distribution",
			"attack",
			math.huge,
		},
		{
			"cleave_distribution",
			"impact",
			math.huge,
		},
		{
			"shield_override_stagger_strength",
			200,
		},
		{
			"weapon_special",
			true,
		},
	},
}
damage_templates.ogryn_powermaul_light_linesman = {
	ragdoll_only = true,
	ragdoll_push_force = 800,
	stagger_category = "melee",
	cleave_distribution = big_cleave,
	damage_type = damage_types.ogryn_pipe_club,
	gibbing_power = gibbing_power.always,
	gibbing_type = gibbing_types.crushing,
	melee_attack_strength = melee_attack_strengths.light,
	wounds_template = WoundsTemplates.ogryn_power_maul,
	stagger_duration_modifier = {
		0.1,
		0.5,
	},
	armor_damage_modifier = linesman_light_default_am,
	targets = {
		{
			power_distribution = {
				attack = {
					80,
					150,
				},
				impact = {
					10,
					20,
				},
			},
			finesse_boost = PowerLevelSettings.default_finesse_boost_amount,
			boost_curve = PowerLevelSettings.boost_curves.default,
			boost_curve_multiplier_finesse = {
				0.2,
				0.3,
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
					110,
				},
				impact = {
					8,
					16,
				},
			},
			finesse_boost = PowerLevelSettings.default_finesse_boost_amount,
			boost_curve = PowerLevelSettings.boost_curves.default,
			boost_curve_multiplier_finesse = {
				0.2,
				0.3,
			},
			power_level_multiplier = {
				0.75,
				1.25,
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
			finesse_boost = PowerLevelSettings.default_finesse_boost_amount,
			boost_curve = PowerLevelSettings.boost_curves.default,
			boost_curve_multiplier_finesse = {
				0.2,
				0.3,
			},
			power_level_multiplier = {
				0.75,
				1.25,
			},
		},
		{
			power_distribution = {
				attack = {
					25,
					60,
				},
				impact = {
					4,
					10,
				},
			},
			finesse_boost = PowerLevelSettings.default_finesse_boost_amount,
			boost_curve = PowerLevelSettings.boost_curves.default,
			boost_curve_multiplier_finesse = {
				0.2,
				0.3,
			},
			power_level_multiplier = {
				0.75,
				1.25,
			},
		},
		default_target = {
			power_distribution = {
				attack = {
					10,
					30,
				},
				impact = {
					4,
					10,
				},
			},
			finesse_boost = PowerLevelSettings.default_finesse_boost_amount,
			boost_curve = PowerLevelSettings.boost_curves.default,
			boost_curve_multiplier_finesse = {
				0.2,
				0.3,
			},
			power_level_multiplier = {
				0.75,
				1.25,
			},
		},
	},
	gib_push_force = GibbingSettings.gib_push_force.blunt_heavy,
}
overrides.ogryn_powermaul_light_linesman_active = {
	parent_template_name = "ogryn_powermaul_light_linesman",
	overrides = {
		{
			"stagger_duration_modifier",
			{
				0.1,
				0.2,
			},
		},
		{
			"armor_damage_modifier",
			light_active_am,
		},
		{
			"targets",
			1,
			"power_distribution",
			"attack",
			{
				120,
				200,
			},
		},
		{
			"targets",
			1,
			"power_distribution",
			"impact",
			{
				40,
				80,
			},
		},
		{
			"targets",
			1,
			"armor_damage_modifier",
			light_active_am,
		},
		{
			"gibbing_power",
			gibbing_power.always,
		},
		{
			"gibbing_type",
			gibbing_types.crushing,
		},
		{
			"wounds_template",
			WoundsTemplates.ogryn_power_maul_activated,
		},
		{
			"cleave_distribution",
			"attack",
			math.huge,
		},
		{
			"cleave_distribution",
			"impact",
			math.huge,
		},
		{
			"shield_override_stagger_strength",
			200,
		},
		{
			"ragdoll_push_force",
			1300,
		},
		{
			"weapon_special",
			true,
		},
	},
}
damage_templates.ogryn_powermaul_heavy_tank = {
	ragdoll_only = true,
	ragdoll_push_force = 800,
	stagger_category = "melee",
	cleave_distribution = big_cleave,
	damage_type = damage_types.ogryn_pipe_club_heavy,
	gibbing_power = gibbing_power.always,
	gibbing_type = gibbing_types.crushing,
	melee_attack_strength = melee_attack_strengths.heavy,
	wounds_template = WoundsTemplates.ogryn_power_maul,
	stagger_duration_modifier = {
		0.1,
		0.5,
	},
	armor_damage_modifier = tank_heavy_default_am,
	targets = {
		{
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = {
					175,
					350,
				},
				impact = {
					25,
					50,
				},
			},
			armor_damage_modifier = tank_heavy_default_am,
		},
		{
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = {
					80,
					160,
				},
				impact = {
					25,
					50,
				},
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
					20,
					40,
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
					20,
					40,
				},
			},
		},
		default_target = {
			boost_curve_multiplier_finesse = 0.25,
			armor_damage_modifier = tank_heavy_default_am,
			power_distribution = {
				attack = {
					40,
					80,
				},
				impact = {
					15,
					30,
				},
			},
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
	gib_push_force = GibbingSettings.gib_push_force.blunt_heavy,
}
overrides.ogryn_powermaul_heavy_tank_active = {
	parent_template_name = "ogryn_powermaul_heavy_tank",
	overrides = {
		{
			"stagger_duration_modifier",
			{
				0.2,
				0.5,
			},
		},
		{
			"armor_damage_modifier",
			tank_heavy_active_am,
		},
		{
			"targets",
			1,
			"power_distribution",
			"attack",
			{
				250,
				475,
			},
		},
		{
			"targets",
			1,
			"power_distribution",
			"impact",
			{
				40,
				70,
			},
		},
		{
			"targets",
			1,
			"armor_damage_modifier",
			tank_heavy_active_am,
		},
		{
			"gibbing_power",
			gibbing_power.always,
		},
		{
			"gibbing_type",
			gibbing_types.crushing,
		},
		{
			"wounds_template",
			WoundsTemplates.ogryn_power_maul_activated,
		},
		{
			"cleave_distribution",
			"attack",
			math.huge,
		},
		{
			"cleave_distribution",
			"impact",
			math.huge,
		},
		{
			"shield_override_stagger_strength",
			200,
		},
		{
			"ragdoll_push_force",
			1600,
		},
		{
			"weapon_special",
			true,
		},
	},
}
damage_templates.ogryn_powermaul_heavy_smiter = {
	ragdoll_only = true,
	ragdoll_push_force = 400,
	stagger_category = "melee",
	cleave_distribution = double_cleave,
	damage_type = damage_types.ogryn_pipe_club_heavy,
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
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = {
					200,
					400,
				},
				impact = {
					30,
					35,
				},
			},
			armor_damage_modifier = tank_heavy_default_am,
		},
		{
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = {
					90,
					150,
				},
				impact = {
					20,
					25,
				},
			},
		},
		default_target = {
			boost_curve_multiplier_finesse = 0.25,
			armor_damage_modifier = tank_heavy_default_am,
			power_distribution = {
				attack = {
					0,
					0,
				},
				impact = {
					10,
					15,
				},
			},
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
}
overrides.ogryn_powermaul_heavy_smiter_active = {
	parent_template_name = "ogryn_powermaul_heavy_smiter",
	overrides = {
		{
			"stagger_duration_modifier",
			{
				0.2,
				0.5,
			},
		},
		{
			"armor_damage_modifier",
			tank_heavy_active_am,
		},
		{
			"targets",
			1,
			"power_distribution",
			"attack",
			{
				300,
				600,
			},
		},
		{
			"targets",
			1,
			"armor_damage_modifier",
			tank_heavy_active_am,
		},
		{
			"gibbing_power",
			gibbing_power.always,
		},
		{
			"gibbing_type",
			gibbing_types.crushing,
		},
		{
			"cleave_distribution",
			"attack",
			math.huge,
		},
		{
			"cleave_distribution",
			"impact",
			math.huge,
		},
		{
			"shield_override_stagger_strength",
			200,
		},
		{
			"weapon_special",
			true,
		},
	},
}
damage_templates.ogryn_powermaul_slabshield_smite = {
	ignore_stagger_reduction = true,
	ragdoll_only = true,
	ragdoll_push_force = 1000,
	stagger_category = "melee",
	cleave_distribution = {
		attack = {
			10.5,
			14.5,
		},
		impact = {
			10.5,
			14.5,
		},
	},
	damage_type = damage_types.blunt_heavy,
	gibbing_power = gibbing_power.always,
	gibbing_type = gibbing_types.default,
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
					180,
					360,
				},
				impact = {
					40,
					60,
				},
			},
		},
		{
			power_distribution = {
				attack = {
					120,
					240,
				},
				impact = {
					20,
					30,
				},
			},
		},
		{
			power_distribution = {
				attack = {
					100,
					200,
				},
				impact = {
					15,
					20,
				},
			},
		},
		default_target = {
			armor_damage_modifier = tank_heavy_default_am,
			power_distribution = {
				attack = {
					30,
					60,
				},
				impact = {
					10,
					15,
				},
			},
		},
	},
}
damage_templates.ogryn_powermaul_slabshield_tank = {
	ignore_stagger_reduction = true,
	ragdoll_only = true,
	ragdoll_push_force = 900,
	stagger_category = "melee",
	cleave_distribution = {
		attack = math.huge,
		impact = math.huge,
	},
	damage_type = damage_types.blunt_heavy,
	gibbing_power = gibbing_power.low,
	gibbing_type = gibbing_types.default,
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
					80,
					160,
				},
				impact = {
					20,
					30,
				},
			},
		},
		{
			power_distribution = {
				attack = {
					50,
					100,
				},
				impact = {
					15,
					20,
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
					10,
					20,
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
					5,
					15,
				},
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
					5,
					15,
				},
			},
		},
	},
}
damage_templates.ogryn_powermaul_light_tank = {
	dead_ragdoll_mod = 1.5,
	ragdoll_only = true,
	ragdoll_push_force = 500,
	stagger_category = "melee",
	cleave_distribution = large_cleave,
	damage_type = damage_types.ogryn_pipe_club,
	gibbing_power = gibbing_power.always,
	gibbing_type = gibbing_types.default,
	melee_attack_strength = melee_attack_strengths.light,
	wounds_template = WoundsTemplates.ogryn_power_maul,
	stagger_duration_modifier = {
		0.1,
		0.5,
	},
	armor_damage_modifier = tank_heavy_default_am,
	targets = {
		{
			boost_curve_multiplier_finesse = 0.25,
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
					25,
					50,
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
					20,
					40,
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
					15,
					30,
				},
				impact = {
					11,
					17,
				},
			},
		},
		default_target = {
			boost_curve_multiplier_finesse = 0.25,
			armor_damage_modifier = tank_heavy_default_am,
			power_distribution = {
				attack = {
					15,
					30,
				},
				impact = {
					3,
					10,
				},
			},
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
}

local human_tank_light_default_am = {
	attack = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1_25,
		[armor_types.armored] = damage_lerp_values.lerp_1,
		[armor_types.resistant] = damage_lerp_values.lerp_1,
		[armor_types.player] = damage_lerp_values.lerp_1,
		[armor_types.berserker] = damage_lerp_values.lerp_0_75,
		[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1_25,
		[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
	},
	impact = {
		[armor_types.unarmored] = damage_lerp_values.lerp_0_75,
		[armor_types.armored] = damage_lerp_values.lerp_1,
		[armor_types.resistant] = damage_lerp_values.lerp_1,
		[armor_types.player] = damage_lerp_values.lerp_1,
		[armor_types.berserker] = damage_lerp_values.lerp_1,
		[armor_types.super_armor] = damage_lerp_values.lerp_1,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_75,
		[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
	},
}
local human_tank_heavy_default_am = {
	attack = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1_25,
		[armor_types.armored] = damage_lerp_values.lerp_1,
		[armor_types.resistant] = damage_lerp_values.lerp_1_25,
		[armor_types.player] = damage_lerp_values.lerp_1,
		[armor_types.berserker] = damage_lerp_values.lerp_0_75,
		[armor_types.super_armor] = damage_lerp_values.lerp_0_25,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1_25,
		[armor_types.void_shield] = damage_lerp_values.lerp_1,
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
local human_smiter_default_am = {
	attack = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1_25,
		[armor_types.armored] = damage_lerp_values.lerp_1,
		[armor_types.resistant] = damage_lerp_values.lerp_1_25,
		[armor_types.player] = damage_lerp_values.lerp_1,
		[armor_types.berserker] = damage_lerp_values.lerp_0_75,
		[armor_types.super_armor] = damage_lerp_values.lerp_0_6,
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
}

damage_templates.powermaul_2h_light_tank = {
	dead_ragdoll_mod = 1.5,
	ragdoll_only = true,
	ragdoll_push_force = 500,
	stagger_category = "melee",
	cleave_distribution = large_cleave,
	damage_type = damage_types.ogryn_pipe_club,
	gibbing_power = gibbing_power.always,
	gibbing_type = gibbing_types.default,
	melee_attack_strength = melee_attack_strengths.light,
	wounds_template = WoundsTemplates.ogryn_power_maul,
	stagger_duration_modifier = {
		0.1,
		0.5,
	},
	armor_damage_modifier = human_tank_light_default_am,
	targets = {
		{
			boost_curve_multiplier_finesse = 0.5,
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
			boost_curve_multiplier_finesse = 0.5,
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
			boost_curve_multiplier_finesse = 0.5,
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
			boost_curve_multiplier_finesse = 0.5,
			armor_damage_modifier = tank_heavy_default_am,
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
overrides.powermaul_2h_light_pushfollow = {
	parent_template_name = "powermaul_2h_light_tank",
	overrides = {
		{
			"stagger_duration_modifier",
			{
				0.1,
				0.2,
			},
		},
		{
			"armor_damage_modifier",
			light_active_am,
		},
		{
			"targets",
			1,
			"power_distribution",
			"attack",
			{
				125,
				250,
			},
		},
		{
			"targets",
			1,
			"boost_curve_multiplier_finesse",
			2.25,
		},
	},
}
overrides.powermaul_2h_light_pushfollow_active = {
	parent_template_name = "powermaul_2h_light_tank",
	overrides = {
		{
			"armor_damage_modifier",
			light_active_am,
		},
		{
			"targets",
			1,
			"power_distribution",
			"attack",
			{
				150,
				300,
			},
		},
		{
			"targets",
			1,
			"boost_curve_multiplier_finesse",
			2.25,
		},
		{
			"gibbing_power",
			gibbing_power.always,
		},
		{
			"gibbing_type",
			gibbing_types.crushing,
		},
		{
			"wounds_template",
			WoundsTemplates.ogryn_power_maul_activated,
		},
		{
			"cleave_distribution",
			"attack",
			math.huge,
		},
		{
			"cleave_distribution",
			"impact",
			math.huge,
		},
		{
			"shield_override_stagger_strength",
			200,
		},
		{
			"weapon_special",
			true,
		},
	},
}
overrides.powermaul_2h_light_tank_active = {
	parent_template_name = "powermaul_2h_light_tank",
	overrides = {
		{
			"stagger_duration_modifier",
			{
				0.1,
				0.2,
			},
		},
		{
			"armor_damage_modifier",
			light_active_am,
		},
		{
			"targets",
			1,
			"power_distribution",
			"attack",
			{
				150,
				300,
			},
		},
		{
			"targets",
			1,
			"power_distribution",
			"impact",
			{
				40,
				80,
			},
		},
		{
			"gibbing_power",
			gibbing_power.always,
		},
		{
			"gibbing_type",
			gibbing_types.crushing,
		},
		{
			"wounds_template",
			WoundsTemplates.ogryn_power_maul_activated,
		},
		{
			"cleave_distribution",
			"attack",
			math.huge,
		},
		{
			"cleave_distribution",
			"impact",
			math.huge,
		},
		{
			"shield_override_stagger_strength",
			200,
		},
		{
			"weapon_special",
			true,
		},
	},
}
damage_templates.powermaul_2h_heavy_tank = {
	ragdoll_only = true,
	ragdoll_push_force = 800,
	stagger_category = "melee",
	cleave_distribution = big_cleave,
	damage_type = damage_types.ogryn_pipe_club_heavy,
	gibbing_power = gibbing_power.always,
	gibbing_type = gibbing_types.crushing,
	melee_attack_strength = melee_attack_strengths.heavy,
	wounds_template = WoundsTemplates.ogryn_power_maul,
	stagger_duration_modifier = {
		0.1,
		0.5,
	},
	armor_damage_modifier = human_tank_heavy_default_am,
	targets = {
		{
			boost_curve_multiplier_finesse = 0.75,
			power_distribution = {
				attack = {
					175,
					350,
				},
				impact = {
					25,
					50,
				},
			},
			armor_damage_modifier = human_tank_heavy_default_am,
		},
		{
			boost_curve_multiplier_finesse = 0.5,
			power_distribution = {
				attack = {
					80,
					160,
				},
				impact = {
					25,
					50,
				},
			},
		},
		{
			boost_curve_multiplier_finesse = 0.5,
			power_distribution = {
				attack = {
					60,
					120,
				},
				impact = {
					20,
					40,
				},
			},
		},
		{
			boost_curve_multiplier_finesse = 0.5,
			power_distribution = {
				attack = {
					50,
					100,
				},
				impact = {
					20,
					40,
				},
			},
		},
		default_target = {
			boost_curve_multiplier_finesse = 0.5,
			armor_damage_modifier = human_tank_heavy_default_am,
			power_distribution = {
				attack = {
					40,
					80,
				},
				impact = {
					15,
					30,
				},
			},
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
}
overrides.powermaul_2h_heavy_tank_active = {
	parent_template_name = "powermaul_2h_heavy_tank",
	overrides = {
		{
			"stagger_duration_modifier",
			{
				0.1,
				0.2,
			},
		},
		{
			"armor_damage_modifier",
			human_tank_heavy_default_am,
		},
		{
			"targets",
			1,
			"power_distribution",
			"attack",
			{
				200,
				400,
			},
		},
		{
			"targets",
			1,
			"power_distribution",
			"impact",
			{
				40,
				80,
			},
		},
		{
			"targets",
			1,
			"armor_damage_modifier",
			human_tank_heavy_default_am,
		},
		{
			"gibbing_power",
			gibbing_power.always,
		},
		{
			"gibbing_type",
			gibbing_types.crushing,
		},
		{
			"wounds_template",
			WoundsTemplates.ogryn_power_maul_activated,
		},
		{
			"cleave_distribution",
			"attack",
			math.huge,
		},
		{
			"cleave_distribution",
			"impact",
			math.huge,
		},
		{
			"shield_override_stagger_strength",
			200,
		},
		{
			"weapon_special",
			true,
		},
	},
}
damage_templates.powermaul_2h_light_smiter = {
	ignore_shield = false,
	ragdoll_only = true,
	ragdoll_push_force = 800,
	stagger_category = "melee",
	cleave_distribution = single_cleave,
	gibbing_power = gibbing_power.always,
	gibbing_type = gibbing_types.crushing,
	melee_attack_strength = melee_attack_strengths.light,
	wounds_template = WoundsTemplates.ogryn_power_maul,
	stagger_duration_modifier = {
		0.1,
		0.5,
	},
	armor_damage_modifier = human_smiter_default_am,
	targets = {
		{
			boost_curve_multiplier_finesse = 1.4,
			power_distribution = {
				attack = {
					110,
					220,
				},
				impact = {
					10,
					20,
				},
			},
			armor_damage_modifier = human_smiter_default_am,
		},
		{
			boost_curve_multiplier_finesse = 0.75,
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
				impact = 12,
				attack = {
					20,
					40,
				},
			},
		},
	},
}
overrides.powermaul_2h_light_smiter_active = {
	parent_template_name = "powermaul_2h_light_smiter",
	overrides = {
		{
			"cleave_distribution",
			"attack",
			math.huge,
		},
		{
			"cleave_distribution",
			"impact",
			math.huge,
		},
		{
			"stagger_duration_modifier",
			{
				0.2,
				0.5,
			},
		},
		{
			"armor_damage_modifier",
			light_active_am,
		},
		{
			"targets",
			1,
			"power_distribution",
			"attack",
			{
				200,
				400,
			},
		},
		{
			"targets",
			1,
			"power_distribution",
			"impact",
			{
				20,
				40,
			},
		},
		{
			"targets",
			1,
			"armor_damage_modifier",
			light_active_am,
		},
		{
			"gibbing_power",
			gibbing_power.always,
		},
		{
			"gibbing_type",
			gibbing_types.crushing,
		},
		{
			"shield_override_stagger_strength",
			200,
		},
		{
			"weapon_special",
			true,
		},
	},
}
overrides.powermaul_2h_heavy_smiter = {
	parent_template_name = "powermaul_2h_light_smiter",
	overrides = {
		{
			"melee_attack_strength",
			melee_attack_strengths.heavy,
		},
		{
			"targets",
			1,
			"power_distribution",
			"attack",
			{
				225,
				450,
			},
		},
		{
			"targets",
			1,
			"boost_curve_multiplier_finesse",
			1.4,
		},
		{
			"targets",
			1,
			"armor_damage_modifier",
			"attack",
			armor_types.resistant,
			damage_lerp_values.lerp_1_5,
		},
	},
}
overrides.powermaul_2h_heavy_smiter_active = {
	parent_template_name = "powermaul_2h_light_smiter",
	overrides = {
		{
			"cleave_distribution",
			"attack",
			math.huge,
		},
		{
			"cleave_distribution",
			"impact",
			math.huge,
		},
		{
			"stagger_duration_modifier",
			{
				0.2,
				0.5,
			},
		},
		{
			"armor_damage_modifier",
			light_active_am,
		},
		{
			"melee_attack_strength",
			melee_attack_strengths.heavy,
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
				40,
				80,
			},
		},
		{
			"targets",
			1,
			"armor_damage_modifier",
			"attack",
			armor_types.resistant,
			damage_lerp_values.lerp_1_5,
		},
		{
			"gibbing_power",
			gibbing_power.always,
		},
		{
			"gibbing_type",
			gibbing_types.crushing,
		},
		{
			"wounds_template",
			WoundsTemplates.ogryn_power_maul_activated,
		},
		{
			"shield_override_stagger_strength",
			200,
		},
		{
			"targets",
			1,
			"boost_curve_multiplier_finesse",
			1.4,
		},
		{
			"weapon_special",
			true,
		},
	},
}
damage_templates.powermaul_explosion = {
	ignore_shield = true,
	ignore_stagger_reduction = true,
	ragdoll_only = true,
	ragdoll_push_force = 1200,
	stagger_category = "flamer",
	suppression_type = "ability",
	power_distribution = {
		attack = 25,
		impact = 25,
	},
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = 1,
			[armor_types.armored] = 1,
			[armor_types.resistant] = 1,
			[armor_types.player] = 1,
			[armor_types.berserker] = 1,
			[armor_types.super_armor] = 1,
			[armor_types.disgustingly_resilient] = 1,
			[armor_types.void_shield] = 1,
		},
		impact = {
			[armor_types.unarmored] = 1,
			[armor_types.armored] = 1,
			[armor_types.resistant] = 1,
			[armor_types.player] = 1,
			[armor_types.berserker] = 1,
			[armor_types.super_armor] = 1,
			[armor_types.disgustingly_resilient] = 1,
			[armor_types.void_shield] = 1,
		},
	},
	stagger_duration_modifier = {
		0.1,
		0.5,
	},
	damage_type = damage_types.kinetic,
	targets = {
		default_target = {},
	},
}
damage_templates.powermaul_explosion_outer = {
	ignore_shield = true,
	ignore_stagger_reduction = true,
	ragdoll_push_force = 1000,
	stagger_category = "flamer",
	suppression_type = "ability",
	power_distribution = {
		attack = 0,
		impact = 15,
	},
	armor_damage_modifier_ranged = {
		near = {
			attack = {
				[armor_types.unarmored] = 1,
				[armor_types.armored] = 1,
				[armor_types.resistant] = 1,
				[armor_types.player] = 1,
				[armor_types.berserker] = 1,
				[armor_types.super_armor] = 1,
				[armor_types.disgustingly_resilient] = 1,
				[armor_types.void_shield] = 1,
			},
			impact = {
				[armor_types.unarmored] = 1,
				[armor_types.armored] = 1,
				[armor_types.resistant] = 1,
				[armor_types.player] = 1,
				[armor_types.berserker] = 1,
				[armor_types.super_armor] = 1,
				[armor_types.disgustingly_resilient] = 1,
				[armor_types.void_shield] = 1,
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
				[armor_types.resistant] = 1,
				[armor_types.player] = 0.2,
				[armor_types.berserker] = 0.5,
				[armor_types.super_armor] = 0.2,
				[armor_types.disgustingly_resilient] = 1,
				[armor_types.void_shield] = 0.2,
			},
		},
	},
	stagger_duration_modifier = {
		0.1,
		0.5,
	},
	gibbing_power = gibbing_power.always,
	damage_type = damage_types.plasma,
	targets = {
		default_target = {},
	},
}

return {
	base_templates = damage_templates,
	overrides = overrides,
}
