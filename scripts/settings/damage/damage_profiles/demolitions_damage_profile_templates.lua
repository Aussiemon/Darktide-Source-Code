-- chunkname: @scripts/settings/damage/damage_profiles/demolitions_damage_profile_templates.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local DamageProfileSettings = require("scripts/settings/damage/damage_profile_settings")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local GibbingSettings = require("scripts/settings/gibbing/gibbing_settings")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local armor_types = ArmorSettings.types
local damage_lerp_values = DamageProfileSettings.damage_lerp_values
local damage_types = DamageSettings.damage_types
local gibbing_power = GibbingSettings.gibbing_power
local gibbing_types = GibbingSettings.gibbing_types
local damage_templates = {}
local overrides = {}

table.make_unique(damage_templates)
table.make_unique(overrides)

damage_templates.default_grenade = {
	gibbing_power = 0,
	ignore_stagger_reduction = true,
	ragdoll_push_force = 850,
	stagger_category = "explosion",
	suppression_value = 10,
	cleave_distribution = {
		attack = 0.15,
		impact = 0.15,
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
			},
		},
	},
	power_distribution_ranged = {
		attack = {
			far = 100,
			near = 200,
		},
		impact = {
			far = 2,
			near = 25,
		},
	},
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
	gibbing_type = gibbing_types.explosion,
}
damage_templates.close_grenade = {
	damage_type = "grenade",
	ignore_stagger_reduction = true,
	ragdoll_push_force = 850,
	stagger_category = "explosion",
	suppression_value = 10,
	cleave_distribution = {
		attack = 0.15,
		impact = 0.15,
	},
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = 1,
			[armor_types.armored] = 0.5,
			[armor_types.resistant] = 1.25,
			[armor_types.player] = 1,
			[armor_types.berserker] = 1,
			[armor_types.super_armor] = 0,
			[armor_types.disgustingly_resilient] = 0.75,
			[armor_types.void_shield] = 0.75,
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
		},
	},
	power_distribution = {
		attack = 500,
		impact = 100,
	},
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
	gibbing_type = gibbing_types.explosion,
	gibbing_power = gibbing_power.heavy,
}
damage_templates.frag_grenade = {
	gibbing_power = 0,
	ignore_stagger_reduction = true,
	ragdoll_push_force = 600,
	stagger_category = "explosion",
	suppression_value = 10,
	cleave_distribution = {
		attack = 0.15,
		impact = 0.15,
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
			},
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
			},
		},
	},
	power_distribution_ranged = {
		attack = {
			far = 100,
			near = 200,
		},
		impact = {
			far = 2,
			near = 15,
		},
	},
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
	gibbing_type = gibbing_types.explosion,
	damage_type = damage_types.grenade_frag,
	stat_buffs = {
		"frag_damage",
	},
}
damage_templates.close_frag_grenade = {
	ignore_stagger_reduction = true,
	ragdoll_push_force = 850,
	stagger_category = "explosion",
	suppression_value = 10,
	cleave_distribution = {
		attack = 0.15,
		impact = 0.15,
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
		},
	},
	power_distribution = {
		attack = 500,
		impact = 100,
	},
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
	gibbing_type = gibbing_types.explosion,
	gibbing_power = gibbing_power.heavy,
	damage_type = damage_types.grenade_frag,
	stat_buffs = {
		"frag_damage",
	},
}
damage_templates.krak_grenade = {
	ignore_stagger_reduction = true,
	ragdoll_push_force = 500,
	stagger_category = "explosion",
	suppression_value = 10,
	cleave_distribution = {
		attack = 0.15,
		impact = 0.15,
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
			},
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
			},
		},
	},
	power_distribution_ranged = {
		attack = {
			far = 100,
			near = 500,
		},
		impact = {
			far = 2,
			near = 30,
		},
	},
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
	gibbing_type = gibbing_types.explosion,
	gibbing_power = gibbing_power.medium,
	gib_push_force = GibbingSettings.gib_push_force.explosive,
	damage_type = damage_types.grenade_krak,
	stat_buffs = {
		"krak_damage",
	},
}
damage_templates.close_krak_grenade = {
	ignore_shield = true,
	ignore_stagger_reduction = true,
	ragdoll_push_force = 1250,
	stagger_category = "explosion",
	suppression_value = 10,
	cleave_distribution = {
		attack = 0.15,
		impact = 0.15,
	},
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = 1,
			[armor_types.armored] = 2,
			[armor_types.resistant] = 2,
			[armor_types.player] = 1,
			[armor_types.berserker] = 1.3,
			[armor_types.super_armor] = 2,
			[armor_types.disgustingly_resilient] = 0.75,
			[armor_types.void_shield] = 1.1,
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
		},
	},
	power_distribution = {
		attack = 2400,
		impact = 100,
	},
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
	gibbing_type = gibbing_types.explosion,
	gibbing_power = gibbing_power.infinite,
	gib_push_force = GibbingSettings.gib_push_force.explosive_heavy,
	damage_type = damage_types.grenade_krak,
	stat_buffs = {
		"krak_damage",
	},
}
damage_templates.ogryn_box_cluster_frag_grenade = {
	gibbing_power = 0,
	ignore_stagger_reduction = true,
	ragdoll_push_force = 600,
	stagger_category = "explosion",
	suppression_value = 10,
	cleave_distribution = {
		attack = 0.15,
		impact = 0.15,
	},
	armor_damage_modifier_ranged = {
		near = {
			attack = {
				[armor_types.unarmored] = 0.7,
				[armor_types.armored] = 0.5,
				[armor_types.resistant] = 1.1,
				[armor_types.player] = 1,
				[armor_types.berserker] = 1.5,
				[armor_types.super_armor] = 0.7,
				[armor_types.disgustingly_resilient] = 0.6,
				[armor_types.void_shield] = 0.75,
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
			},
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
			},
		},
	},
	power_distribution_ranged = {
		attack = {
			far = 50,
			near = 150,
		},
		impact = {
			far = 5,
			near = 15,
		},
	},
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
	gibbing_type = gibbing_types.explosion,
	damage_type = damage_types.grenade_frag,
	stat_buffs = {
		"frag_damage",
	},
}
damage_templates.ogryn_box_cluster_close_frag_grenade = {
	ignore_stagger_reduction = true,
	ragdoll_push_force = 850,
	stagger_category = "explosion",
	suppression_value = 10,
	cleave_distribution = {
		attack = 0.15,
		impact = 0.15,
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
		},
	},
	power_distribution = {
		attack = 10,
		impact = 100,
	},
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
	gibbing_type = gibbing_types.explosion,
	gibbing_power = gibbing_power.heavy,
	damage_type = damage_types.grenade_frag,
	stat_buffs = {
		"frag_damage",
	},
}
damage_templates.plasma_demolition = {
	ignore_stagger_reduction = true,
	ragdoll_push_force = 1250,
	stagger_category = "explosion",
	suppression_value = 0.5,
	cleave_distribution = {
		attack = 0.1,
		impact = 0.1,
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
		},
	},
	power_distribution = {
		attack = 1,
		impact = 3,
	},
	gibbing_type = gibbing_types.plasma,
	gibbing_power = gibbing_power.heavy,
	targets = {
		default_target = {
			boost_curve_multiplier_finesse = 1.2,
			boost_curve = PowerLevelSettings.boost_curves.default,
			finesse_boost = {
				[armor_types.unarmored] = 0.75,
			},
		},
	},
}
damage_templates.smoke_grenade = {
	damage_type = "grenade",
	ignore_stagger_reduction = true,
	ragdoll_push_force = 250,
	shield_override_stagger_strength = 0,
	stagger_category = "explosion",
	suppression_value = 10,
	cleave_distribution = {
		attack = 0,
		impact = 0.15,
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
		},
		impact = {
			[armor_types.unarmored] = 0.1,
			[armor_types.armored] = 0.1,
			[armor_types.resistant] = 0.75,
			[armor_types.player] = 0.1,
			[armor_types.berserker] = 0.1,
			[armor_types.super_armor] = 0.1,
			[armor_types.disgustingly_resilient] = 0.1,
			[armor_types.void_shield] = 0.1,
		},
	},
	power_distribution = {
		attack = 0,
		impact = 100,
	},
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
	gibbing_type = gibbing_types.explosion,
	gibbing_power = gibbing_power.heavy,
}
damage_templates.shock_grenade = {
	damage_type = "grenade",
	ignore_stagger_reduction = true,
	ragdoll_push_force = 250,
	shield_override_stagger_strength = 0,
	stagger_category = "explosion",
	suppression_value = 10,
	cleave_distribution = {
		attack = 0.15,
		impact = 0,
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
		},
	},
	power_distribution = {
		attack = 0,
		impact = 0,
	},
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
	gibbing_type = gibbing_types.explosion,
	gibbing_power = gibbing_power.heavy,
}
damage_templates.shock_grenade_stun_interval = {
	ignore_shield = true,
	stagger_category = "sticky",
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
		},
	},
	cleave_distribution = {
		attack = 5,
		impact = 20,
	},
	power_distribution = {
		attack = 8,
		impact = 100,
	},
	damage_type = damage_types.electrocution,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
}
damage_templates.adamant_grenade = {
	gibbing_power = 0,
	ignore_stagger_reduction = true,
	ragdoll_push_force = 750,
	stagger_category = "explosion",
	suppression_value = 10,
	cleave_distribution = {
		attack = 0.15,
		impact = 0.15,
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
			},
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
			},
		},
	},
	power_distribution_ranged = {
		attack = {
			far = 50,
			near = 600,
		},
		impact = {
			far = 10,
			near = 15,
		},
	},
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
	gibbing_type = gibbing_types.explosion,
	damage_type = damage_types.grenade_frag,
	stat_buffs = {
		"frag_damage",
	},
}
damage_templates.close_adamant_grenade = {
	ignore_stagger_reduction = true,
	ragdoll_push_force = 850,
	stagger_category = "explosion",
	suppression_value = 10,
	cleave_distribution = {
		attack = 0.15,
		impact = 0.15,
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
		},
	},
	power_distribution = {
		attack = 1500,
		impact = 100,
	},
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
	gibbing_type = gibbing_types.explosion,
	gibbing_power = gibbing_power.heavy,
	damage_type = damage_types.grenade_frag,
	stat_buffs = {
		"frag_damage",
	},
}
damage_templates.whistle_explosion = {
	gibbing_power = 0,
	ignore_stagger_reduction = true,
	ragdoll_push_force = 250,
	stagger_category = "explosion",
	suppression_value = 5,
	cleave_distribution = {
		attack = 0.15,
		impact = 0.15,
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
			},
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
			},
		},
	},
	power_distribution_ranged = {
		attack = {
			far = 50,
			near = 200,
		},
		impact = {
			far = 10,
			near = 15,
		},
	},
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
	gibbing_type = gibbing_types.explosion,
	damage_type = damage_types.grenade_frag,
}
damage_templates.close_whistle_explosion = {
	ignore_stagger_reduction = true,
	ragdoll_push_force = 350,
	stagger_category = "explosion",
	suppression_value = 5,
	cleave_distribution = {
		attack = 0.15,
		impact = 0.15,
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
		},
	},
	power_distribution = {
		attack = 600,
		impact = 100,
	},
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
	gibbing_type = gibbing_types.explosion,
	gibbing_power = gibbing_power.heavy,
	damage_type = damage_types.grenade_frag,
}
damage_templates.shock_mine_self_destruct = {
	damage_type = "grenade",
	ignore_stagger_reduction = false,
	ragdoll_push_force = 250,
	shield_override_stagger_strength = 0,
	stagger_category = "explosion",
	suppression_value = 10,
	cleave_distribution = {
		attack = 0.1,
		impact = 0.1,
	},
	armor_damage_modifier_ranged = {
		near = {
			attack = {
				[armor_types.unarmored] = 0.2,
				[armor_types.armored] = 0.1,
				[armor_types.resistant] = 0.15,
				[armor_types.player] = 0.2,
				[armor_types.berserker] = 0.1,
				[armor_types.super_armor] = 0.04,
				[armor_types.disgustingly_resilient] = 0.2,
				[armor_types.void_shield] = 0.15,
			},
			impact = {
				[armor_types.unarmored] = 0.2,
				[armor_types.armored] = 0.2,
				[armor_types.resistant] = 0.6,
				[armor_types.player] = 0.2,
				[armor_types.berserker] = 0.4,
				[armor_types.super_armor] = 0.4,
				[armor_types.disgustingly_resilient] = 0.2,
				[armor_types.void_shield] = 0.2,
			},
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
			},
			impact = {
				[armor_types.unarmored] = 0.04,
				[armor_types.armored] = 0.04,
				[armor_types.resistant] = 0.2,
				[armor_types.player] = 0.04,
				[armor_types.berserker] = 0.04,
				[armor_types.super_armor] = 0.04,
				[armor_types.disgustingly_resilient] = 0.04,
				[armor_types.void_shield] = 0.04,
			},
		},
	},
	power_distribution = {
		attack = 50,
		impact = 100,
	},
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
	gibbing_type = gibbing_types.explosion,
	gibbing_power = gibbing_power.medium,
}
damage_templates.force_staff_demolition_close = table.clone(damage_templates.close_grenade)
damage_templates.force_staff_demolition_close.power_distribution.attack = 0.1
damage_templates.force_staff_demolition_default = table.clone(damage_templates.default_grenade)
damage_templates.force_staff_demolition_default.power_distribution_ranged.attack.near = 0.25
damage_templates.force_staff_demolition_default.power_distribution_ranged.attack.far = 0.05

