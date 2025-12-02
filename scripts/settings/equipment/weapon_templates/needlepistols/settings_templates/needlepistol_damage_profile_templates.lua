-- chunkname: @scripts/settings/equipment/weapon_templates/needlepistols/settings_templates/needlepistol_damage_profile_templates.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local DamageProfileSettings = require("scripts/settings/damage/damage_profile_settings")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local GibbingSettings = require("scripts/settings/gibbing/gibbing_settings")
local HerdingTemplates = require("scripts/settings/damage/herding_templates")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local WoundsTemplates = require("scripts/settings/damage/wounds_templates")
local armor_types = ArmorSettings.types
local damage_types = DamageSettings.damage_types
local gibbing_power = GibbingSettings.gibbing_power
local gibbing_types = GibbingSettings.gibbing_types
local damage_templates = {}
local overrides = {}

table.make_unique(damage_templates)
table.make_unique(overrides)

local damage_lerp_values = DamageProfileSettings.damage_lerp_values
local single_cleave = DamageProfileSettings.single_cleave
local single_plus_cleave = DamageProfileSettings.single_plus_cleave
local double_cleave = DamageProfileSettings.double_cleave
local no_cleave = DamageProfileSettings.no_cleave
local pistol_crit_mod = {
	attack = {
		[armor_types.unarmored] = 0.3,
		[armor_types.armored] = 0.3,
		[armor_types.resistant] = 0.3,
		[armor_types.player] = 0,
		[armor_types.berserker] = 0.3,
		[armor_types.super_armor] = 0.3,
		[armor_types.disgustingly_resilient] = 0.3,
		[armor_types.void_shield] = 0,
	},
	impact = {
		[armor_types.unarmored] = 0.35,
		[armor_types.armored] = 0.35,
		[armor_types.resistant] = 0.35,
		[armor_types.player] = 0.35,
		[armor_types.berserker] = 0.35,
		[armor_types.super_armor] = 0.35,
		[armor_types.disgustingly_resilient] = 0.35,
		[armor_types.void_shield] = 0.35,
	},
}

damage_templates.needlepistol_dart_parent = {
	stagger_category = "ranged",
	cleave_distribution = single_cleave,
	ranges = {
		max = 25,
		min = 15,
	},
	herding_template = HerdingTemplates.shot,
	wounds_template = WoundsTemplates.needle,
	armor_damage_modifier_ranged = {
		near = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_0_5,
				[armor_types.resistant] = damage_lerp_values.lerp_0_65,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_0_65,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_01,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_65,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_65,
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_0_6,
				[armor_types.armored] = damage_lerp_values.lerp_0_5,
				[armor_types.resistant] = damage_lerp_values.lerp_0_4,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_0_4,
				[armor_types.super_armor] = damage_lerp_values.no_damage,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_3,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_01,
			},
		},
		far = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_0_5,
				[armor_types.armored] = damage_lerp_values.lerp_0_25,
				[armor_types.resistant] = damage_lerp_values.lerp_0_4,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_0_4,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_01,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_5,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_0_5,
				[armor_types.armored] = damage_lerp_values.lerp_0_4,
				[armor_types.resistant] = damage_lerp_values.lerp_0_3,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_0_5,
				[armor_types.super_armor] = damage_lerp_values.no_damage,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_25,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_01,
			},
		},
	},
	critical_strike = {
		gibbing_power = gibbing_power.always,
		gibbing_type = gibbing_types.laser,
	},
	power_distribution = {
		attack = {
			20,
			40,
		},
		impact = {
			5,
			7,
		},
	},
	damage_type = damage_types.laser,
	gibbing_power = gibbing_power.always,
	gibbing_type = gibbing_types.laser,
	suppression_value = {
		0.01,
		0.02,
	},
	on_kill_area_suppression = {
		suppression_value = 0.01,
		distance = {
			0.1,
			0.5,
		},
	},
	crit_mod = pistol_crit_mod,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default,
			finesse_boost = {
				[armor_types.unarmored] = 0.75,
				[armor_types.armored] = 0.75,
			},
		},
	},
	ragdoll_push_force = {
		20,
		30,
	},
}
damage_templates.default_needlepistol_dart = table.clone(damage_templates.needlepistol_dart_parent)
damage_templates.alternate_needlepistol_dart = table.clone(damage_templates.needlepistol_dart_parent)
damage_templates.flamer_needlepistol_dart = table.clone(damage_templates.needlepistol_dart_parent)
damage_templates.stun_needlepistol_dart = table.clone(damage_templates.needlepistol_dart_parent)
damage_templates.needlepistol_explosion_parent = {
	ragdoll_push_force = 1,
	stagger_category = "flamer",
	suppression_value = 0.01,
	ignore_hitzone_multipliers_breed_tags = {
		"horde",
		"roamer",
		"elite",
		"special",
	},
	cleave_distribution = {
		attack = 0.1,
		impact = 0.1,
	},
	ranges = {
		max = 20,
		min = 10,
	},
	armor_damage_modifier_ranged = {
		near = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_1,
				[armor_types.resistant] = damage_lerp_values.lerp_1,
				[armor_types.player] = damage_lerp_values.no_damage,
				[armor_types.berserker] = damage_lerp_values.lerp_1,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_8,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
				[armor_types.void_shield] = damage_lerp_values.lerp_1,
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_1,
				[armor_types.resistant] = damage_lerp_values.lerp_1,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_1,
				[armor_types.super_armor] = damage_lerp_values.no_damage,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
				[armor_types.void_shield] = damage_lerp_values.lerp_1,
			},
		},
		far = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_0_25,
				[armor_types.armored] = damage_lerp_values.lerp_0_1,
				[armor_types.resistant] = damage_lerp_values.lerp_0_25,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_0_25,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_1,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_25,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_25,
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_0_25,
				[armor_types.armored] = damage_lerp_values.no_damage,
				[armor_types.resistant] = damage_lerp_values.lerp_0_25,
				[armor_types.player] = damage_lerp_values.lerp_0_25,
				[armor_types.berserker] = damage_lerp_values.lerp_0_25,
				[armor_types.super_armor] = damage_lerp_values.no_damage,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_25,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_25,
			},
		},
	},
	power_distribution = {
		attack = 0.01,
		impact = 0,
	},
	damage_type = damage_types.boltshell,
	gibbing_power = gibbing_power.heavy,
	gibbing_type = gibbing_types.boltshell,
	wounds_template = WoundsTemplates.bolter,
	on_kill_area_suppression = {
		distance = 4,
		suppression_value = 0.01,
	},
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default,
			finesse_boost = {
				[armor_types.unarmored] = 0.75,
			},
		},
	},
}
overrides.needlepistol_explosion_1 = {
	parent_template_name = "needlepistol_explosion_parent",
	overrides = {
		{
			"buff_on_damage",
			"neurotoxin_interval_buff3",
		},
	},
}

return {
	base_templates = damage_templates,
	overrides = overrides,
}
