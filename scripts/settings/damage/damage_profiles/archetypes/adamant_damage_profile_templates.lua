-- chunkname: @scripts/settings/damage/damage_profiles/archetypes/adamant_damage_profile_templates.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local DamageProfileSettings = require("scripts/settings/damage/damage_profile_settings")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local ForcedLookSettings = require("scripts/settings/damage/forced_look_settings")
local GibbingSettings = require("scripts/settings/gibbing/gibbing_settings")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local PushSettings = require("scripts/settings/damage/push_settings")
local WoundsTemplates = require("scripts/settings/damage/wounds_templates")
local armor_types = ArmorSettings.types
local gibbing_power = GibbingSettings.gibbing_power
local gibbing_types = GibbingSettings.gibbing_types
local damage_types = DamageSettings.damage_types
local push_templates = PushSettings.push_templates
local damage_templates = {}
local overrides = {}

table.make_unique(damage_templates)
table.make_unique(overrides)

damage_templates.adamant_shout = {
	ignore_shield = true,
	ignore_stagger_reduction = true,
	stagger_category = "melee",
	stagger_duration_modifier = 1,
	suppression_type = "ability",
	suppression_value = 30,
	power_distribution = {
		attack = 0,
		impact = 30,
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
	targets = {
		default_target = {},
	},
}
damage_templates.adamant_shout_damage = {
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
	targets = {
		default_target = {},
	},
}
damage_templates.adamant_charge_impact = {
	ignore_stagger_reduction = true,
	is_push = true,
	stagger_category = "hatchet",
	stagger_override = "heavy",
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
			[armor_types.unarmored] = 3,
			[armor_types.armored] = 3,
			[armor_types.resistant] = 3,
			[armor_types.player] = 3,
			[armor_types.berserker] = 3,
			[armor_types.super_armor] = 3,
			[armor_types.disgustingly_resilient] = 3,
			[armor_types.void_shield] = 3,
		},
	},
	targets = {
		default_target = {},
	},
	attacker_impact_effects = {
		camera_effect_shake_event = "adamant_charge_impact",
	},
}
damage_templates.adamant_charge_damage = {
	ignore_stagger_reduction = true,
	stagger_category = "hatchet",
	stagger_override = "heavy",
	power_distribution = {
		attack = 300,
		impact = 1,
	},
	cleave_distribution = {
		attack = 1,
		impact = 1,
	},
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = 1.5,
			[armor_types.armored] = 1.5,
			[armor_types.resistant] = 1.5,
			[armor_types.player] = 1,
			[armor_types.berserker] = 1.5,
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
	targets = {
		default_target = {},
	},
	attacker_impact_effects = {
		camera_effect_shake_event = "adamant_charge_impact",
	},
}
damage_templates.adamant_companion_pounce = {
	companion_pounce = true,
	disorientation_type = "medium",
	instant_ragdoll_delay = 0.05,
	interrupt_alternate_fire = true,
	ogryn_disorientation_type = "ogryn_medium",
	stagger_category = "melee",
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = 1,
			[armor_types.armored] = 0.8,
			[armor_types.resistant] = 1,
			[armor_types.player] = 1,
			[armor_types.berserker] = 1,
			[armor_types.super_armor] = 0.6,
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
	power_distribution = {
		attack = 100,
		impact = 10,
	},
	cleave_distribution = {
		attack = 1,
		impact = 1,
	},
	force_look_function = ForcedLookSettings.look_functions.medium,
	push_template = push_templates.medium,
	ogryn_push_template = push_templates.medium,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
}
damage_templates.adamant_companion_human_pounce = table.clone(damage_templates.adamant_companion_pounce)
damage_templates.adamant_companion_ogryn_pounce = table.clone(damage_templates.adamant_companion_pounce)
damage_templates.adamant_companion_ogryn_pounce.power_distribution.attack = 200
damage_templates.adamant_companion_ogryn_pounce.initial_pounce = true
damage_templates.adamant_companion_monster_pounce = table.clone(damage_templates.adamant_companion_pounce)
damage_templates.adamant_companion_monster_pounce.power_distribution.attack = 300
damage_templates.adamant_companion_monster_pounce.initial_pounce = true
damage_templates.adamant_companion_initial_pounce = {
	companion_pounce = true,
	disorientation_type = "medium",
	initial_pounce = true,
	instant_ragdoll_delay = 0.05,
	interrupt_alternate_fire = true,
	ogryn_disorientation_type = "ogryn_medium",
	stagger_category = "melee",
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
	power_distribution = {
		attack = 0,
		impact = 10,
	},
	cleave_distribution = {
		attack = 1,
		impact = 1,
	},
	force_look_function = ForcedLookSettings.look_functions.medium,
	push_template = push_templates.medium,
	ogryn_push_template = push_templates.medium,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
}
damage_templates.adamant_companion_no_damage_pounce = table.clone(damage_templates.adamant_companion_initial_pounce)
damage_templates.adamant_companion_no_damage_pounce.power_distribution = {
	attack = 0,
	impact = 10,
}

return {
	base_templates = damage_templates,
	overrides = overrides,
}
