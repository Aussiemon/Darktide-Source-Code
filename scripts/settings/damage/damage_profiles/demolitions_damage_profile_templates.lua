local ArmorSettings = require("scripts/settings/damage/armor_settings")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local GibbingSettings = require("scripts/settings/gibbing/gibbing_settings")
local DamageProfileSettings = require("scripts/settings/damage/damage_profile_settings")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local GibbingPower = GibbingSettings.gibbing_power
local GibbingTypes = GibbingSettings.gibbing_types
local damage_types = DamageSettings.damage_types
local armor_types = ArmorSettings.types
local damage_lerp_values = DamageProfileSettings.damage_lerp_values
local damage_templates = {}
local overrides = {}

table.make_unique(damage_templates)
table.make_unique(overrides)

damage_templates.default_grenade = {
	gibbing_power = 0,
	stagger_category = "explosion",
	suppression_value = 10,
	ragdoll_push_force = 850,
	ignore_stagger_reduction = true,
	cleave_distribution = {
		attack = 0.15,
		impact = 0.15
	},
	armor_damage_modifier_ranged = {
		near = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_0_25,
				[armor_types.resistant] = damage_lerp_values.lerp_0_75,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_0_5,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_1,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
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
		far = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_0_1,
				[armor_types.armored] = damage_lerp_values.lerp_0_1,
				[armor_types.resistant] = damage_lerp_values.lerp_0_1,
				[armor_types.player] = damage_lerp_values.lerp_0_1,
				[armor_types.berserker] = damage_lerp_values.lerp_0_1,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_1,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_1,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_1,
				[armor_types.prop_armor] = damage_lerp_values.lerp_0_1
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_0_2,
				[armor_types.armored] = damage_lerp_values.lerp_0_2,
				[armor_types.resistant] = damage_lerp_values.lerp_1,
				[armor_types.player] = damage_lerp_values.lerp_0_2,
				[armor_types.berserker] = damage_lerp_values.lerp_0_2,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_2,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_2,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_2,
				[armor_types.prop_armor] = damage_lerp_values.lerp_0_2
			}
		}
	},
	power_distribution_ranged = {
		attack = {
			far = 100,
			near = 200
		},
		impact = {
			far = 2,
			near = 25
		}
	},
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	},
	gibbing_type = GibbingTypes.explosion
}
damage_templates.close_grenade = {
	suppression_value = 10,
	damage_type = "grenade",
	ragdoll_push_force = 850,
	ignore_stagger_reduction = true,
	stagger_category = "explosion",
	cleave_distribution = {
		attack = 0.15,
		impact = 0.15
	},
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = 1,
			[armor_types.armored] = 0.5,
			[armor_types.resistant] = 0.75,
			[armor_types.player] = 1,
			[armor_types.berserker] = 1,
			[armor_types.super_armor] = 0,
			[armor_types.disgustingly_resilient] = 0.75,
			[armor_types.void_shield] = 0.75,
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
		attack = 500,
		impact = 100
	},
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	},
	gibbing_type = GibbingTypes.explosion,
	gibbing_power = GibbingPower.heavy
}
damage_templates.frag_grenade = {
	gibbing_power = 0,
	stagger_category = "explosion",
	suppression_value = 10,
	damage_type = "frag",
	ragdoll_push_force = 600,
	ignore_stagger_reduction = true,
	cleave_distribution = {
		attack = 0.15,
		impact = 0.15
	},
	armor_damage_modifier_ranged = {
		near = {
			attack = {
				[armor_types.unarmored] = 1,
				[armor_types.armored] = 0.5,
				[armor_types.resistant] = 0.75,
				[armor_types.player] = 1,
				[armor_types.berserker] = 0.5,
				[armor_types.super_armor] = 0.2,
				[armor_types.disgustingly_resilient] = 1,
				[armor_types.void_shield] = 0.75,
				[armor_types.prop_armor] = 1
			},
			impact = {
				[armor_types.unarmored] = 1,
				[armor_types.armored] = 1,
				[armor_types.resistant] = 3,
				[armor_types.player] = 1,
				[armor_types.berserker] = 2,
				[armor_types.super_armor] = 2,
				[armor_types.disgustingly_resilient] = 1,
				[armor_types.void_shield] = 1,
				[armor_types.prop_armor] = 1
			}
		},
		far = {
			attack = {
				[armor_types.unarmored] = 0,
				[armor_types.armored] = 0,
				[armor_types.resistant] = 0,
				[armor_types.player] = 0,
				[armor_types.berserker] = 0,
				[armor_types.super_armor] = 0,
				[armor_types.disgustingly_resilient] = 0,
				[armor_types.void_shield] = 0,
				[armor_types.prop_armor] = 0
			},
			impact = {
				[armor_types.unarmored] = 0.2,
				[armor_types.armored] = 0.2,
				[armor_types.resistant] = 1,
				[armor_types.player] = 0.2,
				[armor_types.berserker] = 0.2,
				[armor_types.super_armor] = 0.2,
				[armor_types.disgustingly_resilient] = 0.2,
				[armor_types.void_shield] = 0.2,
				[armor_types.prop_armor] = 0.2
			}
		}
	},
	power_distribution_ranged = {
		attack = {
			far = 100,
			near = 200
		},
		impact = {
			far = 2,
			near = 15
		}
	},
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	},
	gibbing_type = GibbingTypes.explosion
}
damage_templates.close_frag_grenade = {
	suppression_value = 10,
	damage_type = "frag",
	ragdoll_push_force = 850,
	ignore_stagger_reduction = true,
	stagger_category = "explosion",
	cleave_distribution = {
		attack = 0.15,
		impact = 0.15
	},
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = 1,
			[armor_types.armored] = 0.5,
			[armor_types.resistant] = 0.75,
			[armor_types.player] = 1,
			[armor_types.berserker] = 1,
			[armor_types.super_armor] = 0.2,
			[armor_types.disgustingly_resilient] = 0.75,
			[armor_types.void_shield] = 0.75,
			[armor_types.prop_armor] = 1
		},
		impact = {
			[armor_types.unarmored] = 2,
			[armor_types.armored] = 2,
			[armor_types.resistant] = 10,
			[armor_types.player] = 2,
			[armor_types.berserker] = 2,
			[armor_types.super_armor] = 5,
			[armor_types.disgustingly_resilient] = 2,
			[armor_types.void_shield] = 2,
			[armor_types.prop_armor] = 2
		}
	},
	power_distribution = {
		attack = 500,
		impact = 100
	},
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	},
	gibbing_type = GibbingTypes.explosion,
	gibbing_power = GibbingPower.heavy
}
damage_templates.krak_grenade = {
	stagger_category = "explosion",
	suppression_value = 10,
	damage_type = "krak",
	ragdoll_push_force = 500,
	ignore_stagger_reduction = true,
	cleave_distribution = {
		attack = 0.15,
		impact = 0.15
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
				[armor_types.disgustingly_resilient] = 0.75,
				[armor_types.void_shield] = 0.75,
				[armor_types.prop_armor] = 1
			},
			impact = {
				[armor_types.unarmored] = 2,
				[armor_types.armored] = 2,
				[armor_types.resistant] = 5,
				[armor_types.player] = 2,
				[armor_types.berserker] = 2,
				[armor_types.super_armor] = 5,
				[armor_types.disgustingly_resilient] = 2,
				[armor_types.void_shield] = 2,
				[armor_types.prop_armor] = 2
			}
		},
		far = {
			attack = {
				[armor_types.unarmored] = 0,
				[armor_types.armored] = 0,
				[armor_types.resistant] = 0,
				[armor_types.player] = 0,
				[armor_types.berserker] = 0,
				[armor_types.super_armor] = 0,
				[armor_types.disgustingly_resilient] = 0,
				[armor_types.void_shield] = 0,
				[armor_types.prop_armor] = 0
			},
			impact = {
				[armor_types.unarmored] = 0.2,
				[armor_types.armored] = 0.2,
				[armor_types.resistant] = 1,
				[armor_types.player] = 0.2,
				[armor_types.berserker] = 0.2,
				[armor_types.super_armor] = 0.2,
				[armor_types.disgustingly_resilient] = 0.2,
				[armor_types.void_shield] = 0.2,
				[armor_types.prop_armor] = 0.2
			}
		}
	},
	power_distribution_ranged = {
		attack = {
			far = 100,
			near = 500
		},
		impact = {
			far = 2,
			near = 30
		}
	},
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	},
	gibbing_type = GibbingTypes.explosion,
	gibbing_power = GibbingPower.medium
}
damage_templates.close_krak_grenade = {
	suppression_value = 10,
	ignore_shield = true,
	damage_type = "krak",
	ragdoll_push_force = 1250,
	ignore_stagger_reduction = true,
	stagger_category = "explosion",
	cleave_distribution = {
		attack = 0.15,
		impact = 0.15
	},
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = 1,
			[armor_types.armored] = 2,
			[armor_types.resistant] = 2,
			[armor_types.player] = 1,
			[armor_types.berserker] = 1,
			[armor_types.super_armor] = 2,
			[armor_types.disgustingly_resilient] = 0.75,
			[armor_types.void_shield] = 0.75,
			[armor_types.prop_armor] = 2
		},
		impact = {
			[armor_types.unarmored] = 2,
			[armor_types.armored] = 2,
			[armor_types.resistant] = 10,
			[armor_types.player] = 2,
			[armor_types.berserker] = 2,
			[armor_types.super_armor] = 5,
			[armor_types.disgustingly_resilient] = 2,
			[armor_types.void_shield] = 2,
			[armor_types.prop_armor] = 2
		}
	},
	power_distribution = {
		attack = 750,
		impact = 100
	},
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	},
	gibbing_type = GibbingTypes.explosion,
	gibbing_power = GibbingPower.heavy
}
damage_templates.plasma_demolition = {
	ragdoll_push_force = 1250,
	suppression_value = 0.5,
	ignore_stagger_reduction = true,
	stagger_category = "explosion",
	cleave_distribution = {
		attack = 0.1,
		impact = 0.1
	},
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = 1,
			[armor_types.armored] = 2,
			[armor_types.resistant] = 1,
			[armor_types.player] = 1,
			[armor_types.berserker] = 1,
			[armor_types.super_armor] = 1,
			[armor_types.disgustingly_resilient] = 1,
			[armor_types.void_shield] = 1,
			[armor_types.prop_armor] = 2
		},
		impact = {
			[armor_types.unarmored] = 2,
			[armor_types.armored] = 2,
			[armor_types.resistant] = 10,
			[armor_types.player] = 2,
			[armor_types.berserker] = 2,
			[armor_types.super_armor] = 5,
			[armor_types.disgustingly_resilient] = 2,
			[armor_types.void_shield] = 2,
			[armor_types.prop_armor] = 2
		}
	},
	power_distribution = {
		attack = 1,
		impact = 3
	},
	gibbing_type = GibbingTypes.plasma,
	gibbing_power = GibbingPower.heavy,
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
damage_templates.shock_grenade = {
	shield_override_stagger_strength = 0,
	suppression_value = 10,
	damage_type = "grenade",
	ragdoll_push_force = 250,
	ignore_stagger_reduction = true,
	stagger_category = "explosion",
	cleave_distribution = {
		attack = 0.15,
		impact = 0
	},
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = 0,
			[armor_types.armored] = 0,
			[armor_types.resistant] = 0,
			[armor_types.player] = 0,
			[armor_types.berserker] = 0,
			[armor_types.super_armor] = 0,
			[armor_types.disgustingly_resilient] = 0,
			[armor_types.void_shield] = 0,
			[armor_types.prop_armor] = 0
		},
		impact = {
			[armor_types.unarmored] = 0,
			[armor_types.armored] = 0,
			[armor_types.resistant] = 0,
			[armor_types.player] = 0,
			[armor_types.berserker] = 0,
			[armor_types.super_armor] = 0,
			[armor_types.disgustingly_resilient] = 0,
			[armor_types.void_shield] = 0,
			[armor_types.prop_armor] = 0
		}
	},
	power_distribution = {
		attack = 0,
		impact = 0
	},
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	},
	gibbing_type = GibbingTypes.explosion,
	gibbing_power = GibbingPower.heavy
}
damage_templates.shock_grenade_stun_interval = {
	stagger_category = "sticky",
	ignore_shield = true,
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = damage_lerp_values.lerp_0_5,
			[armor_types.armored] = damage_lerp_values.lerp_1,
			[armor_types.resistant] = damage_lerp_values.lerp_1,
			[armor_types.player] = damage_lerp_values.lerp_0_75,
			[armor_types.berserker] = damage_lerp_values.lerp_1,
			[armor_types.super_armor] = damage_lerp_values.lerp_1,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_5,
			[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
			[armor_types.prop_armor] = damage_lerp_values.no_damage
		},
		impact = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_2,
			[armor_types.resistant] = damage_lerp_values.lerp_1,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_1,
			[armor_types.super_armor] = damage_lerp_values.lerp_1_5,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
			[armor_types.void_shield] = damage_lerp_values.lerp_1,
			[armor_types.prop_armor] = damage_lerp_values.lerp_1
		}
	},
	cleave_distribution = {
		attack = 5,
		impact = 20
	},
	power_distribution = {
		attack = 8,
		impact = 100
	},
	damage_type = damage_types.electrocution,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.force_staff_demolition_close = table.clone(damage_templates.close_grenade)
