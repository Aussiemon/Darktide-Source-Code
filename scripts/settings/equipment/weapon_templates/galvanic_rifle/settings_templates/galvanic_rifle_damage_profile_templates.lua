-- chunkname: @scripts/settings/equipment/weapon_templates/galvanic_rifle/settings_templates/galvanic_rifle_damage_profile_templates.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local DamageProfileSettings = require("scripts/settings/damage/damage_profile_settings")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local GibbingSettings = require("scripts/settings/gibbing/gibbing_settings")
local GibbingPower = GibbingSettings.gibbing_power
local gibbing_types = GibbingSettings.gibbing_types
local HerdingTemplates = require("scripts/settings/damage/herding_templates")
local WoundsTemplates = require("scripts/settings/damage/wounds_templates")
local damage_types = DamageSettings.damage_types
local armor_types = ArmorSettings.types
local damage_templates = {}
local overrides = {}

table.make_unique(damage_templates)
table.make_unique(overrides)

local damage_lerp_values = DamageProfileSettings.damage_lerp_values
local single_cleave = DamageProfileSettings.single_cleave
local single_plus_cleave = DamageProfileSettings.single_plus_cleave
local double_cleave = DamageProfileSettings.double_cleave
local default_shield_override_stagger_strength = 4
local galvanic_rifle_crit_mod = {
	attack = {
		[armor_types.unarmored] = 0.1,
		[armor_types.armored] = 0.1,
		[armor_types.resistant] = 0.1,
		[armor_types.player] = 0,
		[armor_types.berserker] = 0.1,
		[armor_types.super_armor] = 0.1,
		[armor_types.disgustingly_resilient] = 0.1,
		[armor_types.void_shield] = 0,
	},
	impact = {
		[armor_types.unarmored] = 1,
		[armor_types.armored] = 1,
		[armor_types.resistant] = 1,
		[armor_types.player] = 1,
		[armor_types.berserker] = 1,
		[armor_types.super_armor] = 1,
		[armor_types.disgustingly_resilient] = 0.75,
		[armor_types.void_shield] = 0.75,
	},
}

damage_templates.galvanic_rifle_p1_m1 = {
	ragdoll_push_force = 250,
	stagger_category = "sticky",
	suppression_value = 1,
	cleave_distribution = double_cleave,
	ranges = {
		min = {
			10,
			20,
		},
		max = {
			25,
			40,
		},
	},
	armor_damage_modifier_ranged = {
		near = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_0_8,
				[armor_types.resistant] = damage_lerp_values.lerp_0_5,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_0_7,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_2,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_7,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_0_8,
				[armor_types.resistant] = damage_lerp_values.lerp_0_5,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_0_6,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_25,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_75,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
			},
		},
		far = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_0_9,
				[armor_types.armored] = damage_lerp_values.lerp_0_7,
				[armor_types.resistant] = damage_lerp_values.lerp_0_4,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_0_6,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_1,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_6,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_4,
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_0_8,
				[armor_types.resistant] = damage_lerp_values.lerp_0_5,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_0_5,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_25,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_75,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
			},
		},
	},
	critical_strike = {
		gibbing_power = GibbingPower.light,
		gibbing_type = gibbing_types.ballistic,
	},
	power_distribution = {
		attack = {
			540,
			750,
		},
		impact = {
			6,
			12,
		},
	},
	shield_override_stagger_strength = default_shield_override_stagger_strength,
	damage_type = damage_types.auto_bullet,
	gibbing_power = GibbingPower.always,
	gibbing_type = gibbing_types.ballistic,
	wounds_template = WoundsTemplates.ballistic,
	on_kill_area_suppression = {
		distance = 3,
		suppression_value = 5,
	},
	gib_push_force = GibbingSettings.gib_push_force.ranged_light,
	targets = {
		default_target = {
			crit_boost = 0.6,
			boost_curve = PowerLevelSettings.boost_curves.default,
			finesse_boost = {
				[armor_types.unarmored] = 0.65,
				[armor_types.armored] = 0.65,
				[armor_types.resistant] = 0.55,
				[armor_types.player] = 0.65,
				[armor_types.berserker] = 0.65,
				[armor_types.super_armor] = 0.75,
				[armor_types.disgustingly_resilient] = 0.55,
				[armor_types.void_shield] = 0.5,
			},
			boost_curve_multiplier_finesse = {
				1.5,
				2,
			},
		},
		crit_mod = galvanic_rifle_crit_mod,
	},
}
damage_templates.galvanic_rifle_weapon_special_bash = {
	is_push = true,
	stagger_category = "melee",
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = 0.8,
			[armor_types.armored] = 0.3,
			[armor_types.resistant] = 0.5,
			[armor_types.player] = 0,
			[armor_types.berserker] = 0.6,
			[armor_types.super_armor] = 0,
			[armor_types.disgustingly_resilient] = 1,
			[armor_types.void_shield] = 0.1,
		},
		impact = {
			[armor_types.unarmored] = 1.25,
			[armor_types.armored] = 1,
			[armor_types.resistant] = 1,
			[armor_types.player] = 0,
			[armor_types.berserker] = 0.5,
			[armor_types.super_armor] = 0.5,
			[armor_types.disgustingly_resilient] = 1,
			[armor_types.void_shield] = 0,
		},
	},
	gibbing_power = GibbingPower.always,
	gibbing_type = gibbing_types.default,
	targets = {
		default_target = {
			power_distribution = {
				attack = {
					55,
					75,
				},
				impact = {
					10,
					20,
				},
			},
		},
	},
}
damage_templates.galvanic_rifle_weapon_special_push = {
	ignore_stagger_reduction = true,
	is_push = true,
	ragdoll_push_force = 100,
	stagger_category = "melee",
	weakspot_stagger_resistance_modifier = 0.2,
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = 0.8,
			[armor_types.armored] = 0.3,
			[armor_types.resistant] = 0.5,
			[armor_types.player] = 0,
			[armor_types.berserker] = 0.6,
			[armor_types.super_armor] = 0,
			[armor_types.disgustingly_resilient] = 1,
			[armor_types.void_shield] = 0.1,
		},
		impact = {
			[armor_types.unarmored] = 1.25,
			[armor_types.armored] = 1,
			[armor_types.resistant] = 0.25,
			[armor_types.player] = 0,
			[armor_types.berserker] = 0.5,
			[armor_types.super_armor] = 0.5,
			[armor_types.disgustingly_resilient] = 1,
			[armor_types.void_shield] = 0,
		},
	},
	gibbing_power = GibbingPower.always,
	gibbing_type = gibbing_types.default,
	targets = {
		default_target = {
			power_distribution = {
				attack = {
					25,
					75,
				},
				impact = {
					5,
					10,
				},
			},
		},
	},
}
overrides.galvanic_weapon_special_bash_heavy = {
	parent_template_name = "galvanic_rifle_weapon_special_bash",
	overrides = {
		{
			"targets",
			"default_target",
			"power_distribution",
			"attack",
			{
				50,
				150,
			},
		},
		{
			"targets",
			"default_target",
			"power_distribution",
			"impact",
			{
				5,
				10,
			},
		},
		{
			"weakspot_stagger_resistance_modifier",
			0.1,
		},
		{
			"ragdoll_push_force",
			400,
		},
	},
}

return {
	base_templates = damage_templates,
	overrides = overrides,
}
