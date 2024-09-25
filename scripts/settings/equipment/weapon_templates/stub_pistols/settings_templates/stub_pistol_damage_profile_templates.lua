-- chunkname: @scripts/settings/equipment/weapon_templates/stub_pistols/settings_templates/stub_pistol_damage_profile_templates.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local DamageProfileSettings = require("scripts/settings/damage/damage_profile_settings")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local GibbingSettings = require("scripts/settings/gibbing/gibbing_settings")
local GibbingPower = GibbingSettings.gibbing_power
local GibbingTypes = GibbingSettings.gibbing_types
local HerdingTemplates = require("scripts/settings/damage/herding_templates")
local WoundsTemplates = require("scripts/settings/damage/wounds_templates")
local damage_types = DamageSettings.damage_types
local armor_types = ArmorSettings.types
local damage_templates = {}
local overrides = {}

table.make_unique(damage_templates)
table.make_unique(overrides)

local crit_armor_mod = DamageProfileSettings.crit_armor_mod
local crit_impact_armor_mod = DamageProfileSettings.crit_impact_armor_mod
local damage_lerp_values = DamageProfileSettings.damage_lerp_values
local single_cleave = DamageProfileSettings.single_cleave
local double_cleave = DamageProfileSettings.double_cleave
local medium_cleave = DamageProfileSettings.medium_cleave
local big_cleave = DamageProfileSettings.big_cleave
local armor_modifiers = {
	p1_m1 = {
		near = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_1,
				[armor_types.resistant] = damage_lerp_values.lerp_1,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_1,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_4,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_1,
				[armor_types.resistant] = damage_lerp_values.lerp_1,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_1,
				[armor_types.super_armor] = damage_lerp_values.lerp_1,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
			},
		},
		far = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_0_8,
				[armor_types.armored] = damage_lerp_values.lerp_0_8,
				[armor_types.resistant] = damage_lerp_values.lerp_0_8,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_0_8,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_8,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_4,
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_0_8,
				[armor_types.armored] = damage_lerp_values.lerp_0_8,
				[armor_types.resistant] = damage_lerp_values.lerp_0_8,
				[armor_types.player] = damage_lerp_values.lerp_0_8,
				[armor_types.berserker] = damage_lerp_values.lerp_0_8,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_8,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_8,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_4,
			},
		},
	},
	p1_m2 = {
		near = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1_25,
				[armor_types.armored] = damage_lerp_values.lerp_0_8,
				[armor_types.resistant] = damage_lerp_values.lerp_1_5,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_1_2,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_3,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1_25,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_1,
				[armor_types.resistant] = damage_lerp_values.lerp_1,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_1,
				[armor_types.super_armor] = damage_lerp_values.lerp_1,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
			},
		},
		far = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_0_6,
				[armor_types.armored] = damage_lerp_values.lerp_0_6,
				[armor_types.resistant] = damage_lerp_values.lerp_0_9,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_0_6,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_1,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_7,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_0_8,
				[armor_types.armored] = damage_lerp_values.lerp_0_8,
				[armor_types.resistant] = damage_lerp_values.lerp_0_8,
				[armor_types.player] = damage_lerp_values.lerp_0_8,
				[armor_types.berserker] = damage_lerp_values.lerp_0_8,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_8,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_8,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_4,
			},
		},
	},
	p1_m3 = {
		near = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_1,
				[armor_types.resistant] = damage_lerp_values.lerp_1,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_1,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_6,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_1,
				[armor_types.resistant] = damage_lerp_values.lerp_1,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_1,
				[armor_types.super_armor] = damage_lerp_values.lerp_1,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
			},
		},
		far = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_0_8,
				[armor_types.armored] = damage_lerp_values.lerp_0_8,
				[armor_types.resistant] = damage_lerp_values.lerp_0_8,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_0_8,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_8,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_4,
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_0_8,
				[armor_types.armored] = damage_lerp_values.lerp_0_8,
				[armor_types.resistant] = damage_lerp_values.lerp_0_8,
				[armor_types.player] = damage_lerp_values.lerp_0_8,
				[armor_types.berserker] = damage_lerp_values.lerp_0_8,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_8,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_8,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_4,
			},
		},
	},
}