local ogryn_thumper_p1_m2_default = table.clone(damage_templates.default_grenade)

ogryn_thumper_p1_m2_default.armor_damage_modifier_ranged.near.attack[armor_types.armored] = {
	0.3,
	0.7,
}
ogryn_thumper_p1_m2_default.armor_damage_modifier_ranged.far.attack[armor_types.armored] = {
	0,
	0.1,
}
ogryn_thumper_p1_m2_default.armor_damage_modifier_ranged.near.impact[armor_types.armored] = {
	2,
	4,
}
ogryn_thumper_p1_m2_default.armor_damage_modifier_ranged.far.impact[armor_types.armored] = {
	0.2,
	0.4,
}
ogryn_thumper_p1_m2_default.opt_in_stagger_duration_multiplier = true
ogryn_thumper_p1_m2_default.count_as_ranged_attack = true
damage_templates.ogryn_thumper_p1_m2_default = ogryn_thumper_p1_m2_default

local ogryn_thumper_p1_m2_close = table.clone(damage_templates.close_grenade)

ogryn_thumper_p1_m2_close.armor_damage_modifier.attack[armor_types.armored] = {
	0.3,
	0.7,
}
ogryn_thumper_p1_m2_close.armor_damage_modifier.impact[armor_types.armored] = {
	2,
	4,
}
ogryn_thumper_p1_m2_close.opt_in_stagger_duration_multiplier = true
ogryn_thumper_p1_m2_close.power_distribution.attack = 250
ogryn_thumper_p1_m2_close.count_as_ranged_attack = true
damage_templates.ogryn_thumper_p1_m2_close = ogryn_thumper_p1_m2_close

