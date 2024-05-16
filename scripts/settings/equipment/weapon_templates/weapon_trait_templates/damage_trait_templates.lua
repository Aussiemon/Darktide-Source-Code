-- chunkname: @scripts/settings/equipment/weapon_templates/weapon_trait_templates/damage_trait_templates.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
local armor_types = ArmorSettings.types
local DEFAULT_LERP_VALUE = WeaponTweakTemplateSettings.DEFAULT_LERP_VALUE
local damage_trait_templates = {}

damage_trait_templates.test_01 = {
	{
		"armor_damage_modifier_ranged",
		"near",
		"attack",
		armor_types.armored,
		0.5,
	},
	{
		"armor_damage_modifier_ranged",
		"far",
		"attack",
		armor_types.armored,
		0.5,
	},
	{
		"ranges",
		"min",
		0.5,
	},
	{
		"ranges",
		"max",
		0.5,
	},
	{
		"power_distribution_ranged",
		"attack",
		"near",
		0,
	},
	{
		"power_distribution_ranged",
		"attack",
		"far",
		0,
	},
	{
		"power_distribution_ranged",
		"impact",
		"near",
		0,
	},
	{
		"power_distribution_ranged",
		"impact",
		"far",
		0,
	},
	{
		"targets",
		"default_target",
		"boost_curve_multiplier_finesse",
		0.5,
	},
	[DEFAULT_LERP_VALUE] = 0.4,
}
damage_trait_templates.default_dps_stat = {
	{
		"armor_damage_modifier_ranged",
		"near",
		"attack",
		armor_types.unarmored,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"armor_damage_modifier_ranged",
		"far",
		"attack",
		armor_types.unarmored,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"armor_damage_modifier_ranged",
		"near",
		"attack",
		armor_types.disgustingly_resilient,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"armor_damage_modifier_ranged",
		"far",
		"attack",
		armor_types.disgustingly_resilient,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"power_distribution",
		"attack",
		{
			max = 0.75,
			min = 0.25,
		},
	},
}
damage_trait_templates.high_bot_dps_stat = {
	{
		"armor_damage_modifier_ranged",
		"near",
		"attack",
		armor_types.unarmored,
		{
			max = 0.75,
			min = 0.75,
		},
	},
	{
		"armor_damage_modifier_ranged",
		"far",
		"attack",
		armor_types.unarmored,
		{
			max = 0.75,
			min = 0.75,
		},
	},
	{
		"armor_damage_modifier_ranged",
		"near",
		"attack",
		armor_types.disgustingly_resilient,
		{
			max = 0.75,
			min = 0.75,
		},
	},
	{
		"armor_damage_modifier_ranged",
		"far",
		"attack",
		armor_types.disgustingly_resilient,
		{
			max = 0.75,
			min = 0.75,
		},
	},
	{
		"power_distribution",
		"attack",
		{
			max = 0.8,
			min = 0.8,
		},
	},
}
damage_trait_templates.high_bot_power_stat = {
	{
		"armor_damage_modifier_ranged",
		"near",
		"attack",
		armor_types.armored,
		{
			max = 0.95,
			min = 0.8,
		},
	},
	{
		"armor_damage_modifier_ranged",
		"far",
		"attack",
		armor_types.armored,
		{
			max = 0.95,
			min = 0.8,
		},
	},
	{
		"armor_damage_modifier_ranged",
		"near",
		"attack",
		armor_types.super_armor,
		{
			max = 0.95,
			min = 0.8,
		},
	},
	{
		"armor_damage_modifier_ranged",
		"far",
		"attack",
		armor_types.super_armor,
		{
			max = 0.95,
			min = 0.8,
		},
	},
	{
		"armor_damage_modifier_ranged",
		"near",
		"attack",
		armor_types.resistant,
		{
			max = 0.95,
			min = 0.8,
		},
	},
	{
		"armor_damage_modifier_ranged",
		"far",
		"attack",
		armor_types.resistant,
		{
			max = 0.95,
			min = 0.8,
		},
	},
	{
		"armor_damage_modifier_ranged",
		"near",
		"attack",
		armor_types.berserker,
		{
			max = 0.95,
			min = 0.8,
		},
	},
	{
		"armor_damage_modifier_ranged",
		"far",
		"attack",
		armor_types.berserker,
		{
			max = 0.95,
			min = 0.8,
		},
	},
	{
		"power_distribution",
		"impact",
		{
			max = 0.95,
			min = 0.95,
		},
	},
}
damage_trait_templates.default_melee_dps_perk = {
	{
		"targets",
		1,
		"power_distribution",
		"attack",
		0.05,
	},
	{
		"targets",
		2,
		"power_distribution",
		"attack",
		0.05,
	},
	{
		"targets",
		"default_target",
		"power_distribution",
		"attack",
		0.05,
	},
}
damage_trait_templates.thumper_shotgun_power_stat = {
	{
		"armor_damage_modifier_ranged",
		"near",
		"attack",
		armor_types.armored,
		{
			max = 0.95,
			min = 0.1,
		},
	},
	{
		"armor_damage_modifier_ranged",
		"near",
		"attack",
		armor_types.super_armor,
		{
			max = 0.95,
			min = 0.1,
		},
	},
	{
		"armor_damage_modifier_ranged",
		"near",
		"attack",
		armor_types.resistant,
		{
			max = 0.95,
			min = 0.1,
		},
	},
	{
		"armor_damage_modifier_ranged",
		"near",
		"attack",
		armor_types.berserker,
		{
			max = 0.95,
			min = 0.1,
		},
	},
	{
		"power_distribution",
		"impact",
		{
			max = 0.95,
			min = 0.1,
		},
	},
}
damage_trait_templates.default_power_stat = {
	{
		"armor_damage_modifier_ranged",
		"near",
		"attack",
		armor_types.armored,
		{
			max = 0.95,
			min = 0.1,
		},
	},
	{
		"armor_damage_modifier_ranged",
		"far",
		"attack",
		armor_types.armored,
		{
			max = 0.95,
			min = 0.1,
		},
	},
	{
		"armor_damage_modifier_ranged",
		"near",
		"attack",
		armor_types.super_armor,
		{
			max = 0.95,
			min = 0.1,
		},
	},
	{
		"armor_damage_modifier_ranged",
		"far",
		"attack",
		armor_types.super_armor,
		{
			max = 0.95,
			min = 0.1,
		},
	},
	{
		"armor_damage_modifier_ranged",
		"near",
		"attack",
		armor_types.resistant,
		{
			max = 0.95,
			min = 0.1,
		},
	},
	{
		"armor_damage_modifier_ranged",
		"far",
		"attack",
		armor_types.resistant,
		{
			max = 0.95,
			min = 0.1,
		},
	},
	{
		"armor_damage_modifier_ranged",
		"near",
		"attack",
		armor_types.berserker,
		{
			max = 0.95,
			min = 0.1,
		},
	},
	{
		"armor_damage_modifier_ranged",
		"far",
		"attack",
		armor_types.berserker,
		{
			max = 0.95,
			min = 0.1,
		},
	},
	{
		"power_distribution",
		"impact",
		{
			max = 0.95,
			min = 0.1,
		},
	},
}
damage_trait_templates.default_dps_perk = {
	{
		"armor_damage_modifier_ranged",
		"near",
		"attack",
		armor_types.unarmored,
		0.05,
	},
	{
		"armor_damage_modifier_ranged",
		"far",
		"attack",
		armor_types.unarmored,
		0.05,
	},
	{
		"armor_damage_modifier_ranged",
		"near",
		"attack",
		armor_types.disgustingly_resilient,
		0.05,
	},
	{
		"armor_damage_modifier_ranged",
		"far",
		"attack",
		armor_types.disgustingly_resilient,
		0.05,
	},
	{
		"power_distribution",
		"attack",
		0.05,
	},
}
damage_trait_templates.default_power_perk = {
	{
		"armor_damage_modifier_ranged",
		"near",
		"attack",
		armor_types.armored,
		0.05,
	},
	{
		"armor_damage_modifier_ranged",
		"far",
		"attack",
		armor_types.armored,
		0.05,
	},
	{
		"armor_damage_modifier_ranged",
		"near",
		"attack",
		armor_types.super_armor,
		0.05,
	},
	{
		"armor_damage_modifier_ranged",
		"far",
		"attack",
		armor_types.super_armor,
		0.05,
	},
	{
		"armor_damage_modifier_ranged",
		"near",
		"attack",
		armor_types.resistant,
		0.05,
	},
	{
		"armor_damage_modifier_ranged",
		"far",
		"attack",
		armor_types.resistant,
		0.05,
	},
	{
		"armor_damage_modifier_ranged",
		"near",
		"attack",
		armor_types.berserker,
		0.05,
	},
	{
		"armor_damage_modifier_ranged",
		"far",
		"attack",
		armor_types.berserker,
		0.05,
	},
	{
		"power_distribution_ranged",
		"impact",
		0.05,
	},
}
damage_trait_templates.default_melee_finesse_stat = {
	{
		"targets",
		1,
		"boost_curve_multiplier_finesse",
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		2,
		"boost_curve_multiplier_finesse",
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		"default_target",
		"boost_curve_multiplier_finesse",
		{
			max = 0.75,
			min = 0.25,
		},
	},
}
damage_trait_templates.default_melee_finesse_perk = {
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
		"targets",
		"default_target",
		"boost_curve_multiplier_finesse",
		0.05,
	},
}
damage_trait_templates.default_melee_dps_stat = {
	{
		"targets",
		1,
		"power_distribution",
		"attack",
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		2,
		"power_distribution",
		"attack",
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		"default_target",
		"power_distribution",
		"attack",
		{
			max = 0.75,
			min = 0.25,
		},
	},
}
damage_trait_templates.default_first_target_stat = {
	{
		"targets",
		1,
		"power_level_multiplier",
		{
			max = 0.75,
			min = 0.25,
		},
	},
}
damage_trait_templates.default_melee_first_target_perk = {
	{
		"targets",
		1,
		"armor_damage_modifier",
		"attack",
		armor_types.unarmored,
		0.05,
	},
	{
		"targets",
		1,
		"armor_damage_modifier",
		"attack",
		armor_types.armored,
		0.05,
	},
	{
		"targets",
		1,
		"armor_damage_modifier",
		"attack",
		armor_types.resistant,
		0.05,
	},
	{
		"targets",
		1,
		"armor_damage_modifier",
		"attack",
		armor_types.berserker,
		0.05,
	},
	{
		"targets",
		1,
		"armor_damage_modifier",
		"attack",
		armor_types.super_armor,
		0.05,
	},
	{
		"targets",
		1,
		"armor_damage_modifier",
		"attack",
		armor_types.disgustingly_resilient,
		0.05,
	},
	{
		"targets",
		1,
		"armor_damage_modifier",
		"attack",
		armor_types.void_shield,
		0.05,
	},
}
damage_trait_templates.default_armor_pierce_stat = {
	{
		"targets",
		1,
		"armor_damage_modifier",
		"attack",
		armor_types.armored,
		{
			max = 0.95,
			min = 0.1,
		},
	},
	{
		"targets",
		1,
		"armor_damage_modifier",
		"attack",
		armor_types.super_armor,
		{
			max = 0.95,
			min = 0.1,
		},
	},
	{
		"targets",
		2,
		"armor_damage_modifier",
		"attack",
		armor_types.armored,
		{
			max = 0.95,
			min = 0.1,
		},
	},
	{
		"targets",
		2,
		"armor_damage_modifier",
		"attack",
		armor_types.super_armor,
		{
			max = 0.95,
			min = 0.1,
		},
	},
	{
		"targets",
		"default_target",
		"armor_damage_modifier",
		"attack",
		armor_types.armored,
		{
			max = 0.95,
			min = 0.1,
		},
	},
	{
		"targets",
		"default_target",
		"armor_damage_modifier",
		"attack",
		armor_types.super_armor,
		{
			max = 0.95,
			min = 0.1,
		},
	},
	{
		"armor_damage_modifier",
		"attack",
		armor_types.armored,
		{
			max = 0.95,
			min = 0.1,
		},
	},
	{
		"armor_damage_modifier",
		"attack",
		armor_types.super_armor,
		{
			max = 0.95,
			min = 0.1,
		},
	},
}
damage_trait_templates.default_armor_pierce_perk = {
	{
		"targets",
		1,
		"armor_damage_modifier",
		"attack",
		armor_types.armored,
		0.05,
	},
	{
		"targets",
		1,
		"armor_damage_modifier",
		"attack",
		armor_types.super_armor,
		0.05,
	},
	{
		"targets",
		2,
		"armor_damage_modifier",
		"attack",
		armor_types.armored,
		0.05,
	},
	{
		"targets",
		2,
		"armor_damage_modifier",
		"attack",
		armor_types.super_armor,
		0.05,
	},
	{
		"targets",
		"default_target",
		"armor_damage_modifier",
		"attack",
		armor_types.armored,
		0.05,
	},
	{
		"targets",
		"default_target",
		"armor_damage_modifier",
		"attack",
		armor_types.super_armor,
		0.05,
	},
	{
		"armor_damage_modifier",
		"attack",
		armor_types.armored,
		0.05,
	},
	{
		"armor_damage_modifier",
		"attack",
		armor_types.super_armor,
		0.05,
	},
}
damage_trait_templates.autopistol_power_stat = {
	{
		"armor_damage_modifier_ranged",
		"near",
		"attack",
		armor_types.armored,
		{
			max = 0.95,
			min = 0.1,
		},
	},
	{
		"armor_damage_modifier_ranged",
		"far",
		"attack",
		armor_types.armored,
		{
			max = 0.95,
			min = 0.1,
		},
	},
	{
		"armor_damage_modifier_ranged",
		"near",
		"attack",
		armor_types.super_armor,
		{
			max = 0.95,
			min = 0.1,
		},
	},
	{
		"armor_damage_modifier_ranged",
		"far",
		"attack",
		armor_types.super_armor,
		{
			max = 0.95,
			min = 0.1,
		},
	},
	{
		"armor_damage_modifier_ranged",
		"near",
		"attack",
		armor_types.resistant,
		{
			max = 0.95,
			min = 0.1,
		},
	},
	{
		"armor_damage_modifier_ranged",
		"far",
		"attack",
		armor_types.resistant,
		{
			max = 0.95,
			min = 0.1,
		},
	},
	{
		"armor_damage_modifier_ranged",
		"near",
		"attack",
		armor_types.berserker,
		{
			max = 0.95,
			min = 0.1,
		},
	},
	{
		"armor_damage_modifier_ranged",
		"far",
		"attack",
		armor_types.berserker,
		{
			max = 0.95,
			min = 0.1,
		},
	},
}
damage_trait_templates.autopistol_control_stat = {
	{
		"armor_damage_modifier_ranged",
		"near",
		"impact",
		armor_types.armored,
		{
			max = 0.95,
			min = 0.1,
		},
	},
	{
		"armor_damage_modifier_ranged",
		"far",
		"impact",
		armor_types.armored,
		{
			max = 0.95,
			min = 0.1,
		},
	},
	{
		"armor_damage_modifier_ranged",
		"near",
		"impact",
		armor_types.super_armor,
		{
			max = 0.95,
			min = 0.1,
		},
	},
	{
		"armor_damage_modifier_ranged",
		"far",
		"impact",
		armor_types.super_armor,
		{
			max = 0.95,
			min = 0.1,
		},
	},
	{
		"armor_damage_modifier_ranged",
		"near",
		"impact",
		armor_types.resistant,
		{
			max = 0.95,
			min = 0.1,
		},
	},
	{
		"armor_damage_modifier_ranged",
		"far",
		"impact",
		armor_types.resistant,
		{
			max = 0.95,
			min = 0.1,
		},
	},
	{
		"armor_damage_modifier_ranged",
		"near",
		"impact",
		armor_types.berserker,
		{
			max = 0.95,
			min = 0.1,
		},
	},
	{
		"armor_damage_modifier_ranged",
		"far",
		"impact",
		armor_types.berserker,
		{
			max = 0.95,
			min = 0.1,
		},
	},
	{
		"suppression_value",
		{
			max = 0.95,
			min = 0.1,
		},
	},
	{
		"on_kill_area_suppression",
		"suppression_value",
		{
			max = 0.95,
			min = 0.1,
		},
	},
	{
		"on_kill_area_suppression",
		"distance",
		{
			max = 0.95,
			min = 0.1,
		},
	},
	{
		"power_distribution",
		"impact",
		{
			max = 0.95,
			min = 0.1,
		},
	},
	{
		"accumulative_stagger_strength_multiplier",
		{
			max = 0.95,
			min = 0.1,
		},
	},
}
damage_trait_templates.shotgun_dps_stat = {
	{
		"armor_damage_modifier_ranged",
		"near",
		"attack",
		armor_types.unarmored,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"armor_damage_modifier_ranged",
		"near",
		"attack",
		armor_types.disgustingly_resilient,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"power_distribution",
		"attack",
		{
			max = 0.75,
			min = 0.25,
		},
	},
}
damage_trait_templates.shotgun_control_stat = {
	{
		"armor_damage_modifier_ranged",
		"near",
		"impact",
		armor_types.armored,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"armor_damage_modifier_ranged",
		"far",
		"impact",
		armor_types.armored,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"armor_damage_modifier_ranged",
		"near",
		"impact",
		armor_types.super_armor,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"armor_damage_modifier_ranged",
		"far",
		"impact",
		armor_types.super_armor,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"armor_damage_modifier_ranged",
		"near",
		"impact",
		armor_types.resistant,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"armor_damage_modifier_ranged",
		"far",
		"impact",
		armor_types.resistant,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"armor_damage_modifier_ranged",
		"near",
		"impact",
		armor_types.berserker,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"armor_damage_modifier_ranged",
		"far",
		"impact",
		armor_types.berserker,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"suppression_value",
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"on_kill_area_suppression",
		"suppression_value",
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"on_kill_area_suppression",
		"distance",
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"power_distribution",
		"impact",
		{
			max = 0.75,
			min = 0.25,
		},
	},
}
damage_trait_templates.flamer_p1_m1_braced_dps_stat = {
	{
		"targets",
		1,
		"power_distribution",
		"attack",
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		2,
		"power_distribution",
		"attack",
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		3,
		"power_distribution",
		"attack",
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		4,
		"power_distribution",
		"attack",
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		5,
		"power_distribution",
		"attack",
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		"default_target",
		"power_distribution",
		"attack",
		{
			max = 0.75,
			min = 0.25,
		},
	},
}
damage_trait_templates.flamer_p1_m1_braced_dps_perk = {
	{
		"targets",
		1,
		"power_distribution",
		"attack",
		0.05,
	},
	{
		"targets",
		2,
		"power_distribution",
		"attack",
		0.05,
	},
	{
		"targets",
		3,
		"power_distribution",
		"attack",
		0.05,
	},
	{
		"targets",
		4,
		"power_distribution",
		"attack",
		0.05,
	},
	{
		"targets",
		5,
		"power_distribution",
		"attack",
		0.05,
	},
	{
		"targets",
		"default_target",
		"power_distribution",
		"attack",
		0.05,
	},
}
damage_trait_templates.forcestaff_p2_m1_braced_dps_stat = {
	{
		"targets",
		1,
		"power_distribution",
		"attack",
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		2,
		"power_distribution",
		"attack",
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		3,
		"power_distribution",
		"attack",
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		4,
		"power_distribution",
		"attack",
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		5,
		"power_distribution",
		"attack",
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		"default_target",
		"power_distribution",
		"attack",
		{
			max = 0.75,
			min = 0.25,
		},
	},
}
damage_trait_templates.ogryn_combatblade_p1_m1_cleave_stat = {
	{
		"cleave_distribution",
		"attack",
		{
			max = 0.95,
			min = 0.05,
		},
	},
	{
		"cleave_distribution",
		"impact",
		{
			max = 0.95,
			min = 0.05,
		},
	},
}
damage_trait_templates.forcestaff_p1_m1_dps_stat = {
	{
		"power_distribution",
		"attack",
		{
			max = 0.75,
			min = 0.25,
		},
	},
}
damage_trait_templates.forcestaff_p1_m1_dps_perk = {
	{
		"power_distribution",
		"attack",
		0.05,
	},
}
damage_trait_templates.forcestaff_p2_m1_dps_stat = {
	{
		"power_distribution",
		"attack",
		{
			max = 0.75,
			min = 0.25,
		},
	},
}
damage_trait_templates.forcestaff_p3_m1_dps_stat = {
	{
		"power_distribution",
		"attack",
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		1,
		"power_distribution",
		"attack",
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		2,
		"power_distribution",
		"attack",
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		3,
		"power_distribution",
		"attack",
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		4,
		"power_distribution",
		"attack",
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		5,
		"power_distribution",
		"attack",
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		"default_target",
		"power_distribution",
		"attack",
		{
			max = 0.75,
			min = 0.25,
		},
	},
}
damage_trait_templates.forcestaff_p3_m1_crit_stat = {
	{
		"crit_mod",
		"attack",
		armor_types.unarmored,
		{
			max = 1,
			min = 0,
		},
	},
	{
		"crit_mod",
		"attack",
		armor_types.armored,
		{
			max = 1,
			min = 0,
		},
	},
	{
		"crit_mod",
		"attack",
		armor_types.resistant,
		{
			max = 1,
			min = 0,
		},
	},
	{
		"crit_mod",
		"attack",
		armor_types.berserker,
		{
			max = 1,
			min = 0,
		},
	},
	{
		"crit_mod",
		"attack",
		armor_types.super_armor,
		{
			max = 1,
			min = 0,
		},
	},
	{
		"crit_mod",
		"attack",
		armor_types.disgustingly_resilient,
		{
			max = 1,
			min = 0,
		},
	},
	{
		"crit_mod",
		"attack",
		armor_types.void_shield,
		{
			max = 1,
			min = 0,
		},
	},
}
damage_trait_templates.forcestaff_p4_m1_dps_stat = {
	{
		"power_distribution",
		"attack",
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		"default_target",
		"power_distribution",
		"attack",
		{
			max = 0.75,
			min = 0.25,
		},
	},
}
damage_trait_templates.ogryn_club_first_target_perk = {
	{
		"targets",
		1,
		"armor_damage_modifier",
		"attack",
		armor_types.unarmored,
		0.05,
	},
	{
		"targets",
		1,
		"armor_damage_modifier",
		"attack",
		armor_types.armored,
		0.05,
	},
	{
		"targets",
		1,
		"armor_damage_modifier",
		"attack",
		armor_types.resistant,
		0.05,
	},
	{
		"targets",
		1,
		"armor_damage_modifier",
		"attack",
		armor_types.berserker,
		0.05,
	},
	{
		"targets",
		1,
		"armor_damage_modifier",
		"attack",
		armor_types.super_armor,
		0.05,
	},
	{
		"targets",
		1,
		"armor_damage_modifier",
		"attack",
		armor_types.disgustingly_resilient,
		0.05,
	},
	{
		"targets",
		1,
		"armor_damage_modifier",
		"attack",
		armor_types.void_shield,
		0.05,
	},
}
damage_trait_templates.thunderhammer_dps_stat = {
	{
		"targets",
		1,
		"power_distribution",
		"attack",
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		2,
		"power_distribution",
		"attack",
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		3,
		"power_distribution",
		"attack",
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		4,
		"power_distribution",
		"attack",
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		5,
		"power_distribution",
		"attack",
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		"default_target",
		"power_distribution",
		"attack",
		{
			max = 0.75,
			min = 0.25,
		},
	},
}
damage_trait_templates.thunderhammer_armor_pierce_stat = {
	{
		"targets",
		1,
		"armor_damage_modifier",
		"attack",
		armor_types.armored,
		{
			max = 0.5,
			min = 0,
		},
	},
	{
		"targets",
		1,
		"armor_damage_modifier",
		"attack",
		armor_types.super_armor,
		{
			max = 0.5,
			min = 0,
		},
	},
	{
		"targets",
		2,
		"armor_damage_modifier",
		"attack",
		armor_types.armored,
		{
			max = 0.5,
			min = 0,
		},
	},
	{
		"targets",
		2,
		"armor_damage_modifier",
		"attack",
		armor_types.super_armor,
		{
			max = 0.5,
			min = 0,
		},
	},
	{
		"targets",
		3,
		"armor_damage_modifier",
		"attack",
		armor_types.armored,
		{
			max = 0.5,
			min = 0,
		},
	},
	{
		"targets",
		3,
		"armor_damage_modifier",
		"attack",
		armor_types.super_armor,
		{
			max = 0.5,
			min = 0,
		},
	},
	{
		"targets",
		4,
		"armor_damage_modifier",
		"attack",
		armor_types.armored,
		{
			max = 0.5,
			min = 0,
		},
	},
	{
		"targets",
		4,
		"armor_damage_modifier",
		"attack",
		armor_types.super_armor,
		{
			max = 0.5,
			min = 0,
		},
	},
	{
		"targets",
		5,
		"armor_damage_modifier",
		"attack",
		armor_types.armored,
		{
			max = 0.5,
			min = 0,
		},
	},
	{
		"targets",
		5,
		"armor_damage_modifier",
		"attack",
		armor_types.super_armor,
		{
			max = 0.5,
			min = 0,
		},
	},
	{
		"targets",
		"default_target",
		"armor_damage_modifier",
		"attack",
		armor_types.armored,
		{
			max = 0.5,
			min = 0,
		},
	},
	{
		"targets",
		"default_target",
		"armor_damage_modifier",
		"attack",
		armor_types.super_armor,
		{
			max = 0.5,
			min = 0,
		},
	},
	{
		"armor_damage_modifier",
		"attack",
		armor_types.armored,
		{
			max = 0.5,
			min = 0,
		},
	},
	{
		"armor_damage_modifier",
		"attack",
		armor_types.super_armor,
		{
			max = 0.5,
			min = 0,
		},
	},
}
damage_trait_templates.thunderhammer_control_stat = {
	{
		"targets",
		1,
		"power_distribution",
		"impact",
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		2,
		"power_distribution",
		"impact",
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		3,
		"power_distribution",
		"impact",
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		4,
		"power_distribution",
		"impact",
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		5,
		"power_distribution",
		"impact",
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		"default_target",
		"power_distribution",
		"impact",
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"cleave_distribution",
		"attack",
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"cleave_distribution",
		"impact",
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"stagger_duration_modifier",
		{
			max = 0.75,
			min = 0.25,
		},
	},
}
damage_trait_templates.ogryn_club_control_stat = {
	{
		"targets",
		1,
		"power_distribution",
		"impact",
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		2,
		"power_distribution",
		"impact",
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		3,
		"power_distribution",
		"impact",
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		4,
		"power_distribution",
		"impact",
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		5,
		"power_distribution",
		"impact",
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		"default_target",
		"power_distribution",
		"impact",
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"cleave_distribution",
		"attack",
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"cleave_distribution",
		"impact",
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"stagger_duration_modifier",
		{
			max = 0.75,
			min = 0.25,
		},
	},
}
damage_trait_templates.ogryn_club_push_control_stat = {
	{
		"power_distribution",
		"impact",
		{
			max = 0.95,
			min = 0.05,
		},
	},
}
damage_trait_templates.thunderhammer_dps_perk = {
	{
		"targets",
		1,
		"power_distribution",
		"attack",
		0.05,
	},
	{
		"targets",
		2,
		"power_distribution",
		"attack",
		0.05,
	},
	{
		"targets",
		3,
		"power_distribution",
		"attack",
		0.05,
	},
	{
		"targets",
		4,
		"power_distribution",
		"attack",
		0.05,
	},
	{
		"targets",
		5,
		"power_distribution",
		"attack",
		0.05,
	},
	{
		"targets",
		"default_target",
		"power_distribution",
		"attack",
		0.05,
	},
}
damage_trait_templates.thunderhammer_armor_pierce_perk = {
	{
		"targets",
		1,
		"armor_damage_modifier",
		"attack",
		armor_types.armored,
		0.05,
	},
	{
		"targets",
		1,
		"armor_damage_modifier",
		"attack",
		armor_types.super_armor,
		0.05,
	},
	{
		"targets",
		2,
		"armor_damage_modifier",
		"attack",
		armor_types.armored,
		0.05,
	},
	{
		"targets",
		2,
		"armor_damage_modifier",
		"attack",
		armor_types.super_armor,
		0.05,
	},
	{
		"targets",
		3,
		"armor_damage_modifier",
		"attack",
		armor_types.armored,
		0.05,
	},
	{
		"targets",
		3,
		"armor_damage_modifier",
		"attack",
		armor_types.super_armor,
		0.05,
	},
	{
		"targets",
		4,
		"armor_damage_modifier",
		"attack",
		armor_types.armored,
		0.05,
	},
	{
		"targets",
		4,
		"armor_damage_modifier",
		"attack",
		armor_types.super_armor,
		0.05,
	},
	{
		"targets",
		5,
		"armor_damage_modifier",
		"attack",
		armor_types.armored,
		0.05,
	},
	{
		"targets",
		5,
		"armor_damage_modifier",
		"attack",
		armor_types.super_armor,
		0.05,
	},
	{
		"targets",
		"default_target",
		"armor_damage_modifier",
		"attack",
		armor_types.armored,
		0.05,
	},
	{
		"targets",
		"default_target",
		"armor_damage_modifier",
		"attack",
		armor_types.super_armor,
		0.05,
	},
	{
		"armor_damage_modifier",
		"attack",
		armor_types.armored,
		0.05,
	},
	{
		"armor_damage_modifier",
		"attack",
		armor_types.super_armor,
		0.05,
	},
}
damage_trait_templates.thunderhammer_control_perk = {
	{
		"targets",
		1,
		"power_distribution",
		"impact",
		0.05,
	},
	{
		"targets",
		2,
		"power_distribution",
		"impact",
		0.05,
	},
	{
		"targets",
		3,
		"power_distribution",
		"impact",
		0.05,
	},
	{
		"targets",
		4,
		"power_distribution",
		"impact",
		0.05,
	},
	{
		"targets",
		5,
		"power_distribution",
		"impact",
		0.05,
	},
	{
		"targets",
		"default_target",
		"power_distribution",
		"impact",
		0.05,
	},
	{
		"cleave_distribution",
		"attack",
		0.05,
	},
	{
		"cleave_distribution",
		"impact",
		0.05,
	},
}
damage_trait_templates.powersword_dps_stat = {
	{
		"targets",
		1,
		"power_distribution",
		"attack",
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		2,
		"power_distribution",
		"attack",
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		3,
		"power_distribution",
		"attack",
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		4,
		"power_distribution",
		"attack",
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		5,
		"power_distribution",
		"attack",
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		6,
		"power_distribution",
		"attack",
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		7,
		"power_distribution",
		"attack",
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		"default_target",
		"power_distribution",
		"attack",
		{
			max = 0.75,
			min = 0.25,
		},
	},
}
damage_trait_templates.powersword_cleave_damage_stat = {
	{
		"targets",
		1,
		"armor_damage_modifier",
		"attack",
		armor_types.armored,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		1,
		"armor_damage_modifier",
		"attack",
		armor_types.unarmored,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		1,
		"armor_damage_modifier",
		"attack",
		armor_types.disgustingly_resilient,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		2,
		"armor_damage_modifier",
		"attack",
		armor_types.armored,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		2,
		"armor_damage_modifier",
		"attack",
		armor_types.unarmored,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		2,
		"armor_damage_modifier",
		"attack",
		armor_types.disgustingly_resilient,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		3,
		"armor_damage_modifier",
		"attack",
		armor_types.armored,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		3,
		"armor_damage_modifier",
		"attack",
		armor_types.unarmored,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		3,
		"armor_damage_modifier",
		"attack",
		armor_types.disgustingly_resilient,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		4,
		"armor_damage_modifier",
		"attack",
		armor_types.armored,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		4,
		"armor_damage_modifier",
		"attack",
		armor_types.unarmored,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		4,
		"armor_damage_modifier",
		"attack",
		armor_types.disgustingly_resilient,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		5,
		"armor_damage_modifier",
		"attack",
		armor_types.armored,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		5,
		"armor_damage_modifier",
		"attack",
		armor_types.unarmored,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		5,
		"armor_damage_modifier",
		"attack",
		armor_types.disgustingly_resilient,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		6,
		"armor_damage_modifier",
		"attack",
		armor_types.armored,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		6,
		"armor_damage_modifier",
		"attack",
		armor_types.unarmored,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		6,
		"armor_damage_modifier",
		"attack",
		armor_types.disgustingly_resilient,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		7,
		"armor_damage_modifier",
		"attack",
		armor_types.armored,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		7,
		"armor_damage_modifier",
		"attack",
		armor_types.unarmored,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		7,
		"armor_damage_modifier",
		"attack",
		armor_types.disgustingly_resilient,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		"default_target",
		"armor_damage_modifier",
		"attack",
		armor_types.armored,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		"default_target",
		"armor_damage_modifier",
		"attack",
		armor_types.unarmored,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		"default_target",
		"armor_damage_modifier",
		"attack",
		armor_types.disgustingly_resilient,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"armor_damage_modifier",
		"attack",
		armor_types.armored,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"armor_damage_modifier",
		"attack",
		armor_types.unarmored,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"armor_damage_modifier",
		"attack",
		armor_types.disgustingly_resilient,
		{
			max = 0.75,
			min = 0.25,
		},
	},
}
damage_trait_templates.powersword_finesse_stat = {
	{
		"targets",
		1,
		"boost_curve_multiplier_finesse",
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		2,
		"boost_curve_multiplier_finesse",
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		3,
		"boost_curve_multiplier_finesse",
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		4,
		"boost_curve_multiplier_finesse",
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		5,
		"boost_curve_multiplier_finesse",
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		6,
		"boost_curve_multiplier_finesse",
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		7,
		"boost_curve_multiplier_finesse",
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		"default_target",
		"boost_curve_multiplier_finesse",
		{
			max = 0.75,
			min = 0.25,
		},
	},
}
damage_trait_templates.powersword_cleave_targets_stat = {
	{
		"cleave_distribution",
		"attack",
		{
			max = 1,
			min = 0,
		},
	},
	{
		"cleave_distribution",
		"impact",
		{
			max = 1,
			min = 0,
		},
	},
}
damage_trait_templates.powersword_dps_perk = {
	{
		"targets",
		1,
		"power_distribution",
		"attack",
		0.05,
	},
	{
		"targets",
		2,
		"power_distribution",
		"attack",
		0.05,
	},
	{
		"targets",
		3,
		"power_distribution",
		"attack",
		0.05,
	},
	{
		"targets",
		4,
		"power_distribution",
		"attack",
		0.05,
	},
	{
		"targets",
		5,
		"power_distribution",
		"attack",
		0.05,
	},
	{
		"targets",
		6,
		"power_distribution",
		"attack",
		0.05,
	},
	{
		"targets",
		7,
		"power_distribution",
		"attack",
		0.05,
	},
	{
		"targets",
		"default_target",
		"power_distribution",
		"attack",
		0.05,
	},
}
damage_trait_templates.powersword_cleave_damage_perk = {
	{
		"targets",
		1,
		"armor_damage_modifier",
		"attack",
		armor_types.armored,
		0.05,
	},
	{
		"targets",
		1,
		"armor_damage_modifier",
		"attack",
		armor_types.unarmored,
		0.05,
	},
	{
		"targets",
		1,
		"armor_damage_modifier",
		"attack",
		armor_types.disgustingly_resilient,
		0.05,
	},
	{
		"targets",
		2,
		"armor_damage_modifier",
		"attack",
		armor_types.armored,
		0.05,
	},
	{
		"targets",
		2,
		"armor_damage_modifier",
		"attack",
		armor_types.unarmored,
		0.05,
	},
	{
		"targets",
		2,
		"armor_damage_modifier",
		"attack",
		armor_types.disgustingly_resilient,
		0.05,
	},
	{
		"targets",
		3,
		"armor_damage_modifier",
		"attack",
		armor_types.armored,
		0.05,
	},
	{
		"targets",
		3,
		"armor_damage_modifier",
		"attack",
		armor_types.unarmored,
		0.05,
	},
	{
		"targets",
		3,
		"armor_damage_modifier",
		"attack",
		armor_types.disgustingly_resilient,
		0.05,
	},
	{
		"targets",
		4,
		"armor_damage_modifier",
		"attack",
		armor_types.armored,
		0.05,
	},
	{
		"targets",
		4,
		"armor_damage_modifier",
		"attack",
		armor_types.unarmored,
		0.05,
	},
	{
		"targets",
		4,
		"armor_damage_modifier",
		"attack",
		armor_types.disgustingly_resilient,
		0.05,
	},
	{
		"targets",
		5,
		"armor_damage_modifier",
		"attack",
		armor_types.armored,
		0.05,
	},
	{
		"targets",
		5,
		"armor_damage_modifier",
		"attack",
		armor_types.unarmored,
		0.05,
	},
	{
		"targets",
		5,
		"armor_damage_modifier",
		"attack",
		armor_types.disgustingly_resilient,
		0.05,
	},
	{
		"targets",
		6,
		"armor_damage_modifier",
		"attack",
		armor_types.armored,
		0.05,
	},
	{
		"targets",
		6,
		"armor_damage_modifier",
		"attack",
		armor_types.unarmored,
		0.05,
	},
	{
		"targets",
		6,
		"armor_damage_modifier",
		"attack",
		armor_types.disgustingly_resilient,
		0.05,
	},
	{
		"targets",
		7,
		"armor_damage_modifier",
		"attack",
		armor_types.armored,
		0.05,
	},
	{
		"targets",
		7,
		"armor_damage_modifier",
		"attack",
		armor_types.unarmored,
		0.05,
	},
	{
		"targets",
		7,
		"armor_damage_modifier",
		"attack",
		armor_types.disgustingly_resilient,
		0.05,
	},
	{
		"targets",
		"default_target",
		"armor_damage_modifier",
		"attack",
		armor_types.armored,
		0.05,
	},
	{
		"targets",
		"default_target",
		"armor_damage_modifier",
		"attack",
		armor_types.unarmored,
		0.05,
	},
	{
		"targets",
		"default_target",
		"armor_damage_modifier",
		"attack",
		armor_types.disgustingly_resilient,
		0.05,
	},
	{
		"armor_damage_modifier",
		"attack",
		armor_types.armored,
		0.05,
	},
	{
		"armor_damage_modifier",
		"attack",
		armor_types.unarmored,
		0.05,
	},
	{
		"armor_damage_modifier",
		"attack",
		armor_types.disgustingly_resilient,
		0.05,
	},
}
damage_trait_templates.powersword_finesse_perk = {
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
		"targets",
		3,
		"boost_curve_multiplier_finesse",
		0.05,
	},
	{
		"targets",
		4,
		"boost_curve_multiplier_finesse",
		0.05,
	},
	{
		"targets",
		5,
		"boost_curve_multiplier_finesse",
		0.05,
	},
	{
		"targets",
		6,
		"boost_curve_multiplier_finesse",
		0.05,
	},
	{
		"targets",
		7,
		"boost_curve_multiplier_finesse",
		0.05,
	},
	{
		"targets",
		"default_target",
		"boost_curve_multiplier_finesse",
		0.05,
	},
}
damage_trait_templates.powersword_cleave_targets_perk = {
	{
		"cleave_distribution",
		"attack",
		0.05,
	},
	{
		"cleave_distribution",
		"impact",
		0.05,
	},
}
damage_trait_templates.ogryn_thumper_p1_m2_explosion_antiarmor_stat = {
	{
		"armor_damage_modifier",
		"attack",
		armor_types.armored,
		{
			max = 1,
			min = 0,
		},
	},
	{
		"armor_damage_modifier",
		"impact",
		armor_types.armored,
		{
			max = 1,
			min = 0,
		},
	},
	{
		"armor_damage_modifier",
		"attack",
		armor_types.super_armor,
		{
			max = 1,
			min = 0,
		},
	},
	{
		"armor_damage_modifier",
		"impact",
		armor_types.super_armor,
		{
			max = 1,
			min = 0,
		},
	},
	{
		"armor_damage_modifier",
		"attack",
		armor_types.resistant,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"armor_damage_modifier",
		"impact",
		armor_types.resistant,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"armor_damage_modifier_ranged",
		"near",
		"attack",
		armor_types.armored,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"armor_damage_modifier_ranged",
		"far",
		"attack",
		armor_types.armored,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"armor_damage_modifier_ranged",
		"near",
		"attack",
		armor_types.resistant,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"armor_damage_modifier_ranged",
		"far",
		"attack",
		armor_types.resistant,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"armor_damage_modifier_ranged",
		"near",
		"attack",
		armor_types.super_armor,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"armor_damage_modifier_ranged",
		"far",
		"attack",
		armor_types.super_armor,
		{
			max = 0.75,
			min = 0.25,
		},
	},
}
damage_trait_templates.ogryn_gauntlet_p1_m1_explosion_antiarmor_stat = {
	{
		"armor_damage_modifier",
		"attack",
		armor_types.armored,
		{
			max = 1,
			min = 0,
		},
	},
	{
		"armor_damage_modifier",
		"impact",
		armor_types.armored,
		{
			max = 1,
			min = 0,
		},
	},
	{
		"armor_damage_modifier",
		"attack",
		armor_types.super_armor,
		{
			max = 1,
			min = 0,
		},
	},
	{
		"armor_damage_modifier",
		"impact",
		armor_types.super_armor,
		{
			max = 1,
			min = 0,
		},
	},
	{
		"armor_damage_modifier",
		"attack",
		armor_types.resistant,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"armor_damage_modifier",
		"impact",
		armor_types.resistant,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"armor_damage_modifier_ranged",
		"near",
		"attack",
		armor_types.armored,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"armor_damage_modifier_ranged",
		"far",
		"attack",
		armor_types.armored,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"armor_damage_modifier_ranged",
		"near",
		"attack",
		armor_types.resistant,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"armor_damage_modifier_ranged",
		"far",
		"attack",
		armor_types.resistant,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"armor_damage_modifier_ranged",
		"near",
		"attack",
		armor_types.super_armor,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"armor_damage_modifier_ranged",
		"far",
		"attack",
		armor_types.super_armor,
		{
			max = 0.75,
			min = 0.25,
		},
	},
}
damage_trait_templates.ogryn_thumper_p1_m2_explosion_damage_stat = {
	{
		"power_distribution_ranged",
		"attack",
		"far",
		{
			max = 1,
			min = 0,
		},
	},
	{
		"power_distribution_ranged",
		"attack",
		"near",
		{
			max = 1,
			min = 0,
		},
	},
	{
		"power_distribution",
		"attack",
		{
			max = 1,
			min = 0,
		},
	},
	{
		"armor_damage_modifier",
		"attack",
		armor_types.unarmored,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"armor_damage_modifier",
		"attack",
		armor_types.player,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"armor_damage_modifier",
		"attack",
		armor_types.disgustingly_resilient,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"armor_damage_modifier",
		"attack",
		armor_types.void_shield,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"armor_damage_modifier_ranged",
		"near",
		"attack",
		armor_types.unarmored,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"armor_damage_modifier_ranged",
		"far",
		"attack",
		armor_types.unarmored,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"armor_damage_modifier_ranged",
		"near",
		"attack",
		armor_types.disgustingly_resilient,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"armor_damage_modifier_ranged",
		"far",
		"attack",
		armor_types.disgustingly_resilient,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"armor_damage_modifier_ranged",
		"near",
		"attack",
		armor_types.void_shield,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"armor_damage_modifier_ranged",
		"far",
		"attack",
		armor_types.void_shield,
		{
			max = 0.75,
			min = 0.25,
		},
	},
}
damage_trait_templates.ogryn_thumper_p1_m2_explosion_antiarmor_perk = {
	{
		"armor_damage_modifier_ranged",
		"near",
		"attack",
		armor_types.armored,
		0.05,
	},
	{
		"armor_damage_modifier_ranged",
		"far",
		"attack",
		armor_types.armored,
		0.05,
	},
	{
		"armor_damage_modifier_ranged",
		"near",
		"impact",
		armor_types.armored,
		0.05,
	},
	{
		"armor_damage_modifier_ranged",
		"far",
		"impact",
		armor_types.armored,
		0.05,
	},
	{
		"armor_damage_modifier",
		"attack",
		armor_types.armored,
		0.05,
	},
	{
		"armor_damage_modifier",
		"impact",
		armor_types.armored,
		0.05,
	},
}
damage_trait_templates.ogryn_thumper_p1_m2_explosion_damage_perk = {
	{
		"armor_damage_modifier",
		"attack",
		armor_types.unarmored,
		0.05,
	},
	{
		"armor_damage_modifier",
		"attack",
		armor_types.armored,
		0.05,
	},
	{
		"armor_damage_modifier",
		"attack",
		armor_types.resistant,
		0.05,
	},
	{
		"armor_damage_modifier",
		"attack",
		armor_types.player,
		0.05,
	},
	{
		"armor_damage_modifier",
		"attack",
		armor_types.super_armor,
		0.05,
	},
	{
		"armor_damage_modifier",
		"attack",
		armor_types.disgustingly_resilient,
		0.05,
	},
	{
		"armor_damage_modifier",
		"attack",
		armor_types.void_shield,
		0.05,
	},
	{
		"armor_damage_modifier_ranged",
		"near",
		"attack",
		armor_types.unarmored,
		0.05,
	},
	{
		"armor_damage_modifier_ranged",
		"far",
		"attack",
		armor_types.unarmored,
		0.05,
	},
	{
		"armor_damage_modifier_ranged",
		"near",
		"attack",
		armor_types.armored,
		0.05,
	},
	{
		"armor_damage_modifier_ranged",
		"far",
		"attack",
		armor_types.armored,
		0.05,
	},
	{
		"armor_damage_modifier_ranged",
		"near",
		"attack",
		armor_types.resistant,
		0.05,
	},
	{
		"armor_damage_modifier_ranged",
		"far",
		"attack",
		armor_types.resistant,
		0.05,
	},
	{
		"armor_damage_modifier_ranged",
		"near",
		"attack",
		armor_types.player,
		0.05,
	},
	{
		"armor_damage_modifier_ranged",
		"far",
		"attack",
		armor_types.player,
		0.05,
	},
	{
		"armor_damage_modifier_ranged",
		"near",
		"attack",
		armor_types.super_armor,
		0.05,
	},
	{
		"armor_damage_modifier_ranged",
		"far",
		"attack",
		armor_types.super_armor,
		0.05,
	},
	{
		"armor_damage_modifier_ranged",
		"near",
		"attack",
		armor_types.disgustingly_resilient,
		0.05,
	},
	{
		"armor_damage_modifier_ranged",
		"far",
		"attack",
		armor_types.disgustingly_resilient,
		0.05,
	},
	{
		"armor_damage_modifier_ranged",
		"near",
		"attack",
		armor_types.void_shield,
		0.05,
	},
	{
		"armor_damage_modifier_ranged",
		"far",
		"attack",
		armor_types.void_shield,
		0.05,
	},
}
damage_trait_templates.ogryn_gauntlet_p1_m1_explosion_damage_stat = {
	{
		"power_distribution",
		"attack",
		{
			max = 1,
			min = 0,
		},
	},
}
damage_trait_templates.ogryn_gauntlet_p1_m1_explosion_antiarmor_perk = {
	{
		"armor_damage_modifier_ranged",
		"near",
		"attack",
		armor_types.armored,
		0.05,
	},
	{
		"armor_damage_modifier_ranged",
		"far",
		"attack",
		armor_types.armored,
		0.05,
	},
	{
		"armor_damage_modifier_ranged",
		"near",
		"impact",
		armor_types.armored,
		0.05,
	},
	{
		"armor_damage_modifier_ranged",
		"far",
		"impact",
		armor_types.armored,
		0.05,
	},
	{
		"armor_damage_modifier",
		"attack",
		armor_types.armored,
		0.05,
	},
	{
		"armor_damage_modifier",
		"impact",
		armor_types.armored,
		0.05,
	},
}
damage_trait_templates.ogryn_gauntlet_p1_m1_explosion_damage_perk = {
	{
		"armor_damage_modifier",
		"attack",
		armor_types.unarmored,
		0.05,
	},
	{
		"armor_damage_modifier",
		"attack",
		armor_types.armored,
		0.05,
	},
	{
		"armor_damage_modifier",
		"attack",
		armor_types.resistant,
		0.05,
	},
	{
		"armor_damage_modifier",
		"attack",
		armor_types.player,
		0.05,
	},
	{
		"armor_damage_modifier",
		"attack",
		armor_types.super_armor,
		0.05,
	},
	{
		"armor_damage_modifier",
		"attack",
		armor_types.disgustingly_resilient,
		0.05,
	},
	{
		"armor_damage_modifier",
		"attack",
		armor_types.void_shield,
		0.05,
	},
	{
		"armor_damage_modifier_ranged",
		"near",
		"attack",
		armor_types.unarmored,
		0.05,
	},
	{
		"armor_damage_modifier_ranged",
		"far",
		"attack",
		armor_types.unarmored,
		0.05,
	},
	{
		"armor_damage_modifier_ranged",
		"near",
		"attack",
		armor_types.armored,
		0.05,
	},
	{
		"armor_damage_modifier_ranged",
		"far",
		"attack",
		armor_types.armored,
		0.05,
	},
	{
		"armor_damage_modifier_ranged",
		"near",
		"attack",
		armor_types.resistant,
		0.05,
	},
	{
		"armor_damage_modifier_ranged",
		"far",
		"attack",
		armor_types.resistant,
		0.05,
	},
	{
		"armor_damage_modifier_ranged",
		"near",
		"attack",
		armor_types.player,
		0.05,
	},
	{
		"armor_damage_modifier_ranged",
		"far",
		"attack",
		armor_types.player,
		0.05,
	},
	{
		"armor_damage_modifier_ranged",
		"near",
		"attack",
		armor_types.super_armor,
		0.05,
	},
	{
		"armor_damage_modifier_ranged",
		"far",
		"attack",
		armor_types.super_armor,
		0.05,
	},
	{
		"armor_damage_modifier_ranged",
		"near",
		"attack",
		armor_types.disgustingly_resilient,
		0.05,
	},
	{
		"armor_damage_modifier_ranged",
		"far",
		"attack",
		armor_types.disgustingly_resilient,
		0.05,
	},
	{
		"armor_damage_modifier_ranged",
		"near",
		"attack",
		armor_types.void_shield,
		0.05,
	},
	{
		"armor_damage_modifier_ranged",
		"far",
		"attack",
		armor_types.void_shield,
		0.05,
	},
}
damage_trait_templates.combatsword_dps_stat = {
	{
		"targets",
		1,
		"power_distribution",
		"attack",
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		2,
		"power_distribution",
		"attack",
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		3,
		"power_distribution",
		"attack",
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		4,
		"power_distribution",
		"attack",
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		5,
		"power_distribution",
		"attack",
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		6,
		"power_distribution",
		"attack",
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		7,
		"power_distribution",
		"attack",
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		"default_target",
		"power_distribution",
		"attack",
		{
			max = 0.75,
			min = 0.25,
		},
	},
}
damage_trait_templates.combatsword_cleave_damage_stat = {
	{
		"targets",
		1,
		"armor_damage_modifier",
		"attack",
		armor_types.armored,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		1,
		"armor_damage_modifier",
		"attack",
		armor_types.unarmored,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		1,
		"armor_damage_modifier",
		"attack",
		armor_types.disgustingly_resilient,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		2,
		"armor_damage_modifier",
		"attack",
		armor_types.armored,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		2,
		"armor_damage_modifier",
		"attack",
		armor_types.unarmored,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		2,
		"armor_damage_modifier",
		"attack",
		armor_types.disgustingly_resilient,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		3,
		"armor_damage_modifier",
		"attack",
		armor_types.armored,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		3,
		"armor_damage_modifier",
		"attack",
		armor_types.unarmored,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		3,
		"armor_damage_modifier",
		"attack",
		armor_types.disgustingly_resilient,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		4,
		"armor_damage_modifier",
		"attack",
		armor_types.armored,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		4,
		"armor_damage_modifier",
		"attack",
		armor_types.unarmored,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		4,
		"armor_damage_modifier",
		"attack",
		armor_types.disgustingly_resilient,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		5,
		"armor_damage_modifier",
		"attack",
		armor_types.armored,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		5,
		"armor_damage_modifier",
		"attack",
		armor_types.unarmored,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		5,
		"armor_damage_modifier",
		"attack",
		armor_types.disgustingly_resilient,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		6,
		"armor_damage_modifier",
		"attack",
		armor_types.armored,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		6,
		"armor_damage_modifier",
		"attack",
		armor_types.unarmored,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		6,
		"armor_damage_modifier",
		"attack",
		armor_types.disgustingly_resilient,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		7,
		"armor_damage_modifier",
		"attack",
		armor_types.armored,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		7,
		"armor_damage_modifier",
		"attack",
		armor_types.unarmored,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		7,
		"armor_damage_modifier",
		"attack",
		armor_types.disgustingly_resilient,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		"default_target",
		"armor_damage_modifier",
		"attack",
		armor_types.armored,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		"default_target",
		"armor_damage_modifier",
		"attack",
		armor_types.unarmored,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		"default_target",
		"armor_damage_modifier",
		"attack",
		armor_types.disgustingly_resilient,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"armor_damage_modifier",
		"attack",
		armor_types.armored,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"armor_damage_modifier",
		"attack",
		armor_types.unarmored,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"armor_damage_modifier",
		"attack",
		armor_types.disgustingly_resilient,
		{
			max = 0.75,
			min = 0.25,
		},
	},
}
damage_trait_templates.combatsword_finesse_stat = {
	{
		"targets",
		1,
		"boost_curve_multiplier_finesse",
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		2,
		"boost_curve_multiplier_finesse",
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		3,
		"boost_curve_multiplier_finesse",
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		4,
		"boost_curve_multiplier_finesse",
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		5,
		"boost_curve_multiplier_finesse",
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		6,
		"boost_curve_multiplier_finesse",
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		7,
		"boost_curve_multiplier_finesse",
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		"default_target",
		"boost_curve_multiplier_finesse",
		{
			max = 0.75,
			min = 0.25,
		},
	},
}
damage_trait_templates.combatsword_cleave_targets_stat = {
	{
		"cleave_distribution",
		"attack",
		{
			max = 1,
			min = 0,
		},
	},
	{
		"cleave_distribution",
		"impact",
		{
			max = 1,
			min = 0,
		},
	},
}
damage_trait_templates.combatsword_dps_perk = {
	{
		"targets",
		1,
		"power_distribution",
		"attack",
		0.05,
	},
	{
		"targets",
		2,
		"power_distribution",
		"attack",
		0.05,
	},
	{
		"targets",
		3,
		"power_distribution",
		"attack",
		0.05,
	},
	{
		"targets",
		4,
		"power_distribution",
		"attack",
		0.05,
	},
	{
		"targets",
		5,
		"power_distribution",
		"attack",
		0.05,
	},
	{
		"targets",
		6,
		"power_distribution",
		"attack",
		0.05,
	},
	{
		"targets",
		7,
		"power_distribution",
		"attack",
		0.05,
	},
	{
		"targets",
		"default_target",
		"power_distribution",
		"attack",
		0.05,
	},
}
damage_trait_templates.combatsword_cleave_damage_perk = {
	{
		"targets",
		1,
		"armor_damage_modifier",
		"attack",
		armor_types.armored,
		0.05,
	},
	{
		"targets",
		1,
		"armor_damage_modifier",
		"attack",
		armor_types.unarmored,
		0.05,
	},
	{
		"targets",
		1,
		"armor_damage_modifier",
		"attack",
		armor_types.disgustingly_resilient,
		0.05,
	},
	{
		"targets",
		2,
		"armor_damage_modifier",
		"attack",
		armor_types.armored,
		0.05,
	},
	{
		"targets",
		2,
		"armor_damage_modifier",
		"attack",
		armor_types.unarmored,
		0.05,
	},
	{
		"targets",
		2,
		"armor_damage_modifier",
		"attack",
		armor_types.disgustingly_resilient,
		0.05,
	},
	{
		"targets",
		3,
		"armor_damage_modifier",
		"attack",
		armor_types.armored,
		0.05,
	},
	{
		"targets",
		3,
		"armor_damage_modifier",
		"attack",
		armor_types.unarmored,
		0.05,
	},
	{
		"targets",
		3,
		"armor_damage_modifier",
		"attack",
		armor_types.disgustingly_resilient,
		0.05,
	},
	{
		"targets",
		4,
		"armor_damage_modifier",
		"attack",
		armor_types.armored,
		0.05,
	},
	{
		"targets",
		4,
		"armor_damage_modifier",
		"attack",
		armor_types.unarmored,
		0.05,
	},
	{
		"targets",
		4,
		"armor_damage_modifier",
		"attack",
		armor_types.disgustingly_resilient,
		0.05,
	},
	{
		"targets",
		5,
		"armor_damage_modifier",
		"attack",
		armor_types.armored,
		0.05,
	},
	{
		"targets",
		5,
		"armor_damage_modifier",
		"attack",
		armor_types.unarmored,
		0.05,
	},
	{
		"targets",
		5,
		"armor_damage_modifier",
		"attack",
		armor_types.disgustingly_resilient,
		0.05,
	},
	{
		"targets",
		6,
		"armor_damage_modifier",
		"attack",
		armor_types.armored,
		0.05,
	},
	{
		"targets",
		6,
		"armor_damage_modifier",
		"attack",
		armor_types.unarmored,
		0.05,
	},
	{
		"targets",
		6,
		"armor_damage_modifier",
		"attack",
		armor_types.disgustingly_resilient,
		0.05,
	},
	{
		"targets",
		7,
		"armor_damage_modifier",
		"attack",
		armor_types.armored,
		0.05,
	},
	{
		"targets",
		7,
		"armor_damage_modifier",
		"attack",
		armor_types.unarmored,
		0.05,
	},
	{
		"targets",
		7,
		"armor_damage_modifier",
		"attack",
		armor_types.disgustingly_resilient,
		0.05,
	},
	{
		"targets",
		"default_target",
		"armor_damage_modifier",
		"attack",
		armor_types.armored,
		0.05,
	},
	{
		"targets",
		"default_target",
		"armor_damage_modifier",
		"attack",
		armor_types.unarmored,
		0.05,
	},
	{
		"targets",
		"default_target",
		"armor_damage_modifier",
		"attack",
		armor_types.disgustingly_resilient,
		0.05,
	},
	{
		"armor_damage_modifier",
		"attack",
		armor_types.armored,
		0.05,
	},
	{
		"armor_damage_modifier",
		"attack",
		armor_types.unarmored,
		0.05,
	},
	{
		"armor_damage_modifier",
		"attack",
		armor_types.disgustingly_resilient,
		0.05,
	},
}
damage_trait_templates.combatsword_finesse_perk = {
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
		"targets",
		3,
		"boost_curve_multiplier_finesse",
		0.05,
	},
	{
		"targets",
		4,
		"boost_curve_multiplier_finesse",
		0.05,
	},
	{
		"targets",
		5,
		"boost_curve_multiplier_finesse",
		0.05,
	},
	{
		"targets",
		6,
		"boost_curve_multiplier_finesse",
		0.05,
	},
	{
		"targets",
		7,
		"boost_curve_multiplier_finesse",
		0.05,
	},
	{
		"targets",
		"default_target",
		"boost_curve_multiplier_finesse",
		0.05,
	},
}
damage_trait_templates.combatsword_cleave_targets_perk = {
	{
		"cleave_distribution",
		"attack",
		0.05,
	},
	{
		"cleave_distribution",
		"impact",
		0.05,
	},
}
damage_trait_templates.headshot_damage_01_a = {
	{
		"targets",
		"default_target",
		"boost_curve_multiplier_finesse",
		0.6,
	},
	[DEFAULT_LERP_VALUE] = 0.1,
}
damage_trait_templates.headshot_damage_01_b = {
	{
		"targets",
		"default_target",
		"boost_curve_multiplier_finesse",
		0.8,
	},
	[DEFAULT_LERP_VALUE] = 0.2,
}
damage_trait_templates.headshot_damage_01_c = {
	{
		"targets",
		"default_target",
		"boost_curve_multiplier_finesse",
		1,
	},
	[DEFAULT_LERP_VALUE] = 0.3,
}
damage_trait_templates.unarmored_damage_01_a = {
	{
		"armor_damage_modifier_ranged",
		"near",
		"attack",
		armor_types.unarmored,
		0.6,
	},
	{
		"armor_damage_modifier_ranged",
		"far",
		"attack",
		armor_types.unarmored,
		0.6,
	},
	{
		"armor_damage_modifier_ranged",
		"near",
		"attack",
		armor_types.unarmored,
		0.6,
	},
	{
		"armor_damage_modifier_ranged",
		"far",
		"attack",
		armor_types.unarmored,
		0.6,
	},
	[DEFAULT_LERP_VALUE] = 0.1,
}
damage_trait_templates.unarmored_damage_01_b = {
	{
		"armor_damage_modifier_ranged",
		"near",
		"attack",
		armor_types.unarmored,
		0.8,
	},
	{
		"armor_damage_modifier_ranged",
		"far",
		"attack",
		armor_types.unarmored,
		0.8,
	},
	[DEFAULT_LERP_VALUE] = 0.2,
}
damage_trait_templates.unarmored_damage_01_c = {
	{
		"armor_damage_modifier_ranged",
		"near",
		"attack",
		armor_types.unarmored,
		1,
	},
	{
		"armor_damage_modifier_ranged",
		"far",
		"attack",
		armor_types.unarmored,
		1,
	},
	[DEFAULT_LERP_VALUE] = 0.3,
}
damage_trait_templates.armored_damage_01_a = {
	{
		"armor_damage_modifier_ranged",
		"near",
		"attack",
		armor_types.armored,
		0.6,
	},
	{
		"armor_damage_modifier_ranged",
		"far",
		"attack",
		armor_types.armored,
		0.6,
	},
	[DEFAULT_LERP_VALUE] = 0.1,
}
damage_trait_templates.armored_damage_01_b = {
	{
		"armor_damage_modifier_ranged",
		"near",
		"attack",
		armor_types.armored,
		0.8,
	},
	{
		"armor_damage_modifier_ranged",
		"far",
		"attack",
		armor_types.armored,
		0.8,
	},
	[DEFAULT_LERP_VALUE] = 0.2,
}
damage_trait_templates.armored_damage_01_c = {
	{
		"armor_damage_modifier_ranged",
		"near",
		"attack",
		armor_types.armored,
		1,
	},
	{
		"armor_damage_modifier_ranged",
		"far",
		"attack",
		armor_types.armored,
		1,
	},
	[DEFAULT_LERP_VALUE] = 0.3,
}
damage_trait_templates.autogun_standard_damage_vs_armor_increase_01 = {
	{
		"armor_damage_modifier_ranged",
		"near",
		"attack",
		armor_types.armored,
		1,
	},
	{
		"armor_damage_modifier_ranged",
		"far",
		"attack",
		armor_types.armored,
		1,
	},
}
damage_trait_templates.autogun_standard_damage_vs_unarmored_increase_01 = {
	{
		"armor_damage_modifier_ranged",
		"near",
		"attack",
		armor_types.unarmored,
		1,
	},
	{
		"armor_damage_modifier_ranged",
		"far",
		"attack",
		armor_types.unarmored,
		1,
	},
}
damage_trait_templates.autogun_standard_damage_ranged_increase_01 = {
	{
		"ranges",
		"min",
		1,
	},
	{
		"ranges",
		"max",
		1,
	},
}
damage_trait_templates.autogun_spraynpray_damage_increase_01 = {
	{
		"power_distribution",
		"attack",
		1,
	},
	{
		"power_distribution",
		"impact",
		1,
	},
}
damage_trait_templates.autogun_standard_headshot_increase_01 = {
	{
		"targets",
		"default_target",
		"boost_curve_multiplier_finesse",
		1,
	},
}
damage_trait_templates.suppression_value_01 = {
	{
		"suppression_value",
		1,
	},
	{
		"on_kill_area_suppression",
		"suppression_value",
		1,
	},
	{
		"on_kill_area_suppression",
		"distance",
		1,
	},
}
damage_trait_templates.shotgun_default_range_stat = {
	{
		"ranges",
		"min",
		{
			max = 1,
			min = 0,
		},
	},
	{
		"ranges",
		"max",
		{
			max = 1,
			min = 0,
		},
	},
	{
		"armor_damage_modifier_ranged",
		"far",
		"attack",
		armor_types.unarmored,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"armor_damage_modifier_ranged",
		"far",
		"attack",
		armor_types.armored,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"armor_damage_modifier_ranged",
		"far",
		"attack",
		armor_types.resistant,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"armor_damage_modifier_ranged",
		"far",
		"attack",
		armor_types.berserker,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"armor_damage_modifier_ranged",
		"far",
		"attack",
		armor_types.disgustingly_resilient,
		{
			max = 0.75,
			min = 0.25,
		},
	},
}
damage_trait_templates.stubrevolver_dps_stat = {
	{
		"power_distribution",
		"attack",
		{
			max = 0.8,
			min = 0.2,
		},
	},
}
damage_trait_templates.stubrevolver_armor_piercing_stat = {
	{
		"armor_damage_modifier_ranged",
		"near",
		"attack",
		armor_types.armored,
		{
			max = 0.95,
			min = 0.1,
		},
	},
	{
		"armor_damage_modifier_ranged",
		"far",
		"attack",
		armor_types.armored,
		{
			max = 0.95,
			min = 0.1,
		},
	},
	{
		"armor_damage_modifier_ranged",
		"near",
		"attack",
		armor_types.super_armor,
		{
			max = 0.95,
			min = 0.1,
		},
	},
	{
		"armor_damage_modifier_ranged",
		"far",
		"attack",
		armor_types.super_armor,
		{
			max = 0.95,
			min = 0.1,
		},
	},
	{
		"armor_damage_modifier_ranged",
		"near",
		"attack",
		armor_types.resistant,
		{
			max = 0.95,
			min = 0.1,
		},
	},
	{
		"armor_damage_modifier_ranged",
		"far",
		"attack",
		armor_types.resistant,
		{
			max = 0.95,
			min = 0.1,
		},
	},
	{
		"armor_damage_modifier_ranged",
		"near",
		"attack",
		armor_types.void_shield,
		{
			max = 0.95,
			min = 0.1,
		},
	},
	{
		"armor_damage_modifier_ranged",
		"far",
		"attack",
		armor_types.void_shield,
		{
			max = 0.95,
			min = 0.1,
		},
	},
}
damage_trait_templates.stubrevolver_crit_stat = {
	{
		"crit_mod",
		"attack",
		armor_types.unarmored,
		{
			max = 1,
			min = 0,
		},
	},
	{
		"crit_mod",
		"attack",
		armor_types.armored,
		{
			max = 1,
			min = 0,
		},
	},
	{
		"crit_mod",
		"attack",
		armor_types.resistant,
		{
			max = 1,
			min = 0,
		},
	},
	{
		"crit_mod",
		"attack",
		armor_types.berserker,
		{
			max = 1,
			min = 0,
		},
	},
	{
		"crit_mod",
		"attack",
		armor_types.super_armor,
		{
			max = 1,
			min = 0,
		},
	},
	{
		"crit_mod",
		"attack",
		armor_types.disgustingly_resilient,
		{
			max = 1,
			min = 0,
		},
	},
	{
		"crit_mod",
		"attack",
		armor_types.void_shield,
		{
			max = 1,
			min = 0,
		},
	},
}
damage_trait_templates.powermaul_cleave_damage_stat = {
	{
		"targets",
		1,
		"armor_damage_modifier",
		"attack",
		armor_types.armored,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		1,
		"armor_damage_modifier",
		"attack",
		armor_types.unarmored,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		1,
		"armor_damage_modifier",
		"attack",
		armor_types.disgustingly_resilient,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		2,
		"armor_damage_modifier",
		"attack",
		armor_types.armored,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		2,
		"armor_damage_modifier",
		"attack",
		armor_types.unarmored,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		2,
		"armor_damage_modifier",
		"attack",
		armor_types.disgustingly_resilient,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		3,
		"armor_damage_modifier",
		"attack",
		armor_types.armored,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		3,
		"armor_damage_modifier",
		"attack",
		armor_types.unarmored,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		3,
		"armor_damage_modifier",
		"attack",
		armor_types.disgustingly_resilient,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		4,
		"armor_damage_modifier",
		"attack",
		armor_types.armored,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		4,
		"armor_damage_modifier",
		"attack",
		armor_types.unarmored,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		4,
		"armor_damage_modifier",
		"attack",
		armor_types.disgustingly_resilient,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		"default_target",
		"armor_damage_modifier",
		"attack",
		armor_types.armored,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		"default_target",
		"armor_damage_modifier",
		"attack",
		armor_types.unarmored,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"targets",
		"default_target",
		"armor_damage_modifier",
		"attack",
		armor_types.disgustingly_resilient,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"armor_damage_modifier",
		"attack",
		armor_types.armored,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"armor_damage_modifier",
		"attack",
		armor_types.unarmored,
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"armor_damage_modifier",
		"attack",
		armor_types.disgustingly_resilient,
		{
			max = 0.75,
			min = 0.25,
		},
	},
}

return damage_trait_templates
