local ArmorSettings = require("scripts/settings/damage/armor_settings")
local CatapultingTemplates = require("scripts/settings/damage/catapulting_templates")
local DamageProfileSettings = require("scripts/settings/damage/damage_profile_settings")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local ForcedLookSettings = require("scripts/settings/damage/forced_look_settings")
local GibbingSettings = require("scripts/settings/gibbing/gibbing_settings")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local PushSettings = require("scripts/settings/damage/push_settings")
local armor_types = ArmorSettings.types
local gibbing_power = GibbingSettings.gibbing_power
local gibbing_types = GibbingSettings.gibbing_types
local push_templates = PushSettings.push_templates
local damage_templates = {}
local overrides = {}

table.make_unique(damage_templates)
table.make_unique(overrides)

local flat_one_armor_mod = DamageProfileSettings.flat_one_armor_mod
local default_armor_mod = DamageProfileSettings.default_armor_mod
local crit_armor_mod = DamageProfileSettings.crit_armor_mod
local crit_impact_armor_mod = DamageProfileSettings.crit_impact_armor_mod
local damage_types = DamageSettings.damage_types
local double_cleave = DamageProfileSettings.double_cleave
damage_templates.luggable_battery = {
	interrupt_alternate_fire = true,
	suppression_value = 15,
	ogryn_disorientation_type = "grenadier",
	ignore_stun_immunity = true,
	stagger_category = "ranged",
	ragdoll_push_force = 500,
	ignore_stagger_reduction = true,
	disorientation_type = "grenadier",
	cleave_distribution = {
		attack = 0.15,
		impact = 0.15
	},
	armor_damage_modifier_ranged = {
		near = {
			attack = {
				[armor_types.unarmored] = 0,
				[armor_types.armored] = 0,
				[armor_types.resistant] = 0,
				[armor_types.player] = 1,
				[armor_types.berserker] = 0,
				[armor_types.super_armor] = 0,
				[armor_types.disgustingly_resilient] = 0,
				[armor_types.void_shield] = 0
			},
			impact = {
				[armor_types.unarmored] = 2,
				[armor_types.armored] = 5,
				[armor_types.resistant] = 2,
				[armor_types.player] = 2,
				[armor_types.berserker] = 2,
				[armor_types.super_armor] = 0,
				[armor_types.disgustingly_resilient] = 2,
				[armor_types.void_shield] = 2
			}
		},
		far = {
			attack = {
				[armor_types.unarmored] = 0,
				[armor_types.armored] = 0,
				[armor_types.resistant] = 0,
				[armor_types.player] = 1,
				[armor_types.berserker] = 0,
				[armor_types.super_armor] = 0,
				[armor_types.disgustingly_resilient] = 0,
				[armor_types.void_shield] = 0
			},
			impact = {
				[armor_types.unarmored] = 2,
				[armor_types.armored] = 5,
				[armor_types.resistant] = 2,
				[armor_types.player] = 2,
				[armor_types.berserker] = 2,
				[armor_types.super_armor] = 2,
				[armor_types.disgustingly_resilient] = 2,
				[armor_types.void_shield] = 2
			}
		}
	},
	targets = {
		default_target = {
			armor_damage_modifier_ranged = {
				near = {
					attack = {
						[armor_types.unarmored] = 0,
						[armor_types.armored] = 0,
						[armor_types.resistant] = 0,
						[armor_types.player] = 1,
						[armor_types.berserker] = 0,
						[armor_types.super_armor] = 0,
						[armor_types.disgustingly_resilient] = 0,
						[armor_types.void_shield] = 0
					},
					impact = {
						[armor_types.unarmored] = 2,
						[armor_types.armored] = 5,
						[armor_types.resistant] = 2,
						[armor_types.player] = 2,
						[armor_types.berserker] = 2,
						[armor_types.super_armor] = 0,
						[armor_types.disgustingly_resilient] = 2,
						[armor_types.void_shield] = 2
					}
				},
				far = {
					attack = {
						[armor_types.unarmored] = 0,
						[armor_types.armored] = 0,
						[armor_types.resistant] = 0,
						[armor_types.player] = 1,
						[armor_types.berserker] = 0,
						[armor_types.super_armor] = 0,
						[armor_types.disgustingly_resilient] = 0,
						[armor_types.void_shield] = 0
					},
					impact = {
						[armor_types.unarmored] = 2,
						[armor_types.armored] = 5,
						[armor_types.resistant] = 2,
						[armor_types.player] = 2,
						[armor_types.berserker] = 2,
						[armor_types.super_armor] = 2,
						[armor_types.disgustingly_resilient] = 2,
						[armor_types.void_shield] = 2
					}
				}
			},
			power_distribution = {
				attack = 20,
				impact = 4
			}
		}
	},
	power_distribution = {
		attack = 0,
		impact = 25
	},
	force_look_function = ForcedLookSettings.look_functions.heavy,
	push_template = push_templates.grenadier_explosion
}

return {
	base_templates = damage_templates,
	overrides = overrides
}
