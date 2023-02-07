local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local DamageProfileSettings = require("scripts/settings/damage/damage_profile_settings")
local GibbingSettings = require("scripts/settings/gibbing/gibbing_settings")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local ArmorSettings = require("scripts/settings/damage/armor_settings")
local WoundsTemplates = require("scripts/settings/damage/wounds_templates")
local GibbingPower = GibbingSettings.gibbing_power
local GibbingTypes = GibbingSettings.gibbing_types
local damage_types = DamageSettings.damage_types
local damage_templates = {}
local overrides = {}

table.make_unique(damage_templates)
table.make_unique(overrides)

local armor_types = ArmorSettings.types
local damage_lerp_values = DamageProfileSettings.damage_lerp_values
local default_armor_mod = DamageProfileSettings.default_armor_mod
local flat_one_armor_mod = DamageProfileSettings.flat_one_armor_mod
local crit_armor_mod = DamageProfileSettings.crit_armor_mod
local crit_impact_armor_mod = DamageProfileSettings.crit_impact_armor_mod
damage_templates.psyker_smite_kill = {
	ragdoll_push_force = 0,
	ignore_stagger_reduction = true,
	ignore_shield = true,
	ragdoll_only = true,
	stagger_category = "uppercut",
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_1,
			[armor_types.resistant] = damage_lerp_values.lerp_1,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_1,
			[armor_types.super_armor] = damage_lerp_values.lerp_0_75,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
			[armor_types.void_shield] = damage_lerp_values.lerp_1,
			[armor_types.prop_armor] = damage_lerp_values.lerp_1
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
			[armor_types.prop_armor] = damage_lerp_values.lerp_1
		}
	},
	cleave_distribution = {
		attack = 100,
		impact = 100
	},
	power_distribution = {
		attack = 1100,
		impact = 55
	},
	gibbing_power = GibbingPower.heavy,
	gibbing_type = GibbingTypes.warp,
	damage_type = damage_types.smite,
	targets = {
		default_target = {
			boost_curve_multiplier_finesse = 0
		}
	}
}
damage_templates.psyker_smite_stagger = {
	stagger_category = "flamer",
	ignore_shield = true,
	ignore_stagger_reduction = false,
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = 1,
			[armor_types.armored] = 1,
			[armor_types.resistant] = 1,
			[armor_types.player] = 1,
			[armor_types.berserker] = 1,
			[armor_types.super_armor] = 1,
			[armor_types.disgustingly_resilient] = 1,
			[armor_types.void_shield] = 1,
			[armor_types.prop_armor] = 1
		},
		impact = {
			[armor_types.unarmored] = 1,
			[armor_types.armored] = 1,
			[armor_types.resistant] = 1,
			[armor_types.player] = 1,
			[armor_types.berserker] = 1,
			[armor_types.super_armor] = 1,
			[armor_types.disgustingly_resilient] = 1,
			[armor_types.void_shield] = 1,
			[armor_types.prop_armor] = 1
		}
	},
	power_distribution = {
		attack = 0,
		impact = 8
	},
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.psyker_smite_light = {
	stagger_category = "ranged",
	armor_damage_modifier = {
		attack = flat_one_armor_mod,
		impact = flat_one_armor_mod
	},
	cleave_distribution = {
		attack = 0.25,
		impact = 0.25
	},
	power_distribution = {
		attack = 100,
		impact = 12
	},
	damage_type = damage_types.smite,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.psyker_smite_heavy = {
	ragdoll_push_force = 0,
	stagger_category = "ranged",
	armor_damage_modifier = {
		attack = flat_one_armor_mod,
		impact = flat_one_armor_mod
	},
	cleave_distribution = {
		attack = 100,
		impact = 100
	},
	power_distribution = {
		attack = 120,
		impact = 8
	},
	wounds_template = WoundsTemplates.psyker_ball,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.psyker_biomancer_soul = {
	ragdoll_push_force = 0,
	ragdoll_only = true,
	stagger_category = "ranged",
	armor_damage_modifier = {
		attack = flat_one_armor_mod,
		impact = flat_one_armor_mod
	},
	cleave_distribution = {
		attack = 0.25,
		impact = 0.25
	},
	power_distribution = {
		attack = 100,
		impact = 12
	},
	damage_type = damage_types.biomancer_soul,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.psyker_gunslinger_smite = {
	stagger_category = "killshot",
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_1,
			[armor_types.resistant] = damage_lerp_values.lerp_0_5,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_1_5,
			[armor_types.super_armor] = damage_lerp_values.no_damage,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
			[armor_types.void_shield] = damage_lerp_values.lerp_1,
			[armor_types.prop_armor] = damage_lerp_values.lerp_1
		},
		impact = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_0_5,
			[armor_types.resistant] = damage_lerp_values.lerp_1,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_1,
			[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
			[armor_types.void_shield] = damage_lerp_values.lerp_1,
			[armor_types.prop_armor] = damage_lerp_values.lerp_1
		}
	},
	cleave_distribution = {
		attack = 1.25,
		impact = 1.25
	},
	power_distribution = {
		attack = 100,
		impact = 5
	},
	damage_type = damage_types.throwing_knife,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		},
		boost_curve_multiplier_finesse = damage_lerp_values.lerp_1
	}
}

return {
	base_templates = damage_templates,
	overrides = overrides
}
