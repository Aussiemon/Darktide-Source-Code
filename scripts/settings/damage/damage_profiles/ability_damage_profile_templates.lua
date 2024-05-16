-- chunkname: @scripts/settings/damage/damage_profiles/ability_damage_profile_templates.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local armor_types = ArmorSettings.types
local damage_types = DamageSettings.damage_types
local damage_templates = {}
local overrides = {}

table.make_unique(damage_templates)
table.make_unique(overrides)

damage_templates.shout_stagger_veteran = {
	gibbing_power = 0,
	stagger_category = "melee",
	stagger_duration_modifier = 1.5,
	suppression_type = "ability",
	suppression_value = 30,
	power_distribution = {
		attack = 0,
		impact = 15,
	},
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = 1,
			[armor_types.armored] = 1,
			[armor_types.resistant] = 1,
			[armor_types.player] = 1,
			[armor_types.berserker] = 0.5,
			[armor_types.super_armor] = 0,
			[armor_types.disgustingly_resilient] = 0,
			[armor_types.void_shield] = 0,
		},
		impact = {
			[armor_types.unarmored] = 5,
			[armor_types.armored] = 5,
			[armor_types.resistant] = 5,
			[armor_types.player] = 5,
			[armor_types.berserker] = 5,
			[armor_types.super_armor] = 5,
			[armor_types.disgustingly_resilient] = 5,
			[armor_types.void_shield] = 5,
		},
	},
	targets = {
		default_target = {},
	},
}
damage_templates.shout_stagger_ogryn_taunt = {
	gibbing_power = 0,
	stagger_category = "melee",
	suppression_type = "ability",
	suppression_value = 10,
	power_distribution = {
		attack = 0,
		impact = 1,
	},
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = 1,
			[armor_types.armored] = 1,
			[armor_types.resistant] = 1,
			[armor_types.player] = 1,
			[armor_types.berserker] = 0.5,
			[armor_types.super_armor] = 0,
			[armor_types.disgustingly_resilient] = 0,
			[armor_types.void_shield] = 0,
		},
		impact = {
			[armor_types.unarmored] = 0.1,
			[armor_types.armored] = 0.1,
			[armor_types.resistant] = 0.1,
			[armor_types.player] = 0.1,
			[armor_types.berserker] = 0.1,
			[armor_types.super_armor] = 0.1,
			[armor_types.disgustingly_resilient] = 0.1,
			[armor_types.void_shield] = 0.1,
		},
	},
	targets = {
		default_target = {},
	},
}
damage_templates.veteran_invisibility_suppression = {
	gibbing_power = 0,
	ignore_stagger_reduction = true,
	stagger_category = "killshot",
	stagger_duration_modifier = 1.5,
	stagger_override = "killshot",
	suppression_type = "ability",
	suppression_value = 200,
	power_distribution = {
		attack = 0,
		impact = 15,
	},
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = 1,
			[armor_types.armored] = 1,
			[armor_types.resistant] = 1,
			[armor_types.player] = 1,
			[armor_types.berserker] = 0.5,
			[armor_types.super_armor] = 0,
			[armor_types.disgustingly_resilient] = 0,
			[armor_types.void_shield] = 0,
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
	targets = {
		default_target = {},
	},
}
damage_templates.zealot_channel_stagger = {
	ignore_stagger_reduction = true,
	no_stagger_breed_tag = "ogryn",
	stagger_category = "melee",
	stagger_override = "light",
	suppression_type = "ability",
	suppression_value = 200,
	power_distribution = {
		attack = 0,
		impact = 1,
	},
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = 1,
			[armor_types.armored] = 1,
			[armor_types.resistant] = 0.1,
			[armor_types.player] = 1,
			[armor_types.berserker] = 0.5,
			[armor_types.super_armor] = 0,
			[armor_types.disgustingly_resilient] = 0,
			[armor_types.void_shield] = 0,
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
	targets = {
		default_target = {},
	},
}
damage_templates.psyker_biomancer_shout = {
	ignore_shield = true,
	ignore_stagger_reduction = true,
	stagger_category = "melee",
	stagger_duration_modifier = 1,
	suppression_type = "ability",
	suppression_value = 30,
	power_distribution = {
		attack = 0,
		impact = 17,
	},
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = 1,
			[armor_types.armored] = 1,
			[armor_types.resistant] = 1,
			[armor_types.player] = 1,
			[armor_types.berserker] = 1,
			[armor_types.super_armor] = 1,
			[armor_types.disgustingly_resilient] = 1,
			[armor_types.void_shield] = 0,
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
	damage_type = damage_types.psyker_biomancer_discharge,
	targets = {
		default_target = {},
	},
}
damage_templates.psyker_biomancer_shout_damage = {
	ignore_shield = true,
	ignore_stagger_reduction = true,
	stagger_category = "melee",
	stagger_duration_modifier = 1,
	suppression_type = "ability",
	suppression_value = 30,
	power_distribution = {
		attack = 100,
		impact = 17,
	},
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = 1,
			[armor_types.armored] = 1,
			[armor_types.resistant] = 1,
			[armor_types.player] = 1,
			[armor_types.berserker] = 1,
			[armor_types.super_armor] = 1,
			[armor_types.disgustingly_resilient] = 1,
			[armor_types.void_shield] = 0,
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
	damage_type = damage_types.psyker_biomancer_discharge,
	targets = {
		default_target = {},
	},
}
damage_templates.psyker_shield_stagger = {
	ignore_shield = true,
	ignore_stagger_reduction = true,
	stagger_category = "melee",
	stagger_duration_modifier = 1,
	suppression_type = "ability",
	suppression_value = 30,
	power_distribution = {
		attack = 0,
		impact = 250,
	},
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = 1,
			[armor_types.armored] = 1,
			[armor_types.resistant] = 1,
			[armor_types.player] = 1,
			[armor_types.berserker] = 1,
			[armor_types.super_armor] = 1,
			[armor_types.disgustingly_resilient] = 1,
			[armor_types.void_shield] = 0,
		},
		impact = {
			[armor_types.unarmored] = 5,
			[armor_types.armored] = 5,
			[armor_types.resistant] = 5,
			[armor_types.player] = 5,
			[armor_types.berserker] = 5,
			[armor_types.super_armor] = 5,
			[armor_types.disgustingly_resilient] = 5,
			[armor_types.void_shield] = 5,
		},
	},
	damage_type = damage_types.electrocution,
	targets = {
		default_target = {},
	},
}
damage_templates.zealot_dash_impact = {
	ignore_stagger_reduction = true,
	is_push = true,
	stagger_category = "hatchet",
	stagger_override = "killshot",
	power_distribution = {
		attack = 0,
		impact = 8,
	},
	cleave_distribution = {
		attack = 0,
		impact = 0.01,
	},
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = 1,
			[armor_types.armored] = 1,
			[armor_types.resistant] = 1,
			[armor_types.player] = 1,
			[armor_types.berserker] = 0.5,
			[armor_types.super_armor] = 0,
			[armor_types.disgustingly_resilient] = 0.5,
			[armor_types.void_shield] = 0.5,
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
	targets = {
		default_target = {},
	},
}
damage_templates.zealot_dash_health_to_damage_transfer = {
	is_push = true,
	stagger_category = "explosion",
	power_distribution = {
		attack = 0.5,
		impact = 0,
	},
	cleave_distribution = {
		impact = 0,
		attack = math.huge,
	},
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = 1,
			[armor_types.armored] = 1,
			[armor_types.resistant] = 1,
			[armor_types.player] = 1,
			[armor_types.berserker] = 0.5,
			[armor_types.super_armor] = 0.1,
			[armor_types.disgustingly_resilient] = 0.5,
			[armor_types.void_shield] = 0.5,
		},
		impact = {
			[armor_types.unarmored] = 1,
			[armor_types.armored] = 1,
			[armor_types.resistant] = 1,
			[armor_types.player] = 1,
			[armor_types.berserker] = 0.5,
			[armor_types.super_armor] = 0.1,
			[armor_types.disgustingly_resilient] = 1,
			[armor_types.void_shield] = 1,
		},
	},
	targets = {
		default_target = {},
	},
}
damage_templates.zealot_preacher_ability_close = {
	damage_type = "kinetic",
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
			[armor_types.armored] = 1,
			[armor_types.resistant] = 1,
			[armor_types.player] = 1,
			[armor_types.berserker] = 1,
			[armor_types.super_armor] = 0,
			[armor_types.disgustingly_resilient] = 1,
			[armor_types.void_shield] = 1,
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
		attack = 75,
		impact = 75,
	},
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
}
damage_templates.zealot_preacher_ability_far = {
	damage_type = "kinetic",
	ignore_stagger_reduction = true,
	ragdoll_push_force = 1000,
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
				[armor_types.super_armor] = 1,
				[armor_types.disgustingly_resilient] = 1,
				[armor_types.void_shield] = 1,
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
		far = {
			attack = {
				[armor_types.unarmored] = 0.5,
				[armor_types.armored] = 0.5,
				[armor_types.resistant] = 0.5,
				[armor_types.player] = 0.5,
				[armor_types.berserker] = 0.5,
				[armor_types.super_armor] = 0.5,
				[armor_types.disgustingly_resilient] = 0.5,
				[armor_types.void_shield] = 0.5,
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
	},
	power_distribution_ranged = {
		attack = {
			far = 10,
			near = 50,
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
}
damage_templates.ogryn_charge_impact = {
	ignore_stagger_reduction = true,
	is_push = true,
	stagger_category = "explosion",
	power_distribution = {
		attack = 0,
		impact = 250,
	},
	cleave_distribution = {
		attack = 0,
		impact = math.huge,
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
			[armor_types.unarmored] = 6,
			[armor_types.armored] = 6,
			[armor_types.resistant] = 6,
			[armor_types.player] = 6,
			[armor_types.berserker] = 6,
			[armor_types.super_armor] = 6,
			[armor_types.disgustingly_resilient] = 6,
			[armor_types.void_shield] = 6,
		},
	},
	targets = {
		default_target = {},
	},
	attacker_impact_effects = {
		camera_effect_shake_event = "ogryn_charge_impact",
	},
}
damage_templates.ogryn_charge_finish = {
	ignore_stagger_reduction = true,
	ragdoll_push_force = 500,
	stagger_category = "explosion",
	cleave_distribution = {
		attack = 0.1,
		impact = 0.1,
	},
	ranges = {
		max = 20,
		min = 19,
	},
	armor_damage_modifier_ranged = {
		near = {
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
				[armor_types.unarmored] = 5,
				[armor_types.armored] = 5,
				[armor_types.resistant] = 5,
				[armor_types.player] = 5,
				[armor_types.berserker] = 5,
				[armor_types.super_armor] = 5,
				[armor_types.disgustingly_resilient] = 5,
				[armor_types.void_shield] = 5,
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
				[armor_types.unarmored] = 5,
				[armor_types.armored] = 5,
				[armor_types.resistant] = 5,
				[armor_types.player] = 5,
				[armor_types.berserker] = 5,
				[armor_types.super_armor] = 5,
				[armor_types.disgustingly_resilient] = 5,
				[armor_types.void_shield] = 5,
			},
		},
	},
	crit_mods = {
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
			[armor_types.unarmored] = 5,
			[armor_types.armored] = 5,
			[armor_types.resistant] = 5,
			[armor_types.player] = 5,
			[armor_types.berserker] = 5,
			[armor_types.super_armor] = 5,
			[armor_types.disgustingly_resilient] = 5,
			[armor_types.void_shield] = 5,
		},
	},
	power_distribution = {
		attack = 0,
		impact = 10,
	},
	targets = {
		default_target = {
			boost_curve_multiplier_finesse = 1.2,
			boost_curve = PowerLevelSettings.boost_curves.default,
			finesse_boost = {
				[armor_types.unarmored] = 1,
			},
		},
	},
}
damage_templates.ogryn_charge_impact_damage = {
	ignore_stagger_reduction = true,
	is_push = true,
	stagger_category = "explosion",
	stagger_duration_modifier = 1.5,
	power_distribution = {
		attack = 50,
		impact = 250,
	},
	cleave_distribution = {
		attack = 0,
		impact = 1,
	},
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = 1,
			[armor_types.armored] = 1,
			[armor_types.resistant] = 1,
			[armor_types.player] = 1,
			[armor_types.berserker] = 0.5,
			[armor_types.super_armor] = 0.1,
			[armor_types.disgustingly_resilient] = 0.5,
			[armor_types.void_shield] = 0.5,
		},
		impact = {
			[armor_types.unarmored] = 6,
			[armor_types.armored] = 6,
			[armor_types.resistant] = 6,
			[armor_types.player] = 6,
			[armor_types.berserker] = 6,
			[armor_types.super_armor] = 6,
			[armor_types.disgustingly_resilient] = 6,
			[armor_types.void_shield] = 6,
		},
	},
	targets = {
		default_target = {},
	},
	attacker_impact_effects = {
		camera_effect_shake_event = "ogryn_charge_impact",
	},
}
damage_templates.ogryn_charge_finish_damage = {
	ignore_stagger_reduction = true,
	ragdoll_push_force = 500,
	stagger_category = "explosion",
	stagger_duration_modifier = 1.5,
	power_distribution = {
		attack = 50,
		impact = 250,
	},
	cleave_distribution = {
		attack = 0.1,
		impact = 0.1,
	},
	ranges = {
		max = 20,
		min = 19,
	},
	armor_damage_modifier_ranged = {
		near = {
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
				[armor_types.unarmored] = 5,
				[armor_types.armored] = 5,
				[armor_types.resistant] = 5,
				[armor_types.player] = 5,
				[armor_types.berserker] = 5,
				[armor_types.super_armor] = 5,
				[armor_types.disgustingly_resilient] = 5,
				[armor_types.void_shield] = 5,
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
				[armor_types.unarmored] = 5,
				[armor_types.armored] = 5,
				[armor_types.resistant] = 5,
				[armor_types.player] = 5,
				[armor_types.berserker] = 5,
				[armor_types.super_armor] = 5,
				[armor_types.disgustingly_resilient] = 5,
				[armor_types.void_shield] = 5,
			},
		},
	},
	crit_mods = {
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
			[armor_types.unarmored] = 5,
			[armor_types.armored] = 5,
			[armor_types.resistant] = 5,
			[armor_types.player] = 5,
			[armor_types.berserker] = 5,
			[armor_types.super_armor] = 5,
			[armor_types.disgustingly_resilient] = 5,
			[armor_types.void_shield] = 5,
		},
	},
	targets = {
		default_target = {
			boost_curve_multiplier_finesse = 1.2,
			boost_curve = PowerLevelSettings.boost_curves.default,
			finesse_boost = {
				[armor_types.unarmored] = 1,
			},
		},
	},
}
damage_templates.slide_knockdown = {
	is_push = true,
	stagger_category = "melee",
	power_distribution = {
		attack = 0,
		impact = 0.35,
	},
	cleave_distribution = {
		attack = 0,
		impact = math.huge,
	},
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = 1,
			[armor_types.armored] = 1,
			[armor_types.resistant] = 1,
			[armor_types.player] = 1,
			[armor_types.berserker] = 0.5,
			[armor_types.super_armor] = 0,
			[armor_types.disgustingly_resilient] = 0.5,
			[armor_types.void_shield] = 0.5,
		},
		impact = {
			[armor_types.unarmored] = 1,
			[armor_types.armored] = 1,
			[armor_types.resistant] = 1,
			[armor_types.player] = 1,
			[armor_types.berserker] = 0.5,
			[armor_types.super_armor] = 0,
			[armor_types.disgustingly_resilient] = 1,
			[armor_types.void_shield] = 1,
		},
	},
	targets = {
		default_target = {},
	},
}

return {
	base_templates = damage_templates,
	overrides = overrides,
}
