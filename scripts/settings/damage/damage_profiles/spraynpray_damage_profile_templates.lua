-- chunkname: @scripts/settings/damage/damage_profiles/spraynpray_damage_profile_templates.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local DamageProfileSettings = require("scripts/settings/damage/damage_profile_settings")
local GibbingSettings = require("scripts/settings/gibbing/gibbing_settings")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local armor_types = ArmorSettings.types
local gibbing_power = GibbingSettings.gibbing_power
local single_cleave = DamageProfileSettings.single_cleave
local damage_templates = {}
local overrides = {}

table.make_unique(damage_templates)
table.make_unique(overrides)

damage_templates.default_spraynpray = {
	suppression_value = 4,
	stagger_category = "ranged",
	cleave_distribution = single_cleave,
	ranges = {
		max = 20,
		min = 10
	},
	armor_damage_modifier_ranged = {
		near = {
			attack = {
				[armor_types.unarmored] = 1,
				[armor_types.armored] = 0.55,
				[armor_types.resistant] = 1,
				[armor_types.player] = 1,
				[armor_types.berserker] = 0.5,
				[armor_types.super_armor] = 0,
				[armor_types.disgustingly_resilient] = 0.75,
				[armor_types.void_shield] = 0.75
			},
			impact = {
				[armor_types.unarmored] = 1,
				[armor_types.armored] = 1,
				[armor_types.resistant] = 1,
				[armor_types.player] = 1,
				[armor_types.berserker] = 0.5,
				[armor_types.super_armor] = 0,
				[armor_types.disgustingly_resilient] = 0.25,
				[armor_types.void_shield] = 0.25
			}
		},
		far = {
			attack = {
				[armor_types.unarmored] = 0.75,
				[armor_types.armored] = 0.55,
				[armor_types.resistant] = 1,
				[armor_types.player] = 1,
				[armor_types.berserker] = 0.5,
				[armor_types.super_armor] = 0,
				[armor_types.disgustingly_resilient] = 0.55,
				[armor_types.void_shield] = 0.55
			},
			impact = {
				[armor_types.unarmored] = 1,
				[armor_types.armored] = 2,
				[armor_types.resistant] = 1,
				[armor_types.player] = 1,
				[armor_types.berserker] = 0.5,
				[armor_types.super_armor] = 0,
				[armor_types.disgustingly_resilient] = 0.25,
				[armor_types.void_shield] = 0.25
			}
		}
	},
	power_distribution = {
		attack = 0.3,
		impact = 0.75
	},
	gibbing_power = gibbing_power.medium,
	on_kill_area_suppression = {
		distance = 2,
		suppression_value = 4
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
damage_templates.autogun_snp = {
	suppression_value = 4,
	ragdoll_push_force = 250,
	stagger_category = "ranged",
	cleave_distribution = single_cleave,
	ranges = {
		max = 25,
		min = 10
	},
	armor_damage_modifier_ranged = {
		near = {
			attack = {
				[armor_types.unarmored] = 1,
				[armor_types.armored] = 0.5,
				[armor_types.resistant] = 1,
				[armor_types.player] = 1,
				[armor_types.berserker] = 0.5,
				[armor_types.super_armor] = 0,
				[armor_types.disgustingly_resilient] = 0.5,
				[armor_types.void_shield] = 0.5
			},
			impact = {
				[armor_types.unarmored] = 1,
				[armor_types.armored] = 1,
				[armor_types.resistant] = 1,
				[armor_types.player] = 1,
				[armor_types.berserker] = 0.5,
				[armor_types.super_armor] = 0,
				[armor_types.disgustingly_resilient] = 1,
				[armor_types.void_shield] = 1
			}
		},
		far = {
			attack = {
				[armor_types.unarmored] = 1,
				[armor_types.armored] = 0.5,
				[armor_types.resistant] = 1,
				[armor_types.player] = 1,
				[armor_types.berserker] = 0.5,
				[armor_types.super_armor] = 0,
				[armor_types.disgustingly_resilient] = 0.5,
				[armor_types.void_shield] = 0.5
			},
			impact = {
				[armor_types.unarmored] = 1,
				[armor_types.armored] = 1,
				[armor_types.resistant] = 1,
				[armor_types.player] = 1,
				[armor_types.berserker] = 0.5,
				[armor_types.super_armor] = 0,
				[armor_types.disgustingly_resilient] = 1,
				[armor_types.void_shield] = 1
			}
		}
	},
	power_distribution = {
		attack = 0.3,
		impact = 0.4
	},
	gibbing_power = gibbing_power.medium,
	on_kill_area_suppression = {
		distance = 2,
		suppression_value = 4
	},
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.rippergun_spraynpray = {
	ignore_stagger_reduction = true,
	suppression_value = 5,
	ragdoll_only = true,
	stagger_category = "ranged",
	cleave_distribution = {
		attack = 0.01,
		impact = 0.1
	},
	ranges = {
		max = 25,
		min = 10
	},
	armor_damage_modifier_ranged = {
		near = {
			attack = {
				[armor_types.unarmored] = 1,
				[armor_types.armored] = 0.75,
				[armor_types.resistant] = 0.8,
				[armor_types.player] = 1,
				[armor_types.berserker] = 0.9,
				[armor_types.super_armor] = 0,
				[armor_types.disgustingly_resilient] = 1.5,
				[armor_types.void_shield] = 1.5
			},
			impact = {
				[armor_types.unarmored] = 2,
				[armor_types.armored] = 3,
				[armor_types.resistant] = 2,
				[armor_types.player] = 2,
				[armor_types.berserker] = 2,
				[armor_types.super_armor] = 0,
				[armor_types.disgustingly_resilient] = 2,
				[armor_types.void_shield] = 2
			}
		},
		far = {
			attack = {
				[armor_types.unarmored] = 0.5,
				[armor_types.armored] = 0.25,
				[armor_types.resistant] = 0.5,
				[armor_types.player] = 0.1,
				[armor_types.berserker] = 0.2,
				[armor_types.super_armor] = 0,
				[armor_types.disgustingly_resilient] = 0.6,
				[armor_types.void_shield] = 0.6
			},
			impact = {
				[armor_types.unarmored] = 1,
				[armor_types.armored] = 0.5,
				[armor_types.resistant] = 0.5,
				[armor_types.player] = 0,
				[armor_types.berserker] = 0.5,
				[armor_types.super_armor] = 0,
				[armor_types.disgustingly_resilient] = 1.5,
				[armor_types.void_shield] = 1.5
			}
		}
	},
	power_distribution = {
		attack = 1.5,
		impact = 1.75
	},
	gibbing_power = gibbing_power.medium,
	targets = {
		default_target = {
			boost_curve_multiplier_finesse = 1.2,
			boost_curve = PowerLevelSettings.boost_curves.default,
			finesse_boost = {
				[armor_types.unarmored] = 0.75
			}
		}
	},
	ragdoll_push_force = {
		400,
		600
	}
}

return {
	base_templates = damage_templates,
	overrides = overrides
}