damage_templates.default_stub_pistol_bfg = {
	ignore_stagger_reduction = true,
	ragdoll_push_force = 350,
	stagger_category = "melee",
	suppression_value = 2.5,
	cleave_distribution = medium_cleave,
	ranges = {
		max = 35,
		min = 13,
	},
	armor_damage_modifier_ranged = armor_modifiers.p1_m1,
	critical_strike = {
		gibbing_power = GibbingPower.medium,
		gibbing_type = GibbingTypes.ballistic,
	},
	crit_mod = {
		attack = {
			[armor_types.unarmored] = {
				0,
				0.3,
			},
			[armor_types.armored] = {
				0,
				0.3,
			},
			[armor_types.resistant] = {
				0,
				0.3,
			},
			[armor_types.player] = {
				0,
				0.3,
			},
			[armor_types.berserker] = {
				0,
				0.3,
			},
			[armor_types.super_armor] = {
				0,
				0.15,
			},
			[armor_types.disgustingly_resilient] = {
				0,
				0.3,
			},
			[armor_types.void_shield] = {
				0,
				0.3,
			},
		},
		impact = crit_impact_armor_mod,
	},
	power_distribution = {
		attack = {
			300,
			600,
		},
		impact = {
			10,
			20,
		},
	},
	herding_template = HerdingTemplates.shot,
	damage_type = damage_types.auto_bullet,
	wounds_template = WoundsTemplates.stubrevolver,
	gibbing_power = GibbingPower.light,
	gibbing_type = GibbingTypes.ballistic,
	gib_push_force = GibbingSettings.gib_push_force.ranged_medium,
	on_kill_area_suppression = {
		distance = 4,
		suppression_value = 12,
	},
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default,
			finesse_boost = {
				[armor_types.unarmored] = 0.5,
				[armor_types.armored] = 0.5,
				[armor_types.super_armor] = 0.25,
				[armor_types.resistant] = 0.25,
			},
			boost_curve_multiplier_finesse = damage_lerp_values.lerp_1_5,
		},
	},
}
damage_templates.stub_pistol_p1_m2 = {
	ignore_stagger_reduction = true,
	ragdoll_push_force = 350,
	stagger_category = "melee",
	suppression_value = 1.5,
	cleave_distribution = double_cleave,
	ranges = {
		max = 25,
		min = 10,
	},
	armor_damage_modifier_ranged = armor_modifiers.p1_m2,
	critical_strike = {
		gibbing_power = GibbingPower.medium,
		gibbing_type = GibbingTypes.ballistic,
	},
	crit_mod = {
		attack = {
			[armor_types.unarmored] = {
				0,
				0.3,
			},
			[armor_types.armored] = {
				0,
				0.3,
			},
			[armor_types.resistant] = {
				0,
				0.3,
			},
			[armor_types.player] = {
				0,
				0.3,
			},
			[armor_types.berserker] = {
				0,
				0.3,
			},
			[armor_types.super_armor] = {
				0,
				0.15,
			},
			[armor_types.disgustingly_resilient] = {
				0,
				0.3,
			},
			[armor_types.void_shield] = {
				0,
				0.3,
			},
		},
		impact = crit_impact_armor_mod,
	},
	power_distribution = {
		attack = {
			210,
			420,
		},
		impact = {
			6,
			12,
		},
	},
	herding_template = HerdingTemplates.shot,
	damage_type = damage_types.auto_bullet,
	wounds_template = WoundsTemplates.stubrevolver,
	gibbing_power = GibbingPower.light,
	gibbing_type = GibbingTypes.ballistic,
	gib_push_force = GibbingSettings.gib_push_force.ranged_medium,
	on_kill_area_suppression = {
		distance = 2,
		suppression_value = 12,
	},
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default,
			finesse_boost = {
				[armor_types.unarmored] = 0.5,
				[armor_types.armored] = 0.5,
				[armor_types.super_armor] = 0.25,
				[armor_types.resistant] = 0.25,
			},
			boost_curve_multiplier_finesse = damage_lerp_values.lerp_1_5,
		},
	},
}
damage_templates.stub_pistol_p1_m3 = {
	ragdoll_push_force = 450,
	stagger_category = "killshot",
	suppression_value = 0.6,
	cleave_distribution = big_cleave,
	ranges = {
		max = 35,
		min = 13,
	},
	armor_damage_modifier_ranged = armor_modifiers.p1_m3,
	critical_strike = {
		gibbing_power = GibbingPower.medium,
		gibbing_type = GibbingTypes.ballistic,
	},
	crit_mod = {
		attack = crit_armor_mod,
		impact = crit_impact_armor_mod,
	},
	power_distribution = {
		attack = {
			420,
			840,
		},
		impact = {
			20,
			40,
		},
	},
	damage_type = damage_types.auto_bullet,
	gibbing_power = GibbingPower.light,
	gibbing_type = GibbingTypes.ballistic,
	on_kill_area_suppression = {
		distance = 3,
		suppression_value = 2,
	},
	targets = {
		default_target = {
			boost_curve_multiplier_finesse = 0.5,
			boost_curve = PowerLevelSettings.boost_curves.default,
			finesse_boost = {
				[armor_types.unarmored] = 1,
				[armor_types.armored] = 0.6,
			},
		},
	},
	gib_push_force = GibbingSettings.gib_push_force.ranged_medium,
}

return {
	base_templates = damage_templates,
	overrides = overrides,
}
