-- chunkname: @scripts/settings/equipment/weapon_templates/force_staffs/settings_templates/force_staff_damage_profile_templates.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local DamageProfileSettings = require("scripts/settings/damage/damage_profile_settings")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local GibbingSettings = require("scripts/settings/gibbing/gibbing_settings")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local WoundsTemplates = require("scripts/settings/damage/wounds_templates")
local armor_types = ArmorSettings.types
local crit_armor_mod = DamageProfileSettings.crit_armor_mod
local crit_impact_armor_mod = DamageProfileSettings.crit_impact_armor_mod
local damage_lerp_values = DamageProfileSettings.damage_lerp_values
local damage_types = DamageSettings.damage_types
local gibbing_power = GibbingSettings.gibbing_power
local gibbing_types = GibbingSettings.gibbing_types
local melee_attack_strengths = AttackSettings.melee_attack_strength
local damage_templates = {}
local overrides = {}

table.make_unique(damage_templates)
table.make_unique(overrides)

damage_templates.force_staff_ball = {
	force_staff_primary = true,
	force_weapon_damage = true,
	ignore_stagger_reduction = true,
	ragdoll_push_force = 600,
	stagger_category = "melee",
	stagger_override = "medium",
	suppression_attack_delay = 0.6,
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_1,
			[armor_types.resistant] = damage_lerp_values.lerp_0_6,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_1,
			[armor_types.super_armor] = damage_lerp_values.lerp_0_1,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
			[armor_types.void_shield] = damage_lerp_values.lerp_0_6,
		},
		impact = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_1,
			[armor_types.resistant] = damage_lerp_values.lerp_0_6,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_0_5,
			[armor_types.super_armor] = damage_lerp_values.no_damage,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_8,
			[armor_types.void_shield] = damage_lerp_values.lerp_0_8,
		},
	},
	cleave_distribution = {
		attack = 0.25,
		impact = 0.25,
	},
	crit_mod = {
		attack = crit_armor_mod,
		impact = crit_impact_armor_mod,
	},
	power_distribution = {
		attack = {
			60,
			180,
		},
		impact = {
			4,
			8,
		},
	},
	gibbing_power = gibbing_power.light,
	gibbing_type = gibbing_types.warp,
	gib_push_force = GibbingSettings.gib_push_force.force_assault,
	wounds_template = WoundsTemplates.psyker_ball,
	suppression_value = {
		10,
		15,
	},
	on_kill_area_suppression = {
		distance = 3,
		suppression_value = 5,
	},
	targets = {
		default_target = {
			boost_curve_multiplier_finesse = 1.5,
			boost_curve = PowerLevelSettings.boost_curves.default,
			finesse_boost = {
				[armor_types.unarmored] = 0.75,
			},
		},
	},
}
damage_templates.default_force_staff_bfg = {
	force_weapon_damage = true,
	ignore_shield = true,
	ragdoll_only = true,
	ragdoll_push_force = 1000,
	stagger_category = "explosion",
	weakspot_stagger_resistance_modifier = 0.2,
	cleave_distribution = {
		attack = 10,
		impact = 12,
	},
	gibbing_power = gibbing_power.heavy,
	gibbing_type = gibbing_types.warp,
	gib_push_force = GibbingSettings.gib_push_force.force_bfg,
	ignore_hitzone_multipliers_breed_tags = {
		"horde",
		"roamer",
		"elite",
		"special",
	},
	targets = {
		default_target = {
			boost_curve_multiplier_finesse = 1.25,
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_1,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_1,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_75,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_2,
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_2,
					[armor_types.armored] = damage_lerp_values.lerp_1,
					[armor_types.resistant] = damage_lerp_values.lerp_0_1,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_1,
					[armor_types.super_armor] = damage_lerp_values.lerp_1,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_2,
					[armor_types.void_shield] = damage_lerp_values.lerp_2_35,
				},
			},
			power_distribution = {
				attack = {
					375,
					750,
				},
				impact = {
					30,
					60,
				},
			},
			boost_curve = PowerLevelSettings.boost_curves.default,
			finesse_boost = {
				[armor_types.unarmored] = 0.5,
				[armor_types.armored] = 0.5,
				[armor_types.resistant] = 0.5,
				[armor_types.player] = 0.5,
				[armor_types.berserker] = 0.5,
				[armor_types.super_armor] = 0.5,
				[armor_types.disgustingly_resilient] = 0.5,
				[armor_types.void_shield] = 0.5,
			},
		},
	},
	on_kill_area_suppression = {
		distance = 5,
		suppression_value = 8,
	},
	charge_level_scaler = {
		{
			modifier = 1,
			t = 1,
		},
		start_modifier = 0.1,
	},
}
damage_templates.default_force_staff_demolition = {
	force_weapon_damage = true,
	ignore_stagger_reduction = true,
	ragdoll_push_force = 200,
	stagger_category = "melee",
	suppression_value = 10,
	cleave_distribution = {
		attack = 0.15,
		impact = 0.15,
	},
	ranges = {
		max = 50,
		min = 40,
	},
	armor_damage_modifier_ranged = {
		near = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_0_75,
				[armor_types.resistant] = damage_lerp_values.lerp_1,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_1,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_25,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_75,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_0_5,
				[armor_types.resistant] = damage_lerp_values.lerp_0_5,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_1,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_25,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
				[armor_types.void_shield] = damage_lerp_values.lerp_1,
			},
		},
		far = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_0_75,
				[armor_types.resistant] = damage_lerp_values.lerp_1,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_1,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_25,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_75,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_0_5,
				[armor_types.resistant] = damage_lerp_values.lerp_0_5,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_1,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_25,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
				[armor_types.void_shield] = damage_lerp_values.lerp_1,
			},
		},
	},
	power_distribution = {
		attack = {
			15,
			40,
		},
		impact = {
			8,
			24,
		},
	},
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
	gibbing_type = gibbing_types.warp,
	gibbing_power = gibbing_power.medium,
	gib_push_force = GibbingSettings.gib_push_force.force_assault,
}
damage_templates.close_force_staff_p4_demolition = {
	force_weapon_damage = true,
	ignore_shield = true,
	ignore_stagger_reduction = true,
	ragdoll_push_force = 600,
	stagger_category = "melee",
	suppression_value = 10,
	cleave_distribution = {
		attack = 0.15,
		impact = 0.15,
	},
	ranges = {
		max = 3,
		min = 0.25,
	},
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_1,
			[armor_types.resistant] = damage_lerp_values.lerp_1,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_1,
			[armor_types.super_armor] = damage_lerp_values.lerp_1,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_75,
			[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
		},
		impact = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_1,
			[armor_types.resistant] = damage_lerp_values.lerp_1,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_1,
			[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
			[armor_types.void_shield] = damage_lerp_values.lerp_1,
		},
	},
	power_distribution = {
		attack = {
			50,
			70,
		},
		impact = {
			40,
			80,
		},
	},
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
	gibbing_type = gibbing_types.warp,
	gibbing_power = gibbing_power.heavy,
	gib_push_force = GibbingSettings.gib_push_force.force_assault,
}
damage_templates.force_staff_p4_demolition = {
	force_weapon_damage = true,
	ignore_stagger_reduction = true,
	ragdoll_push_force = 200,
	stagger_category = "melee",
	suppression_value = 10,
	cleave_distribution = {
		attack = 0.15,
		impact = 0.15,
	},
	ranges = {
		max = 50,
		min = 40,
	},
	armor_damage_modifier_ranged = {
		near = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_0_75,
				[armor_types.resistant] = damage_lerp_values.lerp_1,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_1,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_25,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_75,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_0_5,
				[armor_types.resistant] = damage_lerp_values.lerp_0_5,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_1,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_25,
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
				[armor_types.unarmored] = damage_lerp_values.lerp_0_5,
				[armor_types.armored] = damage_lerp_values.lerp_0_5,
				[armor_types.resistant] = damage_lerp_values.lerp_0_5,
				[armor_types.player] = damage_lerp_values.lerp_0_5,
				[armor_types.berserker] = damage_lerp_values.lerp_0_5,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_5,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_1,
			},
		},
	},
	power_distribution = {
		attack = {
			25,
			50,
		},
		impact = {
			10,
			20,
		},
	},
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
	gibbing_type = gibbing_types.warp,
	gibbing_power = gibbing_power.heavy,
	gib_push_force = GibbingSettings.gib_push_force.force_demolition,
}
damage_templates.close_force_staff_demolition = {
	force_weapon_damage = true,
	ignore_shield = true,
	ignore_stagger_reduction = true,
	ragdoll_push_force = 850,
	stagger_category = "melee",
	suppression_value = 10,
	cleave_distribution = {
		attack = 0.15,
		impact = 0.15,
	},
	ranges = {
		max = 3,
		min = 0.25,
	},
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_0_8,
			[armor_types.resistant] = damage_lerp_values.lerp_1,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_1,
			[armor_types.super_armor] = damage_lerp_values.lerp_0_8,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_75,
			[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
		},
		impact = {
			[armor_types.unarmored] = damage_lerp_values.lerp_2,
			[armor_types.armored] = damage_lerp_values.lerp_2,
			[armor_types.resistant] = damage_lerp_values.lerp_2,
			[armor_types.player] = damage_lerp_values.lerp_2,
			[armor_types.berserker] = damage_lerp_values.lerp_2,
			[armor_types.super_armor] = damage_lerp_values.lerp_2,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_2,
			[armor_types.void_shield] = damage_lerp_values.lerp_2,
		},
	},
	power_distribution = {
		attack = {
			400,
			800,
		},
		impact = {
			100,
			100,
		},
	},
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
	gibbing_type = gibbing_types.warp,
	gibbing_power = gibbing_power.heavy,
	gib_push_force = GibbingSettings.gib_push_force.force_demolition,
}
damage_templates.force_staff_bash = {
	force_staff_melee = true,
	ignore_stagger_reduction = true,
	ragdoll_push_force = 100,
	stagger_category = "melee",
	weakspot_stagger_resistance_modifier = 0.2,
	damage_type = damage_types.blunt_light,
	melee_attack_strength = melee_attack_strengths.light,
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = 0.8,
			[armor_types.armored] = 0.3,
			[armor_types.resistant] = 0.5,
			[armor_types.player] = 0,
			[armor_types.berserker] = 0.6,
			[armor_types.super_armor] = 0,
			[armor_types.disgustingly_resilient] = 1,
			[armor_types.void_shield] = 0.1,
		},
		impact = {
			[armor_types.unarmored] = 1.25,
			[armor_types.armored] = 1,
			[armor_types.resistant] = 0.1,
			[armor_types.player] = 0,
			[armor_types.berserker] = 0.5,
			[armor_types.super_armor] = 0.25,
			[armor_types.disgustingly_resilient] = 1,
			[armor_types.void_shield] = 0,
		},
	},
	targets = {
		default_target = {
			power_distribution = {
				attack = {
					25,
					75,
				},
				impact = {
					1,
					3,
				},
			},
		},
	},
	cleave_distribution = {
		attack = 2,
		impact = 2,
	},
}
overrides.heavy_force_staff_bash = {
	parent_template_name = "force_staff_bash",
	overrides = {
		{
			"cleave_distribution",
			"attack",
			14,
		},
		{
			"cleave_distribution",
			"impact",
			14,
		},
		{
			"melee_attack_strength",
			melee_attack_strengths.heavy,
		},
	},
}
overrides.force_staff_bash_stab_heavy = {
	parent_template_name = "force_staff_bash",
	overrides = {
		{
			"cleave_distribution",
			"attack",
			14,
		},
		{
			"cleave_distribution",
			"impact",
			8,
		},
		{
			"weakspot_stagger_resistance_modifier",
			0.01,
		},
		{
			"melee_attack_strength",
			melee_attack_strengths.heavy,
		},
	},
}

