local ArmorSettings = require("scripts/settings/damage/armor_settings")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local GibbingSettings = require("scripts/settings/gibbing/gibbing_settings")
local GibbingPower = GibbingSettings.gibbing_power
local GibbingTypes = GibbingSettings.gibbing_types
local DamageProfileSettings = require("scripts/settings/damage/damage_profile_settings")
local armor_types = ArmorSettings.types
local medium_cleave = DamageProfileSettings.medium_cleave
local damage_templates = {}
local overrides = {}

table.make_unique(damage_templates)
table.make_unique(overrides)

damage_templates.ogryn_grenade_impact = {
	shield_override_stagger_strength = 120,
	suppression_value = 4,
	ignore_shield = true,
	ragdoll_push_force = 750,
	ignore_stagger_reduction = true,
	stagger_category = "ranged",
	gibbing_type = 0,
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
		attack = 30,
		impact = 15
	},
	gibbing_power = GibbingPower.light,
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
	},
	breed_instakill_overrides = {
		corruptor_body = true
	}
}
damage_templates.ogryn_grenade_box_impact = {
	shield_override_stagger_strength = 150,
	gibbing_power = 0,
	suppression_value = 4,
	ignore_shield = true,
	ragdoll_push_force = 2000,
	ragdoll_only = true,
	ignore_stagger_reduction = true,
	stagger_category = "ranged",
	gibbing_type = 0,
	cleave_distribution = medium_cleave,
	ranges = {
		max = 30,
		min = 15
	},
	armor_damage_modifier_ranged = {
		near = {
			attack = {
				[armor_types.unarmored] = 1,
				[armor_types.armored] = 1,
				[armor_types.resistant] = 1.5,
				[armor_types.player] = 1,
				[armor_types.berserker] = 1,
				[armor_types.super_armor] = 0.15,
				[armor_types.disgustingly_resilient] = 1,
				[armor_types.void_shield] = 2,
				[armor_types.prop_armor] = 1
			},
			impact = {
				[armor_types.unarmored] = 2,
				[armor_types.armored] = 5,
				[armor_types.resistant] = 2,
				[armor_types.player] = 2,
				[armor_types.berserker] = 2,
				[armor_types.super_armor] = 1,
				[armor_types.disgustingly_resilient] = 2.5,
				[armor_types.void_shield] = 2.5,
				[armor_types.prop_armor] = 5
			}
		},
		far = {
			attack = {
				[armor_types.unarmored] = 1,
				[armor_types.armored] = 1,
				[armor_types.resistant] = 1.5,
				[armor_types.player] = 1,
				[armor_types.berserker] = 1,
				[armor_types.super_armor] = 0.15,
				[armor_types.disgustingly_resilient] = 1,
				[armor_types.void_shield] = 2,
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
		attack = 1500,
		impact = 65
	},
	on_kill_area_suppression = {
		distance = 8,
		suppression_value = 15
	},
	targets = {
		default_target = {
			boost_curve_multiplier_finesse = 1.4,
			boost_curve = PowerLevelSettings.boost_curves.default,
			finesse_boost = {
				[armor_types.unarmored] = 0.75
			}
		}
	},
	breed_instakill_overrides = {
		corruptor_body = true,
		renegade_shocktrooper = true,
		renegade_gunner = true,
		poxwalker_bomber = true,
		cultist_berzerker = true,
		cultist_mutant = true,
		chaos_hound = true,
		cultist_shocktrooper = true,
		cultist_gunner = true,
		renegade_executor = true
	}
}
damage_templates.krak_grenade_impact = {
	ignore_stagger_reduction = true,
	gibbing_power = 0,
	suppression_value = 4,
	stagger_override = "medium",
	ignore_shield = true,
	ragdoll_push_force = 750,
	shield_override_stagger_strength = 120,
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
		impact = 300
	},
	gibbing_type = GibbingTypes.explosion,
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
damage_templates.thumper_grenade_impact = {
	gibbing_power = 0,
	suppression_value = 4,
	ragdoll_push_force = 1250,
	ragdoll_only = true,
	ignore_stagger_reduction = true,
	stagger_category = "melee",
	cleave_distribution = {
		attack = 5.1,
		impact = 5.1
	},
	ranges = {
		max = 20,
		min = 10
	},
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = 1,
			[armor_types.armored] = 0.75,
			[armor_types.resistant] = 1,
			[armor_types.player] = 1,
			[armor_types.berserker] = 1,
			[armor_types.super_armor] = 0,
			[armor_types.disgustingly_resilient] = 1,
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
		attack = 200,
		impact = 10
	},
	gibbing_type = GibbingTypes.explosion,
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
overrides.frag_grenade_impact = {
	parent_template_name = "ogryn_grenade_impact",
	overrides = {
		{
			"power_distribution",
			"attack",
			2
		},
		{
			"power_distribution",
			"impact",
			3
		},
		{
			"ragdoll_push_force",
			150
		},
		{
			"ignore_stagger_reduction",
			false
		},
		{
			"ignore_shield",
			false
		},
		{
			"shield_override_stagger_strength",
			0
		}
	}
}
overrides.fire_grenade_impact = {
	parent_template_name = "ogryn_grenade_impact",
	overrides = {
		{
			"power_distribution",
			"attack",
			2
		},
		{
			"power_distribution",
			"impact",
			3
		},
		{
			"ragdoll_push_force",
			150
		},
		{
			"ignore_stagger_reduction",
			false
		},
		{
			"ignore_shield",
			false
		},
		{
			"shield_override_stagger_strength",
			0
		}
	}
}

return {
	base_templates = damage_templates,
	overrides = overrides
}