local ogryn_thumper_p1_m2_default_instant = table.clone(damage_templates.default_grenade)

ogryn_thumper_p1_m2_default_instant.armor_damage_modifier_ranged.near.attack[armor_types.armored] = {
	0.25,
	0.5,
}
ogryn_thumper_p1_m2_default_instant.armor_damage_modifier_ranged.near.attack[armor_types.super_armor] = {
	0,
	0.2,
}
ogryn_thumper_p1_m2_default_instant.armor_damage_modifier_ranged.far.attack[armor_types.armored] = {
	0,
	0.1,
}
ogryn_thumper_p1_m2_default_instant.armor_damage_modifier_ranged.far.attack[armor_types.super_armor] = {
	0,
	0.1,
}
ogryn_thumper_p1_m2_default_instant.armor_damage_modifier_ranged.near.impact[armor_types.armored] = {
	0.5,
	1.5,
}
ogryn_thumper_p1_m2_default_instant.armor_damage_modifier_ranged.near.impact[armor_types.super_armor] = {
	0.5,
	1.5,
}
ogryn_thumper_p1_m2_default_instant.armor_damage_modifier_ranged.far.impact[armor_types.armored] = {
	0.2,
	0.4,
}
ogryn_thumper_p1_m2_default_instant.armor_damage_modifier_ranged.far.impact[armor_types.super_armor] = {
	0.2,
	0.4,
}
ogryn_thumper_p1_m2_default_instant.power_distribution_ranged.attack.far = {
	10,
	20,
}
ogryn_thumper_p1_m2_default_instant.power_distribution_ranged.attack.near = {
	100,
	200,
}
ogryn_thumper_p1_m2_default_instant.power_distribution_ranged.impact.far = {
	25,
	75,
}
ogryn_thumper_p1_m2_default_instant.power_distribution_ranged.impact.near = {
	0,
	10,
}
ogryn_thumper_p1_m2_default_instant.count_as_ranged_attack = true
damage_templates.ogryn_thumper_p1_m2_default_instant = ogryn_thumper_p1_m2_default_instant

