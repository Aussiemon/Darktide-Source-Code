-- chunkname: @scripts/settings/damage/damage_profiles/prop_damage_profile_templates.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local CatapultingTemplates = require("scripts/settings/damage/catapulting_templates")
local ForcedLookSettings = require("scripts/settings/damage/forced_look_settings")
local GibbingSettings = require("scripts/settings/gibbing/gibbing_settings")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local PushSettings = require("scripts/settings/damage/push_settings")
local GibbingPower = GibbingSettings.gibbing_power
local GibbingTypes = GibbingSettings.gibbing_types
local armor_types = ArmorSettings.types
local push_templates = PushSettings.push_templates
local damage_templates = {}
local overrides = {}

table.make_unique(damage_templates)
table.make_unique(overrides)

local barrel_explosion_close_admr = {
	attack = {
		[armor_types.unarmored] = 2,
		[armor_types.armored] = 2,
		[armor_types.resistant] = 10,
		[armor_types.player] = 0.15,
		[armor_types.berserker] = 2,
		[armor_types.super_armor] = 3,
		[armor_types.disgustingly_resilient] = 3,
		[armor_types.void_shield] = 0.75,
	},
	impact = {
		[armor_types.unarmored] = 2,
		[armor_types.armored] = 2,
		[armor_types.resistant] = 10,
		[armor_types.player] = 2,
		[armor_types.berserker] = 2,
		[armor_types.super_armor] = 5,
		[armor_types.disgustingly_resilient] = 2,
		[armor_types.void_shield] = 2,
	},
}
local barrel_explosion_far_admr = {
	attack = {
		[armor_types.unarmored] = 1.5,
		[armor_types.armored] = 1.5,
		[armor_types.resistant] = 6,
		[armor_types.player] = 0.15,
		[armor_types.berserker] = 1.5,
		[armor_types.super_armor] = 2,
		[armor_types.disgustingly_resilient] = 2,
		[armor_types.void_shield] = 0.75,
	},
	impact = {
		[armor_types.unarmored] = 2,
		[armor_types.armored] = 2,
		[armor_types.resistant] = 10,
		[armor_types.player] = 2,
		[armor_types.berserker] = 2,
		[armor_types.super_armor] = 5,
		[armor_types.disgustingly_resilient] = 2,
		[armor_types.void_shield] = 2,
	},
}
local fire_barrel_explosion_close_admr = {
	attack = {
		[armor_types.unarmored] = 1,
		[armor_types.armored] = 1,
		[armor_types.resistant] = 2,
		[armor_types.player] = 0.15,
		[armor_types.berserker] = 1,
		[armor_types.super_armor] = 0.2,
		[armor_types.disgustingly_resilient] = 0.75,
		[armor_types.void_shield] = 0.75,
	},
	impact = {
		[armor_types.unarmored] = 1,
		[armor_types.armored] = 1,
		[armor_types.resistant] = 1,
		[armor_types.player] = 2,
		[armor_types.berserker] = 1,
		[armor_types.super_armor] = 1,
		[armor_types.disgustingly_resilient] = 1,
		[armor_types.void_shield] = 1,
	},
}
local fire_barrel_explosion_far_admr = {
	attack = {
		[armor_types.unarmored] = 1,
		[armor_types.armored] = 1,
		[armor_types.resistant] = 1,
		[armor_types.player] = 0.15,
		[armor_types.berserker] = 1,
		[armor_types.super_armor] = 0.2,
		[armor_types.disgustingly_resilient] = 0.75,
		[armor_types.void_shield] = 0.75,
	},
	impact = {
		[armor_types.unarmored] = 1,
		[armor_types.armored] = 1,
		[armor_types.resistant] = 1,
		[armor_types.player] = 2,
		[armor_types.berserker] = 1,
		[armor_types.super_armor] = 1,
		[armor_types.disgustingly_resilient] = 1,
		[armor_types.void_shield] = 1,
	},
}
local breach_charge_explosion_close = {
	attack = {
		[armor_types.unarmored] = 1,
		[armor_types.armored] = 1,
		[armor_types.resistant] = 2,
		[armor_types.player] = 1,
		[armor_types.berserker] = 1,
		[armor_types.super_armor] = 0.2,
		[armor_types.disgustingly_resilient] = 0.75,
		[armor_types.void_shield] = 0.75,
	},
	impact = {
		[armor_types.unarmored] = 1,
		[armor_types.armored] = 1,
		[armor_types.resistant] = 1,
		[armor_types.player] = 0,
		[armor_types.berserker] = 1,
		[armor_types.super_armor] = 1,
		[armor_types.disgustingly_resilient] = 1,
		[armor_types.void_shield] = 1,
	},
}

