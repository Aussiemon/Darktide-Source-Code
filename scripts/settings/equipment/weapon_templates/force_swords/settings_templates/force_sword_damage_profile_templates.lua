-- chunkname: @scripts/settings/equipment/weapon_templates/force_swords/settings_templates/force_sword_damage_profile_templates.lua

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
local big_cleave = DamageProfileSettings.big_cleave
local default_shield_override_stagger_strength = 4

damage_templates.heavy_force_sword = {
	force_weapon_damage = true,
	ragdoll_push_force = 50,
	stagger_category = "melee",
	sticky_attack = false,
	cleave_distribution = medium_cleave,
	gibbing_power = GibbingPower.light,
	gibbing_type = GibbingTypes.sawing,
	melee_attack_strength = melee_attack_strengths.heavy,
	wounds_template = WoundsTemplates.force_sword,
	gib_push_force = GibbingSettings.gib_push_force.force_sword,
	shield_override_stagger_strength = default_shield_override_stagger_strength,
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_0_5,
			[armor_types.resistant] = damage_lerp_values.lerp_1,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_0_5,
			[armor_types.super_armor] = damage_lerp_values.no_damage,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_75,
			[armor_types.void_shield] = damage_lerp_values.lerp_1,
		},
		impact = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_0_5,
			[armor_types.resistant] = damage_lerp_values.lerp_1,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_0_5,
			[armor_types.super_armor] = damage_lerp_values.lerp_1,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_75,
			[armor_types.void_shield] = damage_lerp_values.lerp_1,
		},
	},
	targets = {
		{
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_1,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_1,
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
			},
			power_distribution = {
				attack = {
					100,
					200,
				},
				impact = {
					4,
					8,
				},
			},
			boost_curve_multiplier_finesse = {
				1,
				3,
			},
			power_level_multiplier = {
				0.8,
				1.6,
			},
		},
		{
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
		},
		default_target = {
			power_distribution = {
				attack = {
					50,
					100,
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
overrides.heavy_force_sword_stab = {
	parent_template_name = "heavy_force_sword",
	overrides = {
		{
			"shield_stagger_category",
			"melee",
		},
		{
			"ignore_stagger_reduction",
			true,
		},
		{
			"cleave_distribution",
			"attack",
			1.5,
		},
		{
			"cleave_distribution",
			"impact",
			1.5,
		},
		{
			"weakspot_stagger_resistance_modifier",
			0.001,
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
			2,
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
				6,
				12,
			},
		},
		{
			"targets",
			1,
			"boost_curve_multiplier_finesse",
			{
				1.5,
				3,
			},
		},
		{
			"targets",
			1,
			"armor_damage_modifier",
			"attack",
			"resistant",
			damage_lerp_values.lerp_1,
		},
		{
			"targets",
			1,
			"armor_damage_modifier",
			"attack",
			"super_armor",
			damage_lerp_values.lerp_0_6,
		},
	},
}
overrides.heavy_force_sword_smiter = {
	parent_template_name = "heavy_force_sword",
	overrides = {
		{
			"targets",
			1,
			"power_distribution",
			"attack",
			{
				150,
				350,
			},
		},
		{
			"targets",
			2,
			"power_distribution",
			"attack",
			{
				60,
				130,
			},
		},
		{
			"targets",
			1,
			"power_distribution",
			"impact",
			{
				7,
				15,
			},
		},
		{
			"targets",
			1,
			"boost_curve_multiplier_finesse",
			{
				1.2,
				3,
			},
		},
		{
			"cleave_distribution",
			single_cleave,
		},
	},
}
damage_templates.heavy_force_sword_active = {
	force_weapon_damage = true,
	ignore_shield = true,
	ignore_stagger_reduction = true,
	ragdoll_only = true,
	ragdoll_push_force = 0,
	stagger_category = "sticky",
	stagger_override = "sticky",
	sticky_attack = false,
	weapon_special = true,
	cleave_distribution = medium_cleave,
	gibbing_power = GibbingPower.medium,
	gibbing_type = GibbingTypes.warp,
	wounds_template = WoundsTemplates.force_sword_active,
	melee_attack_strength = melee_attack_strengths.heavy,
	gib_push_force = GibbingSettings.gib_push_force.force_sword,
	shield_override_stagger_strength = default_shield_override_stagger_strength,
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1_5,
			[armor_types.armored] = damage_lerp_values.lerp_0_5,
			[armor_types.resistant] = damage_lerp_values.lerp_2,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_1,
			[armor_types.super_armor] = damage_lerp_values.no_damage,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_75,
			[armor_types.void_shield] = damage_lerp_values.lerp_1,
		},
		impact = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_0_5,
			[armor_types.resistant] = damage_lerp_values.lerp_1,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_0_5,
			[armor_types.super_armor] = damage_lerp_values.lerp_1,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_75,
			[armor_types.void_shield] = damage_lerp_values.lerp_1,
		},
	},
	targets = {
		{
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1_5,
					[armor_types.armored] = damage_lerp_values.lerp_2,
					[armor_types.resistant] = damage_lerp_values.lerp_2,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_1_5,
					[armor_types.super_armor] = damage_lerp_values.lerp_1,
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
					100,
					120,
				},
				impact = {
					20,
					25,
				},
			},
			finesse_boost = {
				[armor_types.unarmored] = 0.75,
				[armor_types.disgustingly_resilient] = 0.75,
			},
			boost_curve_multiplier_finesse = {
				0.25,
				0.5,
			},
			power_level_multiplier = {
				0.8,
				1.6,
			},
		},
		{
			power_distribution = {
				attack = {
					85,
					115,
				},
				impact = {
					10,
					20,
				},
			},
		},
		default_target = {
			power_distribution = {
				attack = {
					60,
					90,
				},
				impact = {
					5,
					15,
				},
			},
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
}
overrides.heavy_force_sword_flat = {
	parent_template_name = "heavy_force_sword_active",
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
			"ignore_stagger_reduction",
			true,
		},
		{
			"wounds_template",
			WoundsTemplates.force_sword_active,
		},
		{
			"targets",
			1,
			"power_distribution",
			"attack",
			{
				0,
				0,
			},
		},
		{
			"sticky_attack",
			true,
		},
		{
			"cleave_distribution",
			"attack",
			0.005,
		},
		{
			"cleave_distribution",
			"impact",
			0.005,
		},
	},
}
overrides.heavy_force_sword_sticky = {
	parent_template_name = "heavy_force_sword_active",
	overrides = {
		{
			"stagger_category",
			"killshot",
		},
		{
			"stagger_override",
			"killshot",
		},
		{
			"shield_stagger_category",
			"melee",
		},
		{
			"ignore_stagger_reduction",
			true,
		},
		{
			"sticky_attack",
			true,
		},
		{
			"wounds_template",
			WoundsTemplates.force_sword_active,
		},
		{
			"targets",
			1,
			"power_distribution",
			"attack",
			{
				10,
				20,
			},
		},
		{
			"ragdoll_push_force",
			400,
		},
	},
}
overrides.heavy_force_sword_sticky_last = {
	parent_template_name = "heavy_force_sword_active",
	overrides = {
		{
			"stagger_category",
			"melee",
		},
		{
			"stagger_override",
			"medium",
		},
		{
			"shield_stagger_category",
			"melee",
		},
		{
			"ignore_stagger_reduction",
			true,
		},
		{
			"sticky_attack",
			true,
		},
		{
			"wounds_template",
			WoundsTemplates.force_sword_active,
		},
		{
			"targets",
			1,
			"power_distribution",
			"attack",
			{
				400,
				600,
			},
		},
		{
			"ragdoll_push_force",
			400,
		},
	},
}
damage_templates.light_force_sword = {
	force_weapon_damage = true,
	ragdoll_push_force = 50,
	stagger_category = "melee",
	sticky_attack = false,
	cleave_distribution = light_cleave,
	gibbing_power = GibbingPower.light,
	gibbing_type = GibbingTypes.sawing,
	melee_attack_strength = melee_attack_strengths.light,
	gib_push_force = GibbingSettings.gib_push_force.force_sword,
	wounds_template = WoundsTemplates.force_sword,
	shield_override_stagger_strength = default_shield_override_stagger_strength,
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_0_75,
			[armor_types.resistant] = damage_lerp_values.lerp_1,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_0_75,
			[armor_types.super_armor] = damage_lerp_values.lerp_0_01,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
			[armor_types.void_shield] = damage_lerp_values.lerp_1,
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
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_75,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_75,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_01,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
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
			},
			power_distribution = {
				attack = {
					50,
					110,
				},
				impact = {
					3,
					6,
				},
			},
			boost_curve_multiplier_finesse = {
				1,
				3,
			},
			power_level_multiplier = {
				0.8,
				1.6,
			},
		},
		{
			power_distribution = {
				attack = {
					50,
					100,
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
					30,
					40,
				},
				impact = {
					1.5,
					3,
				},
			},
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
}
damage_templates.light_force_sword_active = {
	force_weapon_damage = true,
	ignore_shield = true,
	ignore_stagger_reduction = true,
	ragdoll_only = true,
	ragdoll_push_force = 0,
	stagger_category = "killshot",
	stagger_override = "killshot",
	sticky_attack = false,
	weapon_special = true,
	cleave_distribution = single_cleave,
	gibbing_power = GibbingPower.light,
	gibbing_type = GibbingTypes.warp,
	melee_attack_strength = melee_attack_strengths.light,
	gib_push_force = GibbingSettings.gib_push_force.force_sword,
	wounds_template = WoundsTemplates.force_sword_active,
	shield_override_stagger_strength = default_shield_override_stagger_strength,
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1_5,
			[armor_types.armored] = damage_lerp_values.lerp_2,
			[armor_types.resistant] = damage_lerp_values.lerp_2,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_1_5,
			[armor_types.super_armor] = damage_lerp_values.lerp_1,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
			[armor_types.void_shield] = damage_lerp_values.lerp_1,
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
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1_5,
					[armor_types.armored] = damage_lerp_values.lerp_2,
					[armor_types.resistant] = damage_lerp_values.lerp_2,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_1_5,
					[armor_types.super_armor] = damage_lerp_values.lerp_1,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
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
			},
			power_distribution = {
				attack = {
					100,
					120,
				},
				impact = {
					10,
					20,
				},
			},
			boost_curve_multiplier_finesse = {
				0.25,
				0.5,
			},
			power_level_multiplier = {
				0.8,
				1.6,
			},
		},
		{
			power_distribution = {
				attack = {
					35,
					65,
				},
				impact = {
					5,
					15,
				},
			},
		},
		default_target = {
			power_distribution = {
				attack = {
					10,
					40,
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
overrides.light_force_sword_sticky = {
	parent_template_name = "light_force_sword_active",
	overrides = {
		{
			"stagger_category",
			"killshot",
		},
		{
			"stagger_override",
			"killshot",
		},
		{
			"shield_stagger_category",
			"melee",
		},
		{
			"shield_stagger_category",
			"melee",
		},
		{
			"sticky_attack",
			true,
		},
		{
			"wounds_template",
			WoundsTemplates.force_sword_active,
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
				20,
			},
		},
		{
			"always_ragdoll",
			true,
		},
		{
			"ragdoll_push_force",
			300,
		},
	},
}
overrides.light_force_sword_sticky_last = {
	parent_template_name = "light_force_sword_active",
	overrides = {
		{
			"stagger_category",
			"melee",
		},
		{
			"stagger_override",
			"medium",
		},
		{
			"shield_stagger_category",
			"melee",
		},
		{
			"ignore_stagger_reduction",
			true,
		},
		{
			"sticky_attack",
			true,
		},
		{
			"wounds_template",
			WoundsTemplates.force_sword_active,
		},
		{
			"targets",
			1,
			"power_distribution",
			"attack",
			{
				300,
				400,
			},
		},
		{
			"always_ragdoll",
			true,
		},
		{
			"ragdoll_push_force",
			300,
		},
	},
}
damage_templates.light_force_sword_linesman = {
	force_weapon_damage = true,
	ragdoll_push_force = 50,
	stagger_category = "melee",
	sticky_attack = false,
	cleave_distribution = double_cleave,
	gibbing_power = GibbingPower.medium,
	gibbing_type = GibbingTypes.warp,
	wounds_template = WoundsTemplates.force_sword,
	melee_attack_strength = melee_attack_strengths.light,
	gib_push_force = GibbingSettings.gib_push_force.force_sword,
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_1,
			[armor_types.resistant] = damage_lerp_values.lerp_1,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_0_5,
			[armor_types.super_armor] = damage_lerp_values.no_damage,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_5,
			[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
		},
		impact = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.no_damage,
			[armor_types.resistant] = damage_lerp_values.lerp_1,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_0_5,
			[armor_types.super_armor] = damage_lerp_values.no_damage,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_5,
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
					[armor_types.berserker] = damage_lerp_values.lerp_0_5,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_75,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_75,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_5,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_5,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_75,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
				},
			},
			power_distribution = {
				attack = {
					65,
					130,
				},
				impact = {
					15,
					25,
				},
			},
			boost_curve_multiplier_finesse = {
				1,
				3,
			},
			power_level_multiplier = {
				0.8,
				1.6,
			},
		},
		{
			power_distribution = {
				attack = {
					45,
					75,
				},
				impact = {
					5,
					15,
				},
			},
		},
		default_target = {
			power_distribution = {
				attack = {
					25,
					55,
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
damage_templates.light_force_sword_stab = {
	force_weapon_damage = true,
	gibbing_power = 0,
	ragdoll_push_force = 50,
	stagger_category = "melee",
	sticky_attack = false,
	cleave_distribution = single_cleave,
	gibbing_type = GibbingTypes.sawing,
	wounds_template = WoundsTemplates.force_sword,
	melee_attack_strength = melee_attack_strengths.light,
	gib_push_force = GibbingSettings.gib_push_force.force_sword,
	shield_override_stagger_strength = default_shield_override_stagger_strength,
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_0_5,
			[armor_types.resistant] = damage_lerp_values.lerp_1,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_0_8,
			[armor_types.super_armor] = damage_lerp_values.no_damage,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_9,
			[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
		},
		impact = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_0_5,
			[armor_types.resistant] = damage_lerp_values.lerp_1,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_0_5,
			[armor_types.super_armor] = damage_lerp_values.no_damage,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_75,
			[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
		},
	},
	targets = {
		{
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_1,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_8,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_25,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_9,
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
			},
			power_distribution = {
				attack = {
					100,
					200,
				},
				impact = {
					5,
					10,
				},
			},
			boost_curve_multiplier_finesse = {
				1.25,
				3.5,
			},
			power_level_multiplier = {
				0.8,
				1.6,
			},
		},
		{
			power_distribution = {
				attack = {
					35,
					65,
				},
				impact = {
					5,
					10,
				},
			},
		},
		default_target = {
			power_distribution = {
				attack = {
					15,
					45,
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
overrides.light_force_sword_stab_sticky = {
	parent_template_name = "light_force_sword_stab",
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
			"sticky_attack",
			true,
		},
		{
			"wounds_template",
			WoundsTemplates.force_sword,
		},
		{
			"targets",
			1,
			"power_distribution",
			"attack",
			{
				200,
				300,
			},
		},
	},
}
damage_templates.force_sword_push_followup_fling = {
	ignore_stagger_reduction = true,
	is_push = true,
	shield_override_stagger_strength = 60,
	stagger_category = "melee",
	power_distribution = {
		attack = 5,
		impact = 100,
	},
	armor_damage_modifier = {
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
			[armor_types.resistant] = 0.5,
			[armor_types.player] = 0,
			[armor_types.berserker] = 1,
			[armor_types.super_armor] = 1,
			[armor_types.disgustingly_resilient] = 1,
			[armor_types.void_shield] = 0,
		},
	},
	targets = {
		default_target = {},
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

damage_templates.forcesword_active_cleave_light = {
	finesse_ability_damage_multiplier = 1.5,
	force_weapon_damage = true,
	ignore_stagger_reduction = true,
	stagger_category = "melee",
	weapon_special = true,
	cleave_distribution = big_cleave,
	damage_type = damage_types.power_sword,
	gibbing_power = GibbingPower.heavy,
	gibbing_type = GibbingTypes.sawing,
	gib_push_force = GibbingSettings.gib_push_force.sawing_medium,
	melee_attack_strength = melee_attack_strengths.light,
	wounds_template = WoundsTemplates.force_sword_active,
	armor_damage_modifier = power_am,
	targets = {
		{
			armor_damage_modifier = power_am,
			boost_curve_multiplier_finesse = {
				0.6,
				1.1,
			},
			power_distribution = {
				attack = {
					300,
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
				1.1,
			},
			power_distribution = {
				attack = {
					150,
					300,
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
				1.1,
			},
			power_distribution = {
				attack = {
					115,
					170,
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
					85,
					130,
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
					95,
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
					45,
					70,
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
					35,
					50,
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
damage_templates.forcesword_active_cleave_heavy = {
	finesse_ability_damage_multiplier = 2,
	force_weapon_damage = true,
	gibbing_power = 10,
	ignore_stagger_reduction = true,
	ragdoll_only = true,
	ragdoll_push_force = 500,
	stagger_category = "melee",
	weapon_special = true,
	cleave_distribution = big_cleave,
	damage_type = damage_types.power_sword,
	gibbing_type = GibbingTypes.default,
	melee_attack_strength = melee_attack_strengths.heavy,
	gib_push_force = GibbingSettings.gib_push_force.sawing_heavy,
	wounds_template = WoundsTemplates.force_sword_active,
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
					275,
					550,
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
					200,
					400,
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
					125,
					250,
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

return {
	base_templates = damage_templates,
	overrides = overrides,
}
