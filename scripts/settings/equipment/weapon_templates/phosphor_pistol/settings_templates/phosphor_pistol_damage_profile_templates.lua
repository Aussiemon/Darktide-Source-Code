-- chunkname: @scripts/settings/equipment/weapon_templates/phosphor_pistol/settings_templates/phosphor_pistol_damage_profile_templates.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local DamageProfileSettings = require("scripts/settings/damage/damage_profile_settings")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local GibbingSettings = require("scripts/settings/gibbing/gibbing_settings")
local HerdingTemplates = require("scripts/settings/damage/herding_templates")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local WoundsTemplates = require("scripts/settings/damage/wounds_templates")
local armor_types = ArmorSettings.types
local damage_types = DamageSettings.damage_types
local gibbing_power = GibbingSettings.gibbing_power
local gibbing_types = GibbingSettings.gibbing_types
local damage_templates = {}
local overrides = {}

table.make_unique(damage_templates)
table.make_unique(overrides)

local damage_lerp_values = DamageProfileSettings.damage_lerp_values
local single_cleave = DamageProfileSettings.single_cleave
local pistol_crit_mod = {
	attack = {
		[armor_types.unarmored] = 0.1,
		[armor_types.armored] = 0.1,
		[armor_types.resistant] = 0.1,
		[armor_types.player] = 0.05,
		[armor_types.berserker] = 0.1,
		[armor_types.super_armor] = 0.1,
		[armor_types.disgustingly_resilient] = 0.1,
		[armor_types.void_shield] = 0,
	},
	impact = {
		[armor_types.unarmored] = 1.75,
		[armor_types.armored] = 1.75,
		[armor_types.resistant] = 1.75,
		[armor_types.player] = 1.75,
		[armor_types.berserker] = 1.75,
		[armor_types.super_armor] = 1.75,
		[armor_types.disgustingly_resilient] = 0.75,
		[armor_types.void_shield] = 0.75,
	},
}

damage_templates.phosphor_pistol_m1_m1_dmg = {
	ignore_hitzone_multiplier = true,
	stagger_category = "killshot",
	suppression_value = 9.5,
	cleave_distribution = {
		attack = {
			5,
			10,
		},
		impact = {
			4,
			8,
		},
	},
	ranges = {
		max = 20,
		min = 10,
	},
	herding_template = HerdingTemplates.shot,
	wounds_template = WoundsTemplates.phosphor,
	armor_damage_modifier_ranged = {
		near = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_0_9,
				[armor_types.armored] = damage_lerp_values.lerp_0_75,
				[armor_types.resistant] = damage_lerp_values.lerp_0_6,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_0_75,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_3,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_7,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_0_75,
				[armor_types.resistant] = damage_lerp_values.lerp_0_5,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_0_6,
				[armor_types.super_armor] = damage_lerp_values.no_damage,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_75,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_3,
			},
		},
		far = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_0_8,
				[armor_types.armored] = damage_lerp_values.lerp_0_7,
				[armor_types.resistant] = damage_lerp_values.lerp_0_5,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_0_7,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_25,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_6,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_4,
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_0_6,
				[armor_types.armored] = damage_lerp_values.lerp_0_5,
				[armor_types.resistant] = damage_lerp_values.lerp_0_3,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_0_6,
				[armor_types.super_armor] = damage_lerp_values.no_damage,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_5,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_25,
			},
		},
	},
	critical_strike = {
		cleave_distribution = {
			attack = {
				6,
				10,
			},
			impact = {
				5,
				10,
			},
		},
		gibbing_power = gibbing_power.medium,
		gibbing_type = gibbing_types.phosphor,
	},
	power_distribution = {
		attack = {
			400,
			600,
		},
		impact = {
			8,
			9,
		},
	},
	damage_type = damage_types.laser,
	gibbing_power = gibbing_power.light,
	gibbing_type = gibbing_types.phosphor,
	gib_push_force = GibbingSettings.gib_push_force.ranged_heavy,
	on_kill_area_suppression = {
		distance = 5,
		suppression_value = 12,
	},
	crit_mod = pistol_crit_mod,
	targets = {
		default_target = {
			crit_boost = 0.55,
			boost_curve = PowerLevelSettings.boost_curves.default,
			finesse_boost = {
				[armor_types.unarmored] = 0.2,
				[armor_types.armored] = 0.2,
				[armor_types.resistant] = 0.2,
				[armor_types.player] = 0.2,
				[armor_types.berserker] = 0.2,
				[armor_types.super_armor] = 0.2,
				[armor_types.disgustingly_resilient] = 0.2,
				[armor_types.void_shield] = 0.2,
			},
			boost_curve_multiplier_finesse = {
				1,
				2,
			},
		},
	},
	ragdoll_push_force = {
		20,
		30,
	},
}

local phosphor_burninating_adm = {
	[armor_types.unarmored] = 1,
	[armor_types.armored] = 1,
	[armor_types.resistant] = 1,
	[armor_types.player] = 0.125,
	[armor_types.berserker] = 1,
	[armor_types.super_armor] = 0.1,
	[armor_types.disgustingly_resilient] = 1,
	[armor_types.void_shield] = 1,
}

damage_templates.phosphor_pistol_backblast_explosion = {
	damage_type = "phosphor",
	shield_override_stagger_strength = 0,
	stagger_category = "flamer",
	suppression_value = 10,
	cleave_distribution = {
		attack = 0,
		impact = 0.1,
	},
	armor_damage_modifier = {
		attack = phosphor_burninating_adm,
		impact = phosphor_burninating_adm,
	},
	power_distribution = {
		attack = 0,
		impact = 1,
	},
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
	gibbing_type = gibbing_types.fire,
	gibbing_power = gibbing_power.light,
}

return {
	base_templates = damage_templates,
	overrides = overrides,
}
