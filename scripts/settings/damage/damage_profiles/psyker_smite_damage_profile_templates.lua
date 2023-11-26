-- chunkname: @scripts/settings/damage/damage_profiles/psyker_smite_damage_profile_templates.lua

local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local DamageProfileSettings = require("scripts/settings/damage/damage_profile_settings")
local GibbingSettings = require("scripts/settings/gibbing/gibbing_settings")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local ArmorSettings = require("scripts/settings/damage/armor_settings")
local WoundsTemplates = require("scripts/settings/damage/wounds_templates")
local GIBBING_POWER = GibbingSettings.gibbing_power
local GIBBING_TYPES = GibbingSettings.gibbing_types
local DAMAGE_TYPES = DamageSettings.damage_types
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
local no_cleave = DamageProfileSettings.no_cleave
local double_cleave = DamageProfileSettings.double_cleave
local light_cleave = DamageProfileSettings.light_cleave
local big_cleave = DamageProfileSettings.big_cleave

damage_templates.psyker_smite_kill = {
	ignore_stagger_reduction = true,
	ragdoll_push_force = 0,
	ignore_shield = true,
	ragdoll_only = true,
	stagger_category = "uppercut",
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_1,
			[armor_types.resistant] = damage_lerp_values.lerp_1_25,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_1_5,
			[armor_types.super_armor] = damage_lerp_values.lerp_1,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
			[armor_types.void_shield] = damage_lerp_values.lerp_1
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
	cleave_distribution = {
		attack = 100,
		impact = 100
	},
	power_distribution = {
		attack = 900,
		impact = 55
	},
	gibbing_power = GIBBING_POWER.heavy,
	gibbing_type = GIBBING_TYPES.warp,
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
			[armor_types.void_shield] = 1
		},
		impact = {
			[armor_types.unarmored] = 1,
			[armor_types.armored] = 1,
			[armor_types.resistant] = 1,
			[armor_types.player] = 1,
			[armor_types.berserker] = 1,
			[armor_types.super_armor] = 1,
			[armor_types.disgustingly_resilient] = 1,
			[armor_types.void_shield] = 1
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
	damage_type = DAMAGE_TYPES.biomancer_soul,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.psyker_throwing_knives = {
	psyker_smite = true,
	hit_mass_override = 1,
	stagger_override = "killshot",
	vo_no_headshot = true,
	ignore_stagger_reduction = true,
	stagger_category = "killshot",
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_0_75,
			[armor_types.resistant] = damage_lerp_values.lerp_0_5,
			[armor_types.player] = damage_lerp_values.lerp_0_75,
			[armor_types.berserker] = damage_lerp_values.lerp_1,
			[armor_types.super_armor] = damage_lerp_values.lerp_0_05,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_75,
			[armor_types.void_shield] = damage_lerp_values.lerp_0_75
		},
		impact = {
			[armor_types.unarmored] = damage_lerp_values.lerp_0_75,
			[armor_types.armored] = damage_lerp_values.lerp_0_5,
			[armor_types.resistant] = damage_lerp_values.lerp_0_75,
			[armor_types.player] = damage_lerp_values.lerp_0_75,
			[armor_types.berserker] = damage_lerp_values.lerp_0_75,
			[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_75,
			[armor_types.void_shield] = damage_lerp_values.lerp_0_75
		}
	},
	cleave_distribution = {
		attack = 2,
		impact = 2
	},
	power_distribution = {
		attack = 100,
		impact = 5
	},
	gibbing_power = GIBBING_POWER.light,
	gibbing_type = GIBBING_TYPES.warp_shard,
	gib_push_force = GibbingSettings.gib_push_force.ranged_light,
	damage_type = DAMAGE_TYPES.warp,
	targets = {
		{
			boost_curve_multiplier_finesse = 1.5,
			boost_curve = PowerLevelSettings.boost_curves.default,
			power_distribution = {
				attack = 200,
				impact = 25
			},
			finesse_boost = {
				[armor_types.unarmored] = 0.5,
				[armor_types.armored] = 0.5
			}
		},
		{
			boost_curve_multiplier_finesse = 1,
			boost_curve = PowerLevelSettings.boost_curves.default,
			power_distribution = {
				attack = 150,
				impact = 5
			},
			finesse_boost = {
				[armor_types.unarmored] = 0.5,
				[armor_types.armored] = 0.5
			}
		},
		{
			boost_curve_multiplier_finesse = 1,
			boost_curve = PowerLevelSettings.boost_curves.default,
			power_distribution = {
				attack = 100,
				impact = 5
			},
			finesse_boost = {
				[armor_types.unarmored] = 0.5,
				[armor_types.armored] = 0.5
			}
		},
		default_target = {
			boost_curve_multiplier_finesse = 0.75,
			boost_curve = PowerLevelSettings.boost_curves.default,
			finesse_boost = {
				[armor_types.unarmored] = 0.5,
				[armor_types.armored] = 0.5
			}
		}
	}
}
damage_templates.psyker_throwing_knives_aimed = table.clone(damage_templates.psyker_throwing_knives)
damage_templates.psyker_throwing_knives_aimed.targets[1].power_distribution.attack = 340
damage_templates.psyker_throwing_knives_aimed.targets[2].power_distribution.attack = 200
damage_templates.psyker_throwing_knives_aimed.targets[3].power_distribution.attack = 150
damage_templates.psyker_throwing_knives_aimed_pierce = table.clone(damage_templates.psyker_throwing_knives)
damage_templates.psyker_throwing_knives_aimed_pierce.cleave_distribution.attack = 4
damage_templates.psyker_throwing_knives_aimed_pierce.cleave_distribution.impact = 4
damage_templates.psyker_throwing_knives_aimed_pierce.power_distribution.attack = 150
damage_templates.psyker_throwing_knives_aimed_pierce.targets[1].power_distribution.attack = 400
damage_templates.psyker_throwing_knives_aimed_pierce.targets[2].power_distribution.attack = 300
damage_templates.psyker_throwing_knives_aimed_pierce.targets[3].power_distribution.attack = 250
damage_templates.psyker_throwing_knives_pierce = table.clone(damage_templates.psyker_throwing_knives)
damage_templates.psyker_throwing_knives_pierce.cleave_distribution.attack = 4
damage_templates.psyker_throwing_knives_pierce.cleave_distribution.impact = 4
damage_templates.psyker_throwing_knives_pierce.power_distribution.attack = 150
damage_templates.psyker_throwing_knives_pierce.targets[1].power_distribution.attack = 300
damage_templates.psyker_throwing_knives_pierce.targets[2].power_distribution.attack = 250
damage_templates.psyker_throwing_knives_pierce.targets[3].power_distribution.attack = 200
damage_templates.psyker_throwing_knives_psychic_fortress = {
	stagger_category = "ranged",
	vo_no_headshot = true,
	armor_damage_modifier = {
		attack = flat_one_armor_mod,
		impact = flat_one_armor_mod
	},
	cleave_distribution = {
		attack = 10,
		impact = 10
	},
	power_distribution = {
		attack = 100,
		impact = 12
	},
	gibbing_power = GIBBING_POWER.always,
	gibbing_type = GIBBING_TYPES.ballistic,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.psyker_protectorate_spread_chain_lightning_interval = {
	ignore_hitzone_multiplier = true,
	chain_lightning = true,
	stagger_category = "electrocuted",
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = damage_lerp_values.lerp_0_75,
			[armor_types.armored] = damage_lerp_values.lerp_0_75,
			[armor_types.resistant] = damage_lerp_values.lerp_1,
			[armor_types.player] = damage_lerp_values.lerp_0_75,
			[armor_types.berserker] = damage_lerp_values.lerp_1,
			[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_75,
			[armor_types.void_shield] = damage_lerp_values.lerp_0_75
		},
		impact = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1_5,
			[armor_types.armored] = damage_lerp_values.lerp_2_5,
			[armor_types.resistant] = damage_lerp_values.lerp_1_5,
			[armor_types.player] = damage_lerp_values.lerp_1_5,
			[armor_types.berserker] = damage_lerp_values.lerp_1_5,
			[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1_5,
			[armor_types.void_shield] = damage_lerp_values.lerp_1_5
		}
	},
	cleave_distribution = {
		attack = 5,
		impact = 20
	},
	power_distribution = {
		attack = 16,
		impact = 250
	},
	charge_level_scaler = {
		{
			modifier = 1,
			t = 1
		},
		start_modifier = 0.4
	},
	damage_type = DAMAGE_TYPES.electrocution,
	gibbing_power = GIBBING_POWER.infinite,
	gibbing_type = GIBBING_TYPES.warp_lightning,
	gib_push_force = GibbingSettings.gib_push_force.ranged_heavy,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		},
		boost_curve_multiplier_finesse = damage_lerp_values.lerp_1
	}
}
damage_templates.psyker_protectorate_channel_chain_lightning_activated = {
	ignore_stagger_reduction = true,
	ignore_hitzone_multiplier = true,
	stagger_category = "melee",
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_1,
			[armor_types.resistant] = damage_lerp_values.lerp_1,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_1,
			[armor_types.super_armor] = damage_lerp_values.lerp_1,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
			[armor_types.void_shield] = damage_lerp_values.lerp_1
		},
		impact = {
			[armor_types.unarmored] = damage_lerp_values.lerp_0_75,
			[armor_types.armored] = damage_lerp_values.lerp_1,
			[armor_types.resistant] = damage_lerp_values.lerp_0_5,
			[armor_types.player] = damage_lerp_values.lerp_0_5,
			[armor_types.berserker] = damage_lerp_values.lerp_0_5,
			[armor_types.super_armor] = damage_lerp_values.lerp_1,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_75,
			[armor_types.void_shield] = damage_lerp_values.lerp_0_5
		}
	},
	cleave_distribution = {
		attack = 5,
		impact = 5
	},
	power_distribution = {
		attack = 20,
		impact = 20
	},
	damage_type = DAMAGE_TYPES.electrocution,
	gibbing_power = GIBBING_POWER.infinite,
	gibbing_type = GIBBING_TYPES.warp_lightning,
	gib_push_force = GibbingSettings.gib_push_force.ranged_heavy,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		},
		boost_curve_multiplier_finesse = damage_lerp_values.lerp_1
	}
}
damage_templates.psyker_protectorate_chain_lighting = {
	chain_lightning = true,
	ragdoll_only = true,
	stagger_category = "electrocuted",
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = damage_lerp_values.lerp_0_75,
			[armor_types.armored] = damage_lerp_values.lerp_0_75,
			[armor_types.resistant] = damage_lerp_values.lerp_1,
			[armor_types.player] = damage_lerp_values.lerp_0_75,
			[armor_types.berserker] = damage_lerp_values.lerp_1,
			[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_75,
			[armor_types.void_shield] = damage_lerp_values.lerp_0_75
		},
		impact = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_2,
			[armor_types.resistant] = damage_lerp_values.lerp_1,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_1,
			[armor_types.super_armor] = damage_lerp_values.lerp_1_5,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
			[armor_types.void_shield] = damage_lerp_values.lerp_1
		}
	},
	cleave_distribution = {
		attack = 8,
		impact = 20
	},
	power_distribution = {
		attack = 20,
		impact = 150
	},
	damage_type = DAMAGE_TYPES.electrocution,
	gibbing_power = GIBBING_POWER.heavy,
	gibbing_type = GIBBING_TYPES.warp_lightning,
	gib_push_force = GibbingSettings.gib_push_force.ranged_heavy,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		},
		boost_curve_multiplier_finesse = damage_lerp_values.lerp_1
	}
}
overrides.psyker_protectorate_chain_lighting_fast = {
	parent_template_name = "psyker_smite_kill",
	overrides = {
		{
			"power_distribution",
			"attack",
			300
		},
		{
			"power_distribution",
			"impact",
			250
		},
		{
			"chain_lightning",
			true
		},
		{
			"gibbing_power",
			GIBBING_POWER.heavy
		},
		{
			"gibbing_type",
			GIBBING_TYPES.warp_lightning
		},
		{
			"gib_push_force",
			GibbingSettings.gib_push_force.ranged_heavy
		},
		{
			"ragdoll_only",
			true
		}
	}
}
damage_templates.psyker_stun = {
	chain_lightning = true,
	stagger_category = "electrocuted",
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = damage_lerp_values.lerp_0_1,
			[armor_types.armored] = damage_lerp_values.lerp_0_5,
			[armor_types.resistant] = damage_lerp_values.lerp_0_05,
			[armor_types.player] = damage_lerp_values.lerp_0_1,
			[armor_types.berserker] = damage_lerp_values.lerp_0_15,
			[armor_types.super_armor] = damage_lerp_values.lerp_0_01,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_1,
			[armor_types.void_shield] = damage_lerp_values.lerp_0_1
		},
		impact = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_2,
			[armor_types.resistant] = damage_lerp_values.lerp_1,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_1,
			[armor_types.super_armor] = damage_lerp_values.lerp_1_5,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
			[armor_types.void_shield] = damage_lerp_values.lerp_1
		}
	},
	cleave_distribution = {
		attack = 0,
		impact = 20
	},
	power_distribution = {
		attack = 0,
		impact = 250
	},
	damage_type = DAMAGE_TYPES.electrocution,
	gibbing_power = GIBBING_POWER.always,
	gibbing_type = GIBBING_TYPES.warp_lightning,
	gib_push_force = GibbingSettings.gib_push_force.ranged_heavy,
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
