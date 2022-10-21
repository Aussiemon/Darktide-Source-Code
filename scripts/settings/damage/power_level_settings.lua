local ArmorSettings = require("scripts/settings/damage/armor_settings")
local armor_types = ArmorSettings.types
local power_level_settings = {
	min_power_level = 0,
	max_power_level = 10000,
	default_power_level = 500,
	min_power_level_cap = 200,
	power_level_diff_ratio = {
		impact = 10,
		attack = 10,
		cleave = 10
	},
	power_level_curve_constants = {
		starting_bonus = 0,
		native_diff_ratio = 10,
		starting_bonus_range = 0
	},
	damage_output = {
		[armor_types.unarmored] = {
			max = 20,
			min = 0
		},
		[armor_types.armored] = {
			max = 20,
			min = 0
		},
		[armor_types.resistant] = {
			max = 20,
			min = 0
		},
		[armor_types.player] = {
			max = 20,
			min = 0
		},
		[armor_types.berserker] = {
			max = 20,
			min = 0
		},
		[armor_types.super_armor] = {
			max = 20,
			min = 0
		},
		[armor_types.disgustingly_resilient] = {
			max = 20,
			min = 0
		},
		[armor_types.void_shield] = {
			max = 20,
			min = 0
		},
		[armor_types.prop_armor] = {
			max = 20,
			min = 0
		}
	},
	stagger_strength_output = {
		[armor_types.unarmored] = {
			max = 20,
			min = 0
		},
		[armor_types.armored] = {
			max = 20,
			min = 0
		},
		[armor_types.resistant] = {
			max = 20,
			min = 0
		},
		[armor_types.player] = {
			max = 20,
			min = 0
		},
		[armor_types.berserker] = {
			max = 20,
			min = 0
		},
		[armor_types.super_armor] = {
			max = 20,
			min = 0
		},
		[armor_types.disgustingly_resilient] = {
			max = 20,
			min = 0
		},
		[armor_types.void_shield] = {
			max = 20,
			min = 0
		},
		[armor_types.prop_armor] = {
			max = 20,
			min = 0
		}
	},
	cleave_output = {
		max = 20,
		min = 0
	},
	default_armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = 1,
			[armor_types.armored] = 0.5,
			[armor_types.resistant] = 1,
			[armor_types.player] = 1,
			[armor_types.berserker] = 0.75,
			[armor_types.super_armor] = 0,
			[armor_types.disgustingly_resilient] = 0.8,
			[armor_types.void_shield] = 0.8,
			[armor_types.prop_armor] = 0.5
		},
		impact = {
			[armor_types.unarmored] = 1,
			[armor_types.armored] = 0.5,
			[armor_types.resistant] = 1,
			[armor_types.player] = 1,
			[armor_types.berserker] = 0.75,
			[armor_types.super_armor] = 0.5,
			[armor_types.disgustingly_resilient] = 0.8,
			[armor_types.void_shield] = 0.8,
			[armor_types.prop_armor] = 0.5
		}
	},
	default_power_distribution = {
		attack = 100,
		impact = 5
	},
	default_cleave_distribution = {
		attack = 0.15,
		impact = 0.15
	},
	boost_curves = {
		default = {
			0,
			0.3,
			0.6,
			0.8,
			1
		}
	},
	rending_boost_amount = {
		[armor_types.unarmored] = 0.75,
		[armor_types.armored] = 0.6,
		[armor_types.resistant] = 0.5,
		[armor_types.player] = 0.5,
		[armor_types.berserker] = 0.5,
		[armor_types.super_armor] = 0.3,
		[armor_types.disgustingly_resilient] = 0.6,
		[armor_types.void_shield] = 0.6,
		[armor_types.prop_armor] = 0.6
	},
	default_finesse_boost_amount = {
		[armor_types.unarmored] = 0.5,
		[armor_types.armored] = 0.5,
		[armor_types.resistant] = 0.5,
		[armor_types.player] = 0.5,
		[armor_types.berserker] = 0.5,
		[armor_types.super_armor] = 0.5,
		[armor_types.disgustingly_resilient] = 0.5,
		[armor_types.void_shield] = 0.5,
		[armor_types.prop_armor] = 0.5
	},
	smiter_finesse_boost_amount = {
		[armor_types.unarmored] = 0.1,
		[armor_types.armored] = 0.5,
		[armor_types.resistant] = 0.1,
		[armor_types.player] = 0.1,
		[armor_types.berserker] = 0.1,
		[armor_types.super_armor] = 0.1,
		[armor_types.disgustingly_resilient] = 0.5,
		[armor_types.void_shield] = 0.5,
		[armor_types.prop_armor] = 0.5
	},
	default_finesse_boost_no_base_damage_amount = {
		[armor_types.unarmored] = 0,
		[armor_types.armored] = 0.5,
		[armor_types.resistant] = 0,
		[armor_types.player] = 0,
		[armor_types.berserker] = 0,
		[armor_types.super_armor] = 0.25,
		[armor_types.disgustingly_resilient] = 0,
		[armor_types.void_shield] = 0.5,
		[armor_types.prop_armor] = 0.5
	},
	default_crit_boost_amount = 0.5,
	default_boost_curve_multiplier = 0.25,
	rending_armor_conversion = {
		[armor_types.unarmored] = armor_types.unarmored,
		[armor_types.armored] = armor_types.unarmored,
		[armor_types.resistant] = armor_types.resistant,
		[armor_types.player] = armor_types.player,
		[armor_types.berserker] = armor_types.unarmored,
		[armor_types.super_armor] = armor_types.unarmored,
		[armor_types.disgustingly_resilient] = armor_types.unarmored,
		[armor_types.void_shield] = armor_types.unarmored,
		[armor_types.prop_armor] = armor_types.unarmored
	},
	finesse_min_damage_multiplier = 0.5
}

return settings("PowerLevelSettings", power_level_settings)
