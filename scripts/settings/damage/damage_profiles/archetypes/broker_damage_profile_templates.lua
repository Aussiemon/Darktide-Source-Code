-- chunkname: @scripts/settings/damage/damage_profiles/archetypes/broker_damage_profile_templates.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local DamageProfileSettings = require("scripts/settings/damage/damage_profile_settings")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local GibbingSettings = require("scripts/settings/gibbing/gibbing_settings")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local armor_types = ArmorSettings.types
local damage_types = DamageSettings.damage_types
local gib_push_force = GibbingSettings.gib_push_force
local gibbing_power = GibbingSettings.gibbing_power
local gibbing_types = GibbingSettings.gibbing_types
local damage_templates = {}
local overrides = {}

table.make_unique(damage_templates)
table.make_unique(overrides)

damage_templates.broker_flash_grenade_impact = {
	gibbing_power = 0,
	gibbing_type = 0,
	ignore_shield = true,
	ignore_stagger_reduction = true,
	ragdoll_push_force = 150,
	shield_override_stagger_strength = 500,
	stagger_category = "ranged",
	suppression_value = 4,
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
				[armor_types.unarmored] = 0.5,
				[armor_types.armored] = 1,
				[armor_types.resistant] = 1,
				[armor_types.player] = 1,
				[armor_types.berserker] = 1,
				[armor_types.super_armor] = 0.5,
				[armor_types.disgustingly_resilient] = 0.75,
				[armor_types.void_shield] = 0.75,
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
			},
		},
		far = {
			attack = {
				[armor_types.unarmored] = 0.5,
				[armor_types.armored] = 1,
				[armor_types.resistant] = 1,
				[armor_types.player] = 1,
				[armor_types.berserker] = 1,
				[armor_types.super_armor] = 0.5,
				[armor_types.disgustingly_resilient] = 0.75,
				[armor_types.void_shield] = 0.75,
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
			},
		},
	},
	power_distribution = {
		attack = 2,
		impact = 3,
	},
	on_kill_area_suppression = {
		distance = 8,
		suppression_value = 10,
	},
	targets = {
		default_target = {
			boost_curve_multiplier_finesse = 1.2,
			boost_curve = PowerLevelSettings.boost_curves.default,
			finesse_boost = {
				[armor_types.unarmored] = 0.75,
			},
		},
	},
	breed_instakill_overrides = {
		corruptor_body = true,
	},
}
damage_templates.broker_flash_grenade_close = {
	damage_type = "grenade",
	gibbing_power = 0,
	gibbing_type = 0,
	ignore_stagger_reduction = true,
	ragdoll_push_force = 500,
	shield_override_stagger_strength = 500,
	stagger_category = "ranged",
	suppression_value = 10,
	cleave_distribution = DamageProfileSettings.no_cleave,
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
			[armor_types.unarmored] = 1,
			[armor_types.armored] = 2,
			[armor_types.resistant] = 1,
			[armor_types.player] = 1,
			[armor_types.berserker] = 2,
			[armor_types.super_armor] = 2,
			[armor_types.disgustingly_resilient] = 2,
			[armor_types.void_shield] = 2,
		},
	},
	power_distribution = {
		attack = 0,
		impact = 200,
	},
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
}
overrides.broker_flash_grenade = {
	parent_template_name = "broker_flash_grenade_close",
	overrides = {
		{
			"power_distribution",
			"impact",
			100,
		},
	},
}

local broker_missile_launcher_impact_adm = {
	[armor_types.unarmored] = 1,
	[armor_types.armored] = 1,
	[armor_types.resistant] = 0.75,
	[armor_types.player] = 1,
	[armor_types.berserker] = 0.9,
	[armor_types.super_armor] = 1.1,
	[armor_types.disgustingly_resilient] = 0.25,
	[armor_types.void_shield] = 1,
}

