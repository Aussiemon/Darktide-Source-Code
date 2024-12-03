-- chunkname: @scripts/settings/equipment/weapon_templates/ogryn_heavystubbers/settings_templates/ogryn_heavystubber_damage_profile_templates.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local DamageProfileSettings = require("scripts/settings/damage/damage_profile_settings")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local GibbingSettings = require("scripts/settings/gibbing/gibbing_settings")
local GibbingPower = GibbingSettings.gibbing_power
local GibbingTypes = GibbingSettings.gibbing_types
local HerdingTemplates = require("scripts/settings/damage/herding_templates")
local WoundsTemplates = require("scripts/settings/damage/wounds_templates")
local crit_impact_armor_mod = DamageProfileSettings.crit_impact_armor_mod
local damage_types = DamageSettings.damage_types
local armor_types = ArmorSettings.types
local damage_templates = {}
local overrides = {}

table.make_unique(damage_templates)
table.make_unique(overrides)

local damage_lerp_values = DamageProfileSettings.damage_lerp_values
local single_cleave = DamageProfileSettings.single_cleave
local light_cleave = DamageProfileSettings.light_cleave
local medium_cleave = DamageProfileSettings.medium_cleave
local large_cleave = DamageProfileSettings.large_cleave
local big_cleave = DamageProfileSettings.big_cleave
local default_shield_override_stagger_strength = 4

