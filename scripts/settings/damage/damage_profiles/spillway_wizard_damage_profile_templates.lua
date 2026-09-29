-- chunkname: @scripts/settings/damage/damage_profiles/spillway_wizard_damage_profile_templates.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local CatapultingTemplates = require("scripts/settings/damage/catapulting_templates")
local DamageProfileSettings = require("scripts/settings/damage/damage_profile_settings")
local ForcedLookSettings = require("scripts/settings/damage/forced_look_settings")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local PushSettings = require("scripts/settings/damage/push_settings")
local armor_types = ArmorSettings.types
local push_templates = PushSettings.push_templates
local damage_templates = {}
local overrides = {}

table.make_unique(damage_templates)
table.make_unique(overrides)

local default_armor_mod = DamageProfileSettings.default_armor_mod

damage_templates.spillway_wizard_dance_floor_burn = {
	disorientation_type = "heavy",
	interrupt_alternate_fire = true,
	ogryn_disorientation_type = "ogryn_heavy",
	stagger_category = "melee",
	toughness_multiplier = 2,
	unblockable = true,
	undodgeable = true,
	armor_damage_modifier = {
		attack = default_armor_mod,
		impact = default_armor_mod,
	},
	power_distribution = {
		attack = 0.5,
		impact = 2,
	},
	cleave_distribution = {
		attack = 0.25,
		impact = 0.25,
	},
	force_look_function = ForcedLookSettings.look_functions.heavy,
	push_template = push_templates.renegade_flamer_push,
	ogryn_push_template = push_templates.renegade_flamer_push,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
}
damage_templates.spillway_wizard_dance_wall_knockback = {
	disorientation_type = "medium",
	interrupt_alternate_fire = true,
	ogryn_disorientation_type = "ogryn_medium",
	stagger_category = "melee",
	toughness_multiplier = 2,
	armor_damage_modifier = {
		attack = default_armor_mod,
		impact = default_armor_mod,
	},
	power_distribution = {
		attack = 15,
		impact = 0.5,
	},
	cleave_distribution = {
		attack = 0.25,
		impact = 0.25,
	},
	force_look_function = ForcedLookSettings.look_functions.medium,
	push_template = push_templates.chaos_ogryn_houndmaster_charge,
	catapulting_template = CatapultingTemplates.houndmaster_catapult,
	ogryn_push_template = push_templates.chaos_ogryn_houndmaster_charge_ogrym,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
}
damage_templates.spillway_wizard_shockwave_wall_slam = {
	disorientation_type = "falling_light",
	ignore_shield = true,
	ignore_toughness = false,
	interrupt_alternate_fire = true,
	ogryn_disorientation_type = "falling_light",
	stagger_category = "ranged",
	armor_damage_modifier = {
		attack = default_armor_mod,
		impact = default_armor_mod,
	},
	power_distribution = {
		attack = 0.4,
		impact = 0.4,
	},
	cleave_distribution = {
		attack = 0.25,
		impact = 0.25,
	},
	force_look_function = ForcedLookSettings.look_functions.light,
	push_template = push_templates.heavy,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
}
damage_templates.spillway_wizard_melee_kick = {
	disorientation_type = "heavy",
	interrupt_alternate_fire = true,
	ogryn_disorientation_type = "medium",
	stagger_category = "melee",
	toughness_multiplier = 2,
	armor_damage_modifier = {
		attack = default_armor_mod,
		impact = default_armor_mod,
	},
	power_distribution = {
		attack = 0.125,
		impact = 0.5,
	},
	cleave_distribution = {
		attack = 0.25,
		impact = 0.25,
	},
	force_look_function = ForcedLookSettings.look_functions.heavy,
	push_template = push_templates.shield_push,
	ogryn_push_template = push_templates.shield_push,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
}
damage_templates.spillway_wizard_force_ball_impact = {
	gibbing_power = 0,
	gibbing_type = 0,
	ignore_shield = false,
	ignore_stagger_reduction = false,
	ragdoll_push_force = 150,
	shield_override_stagger_strength = 0,
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
				[armor_types.disgustingly_resilient] = 1,
				[armor_types.void_shield] = 1,
			},
			impact = {
				[armor_types.unarmored] = 2,
				[armor_types.armored] = 5,
				[armor_types.resistant] = 2,
				[armor_types.player] = 2,
				[armor_types.berserker] = 2,
				[armor_types.super_armor] = 2,
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

return {
	base_templates = damage_templates,
	overrides = overrides,
}