local assault_warpfire_armor_mod = {
	near = {
		attack = {
			[armor_types.unarmored] = 2,
			[armor_types.armored] = 1.75,
			[armor_types.resistant] = 2,
			[armor_types.player] = 1,
			[armor_types.berserker] = 2.5,
			[armor_types.super_armor] = 0.25,
			[armor_types.disgustingly_resilient] = 1.5,
			[armor_types.void_shield] = 1,
		},
		impact = {
			[armor_types.unarmored] = 1,
			[armor_types.armored] = 0.75,
			[armor_types.resistant] = 0.75,
			[armor_types.player] = 1,
			[armor_types.berserker] = 1.5,
			[armor_types.super_armor] = 0.2,
			[armor_types.disgustingly_resilient] = 1,
			[armor_types.void_shield] = 1,
		},
	},
	far = {
		attack = {
			[armor_types.unarmored] = 1,
			[armor_types.armored] = 0.75,
			[armor_types.resistant] = 1,
			[armor_types.player] = 1,
			[armor_types.berserker] = 1,
			[armor_types.super_armor] = 0,
			[armor_types.disgustingly_resilient] = 0.7,
			[armor_types.void_shield] = 1,
		},
		impact = {
			[armor_types.unarmored] = 0.75,
			[armor_types.armored] = 0.25,
			[armor_types.resistant] = 0.3,
			[armor_types.player] = 0,
			[armor_types.berserker] = 1.25,
			[armor_types.super_armor] = 0.1,
			[armor_types.disgustingly_resilient] = 0.75,
			[armor_types.void_shield] = 0.5,
		},
	},
}