damage_templates.broker_missile_launcher_explosion_close = {
	ignore_stagger_reduction = true,
	ragdoll_push_force = 2000,
	stagger_category = "explosion",
	suppression_value = 10,
	cleave_distribution = {
		attack = 1,
		impact = 1,
	},
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = 1.25,
			[armor_types.armored] = 2,
			[armor_types.resistant] = 2,
			[armor_types.player] = 1,
			[armor_types.berserker] = 1.35,
			[armor_types.super_armor] = 2.4,
			[armor_types.disgustingly_resilient] = 0.75,
			[armor_types.void_shield] = 1.1,
		},
		impact = {
			[armor_types.unarmored] = 2,
			[armor_types.armored] = 2,
			[armor_types.resistant] = 2,
			[armor_types.player] = 2,
			[armor_types.berserker] = 2,
			[armor_types.super_armor] = 2,
			[armor_types.disgustingly_resilient] = 2,
			[armor_types.void_shield] = 2,
		},
	},
	power_distribution = {
		attack = 2800,
		impact = 600,
	},
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
	damage_type = damage_types.grenade_frag,
	gibbing_type = gibbing_types.explosion,
	gibbing_power = gibbing_power.infinite,
	gib_push_force = gib_push_force.explosive_heavy,
}
overrides.broker_missile_launcher_explosion = {
	parent_template_name = "broker_missile_launcher_explosion_close",
	overrides = {
		{
			"power_distribution",
			"attack",
			1300,
		},
		{
			"power_distribution",
			"impact",
			150,
		},
		{
			"gibbing_power",
			gibbing_power.heavy,
		},
		{
			"gib_push_force",
			gib_push_force.explosive,
		},
	},
}
damage_templates.broker_missile_launcher_impact = {
	ignore_shield = true,
	ignore_stagger_reduction = true,
	ragdoll_push_force = 750,
	shield_override_stagger_strength = 120,
	stagger_category = "explosion",
	suppression_value = 12,
	cleave_distribution = {
		attack = 2.5,
		impact = 2.5,
	},
	ranges = {
		max = 4,
		min = 0.5,
	},
	armor_damage_modifier_ranged = {
		near = {
			attack = broker_missile_launcher_impact_adm,
			impact = broker_missile_launcher_impact_adm,
		},
		far = {
			attack = broker_missile_launcher_impact_adm,
			impact = broker_missile_launcher_impact_adm,
		},
	},
	power_distribution = {
		attack = 1800,
		impact = 800,
	},
	damage_type = damage_types.grenade_frag,
	gibbing_type = gibbing_types.explosion,
	gibbing_power = gibbing_power.heavy,
	gib_push_force = gib_push_force.ranged_heavy,
	on_kill_area_suppression = {
		distance = 16,
		suppression_value = 12,
	},
	targets = {
		default_target = {
			boost_curve_multiplier_finesse = 1.2,
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
	breed_instakill_overrides = {
		corruptor_body = true,
	},
}
damage_templates.missile_launcher_knockback = {
	ignore_stagger_reduction = true,
	stagger_category = "explosion",
	suppression_value = 200,
	ranges = {
		max = 12,
		min = 6,
	},
	armor_damage_modifier_ranged = {
		near = {
			attack = {
				[armor_types.unarmored] = 1,
				[armor_types.armored] = 0.5,
				[armor_types.resistant] = 0.5,
				[armor_types.player] = 0,
				[armor_types.berserker] = 0.75,
				[armor_types.super_armor] = 0.25,
				[armor_types.disgustingly_resilient] = 0.5,
				[armor_types.void_shield] = 0,
			},
			impact = {
				[armor_types.unarmored] = 1.6,
				[armor_types.armored] = 1,
				[armor_types.resistant] = 0.8,
				[armor_types.player] = 0,
				[armor_types.berserker] = 0.6,
				[armor_types.super_armor] = 0.6,
				[armor_types.disgustingly_resilient] = 1,
				[armor_types.void_shield] = 0,
			},
		},
		far = {
			attack = {
				[armor_types.unarmored] = 1,
				[armor_types.armored] = 0.5,
				[armor_types.resistant] = 0.5,
				[armor_types.player] = 0,
				[armor_types.berserker] = 0.75,
				[armor_types.super_armor] = 0.25,
				[armor_types.disgustingly_resilient] = 0.5,
				[armor_types.void_shield] = 0,
			},
			impact = {
				[armor_types.unarmored] = 1.6,
				[armor_types.armored] = 1,
				[armor_types.resistant] = 0.8,
				[armor_types.player] = 0,
				[armor_types.berserker] = 0.6,
				[armor_types.super_armor] = 0.6,
				[armor_types.disgustingly_resilient] = 1,
				[armor_types.void_shield] = 0,
			},
		},
	},
	power_distribution_ranged = {
		attack = {
			far = 50,
			near = 100,
		},
		impact = {
			far = 100,
			near = 200,
		},
	},
	buffs = {
		on_damage_dealt = {
			flamer_assault = 1,
		},
	},
	targets = {
		default_target = {},
	},
}
damage_templates.broker_tox_grenade = {
	gibbing_power = 0,
	ignore_stagger_reduction = true,
	ragdoll_push_force = 200,
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
	},
	power_distribution_ranged = {
		attack = {
			far = 1,
			near = 2,
		},
		impact = {
			far = 2.5,
			near = 5,
		},
	},
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
	gibbing_type = gibbing_types.explosion,
}
damage_templates.broker_stimm_field = {
	ignore_stagger_reduction = true,
	ragdoll_push_force = 100,
	stagger_category = "explosion",
	suppression_value = 10,
	cleave_distribution = {
		attack = 0.15,
		impact = 0.15,
	},
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = 1,
			[armor_types.armored] = 0.25,
			[armor_types.resistant] = 0.75,
			[armor_types.player] = 1,
			[armor_types.berserker] = 0.5,
			[armor_types.super_armor] = 0.1,
			[armor_types.disgustingly_resilient] = 1,
			[armor_types.void_shield] = 0.75,
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
		attack = 200,
		impact = 30,
	},
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
	buffs = {
		on_damage_dealt = {
			neurotoxin_interval_buff3 = 7,
		},
	},
	gibbing_type = gibbing_types.explosion,
	gibbing_power = gibbing_power.light,
}
overrides.broker_stimm_field_close = {
	parent_template_name = "broker_stimm_field",
	overrides = {
		{
			"power_distribution",
			"attack",
			300,
		},
		{
			"power_distribution",
			"impact",
			55,
		},
		{
			"suppression_value",
			30,
		},
		{
			"ragdoll_push_force",
			250,
		},
	},
}
damage_templates.broker_vultures_mark_aoe_stagger = {
	stagger_category = "ranged",
	stagger_override = "medium",
	power_distribution = {
		attack = 0,
		impact = 0.55,
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
			[armor_types.unarmored] = 1,
			[armor_types.armored] = 0.4,
			[armor_types.resistant] = 0.4,
			[armor_types.player] = 1,
			[armor_types.berserker] = 0.4,
			[armor_types.super_armor] = 0.1,
			[armor_types.disgustingly_resilient] = 0.4,
			[armor_types.void_shield] = 0.1,
		},
	},
	targets = {
		default_target = {},
	},
}
damage_templates.broker_punk_rage_shout = {
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

return {
	base_templates = damage_templates,
	overrides = overrides,
}