damage_templates.default_ogryn_heavystubber_assault_snp = {
	ragdoll_push_force = 600,
	stagger_category = "ranged",
	suppression_value = 2.5,
	cleave_distribution = light_cleave,
	ranges = {
		min = {
			9,
			12,
		},
		max = {
			25,
			40,
		},
	},
	wounds_template = WoundsTemplates.heavy_stubber,
	armor_damage_modifier_ranged = {
		near = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_0_5,
				[armor_types.resistant] = damage_lerp_values.lerp_0_6,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_1,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_1,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_8,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_8,
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1_25,
				[armor_types.armored] = damage_lerp_values.lerp_1,
				[armor_types.resistant] = damage_lerp_values.lerp_1_25,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_0_75,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
				[armor_types.void_shield] = damage_lerp_values.lerp_1,
			},
		},
		far = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_0_8,
				[armor_types.armored] = damage_lerp_values.lerp_0_3,
				[armor_types.resistant] = damage_lerp_values.lerp_0_3,
				[armor_types.player] = damage_lerp_values.lerp_0_5,
				[armor_types.berserker] = damage_lerp_values.lerp_0_8,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_01,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_8,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_0_8,
				[armor_types.resistant] = damage_lerp_values.lerp_0_8,
				[armor_types.player] = damage_lerp_values.lerp_0_4,
				[armor_types.berserker] = damage_lerp_values.lerp_0_1,
				[armor_types.super_armor] = damage_lerp_values.no_damage,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_6,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_4,
			},
		},
	},
	power_distribution = {
		attack = {
			100,
			200,
		},
		impact = {
			10,
			20,
		},
	},
	shield_override_stagger_strength = default_shield_override_stagger_strength,
	damage_type = damage_types.auto_bullet,
	gibbing_power = GibbingPower.heavy,
	gibbing_type = GibbingTypes.ballistic,
	on_kill_area_suppression = {
		distance = 3,
		suppression_value = 1,
	},
	gib_push_force = GibbingSettings.gib_push_force.ranged_heavy,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
}
damage_templates.default_ogryn_heavystubber_assault_snp_m2 = {
	ragdoll_push_force = 600,
	stagger_category = "ranged",
	suppression_value = 2.5,
	cleave_distribution = light_cleave,
	ranges = {
		min = {
			12,
			15,
		},
		max = {
			30,
			60,
		},
	},
	wounds_template = WoundsTemplates.heavy_stubber,
	armor_damage_modifier_ranged = {
		near = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_0_75,
				[armor_types.resistant] = damage_lerp_values.lerp_0_6,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_1,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_1,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_8,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_8,
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1_25,
				[armor_types.armored] = damage_lerp_values.lerp_1,
				[armor_types.resistant] = damage_lerp_values.lerp_1_25,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_0_75,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
				[armor_types.void_shield] = damage_lerp_values.lerp_1,
			},
		},
		far = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_0_8,
				[armor_types.armored] = damage_lerp_values.lerp_0_5,
				[armor_types.resistant] = damage_lerp_values.lerp_0_3,
				[armor_types.player] = damage_lerp_values.lerp_0_5,
				[armor_types.berserker] = damage_lerp_values.lerp_0_8,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_01,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_8,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_0_8,
				[armor_types.resistant] = damage_lerp_values.lerp_0_8,
				[armor_types.player] = damage_lerp_values.lerp_0_4,
				[armor_types.berserker] = damage_lerp_values.lerp_0_1,
				[armor_types.super_armor] = damage_lerp_values.no_damage,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_6,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_4,
			},
		},
	},
	power_distribution = {
		attack = {
			140,
			290,
		},
		impact = {
			20,
			40,
		},
	},
	shield_override_stagger_strength = default_shield_override_stagger_strength,
	damage_type = damage_types.auto_bullet,
	gibbing_power = GibbingPower.heavy,
	gibbing_type = GibbingTypes.ballistic,
	on_kill_area_suppression = {
		distance = 3,
		suppression_value = 1,
	},
	gib_push_force = GibbingSettings.gib_push_force.ranged_heavy,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
}
damage_templates.default_ogryn_heavystubber_assault_snp_m3 = {
	ragdoll_push_force = 600,
	stagger_category = "ranged",
	suppression_value = 2.5,
	cleave_distribution = light_cleave,
	ranges = {
		min = {
			8,
			15,
		},
		max = {
			20,
			35,
		},
	},
	wounds_template = WoundsTemplates.heavy_stubber,
	armor_damage_modifier_ranged = {
		near = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_0_5,
				[armor_types.resistant] = damage_lerp_values.lerp_0_75,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_1,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_1,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_8,
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1_25,
				[armor_types.armored] = damage_lerp_values.lerp_1,
				[armor_types.resistant] = damage_lerp_values.lerp_1_25,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_0_75,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
				[armor_types.void_shield] = damage_lerp_values.lerp_1,
			},
		},
		far = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_0_8,
				[armor_types.armored] = damage_lerp_values.lerp_0_3,
				[armor_types.resistant] = damage_lerp_values.lerp_0_3,
				[armor_types.player] = damage_lerp_values.lerp_0_5,
				[armor_types.berserker] = damage_lerp_values.lerp_0_8,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_01,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_8,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_0_8,
				[armor_types.resistant] = damage_lerp_values.lerp_0_8,
				[armor_types.player] = damage_lerp_values.lerp_0_4,
				[armor_types.berserker] = damage_lerp_values.lerp_0_1,
				[armor_types.super_armor] = damage_lerp_values.no_damage,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_6,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_4,
			},
		},
	},
	power_distribution = {
		attack = {
			80,
			160,
		},
		impact = {
			8,
			16,
		},
	},
	shield_override_stagger_strength = default_shield_override_stagger_strength,
	damage_type = damage_types.auto_bullet,
	gibbing_power = GibbingPower.medium,
	gibbing_type = GibbingTypes.ballistic,
	on_kill_area_suppression = {
		distance = 3,
		suppression_value = 1,
	},
	gib_push_force = GibbingSettings.gib_push_force.ranged_heavy,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
}
damage_templates.default_ogryn_heavystubber_assault = {
	stagger_category = "killshot",
	cleave_distribution = single_cleave,
	ranges = {
		min = {
			10,
			20,
		},
		max = {
			25,
			50,
		},
	},
	herding_template = HerdingTemplates.shot,
	wounds_template = WoundsTemplates.heavy_stubber,
	armor_damage_modifier_ranged = {
		near = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_0_8,
				[armor_types.resistant] = damage_lerp_values.lerp_0_6,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_0_75,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_01,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_6,
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_0_8,
				[armor_types.armored] = damage_lerp_values.lerp_1,
				[armor_types.resistant] = damage_lerp_values.lerp_0_75,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_0_5,
				[armor_types.super_armor] = damage_lerp_values.no_damage,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_4,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_4,
			},
		},
		far = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_0_8,
				[armor_types.armored] = damage_lerp_values.lerp_0_6,
				[armor_types.resistant] = damage_lerp_values.lerp_0_5,
				[armor_types.player] = damage_lerp_values.lerp_0_5,
				[armor_types.berserker] = damage_lerp_values.lerp_0_6,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_01,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_8,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_0_6,
				[armor_types.armored] = damage_lerp_values.lerp_1,
				[armor_types.resistant] = damage_lerp_values.lerp_0_4,
				[armor_types.player] = damage_lerp_values.lerp_0_4,
				[armor_types.berserker] = damage_lerp_values.lerp_0_1,
				[armor_types.super_armor] = damage_lerp_values.no_damage,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_6,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_4,
			},
		},
	},
	critical_strike = {
		gibbing_power = GibbingPower.medium,
		gibbing_type = GibbingTypes.ballistic,
	},
	power_distribution = {
		attack = {
			40,
			100,
		},
		impact = {
			2,
			6,
		},
	},
	accumulative_stagger_strength_multiplier = {
		0.5,
		1,
	},
	shield_override_stagger_strength = default_shield_override_stagger_strength,
	damage_type = damage_types.auto_bullet,
	gibbing_power = GibbingPower.light,
	gibbing_type = GibbingTypes.ballistic,
	suppression_value = {
		0.5,
		1.5,
	},
	on_kill_area_suppression = {
		suppression_value = {
			1,
			2,
		},
		distance = {
			3,
			5,
		},
	},
	ragdoll_push_force = {
		200,
		300,
	},
	gib_push_force = GibbingSettings.gib_push_force.ranged_heavy,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default,
			finesse_boost = {
				[armor_types.unarmored] = 0.75,
				[armor_types.resistant] = 0.2,
				[armor_types.armored] = 0.8,
			},
			boost_curve_multiplier_finesse = damage_lerp_values.lerp_2,
		},
	},
}

