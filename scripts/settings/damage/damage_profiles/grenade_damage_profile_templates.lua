-- chunkname: @scripts/settings/damage/damage_profiles/grenade_damage_profile_templates.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local GibbingSettings = require("scripts/settings/gibbing/gibbing_settings")
local GibbingPower = GibbingSettings.gibbing_power
local GibbingTypes = GibbingSettings.gibbing_types
local DamageProfileSettings = require("scripts/settings/damage/damage_profile_settings")
local armor_types = ArmorSettings.types
local medium_cleave = DamageProfileSettings.medium_cleave
local no_cleave = DamageProfileSettings.no_cleave
local damage_templates = {}
local overrides = {}
local damage_lerp_values = DamageProfileSettings.damage_lerp_values

table.make_unique(damage_templates)
table.make_unique(overrides)

damage_templates.ogryn_grenade_impact = {
	shield_override_stagger_strength = 120,
	gibbing_power = 0,
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
				[armor_types.void_shield] = 0.75
			},
			impact = {
				[armor_types.unarmored] = 2,
				[armor_types.armored] = 5,
				[armor_types.resistant] = 2,
				[armor_types.player] = 2,
				[armor_types.berserker] = 2,
				[armor_types.super_armor] = 0.5,
				[armor_types.disgustingly_resilient] = 2.5,
				[armor_types.void_shield] = 2.5
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
				[armor_types.void_shield] = 1
			},
			impact = {
				[armor_types.unarmored] = 2,
				[armor_types.armored] = 5,
				[armor_types.resistant] = 2,
				[armor_types.player] = 2,
				[armor_types.berserker] = 2,
				[armor_types.super_armor] = 2,
				[armor_types.disgustingly_resilient] = 2.5,
				[armor_types.void_shield] = 2.5
			}
		}
	},
	power_distribution = {
		attack = 70,
		impact = 20
	},
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
				[armor_types.void_shield] = 2
			},
			impact = {
				[armor_types.unarmored] = 2,
				[armor_types.armored] = 5,
				[armor_types.resistant] = 2,
				[armor_types.player] = 2,
				[armor_types.berserker] = 2,
				[armor_types.super_armor] = 1,
				[armor_types.disgustingly_resilient] = 2.5,
				[armor_types.void_shield] = 2.5
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
				[armor_types.void_shield] = 2
			},
			impact = {
				[armor_types.unarmored] = 2,
				[armor_types.armored] = 5,
				[armor_types.resistant] = 2,
				[armor_types.player] = 2,
				[armor_types.berserker] = 2,
				[armor_types.super_armor] = 2,
				[armor_types.disgustingly_resilient] = 2.5,
				[armor_types.void_shield] = 2.5
			}
		}
	},
	power_distribution = {
		attack = 1850,
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
overrides.ogryn_grenade_box_cluster_impact = {
	parent_template_name = "ogryn_grenade_box_impact",
	overrides = {
		{
			"cleave_distribution",
			no_cleave
		}
	}
}
damage_templates.krak_grenade_impact = {
	gibbing_power = 0,
	suppression_value = 4,
	stagger_override = "light",
	ignore_shield = true,
	ragdoll_push_force = 750,
	ignore_stagger_reduction = true,
	stagger_category = "melee",
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
				[armor_types.void_shield] = 0.75
			},
			impact = {
				[armor_types.unarmored] = 2,
				[armor_types.armored] = 5,
				[armor_types.resistant] = 2,
				[armor_types.player] = 2,
				[armor_types.berserker] = 1,
				[armor_types.super_armor] = 0.5,
				[armor_types.disgustingly_resilient] = 2.5,
				[armor_types.void_shield] = 2.5
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
				[armor_types.void_shield] = 1
			},
			impact = {
				[armor_types.unarmored] = 2,
				[armor_types.armored] = 5,
				[armor_types.resistant] = 2,
				[armor_types.player] = 2,
				[armor_types.berserker] = 2,
				[armor_types.super_armor] = 1,
				[armor_types.disgustingly_resilient] = 2.5,
				[armor_types.void_shield] = 2.5
			}
		}
	},
	power_distribution = {
		attack = 2,
		impact = 10
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
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_0_75,
			[armor_types.resistant] = damage_lerp_values.lerp_1,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_1,
			[armor_types.super_armor] = damage_lerp_values.lerp_1,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
			[armor_types.void_shield] = damage_lerp_values.lerp_0_75
		},
		impact = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_1,
			[armor_types.resistant] = damage_lerp_values.lerp_1,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_1,
			[armor_types.super_armor] = damage_lerp_values.lerp_1,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
			[armor_types.void_shield] = damage_lerp_values.lerp_1
		}
	},
	power_distribution = {
		attack = {
			200,
			400
		},
		impact = {
			8,
			16
		}
	},
	gibbing_type = GibbingTypes.crushing,
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
			"gibbing_power",
			0
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
		},
		{
			"gibbing_power",
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
			"gibbing_power",
			0
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
		},
		{
			"gibbing_power",
			0
		}
	}
}
damage_templates.ogryn_friendly_rock_impact = {
	suppression_value = 4,
	gibbing_power = 0,
	ignore_stagger_reduction = true,
	ignore_shield = true,
	ragdoll_only = true,
	weakspot_stagger_resistance_modifier = 0.001,
	stagger_category = "explosion",
	gibbing_type = 0,
	ragdoll_push_force = 2500,
	shield_override_stagger_strength = 200,
	cleave_distribution = {
		attack = {
			8.5,
			12.5
		},
		impact = {
			8.5,
			12.5
		}
	},
	ranges = {
		max = 35,
		min = 12
	},
	armor_damage_modifier_ranged = {
		near = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_1,
				[armor_types.resistant] = damage_lerp_values.lerp_1,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_1_25,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_25,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
				[armor_types.void_shield] = damage_lerp_values.lerp_1
			},
			impact = {
				[armor_types.unarmored] = 2,
				[armor_types.armored] = 5,
				[armor_types.resistant] = 2,
				[armor_types.player] = 2,
				[armor_types.berserker] = 2,
				[armor_types.super_armor] = 1,
				[armor_types.disgustingly_resilient] = 2.5,
				[armor_types.void_shield] = 2.5
			}
		},
		far = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_0_5,
				[armor_types.resistant] = damage_lerp_values.lerp_0_75,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_1_25,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_25,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
				[armor_types.void_shield] = damage_lerp_values.lerp_1
			},
			impact = {
				[armor_types.unarmored] = 2,
				[armor_types.armored] = 5,
				[armor_types.resistant] = 2,
				[armor_types.player] = 2,
				[armor_types.berserker] = 2,
				[armor_types.super_armor] = 2,
				[armor_types.disgustingly_resilient] = 2.5,
				[armor_types.void_shield] = 2.5
			}
		}
	},
	power_distribution = {
		attack = 1200,
		impact = 50
	},
	on_kill_area_suppression = {
		distance = 8,
		suppression_value = 15
	},
	targets = {
		default_target = {
			boost_curve_multiplier_finesse = 0.5,
			boost_curve = PowerLevelSettings.boost_curves.default,
			finesse_boost = {
				[armor_types.resistant] = 0.2
			}
		}
	},
	breed_instakill_overrides = {
		cultist_gunner = true,
		renegade_shocktrooper = true,
		renegade_gunner = true,
		cultist_shocktrooper = true,
		cultist_berzerker = true,
		cultist_mutant = true,
		chaos_hound = true,
		poxwalker_bomber = true,
		corruptor_body = true
	}
}

return {
	base_templates = damage_templates,
	overrides = overrides
}