local ogryn_thumper_p1_m2_close_instant = table.clone(damage_templates.close_grenade)

ogryn_thumper_p1_m2_close_instant.armor_damage_modifier.attack[armor_types.armored] = {
	0.25,
	0.75,
}
ogryn_thumper_p1_m2_close_instant.armor_damage_modifier.attack[armor_types.super_armor] = {
	0,
	0.2,
}
ogryn_thumper_p1_m2_close_instant.armor_damage_modifier.impact[armor_types.armored] = {
	0.5,
	1.5,
}
ogryn_thumper_p1_m2_close_instant.armor_damage_modifier.impact[armor_types.super_armor] = {
	0.5,
	1.5,
}
ogryn_thumper_p1_m2_close_instant.power_distribution.attack = {
	500,
	1000,
}
ogryn_thumper_p1_m2_close_instant.power_distribution.impact = {
	40,
	80,
}
ogryn_thumper_p1_m2_close_instant.count_as_ranged_attack = true
damage_templates.ogryn_thumper_p1_m2_close_instant = ogryn_thumper_p1_m2_close_instant

local ogryn_grenade = table.clone(damage_templates.default_grenade)

ogryn_grenade.armor_damage_modifier_ranged.near.attack[armor_types.armored] = {
	1,
	1.6,
}
ogryn_grenade.armor_damage_modifier_ranged.far.attack[armor_types.armored] = {
	0.25,
	0.5,
}
ogryn_grenade.armor_damage_modifier_ranged.far.attack[armor_types.unarmored] = {
	2,
	2,
}
ogryn_grenade.armor_damage_modifier_ranged.near.attack[armor_types.unarmored] = {
	2,
	2,
}
ogryn_grenade.armor_damage_modifier_ranged.near.attack[armor_types.berserker] = {
	2,
	2.6,
}
ogryn_grenade.armor_damage_modifier_ranged.far.attack[armor_types.berserker] = {
	0.75,
	0.95,
}
ogryn_grenade.armor_damage_modifier_ranged.near.impact[armor_types.armored] = {
	2,
	4,
}
ogryn_grenade.armor_damage_modifier_ranged.far.impact[armor_types.armored] = {
	0.2,
	0.5,
}
ogryn_grenade.armor_damage_modifier_ranged.near.attack[armor_types.super_armor] = {
	0.8,
	1.2,
}
ogryn_grenade.armor_damage_modifier_ranged.far.attack[armor_types.super_armor] = {
	0.25,
	0.5,
}
ogryn_grenade.armor_damage_modifier_ranged.near.impact[armor_types.super_armor] = {
	1,
	1,
}
ogryn_grenade.armor_damage_modifier_ranged.far.impact[armor_types.super_armor] = {
	0.25,
	0.5,
}
ogryn_grenade.armor_damage_modifier_ranged.near.attack[armor_types.resistant] = {
	2,
	3.25,
}
ogryn_grenade.armor_damage_modifier_ranged.far.attack[armor_types.resistant] = {
	1,
	1.25,
}
ogryn_grenade.armor_damage_modifier_ranged.near.impact[armor_types.resistant] = {
	1.5,
	1.5,
}
ogryn_grenade.armor_damage_modifier_ranged.far.impact[armor_types.resistant] = {
	3,
	3,
}
ogryn_grenade.power_distribution_ranged.attack.near = 1250
ogryn_grenade.power_distribution_ranged.attack.far = 600
ogryn_grenade.power_distribution_ranged.impact.near = 200
ogryn_grenade.power_distribution_ranged.impact.far = 10
ogryn_grenade.damage_type = damage_types.grenade_frag
ogryn_grenade.gibbing_power = gibbing_power.heavy
ogryn_grenade.ragdoll_push_force = 1200
ogryn_grenade.stat_buffs = {
	"frag_damage",
}
damage_templates.ogryn_grenade = ogryn_grenade

