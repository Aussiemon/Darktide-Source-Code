-- chunkname: @scripts/settings/equipment/weapon_templates/power_swords/settings_templates/power_sword_damage_profile_templates.lua

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
local damage_templates = {}
local overrides = {}

table.make_unique(damage_templates)
table.make_unique(overrides)

local cutting_am = {
	attack = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1,
		[armor_types.armored] = damage_lerp_values.lerp_0_5,
		[armor_types.resistant] = damage_lerp_values.lerp_0_5,
		[armor_types.player] = damage_lerp_values.no_damage,
		[armor_types.berserker] = damage_lerp_values.lerp_1,
		[armor_types.super_armor] = damage_lerp_values.lerp_0_075,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_75,
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
local power_am = {
	attack = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1,
		[armor_types.armored] = damage_lerp_values.lerp_1,
		[armor_types.resistant] = damage_lerp_values.lerp_1_75,
		[armor_types.player] = damage_lerp_values.no_damage,
		[armor_types.berserker] = damage_lerp_values.lerp_1,
		[armor_types.super_armor] = damage_lerp_values.lerp_0_75,
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

damage_templates.light_sword = {
	finesse_ability_damage_multiplier = 2,
	stagger_category = "melee",
	cleave_distribution = double_cleave,
	damage_type = damage_types.metal_slashing_medium,
	gibbing_power = gibbing_power.light,
	gibbing_type = gibbing_types.sawing,
	gib_push_force = GibbingSettings.gib_push_force.sawing_medium,
	melee_attack_strength = melee_attack_strengths.light,
	wounds_template = WoundsTemplates.power_sword,
	armor_damage_modifier = cutting_am,
	targets = {
		{
			armor_damage_modifier = cutting_am,
			boost_curve_multiplier_finesse = {
				0.5,
				1,
			},
			power_distribution = {
				attack = {
					80,
					160,
				},
				impact = {
					5,
					9,
				},
			},
		},
		{
			armor_damage_modifier = cutting_am,
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
		},
		{
			armor_damage_modifier = cutting_am,
			power_distribution = {
				attack = {
					30,
					60,
				},
				impact = {
					3,
					7,
				},
			},
		},
		default_target = {
			armor_damage_modifier = cutting_am,
			power_distribution = {
				attack = {
					10,
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
damage_templates.light_sword_smiter = {
	finesse_ability_damage_multiplier = 2,
	stagger_category = "melee",
	cleave_distribution = single_cleave,
	damage_type = damage_types.metal_slashing_medium,
	gibbing_power = gibbing_power.light,
	gibbing_type = gibbing_types.sawing,
	gib_push_force = GibbingSettings.gib_push_force.sawing_medium,
	melee_attack_strength = melee_attack_strengths.light,
	wounds_template = WoundsTemplates.power_sword,
	armor_damage_modifier = cutting_am,
	targets = {
		{
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_1,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
					[armor_types.player] = damage_lerp_values.no_damage,
					[armor_types.berserker] = damage_lerp_values.lerp_1,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_25,
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
			boost_curve_multiplier_finesse = {
				0.5,
				1,
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
		},
		default_target = {
			armor_damage_modifier = cutting_am,
			power_distribution = {
				attack = {
					10,
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
overrides.light_sword_stab = {
	parent_template_name = "light_sword_smiter",
	overrides = {
		{
			"targets",
			1,
			"boost_curve_multiplier_finesse",
			{
				1,
				2,
			},
		},
		{
			"targets",
			1,
			"power_distribution",
			"attack",
			{
				100,
				200,
			},
		},
		{
			"gibbing_power",
			0,
		},
	},
}
damage_templates.light_powersword = {
	finesse_ability_damage_multiplier = 2,
	stagger_category = "melee",
	weapon_special = true,
	cleave_distribution = big_cleave,
	damage_type = damage_types.power_sword,
	gibbing_power = gibbing_power.heavy,
	gibbing_type = gibbing_types.sawing,
	gib_push_force = GibbingSettings.gib_push_force.sawing_medium,
	melee_attack_strength = melee_attack_strengths.light,
	wounds_template = WoundsTemplates.power_sword,
	armor_damage_modifier = power_am,
	targets = {
		{
			armor_damage_modifier = power_am,
			boost_curve_multiplier_finesse = {
				0.8,
				1.6,
			},
			power_distribution = {
				attack = {
					200,
					400,
				},
				impact = {
					7,
					9,
				},
			},
		},
		{
			armor_damage_modifier = power_am,
			boost_curve_multiplier_finesse = {
				0.6,
				1.2,
			},
			power_distribution = {
				attack = {
					120,
					240,
				},
				impact = {
					7,
					9,
				},
			},
		},
		{
			armor_damage_modifier = power_am,
			boost_curve_multiplier_finesse = {
				0.4,
				1,
			},
			power_distribution = {
				attack = {
					80,
					160,
				},
				impact = {
					7,
					9,
				},
			},
		},
		{
			armor_damage_modifier = power_am,
			power_distribution = {
				attack = {
					60,
					120,
				},
				impact = {
					5,
					7,
				},
			},
		},
		{
			armor_damage_modifier = power_am,
			power_distribution = {
				attack = {
					40,
					80,
				},
				impact = {
					5,
					7,
				},
			},
		},
		{
			armor_damage_modifier = power_am,
			power_distribution = {
				attack = {
					25,
					65,
				},
				impact = {
					5,
					7,
				},
			},
		},
		{
			armor_damage_modifier = power_am,
			power_distribution = {
				attack = {
					20,
					60,
				},
				impact = {
					5,
					7,
				},
			},
		},
		default_target = {
			armor_damage_modifier = power_am,
			power_distribution = {
				attack = {
					10,
					50,
				},
				impact = {
					4,
					6,
				},
			},
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
}
overrides.light_powersword_active = {
	parent_template_name = "light_powersword",
	overrides = {
		{
			"wounds_template",
			WoundsTemplates.power_sword_active,
		},
		{
			"ignore_stagger_reduction",
			true,
		},
	},
}
damage_templates.light_powersword_smiter = {
	finesse_ability_damage_multiplier = 2,
	stagger_category = "melee",
	weapon_special = true,
	cleave_distribution = big_cleave,
	damage_type = damage_types.power_sword,
	gibbing_power = gibbing_power.heavy,
	gibbing_type = gibbing_types.sawing,
	gib_push_force = GibbingSettings.gib_push_force.sawing_medium,
	melee_attack_strength = melee_attack_strengths.light,
	wounds_template = WoundsTemplates.power_sword,
	armor_damage_modifier = power_am,
	targets = {
		{
			armor_damage_modifier = power_am,
			boost_curve_multiplier_finesse = {
				0.4,
				1,
			},
			power_distribution = {
				attack = {
					150,
					250,
				},
				impact = {
					7,
					9,
				},
			},
		},
		{
			armor_damage_modifier = power_am,
			boost_curve_multiplier_finesse = {
				0.4,
				1,
			},
			power_distribution = {
				attack = {
					60,
					120,
				},
				impact = {
					7,
					9,
				},
			},
		},
		{
			armor_damage_modifier = power_am,
			boost_curve_multiplier_finesse = {
				0.4,
				1,
			},
			power_distribution = {
				attack = {
					60,
					120,
				},
				impact = {
					7,
					9,
				},
			},
		},
		{
			armor_damage_modifier = power_am,
			power_distribution = {
				attack = {
					60,
					120,
				},
				impact = {
					5,
					7,
				},
			},
		},
		{
			armor_damage_modifier = power_am,
			power_distribution = {
				attack = {
					60,
					120,
				},
				impact = {
					5,
					7,
				},
			},
		},
		{
			armor_damage_modifier = power_am,
			power_distribution = {
				attack = {
					60,
					120,
				},
				impact = {
					5,
					7,
				},
			},
		},
		{
			armor_damage_modifier = power_am,
			power_distribution = {
				attack = {
					20,
					60,
				},
				impact = {
					5,
					7,
				},
			},
		},
		default_target = {
			armor_damage_modifier = power_am,
			power_distribution = {
				attack = {
					10,
					50,
				},
				impact = {
					4,
					6,
				},
			},
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
}

local push_followup_adm = {
	attack = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1,
		[armor_types.armored] = damage_lerp_values.lerp_1,
		[armor_types.resistant] = damage_lerp_values.lerp_2,
		[armor_types.player] = damage_lerp_values.no_damage,
		[armor_types.berserker] = damage_lerp_values.lerp_1,
		[armor_types.super_armor] = damage_lerp_values.lerp_1_25,
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

damage_templates.light_powersword_smiter_push_follow_up_active = {
	finesse_ability_damage_multiplier = 2,
	stagger_category = "melee",
	weapon_special = true,
	cleave_distribution = big_cleave,
	damage_type = damage_types.power_sword,
	gibbing_power = gibbing_power.heavy,
	gibbing_type = gibbing_types.sawing,
	gib_push_force = GibbingSettings.gib_push_force.sawing_medium,
	melee_attack_strength = melee_attack_strengths.light,
	wounds_template = WoundsTemplates.power_sword_active,
	armor_damage_modifier = push_followup_adm,
	targets = {
		{
			armor_damage_modifier = push_followup_adm,
			boost_curve_multiplier_finesse = {
				0.8,
				1.6,
			},
			power_distribution = {
				attack = {
					250,
					500,
				},
				impact = {
					7,
					9,
				},
			},
		},
		{
			armor_damage_modifier = push_followup_adm,
			boost_curve_multiplier_finesse = {
				0.6,
				1.2,
			},
			power_distribution = {
				attack = {
					120,
					240,
				},
				impact = {
					7,
					9,
				},
			},
		},
		{
			armor_damage_modifier = push_followup_adm,
			boost_curve_multiplier_finesse = {
				0.4,
				1,
			},
			power_distribution = {
				attack = {
					80,
					160,
				},
				impact = {
					7,
					9,
				},
			},
		},
		{
			armor_damage_modifier = push_followup_adm,
			power_distribution = {
				attack = {
					60,
					120,
				},
				impact = {
					5,
					7,
				},
			},
		},
		{
			armor_damage_modifier = push_followup_adm,
			power_distribution = {
				attack = {
					40,
					80,
				},
				impact = {
					5,
					7,
				},
			},
		},
		{
			armor_damage_modifier = push_followup_adm,
			power_distribution = {
				attack = {
					25,
					65,
				},
				impact = {
					5,
					7,
				},
			},
		},
		{
			armor_damage_modifier = push_followup_adm,
			power_distribution = {
				attack = {
					20,
					60,
				},
				impact = {
					5,
					7,
				},
			},
		},
		default_target = {
			armor_damage_modifier = push_followup_adm,
			power_distribution = {
				attack = {
					10,
					50,
				},
				impact = {
					4,
					6,
				},
			},
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
}
overrides.light_powersword_active_smiter = {
	parent_template_name = "light_powersword_smiter_push_follow_up_active",
	overrides = {
		{
			"wounds_template",
			WoundsTemplates.power_sword_active,
		},
	},
}
overrides.light_powersword_stab_active = {
	parent_template_name = "light_powersword_smiter_push_follow_up_active",
	overrides = {
		{
			"targets",
			1,
			"boost_curve_multiplier_finesse",
			{
				1,
				2,
			},
		},
		{
			"wounds_template",
			WoundsTemplates.power_sword_active,
		},
	},
}
damage_templates.heavy_powersword = {
	finesse_ability_damage_multiplier = 2,
	gibbing_power = 10,
	ragdoll_only = true,
	ragdoll_push_force = 400,
	stagger_category = "melee",
	weapon_special = true,
	cleave_distribution = big_cleave,
	damage_type = damage_types.power_sword,
	gibbing_type = gibbing_types.default,
	melee_attack_strength = melee_attack_strengths.heavy,
	gib_push_force = GibbingSettings.gib_push_force.sawing_heavy,
	wounds_template = WoundsTemplates.power_sword,
	armor_damage_modifier = power_am,
	targets = {
		{
			armor_damage_modifier = power_am,
			boost_curve_multiplier_finesse = {
				0.8,
				1.6,
			},
			power_distribution = {
				attack = {
					270,
					540,
				},
				impact = {
					6,
					8,
				},
			},
		},
		{
			armor_damage_modifier = power_am,
			boost_curve_multiplier_finesse = {
				0.6,
				1.2,
			},
			power_distribution = {
				attack = {
					180,
					360,
				},
				impact = {
					6,
					8,
				},
			},
		},
		{
			armor_damage_modifier = power_am,
			boost_curve_multiplier_finesse = {
				0.4,
				1,
			},
			power_distribution = {
				attack = {
					150,
					300,
				},
				impact = {
					6,
					8,
				},
			},
		},
		{
			armor_damage_modifier = power_am,
			power_distribution = {
				attack = {
					90,
					180,
				},
				impact = {
					6,
					8,
				},
			},
		},
		{
			armor_damage_modifier = power_am,
			power_distribution = {
				attack = {
					85,
					170,
				},
				impact = {
					6,
					8,
				},
			},
		},
		{
			armor_damage_modifier = power_am,
			power_distribution = {
				attack = {
					75,
					150,
				},
				impact = {
					6,
					8,
				},
			},
		},
		{
			armor_damage_modifier = power_am,
			power_distribution = {
				attack = {
					70,
					140,
				},
				impact = {
					6,
					8,
				},
			},
		},
		default_target = {
			armor_damage_modifier = power_am,
			power_distribution = {
				attack = {
					50,
					100,
				},
				impact = {
					6,
					8,
				},
			},
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
}
overrides.heavy_powersword_active = {
	parent_template_name = "heavy_powersword",
	overrides = {
		{
			"ignore_stagger_reduction",
			true,
		},
		{
			"wounds_template",
			WoundsTemplates.power_sword_active,
		},
		{
			"targets",
			1,
			"armor_damage_modifier",
			"attack",
			"super_armor",
			damage_lerp_values.lerp_0_65,
		},
		{
			"targets",
			1,
			"armor_damage_modifier",
			"attack",
			"resistant",
			damage_lerp_values.lerp_1_5,
		},
		{
			"targets",
			2,
			"armor_damage_modifier",
			"attack",
			"super_armor",
			damage_lerp_values.lerp_0_65,
		},
		{
			"targets",
			2,
			"armor_damage_modifier",
			"attack",
			"resistant",
			damage_lerp_values.lerp_1_5,
		},
		{
			"targets",
			3,
			"armor_damage_modifier",
			"attack",
			"super_armor",
			damage_lerp_values.lerp_0_65,
		},
		{
			"targets",
			3,
			"armor_damage_modifier",
			"attack",
			"resistant",
			damage_lerp_values.lerp_1_5,
		},
		{
			"targets",
			4,
			"armor_damage_modifier",
			"attack",
			"super_armor",
			damage_lerp_values.lerp_0_65,
		},
		{
			"targets",
			4,
			"armor_damage_modifier",
			"attack",
			"resistant",
			damage_lerp_values.lerp_1_5,
		},
		{
			"targets",
			5,
			"armor_damage_modifier",
			"attack",
			"super_armor",
			damage_lerp_values.lerp_0_65,
		},
		{
			"targets",
			5,
			"armor_damage_modifier",
			"attack",
			"resistant",
			damage_lerp_values.lerp_1_5,
		},
		{
			"targets",
			6,
			"armor_damage_modifier",
			"attack",
			"super_armor",
			damage_lerp_values.lerp_0_65,
		},
		{
			"targets",
			6,
			"armor_damage_modifier",
			"attack",
			"resistant",
			damage_lerp_values.lerp_1_5,
		},
		{
			"targets",
			7,
			"armor_damage_modifier",
			"attack",
			"super_armor",
			damage_lerp_values.lerp_0_65,
		},
		{
			"targets",
			7,
			"armor_damage_modifier",
			"attack",
			"resistant",
			damage_lerp_values.lerp_1_5,
		},
	},
}

local heavy_sword_am = {
	attack = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1,
		[armor_types.armored] = damage_lerp_values.lerp_0_75,
		[armor_types.resistant] = damage_lerp_values.lerp_0_75,
		[armor_types.player] = damage_lerp_values.no_damage,
		[armor_types.berserker] = damage_lerp_values.lerp_1,
		[armor_types.super_armor] = damage_lerp_values.lerp_0_25,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_75,
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

damage_templates.heavy_sword = {
	finesse_ability_damage_multiplier = 2,
	ragdoll_push_force = 150,
	stagger_category = "melee",
	cleave_distribution = medium_cleave,
	damage_type = damage_types.metal_slashing_medium,
	gibbing_power = gibbing_power.medium,
	gibbing_type = gibbing_types.sawing,
	gib_push_force = GibbingSettings.gib_push_force.sawing_heavy,
	melee_attack_strength = melee_attack_strengths.heavy,
	wounds_template = WoundsTemplates.power_sword,
	armor_damage_modifier = cutting_am,
	targets = {
		{
			armor_damage_modifier = heavy_sword_am,
			boost_curve_multiplier_finesse = {
				0.4,
				1.2,
			},
			power_distribution = {
				attack = {
					120,
					240,
				},
				impact = {
					8,
					16,
				},
			},
		},
		{
			armor_damage_modifier = heavy_sword_am,
			power_distribution = {
				attack = {
					60,
					120,
				},
				impact = {
					6,
					12,
				},
			},
		},
		{
			armor_damage_modifier = heavy_sword_am,
			power_distribution = {
				attack = {
					20,
					60,
				},
				impact = {
					5,
					10,
				},
			},
		},
		default_target = {
			armor_damage_modifier = heavy_sword_am,
			power_distribution = {
				attack = {
					10,
					50,
				},
				impact = {
					4,
					8,
				},
			},
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
}

local cutting_am_p2 = {
	attack = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1,
		[armor_types.armored] = damage_lerp_values.lerp_0_5,
		[armor_types.resistant] = damage_lerp_values.lerp_0_5,
		[armor_types.player] = damage_lerp_values.no_damage,
		[armor_types.berserker] = damage_lerp_values.lerp_0_75,
		[armor_types.super_armor] = damage_lerp_values.lerp_0_1,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_75,
		[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
	},
	impact = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1,
		[armor_types.armored] = damage_lerp_values.lerp_1,
		[armor_types.resistant] = damage_lerp_values.lerp_1,
		[armor_types.player] = damage_lerp_values.lerp_1,
		[armor_types.berserker] = damage_lerp_values.lerp_0_8,
		[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
		[armor_types.void_shield] = damage_lerp_values.lerp_1,
	},
}
local stab_am_p2 = {
	attack = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1,
		[armor_types.armored] = damage_lerp_values.lerp_1,
		[armor_types.resistant] = damage_lerp_values.lerp_1_2,
		[armor_types.player] = damage_lerp_values.no_damage,
		[armor_types.berserker] = damage_lerp_values.lerp_1,
		[armor_types.super_armor] = damage_lerp_values.lerp_0_7,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_9,
		[armor_types.void_shield] = damage_lerp_values.lerp_0_8,
	},
	impact = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1,
		[armor_types.armored] = damage_lerp_values.lerp_1,
		[armor_types.resistant] = damage_lerp_values.lerp_1,
		[armor_types.player] = damage_lerp_values.lerp_1,
		[armor_types.berserker] = damage_lerp_values.lerp_1,
		[armor_types.super_armor] = damage_lerp_values.lerp_0_9,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
		[armor_types.void_shield] = damage_lerp_values.lerp_1,
	},
}
local power_am_p2 = {
	attack = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1,
		[armor_types.armored] = damage_lerp_values.lerp_1,
		[armor_types.resistant] = damage_lerp_values.lerp_1_25,
		[armor_types.player] = damage_lerp_values.no_damage,
		[armor_types.berserker] = damage_lerp_values.lerp_1,
		[armor_types.super_armor] = damage_lerp_values.lerp_0_75,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
		[armor_types.void_shield] = damage_lerp_values.lerp_0_9,
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
local power_stab_am_p2 = {
	attack = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1,
		[armor_types.armored] = damage_lerp_values.lerp_1,
		[armor_types.resistant] = damage_lerp_values.lerp_1_5,
		[armor_types.player] = damage_lerp_values.no_damage,
		[armor_types.berserker] = damage_lerp_values.lerp_1,
		[armor_types.super_armor] = damage_lerp_values.lerp_0_8,
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
local heavy_sword_am_p2 = {
	attack = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1,
		[armor_types.armored] = damage_lerp_values.lerp_0_9,
		[armor_types.resistant] = damage_lerp_values.lerp_0_9,
		[armor_types.player] = damage_lerp_values.no_damage,
		[armor_types.berserker] = damage_lerp_values.lerp_1,
		[armor_types.super_armor] = damage_lerp_values.lerp_0_7,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_9,
		[armor_types.void_shield] = damage_lerp_values.lerp_0_8,
	},
	impact = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1,
		[armor_types.armored] = damage_lerp_values.lerp_1,
		[armor_types.resistant] = damage_lerp_values.lerp_1,
		[armor_types.player] = damage_lerp_values.lerp_1,
		[armor_types.berserker] = damage_lerp_values.lerp_1,
		[armor_types.super_armor] = damage_lerp_values.lerp_0_9,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
		[armor_types.void_shield] = damage_lerp_values.lerp_1,
	},
}

damage_templates.light_sword_p2 = {
	finesse_ability_damage_multiplier = 1.5,
	stagger_category = "melee",
	cleave_distribution = light_cleave,
	damage_type = damage_types.metal_slashing_medium,
	gibbing_power = gibbing_power.light,
	gibbing_type = gibbing_types.sawing,
	gib_push_force = GibbingSettings.gib_push_force.sawing_medium,
	melee_attack_strength = melee_attack_strengths.light,
	wounds_template = WoundsTemplates.power_sword,
	armor_damage_modifier = cutting_am_p2,
	targets = {
		{
			armor_damage_modifier = cutting_am_p2,
			boost_curve_multiplier_finesse = {
				0.5,
				1,
			},
			power_distribution = {
				attack = {
					120,
					200,
				},
				impact = {
					5,
					9,
				},
			},
		},
		{
			armor_damage_modifier = cutting_am_p2,
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
		},
		{
			armor_damage_modifier = cutting_am_p2,
			power_distribution = {
				attack = {
					60,
					130,
				},
				impact = {
					3,
					7,
				},
			},
		},
		{
			armor_damage_modifier = cutting_am_p2,
			power_distribution = {
				attack = {
					40,
					90,
				},
				impact = {
					3,
					7,
				},
			},
		},
		{
			armor_damage_modifier = cutting_am_p2,
			power_distribution = {
				attack = {
					30,
					60,
				},
				impact = {
					3,
					6,
				},
			},
		},
		default_target = {
			armor_damage_modifier = cutting_am_p2,
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
damage_templates.light_sword_active_p2 = {
	finesse_ability_damage_multiplier = 1.5,
	stagger_category = "melee",
	weapon_special = true,
	cleave_distribution = big_cleave,
	damage_type = damage_types.power_sword,
	gibbing_power = gibbing_power.heavy,
	gibbing_type = gibbing_types.sawing,
	gib_push_force = GibbingSettings.gib_push_force.sawing_medium,
	melee_attack_strength = melee_attack_strengths.light,
	wounds_template = WoundsTemplates.power_sword_active,
	armor_damage_modifier = power_am_p2,
	targets = {
		{
			armor_damage_modifier = power_am_p2,
			boost_curve_multiplier_finesse = {
				0.5,
				1,
			},
			power_distribution = {
				attack = {
					180,
					260,
				},
				impact = {
					6,
					10,
				},
			},
		},
		{
			armor_damage_modifier = power_am_p2,
			boost_curve_multiplier_finesse = {
				0.4,
				0.8,
			},
			power_distribution = {
				attack = {
					150,
					220,
				},
				impact = {
					5,
					9,
				},
			},
		},
		{
			armor_damage_modifier = power_am_p2,
			power_distribution = {
				attack = {
					110,
					180,
				},
				impact = {
					4,
					8,
				},
			},
		},
		{
			armor_damage_modifier = power_am_p2,
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
		},
		{
			armor_damage_modifier = power_am_p2,
			power_distribution = {
				attack = {
					50,
					100,
				},
				impact = {
					3,
					7,
				},
			},
		},
		{
			armor_damage_modifier = cutting_am_p2,
			power_distribution = {
				attack = {
					40,
					80,
				},
				impact = {
					3,
					7,
				},
			},
		},
		{
			armor_damage_modifier = cutting_am_p2,
			power_distribution = {
				attack = {
					30,
					60,
				},
				impact = {
					3,
					6,
				},
			},
		},
		default_target = {
			armor_damage_modifier = power_am_p2,
			power_distribution = {
				attack = {
					25,
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
damage_templates.light_sword_tank_p2 = {
	stagger_category = "melee",
	cleave_distribution = medium_cleave,
	damage_type = damage_types.metal_slashing_medium,
	gibbing_power = gibbing_power.light,
	gibbing_type = gibbing_types.sawing,
	gib_push_force = GibbingSettings.gib_push_force.sawing_medium,
	melee_attack_strength = melee_attack_strengths.light,
	wounds_template = WoundsTemplates.power_sword,
	armor_damage_modifier = cutting_am_p2,
	targets = {
		{
			armor_damage_modifier = cutting_am_p2,
			boost_curve_multiplier_finesse = {
				0.3,
				0.6,
			},
			power_distribution = {
				attack = {
					100,
					180,
				},
				impact = {
					6,
					12,
				},
			},
		},
		{
			armor_damage_modifier = cutting_am_p2,
			power_distribution = {
				attack = {
					80,
					140,
				},
				impact = {
					5,
					10,
				},
			},
		},
		{
			armor_damage_modifier = cutting_am_p2,
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
		{
			armor_damage_modifier = cutting_am_p2,
			power_distribution = {
				attack = {
					40,
					60,
				},
				impact = {
					4,
					8,
				},
			},
		},
		{
			armor_damage_modifier = cutting_am_p2,
			power_distribution = {
				attack = {
					20,
					40,
				},
				impact = {
					4,
					8,
				},
			},
		},
		default_target = {
			armor_damage_modifier = cutting_am_p2,
			power_distribution = {
				attack = {
					10,
					30,
				},
				impact = {
					3,
					6,
				},
			},
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
}
damage_templates.light_sword_tank_active_p2 = {
	stagger_category = "melee",
	weapon_special = true,
	cleave_distribution = big_cleave,
	damage_type = damage_types.power_sword,
	gibbing_power = gibbing_power.heavy,
	gibbing_type = gibbing_types.sawing,
	gib_push_force = GibbingSettings.gib_push_force.sawing_medium,
	melee_attack_strength = melee_attack_strengths.light,
	wounds_template = WoundsTemplates.power_sword_active,
	armor_damage_modifier = power_am_p2,
	targets = {
		{
			armor_damage_modifier = power_am_p2,
			boost_curve_multiplier_finesse = {
				0.4,
				0.8,
			},
			power_distribution = {
				attack = {
					150,
					230,
				},
				impact = {
					7,
					14,
				},
			},
		},
		{
			armor_damage_modifier = power_am_p2,
			power_distribution = {
				attack = {
					120,
					190,
				},
				impact = {
					6,
					12,
				},
			},
		},
		{
			armor_damage_modifier = power_am_p2,
			power_distribution = {
				attack = {
					80,
					150,
				},
				impact = {
					5,
					10,
				},
			},
		},
		{
			armor_damage_modifier = power_am_p2,
			power_distribution = {
				attack = {
					60,
					110,
				},
				impact = {
					5,
					10,
				},
			},
		},
		{
			armor_damage_modifier = power_am_p2,
			power_distribution = {
				attack = {
					50,
					80,
				},
				impact = {
					4,
					8,
				},
			},
		},
		{
			armor_damage_modifier = cutting_am_p2,
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
		{
			armor_damage_modifier = cutting_am_p2,
			power_distribution = {
				attack = {
					30,
					50,
				},
				impact = {
					4,
					8,
				},
			},
		},
		default_target = {
			armor_damage_modifier = power_am_p2,
			power_distribution = {
				attack = {
					25,
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
}
damage_templates.light_sword_smiter_p2 = {
	finesse_ability_damage_multiplier = 2,
	stagger_category = "melee",
	cleave_distribution = single_cleave,
	damage_type = damage_types.metal_slashing_medium,
	gibbing_power = gibbing_power.light,
	gibbing_type = gibbing_types.sawing,
	gib_push_force = GibbingSettings.gib_push_force.sawing_medium,
	melee_attack_strength = melee_attack_strengths.light,
	wounds_template = WoundsTemplates.power_sword,
	armor_damage_modifier = cutting_am_p2,
	targets = {
		{
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_1,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
					[armor_types.player] = damage_lerp_values.no_damage,
					[armor_types.berserker] = damage_lerp_values.lerp_1,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_4,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_1,
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_75,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_75,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_1,
				},
			},
			boost_curve_multiplier_finesse = {
				0.8,
				1.6,
			},
			power_distribution = {
				attack = {
					150,
					270,
				},
				impact = {
					5,
					10,
				},
			},
		},
		{
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_1,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
					[armor_types.player] = damage_lerp_values.no_damage,
					[armor_types.berserker] = damage_lerp_values.lerp_1,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_4,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_1,
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_75,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_75,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_1,
				},
			},
			boost_curve_multiplier_finesse = {
				0.5,
				1,
			},
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
		default_target = {
			armor_damage_modifier = cutting_am_p2,
			power_distribution = {
				attack = {
					15,
					40,
				},
				impact = {
					3,
					7,
				},
			},
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
}
damage_templates.light_sword_smiter_active_p2 = {
	finesse_ability_damage_multiplier = 2,
	stagger_category = "melee",
	weapon_special = true,
	cleave_distribution = medium_cleave,
	damage_type = damage_types.power_sword,
	gibbing_power = gibbing_power.medium,
	gibbing_type = gibbing_types.sawing,
	gib_push_force = GibbingSettings.gib_push_force.sawing_medium,
	melee_attack_strength = melee_attack_strengths.light,
	wounds_template = WoundsTemplates.power_sword_active,
	armor_damage_modifier = power_am_p2,
	targets = {
		{
			armor_damage_modifier = power_am_p2,
			boost_curve_multiplier_finesse = {
				0.8,
				1.6,
			},
			power_distribution = {
				attack = {
					190,
					330,
				},
				impact = {
					7,
					12,
				},
			},
		},
		{
			armor_damage_modifier = power_am_p2,
			power_distribution = {
				attack = {
					130,
					220,
				},
				impact = {
					5,
					9,
				},
			},
			boost_curve_multiplier_finesse = {
				0.6,
				1.2,
			},
		},
		{
			armor_damage_modifier = power_am_p2,
			power_distribution = {
				attack = {
					50,
					120,
				},
				impact = {
					5,
					9,
				},
			},
		},
		default_target = {
			armor_damage_modifier = power_am_p2,
			power_distribution = {
				attack = {
					25,
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
}
damage_templates.light_sword_stab_p2 = {
	finesse_ability_damage_multiplier = 2,
	stagger_category = "melee",
	cleave_distribution = single_cleave,
	damage_type = damage_types.metal_slashing_medium,
	gibbing_power = gibbing_power.light,
	gibbing_type = gibbing_types.sawing,
	gib_push_force = GibbingSettings.gib_push_force.sawing_medium,
	melee_attack_strength = melee_attack_strengths.light,
	wounds_template = WoundsTemplates.power_sword,
	armor_damage_modifier = stab_am_p2,
	targets = {
		{
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_1,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
					[armor_types.player] = damage_lerp_values.no_damage,
					[armor_types.berserker] = damage_lerp_values.lerp_1,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_1,
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_75,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_75,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_1,
				},
			},
			boost_curve_multiplier_finesse = {
				1,
				2,
			},
			power_distribution = {
				attack = {
					150,
					300,
				},
				impact = {
					7,
					12,
				},
			},
		},
		{
			boost_curve_multiplier_finesse = {
				0.5,
				1,
			},
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
		},
		default_target = {
			armor_damage_modifier = cutting_am_p2,
			power_distribution = {
				attack = {
					20,
					40,
				},
				impact = {
					2,
					6,
				},
			},
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
}
damage_templates.light_sword_stab_active_p2 = {
	finesse_ability_damage_multiplier = 2,
	ignore_stagger_reduction = true,
	stagger_category = "melee",
	weapon_special = true,
	cleave_distribution = light_cleave,
	damage_type = damage_types.power_sword,
	gibbing_power = gibbing_power.medium,
	gibbing_type = gibbing_types.sawing,
	gib_push_force = GibbingSettings.gib_push_force.sawing_medium,
	melee_attack_strength = melee_attack_strengths.light,
	wounds_template = WoundsTemplates.power_sword_active,
	armor_damage_modifier = power_stab_am_p2,
	targets = {
		{
			armor_damage_modifier = power_stab_am_p2,
			boost_curve_multiplier_finesse = {
				1,
				2,
			},
			power_distribution = {
				attack = {
					200,
					400,
				},
				impact = {
					7,
					12,
				},
			},
		},
		{
			armor_damage_modifier = power_am_p2,
			power_distribution = {
				attack = {
					90,
					180,
				},
				impact = {
					5,
					9,
				},
			},
			boost_curve_multiplier_finesse = {
				0.5,
				1,
			},
		},
		{
			armor_damage_modifier = power_am_p2,
			power_distribution = {
				attack = {
					40,
					90,
				},
				impact = {
					6,
					8,
				},
			},
		},
		default_target = {
			armor_damage_modifier = power_am_p2,
			power_distribution = {
				attack = {
					20,
					50,
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
damage_templates.heavy_sword_p2 = {
	finesse_ability_damage_multiplier = 1.5,
	ragdoll_push_force = 150,
	stagger_category = "melee",
	cleave_distribution = medium_cleave,
	damage_type = damage_types.metal_slashing_medium,
	gibbing_power = gibbing_power.medium,
	gibbing_type = gibbing_types.sawing,
	gib_push_force = GibbingSettings.gib_push_force.sawing_heavy,
	melee_attack_strength = melee_attack_strengths.heavy,
	wounds_template = WoundsTemplates.power_sword,
	armor_damage_modifier = cutting_am_p2,
	targets = {
		{
			armor_damage_modifier = heavy_sword_am_p2,
			boost_curve_multiplier_finesse = {
				0.4,
				0.8,
			},
			power_distribution = {
				attack = {
					140,
					260,
				},
				impact = {
					9,
					18,
				},
			},
		},
		{
			armor_damage_modifier = heavy_sword_am_p2,
			power_distribution = {
				attack = {
					90,
					190,
				},
				impact = {
					6,
					12,
				},
			},
		},
		{
			armor_damage_modifier = heavy_sword_am_p2,
			power_distribution = {
				attack = {
					60,
					140,
				},
				impact = {
					5,
					10,
				},
			},
		},
		{
			armor_damage_modifier = heavy_sword_am_p2,
			power_distribution = {
				attack = {
					40,
					90,
				},
				impact = {
					3,
					6,
				},
			},
		},
		{
			armor_damage_modifier = heavy_sword_am_p2,
			power_distribution = {
				attack = {
					30,
					70,
				},
				impact = {
					3,
					6,
				},
			},
		},
		default_target = {
			armor_damage_modifier = heavy_sword_am_p2,
			power_distribution = {
				attack = {
					20,
					50,
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
damage_templates.heavy_sword_active_p2 = {
	finesse_ability_damage_multiplier = 1.5,
	ragdoll_push_force = 150,
	stagger_category = "melee",
	weapon_special = true,
	cleave_distribution = big_cleave,
	damage_type = damage_types.metal_slashing_medium,
	gibbing_power = gibbing_power.medium,
	gibbing_type = gibbing_types.sawing,
	gib_push_force = GibbingSettings.gib_push_force.sawing_heavy,
	melee_attack_strength = melee_attack_strengths.heavy,
	wounds_template = WoundsTemplates.power_sword,
	armor_damage_modifier = power_am_p2,
	targets = {
		{
			armor_damage_modifier = power_am_p2,
			boost_curve_multiplier_finesse = {
				0.5,
				1,
			},
			power_distribution = {
				attack = {
					250,
					350,
				},
				impact = {
					10,
					18,
				},
			},
		},
		{
			armor_damage_modifier = power_am_p2,
			boost_curve_multiplier_finesse = {
				0.3,
				0.6,
			},
			power_distribution = {
				attack = {
					200,
					280,
				},
				impact = {
					6,
					12,
				},
			},
		},
		{
			armor_damage_modifier = power_am_p2,
			power_distribution = {
				attack = {
					150,
					220,
				},
				impact = {
					5,
					10,
				},
			},
		},
		{
			armor_damage_modifier = power_am_p2,
			power_distribution = {
				attack = {
					90,
					160,
				},
				impact = {
					5,
					10,
				},
			},
		},
		{
			armor_damage_modifier = power_am_p2,
			power_distribution = {
				attack = {
					70,
					110,
				},
				impact = {
					4,
					8,
				},
			},
		},
		{
			armor_damage_modifier = power_am_p2,
			power_distribution = {
				attack = {
					40,
					80,
				},
				impact = {
					4,
					8,
				},
			},
		},
		default_target = {
			armor_damage_modifier = power_am_p2,
			power_distribution = {
				attack = {
					30,
					60,
				},
				impact = {
					3,
					6,
				},
			},
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
}
damage_templates.heavy_sword_tank_p2 = {
	finesse_ability_damage_multiplier = 1.5,
	ragdoll_push_force = 150,
	stagger_category = "melee",
	cleave_distribution = large_cleave,
	damage_type = damage_types.metal_slashing_medium,
	gibbing_power = gibbing_power.medium,
	gibbing_type = gibbing_types.sawing,
	gib_push_force = GibbingSettings.gib_push_force.sawing_heavy,
	melee_attack_strength = melee_attack_strengths.heavy,
	wounds_template = WoundsTemplates.power_sword,
	armor_damage_modifier = cutting_am_p2,
	targets = {
		{
			armor_damage_modifier = heavy_sword_am_p2,
			boost_curve_multiplier_finesse = {
				0.2,
				0.5,
			},
			power_distribution = {
				attack = {
					140,
					220,
				},
				impact = {
					10,
					20,
				},
			},
		},
		{
			armor_damage_modifier = heavy_sword_am_p2,
			power_distribution = {
				attack = {
					90,
					160,
				},
				impact = {
					8,
					16,
				},
			},
		},
		{
			armor_damage_modifier = heavy_sword_am_p2,
			power_distribution = {
				attack = {
					60,
					120,
				},
				impact = {
					6,
					12,
				},
			},
		},
		{
			armor_damage_modifier = heavy_sword_am_p2,
			power_distribution = {
				attack = {
					40,
					70,
				},
				impact = {
					5,
					10,
				},
			},
		},
		{
			armor_damage_modifier = heavy_sword_am_p2,
			power_distribution = {
				attack = {
					30,
					50,
				},
				impact = {
					5,
					10,
				},
			},
		},
		default_target = {
			armor_damage_modifier = heavy_sword_am_p2,
			power_distribution = {
				attack = {
					20,
					40,
				},
				impact = {
					4,
					8,
				},
			},
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
}
damage_templates.heavy_sword_tank_active_p2 = {
	ignore_stagger_reduction = true,
	ragdoll_push_force = 150,
	stagger_category = "melee",
	weapon_special = true,
	cleave_distribution = big_cleave,
	damage_type = damage_types.metal_slashing_medium,
	gibbing_power = gibbing_power.medium,
	gibbing_type = gibbing_types.sawing,
	gib_push_force = GibbingSettings.gib_push_force.sawing_heavy,
	melee_attack_strength = melee_attack_strengths.heavy,
	wounds_template = WoundsTemplates.power_sword,
	armor_damage_modifier = power_am_p2,
	targets = {
		{
			armor_damage_modifier = power_am_p2,
			boost_curve_multiplier_finesse = {
				0.4,
				0.8,
			},
			power_distribution = {
				attack = {
					240,
					320,
				},
				impact = {
					11,
					22,
				},
			},
		},
		{
			armor_damage_modifier = power_am_p2,
			power_distribution = {
				attack = {
					180,
					250,
				},
				impact = {
					8,
					16,
				},
			},
		},
		{
			armor_damage_modifier = power_am_p2,
			power_distribution = {
				attack = {
					130,
					190,
				},
				impact = {
					6,
					12,
				},
			},
		},
		{
			armor_damage_modifier = power_am_p2,
			power_distribution = {
				attack = {
					70,
					130,
				},
				impact = {
					5,
					10,
				},
			},
		},
		{
			armor_damage_modifier = power_am_p2,
			power_distribution = {
				attack = {
					50,
					90,
				},
				impact = {
					5,
					10,
				},
			},
		},
		{
			armor_damage_modifier = power_am_p2,
			power_distribution = {
				attack = {
					40,
					70,
				},
				impact = {
					4,
					8,
				},
			},
		},
		{
			armor_damage_modifier = power_am_p2,
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
			armor_damage_modifier = power_am_p2,
			power_distribution = {
				attack = {
					30,
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
}
damage_templates.heavy_sword_smiter_p2 = {
	finesse_ability_damage_multiplier = 2,
	ragdoll_push_force = 150,
	stagger_category = "melee",
	cleave_distribution = light_cleave,
	damage_type = damage_types.metal_slashing_medium,
	gibbing_power = gibbing_power.medium,
	gibbing_type = gibbing_types.sawing,
	gib_push_force = GibbingSettings.gib_push_force.sawing_heavy,
	melee_attack_strength = melee_attack_strengths.heavy,
	wounds_template = WoundsTemplates.power_sword,
	armor_damage_modifier = cutting_am_p2,
	targets = {
		{
			armor_damage_modifier = heavy_sword_am_p2,
			boost_curve_multiplier_finesse = {
				0.8,
				1.6,
			},
			power_distribution = {
				attack = {
					230,
					320,
				},
				impact = {
					10,
					20,
				},
			},
		},
		{
			armor_damage_modifier = heavy_sword_am_p2,
			power_distribution = {
				attack = {
					110,
					170,
				},
				impact = {
					6,
					12,
				},
			},
		},
		{
			armor_damage_modifier = heavy_sword_am_p2,
			power_distribution = {
				attack = {
					40,
					60,
				},
				impact = {
					5,
					10,
				},
			},
		},
		default_target = {
			armor_damage_modifier = heavy_sword_am_p2,
			power_distribution = {
				attack = {
					10,
					50,
				},
				impact = {
					4,
					8,
				},
			},
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
}
damage_templates.heavy_sword_smiter_active_p2 = {
	finesse_ability_damage_multiplier = 2,
	ignore_stagger_reduction = true,
	ragdoll_push_force = 150,
	stagger_category = "melee",
	weapon_special = true,
	cleave_distribution = medium_cleave,
	damage_type = damage_types.metal_slashing_medium,
	gibbing_power = gibbing_power.medium,
	gibbing_type = gibbing_types.sawing,
	gib_push_force = GibbingSettings.gib_push_force.sawing_heavy,
	melee_attack_strength = melee_attack_strengths.heavy,
	wounds_template = WoundsTemplates.power_sword,
	armor_damage_modifier = power_am_p2,
	targets = {
		{
			armor_damage_modifier = power_am_p2,
			boost_curve_multiplier_finesse = {
				0.9,
				1.8,
			},
			power_distribution = {
				attack = {
					300,
					500,
				},
				impact = {
					11,
					22,
				},
			},
		},
		{
			armor_damage_modifier = power_am_p2,
			boost_curve_multiplier_finesse = {
				0.8,
				1.6,
			},
			power_distribution = {
				attack = {
					125,
					250,
				},
				impact = {
					6,
					12,
				},
			},
		},
		{
			armor_damage_modifier = power_am_p2,
			power_distribution = {
				attack = {
					80,
					160,
				},
				impact = {
					5,
					10,
				},
			},
		},
		{
			armor_damage_modifier = power_am_p2,
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
		default_target = {
			armor_damage_modifier = power_am_p2,
			power_distribution = {
				attack = {
					30,
					70,
				},
				impact = {
					4,
					8,
				},
			},
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
}

return {
	base_templates = damage_templates,
	overrides = overrides,
}
