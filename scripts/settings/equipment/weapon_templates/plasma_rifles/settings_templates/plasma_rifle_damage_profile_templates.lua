-- chunkname: @scripts/settings/equipment/weapon_templates/plasma_rifles/settings_templates/plasma_rifle_damage_profile_templates.lua

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
local damage_templates = {}
local overrides = {}

table.make_unique(damage_templates)
table.make_unique(overrides)

damage_templates.default_plasma_killshot = {
	gibbing_power = 0,
	ignore_shield = false,
	ignore_stagger_reduction = true,
	ragdoll_only = true,
	ragdoll_push_force = 300,
	stagger_category = "melee",
	suppression_value = 10,
	herding_template = HerdingTemplates.shot,
	cleave_distribution = {
		attack = 3.01,
		impact = 3.01,
	},
	ranges = {
		max = 30,
		min = 20,
	},
	armor_damage_modifier_ranged = {
		near = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_1,
				[armor_types.resistant] = damage_lerp_values.lerp_2,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_1,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
				[armor_types.void_shield] = damage_lerp_values.lerp_1,
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_1,
				[armor_types.resistant] = damage_lerp_values.lerp_1,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_1,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
				[armor_types.void_shield] = damage_lerp_values.lerp_1,
			},
		},
		far = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_1,
				[armor_types.resistant] = damage_lerp_values.lerp_2,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_1,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
				[armor_types.void_shield] = damage_lerp_values.lerp_1,
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_1,
				[armor_types.resistant] = damage_lerp_values.lerp_1,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_1,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
				[armor_types.void_shield] = damage_lerp_values.lerp_1,
			},
		},
	},
	power_distribution = {
		impact = 100,
		attack = {
			400,
			600,
		},
	},
	wounds_template = WoundsTemplates.plasma,
	damage_type = damage_types.plasma,
	gibbing_type = gibbing_types.plasma,
	ignore_hitzone_multipliers_breed_tags = {
		"horde",
		"roamer",
		"elite",
		"special",
	},
	on_kill_area_suppression = {
		distance = 8,
		suppression_value = 10,
	},
	targets = {
		default_target = {
			boost_curve_multiplier_finesse = 0.5,
			boost_curve = PowerLevelSettings.boost_curves.default,
			finesse_boost = {
				[armor_types.unarmored] = 0.75,
			},
		},
	},
	gib_push_force = GibbingSettings.gib_push_force.ranged_heavy,
}
damage_templates.default_plasma_bfg = {
	ignore_shield = true,
	ignore_stagger_reduction = true,
	ragdoll_only = true,
	ragdoll_push_force = 500,
	stagger_category = "ranged",
	suppression_value = 8,
	weakspot_stagger_resistance_modifier = 0.0001,
	herding_template = HerdingTemplates.shot,
	cleave_distribution = {
		attack = 100,
		impact = 105,
	},
	ranges = {
		max = 20,
		min = 10,
	},
	armor_damage_modifier_ranged = {
		near = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_1,
				[armor_types.resistant] = damage_lerp_values.lerp_1_5,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_1_25,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_75,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
				[armor_types.void_shield] = damage_lerp_values.lerp_1,
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_1,
				[armor_types.resistant] = damage_lerp_values.lerp_1,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_1,
				[armor_types.super_armor] = damage_lerp_values.lerp_1_5,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
				[armor_types.void_shield] = damage_lerp_values.lerp_1,
			},
		},
		far = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_1,
				[armor_types.resistant] = damage_lerp_values.lerp_1_5,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_1_25,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
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
	},
	power_distribution = {
		attack = {
			700,
			1400,
		},
		impact = {
			30,
			60,
		},
	},
	wounds_template = WoundsTemplates.plasma,
	damage_type = damage_types.plasma,
	gibbing_power = gibbing_power.heavy,
	gibbing_type = gibbing_types.plasma,
	ignore_hitzone_multipliers_breed_tags = {
		"horde",
		"roamer",
		"elite",
		"special",
	},
	on_kill_area_suppression = {
		distance = 8,
		suppression_value = 10,
		decay_delay = {
			0.2,
			0.6,
		},
	},
	targets = {
		default_target = {
			boost_curve_multiplier_finesse = 0.5,
			boost_curve = PowerLevelSettings.boost_curves.default,
			finesse_boost = {
				[armor_types.unarmored] = 0.75,
			},
		},
	},
	gib_push_force = GibbingSettings.gib_push_force.ranged_heavy,
}
damage_templates.default_plasma_bfg_light = {
	ignore_shield = true,
	ignore_stagger_reduction = true,
	ragdoll_only = true,
	ragdoll_push_force = 500,
	stagger_category = "ranged",
	suppression_value = 8,
	weakspot_stagger_resistance_modifier = 0.0001,
	herding_template = HerdingTemplates.shot,
	cleave_distribution = {
		attack = 34.3,
		impact = 34.3,
	},
	ranges = {
		max = 20,
		min = 10,
	},
	armor_damage_modifier_ranged = {
		near = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_1,
				[armor_types.resistant] = damage_lerp_values.lerp_1_5,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_1_25,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_75,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
				[armor_types.void_shield] = damage_lerp_values.lerp_1,
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_1,
				[armor_types.resistant] = damage_lerp_values.lerp_1,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_1,
				[armor_types.super_armor] = damage_lerp_values.lerp_1_5,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
				[armor_types.void_shield] = damage_lerp_values.lerp_1,
			},
		},
		far = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_1,
				[armor_types.resistant] = damage_lerp_values.lerp_1_5,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_1_25,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
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
	},
	power_distribution = {
		attack = {
			700,
			1400,
		},
		impact = {
			30,
			60,
		},
	},
	wounds_template = WoundsTemplates.plasma,
	damage_type = damage_types.plasma,
	gibbing_power = gibbing_power.heavy,
	gibbing_type = gibbing_types.plasma,
	ignore_hitzone_multipliers_breed_tags = {
		"horde",
		"roamer",
		"elite",
		"special",
	},
	on_kill_area_suppression = {
		distance = 8,
		suppression_value = 10,
		decay_delay = {
			0.2,
			0.6,
		},
	},
	targets = {
		default_target = {
			boost_curve_multiplier_finesse = 0.5,
			boost_curve = PowerLevelSettings.boost_curves.default,
			finesse_boost = {
				[armor_types.unarmored] = 0.75,
			},
		},
	},
	gib_push_force = GibbingSettings.gib_push_force.ranged_heavy,
}
damage_templates.default_plasma_demolition = {
	ignore_stagger_reduction = true,
	ragdoll_push_force = 800,
	stagger_category = "ranged",
	suppression_value = 0.5,
	herding_template = HerdingTemplates.shot,
	cleave_distribution = {
		attack = 0.1,
		impact = 0.1,
	},
	ranges = {
		max = 20,
		min = 10,
	},
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_1,
			[armor_types.resistant] = damage_lerp_values.lerp_1,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_1,
			[armor_types.super_armor] = damage_lerp_values.lerp_1,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
			[armor_types.void_shield] = damage_lerp_values.lerp_1,
		},
		impact = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_2,
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
			300,
			600,
		},
		impact = {
			10,
			20,
		},
	},
	wounds_template = WoundsTemplates.plasma,
	damage_type = damage_types.laser,
	gibbing_power = gibbing_power.always,
	gibbing_type = gibbing_types.explosion,
	ignore_hitzone_multipliers_breed_tags = {
		"horde",
		"roamer",
		"elite",
		"special",
	},
	targets = {
		default_target = {
			boost_curve_multiplier_finesse = 0.2,
			boost_curve = PowerLevelSettings.boost_curves.default,
			finesse_boost = {
				[armor_types.unarmored] = 0.75,
			},
		},
	},
	gib_push_force = GibbingSettings.gib_push_force.ranged_heavy,
}
damage_templates.close_light_plasma_demolition = {
	ragdoll_push_force = 800,
	stagger_category = "ranged",
	suppression_value = 0.5,
	cleave_distribution = {
		attack = 0.1,
		impact = 0.1,
	},
	ranges = {
		max = 20,
		min = 10,
	},
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_0_5,
			[armor_types.resistant] = damage_lerp_values.lerp_1,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_0_5,
			[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
			[armor_types.void_shield] = damage_lerp_values.lerp_1,
		},
		impact = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_2,
			[armor_types.resistant] = damage_lerp_values.lerp_1,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_1,
			[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
			[armor_types.void_shield] = damage_lerp_values.lerp_1,
		},
	},
	power_distribution_ranged = {
		attack = {
			far = 5,
			near = 50,
		},
		impact = {
			far = 1,
			near = 15,
		},
	},
	wounds_template = WoundsTemplates.plasma,
	damage_type = damage_types.laser,
	gibbing_power = gibbing_power.always,
	gibbing_type = gibbing_types.explosion,
	ignore_hitzone_multipliers_breed_tags = {
		"horde",
		"roamer",
		"elite",
		"special",
	},
	targets = {
		default_target = {
			boost_curve_multiplier_finesse = 0.2,
			boost_curve = PowerLevelSettings.boost_curves.default,
			finesse_boost = {
				[armor_types.unarmored] = 0.75,
			},
		},
	},
	gib_push_force = GibbingSettings.gib_push_force.ranged_heavy,
}
damage_templates.light_plasma_demolition = {
	ragdoll_push_force = 800,
	stagger_category = "ranged",
	suppression_value = 0.5,
	cleave_distribution = {
		attack = 0.1,
		impact = 0.1,
	},
	ranges = {
		max = 20,
		min = 10,
	},
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_0_5,
			[armor_types.resistant] = damage_lerp_values.lerp_1,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_0_5,
			[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
			[armor_types.void_shield] = damage_lerp_values.lerp_1,
		},
		impact = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_2,
			[armor_types.resistant] = damage_lerp_values.lerp_1,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_1,
			[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
			[armor_types.void_shield] = damage_lerp_values.lerp_1,
		},
	},
	power_distribution_ranged = {
		attack = {
			far = 5,
			near = 50,
		},
		impact = {
			far = 1,
			near = 15,
		},
	},
	wounds_template = WoundsTemplates.plasma,
	damage_type = damage_types.laser,
	gibbing_power = gibbing_power.always,
	gibbing_type = gibbing_types.explosion,
	ignore_hitzone_multipliers_breed_tags = {
		"horde",
		"roamer",
		"elite",
		"special",
	},
	targets = {
		default_target = {
			boost_curve_multiplier_finesse = 0.2,
			boost_curve = PowerLevelSettings.boost_curves.default,
			finesse_boost = {
				[armor_types.unarmored] = 0.75,
			},
		},
	},
	gib_push_force = GibbingSettings.gib_push_force.ranged_heavy,
}
damage_templates.plasma_p1_m2_light = {
	ignore_shield = true,
	ignore_stagger_reduction = true,
	ragdoll_only = true,
	ragdoll_push_force = 500,
	stagger_category = "ranged",
	suppression_value = 8,
	weakspot_stagger_resistance_modifier = 0.01,
	herding_template = HerdingTemplates.shot,
	cleave_distribution = {
		attack = {
			0.001,
			0.001,
		},
		impact = {
			0.001,
			0.001,
		},
	},
	ranges = {
		max = 20,
		min = 10,
	},
	armor_damage_modifier_ranged = {
		near = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_1,
				[armor_types.resistant] = damage_lerp_values.lerp_1_5,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_1_25,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_75,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
				[armor_types.void_shield] = damage_lerp_values.lerp_1,
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_1,
				[armor_types.resistant] = damage_lerp_values.lerp_1,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_1,
				[armor_types.super_armor] = damage_lerp_values.lerp_1_5,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
				[armor_types.void_shield] = damage_lerp_values.lerp_1,
			},
		},
		far = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_1,
				[armor_types.resistant] = damage_lerp_values.lerp_1_5,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_1_25,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
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
	},
	power_distribution = {
		attack = {
			300,
			1000,
		},
		impact = {
			20,
			40,
		},
	},
	wounds_template = WoundsTemplates.plasma,
	damage_type = damage_types.plasma,
	gibbing_power = gibbing_power.heavy,
	gibbing_type = gibbing_types.plasma,
	ignore_hitzone_multipliers_breed_tags = {
		"horde",
		"roamer",
		"elite",
		"special",
	},
	on_kill_area_suppression = {
		distance = 8,
		suppression_value = 10,
		decay_delay = {
			0.2,
			0.6,
		},
	},
	targets = {
		default_target = {
			boost_curve_multiplier_finesse = 0.5,
			boost_curve = PowerLevelSettings.boost_curves.default,
			finesse_boost = {
				[armor_types.unarmored] = 0.75,
			},
		},
	},
	gib_push_force = GibbingSettings.gib_push_force.ranged_heavy,
}
damage_templates.plasma_p1_m2_charged = {
	ignore_shield = true,
	ignore_stagger_reduction = true,
	ragdoll_only = true,
	ragdoll_push_force = 500,
	stagger_category = "ranged",
	suppression_value = 8,
	weakspot_stagger_resistance_modifier = 0.01,
	herding_template = HerdingTemplates.shot,
	cleave_distribution = {
		attack = {
			0.001,
			0.001,
		},
		impact = {
			0.001,
			0.001,
		},
	},
	ranges = {
		max = 20,
		min = 10,
	},
	armor_damage_modifier_ranged = {
		near = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1_1,
				[armor_types.armored] = damage_lerp_values.lerp_1,
				[armor_types.resistant] = damage_lerp_values.lerp_1_75,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_1_25,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_75,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
				[armor_types.void_shield] = damage_lerp_values.lerp_1,
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_1,
				[armor_types.resistant] = damage_lerp_values.lerp_1,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_1,
				[armor_types.super_armor] = damage_lerp_values.lerp_1_5,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
				[armor_types.void_shield] = damage_lerp_values.lerp_1,
			},
		},
		far = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_1,
				[armor_types.resistant] = damage_lerp_values.lerp_2,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_1_25,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
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
	},
	power_distribution = {
		attack = {
			550,
			1200,
		},
		impact = {
			30,
			60,
		},
	},
	wounds_template = WoundsTemplates.plasma,
	damage_type = damage_types.plasma,
	gibbing_power = gibbing_power.heavy,
	gibbing_type = gibbing_types.plasma,
	ignore_hitzone_multipliers_breed_tags = {
		"horde",
		"roamer",
		"elite",
		"special",
	},
	on_kill_area_suppression = {
		distance = 8,
		suppression_value = 10,
		decay_delay = {
			0.2,
			0.6,
		},
	},
	targets = {
		default_target = {
			boost_curve_multiplier_finesse = 0.5,
			boost_curve = PowerLevelSettings.boost_curves.default,
			finesse_boost = {
				[armor_types.unarmored] = 0.75,
			},
		},
	},
	gib_push_force = GibbingSettings.gib_push_force.ranged_heavy,
}
damage_templates.close_light_plasma_demolition_p1_m2 = {
	ragdoll_push_force = 800,
	stagger_category = "ranged",
	suppression_value = 0.5,
	cleave_distribution = {
		attack = 0.1,
		impact = 0.1,
	},
	ranges = {
		max = 20,
		min = 10,
	},
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_0_5,
			[armor_types.resistant] = damage_lerp_values.lerp_1,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_0_5,
			[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
			[armor_types.void_shield] = damage_lerp_values.lerp_1,
		},
		impact = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_2,
			[armor_types.resistant] = damage_lerp_values.lerp_1,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_1,
			[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
			[armor_types.void_shield] = damage_lerp_values.lerp_1,
		},
	},
	power_distribution_ranged = {
		attack = {
			far = 200,
			near = 250,
		},
		impact = {
			far = 13,
			near = 15,
		},
	},
	wounds_template = WoundsTemplates.plasma,
	damage_type = damage_types.laser,
	gibbing_power = gibbing_power.always,
	gibbing_type = gibbing_types.explosion,
	ignore_hitzone_multipliers_breed_tags = {
		"horde",
		"roamer",
		"elite",
		"special",
	},
	targets = {
		default_target = {
			boost_curve_multiplier_finesse = 0.2,
			boost_curve = PowerLevelSettings.boost_curves.default,
			finesse_boost = {
				[armor_types.unarmored] = 0.75,
			},
		},
	},
	gib_push_force = GibbingSettings.gib_push_force.ranged_heavy,
}
damage_templates.far_light_plasma_demolition_p1_m2 = {
	ragdoll_push_force = 800,
	stagger_category = "ranged",
	suppression_value = 0.5,
	cleave_distribution = {
		attack = 0.1,
		impact = 0.1,
	},
	ranges = {
		max = 20,
		min = 10,
	},
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = damage_lerp_values.lerp_0_8,
			[armor_types.armored] = damage_lerp_values.lerp_0_4,
			[armor_types.resistant] = damage_lerp_values.lerp_1,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_0_5,
			[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_8,
			[armor_types.void_shield] = damage_lerp_values.lerp_1,
		},
		impact = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_2,
			[armor_types.resistant] = damage_lerp_values.lerp_1,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_1,
			[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
			[armor_types.void_shield] = damage_lerp_values.lerp_1,
		},
	},
	power_distribution_ranged = {
		attack = {
			far = 75,
			near = 150,
		},
		impact = {
			far = 10,
			near = 13,
		},
	},
	wounds_template = WoundsTemplates.plasma,
	damage_type = damage_types.laser,
	gibbing_power = gibbing_power.always,
	gibbing_type = gibbing_types.explosion,
	ignore_hitzone_multipliers_breed_tags = {
		"horde",
		"roamer",
		"elite",
		"special",
	},
	targets = {
		default_target = {
			boost_curve_multiplier_finesse = 0.2,
			boost_curve = PowerLevelSettings.boost_curves.default,
			finesse_boost = {
				[armor_types.unarmored] = 0.75,
			},
		},
	},
	gib_push_force = GibbingSettings.gib_push_force.ranged_heavy,
}
damage_templates.close_charged_plasma_demolition_p1_m2 = {
	ignore_stagger_reduction = true,
	ragdoll_push_force = 800,
	stagger_category = "ranged",
	suppression_value = 0.5,
	herding_template = HerdingTemplates.shot,
	cleave_distribution = {
		attack = 0.1,
		impact = 0.1,
	},
	ranges = {
		max = 20,
		min = 10,
	},
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_1,
			[armor_types.resistant] = damage_lerp_values.lerp_1,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_1,
			[armor_types.super_armor] = damage_lerp_values.lerp_1,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
			[armor_types.void_shield] = damage_lerp_values.lerp_1,
		},
		impact = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_2,
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
			500,
			800,
		},
		impact = {
			10,
			20,
		},
	},
	wounds_template = WoundsTemplates.plasma,
	damage_type = damage_types.laser,
	gibbing_power = gibbing_power.heavy,
	gibbing_type = gibbing_types.explosion,
	ignore_hitzone_multipliers_breed_tags = {
		"horde",
		"roamer",
		"elite",
		"special",
	},
	targets = {
		default_target = {
			boost_curve_multiplier_finesse = 0.2,
			boost_curve = PowerLevelSettings.boost_curves.default,
			finesse_boost = {
				[armor_types.unarmored] = 0.75,
			},
		},
	},
	gib_push_force = GibbingSettings.gib_push_force.ranged_heavy,
}
damage_templates.far_charged_plasma_demolition_p1_m2 = {
	ragdoll_push_force = 800,
	stagger_category = "ranged",
	suppression_value = 0.5,
	cleave_distribution = {
		attack = 150.1,
		impact = 3.1,
	},
	ranges = {
		max = 20,
		min = 10,
	},
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = damage_lerp_values.lerp_0_8,
			[armor_types.armored] = damage_lerp_values.lerp_0_4,
			[armor_types.resistant] = damage_lerp_values.lerp_1,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_0_5,
			[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_8,
			[armor_types.void_shield] = damage_lerp_values.lerp_1,
		},
		impact = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_2,
			[armor_types.resistant] = damage_lerp_values.lerp_1,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_1,
			[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
			[armor_types.void_shield] = damage_lerp_values.lerp_1,
		},
	},
	power_distribution_ranged = {
		attack = {
			far = 300,
			near = 350,
		},
		impact = {
			far = 15,
			near = 25,
		},
	},
	wounds_template = WoundsTemplates.plasma,
	damage_type = damage_types.laser,
	gibbing_power = gibbing_power.heavy,
	gibbing_type = gibbing_types.explosion,
	ignore_hitzone_multipliers_breed_tags = {
		"horde",
		"roamer",
		"elite",
		"special",
	},
	targets = {
		default_target = {
			boost_curve_multiplier_finesse = 0.2,
			boost_curve = PowerLevelSettings.boost_curves.default,
			finesse_boost = {
				[armor_types.unarmored] = 0.75,
			},
		},
	},
	gib_push_force = GibbingSettings.gib_push_force.ranged_heavy,
}

return {
	base_templates = damage_templates,
	overrides = overrides,
}
