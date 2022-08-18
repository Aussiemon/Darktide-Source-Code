local ArmorSettings = require("scripts/settings/damage/armor_settings")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local GibbingSettings = require("scripts/settings/gibbing/gibbing_settings")
local GibbingPower = GibbingSettings.gibbing_power
local GibbingTypes = GibbingSettings.gibbing_types
local armor_types = ArmorSettings.types
local damage_templates = {}
local overrides = {}

table.make_unique(damage_templates)
table.make_unique(overrides)

damage_templates.default_bfg = {
	ignore_stagger_reduction = true,
	suppression_value = 8,
	ignore_shield = true,
	ragdoll_push_force = 1000,
	stagger_category = "ranged",
	cleave_distribution = {
		attack = 0.15,
		impact = 0.15
	},
	ranges = {
		max = 20,
		min = 10
	},
	armor_damage_modifier_ranged = {
		near = {
			attack = {
				[armor_types.unarmored] = 1,
				[armor_types.armored] = 1,
				[armor_types.resistant] = 1,
				[armor_types.player] = 1,
				[armor_types.berserker] = 1,
				[armor_types.super_armor] = 0,
				[armor_types.disgustingly_resilient] = 1,
				[armor_types.void_shield] = 1,
				[armor_types.prop_armor] = 1
			},
			impact = {
				[armor_types.unarmored] = 2,
				[armor_types.armored] = 5,
				[armor_types.resistant] = 2,
				[armor_types.player] = 2,
				[armor_types.berserker] = 2,
				[armor_types.super_armor] = 0,
				[armor_types.disgustingly_resilient] = 5,
				[armor_types.void_shield] = 5,
				[armor_types.prop_armor] = 5
			}
		},
		far = {
			attack = {
				[armor_types.unarmored] = 1,
				[armor_types.armored] = 1,
				[armor_types.resistant] = 1,
				[armor_types.player] = 1,
				[armor_types.berserker] = 1,
				[armor_types.super_armor] = 0,
				[armor_types.disgustingly_resilient] = 1,
				[armor_types.void_shield] = 1,
				[armor_types.prop_armor] = 1
			},
			impact = {
				[armor_types.unarmored] = 2,
				[armor_types.armored] = 5,
				[armor_types.resistant] = 2,
				[armor_types.player] = 2,
				[armor_types.berserker] = 2,
				[armor_types.super_armor] = 2,
				[armor_types.disgustingly_resilient] = 5,
				[armor_types.void_shield] = 5,
				[armor_types.prop_armor] = 5
			}
		}
	},
	power_distribution = {
		attack = 2,
		impact = 4
	},
	gibbing_power = GibbingPower.heavy,
	gibbing_type = GibbingTypes.plasma,
	on_kill_area_suppression = {
		distance = 8,
		suppression_value = 10
	},
	targets = {
		default_target = {
			boost_curve_multiplier_finesse = 1.2,
			boost_curve = PowerLevelSettings.boost_curves.default,
			finesse_boost = {
				[armor_types.unarmored] = 0.75
			}
		}
	}
}
damage_templates.plasma_killshot = {
	ignore_stagger_reduction = true,
	suppression_value = 4,
	ignore_shield = false,
	ragdoll_push_force = 750,
	stagger_category = "ranged",
	cleave_distribution = {
		attack = 0.1,
		impact = 0.1
	},
	ranges = {
		max = 30,
		min = 20
	},
	armor_damage_modifier_ranged = {
		near = {
			attack = {
				[armor_types.unarmored] = 1,
				[armor_types.armored] = 1,
				[armor_types.resistant] = 2,
				[armor_types.player] = 1,
				[armor_types.berserker] = 1,
				[armor_types.super_armor] = 2,
				[armor_types.disgustingly_resilient] = 1,
				[armor_types.void_shield] = 1,
				[armor_types.prop_armor] = 1
			},
			impact = {
				[armor_types.unarmored] = 2,
				[armor_types.armored] = 5,
				[armor_types.resistant] = 2,
				[armor_types.player] = 2,
				[armor_types.berserker] = 2,
				[armor_types.super_armor] = 0.5,
				[armor_types.disgustingly_resilient] = 2.5,
				[armor_types.void_shield] = 2.5,
				[armor_types.prop_armor] = 5
			}
		},
		far = {
			attack = {
				[armor_types.unarmored] = 1,
				[armor_types.armored] = 1,
				[armor_types.resistant] = 2,
				[armor_types.player] = 1,
				[armor_types.berserker] = 1,
				[armor_types.super_armor] = 2,
				[armor_types.disgustingly_resilient] = 1,
				[armor_types.void_shield] = 1,
				[armor_types.prop_armor] = 1
			},
			impact = {
				[armor_types.unarmored] = 2,
				[armor_types.armored] = 5,
				[armor_types.resistant] = 2,
				[armor_types.player] = 2,
				[armor_types.berserker] = 2,
				[armor_types.super_armor] = 2,
				[armor_types.disgustingly_resilient] = 2.5,
				[armor_types.void_shield] = 2.5,
				[armor_types.prop_armor] = 5
			}
		}
	},
	power_distribution = {
		attack = 1.5,
		impact = 1
	},
	gibbing_power = GibbingPower.medium,
	gibbing_type = GibbingTypes.plasma,
	on_kill_area_suppression = {
		distance = 8,
		suppression_value = 10
	},
	targets = {
		default_target = {
			boost_curve_multiplier_finesse = 0.5,
			boost_curve = PowerLevelSettings.boost_curves.default,
			finesse_boost = {
				[armor_types.unarmored] = 0.75
			}
		}
	}
}
damage_templates.light_bfg = {
	ignore_stagger_reduction = true,
	suppression_value = 4,
	ignore_shield = true,
	ragdoll_push_force = 750,
	stagger_category = "ranged",
	cleave_distribution = {
		attack = 0.1,
		impact = 0.1
	},
	ranges = {
		max = 20,
		min = 10
	},
	armor_damage_modifier_ranged = {
		near = {
			attack = {
				[armor_types.unarmored] = 0.5,
				[armor_types.armored] = 1,
				[armor_types.resistant] = 1,
				[armor_types.player] = 1,
				[armor_types.berserker] = 1,
				[armor_types.super_armor] = 0.5,
				[armor_types.disgustingly_resilient] = 0.75,
				[armor_types.void_shield] = 0.75,
				[armor_types.prop_armor] = 1
			},
			impact = {
				[armor_types.unarmored] = 2,
				[armor_types.armored] = 5,
				[armor_types.resistant] = 2,
				[armor_types.player] = 2,
				[armor_types.berserker] = 2,
				[armor_types.super_armor] = 0.5,
				[armor_types.disgustingly_resilient] = 2.5,
				[armor_types.void_shield] = 2.5,
				[armor_types.prop_armor] = 5
			}
		},
		far = {
			attack = {
				[armor_types.unarmored] = 0.5,
				[armor_types.armored] = 1,
				[armor_types.resistant] = 1,
				[armor_types.player] = 1,
				[armor_types.berserker] = 1,
				[armor_types.super_armor] = 0.5,
				[armor_types.disgustingly_resilient] = 1,
				[armor_types.void_shield] = 1,
				[armor_types.prop_armor] = 1
			},
			impact = {
				[armor_types.unarmored] = 2,
				[armor_types.armored] = 5,
				[armor_types.resistant] = 2,
				[armor_types.player] = 2,
				[armor_types.berserker] = 2,
				[armor_types.super_armor] = 2,
				[armor_types.disgustingly_resilient] = 2.5,
				[armor_types.void_shield] = 2.5,
				[armor_types.prop_armor] = 5
			}
		}
	},
	power_distribution = {
		attack = 2,
		impact = 3
	},
	gibbing_power = GibbingPower.heavy,
	gibbing_type = GibbingTypes.plasma,
	on_kill_area_suppression = {
		distance = 8,
		suppression_value = 10
	},
	targets = {
		default_target = {
			boost_curve_multiplier_finesse = 1.2,
			boost_curve = PowerLevelSettings.boost_curves.default,
			finesse_boost = {
				[armor_types.unarmored] = 0.75
			}
		}
	}
}
damage_templates.light_bfg_spray = table.clone(damage_templates.light_bfg)
damage_templates.light_bfg_spray.power_distribution.attack = 0.5
damage_templates.light_bfg_spray.power_distribution.impact = 1

return {
	base_templates = damage_templates,
	overrides = overrides
}
