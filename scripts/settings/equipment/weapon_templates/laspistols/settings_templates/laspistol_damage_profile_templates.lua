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

local crit_armor_mod = DamageProfileSettings.crit_armor_mod
local crit_impact_armor_mod = DamageProfileSettings.crit_impact_armor_mod
local damage_lerp_values = DamageProfileSettings.damage_lerp_values
local single_cleave = DamageProfileSettings.single_cleave
local double_cleave = DamageProfileSettings.double_cleave
local pistol_crit_mod = {
	attack = {
		[armor_types.unarmored] = 0,
		[armor_types.armored] = 0.5,
		[armor_types.resistant] = 0.75,
		[armor_types.player] = 0,
		[armor_types.berserker] = 0.5,
		[armor_types.super_armor] = 0.2,
		[armor_types.disgustingly_resilient] = 0.25,
		[armor_types.void_shield] = 0,
		[armor_types.prop_armor] = 0
	},
	impact = {
		[armor_types.unarmored] = 0.75,
		[armor_types.armored] = 0.75,
		[armor_types.resistant] = 0.75,
		[armor_types.player] = 0.75,
		[armor_types.berserker] = 0.75,
		[armor_types.super_armor] = 0.75,
		[armor_types.disgustingly_resilient] = 0.75,
		[armor_types.void_shield] = 0.75,
		[armor_types.prop_armor] = 0.75
	}
}
damage_templates.default_laspistol_killshot = {
	stagger_category = "killshot",
	cleave_distribution = single_cleave,
	ranges = {
		max = 25,
		min = 15
	},
	herding_template = HerdingTemplates.shot,
	wounds_template = WoundsTemplates.laspistol,
	armor_damage_modifier_ranged = {
		near = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_1,
				[armor_types.resistant] = damage_lerp_values.lerp_0_65,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_0_65,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_01,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_65,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_65,
				[armor_types.prop_armor] = damage_lerp_values.lerp_1
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
				[armor_types.prop_armor] = damage_lerp_values.lerp_0_5
			}
		},
		far = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_0_5,
				[armor_types.armored] = damage_lerp_values.lerp_0_5,
				[armor_types.resistant] = damage_lerp_values.lerp_0_4,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_0_4,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_01,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_5,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
				[armor_types.prop_armor] = damage_lerp_values.lerp_0_6
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
				[armor_types.prop_armor] = damage_lerp_values.lerp_0_3
			}
		}
	},
	critical_strike = {
		cleave_distribution = single_cleave,
		gibbing_power = gibbing_power.always,
		gibbing_type = gibbing_types.laser
	},
	power_distribution = {
		attack = {
			62.5,
			125
		},
		impact = {
			4,
			7
		}
	},
	damage_type = damage_types.laser,
	gibbing_power = gibbing_power.always,
	gibbing_type = gibbing_types.laser,
	suppression_value = {
		1,
		3
	},
	on_kill_area_suppression = {
		suppression_value = {
			2,
			4
		},
		distance = {
			3,
			5
		}
	},
	crit_mod = pistol_crit_mod,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default,
			finesse_boost = {
				[armor_types.unarmored] = 0.75,
				[armor_types.armored] = 0.75
			},
			boost_curve_multiplier_finesse = {
				1.8,
				2.35
			}
		}
	},
	ragdoll_push_force = {
		20,
		30
	}
}
damage_templates.default_laspistol_bfg = {
	stagger_category = "killshot",
	cleave_distribution = single_cleave,
	ranges = {
		max = 35,
		min = 20
	},
	herding_template = HerdingTemplates.shot,
	wounds_template = WoundsTemplates.laspistol,
	armor_damage_modifier_ranged = {
		near = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_1,
				[armor_types.resistant] = damage_lerp_values.lerp_0_65,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_0_65,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_05,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_65,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_65,
				[armor_types.prop_armor] = damage_lerp_values.lerp_1
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
				[armor_types.prop_armor] = damage_lerp_values.lerp_0_5
			}
		},
		far = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_0_5,
				[armor_types.armored] = damage_lerp_values.lerp_0_5,
				[armor_types.resistant] = damage_lerp_values.lerp_0_4,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_0_4,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_01,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_5,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
				[armor_types.prop_armor] = damage_lerp_values.lerp_0_6
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
				[armor_types.prop_armor] = damage_lerp_values.lerp_0_3
			}
		}
	},
	critical_strike = {
		cleave_distribution = single_cleave,
		gibbing_power = gibbing_power.always,
		gibbing_type = gibbing_types.laser
	},
	power_distribution = {
		attack = {
			90,
			185
		},
		impact = {
			5,
			14
		}
	},
	damage_type = damage_types.laser,
	gibbing_power = gibbing_power.always,
	gibbing_type = gibbing_types.laser,
	suppression_value = {
		1,
		3
	},
	on_kill_area_suppression = {
		suppression_value = {
			2,
			4
		},
		distance = {
			3,
			5
		}
	},
	crit_mod = pistol_crit_mod,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default,
			finesse_boost = {
				[armor_types.unarmored] = 0.75,
				[armor_types.armored] = 0.75
			},
			boost_curve_multiplier_finesse = {
				1.8,
				2.35
			}
		}
	},
	ragdoll_push_force = {
		20,
		30
	}
}

return {
	base_templates = damage_templates,
	overrides = overrides
}