damage_templates.force_staff_demolition_close.power_distribution.attack = 0.1
damage_templates.force_staff_demolition_default = table.clone(damage_templates.default_grenade)
damage_templates.force_staff_demolition_default.power_distribution_ranged.attack.near = 0.25
damage_templates.force_staff_demolition_default.power_distribution_ranged.attack.far = 0.05
local ogryn_thumper_p1_m2_default = table.clone(damage_templates.default_grenade)
ogryn_thumper_p1_m2_default.armor_damage_modifier_ranged.near.attack[armor_types.armored] = {
	0.3,
	0.7
}
ogryn_thumper_p1_m2_default.armor_damage_modifier_ranged.far.attack[armor_types.armored] = {
	0,
	0.1
}
ogryn_thumper_p1_m2_default.armor_damage_modifier_ranged.near.impact[armor_types.armored] = {
	2,
	4
}
ogryn_thumper_p1_m2_default.armor_damage_modifier_ranged.far.impact[armor_types.armored] = {
	0.2,
	0.4
}
ogryn_thumper_p1_m2_default.opt_in_stagger_duration_multiplier = true
damage_templates.ogryn_thumper_p1_m2_default = ogryn_thumper_p1_m2_default
local ogryn_thumper_p1_m2_close = table.clone(damage_templates.close_grenade)
ogryn_thumper_p1_m2_close.armor_damage_modifier.attack[armor_types.armored] = {
	0.3,
	0.7
}
ogryn_thumper_p1_m2_close.armor_damage_modifier.impact[armor_types.armored] = {
	2,
	4
}
ogryn_thumper_p1_m2_close.opt_in_stagger_duration_multiplier = true
ogryn_thumper_p1_m2_close.power_distribution.attack = 250
damage_templates.ogryn_thumper_p1_m2_close = ogryn_thumper_p1_m2_close
local ogryn_thumper_p1_m2_default_instant = table.clone(damage_templates.default_grenade)
ogryn_thumper_p1_m2_default_instant.armor_damage_modifier_ranged.near.attack[armor_types.armored] = {
	0.25,
	0.5
}
ogryn_thumper_p1_m2_default_instant.armor_damage_modifier_ranged.near.attack[armor_types.super_armor] = {
	0,
	0.2
}
ogryn_thumper_p1_m2_default_instant.armor_damage_modifier_ranged.far.attack[armor_types.armored] = {
	0,
	0.1
}
ogryn_thumper_p1_m2_default_instant.armor_damage_modifier_ranged.far.attack[armor_types.super_armor] = {
	0,
	0.1
}
ogryn_thumper_p1_m2_default_instant.armor_damage_modifier_ranged.near.impact[armor_types.armored] = {
	0.5,
	1.5
}
ogryn_thumper_p1_m2_default_instant.armor_damage_modifier_ranged.near.impact[armor_types.super_armor] = {
	0.5,
	1.5
}
ogryn_thumper_p1_m2_default_instant.armor_damage_modifier_ranged.far.impact[armor_types.armored] = {
	0.2,
	0.4
}
ogryn_thumper_p1_m2_default_instant.armor_damage_modifier_ranged.far.impact[armor_types.super_armor] = {
	0.2,
	0.4
}
ogryn_thumper_p1_m2_default_instant.power_distribution_ranged.attack.far = {
	10,
	20
}
ogryn_thumper_p1_m2_default_instant.power_distribution_ranged.attack.near = {
	100,
	200
}
ogryn_thumper_p1_m2_default_instant.power_distribution_ranged.impact.far = {
	25,
	75
}
ogryn_thumper_p1_m2_default_instant.power_distribution_ranged.impact.near = {
	0,
	10
}
damage_templates.ogryn_thumper_p1_m2_default_instant = ogryn_thumper_p1_m2_default_instant
local ogryn_thumper_p1_m2_close_instant = table.clone(damage_templates.close_grenade)
ogryn_thumper_p1_m2_close_instant.armor_damage_modifier.attack[armor_types.armored] = {
	0.25,
	0.75
}
ogryn_thumper_p1_m2_close_instant.armor_damage_modifier.attack[armor_types.super_armor] = {
	0,
	0.2
}
ogryn_thumper_p1_m2_close_instant.armor_damage_modifier.impact[armor_types.armored] = {
	0.5,
	1.5
}
ogryn_thumper_p1_m2_close_instant.armor_damage_modifier.impact[armor_types.super_armor] = {
	0.5,
	1.5
}
ogryn_thumper_p1_m2_close_instant.power_distribution.attack = {
	250,
	500
}
ogryn_thumper_p1_m2_close_instant.power_distribution.impact = {
	25,
	75
}
damage_templates.ogryn_thumper_p1_m2_close_instant = ogryn_thumper_p1_m2_close_instant
local ogryn_grenade = table.clone(damage_templates.default_grenade)
ogryn_grenade.armor_damage_modifier_ranged.near.attack[armor_types.armored] = {
	0.7,
	1.3
}
ogryn_grenade.armor_damage_modifier_ranged.far.attack[armor_types.armored] = {
	0,
	0.1
}
ogryn_grenade.armor_damage_modifier_ranged.near.impact[armor_types.armored] = {
	2,
	4
}
ogryn_grenade.armor_damage_modifier_ranged.far.impact[armor_types.armored] = {
	0.2,
	0.4
}
ogryn_grenade.armor_damage_modifier_ranged.near.attack[armor_types.super_armor] = {
	0.2,
	0.5
}
ogryn_grenade.armor_damage_modifier_ranged.far.attack[armor_types.super_armor] = {
	0,
	0.1
}
ogryn_grenade.armor_damage_modifier_ranged.near.impact[armor_types.super_armor] = {
	1,
	1
}
ogryn_grenade.armor_damage_modifier_ranged.far.impact[armor_types.super_armor] = {
	0.2,
	0.4
}
ogryn_grenade.power_distribution_ranged.attack.near = 300
ogryn_grenade.power_distribution_ranged.attack.far = 50
damage_templates.ogryn_grenade = ogryn_grenade
local close_ogryn_grenade = table.clone(damage_templates.close_grenade)
close_ogryn_grenade.armor_damage_modifier.attack[armor_types.armored] = {
	0.7,
	1.3
}
close_ogryn_grenade.armor_damage_modifier.impact[armor_types.armored] = {
	1,
	1
}
close_ogryn_grenade.armor_damage_modifier.attack[armor_types.super_armor] = {
	0.2,
	0.5
}
close_ogryn_grenade.armor_damage_modifier.impact[armor_types.super_armor] = {
	1,
	1
}
close_ogryn_grenade.power_distribution.attack = 800
damage_templates.close_ogryn_grenade = close_ogryn_grenade

return {
	base_templates = damage_templates,
	overrides = overrides
}