local close_ogryn_grenade = table.clone(damage_templates.close_grenade)

close_ogryn_grenade.armor_damage_modifier.attack[armor_types.armored] = {
	1.25,
	1.85,
}
close_ogryn_grenade.armor_damage_modifier.impact[armor_types.armored] = {
	1,
	1,
}
close_ogryn_grenade.armor_damage_modifier.attack[armor_types.berserker] = {
	1.35,
	2,
}
close_ogryn_grenade.armor_damage_modifier.attack[armor_types.super_armor] = {
	0.8,
	1.25,
}
close_ogryn_grenade.armor_damage_modifier.impact[armor_types.super_armor] = {
	1,
	1,
}
close_ogryn_grenade.armor_damage_modifier.attack[armor_types.resistant] = {
	2,
	3.25,
}
close_ogryn_grenade.armor_damage_modifier.impact[armor_types.resistant] = {
	3,
	3,
}
close_ogryn_grenade.power_distribution.attack = 1500
close_ogryn_grenade.damage_type = damage_types.grenade_frag
close_ogryn_grenade.gibbing_power = gibbing_power.heavy
close_ogryn_grenade.ragdoll_push_force = 2000
close_ogryn_grenade.stat_buffs = {
	"frag_damage",
}
damage_templates.close_ogryn_grenade = close_ogryn_grenade

return {
	base_templates = damage_templates,
	overrides = overrides,
}