damage_templates.barrel_explosion_close = {
	disorientation_type = "grenadier",
	ignore_stagger_reduction = true,
	ignore_stun_immunity = true,
	ignore_toughness = true,
	interrupt_alternate_fire = true,
	ogryn_disorientation_type = "grenadier",
	override_allow_friendly_fire = true,
	ragdoll_push_force = 1000,
	stagger_category = "explosion",
	suppression_value = 20,
	cleave_distribution = {
		attack = 0.1,
		impact = 0.15,
	},
	armor_damage_modifier_ranged = {
		near = barrel_explosion_close_admr,
		far = barrel_explosion_far_admr,
	},
	power_distribution_ranged = {
		attack = {
			far = 10,
			near = 100,
		},
		impact = {
			far = 2,
			near = 30,
		},
	},
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
	power_distribution = {
		attack = 300,
		impact = 100,
	},
	force_look_function = ForcedLookSettings.look_functions.heavy,
	push_template = push_templates.grenadier_explosion,
	catapulting_template = CatapultingTemplates.barrel_explosion,
	gibbing_type = GibbingTypes.explosion,
	gibbing_power = GibbingPower.heavy,
}
damage_templates.fire_barrel_explosion = {
	disorientation_type = "grenadier",
	ignore_stagger_reduction = true,
	ignore_stun_immunity = true,
	ignore_toughness = true,
	interrupt_alternate_fire = true,
	ogryn_disorientation_type = "grenadier",
	override_allow_friendly_fire = true,
	ragdoll_push_force = 1000,
	stagger_category = "explosion",
	suppression_value = 20,
	cleave_distribution = {
		attack = 0.1,
		impact = 0.15,
	},
	armor_damage_modifier_ranged = {
		near = fire_barrel_explosion_close_admr,
		far = fire_barrel_explosion_far_admr,
	},
	power_distribution_ranged = {
		attack = {
			far = 10,
			near = 10,
		},
		impact = {
			far = 2,
			near = 30,
		},
	},
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
	power_distribution = {
		attack = 10,
		impact = 10,
	},
	force_look_function = ForcedLookSettings.look_functions.heavy,
	push_template = push_templates.grenadier_explosion,
	catapulting_template = CatapultingTemplates.barrel_explosion,
	gibbing_type = GibbingTypes.explosion,
	gibbing_power = GibbingPower.heavy,
}
damage_templates.barrel_explosion = table.clone(damage_templates.barrel_explosion_close)
damage_templates.barrel_explosion.power_distribution = {
	attack = 100,
	impact = 50,
}
damage_templates.fire_barrel_explosion_close = table.clone(damage_templates.fire_barrel_explosion)
damage_templates.fire_barrel_explosion_close.power_distribution = {
	attack = 50,
	impact = 20,
}
damage_templates.barrel_explosion.barrel_explosion = nil
damage_templates.corruptor_emerge_explosion = {
	disorientation_type = "grenadier",
	ignore_stagger_reduction = true,
	ignore_stun_immunity = true,
	ignore_toughness = true,
	interrupt_alternate_fire = true,
	ogryn_disorientation_type = "grenadier",
	ragdoll_push_force = 1000,
	stagger_category = "explosion",
	suppression_value = 3,
	cleave_distribution = {
		attack = 0.15,
		impact = 0.15,
	},
	armor_damage_modifier_ranged = {
		near = barrel_explosion_close_admr,
		far = barrel_explosion_close_admr,
	},
	targets = {
		default_target = {
			armor_damage_modifier_ranged = {
				near = barrel_explosion_close_admr,
				far = barrel_explosion_close_admr,
			},
		},
	},
	power_distribution = {
		attack = 0,
		impact = 4,
	},
	force_look_function = ForcedLookSettings.look_functions.to_or_from_attack_direction,
	push_template = push_templates.grenadier_explosion,
	catapulting_template = CatapultingTemplates.corruptor_emerge_explosion,
}
damage_templates.nurgle_head_parasite = table.clone(damage_templates.corruptor_emerge_explosion)
damage_templates.nurgle_head_parasite.ignore_toughness = false
damage_templates.nurgle_head_parasite.permanent_damage_ratio = 0.5
damage_templates.nurgle_head_parasite.power_distribution = {
	attack = 100,
	impact = 50,
}
damage_templates.corruptor_damage_tick = {
	ignore_toughness = true,
	permanent_damage_ratio = 1,
	stagger_category = "ranged",
	cleave_distribution = {
		attack = 0.15,
		impact = 0.15,
	},
	armor_damage_modifier_ranged = {
		near = barrel_explosion_close_admr,
		far = barrel_explosion_close_admr,
	},
	targets = {
		default_target = {
			armor_damage_modifier_ranged = {
				near = barrel_explosion_close_admr,
				far = barrel_explosion_close_admr,
			},
		},
	},
	power_distribution = {
		attack = 0.3,
		impact = 4,
	},
}
damage_templates.breach_charge_explosion = {
	disorientation_type = "grenadier",
	ignore_stagger_reduction = true,
	ignore_stun_immunity = true,
	ignore_toughness = false,
	interrupt_alternate_fire = true,
	ogryn_disorientation_type = "grenadier",
	ragdoll_push_force = 1000,
	stagger_category = "explosion",
	suppression_value = 3,
	cleave_distribution = {
		attack = 0.15,
		impact = 0.15,
	},
	armor_damage_modifier_ranged = {
		near = breach_charge_explosion_close,
		far = breach_charge_explosion_close,
	},
	targets = {
		default_target = {
			armor_damage_modifier_ranged = {
				near = breach_charge_explosion_close,
				far = breach_charge_explosion_close,
			},
		},
	},
	power_distribution = {
		attack = 1,
		impact = 4,
	},
	force_look_function = ForcedLookSettings.look_functions.to_or_from_attack_direction,
	push_template = push_templates.grenadier_explosion,
	catapulting_template = CatapultingTemplates.breach_charge_catapult,
}
damage_templates.flamer_backpack_explosion_close = {
	disorientation_type = "grenadier",
	ignore_stagger_reduction = true,
	ignore_stun_immunity = true,
	ignore_toughness = false,
	interrupt_alternate_fire = true,
	ogryn_disorientation_type = "grenadier",
	override_allow_friendly_fire = true,
	ragdoll_push_force = 500,
	stagger_category = "explosion",
	suppression_value = 20,
	cleave_distribution = {
		attack = 0.1,
		impact = 0.15,
	},
	armor_damage_modifier_ranged = {
		near = barrel_explosion_close_admr,
		far = barrel_explosion_far_admr,
	},
	power_distribution_ranged = {
		attack = {
			far = 10,
			near = 100,
		},
		impact = {
			far = 2,
			near = 30,
		},
	},
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
	power_distribution = {
		attack = 300,
		impact = 100,
	},
	force_look_function = ForcedLookSettings.look_functions.heavy,
	push_template = push_templates.grenadier_explosion,
	catapulting_template = CatapultingTemplates.flamer_explosion,
	gibbing_type = GibbingTypes.implosion,
	gibbing_power = GibbingPower.heavy,
}
damage_templates.flamer_backpack_explosion = table.clone(damage_templates.flamer_backpack_explosion_close)
damage_templates.flamer_backpack_explosion_close.power_distribution = {
	attack = 100,
	impact = 50,
}
damage_templates.interrupted_flamer_backpack_explosion_close = {
	disorientation_type = "grenadier",
	ignore_stagger_reduction = true,
	ignore_stun_immunity = true,
	ignore_toughness = false,
	interrupt_alternate_fire = true,
	ogryn_disorientation_type = "grenadier",
	override_allow_friendly_fire = true,
	ragdoll_push_force = 500,
	stagger_category = "explosion",
	suppression_value = 20,
	cleave_distribution = {
		attack = 0.1,
		impact = 0.15,
	},
	armor_damage_modifier_ranged = {
		near = barrel_explosion_close_admr,
		far = barrel_explosion_far_admr,
	},
	power_distribution_ranged = {
		attack = {
			far = 10,
			near = 100,
		},
		impact = {
			far = 2,
			near = 30,
		},
	},
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
	power_distribution = {
		attack = 150,
		impact = 75,
	},
	force_look_function = ForcedLookSettings.look_functions.heavy,
	push_template = push_templates.grenadier_explosion,
	catapulting_template = CatapultingTemplates.interrupted_flamer_explosion,
	gibbing_type = GibbingTypes.implosion,
	gibbing_power = GibbingPower.heavy,
}
damage_templates.interrupted_flamer_backpack_explosion = table.clone(damage_templates.interrupted_flamer_backpack_explosion_close)
damage_templates.interrupted_flamer_backpack_explosion.power_distribution = {
	attack = 75,
	impact = 25,
}

