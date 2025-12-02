-- chunkname: @scripts/settings/equipment/weapon_templates/saws/settings_templates/saw_damage_profile_templates.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local DamageProfileSettings = require("scripts/settings/damage/damage_profile_settings")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local GibbingSettings = require("scripts/settings/gibbing/gibbing_settings")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local WoundsTemplates = require("scripts/settings/damage/wounds_templates")
local armor_types = ArmorSettings.types
local crit_armor_mod = DamageProfileSettings.saw_crit_mod
local damage_lerp_values = DamageProfileSettings.damage_lerp_values
local damage_types = DamageSettings.damage_types
local gibbing_power = GibbingSettings.gibbing_power
local gibbing_types = GibbingSettings.gibbing_types
local melee_attack_strengths = AttackSettings.melee_attack_strength
local damage_templates = {}
local overrides = {}

table.make_unique(damage_templates)
table.make_unique(overrides)

local no_cleave = DamageProfileSettings.no_cleave
local single_cleave = DamageProfileSettings.single_cleave
local single_plus_cleave = DamageProfileSettings.single_plus_cleave
local double_cleave = DamageProfileSettings.double_cleave
local light_cleave = DamageProfileSettings.light_cleave
local medium_cleave = DamageProfileSettings.medium_cleave
local large_cleave = DamageProfileSettings.large_cleave
local big_cleave = DamageProfileSettings.big_cleave
local cutting_am = {
	attack = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1_1,
		[armor_types.armored] = damage_lerp_values.lerp_0_3,
		[armor_types.resistant] = damage_lerp_values.lerp_0_8,
		[armor_types.player] = damage_lerp_values.no_damage,
		[armor_types.berserker] = damage_lerp_values.lerp_1,
		[armor_types.super_armor] = damage_lerp_values.lerp_0_075,
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
local smiter_am = {
	attack = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1_1,
		[armor_types.armored] = damage_lerp_values.lerp_0_6,
		[armor_types.resistant] = damage_lerp_values.lerp_1,
		[armor_types.player] = damage_lerp_values.no_damage,
		[armor_types.berserker] = damage_lerp_values.lerp_1,
		[armor_types.super_armor] = damage_lerp_values.lerp_0_25,
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
local cutting_ap_am = {
	attack = {
		[armor_types.unarmored] = damage_lerp_values.lerp_0_9,
		[armor_types.armored] = damage_lerp_values.lerp_0_75,
		[armor_types.resistant] = damage_lerp_values.lerp_0_7,
		[armor_types.player] = damage_lerp_values.no_damage,
		[armor_types.berserker] = damage_lerp_values.lerp_0_7,
		[armor_types.super_armor] = damage_lerp_values.lerp_0_35,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_9,
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
local smiter_ap_am = {
	attack = {
		[armor_types.unarmored] = damage_lerp_values.lerp_0_9,
		[armor_types.armored] = damage_lerp_values.lerp_0_8,
		[armor_types.resistant] = damage_lerp_values.lerp_0_8,
		[armor_types.player] = damage_lerp_values.no_damage,
		[armor_types.berserker] = damage_lerp_values.lerp_0_75,
		[armor_types.super_armor] = damage_lerp_values.lerp_0_6,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_9,
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

damage_templates.saw_light_linesman = {
	ragdoll_push_force = 100,
	stagger_category = "melee",
	cleave_distribution = double_cleave,
	damage_type = damage_types.metal_slashing_light,
	gibbing_power = gibbing_power.light,
	gibbing_type = gibbing_types.sawing,
	melee_attack_strength = melee_attack_strengths.light,
	wounds_template = WoundsTemplates.saw,
	gib_push_force = GibbingSettings.gib_push_force.sawing_medium,
	armor_damage_modifier = cutting_am,
	crit_mod = crit_armor_mod,
	targets = {
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
			boost_curve_multiplier_finesse = {
				0.5,
				1.5,
			},
			power_level_multiplier = {
				0.5,
				1.5,
			},
		},
		{
			power_distribution = {
				attack = {
					40,
					75,
				},
				impact = {
					3,
					6,
				},
			},
			boost_curve_multiplier_finesse = {
				0.4,
				1.2,
			},
		},
		{
			power_distribution = {
				attack = {
					25,
					55,
				},
				impact = {
					2,
					4,
				},
			},
		},
		default_target = {
			power_distribution = {
				attack = {
					10,
					30,
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
damage_templates.saw_light_smiter = {
	stagger_category = "melee",
	sticky_attack = false,
	cleave_distribution = single_cleave,
	damage_type = damage_types.sawing,
	critical_strike = {
		gibbing_power = gibbing_power.light,
		gibbing_type = gibbing_types.sawing,
	},
	gibbing_power = gibbing_power.always,
	gibbing_type = gibbing_types.sawing,
	melee_attack_strength = melee_attack_strengths.light,
	wounds_template = WoundsTemplates.saw,
	armor_damage_modifier = smiter_am,
	crit_mod = crit_armor_mod,
	targets = {
		{
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
				0.5,
				1.5,
			},
			power_level_multiplier = {
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
					3,
					6,
				},
			},
			boost_curve_multiplier_finesse = {
				0.4,
				1.2,
			},
		},
		default_target = {
			power_distribution = {
				attack = {
					10,
					20,
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
damage_templates.saw_heavy_linesman = {
	ignore_gib_push = true,
	ragdoll_push_force = 500,
	stagger_category = "melee",
	cleave_distribution = light_cleave,
	damage_type = damage_types.sawing,
	gibbing_power = gibbing_power.medium,
	gibbing_type = gibbing_types.sawing,
	melee_attack_strength = melee_attack_strengths.heavy,
	gib_push_force = GibbingSettings.gib_push_force.sawing_heavy,
	wounds_template = WoundsTemplates.saw,
	armor_damage_modifier = cutting_am,
	crit_mod = crit_armor_mod,
	targets = {
		{
			power_distribution = {
				attack = {
					90,
					180,
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
			power_distribution = {
				attack = {
					70,
					140,
				},
				impact = {
					5,
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
					50,
					100,
				},
				impact = {
					4,
					8,
				},
			},
			boost_curve_multiplier_finesse = {
				0.2,
				1,
			},
		},
		{
			power_distribution = {
				attack = {
					35,
					75,
				},
				impact = {
					4,
					8,
				},
			},
		},
		{
			power_distribution = {
				attack = {
					25,
					50,
				},
				impact = {
					3,
					6,
				},
			},
		},
		default_target = {
			power_distribution = {
				attack = {
					20,
					30,
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
damage_templates.saw_heavy_smiter = {
	ignore_gib_push = true,
	ragdoll_push_force = 500,
	stagger_category = "melee",
	sticky_attack = false,
	cleave_distribution = single_plus_cleave,
	damage_type = damage_types.sawing,
	gibbing_power = gibbing_power.medium,
	gibbing_type = gibbing_types.sawing,
	melee_attack_strength = melee_attack_strengths.heavy,
	gib_push_force = GibbingSettings.gib_push_force.sawing_heavy,
	wounds_template = WoundsTemplates.saw,
	armor_damage_modifier = smiter_am,
	crit_mod = crit_armor_mod,
	targets = {
		{
			power_distribution = {
				attack = {
					165,
					330,
				},
				impact = {
					8,
					16,
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
					60,
					120,
				},
				impact = {
					5,
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
					30,
					60,
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
}
damage_templates.saw_light_linesman_ap = {
	ragdoll_push_force = 100,
	stagger_category = "melee",
	cleave_distribution = double_cleave,
	damage_type = damage_types.sawing,
	gibbing_power = gibbing_power.light,
	gibbing_type = gibbing_types.sawing,
	melee_attack_strength = melee_attack_strengths.light,
	wounds_template = WoundsTemplates.saw,
	gib_push_force = GibbingSettings.gib_push_force.sawing_medium,
	armor_damage_modifier = cutting_ap_am,
	crit_mod = crit_armor_mod,
	targets = {
		{
			power_distribution = {
				attack = {
					60,
					110,
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
			power_level_multiplier = {
				0.5,
				1.5,
			},
		},
		{
			power_distribution = {
				attack = {
					40,
					85,
				},
				impact = {
					3,
					6,
				},
			},
			boost_curve_multiplier_finesse = {
				0.4,
				1.2,
			},
		},
		{
			power_distribution = {
				attack = {
					25,
					55,
				},
				impact = {
					2,
					4,
				},
			},
		},
		default_target = {
			power_distribution = {
				attack = {
					10,
					30,
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
damage_templates.saw_light_smiter_ap = {
	stagger_category = "melee",
	cleave_distribution = single_cleave,
	damage_type = damage_types.sawing,
	critical_strike = {
		gibbing_power = gibbing_power.light,
		gibbing_type = gibbing_types.sawing,
	},
	gibbing_power = gibbing_power.always,
	gibbing_type = gibbing_types.sawing,
	melee_attack_strength = melee_attack_strengths.light,
	wounds_template = WoundsTemplates.saw,
	armor_damage_modifier = smiter_ap_am,
	crit_mod = crit_armor_mod,
	targets = {
		{
			power_distribution = {
				attack = {
					105,
					210,
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
			power_level_multiplier = {
				0.5,
				1.5,
			},
		},
		{
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
			boost_curve_multiplier_finesse = {
				0.2,
				1,
			},
		},
		default_target = {
			power_distribution = {
				attack = {
					10,
					20,
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
damage_templates.saw_heavy_linesman_ap = {
	ignore_gib_push = true,
	ragdoll_push_force = 500,
	stagger_category = "melee",
	cleave_distribution = light_cleave,
	damage_type = damage_types.sawing,
	gibbing_power = gibbing_power.medium,
	gibbing_type = gibbing_types.sawing,
	melee_attack_strength = melee_attack_strengths.heavy,
	gib_push_force = GibbingSettings.gib_push_force.sawing_heavy,
	wounds_template = WoundsTemplates.saw,
	armor_damage_modifier = cutting_ap_am,
	crit_mod = crit_armor_mod,
	targets = {
		{
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
			power_distribution = {
				attack = {
					70,
					140,
				},
				impact = {
					5,
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
					50,
					100,
				},
				impact = {
					4,
					8,
				},
			},
			boost_curve_multiplier_finesse = {
				0.2,
				1,
			},
		},
		{
			power_distribution = {
				attack = {
					35,
					75,
				},
				impact = {
					4,
					8,
				},
			},
		},
		{
			power_distribution = {
				attack = {
					25,
					50,
				},
				impact = {
					3,
					6,
				},
			},
		},
		default_target = {
			power_distribution = {
				attack = {
					20,
					30,
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
damage_templates.saw_heavy_smiter_ap = {
	ignore_gib_push = true,
	ragdoll_push_force = 500,
	stagger_category = "melee",
	cleave_distribution = single_plus_cleave,
	damage_type = damage_types.sawing,
	gibbing_power = gibbing_power.medium,
	gibbing_type = gibbing_types.sawing,
	melee_attack_strength = melee_attack_strengths.heavy,
	gib_push_force = GibbingSettings.gib_push_force.sawing_heavy,
	wounds_template = WoundsTemplates.saw,
	armor_damage_modifier = smiter_ap_am,
	crit_mod = crit_armor_mod,
	targets = {
		{
			power_distribution = {
				attack = {
					170,
					340,
				},
				impact = {
					8,
					16,
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
					65,
					130,
				},
				impact = {
					5,
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
					30,
					60,
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
}
overrides.saw_light_sticky = {
	parent_template_name = "saw_light_smiter",
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
			"cleave_distribution",
			no_cleave,
		},
	},
}
overrides.saw_light_sticky_ap = {
	parent_template_name = "saw_light_smiter_ap",
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
			"cleave_distribution",
			no_cleave,
		},
	},
}
overrides.saw_light_sticky_rip = {
	parent_template_name = "saw_light_smiter",
	overrides = {
		{
			"stagger_category",
			"sticky",
		},
		{
			"shield_stagger_category",
			"melee",
		},
		{
			"damage_type",
			damage_types.sawing,
		},
		{
			"ignore_stagger_reduction",
			true,
		},
		{
			"ignore_shield",
			true,
		},
		{
			"ragdoll_only",
			true,
		},
		{
			"gibbing_power",
			gibbing_power.medium,
		},
		{
			"sticky_attack",
			true,
		},
		{
			"gibbing_type",
			gibbing_types.sawing,
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
				70,
				140,
			},
		},
		{
			"targets",
			1,
			"power_distribution",
			"impact",
			{
				5,
				10,
			},
		},
		{
			"skip_on_hit_proc",
			true,
		},
	},
}
overrides.saw_light_sticky_ap_rip = {
	parent_template_name = "saw_light_smiter_ap",
	overrides = {
		{
			"stagger_category",
			"sticky",
		},
		{
			"shield_stagger_category",
			"melee",
		},
		{
			"damage_type",
			damage_types.sawing,
		},
		{
			"ignore_stagger_reduction",
			true,
		},
		{
			"ignore_shield",
			true,
		},
		{
			"ragdoll_only",
			true,
		},
		{
			"gibbing_power",
			gibbing_power.medium,
		},
		{
			"sticky_attack",
			true,
		},
		{
			"gibbing_type",
			gibbing_types.sawing,
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
				90,
				180,
			},
		},
		{
			"targets",
			1,
			"power_distribution",
			"impact",
			{
				5,
				10,
			},
		},
		{
			"skip_on_hit_proc",
			true,
		},
	},
}
overrides.saw_heavy_sticky = {
	parent_template_name = "saw_heavy_smiter",
	overrides = {
		{
			"stagger_category",
			"sticky",
		},
		{
			"shield_stagger_category",
			"melee",
		},
		{
			"cleave_distribution",
			no_cleave,
		},
	},
}
overrides.saw_heavy_sticky_ap = {
	parent_template_name = "saw_heavy_smiter_ap",
	overrides = {
		{
			"stagger_category",
			"sticky",
		},
		{
			"shield_stagger_category",
			"melee",
		},
		{
			"cleave_distribution",
			no_cleave,
		},
	},
}
overrides.saw_heavy_sticky_rip = {
	parent_template_name = "saw_heavy_smiter",
	overrides = {
		{
			"stagger_category",
			"melee",
		},
		{
			"shield_stagger_category",
			"melee",
		},
		{
			"ignore_shield",
			true,
		},
		{
			"damage_type",
			damage_types.sawing,
		},
		{
			"sticky_attack",
			true,
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
			"gibbing_power",
			gibbing_power.heavy,
		},
		{
			"gibbing_type",
			gibbing_types.sawing,
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
			"skip_on_hit_proc",
			true,
		},
	},
}
overrides.saw_heavy_sticky_ap_rip = {
	parent_template_name = "saw_heavy_smiter_ap",
	overrides = {
		{
			"stagger_category",
			"melee",
		},
		{
			"shield_stagger_category",
			"melee",
		},
		{
			"ignore_shield",
			true,
		},
		{
			"damage_type",
			damage_types.sawing,
		},
		{
			"sticky_attack",
			true,
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
			"gibbing_power",
			gibbing_power.heavy,
		},
		{
			"gibbing_type",
			gibbing_types.sawing,
		},
		{
			"targets",
			1,
			"power_distribution",
			"attack",
			{
				160,
				320,
			},
		},
		{
			"skip_on_hit_proc",
			true,
		},
	},
}

return {
	base_templates = damage_templates,
	overrides = overrides,
}