damage_templates.default_warpfire_assault = {
	accumulative_stagger_strength_multiplier = 0.5,
	duration_scale_bonus = 0.5,
	force_weapon_damage = true,
	ragdoll_push_force = 10,
	stagger_category = "flamer",
	suppression_value = 10,
	cleave_distribution = {
		attack = 0.1,
		impact = 0.1,
	},
	ranges = {
		max = 15,
		min = 5,
	},
	armor_damage_modifier_ranged = assault_warpfire_armor_mod,
	gibbing_type = gibbing_types.warp,
	targets = {
		{
			power_distribution = {
				attack = {
					12,
					24,
				},
				impact = {
					5,
					9,
				},
			},
		},
		{
			power_distribution = {
				attack = {
					20,
					40,
				},
				impact = {
					5,
					10,
				},
			},
		},
		{
			power_distribution = {
				attack = {
					30,
					60,
				},
				impact = {
					7,
					12,
				},
			},
		},
		{
			power_distribution = {
				attack = {
					40,
					80,
				},
				impact = {
					8,
					15,
				},
			},
		},
		{
			power_distribution = {
				attack = {
					45,
					90,
				},
				impact = {
					10,
					15,
				},
			},
		},
		{
			power_distribution = {
				attack = {
					50,
					100,
				},
				impact = {
					10,
					15,
				},
			},
		},
		default_target = {
			power_distribution = {
				attack = {
					40,
					60,
				},
				impact = {
					10,
					15,
				},
			},
		},
	},
}
damage_templates.default_warpfire_assault_burst = {
	duration_scale_bonus = 0.1,
	force_staff_primary = true,
	force_weapon_damage = true,
	ignore_stagger_reduction = true,
	ragdoll_push_force = 12,
	stagger_category = "flamer",
	suppression_value = 5,
	cleave_distribution = {
		attack = 0.1,
		impact = 0.1,
	},
	ranges = {
		max = 15,
		min = 5,
	},
	armor_damage_modifier_ranged = assault_warpfire_armor_mod,
	gibbing_type = gibbing_types.warp,
	power_distribution = {
		attack = {
			15,
			30,
		},
		impact = {
			10,
			20,
		},
	},
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default,
			power_distribution = {
				attack = {
					20,
					40,
				},
				impact = {
					15,
					30,
				},
			},
		},
	},
}
damage_templates.default_chain_lighting_attack = {
	attack_direction_override = "push",
	chain_lightning_staff = true,
	ignore_hitzone_multiplier = true,
	ragdoll_push_force = 10,
	random_gib_hitzone = true,
	stagger_category = "sticky",
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_1,
			[armor_types.resistant] = damage_lerp_values.lerp_1,
			[armor_types.player] = damage_lerp_values.lerp_0_75,
			[armor_types.berserker] = damage_lerp_values.lerp_1,
			[armor_types.super_armor] = damage_lerp_values.lerp_0_9,
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
	cleave_distribution = {
		attack = 8,
		impact = 20,
	},
	power_distribution = {
		impact = 60,
		attack = {
			1,
			2,
		},
	},
	random_damage = {
		{
			max = 1.1,
			min = 0.9,
		},
		{
			max = 1,
			min = 0.5,
		},
		{
			max = 0.5,
			min = 0.25,
		},
		{
			max = 0.5,
			min = 0.25,
		},
	},
	charge_level_scaler = {
		{
			modifier = 1,
			t = 1,
		},
		start_modifier = 0,
	},
	crit_mod = {
		attack = {
			[armor_types.unarmored] = {
				0,
				0.3,
			},
			[armor_types.armored] = {
				0,
				0,
			},
			[armor_types.resistant] = {
				0,
				0.3,
			},
			[armor_types.player] = {
				0,
				0.3,
			},
			[armor_types.berserker] = {
				0,
				0.3,
			},
			[armor_types.super_armor] = {
				0,
				0,
			},
			[armor_types.disgustingly_resilient] = {
				0,
				0.3,
			},
			[armor_types.void_shield] = {
				0,
				0.3,
			},
		},
		impact = crit_impact_armor_mod,
	},
	targets = {
		{
			power_distribution = {
				attack = {
					400,
					800,
				},
				impact = {
					40,
					60,
				},
			},
		},
		{
			power_distribution = {
				attack = {
					100,
					200,
				},
				impact = {
					20,
					40,
				},
			},
		},
		{
			power_distribution = {
				attack = {
					50,
					100,
				},
				impact = {
					15,
					30,
				},
			},
		},
		{
			power_distribution = {
				attack = {
					35,
					70,
				},
				impact = {
					10,
					20,
				},
			},
		},
		{
			power_distribution = {
				attack = {
					30,
					60,
				},
				impact = {
					5,
					10,
				},
			},
		},
		{
			power_distribution = {
				attack = {
					20,
					40,
				},
				impact = {
					3,
					6,
				},
			},
		},
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
		boost_curve_multiplier_finesse = damage_lerp_values.lerp_1,
	},
	damage_type = damage_types.electrocution,
	gibbing_power = gibbing_power.infinite,
	gibbing_type = gibbing_types.warp_lightning,
	gib_push_force = GibbingSettings.gib_push_force.ranged_heavy,
}
damage_templates.default_chain_lighting_interval = {
	chain_lightning_staff = true,
	ignore_hitzone_multiplier = true,
	stagger_category = "sticky",
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = damage_lerp_values.lerp_0_75,
			[armor_types.armored] = damage_lerp_values.lerp_0_75,
			[armor_types.resistant] = damage_lerp_values.lerp_1,
			[armor_types.player] = damage_lerp_values.lerp_0_75,
			[armor_types.berserker] = damage_lerp_values.lerp_1,
			[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_75,
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
		impact = 250,
	},
	damage_type = damage_types.electrocution,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
		boost_curve_multiplier_finesse = damage_lerp_values.lerp_1,
	},
}

return {
	base_templates = damage_templates,
	overrides = overrides,
}
