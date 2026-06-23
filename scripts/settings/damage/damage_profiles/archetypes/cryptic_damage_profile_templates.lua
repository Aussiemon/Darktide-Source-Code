-- chunkname: @scripts/settings/damage/damage_profiles/archetypes/cryptic_damage_profile_templates.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local DamageProfileSettings = require("scripts/settings/damage/damage_profile_settings")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local GibbingSettings = require("scripts/settings/gibbing/gibbing_settings")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local WoundsTemplates = require("scripts/settings/damage/wounds_templates")
local armor_types = ArmorSettings.types
local crit_armor_mod = DamageProfileSettings.axe_crit_mod
local damage_lerp_values = DamageProfileSettings.damage_lerp_values
local damage_types = DamageSettings.damage_types
local gibbing_power = GibbingSettings.gibbing_power
local gibbing_types = GibbingSettings.gibbing_types
local melee_attack_strengths = AttackSettings.melee_attack_strength
local no_cleave = DamageProfileSettings.no_cleave
local double_cleave = DamageProfileSettings.double_cleave
local single_cleave = DamageProfileSettings.single_cleave
local medium_cleave = DamageProfileSettings.medium_cleave
local large_cleave = DamageProfileSettings.large_cleave
local big_cleave = DamageProfileSettings.big_cleave
local damage_templates = {}
local overrides = {}

table.make_unique(damage_templates)
table.make_unique(overrides)

local arc_damage_on_melee_hit_adm = {
	[armor_types.unarmored] = 1,
	[armor_types.armored] = 1,
	[armor_types.resistant] = 1,
	[armor_types.player] = 1,
	[armor_types.berserker] = 1,
	[armor_types.super_armor] = 1,
	[armor_types.disgustingly_resilient] = 1,
	[armor_types.void_shield] = 1,
}

