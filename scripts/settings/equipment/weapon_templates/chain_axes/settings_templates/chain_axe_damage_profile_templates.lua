-- chunkname: @scripts/settings/equipment/weapon_templates/chain_axes/settings_templates/chain_axe_damage_profile_templates.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local DamageProfileSettings = require("scripts/settings/damage/damage_profile_settings")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local GibbingSettings = require("scripts/settings/gibbing/gibbing_settings")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local WoundsTemplates = require("scripts/settings/damage/wounds_templates")
local armor_types = ArmorSettings.types
local damage_lerp_values = DamageProfileSettings.damage_lerp_values
local damage_types = DamageSettings.damage_types
local gibbing_power = GibbingSettings.gibbing_power
local gibbing_types = GibbingSettings.gibbing_types
local melee_attack_strengths = AttackSettings.melee_attack_strength
local double_cleave = DamageProfileSettings.double_cleave
local large_cleave = DamageProfileSettings.large_cleave
local medium_cleave = DamageProfileSettings.medium_cleave
local no_cleave = DamageProfileSettings.no_cleave
local damage_templates = {}
local overrides = {}

table.make_unique(damage_templates)
table.make_unique(overrides)

local chainsword_sawing = {
	attack = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1,
		[armor_types.armored] = damage_lerp_values.lerp_1,
		[armor_types.resistant] = damage_lerp_values.lerp_1_5,
		[armor_types.player] = damage_lerp_values.lerp_1,
		[armor_types.berserker] = damage_lerp_values.lerp_1,
		[armor_types.super_armor] = damage_lerp_values.lerp_0_75,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
		[armor_types.void_shield] = damage_lerp_values.lerp_1,
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
}
local chainsword_sawing_tick = {
	attack = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1,
		[armor_types.armored] = damage_lerp_values.lerp_0_3,
		[armor_types.resistant] = damage_lerp_values.lerp_0_9,
		[armor_types.player] = damage_lerp_values.lerp_1,
		[armor_types.berserker] = damage_lerp_values.lerp_1,
		[armor_types.super_armor] = damage_lerp_values.lerp_0_3,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
		[armor_types.void_shield] = damage_lerp_values.lerp_1,
	},
	impact = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1,
		[armor_types.armored] = damage_lerp_values.lerp_1,
		[armor_types.resistant] = damage_lerp_values.lerp_1,
		[armor_types.player] = damage_lerp_values.lerp_1,
		[armor_types.berserker] = damage_lerp_values.lerp_0_5,
		[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
		[armor_types.void_shield] = damage_lerp_values.lerp_1,
	},
}
local chainsword_sawing_rip = {
	attack = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1,
		[armor_types.armored] = damage_lerp_values.lerp_1_1,
		[armor_types.resistant] = damage_lerp_values.lerp_1_25,
		[armor_types.player] = damage_lerp_values.lerp_1,
		[armor_types.berserker] = damage_lerp_values.lerp_1,
		[armor_types.super_armor] = damage_lerp_values.lerp_1_1,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
		[armor_types.void_shield] = damage_lerp_values.lerp_1,
	},
	impact = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1,
		[armor_types.armored] = damage_lerp_values.lerp_1,
		[armor_types.resistant] = damage_lerp_values.lerp_1,
		[armor_types.player] = damage_lerp_values.lerp_1,
		[armor_types.berserker] = damage_lerp_values.lerp_0_5,
		[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
		[armor_types.void_shield] = damage_lerp_values.lerp_1,
	},
}
local chain_sword_crit_mod = {
	attack = {
		[armor_types.unarmored] = 0,
		[armor_types.armored] = 0.3,
		[armor_types.resistant] = 0,
		[armor_types.player] = 0,
		[armor_types.berserker] = 0,
		[armor_types.super_armor] = 0.2,
		[armor_types.disgustingly_resilient] = 0,
		[armor_types.void_shield] = 0,
	},
	impact = {
		[armor_types.unarmored] = 0,
		[armor_types.armored] = 0,
		[armor_types.resistant] = 0,
		[armor_types.player] = 0,
		[armor_types.berserker] = 0,
		[armor_types.super_armor] = 0.5,
		[armor_types.disgustingly_resilient] = 0,
		[armor_types.void_shield] = 0,
	},
}
local chain_axe_light_mod = {
	attack = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1_1,
		[armor_types.armored] = damage_lerp_values.lerp_0_75,
		[armor_types.resistant] = damage_lerp_values.lerp_1,
		[armor_types.player] = damage_lerp_values.lerp_1,
		[armor_types.berserker] = damage_lerp_values.lerp_1_25,
		[armor_types.super_armor] = damage_lerp_values.no_damage,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1_25,
		[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
	},
	impact = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1,
		[armor_types.armored] = damage_lerp_values.lerp_1,
		[armor_types.resistant] = damage_lerp_values.lerp_0_25,
		[armor_types.player] = damage_lerp_values.lerp_1,
		[armor_types.berserker] = damage_lerp_values.lerp_0_25,
		[armor_types.super_armor] = damage_lerp_values.no_damage,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
		[armor_types.void_shield] = damage_lerp_values.lerp_1,
	},
}
local chain_axe_heavy_mod = {
	attack = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1_1,
		[armor_types.armored] = damage_lerp_values.lerp_0_6,
		[armor_types.resistant] = damage_lerp_values.lerp_1,
		[armor_types.player] = damage_lerp_values.lerp_1,
		[armor_types.berserker] = damage_lerp_values.lerp_1_1,
		[armor_types.super_armor] = damage_lerp_values.no_damage,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1_25,
		[armor_types.void_shield] = damage_lerp_values.lerp_1,
	},
	impact = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1,
		[armor_types.armored] = damage_lerp_values.lerp_1,
		[armor_types.resistant] = damage_lerp_values.lerp_1,
		[armor_types.player] = damage_lerp_values.lerp_1,
		[armor_types.berserker] = damage_lerp_values.lerp_0_5,
		[armor_types.super_armor] = damage_lerp_values.no_damage,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
		[armor_types.void_shield] = damage_lerp_values.lerp_1,
	},
}