local heavy_stubber_armor_mod_p2 = {
	near = {
		attack = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_0_9,
			[armor_types.resistant] = damage_lerp_values.lerp_0_8,
			[armor_types.berserker] = damage_lerp_values.lerp_1,
			[armor_types.super_armor] = damage_lerp_values.lerp_0_25,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_8,
			[armor_types.void_shield] = damage_lerp_values.lerp_0_8,
			[armor_types.player] = damage_lerp_values.lerp_1,
		},
		impact = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1_25,
			[armor_types.armored] = damage_lerp_values.lerp_0_9,
			[armor_types.resistant] = damage_lerp_values.lerp_1_25,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_0_75,
			[armor_types.super_armor] = damage_lerp_values.lerp_0_75,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
			[armor_types.void_shield] = damage_lerp_values.lerp_1,
		},
	},
	far = {
		attack = {
			[armor_types.unarmored] = damage_lerp_values.lerp_0_8,
			[armor_types.armored] = damage_lerp_values.lerp_0_75,
			[armor_types.resistant] = damage_lerp_values.lerp_0_65,
			[armor_types.berserker] = damage_lerp_values.lerp_0_8,
			[armor_types.super_armor] = damage_lerp_values.lerp_0_1,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_65,
			[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
			[armor_types.player] = damage_lerp_values.lerp_1,
		},
		impact = {
			[armor_types.unarmored] = damage_lerp_values.lerp_0_9,
			[armor_types.armored] = damage_lerp_values.lerp_0_7,
			[armor_types.resistant] = damage_lerp_values.lerp_0_8,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_0_15,
			[armor_types.super_armor] = damage_lerp_values.no_damage,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_6,
			[armor_types.void_shield] = damage_lerp_values.lerp_0_4,
		},
	},
}
local heavy_stubber_armor_mod_p2_m3 = {
	near = {
		attack = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_0_9,
			[armor_types.resistant] = damage_lerp_values.lerp_0_8,
			[armor_types.berserker] = damage_lerp_values.lerp_1,
			[armor_types.super_armor] = damage_lerp_values.lerp_0_4,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_8,
			[armor_types.void_shield] = damage_lerp_values.lerp_0_8,
			[armor_types.player] = damage_lerp_values.lerp_1,
		},
		impact = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1_25,
			[armor_types.armored] = damage_lerp_values.lerp_0_9,
			[armor_types.resistant] = damage_lerp_values.lerp_1_25,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_0_75,
			[armor_types.super_armor] = damage_lerp_values.lerp_0_75,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
			[armor_types.void_shield] = damage_lerp_values.lerp_1,
		},
	},
	far = {
		attack = {
			[armor_types.unarmored] = damage_lerp_values.lerp_0_8,
			[armor_types.armored] = damage_lerp_values.lerp_0_75,
			[armor_types.resistant] = damage_lerp_values.lerp_0_65,
			[armor_types.berserker] = damage_lerp_values.lerp_0_8,
			[armor_types.super_armor] = damage_lerp_values.lerp_0_25,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_65,
			[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
			[armor_types.player] = damage_lerp_values.lerp_1,
		},
		impact = {
			[armor_types.unarmored] = damage_lerp_values.lerp_0_9,
			[armor_types.armored] = damage_lerp_values.lerp_0_7,
			[armor_types.resistant] = damage_lerp_values.lerp_0_8,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_0_15,
			[armor_types.super_armor] = damage_lerp_values.no_damage,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_6,
			[armor_types.void_shield] = damage_lerp_values.lerp_0_4,
		},
	},
}

