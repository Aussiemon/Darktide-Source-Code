local ArmorSettings = require("scripts/settings/damage/armor_settings")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local DamageProfileSettings = require("scripts/settings/damage/damage_profile_settings")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local GibbingSettings = require("scripts/settings/gibbing/gibbing_settings")
local HerdingTemplates = require("scripts/settings/damage/herding_templates")
local WoundsTemplates = require("scripts/settings/damage/wounds_templates")
local GibbingPower = GibbingSettings.gibbing_power
local GibbingTypes = GibbingSettings.gibbing_types
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
damage_templates.default_autopistol_assault = {
	stagger_category = "killshot",
	cleave_distribution = single_cleave,
	ranges = {
		max = 35,
		min = 15
	},
	armor_damage_modifier_ranged = {
		near = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_0_6,
				[armor_types.resistant] = damage_lerp_values.lerp_0_5,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_0_9,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_01,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_6,
				[armor_types.prop_armor] = damage_lerp_values.lerp_0_6
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_0_8,
				[armor_types.armored] = damage_lerp_values.lerp_1,
				[armor_types.resistant] = damage_lerp_values.lerp_0_5,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_0_5,
				[armor_types.super_armor] = damage_lerp_values.no_damage,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_8,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_4,
				[armor_types.prop_armor] = damage_lerp_values.lerp_1_5
			}
		},
		far = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_0_6,
				[armor_types.armored] = damage_lerp_values.lerp_0_4,
				[armor_types.resistant] = damage_lerp_values.lerp_0_4,
				[armor_types.player] = damage_lerp_values.lerp_0_5,
				[armor_types.berserker] = damage_lerp_values.lerp_0_6,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_01,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_6,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_4,
				[armor_types.prop_armor] = damage_lerp_values.lerp_0_3
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_0_5,
				[armor_types.armored] = damage_lerp_values.lerp_0_9,
				[armor_types.resistant] = damage_lerp_values.lerp_0_3,
				[armor_types.player] = damage_lerp_values.lerp_0_3,
				[armor_types.berserker] = damage_lerp_values.lerp_0_01,
				[armor_types.super_armor] = damage_lerp_values.no_damage,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_4,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_4,
				[armor_types.prop_armor] = damage_lerp_values.lerp_1_25
			}
		}
	},
	critical_strike = {
		gibbing_power = GibbingPower.light,
		gibbing_type = GibbingTypes.ballistic
	},
	power_distribution = {
		attack = {
			30,
			70
		},
		impact = {
			1,
			4
		}
	},
	accumulative_stagger_strength_multiplier = {
		0.5,
		2
	},
	herding_template = HerdingTemplates.shot,
	wounds_template = WoundsTemplates.autopistol,
	damage_type = damage_types.auto_bullet,
	gibbing_power = GibbingPower.always,
	gibbing_type = GibbingTypes.ballistic,
	suppression_attack_delay = {
		0.05,
		0.4
	},
	suppression_value = {
		0.05,
		1
	},
	on_kill_area_suppression = {
		suppression_value = {
			2,
			6
		},
		distance = {
			3,
			6
		}
	},
	ragdoll_push_force = {
		200,
		250
	},
	gib_push_force = GibbingSettings.gib_push_force.ranged_light,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		},
		boost_curve_multiplier_finesse = {
			0.3,
			0.9
		}
	}
}
damage_templates.default_autopistol_snp = {
	stagger_category = "killshot",
	cleave_distribution = single_cleave,
	ranges = {
		max = 35,
		min = 15
	},
	armor_damage_modifier_ranged = {
		near = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_0_6,
				[armor_types.resistant] = damage_lerp_values.lerp_1,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_0_9,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_01,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_6,
				[armor_types.prop_armor] = damage_lerp_values.lerp_0_6
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_0_8,
				[armor_types.armored] = damage_lerp_values.lerp_1,
				[armor_types.resistant] = damage_lerp_values.lerp_0_5,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_0_5,
				[armor_types.super_armor] = damage_lerp_values.no_damage,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_8,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_4,
				[armor_types.prop_armor] = damage_lerp_values.lerp_1_5
			}
		},
		far = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_0_6,
				[armor_types.armored] = damage_lerp_values.lerp_0_4,
				[armor_types.resistant] = damage_lerp_values.lerp_0_6,
				[armor_types.player] = damage_lerp_values.lerp_0_5,
				[armor_types.berserker] = damage_lerp_values.lerp_0_6,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_01,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_6,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_4,
				[armor_types.prop_armor] = damage_lerp_values.lerp_0_3
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_0_5,
				[armor_types.armored] = damage_lerp_values.lerp_0_9,
				[armor_types.resistant] = damage_lerp_values.lerp_0_3,
				[armor_types.player] = damage_lerp_values.lerp_0_3,
				[armor_types.berserker] = damage_lerp_values.lerp_0_01,
				[armor_types.super_armor] = damage_lerp_values.no_damage,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_4,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_4,
				[armor_types.prop_armor] = damage_lerp_values.lerp_1_25
			}
		}
	},
	critical_strike = {
		gibbing_power = GibbingPower.light,
		gibbing_type = GibbingTypes.ballistic
	},
	power_distribution = {
		attack = {
			30,
			70
		},
		impact = {
			1,
			4
		}
	},
	accumulative_stagger_strength_multiplier = {
		0.5,
		2
	},
	herding_template = HerdingTemplates.shot,
	wounds_template = WoundsTemplates.autopistol,
	damage_type = damage_types.auto_bullet,
	gibbing_power = GibbingPower.always,
	gibbing_type = GibbingTypes.ballistic,
	suppression_attack_delay = {
		0.05,
		0.4
	},
	suppression_value = {
		0.05,
		2
	},
	on_kill_area_suppression = {
		suppression_value = {
			2,
			6
		},
		distance = {
			3,
			6
		}
	},
	ragdoll_push_force = {
		200,
		250
	},
	gib_push_force = GibbingSettings.gib_push_force.ranged_light,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		},
		boost_curve_multiplier_finesse = {
			0.3,
			0.9
		}
	}
}

return {
	base_templates = damage_templates,
	overrides = overrides
}
