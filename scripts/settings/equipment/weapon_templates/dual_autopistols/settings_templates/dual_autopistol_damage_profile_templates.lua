-- chunkname: @scripts/settings/equipment/weapon_templates/dual_autopistols/settings_templates/dual_autopistol_damage_profile_templates.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local DamageProfileSettings = require("scripts/settings/damage/damage_profile_settings")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local GibbingSettings = require("scripts/settings/gibbing/gibbing_settings")
local HerdingTemplates = require("scripts/settings/damage/herding_templates")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local WoundsTemplates = require("scripts/settings/damage/wounds_templates")
local armor_types = ArmorSettings.types
local damage_lerp_values = DamageProfileSettings.damage_lerp_values
local damage_types = DamageSettings.damage_types
local gibbing_power = GibbingSettings.gibbing_power
local gibbing_types = GibbingSettings.gibbing_types
local single_cleave = DamageProfileSettings.single_cleave
local damage_templates = {}
local overrides = {}

table.make_unique(damage_templates)
table.make_unique(overrides)

damage_templates.default_dual_autopistol_assault = {
	stagger_category = "ranged",
	cleave_distribution = single_cleave,
	ranges = {
		max = 16,
		min = 13,
	},
	armor_damage_modifier_ranged = {
		near = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_0_7,
				[armor_types.resistant] = damage_lerp_values.lerp_0_7,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_0_7,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_01,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1_25,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_0_8,
				[armor_types.armored] = damage_lerp_values.lerp_0_5,
				[armor_types.resistant] = damage_lerp_values.lerp_0_6,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_0_6,
				[armor_types.super_armor] = damage_lerp_values.no_damage,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_3,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_01,
			},
		},
		far = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_0_8,
				[armor_types.armored] = damage_lerp_values.lerp_0_6,
				[armor_types.resistant] = damage_lerp_values.lerp_0_6,
				[armor_types.player] = damage_lerp_values.lerp_0_5,
				[armor_types.berserker] = damage_lerp_values.lerp_0_6,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_01,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_8,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_0_5,
				[armor_types.armored] = damage_lerp_values.lerp_0_4,
				[armor_types.resistant] = damage_lerp_values.lerp_0_5,
				[armor_types.player] = damage_lerp_values.lerp_0_3,
				[armor_types.berserker] = damage_lerp_values.lerp_0_01,
				[armor_types.super_armor] = damage_lerp_values.no_damage,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_4,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_01,
			},
		},
	},
	critical_strike = {
		gibbing_power = gibbing_power.light,
		gibbing_type = gibbing_types.ballistic,
	},
	power_distribution = {
		attack = {
			90,
			140,
		},
		impact = {
			5,
			7,
		},
	},
	accumulative_stagger_strength_multiplier = {
		1,
		1.5,
	},
	herding_template = HerdingTemplates.shot,
	wounds_template = WoundsTemplates.autopistol,
	damage_type = damage_types.auto_bullet,
	gibbing_power = gibbing_power.always,
	gibbing_type = gibbing_types.ballistic,
	suppression_attack_delay = {
		0.05,
		0.4,
	},
	suppression_value = {
		1.5,
		2.5,
	},
	on_kill_area_suppression = {
		suppression_value = {
			1,
			3,
		},
		distance = {
			2,
			5,
		},
	},
	ragdoll_push_force = {
		20,
		40,
	},
	gib_push_force = GibbingSettings.gib_push_force.ranged_light,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default,
			boost_curve_multiplier_finesse = {
				0.3,
				0.7,
			},
		},
	},
}
damage_templates.default_dual_autopistol_snp = {
	stagger_category = "ranged",
	cleave_distribution = single_cleave,
	ranges = {
		max = 17,
		min = 14,
	},
	armor_damage_modifier_ranged = {
		near = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_0_7,
				[armor_types.resistant] = damage_lerp_values.lerp_0_7,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_0_7,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_01,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1_25,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_0_8,
				[armor_types.armored] = damage_lerp_values.lerp_0_5,
				[armor_types.resistant] = damage_lerp_values.lerp_0_6,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_0_6,
				[armor_types.super_armor] = damage_lerp_values.no_damage,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_3,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_01,
			},
		},
		far = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_0_8,
				[armor_types.armored] = damage_lerp_values.lerp_0_6,
				[armor_types.resistant] = damage_lerp_values.lerp_0_6,
				[armor_types.player] = damage_lerp_values.lerp_0_5,
				[armor_types.berserker] = damage_lerp_values.lerp_0_6,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_01,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_8,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_0_5,
				[armor_types.armored] = damage_lerp_values.lerp_0_4,
				[armor_types.resistant] = damage_lerp_values.lerp_0_5,
				[armor_types.player] = damage_lerp_values.lerp_0_3,
				[armor_types.berserker] = damage_lerp_values.lerp_0_01,
				[armor_types.super_armor] = damage_lerp_values.no_damage,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_4,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_01,
			},
		},
	},
	critical_strike = {
		gibbing_power = gibbing_power.light,
		gibbing_type = gibbing_types.ballistic,
	},
	power_distribution = {
		attack = {
			90,
			140,
		},
		impact = {
			5,
			7,
		},
	},
	accumulative_stagger_strength_multiplier = {
		1,
		1.5,
	},
	herding_template = HerdingTemplates.shot,
	wounds_template = WoundsTemplates.autopistol,
	damage_type = damage_types.auto_bullet,
	gibbing_power = gibbing_power.always,
	gibbing_type = gibbing_types.ballistic,
	suppression_attack_delay = {
		0.09,
		0.5,
	},
	suppression_value = {
		1.5,
		2.5,
	},
	on_kill_area_suppression = {
		suppression_value = {
			1,
			3,
		},
		distance = {
			2,
			5,
		},
	},
	ragdoll_push_force = {
		20,
		40,
	},
	gib_push_force = GibbingSettings.gib_push_force.ranged_light,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default,
			boost_curve_multiplier_finesse = {
				0.3,
				0.7,
			},
		},
	},
}
damage_templates.default_pistol_whip = {
	ignore_stagger_reduction = true,
	is_push = true,
	ragdoll_push_force = 150,
	stagger_category = "uppercut",
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
			[armor_types.berserker] = 0.4,
			[armor_types.super_armor] = 0.3,
			[armor_types.disgustingly_resilient] = 0.7,
			[armor_types.void_shield] = 0,
		},
	},
	gibbing_type = gibbing_types.default,
	targets = {
		default_target = {
			power_distribution = {
				attack = {
					20,
					35,
				},
				impact = {
					6,
					12,
				},
			},
		},
	},
}

return {
	base_templates = damage_templates,
	overrides = overrides,
}