damage_templates.ogryn_heavystubber_damage_p2_m1 = {
	ragdoll_push_force = 1200,
	stagger_category = "ranged",
	suppression_value = 6.5,
	cleave_distribution = medium_cleave,
	ranges = {
		min = {
			7,
			13,
		},
		max = {
			35,
			70,
		},
	},
	wounds_template = WoundsTemplates.heavy_stubber,
	armor_damage_modifier_ranged = heavy_stubber_armor_mod_p2,
	critical_strike = {
		gibbing_power = GibbingPower.medium,
		gibbing_type = GibbingTypes.ballistic,
	},
	crit_mod = {
		attack = {
			[armor_types.unarmored] = {
				0,
				0.15,
			},
			[armor_types.armored] = {
				0,
				0.15,
			},
			[armor_types.resistant] = {
				0,
				0.15,
			},
			[armor_types.player] = {
				0,
				0.15,
			},
			[armor_types.berserker] = {
				0,
				0.15,
			},
			[armor_types.super_armor] = {
				0,
				0.05,
			},
			[armor_types.disgustingly_resilient] = {
				0,
				0.15,
			},
			[armor_types.void_shield] = {
				0,
				0.15,
			},
		},
		impact = crit_impact_armor_mod,
	},
	power_distribution = {
		attack = {
			170,
			430,
		},
		impact = {
			10,
			25,
		},
	},
	shield_override_stagger_strength = default_shield_override_stagger_strength,
	damage_type = damage_types.auto_bullet,
	gibbing_power = GibbingPower.heavy,
	gibbing_type = GibbingTypes.ballistic,
	on_kill_area_suppression = {
		distance = 3,
		suppression_value = 1,
	},
	gib_push_force = GibbingSettings.gib_push_force.ranged_heavy,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
}
damage_templates.ogryn_heavystubber_damage_p2_m2 = {
	ragdoll_push_force = 1200,
	stagger_category = "ranged",
	suppression_value = 6.5,
	cleave_distribution = medium_cleave,
	ranges = {
		min = {
			9,
			15,
		},
		max = {
			50,
			80,
		},
	},
	wounds_template = WoundsTemplates.heavy_stubber,
	armor_damage_modifier_ranged = heavy_stubber_armor_mod_p2,
	critical_strike = {
		gibbing_power = GibbingPower.medium,
		gibbing_type = GibbingTypes.ballistic,
	},
	crit_mod = {
		attack = {
			[armor_types.unarmored] = {
				0,
				0.15,
			},
			[armor_types.armored] = {
				0,
				0.15,
			},
			[armor_types.resistant] = {
				0,
				0.15,
			},
			[armor_types.player] = {
				0,
				0.15,
			},
			[armor_types.berserker] = {
				0,
				0.15,
			},
			[armor_types.super_armor] = {
				0,
				0.05,
			},
			[armor_types.disgustingly_resilient] = {
				0,
				0.15,
			},
			[armor_types.void_shield] = {
				0,
				0.15,
			},
		},
		impact = crit_impact_armor_mod,
	},
	targets = {
		{
			boost_curve_multiplier_finesse = 0.8,
			power_distribution = {
				attack = {
					220,
					550,
				},
				impact = {
					15,
					30,
				},
			},
		},
		{
			boost_curve_multiplier_finesse = 0.8,
			power_distribution = {
				attack = {
					220,
					550,
				},
				impact = {
					10,
					20,
				},
			},
		},
		{
			boost_curve_multiplier_finesse = 0.8,
			power_distribution = {
				attack = {
					220,
					550,
				},
				impact = {
					10,
					20,
				},
			},
		},
		{
			boost_curve_multiplier_finesse = 0.3,
			power_distribution = {
				attack = {
					110,
					250,
				},
				impact = {
					5,
					15,
				},
			},
		},
		{
			boost_curve_multiplier_finesse = 0.3,
			power_distribution = {
				attack = {
					100,
					200,
				},
				impact = {
					5,
					15,
				},
			},
		},
		default_target = {
			boost_curve_multiplier_finesse = 0.3,
			power_distribution = {
				attack = {
					100,
					200,
				},
				impact = {
					5,
					15,
				},
			},
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
	shield_override_stagger_strength = default_shield_override_stagger_strength,
	damage_type = damage_types.auto_bullet,
	gibbing_power = GibbingPower.heavy,
	gibbing_type = GibbingTypes.ballistic,
	on_kill_area_suppression = {
		distance = 3,
		suppression_value = 1,
	},
	gib_push_force = GibbingSettings.gib_push_force.ranged_heavy,
}
damage_templates.ogryn_heavystubber_damage_p2_m3 = {
	ragdoll_push_force = 1200,
	stagger_category = "ranged",
	suppression_value = 6.5,
	cleave_distribution = large_cleave,
	ranges = {
		min = {
			11,
			22,
		},
		max = {
			65,
			100,
		},
	},
	wounds_template = WoundsTemplates.heavy_stubber,
	armor_damage_modifier_ranged = heavy_stubber_armor_mod_p2_m3,
	critical_strike = {
		gibbing_power = GibbingPower.medium,
		gibbing_type = GibbingTypes.ballistic,
	},
	crit_mod = {
		attack = {
			[armor_types.unarmored] = {
				0,
				0.15,
			},
			[armor_types.armored] = {
				0,
				0.15,
			},
			[armor_types.resistant] = {
				0,
				0.15,
			},
			[armor_types.player] = {
				0,
				0.15,
			},
			[armor_types.berserker] = {
				0,
				0.15,
			},
			[armor_types.super_armor] = {
				0,
				0.05,
			},
			[armor_types.disgustingly_resilient] = {
				0,
				0.15,
			},
			[armor_types.void_shield] = {
				0,
				0.15,
			},
		},
		impact = crit_impact_armor_mod,
	},
	targets = {
		{
			boost_curve_multiplier_finesse = 0.95,
			power_distribution = {
				attack = {
					260,
					800,
				},
				impact = {
					20,
					40,
				},
			},
			finesse_boost = {
				[armor_types.unarmored] = 0.8,
				[armor_types.armored] = 0.8,
				[armor_types.resistant] = 0.8,
				[armor_types.player] = 0,
				[armor_types.berserker] = 0.8,
				[armor_types.super_armor] = 0.8,
				[armor_types.disgustingly_resilient] = 0.8,
				[armor_types.void_shield] = 0.8,
			},
		},
		{
			boost_curve_multiplier_finesse = 0.95,
			power_distribution = {
				attack = {
					260,
					800,
				},
				impact = {
					17,
					34,
				},
			},
			finesse_boost = {
				[armor_types.unarmored] = 0.8,
				[armor_types.armored] = 0.8,
				[armor_types.resistant] = 0.8,
				[armor_types.player] = 0,
				[armor_types.berserker] = 0.8,
				[armor_types.super_armor] = 0.8,
				[armor_types.disgustingly_resilient] = 0.8,
				[armor_types.void_shield] = 0.8,
			},
		},
		{
			boost_curve_multiplier_finesse = 0.95,
			power_distribution = {
				attack = {
					260,
					800,
				},
				impact = {
					15,
					30,
				},
			},
			finesse_boost = {
				[armor_types.unarmored] = 0.8,
				[armor_types.armored] = 0.8,
				[armor_types.resistant] = 0.8,
				[armor_types.player] = 0,
				[armor_types.berserker] = 0.8,
				[armor_types.super_armor] = 0.8,
				[armor_types.disgustingly_resilient] = 0.8,
				[armor_types.void_shield] = 0.8,
			},
		},
		{
			boost_curve_multiplier_finesse = 0.5,
			power_distribution = {
				attack = {
					150,
					500,
				},
				impact = {
					10,
					20,
				},
			},
		},
		{
			boost_curve_multiplier_finesse = 0.5,
			power_distribution = {
				attack = {
					110,
					400,
				},
				impact = {
					5,
					15,
				},
			},
		},
		default_target = {
			boost_curve_multiplier_finesse = 0.5,
			power_distribution = {
				attack = {
					100,
					400,
				},
				impact = {
					5,
					15,
				},
			},
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
	shield_override_stagger_strength = default_shield_override_stagger_strength,
	damage_type = damage_types.auto_bullet,
	gibbing_power = GibbingPower.heavy,
	gibbing_type = GibbingTypes.ballistic,
	on_kill_area_suppression = {
		distance = 3,
		suppression_value = 1,
	},
	gib_push_force = GibbingSettings.gib_push_force.ranged_heavy,
}

return {
	base_templates = damage_templates,
	overrides = overrides,
}