damage_templates.arc_damage_on_melee_hit = {
	ignore_shield = true,
	is_buff_damage = true,
	skip_minion_toughness = true,
	stagger_category = "flamer",
	toughness_multiplier = 3,
	armor_damage_modifier = {
		attack = arc_damage_on_melee_hit_adm,
		impact = arc_damage_on_melee_hit_adm,
	},
	power_distribution = {
		attack = 50,
		impact = 0,
	},
	cleave_distribution = {
		attack = 0.125,
		impact = 0,
	},
	damage_type = damage_types.arc_chain,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
	stat_buffs = {
		"arc_chain_damage",
	},
}
damage_templates.cryptic_arc_chain_lightning_link_damage = {
	ignore_hitzone_multiplier = true,
	ignore_stagger_reduction = true,
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
			[armor_types.void_shield] = damage_lerp_values.lerp_1,
		},
		impact = {
			[armor_types.unarmored] = damage_lerp_values.lerp_0_75,
			[armor_types.armored] = damage_lerp_values.lerp_1,
			[armor_types.resistant] = damage_lerp_values.lerp_0_5,
			[armor_types.player] = damage_lerp_values.lerp_0_5,
			[armor_types.berserker] = damage_lerp_values.lerp_0_5,
			[armor_types.super_armor] = damage_lerp_values.lerp_1,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_75,
			[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
		},
	},
	cleave_distribution = {
		attack = 5,
		impact = 5,
	},
	power_distribution = {
		attack = 20,
		impact = 20,
	},
	damage_type = damage_types.arc_chain,
	gibbing_power = gibbing_power.light,
	gibbing_type = gibbing_types.arc,
	critical_strike = {
		gibbing_power = gibbing_power.medium,
		gibbing_type = gibbing_types.arc,
	},
	gib_push_force = GibbingSettings.gib_push_force.ranged_heavy,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
		boost_curve_multiplier_finesse = damage_lerp_values.lerp_1,
	},
	stat_buffs = {
		"arc_chain_damage",
	},
}
damage_templates.chordclaw_main = {
	ragdoll_only = true,
	ragdoll_push_force = 300,
	shield_override_stagger_strength = 5,
	stagger_category = "sticky",
	cleave_distribution = medium_cleave,
	gibbing_power = gibbing_power.medium,
	gibbing_type = gibbing_types.sawing,
	melee_attack_strength = melee_attack_strengths.heavy,
	gib_push_force = GibbingSettings.gib_push_force.sawing_heavy,
	wounds_template = WoundsTemplates.blunt,
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_1,
			[armor_types.resistant] = damage_lerp_values.lerp_1,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_1,
			[armor_types.super_armor] = damage_lerp_values.lerp_1,
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
	crit_mod = crit_armor_mod,
	targets = {
		{
			boost_curve_multiplier_finesse = 0.25,
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_1,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_1,
					[armor_types.super_armor] = damage_lerp_values.lerp_1,
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
				attack = 800,
				impact = 30,
			},
			power_level_multiplier = {
				0.5,
				1.5,
			},
		},
		{
			power_distribution = {
				attack = 400,
				impact = 30,
			},
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
		{
			power_distribution = {
				attack = 250,
				impact = 30,
			},
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
		default_target = {
			power_distribution = {
				attack = 25,
				impact = 30,
			},
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
	stat_buffs = {
		"cryptic_chordclaw_damage",
	},
}
damage_templates.chordclaw_stab_bleed = {
	ragdoll_only = true,
	ragdoll_push_force = 300,
	shield_override_stagger_strength = 5,
	stagger_category = "sticky",
	cleave_distribution = medium_cleave,
	gibbing_power = gibbing_power.medium,
	gibbing_type = gibbing_types.sawing,
	melee_attack_strength = melee_attack_strengths.heavy,
	gib_push_force = GibbingSettings.gib_push_force.sawing_heavy,
	wounds_template = WoundsTemplates.blunt,
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_1,
			[armor_types.resistant] = damage_lerp_values.lerp_1,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_1,
			[armor_types.super_armor] = damage_lerp_values.lerp_0_9,
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
	crit_mod = crit_armor_mod,
	targets = {
		{
			boost_curve_multiplier_finesse = 0.25,
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1_25,
					[armor_types.armored] = damage_lerp_values.lerp_1,
					[armor_types.resistant] = damage_lerp_values.lerp_1_5,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_1_25,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_9,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1_25,
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
				attack = 550,
				impact = 30,
			},
			power_level_multiplier = {
				0.5,
				1.5,
			},
		},
		{
			boost_curve_multiplier_finesse = 0.25,
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_1,
					[armor_types.resistant] = damage_lerp_values.lerp_1_25,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_1,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_9,
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
				attack = 350,
				impact = 30,
			},
			power_level_multiplier = {
				0.5,
				1.5,
			},
		},
		{
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = 200,
				impact = 30,
			},
			power_level_multiplier = {
				0.5,
				1.5,
			},
		},
		default_target = {
			power_distribution = {
				impact = 30,
				attack = {
					10,
					25,
				},
			},
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
	stat_buffs = {
		"cryptic_chordclaw_damage",
	},
	buffs = {
		on_damage_dealt = {
			bleed_long = 6,
		},
	},
}
overrides.chordclaw_light = {
	parent_template_name = "chordclaw_main",
	overrides = {
		{
			"targets",
			1,
			"power_distribution",
			"attack",
			500,
		},
		{
			"targets",
			1,
			"power_distribution",
			"impact",
			12,
		},
		{
			"targets",
			1,
			"armor_damage_modifier",
			"attack",
			"armored",
			damage_lerp_values.lerp_0_9,
		},
		{
			"targets",
			1,
			"armor_damage_modifier",
			"attack",
			"super_armor",
			damage_lerp_values.lerp_0_4,
		},
	},
}
overrides.chordclaw_sticky = {
	parent_template_name = "chordclaw_main",
	overrides = {
		{
			"damage_type",
			damage_types.sawing_stuck,
		},
		{
			"stagger_category",
			"melee",
		},
		{
			"stagger_override",
			"medium",
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
			"targets",
			1,
			"power_distribution",
			"attack",
			1500,
		},
		{
			"targets",
			1,
			"power_distribution",
			"impact",
			500,
		},
	},
}
overrides.chordclaw_sticky_dodge = {
	parent_template_name = "chordclaw_main",
	overrides = {
		{
			"damage_type",
			damage_types.sawing_stuck,
		},
		{
			"stagger_category",
			"melee",
		},
		{
			"stagger_override",
			"medium",
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
			"targets",
			1,
			"power_distribution",
			"attack",
			800,
		},
		{
			"targets",
			1,
			"power_distribution",
			"impact",
			500,
		},
	},
}
damage_templates.chordclaw_horizontal = {
	gibbing_power = 10,
	ragdoll_only = true,
	ragdoll_push_force = 600,
	shield_override_stagger_strength = 5,
	stagger_category = "melee",
	cleave_distribution = {
		attack = {
			18.5,
			19.5,
		},
		impact = {
			18.5,
			19.5,
		},
	},
	damage_type = damage_types.power_sword,
	gibbing_type = gibbing_types.default,
	melee_attack_strength = melee_attack_strengths.heavy,
	gib_push_force = GibbingSettings.gib_push_force.sawing_heavy,
	wounds_template = WoundsTemplates.slash,
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_1,
			[armor_types.resistant] = damage_lerp_values.lerp_0_9,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_1,
			[armor_types.super_armor] = damage_lerp_values.lerp_0_9,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
			[armor_types.void_shield] = damage_lerp_values.lerp_0_9,
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
	crit_mod = crit_armor_mod,
	targets = {
		default_target = {
			power_distribution = {
				attack = 500,
				impact = 100,
			},
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
	stat_buffs = {
		"cryptic_chordclaw_damage",
	},
}
damage_templates.cryptic_discharge_explosion = {
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
damage_templates.cryptic_discharge_weapon_malfunction_explosion = {
	damage_type = "grenade",
	ignore_stagger_reduction = true,
	ragdoll_push_force = 250,
	shield_override_stagger_strength = 0,
	stagger_category = "explosion",
	suppression_value = 10,
	cleave_distribution = {
		attack = 0,
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
damage_templates.companion_servo_skull_flamer = {
	accumulative_stagger_strength_multiplier = 0.5,
	duration_scale_bonus = 0.5,
	gibbing_power = 0,
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
	armor_damage_modifier_ranged = {
		near = {
			attack = {
				[armor_types.unarmored] = 2,
				[armor_types.armored] = 1,
				[armor_types.resistant] = 2,
				[armor_types.player] = 1,
				[armor_types.berserker] = 2.5,
				[armor_types.super_armor] = 0.1,
				[armor_types.disgustingly_resilient] = 1.5,
				[armor_types.void_shield] = 1,
			},
			impact = {
				[armor_types.unarmored] = 1,
				[armor_types.armored] = 0.75,
				[armor_types.resistant] = 0.75,
				[armor_types.player] = 1,
				[armor_types.berserker] = 1,
				[armor_types.super_armor] = 0.1,
				[armor_types.disgustingly_resilient] = 1,
				[armor_types.void_shield] = 1,
			},
		},
		far = {
			attack = {
				[armor_types.unarmored] = 1,
				[armor_types.armored] = 0.5,
				[armor_types.resistant] = 1,
				[armor_types.player] = 1,
				[armor_types.berserker] = 1,
				[armor_types.super_armor] = 0,
				[armor_types.disgustingly_resilient] = 0.7,
				[armor_types.void_shield] = 1,
			},
			impact = {
				[armor_types.unarmored] = 0.75,
				[armor_types.armored] = 0.1,
				[armor_types.resistant] = 0.3,
				[armor_types.player] = 0,
				[armor_types.berserker] = 0.5,
				[armor_types.super_armor] = 0.01,
				[armor_types.disgustingly_resilient] = 0.75,
				[armor_types.void_shield] = 0.5,
			},
		},
	},
	damage_type = damage_types.burning,
	gibbing_type = gibbing_types.plasma,
	targets = {
		{
			power_distribution = {
				attack = {
					16,
					24,
				},
				impact = {
					1,
					2,
				},
			},
		},
		{
			power_distribution = {
				attack = {
					20,
					32,
				},
				impact = {
					2,
					4,
				},
			},
		},
		{
			power_distribution = {
				attack = {
					24,
					40,
				},
				impact = {
					3,
					6,
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
		{
			power_distribution = {
				attack = {
					35,
					70,
				},
				impact = {
					6,
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
					10,
					15,
				},
			},
		},
		default_target = {
			power_distribution = {
				attack = {
					60,
					100,
				},
				impact = {
					10,
					15,
				},
			},
		},
	},
}
damage_templates.cryptic_overload_keystone_debuff_explosion = {
	damage_type = "grenade",
	ignore_stagger_reduction = true,
	ragdoll_push_force = 0,
	shield_override_stagger_strength = 0,
	stagger_category = "explosion",
	suppression_value = 0,
	cleave_distribution = {
		attack = 0,
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
	gibbing_type = gibbing_types.warp_lightning,
	gibbing_power = gibbing_power.light,
}
damage_templates.cryptic_corruption_resistance_doom_tick = {
	ignore_shield = true,
	ignore_toughness = true,
	permanent_damage_ratio = 1,
	skip_on_hit_proc = true,
	stagger_category = "ranged",
	armor_damage_modifier = {
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
	power_distribution = {
		attack = 10,
		impact = 0,
	},
	cleave_distribution = {
		attack = 1,
		impact = 0,
	},
	damage_type = damage_types.grimoire,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
}

return {
	base_templates = damage_templates,
	overrides = overrides,
}