local tank_wall_explosion_close_admr = {
	attack = {
		[armor_types.unarmored] = 2,
		[armor_types.armored] = 2,
		[armor_types.resistant] = 10,
		[armor_types.player] = 0.25,
		[armor_types.berserker] = 2,
		[armor_types.super_armor] = 3,
		[armor_types.disgustingly_resilient] = 3,
		[armor_types.void_shield] = 0.75,
	},
	impact = {
		[armor_types.unarmored] = 2,
		[armor_types.armored] = 2,
		[armor_types.resistant] = 10,
		[armor_types.player] = 2,
		[armor_types.berserker] = 2,
		[armor_types.super_armor] = 5,
		[armor_types.disgustingly_resilient] = 2,
		[armor_types.void_shield] = 2,
	},
}

damage_templates.no_mans_land_tank_wall_explosion = {
	disorientation_type = "grenadier",
	ignore_stagger_reduction = true,
	ignore_stun_immunity = true,
	ignore_toughness = false,
	interrupt_alternate_fire = true,
	ogryn_disorientation_type = "grenadier",
	ragdoll_push_force = 1000,
	stagger_category = "explosion",
	suppression_value = 3,
	power_distribution = {
		attack = 100,
		impact = 4,
	},
	cleave_distribution = {
		attack = 0.15,
		impact = 0.15,
	},
	armor_damage_modifier_ranged = {
		near = tank_wall_explosion_close_admr,
		far = tank_wall_explosion_close_admr,
	},
	targets = {
		default_target = {
			armor_damage_modifier_ranged = {
				near = tank_wall_explosion_close_admr,
				far = tank_wall_explosion_close_admr,
			},
		},
	},
	force_look_function = ForcedLookSettings.look_functions.to_or_from_attack_direction,
	push_template = push_templates.grenadier_explosion,
	catapulting_template = CatapultingTemplates.breach_charge_catapult,
}

return {
	base_templates = damage_templates,
	overrides = overrides,
}