damage_templates.default_light_chainaxe = {
	finesse_ability_damage_multiplier = 1.5,
	ragdoll_only = true,
	ragdoll_push_force = 150,
	stagger_category = "melee",
	sticky_attack = false,
	crit_mod = chain_sword_crit_mod,
	cleave_distribution = no_cleave,
	damage_type = damage_types.sawing,
	gibbing_power = gibbing_power.always,
	gibbing_type = gibbing_types.sawing,
	melee_attack_strength = melee_attack_strengths.light,
	gib_push_force = GibbingSettings.gib_push_force.sawing_heavy,
	wounds_template = WoundsTemplates.chainaxe,
	armor_damage_modifier = chain_axe_light_mod,
	targets = {
		{
			armor_damage_modifier = {
				attack = {
					[armor_types.armored] = damage_lerp_values.lerp_1_5,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_75,
					[armor_types.resistant] = damage_lerp_values.lerp_1_5,
				},
				impact = {
					[armor_types.super_armor] = {
						0.25,
						0.375,
					},
				},
			},
			power_distribution = {
				attack = {
					80,
					140,
				},
				impact = {
					4,
					8,
				},
			},
			boost_curve_multiplier_finesse = {
				0.4,
				1,
			},
			power_level_multiplier = {
				0.6,
				1.4,
			},
		},
		{
			power_distribution = {
				attack = {
					20,
					30,
				},
				impact = {
					3,
					6,
				},
			},
		},
		default_target = {
			power_distribution = {
				attack = damage_lerp_values.no_damage,
				impact = {
					1,
					3,
				},
			},
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
}
overrides.light_chainaxe_active = {
	parent_template_name = "default_light_chainaxe",
	overrides = {
		{
			"stagger_category",
			"melee",
		},
		{
			"stagger_override",
			"light",
		},
		{
			"shield_stagger_category",
			"melee",
		},
		{
			"damage_type",
			damage_types.sawing_stuck,
		},
		{
			"ignore_instant_ragdoll_chance",
			true,
		},
		{
			"ignore_stagger_reduction",
			true,
		},
		{
			"ignore_shield",
			true,
		},
		{
			"sticky_attack",
			true,
		},
		{
			"cleave_distribution",
			no_cleave,
		},
		{
			"weapon_special",
			true,
		},
		{
			"wounds_template",
			WoundsTemplates.chainaxe_sawing,
		},
	},
}
overrides.light_chainaxe_active_sticky = {
	parent_template_name = "default_light_chainaxe",
	overrides = {
		{
			"stagger_category",
			"sticky",
		},
		{
			"stagger_override",
			"sticky",
		},
		{
			"shield_stagger_category",
			"sticky",
		},
		{
			"damage_type",
			damage_types.sawing_stuck,
		},
		{
			"ignore_instant_ragdoll_chance",
			true,
		},
		{
			"ignore_stagger_reduction",
			true,
		},
		{
			"ignore_shield",
			true,
		},
		{
			"gibbing_power",
			gibbing_power.medium,
		},
		{
			"sticky_attack",
			true,
		},
		{
			"gibbing_type",
			gibbing_types.sawing,
		},
		{
			"wounds_template",
			WoundsTemplates.chainaxe_sawing,
		},
		{
			"melee_attack_strength",
			melee_attack_strengths.light,
		},
		{
			"targets",
			1,
			"power_distribution",
			"attack",
			{
				160,
				320,
			},
		},
		{
			"targets",
			1,
			"power_distribution",
			"impact",
			{
				10,
				10,
			},
		},
		{
			"targets",
			1,
			"armor_damage_modifier",
			table.clone(chainsword_sawing_tick),
		},
		{
			"weapon_special",
			true,
		},
		{
			"skip_on_hit_proc",
			true,
		},
	},
}
overrides.light_chainaxe_active_sticky_last = {
	parent_template_name = "default_light_chainaxe",
	overrides = {
		{
			"stagger_category",
			"sticky",
		},
		{
			"shield_stagger_category",
			"sticky",
		},
		{
			"damage_type",
			damage_types.sawing_stuck,
		},
		{
			"ignore_stagger_reduction",
			true,
		},
		{
			"ignore_shield",
			true,
		},
		{
			"ragdoll_only",
			true,
		},
		{
			"gibbing_power",
			gibbing_power.medium,
		},
		{
			"sticky_attack",
			true,
		},
		{
			"gibbing_type",
			gibbing_types.sawing,
		},
		{
			"wounds_template",
			WoundsTemplates.chainaxe_sawing,
		},
		{
			"melee_attack_strength",
			melee_attack_strengths.light,
		},
		{
			"targets",
			1,
			"power_distribution",
			"attack",
			{
				300,
				600,
			},
		},
		{
			"targets",
			1,
			"power_distribution",
			"impact",
			{
				0,
				0,
			},
		},
		{
			"targets",
			1,
			"armor_damage_modifier",
			table.clone(chainsword_sawing_rip),
		},
		{
			"weapon_special",
			true,
		},
		{
			"skip_on_hit_proc",
			true,
		},
	},
}
overrides.light_chainaxe_sticky = {
	parent_template_name = "default_light_chainaxe",
	overrides = {
		{
			"stagger_category",
			"sticky",
		},
		{
			"shield_stagger_category",
			"melee",
		},
		{
			"damage_type",
			damage_types.sawing_stuck,
		},
		{
			"ignore_instant_ragdoll_chance",
			true,
		},
		{
			"ignore_shield",
			true,
		},
		{
			"gibbing_power",
			gibbing_power.medium,
		},
		{
			"sticky_attack",
			true,
		},
		{
			"gibbing_type",
			gibbing_types.sawing,
		},
		{
			"wounds_template",
			WoundsTemplates.chainaxe_sawing,
		},
		{
			"melee_attack_strength",
			melee_attack_strengths.light,
		},
		{
			"targets",
			1,
			"power_distribution",
			"attack",
			{
				30,
				60,
			},
		},
		{
			"targets",
			1,
			"power_distribution",
			"impact",
			{
				10,
				10,
			},
		},
		{
			"targets",
			1,
			"armor_damage_modifier",
			table.clone(chainsword_sawing),
		},
		{
			"skip_on_hit_proc",
			true,
		},
	},
}
overrides.light_chainaxe_sticky_last_quick = {
	parent_template_name = "default_light_chainaxe",
	overrides = {
		{
			"stagger_category",
			"sticky",
		},
		{
			"shield_stagger_category",
			"melee",
		},
		{
			"damage_type",
			damage_types.sawing_stuck,
		},
		{
			"ignore_stagger_reduction",
			true,
		},
		{
			"ignore_shield",
			true,
		},
		{
			"ragdoll_only",
			true,
		},
		{
			"gibbing_power",
			gibbing_power.medium,
		},
		{
			"sticky_attack",
			true,
		},
		{
			"gibbing_type",
			gibbing_types.sawing,
		},
		{
			"wounds_template",
			WoundsTemplates.chainaxe_sawing,
		},
		{
			"melee_attack_strength",
			melee_attack_strengths.light,
		},
		{
			"targets",
			1,
			"power_distribution",
			"attack",
			{
				50,
				275,
			},
		},
		{
			"targets",
			1,
			"power_distribution",
			"impact",
			{
				5,
				10,
			},
		},
		{
			"targets",
			1,
			"armor_damage_modifier",
			table.clone(chainsword_sawing),
		},
		{
			"targets",
			1,
			"armor_damage_modifier",
			"attack",
			"armored",
			damage_lerp_values.lerp_1_1,
		},
		{
			"targets",
			1,
			"armor_damage_modifier",
			"attack",
			"berserker",
			damage_lerp_values.lerp_1_25,
		},
		{
			"skip_on_hit_proc",
			true,
		},
	},
}
overrides.light_chainaxe_sticky_last_quick_m2 = {
	parent_template_name = "default_light_chainaxe",
	overrides = {
		{
			"stagger_category",
			"sticky",
		},
		{
			"shield_stagger_category",
			"melee",
		},
		{
			"damage_type",
			damage_types.sawing_stuck,
		},
		{
			"ignore_shield",
			true,
		},
		{
			"ragdoll_only",
			true,
		},
		{
			"gibbing_power",
			gibbing_power.medium,
		},
		{
			"sticky_attack",
			true,
		},
		{
			"gibbing_type",
			gibbing_types.sawing,
		},
		{
			"wounds_template",
			WoundsTemplates.chainaxe_sawing,
		},
		{
			"melee_attack_strength",
			melee_attack_strengths.light,
		},
		{
			"targets",
			1,
			"power_distribution",
			"attack",
			{
				75,
				150,
			},
		},
		{
			"skip_on_hit_proc",
			true,
		},
	},
}
damage_templates.light_chainaxe_tank = {
	finesse_ability_damage_multiplier = 1.5,
	ragdoll_only = true,
	ragdoll_push_force = 150,
	stagger_category = "melee",
	sticky_attack = false,
	crit_mod = chain_sword_crit_mod,
	cleave_distribution = large_cleave,
	gibbing_power = gibbing_power.always,
	gibbing_type = gibbing_types.sawing,
	melee_attack_strength = melee_attack_strengths.light,
	gib_push_force = GibbingSettings.gib_push_force.sawing_heavy,
	wounds_template = WoundsTemplates.chainaxe,
	armor_damage_modifier = chain_axe_light_mod,
	targets = {
		{
			armor_damage_modifier = {
				attack = {
					[armor_types.armored] = damage_lerp_values.lerp_1_5,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_75,
					[armor_types.resistant] = damage_lerp_values.lerp_1_5,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1_33,
				},
			},
			power_distribution = {
				attack = {
					80,
					150,
				},
				impact = {
					7,
					20,
				},
			},
			boost_curve_multiplier_finesse = {
				0.4,
				1.3,
			},
			power_level_multiplier = {
				0.6,
				1.5,
			},
		},
		{
			power_distribution = {
				attack = {
					55,
					115,
				},
				impact = {
					6,
					18,
				},
			},
		},
		{
			power_distribution = {
				attack = {
					35,
					75,
				},
				impact = {
					4,
					15,
				},
			},
		},
		{
			power_distribution = {
				attack = {
					25,
					45,
				},
				impact = {
					3,
					11,
				},
			},
		},
		default_target = {
			power_distribution = {
				attack = {
					20,
					30,
				},
				impact = {
					5,
					8,
				},
			},
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
}
damage_templates.heavy_chainaxe = {
	finesse_ability_damage_multiplier = 1.5,
	ragdoll_only = true,
	ragdoll_push_force = 600,
	stagger_category = "melee",
	sticky_attack = false,
	crit_mod = chain_sword_crit_mod,
	cleave_distribution = large_cleave,
	damage_type = damage_types.sawing,
	gibbing_power = gibbing_power.always,
	gibbing_type = gibbing_types.sawing,
	melee_attack_strength = melee_attack_strengths.heavy,
	gib_push_force = GibbingSettings.gib_push_force.sawing_heavy,
	wounds_template = WoundsTemplates.chainaxe,
	stagger_duration_modifier = {
		0.1,
		0.5,
	},
	armor_damage_modifier = chain_axe_heavy_mod,
	targets = {
		{
			armor_damage_modifier = {
				attack = {
					[armor_types.armored] = damage_lerp_values.lerp_0_75,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_3,
				},
				impact = {
					[armor_types.super_armor] = damage_lerp_values.lerp_1,
				},
			},
			power_distribution = {
				attack = {
					150,
					300,
				},
				impact = {
					7,
					22,
				},
			},
			boost_curve_multiplier_finesse = damage_lerp_values.lerp_0_5,
			power_level_multiplier = {
				0.6,
				1.4,
			},
		},
		{
			armor_damage_modifier = {
				attack = {
					[armor_types.armored] = damage_lerp_values.lerp_1,
				},
				impact = {
					[armor_types.super_armor] = damage_lerp_values.lerp_0_65,
				},
			},
			power_distribution = {
				attack = {
					100,
					200,
				},
				impact = {
					6,
					18,
				},
			},
		},
		{
			armor_damage_modifier = {
				attack = {
					[armor_types.armored] = damage_lerp_values.lerp_1,
				},
				impact = {
					[armor_types.super_armor] = damage_lerp_values.lerp_0_65,
				},
			},
			power_distribution = {
				attack = {
					75,
					140,
				},
				impact = {
					5,
					13,
				},
			},
		},
		{
			armor_damage_modifier = {
				attack = {
					[armor_types.armored] = damage_lerp_values.lerp_1,
				},
				impact = {
					[armor_types.super_armor] = damage_lerp_values.lerp_0_65,
				},
			},
			power_distribution = {
				attack = {
					10,
					55,
				},
				impact = {
					6,
					8,
				},
			},
		},
		default_target = {
			armor_damage_modifier = chain_axe_heavy_mod,
			power_distribution = {
				attack = {
					0,
					0,
				},
				impact = {
					4,
					6,
				},
			},
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
}
overrides.heavy_chainaxe_active = {
	parent_template_name = "heavy_chainaxe",
	overrides = {
		{
			"stagger_category",
			"melee",
		},
		{
			"stagger_override",
			"medium",
		},
		{
			"shield_stagger_category",
			"melee",
		},
		{
			"ignore_stagger_reduction",
			true,
		},
		{
			"ignore_shield",
			true,
		},
		{
			"ignore_hit_reacts",
			true,
		},
		{
			"damage_type",
			damage_types.sawing_stuck,
		},
		{
			"ignore_instant_ragdoll_chance",
			true,
		},
		{
			"cleave_distribution",
			no_cleave,
		},
		{
			"gibbing_power",
			gibbing_power.heavy,
		},
		{
			"gibbing_type",
			gibbing_types.sawing,
		},
		{
			"wounds_template",
			WoundsTemplates.chainaxe_sawing,
		},
		{
			"weapon_special",
			true,
		},
	},
}
overrides.heavy_chainaxe_active_sticky = {
	parent_template_name = "heavy_chainaxe",
	overrides = {
		{
			"stagger_category",
			"sticky",
		},
		{
			"stagger_override",
			"sticky",
		},
		{
			"shield_stagger_category",
			"sticky",
		},
		{
			"ignore_stagger_reduction",
			true,
		},
		{
			"ignore_shield",
			true,
		},
		{
			"damage_type",
			damage_types.sawing_stuck,
		},
		{
			"sticky_attack",
			true,
		},
		{
			"ignore_instant_ragdoll_chance",
			true,
		},
		{
			"gibbing_power",
			gibbing_power.heavy,
		},
		{
			"gibbing_type",
			gibbing_types.sawing,
		},
		{
			"wounds_template",
		},
		{
			"targets",
			1,
			"power_distribution",
			"attack",
			{
				200,
				400,
			},
		},
		{
			"targets",
			1,
			"power_distribution",
			"impact",
			{
				10,
				20,
			},
		},
		{
			"targets",
			1,
			"armor_damage_modifier",
			table.clone(chainsword_sawing_tick),
		},
		{
			"weapon_special",
			true,
		},
		{
			"skip_on_hit_proc",
			true,
		},
	},
}
overrides.heavy_chainaxe_active_sticky_last = {
	parent_template_name = "heavy_chainaxe",
	overrides = {
		{
			"stagger_category",
			"sticky",
		},
		{
			"shield_stagger_category",
			"sticky",
		},
		{
			"ignore_stagger_reduction",
			true,
		},
		{
			"ignore_shield",
			true,
		},
		{
			"damage_type",
			damage_types.sawing_stuck,
		},
		{
			"sticky_attack",
			true,
		},
		{
			"ignore_instant_ragdoll_chance",
			true,
		},
		{
			"gibbing_power",
			gibbing_power.heavy,
		},
		{
			"gibbing_type",
			gibbing_types.sawing,
		},
		{
			"wounds_template",
			WoundsTemplates.chainaxe_sawing,
		},
		{
			"targets",
			1,
			"power_distribution",
			"attack",
			{
				550,
				1100,
			},
		},
		{
			"targets",
			1,
			"power_distribution",
			"impact",
			{
				0,
				0,
			},
		},
		{
			"targets",
			1,
			"armor_damage_modifier",
			table.clone(chainsword_sawing_rip),
		},
		{
			"weapon_special",
			true,
		},
		{
			"skip_on_hit_proc",
			true,
		},
	},
}
overrides.heavy_chainaxe_sticky = {
	parent_template_name = "heavy_chainaxe",
	overrides = {
		{
			"stagger_category",
			"sticky",
		},
		{
			"stagger_override",
			"sticky",
		},
		{
			"shield_stagger_category",
			"melee",
		},
		{
			"ignore_shield",
			true,
		},
		{
			"damage_type",
			damage_types.sawing_stuck,
		},
		{
			"sticky_attack",
			true,
		},
		{
			"ignore_instant_ragdoll_chance",
			true,
		},
		{
			"gibbing_power",
			gibbing_power.heavy,
		},
		{
			"gibbing_type",
			gibbing_types.sawing,
		},
		{
			"wounds_template",
		},
		{
			"targets",
			1,
			"power_distribution",
			"attack",
			{
				30,
				90,
			},
		},
		{
			"targets",
			1,
			"armor_damage_modifier",
			table.clone(chainsword_sawing),
		},
		{
			"skip_on_hit_proc",
			true,
		},
	},
}
overrides.heavy_chainaxe_sticky_last_quick = {
	parent_template_name = "heavy_chainaxe",
	overrides = {
		{
			"stagger_category",
			"melee",
		},
		{
			"shield_stagger_category",
			"melee",
		},
		{
			"ignore_stagger_reduction",
			true,
		},
		{
			"ignore_shield",
			true,
		},
		{
			"damage_type",
			damage_types.sawing_stuck,
		},
		{
			"sticky_attack",
			true,
		},
		{
			"ignore_instant_ragdoll_chance",
			true,
		},
		{
			"gibbing_power",
			gibbing_power.heavy,
		},
		{
			"gibbing_type",
			gibbing_types.sawing,
		},
		{
			"wounds_template",
			WoundsTemplates.chainaxe_sawing,
		},
		{
			"targets",
			1,
			"power_distribution",
			"attack",
			{
				110,
				335,
			},
		},
		{
			"targets",
			1,
			"power_distribution",
			"impact",
			{
				9,
				16,
			},
		},
		{
			"targets",
			1,
			"armor_damage_modifier",
			table.clone(chainsword_sawing),
		},
		{
			"targets",
			1,
			"armor_damage_modifier",
			"attack",
			"armored",
			damage_lerp_values.lerp_1_1,
		},
		{
			"targets",
			1,
			"armor_damage_modifier",
			"attack",
			"berserker",
			damage_lerp_values.lerp_1_25,
		},
		{
			"skip_on_hit_proc",
			true,
		},
	},
}
damage_templates.light_chainaxe_pushfollowup_tank = {
	ignore_stagger_reduction = true,
	ragdoll_only = true,
	ragdoll_push_force = 250,
	stagger_category = "melee",
	cleave_distribution = medium_cleave,
	damage_type = damage_types.blunt_light,
	gibbing_power = gibbing_power.always,
	gibbing_type = gibbing_types.sawing,
	melee_attack_strength = melee_attack_strengths.light,
	gib_push_force = GibbingSettings.gib_push_force.sawing_heavy,
	armor_damage_modifier = chain_axe_light_mod,
	targets = {
		{
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_5,
					[armor_types.resistant] = damage_lerp_values.lerp_0_75,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_5,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_1,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_1,
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
			power_distribution = {
				attack = {
					100,
					200,
				},
				impact = {
					6,
					12,
				},
			},
			power_level_multiplier = {
				0.5,
				1.5,
			},
		},
		{
			power_distribution = {
				attack = {
					50,
					100,
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
					4,
					8,
				},
			},
		},
		default_target = {
			power_distribution = {
				attack = {
					5,
					20,
				},
				impact = {
					4,
					8,
				},
			},
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
}
damage_templates.heavy_chainaxe_smiter = {
	finesse_ability_damage_multiplier = 1.5,
	ragdoll_only = true,
	ragdoll_push_force = 600,
	stagger_category = "melee",
	sticky_attack = false,
	crit_mod = chain_sword_crit_mod,
	cleave_distribution = no_cleave,
	damage_type = damage_types.sawing,
	gibbing_power = gibbing_power.always,
	gibbing_type = gibbing_types.sawing,
	melee_attack_strength = melee_attack_strengths.heavy,
	gib_push_force = GibbingSettings.gib_push_force.sawing_heavy,
	wounds_template = WoundsTemplates.chainaxe,
	stagger_duration_modifier = {
		0.1,
		0.5,
	},
	armor_damage_modifier = chain_axe_heavy_mod,
	targets = {
		{
			armor_damage_modifier = {
				attack = {
					[armor_types.armored] = damage_lerp_values.lerp_0_75,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_3,
				},
				impact = {
					[armor_types.super_armor] = damage_lerp_values.lerp_1,
				},
			},
			power_distribution = {
				attack = {
					100,
					220,
				},
				impact = {
					7,
					15,
				},
			},
			boost_curve_multiplier_finesse = damage_lerp_values.lerp_0_5,
			power_level_multiplier = {
				0.7,
				1.1,
			},
		},
		{
			armor_damage_modifier = {
				attack = {
					[armor_types.armored] = damage_lerp_values.lerp_1,
				},
				impact = {
					[armor_types.super_armor] = damage_lerp_values.lerp_0_65,
				},
			},
			power_distribution = {
				attack = {
					50,
					100,
				},
				impact = {
					6,
					12,
				},
			},
		},
		default_target = {
			armor_damage_modifier = chain_axe_heavy_mod,
			power_distribution = {
				attack = {
					0,
					0,
				},
				impact = {
					4,
					6,
				},
			},
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
}
overrides.chainaxe_light_stab = {
	parent_template_name = "default_light_chainaxe",
	overrides = {
		{
			"ignore_stagger_reduction",
			true,
		},
		{
			"targets",
			1,
			"power_distribution",
			"attack",
			{
				140,
				300,
			},
		},
		{
			"targets",
			1,
			"power_distribution",
			"impact",
			{
				15,
				20,
			},
		},
		{
			"cleave_distribution",
			double_cleave,
		},
		{
			"targets",
			1,
			"armor_damage_modifier",
			"attack",
			"armored",
			damage_lerp_values.lerp_1,
		},
		{
			"targets",
			1,
			"armor_damage_modifier",
			"attack",
			"super_armor",
			damage_lerp_values.lerp_0_5,
		},
		{
			"targets",
			1,
			"armor_damage_modifier",
			"attack",
			"resistant",
			damage_lerp_values.lerp_0_9,
		},
		{
			"targets",
			1,
			"armor_damage_modifier",
			"attack",
			"void_shield",
			damage_lerp_values.lerp_2,
		},
		{
			"targets",
			1,
			"armor_damage_modifier",
			"impact",
			"super_armor",
			damage_lerp_values.lerp_1_75,
		},
		{
			"targets",
			1,
			"armor_damage_modifier",
			"impact",
			"berserker",
			damage_lerp_values.lerp_0_9,
		},
		{
			"targets",
			1,
			"armor_damage_modifier",
			"impact",
			"armored",
			damage_lerp_values.lerp_0_5,
		},
		{
			"targets",
			1,
			"boost_curve_multiplier_finesse",
			{
				0.5,
				1.5,
			},
		},
	},
}

return {
	base_templates = damage_templates,
	overrides = overrides,
}
