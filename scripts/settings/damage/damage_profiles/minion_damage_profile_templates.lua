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
damage_templates.poxwalker = {
	disorientation_type = "medium",
	permanent_damage_ratio = 0.25,
	ogryn_disorientation_type = "ogryn_medium",
	interrupt_alternate_fire = true,
	stagger_category = "melee",
	armor_damage_modifier = {
		attack = default_armor_mod,
		impact = default_armor_mod
	},
	crit_mods = {
		attack = crit_armor_mod,
		impact = crit_impact_armor_mod
	},
	power_distribution = {
		attack = 35,
		impact = 10
	},
	cleave_distribution = {
		attack = 1,
		impact = 1
	},
	force_look_function = ForcedLookSettings.look_functions.light,
	push_template = push_templates.light,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.melee_fighter_default = {
	ogryn_disorientation_type = "ogryn_medium",
	stagger_category = "melee",
	interrupt_alternate_fire = true,
	disorientation_type = "medium",
	armor_damage_modifier = {
		attack = default_armor_mod,
		impact = default_armor_mod
	},
	power_distribution = {
		attack = 40,
		impact = 10
	},
	cleave_distribution = {
		attack = 1,
		impact = 1
	},
	force_look_function = ForcedLookSettings.look_functions.medium,
	push_template = push_templates.medium,
	ogryn_push_template = push_templates.medium,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.melee_bruiser_default = {
	ogryn_disorientation_type = "ogryn_medium",
	melee_toughness_multiplier = 1.5,
	stagger_category = "melee",
	interrupt_alternate_fire = true,
	disorientation_type = "medium",
	armor_damage_modifier = {
		attack = default_armor_mod,
		impact = default_armor_mod
	},
	power_distribution = {
		attack = 40,
		impact = 10
	},
	cleave_distribution = {
		attack = 1,
		impact = 1
	},
	force_look_function = ForcedLookSettings.look_functions.medium,
	push_template = push_templates.medium,
	ogryn_push_template = push_templates.medium,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.horde_melee_default = {
	ogryn_disorientation_type = "ogryn_medium",
	melee_toughness_multiplier = 1,
	stagger_category = "melee",
	interrupt_alternate_fire = true,
	disorientation_type = "medium",
	armor_damage_modifier = {
		attack = default_armor_mod,
		impact = default_armor_mod
	},
	power_distribution = {
		attack = 35,
		impact = 10
	},
	cleave_distribution = {
		attack = 1,
		impact = 1
	},
	force_look_function = ForcedLookSettings.look_functions.medium,
	push_template = push_templates.medium,
	ogryn_push_template = push_templates.medium,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.melee_berzerker_combo = {
	ogryn_disorientation_type = "ogryn_berzerker_combo",
	melee_toughness_multiplier = 1.5,
	stagger_category = "melee",
	block_cost_multiplier = 0.75,
	interrupt_alternate_fire = true,
	disorientation_type = "berzerker_combo",
	armor_damage_modifier = {
		attack = default_armor_mod,
		impact = default_armor_mod
	},
	power_distribution = {
		attack = 15,
		impact = 10
	},
	cleave_distribution = {
		attack = 1,
		impact = 1
	},
	force_look_function = ForcedLookSettings.look_functions.medium,
	push_template = push_templates.medium,
	ogryn_push_template = push_templates.medium,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.renegade_captain_melee_default = {
	disorientation_type = "heavy",
	stagger_category = "melee",
	toughness_multiplier = 2,
	interrupt_alternate_fire = true,
	ogryn_disorientation_type = "ogryn_heavy",
	armor_damage_modifier = {
		attack = default_armor_mod,
		impact = default_armor_mod
	},
	crit_mods = {
		attack = crit_armor_mod,
		impact = crit_impact_armor_mod
	},
	power_distribution = {
		attack = 60,
		impact = 0.5
	},
	cleave_distribution = {
		attack = 0.25,
		impact = 0.25
	},
	force_look_function = ForcedLookSettings.look_functions.heavy,
	push_template = push_templates.renegade_captain_light,
	ogryn_push_template = push_templates.renegade_captain_light,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.renegade_captain_power_sword_melee_sweep = {
	disorientation_type = "heavy",
	stagger_category = "melee",
	toughness_multiplier = 2,
	unblockable = true,
	interrupt_alternate_fire = true,
	ogryn_disorientation_type = "ogryn_heavy",
	armor_damage_modifier = {
		attack = default_armor_mod,
		impact = default_armor_mod
	},
	crit_mods = {
		attack = crit_armor_mod,
		impact = crit_impact_armor_mod
	},
	power_distribution = {
		attack = 100,
		impact = 0.5
	},
	cleave_distribution = {
		attack = 0.25,
		impact = 0.25
	},
	force_look_function = ForcedLookSettings.look_functions.heavy,
	push_template = push_templates.renegade_captain,
	ogryn_push_template = push_templates.renegade_captain,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.renegade_captain_powermaul_ground_slam = {
	disorientation_type = "heavy",
	stagger_category = "melee",
	toughness_multiplier = 2,
	unblockable = true,
	interrupt_alternate_fire = true,
	ogryn_disorientation_type = "ogryn_heavy",
	armor_damage_modifier = {
		attack = default_armor_mod,
		impact = default_armor_mod
	},
	crit_mods = {
		attack = crit_armor_mod,
		impact = crit_impact_armor_mod
	},
	power_distribution = {
		attack = 60,
		impact = 0.5
	},
	cleave_distribution = {
		attack = 0.25,
		impact = 0.25
	},
	force_look_function = ForcedLookSettings.look_functions.heavy,
	push_template = push_templates.renegade_captain_heavy,
	ogryn_push_template = push_templates.renegade_captain_heavy,
	catapulting_template = CatapultingTemplates.renegade_captain_powermaul_ground_slam_catapult,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.renegade_captain_powermaul_melee_cleave = {
	disorientation_type = "heavy",
	stagger_category = "melee",
	toughness_multiplier = 2,
	unblockable = true,
	interrupt_alternate_fire = true,
	ogryn_disorientation_type = "ogryn_heavy",
	armor_damage_modifier = {
		attack = default_armor_mod,
		impact = default_armor_mod
	},
	crit_mods = {
		attack = crit_armor_mod,
		impact = crit_impact_armor_mod
	},
	power_distribution = {
		attack = 0.75,
		impact = 0.5
	},
	cleave_distribution = {
		attack = 0.25,
		impact = 0.25
	},
	force_look_function = ForcedLookSettings.look_functions.heavy,
	push_template = push_templates.renegade_captain_heavy,
	ogryn_push_template = push_templates.renegade_captain_heavy,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.renegade_captain_charge = {
	disorientation_type = "medium",
	stagger_category = "melee",
	toughness_multiplier = 2,
	interrupt_alternate_fire = true,
	ogryn_disorientation_type = "ogryn_medium",
	armor_damage_modifier = {
		attack = default_armor_mod,
		impact = default_armor_mod
	},
	crit_mods = {
		attack = crit_armor_mod,
		impact = crit_impact_armor_mod
	},
	power_distribution = {
		attack = 15,
		impact = 0.5
	},
	cleave_distribution = {
		attack = 0.25,
		impact = 0.25
	},
	force_look_function = ForcedLookSettings.look_functions.medium,
	push_template = push_templates.renegade_captain,
	ogryn_push_template = push_templates.renegade_captain_light,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.twin_dash = {
	disorientation_type = "medium",
	stagger_category = "melee",
	toughness_multiplier = 2,
	interrupt_alternate_fire = true,
	ogryn_disorientation_type = "ogryn_medium",
	armor_damage_modifier = {
		attack = default_armor_mod,
		impact = default_armor_mod
	},
	crit_mods = {
		attack = crit_armor_mod,
		impact = crit_impact_armor_mod
	},
	power_distribution = {
		attack = 15,
		impact = 0.5
	},
	cleave_distribution = {
		attack = 0.25,
		impact = 0.25
	},
	force_look_function = ForcedLookSettings.look_functions.medium,
	push_template = push_templates.twin_dash,
	ogryn_push_template = push_templates.twin_dash_light,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.twin_dash_light = {
	disorientation_type = "medium",
	stagger_category = "melee",
	toughness_multiplier = 2,
	interrupt_alternate_fire = true,
	ogryn_disorientation_type = "ogryn_medium",
	armor_damage_modifier = {
		attack = default_armor_mod,
		impact = default_armor_mod
	},
	crit_mods = {
		attack = crit_armor_mod,
		impact = crit_impact_armor_mod
	},
	power_distribution = {
		attack = 15,
		impact = 0.5
	},
	cleave_distribution = {
		attack = 0.25,
		impact = 0.25
	},
	force_look_function = ForcedLookSettings.look_functions.medium,
	push_template = push_templates.twin_dash_light,
	ogryn_push_template = push_templates.twin_dash_light,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.renegade_captain_minion_charge_push = {
	stagger_override = "explosion",
	disorientation_type = "heavy",
	stagger_category = "melee",
	toughness_multiplier = 2,
	unblockable = true,
	interrupt_alternate_fire = true,
	ogryn_disorientation_type = "ogryn_heavy",
	armor_damage_modifier = {
		attack = flat_one_armor_mod,
		impact = flat_one_armor_mod
	},
	crit_mods = {
		attack = flat_one_armor_mod,
		impact = flat_one_armor_mod
	},
	power_distribution = {
		attack = 0.001,
		impact = 2
	},
	cleave_distribution = {
		attack = 0.25,
		impact = 0.25
	},
	force_look_function = ForcedLookSettings.look_functions.heavy,
	push_template = push_templates.shield_push,
	ragdoll_push_force = {
		1500,
		3000
	},
	gibbing_power = gibbing_power.heavy,
	gibbing_type = gibbing_types.explosion,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.melee_roamer_default = {
	disorientation_type = "light",
	stagger_category = "melee",
	toughness_multiplier = 2,
	interrupt_alternate_fire = true,
	ogryn_disorientation_type = "ogryn_light",
	armor_damage_modifier = {
		attack = default_armor_mod,
		impact = default_armor_mod
	},
	crit_mods = {
		attack = crit_armor_mod,
		impact = crit_impact_armor_mod
	},
	power_distribution = {
		attack = 0.075,
		impact = 0.5
	},
	cleave_distribution = {
		attack = 0.25,
		impact = 0.25
	},
	force_look_function = ForcedLookSettings.look_functions.light,
	push_template = push_templates.light,
	ogryn_push_template = push_templates.light,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.chaos_spawn_combo = {
	ogryn_disorientation_type = "ogryn_light",
	block_cost_multiplier = 1.25,
	stagger_category = "melee",
	interrupt_alternate_fire = true,
	disorientation_type = "light",
	armor_damage_modifier = {
		attack = default_armor_mod,
		impact = default_armor_mod
	},
	crit_mods = {
		attack = crit_armor_mod,
		impact = crit_impact_armor_mod
	},
	power_distribution = {
		attack = 30,
		impact = 50
	},
	cleave_distribution = {
		attack = 0.25,
		impact = 0.25
	},
	push_template = push_templates.chaos_spawn_combo,
	ogryn_push_template = push_templates.chaos_spawn_combo,
	force_look_function = ForcedLookSettings.look_functions.to_or_from_attack_direction,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.chaos_spawn_combo_heavy = {
	ogryn_disorientation_type = "ogryn_light",
	block_cost_multiplier = 1.85,
	stagger_category = "melee",
	interrupt_alternate_fire = true,
	disorientation_type = "light",
	armor_damage_modifier = {
		attack = default_armor_mod,
		impact = default_armor_mod
	},
	crit_mods = {
		attack = crit_armor_mod,
		impact = crit_impact_armor_mod
	},
	power_distribution = {
		attack = 35,
		impact = 50
	},
	cleave_distribution = {
		attack = 0.25,
		impact = 0.25
	},
	push_template = push_templates.chaos_spawn_combo_heavy,
	ogryn_push_template = push_templates.chaos_spawn_combo,
	force_look_function = ForcedLookSettings.look_functions.to_or_from_attack_direction,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.monster_slam = {
	disorientation_type = "heavy",
	permanent_damage_ratio = 0.2,
	ogryn_disorientation_type = "ogryn_heavy",
	stagger_category = "melee",
	toughness_multiplier = 2,
	unblockable = true,
	interrupt_alternate_fire = true,
	armor_damage_modifier = {
		attack = default_armor_mod,
		impact = default_armor_mod
	},
	crit_mods = {
		attack = crit_armor_mod,
		impact = crit_impact_armor_mod
	},
	power_distribution = {
		attack = 80,
		impact = 50
	},
	cleave_distribution = {
		attack = 0.25,
		impact = 0.25
	},
	push_template = push_templates.plague_ogryn_medium,
	ogryn_push_template = push_templates.plague_ogryn_light,
	force_look_function = ForcedLookSettings.look_functions.heavy,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.chaos_spawn_claw = {
	block_cost_multiplier = 2.5,
	disorientation_type = "heavy",
	ogryn_disorientation_type = "ogryn_heavy",
	stagger_category = "melee",
	toughness_multiplier = 2,
	interrupt_alternate_fire = true,
	armor_damage_modifier = {
		attack = default_armor_mod,
		impact = default_armor_mod
	},
	crit_mods = {
		attack = crit_armor_mod,
		impact = crit_impact_armor_mod
	},
	power_distribution = {
		attack = 60,
		impact = 50
	},
	cleave_distribution = {
		attack = 0.25,
		impact = 0.25
	},
	push_template = push_templates.plague_ogryn_medium,
	ogryn_push_template = push_templates.plague_ogryn_light,
	force_look_function = ForcedLookSettings.look_functions.heavy,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.chaos_plague_ogryn_scythe = {
	disorientation_type = "medium",
	permanent_damage_ratio = 0.4,
	melee_toughness_multiplier = 2,
	ogryn_disorientation_type = "ogryn_medium",
	block_cost_multiplier = 2.5,
	stagger_category = "melee",
	interrupt_alternate_fire = true,
	armor_damage_modifier = {
		attack = default_armor_mod,
		impact = default_armor_mod
	},
	crit_mods = {
		attack = crit_armor_mod,
		impact = crit_impact_armor_mod
	},
	power_distribution = {
		attack = 50,
		impact = 50
	},
	cleave_distribution = {
		attack = 0.25,
		impact = 0.25
	},
	push_template = push_templates.plague_ogryn_medium,
	ogryn_push_template = push_templates.plague_ogryn_light,
	force_look_function = ForcedLookSettings.look_functions.to_or_from_attack_direction,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.chaos_plague_ogryn_catapult = {
	block_cost_multiplier = 10,
	melee_toughness_multiplier = 2,
	ignore_stun_immunity = true,
	stagger_category = "melee",
	toughness_multiplier = 2,
	interrupt_alternate_fire = true,
	armor_damage_modifier = {
		attack = default_armor_mod,
		impact = default_armor_mod
	},
	crit_mods = {
		attack = crit_armor_mod,
		impact = crit_impact_armor_mod
	},
	power_distribution = {
		attack = 10,
		impact = 50
	},
	cleave_distribution = {
		attack = 0.25,
		impact = 0.25
	},
	push_template = push_templates.plague_ogryn_medium,
	ogryn_push_template = push_templates.plague_ogryn_medium,
	catapulting_template = CatapultingTemplates.plague_ogryn_catapult,
	force_look_function = ForcedLookSettings.look_functions.to_or_from_attack_direction,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.chaos_spawn_grab_smash = {
	block_cost_multiplier = 2,
	melee_toughness_multiplier = 2,
	stagger_category = "melee",
	toughness_multiplier = 2,
	interrupt_alternate_fire = true,
	armor_damage_modifier = {
		attack = default_armor_mod,
		impact = default_armor_mod
	},
	crit_mods = {
		attack = crit_armor_mod,
		impact = crit_impact_armor_mod
	},
	power_distribution = {
		attack = 15,
		impact = 50
	},
	cleave_distribution = {
		attack = 0.25,
		impact = 0.25
	},
	push_template = push_templates.chaos_spawn_tentacle,
	ogryn_push_template = push_templates.chaos_spawn_tentacle,
	catapulting_template = CatapultingTemplates.plague_ogryn_catapult,
	force_look_function = ForcedLookSettings.look_functions.to_or_from_attack_direction,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.chaos_plague_ogryn_charge = {
	block_cost_multiplier = 10,
	stagger_category = "melee",
	ignore_stun_immunity = true,
	toughness_multiplier = 2,
	interrupt_alternate_fire = true,
	armor_damage_modifier = {
		attack = default_armor_mod,
		impact = default_armor_mod
	},
	crit_mods = {
		attack = crit_armor_mod,
		impact = crit_impact_armor_mod
	},
	power_distribution = {
		attack = 40,
		impact = 50
	},
	cleave_distribution = {
		attack = 0.25,
		impact = 0.25
	},
	force_look_function = ForcedLookSettings.look_functions.medium,
	push_template = push_templates.plague_ogryn_charge,
	ogryn_push_template = push_templates.plague_ogryn_medium,
	catapulting_template = CatapultingTemplates.plague_ogryn_catapult,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.chaos_plague_ogryn_minion_charge_push = {
	stagger_override = "explosion",
	disorientation_type = "heavy",
	stagger_category = "melee",
	toughness_multiplier = 2,
	unblockable = true,
	interrupt_alternate_fire = true,
	ogryn_disorientation_type = "ogryn_heavy",
	armor_damage_modifier = {
		attack = flat_one_armor_mod,
		impact = flat_one_armor_mod
	},
	crit_mods = {
		attack = flat_one_armor_mod,
		impact = flat_one_armor_mod
	},
	power_distribution = {
		attack = 0.001,
		impact = 2
	},
	cleave_distribution = {
		attack = 0.25,
		impact = 0.25
	},
	force_look_function = ForcedLookSettings.look_functions.heavy,
	push_template = push_templates.shield_push,
	ragdoll_push_force = {
		1500,
		3000
	},
	gibbing_power = gibbing_power.heavy,
	gibbing_type = gibbing_types.explosion,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.chaos_plague_ogryn_plague_stomp = {
	stagger_category = "melee",
	toughness_multiplier = 2,
	melee_toughness_multiplier = 2,
	ignore_stun_immunity = true,
	unblockable = true,
	interrupt_alternate_fire = true,
	armor_damage_modifier = {
		attack = default_armor_mod,
		impact = default_armor_mod
	},
	power_distribution = {
		attack = 30,
		impact = 50
	},
	cleave_distribution = {
		attack = 0.25,
		impact = 0.25
	},
	push_template = push_templates.plague_ogryn_medium,
	ogryn_push_template = push_templates.plague_ogryn_medium,
	catapulting_template = CatapultingTemplates.plague_ogryn_catapult,
	force_look_function = ForcedLookSettings.look_functions.heavy,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.renegade_captain_punch = {
	ogryn_disorientation_type = "ogryn_heavy",
	stagger_category = "melee",
	toughness_multiplier = 2,
	interrupt_alternate_fire = true,
	disorientation_type = "heavy",
	armor_damage_modifier = {
		attack = default_armor_mod,
		impact = default_armor_mod
	},
	power_distribution = {
		attack = 10,
		impact = 0.5
	},
	cleave_distribution = {
		attack = 0.25,
		impact = 0.25
	},
	force_look_function = ForcedLookSettings.look_functions.heavy,
	push_template = push_templates.renegade_captain,
	ogryn_push_template = push_templates.renegade_captain,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.renegade_captain_kick = {
	disorientation_type = "heavy",
	stagger_category = "melee",
	toughness_multiplier = 1,
	interrupt_alternate_fire = true,
	ogryn_disorientation_type = "ogryn_heavy",
	armor_damage_modifier = {
		attack = default_armor_mod,
		impact = default_armor_mod
	},
	crit_mods = {
		attack = crit_armor_mod,
		impact = crit_impact_armor_mod
	},
	power_distribution = {
		attack = 10,
		impact = 0.5
	},
	cleave_distribution = {
		attack = 0.25,
		impact = 0.25
	},
	force_look_function = ForcedLookSettings.look_functions.heavy,
	push_template = push_templates.renegade_captain,
	ogryn_push_template = push_templates.renegade_captain,
	catapulting_template = CatapultingTemplates.renegade_captain_kick_catapult,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.renegade_captain_bolt_pistol = {
	disorientation_type = "heavy",
	suppression_value = 10,
	stagger_category = "ranged",
	toughness_multiplier = 3,
	ragdoll_push_force = 500,
	interrupt_alternate_fire = true,
	ogryn_disorientation_type = "ogryn_heavy",
	cleave_distribution = double_cleave,
	ranges = {
		max = 40,
		min = 10
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
				[armor_types.unarmored] = 1,
				[armor_types.armored] = 1,
				[armor_types.resistant] = 1,
				[armor_types.player] = 1,
				[armor_types.berserker] = 0.5,
				[armor_types.super_armor] = 0,
				[armor_types.disgustingly_resilient] = 1,
				[armor_types.void_shield] = 1
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
				[armor_types.unarmored] = 1,
				[armor_types.armored] = 0.5,
				[armor_types.resistant] = 1,
				[armor_types.player] = 1,
				[armor_types.berserker] = 0.5,
				[armor_types.super_armor] = 0.5,
				[armor_types.disgustingly_resilient] = 1,
				[armor_types.void_shield] = 1
			}
		}
	},
	power_distribution = {
		attack = 15,
		impact = 1.5
	},
	damage_type = damage_types.boltshell,
	on_kill_area_suppression = {
		distance = 8,
		suppression_value = 12
	},
	push_template = push_templates.heavy,
	ogryn_push_template = push_templates.medium,
	gibbing_power = gibbing_power.heavy,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.renegade_captain_bolt_pistol_kill_explosion = {
	ragdoll_push_force = 500,
	suppression_value = 0.5,
	stagger_category = "ranged",
	cleave_distribution = {
		attack = 0.1,
		impact = 0.1
	},
	ranges = {
		max = 20,
		min = 10
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
				[armor_types.unarmored] = 1,
				[armor_types.armored] = 1,
				[armor_types.resistant] = 1,
				[armor_types.player] = 1,
				[armor_types.berserker] = 1,
				[armor_types.super_armor] = 1,
				[armor_types.disgustingly_resilient] = 1,
				[armor_types.void_shield] = 1
			}
		},
		far = {
			attack = {
				[armor_types.unarmored] = 0,
				[armor_types.armored] = 0,
				[armor_types.resistant] = 0,
				[armor_types.player] = 0,
				[armor_types.berserker] = 0,
				[armor_types.super_armor] = 0,
				[armor_types.disgustingly_resilient] = 0,
				[armor_types.void_shield] = 0
			},
			impact = {
				[armor_types.unarmored] = 1,
				[armor_types.armored] = 1,
				[armor_types.resistant] = 1,
				[armor_types.player] = 1,
				[armor_types.berserker] = 1,
				[armor_types.super_armor] = 1,
				[armor_types.disgustingly_resilient] = 1,
				[armor_types.void_shield] = 1
			}
		}
	},
	power_distribution = {
		attack = 0,
		impact = 0.35
	},
	damage_type = damage_types.boltshell,
	on_kill_area_suppression = {
		distance = 8,
		suppression_value = 12
	},
	gibbing_power = gibbing_power.medium,
	gibbing_type = gibbing_power.explosion,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.renegade_captain_bolt_pistol_stop_explosion = {
	ragdoll_push_force = 500,
	suppression_value = 0.5,
	stagger_category = "ranged",
	cleave_distribution = {
		attack = 0.1,
		impact = 0.1
	},
	ranges = {
		max = 20,
		min = 10
	},
	armor_damage_modifier_ranged = {
		near = {
			attack = {
				[armor_types.unarmored] = 0,
				[armor_types.armored] = 0,
				[armor_types.resistant] = 0,
				[armor_types.player] = 0,
				[armor_types.berserker] = 0,
				[armor_types.super_armor] = 0,
				[armor_types.disgustingly_resilient] = 0,
				[armor_types.void_shield] = 0
			},
			impact = {
				[armor_types.unarmored] = 1,
				[armor_types.armored] = 1,
				[armor_types.resistant] = 1,
				[armor_types.player] = 1,
				[armor_types.berserker] = 1,
				[armor_types.super_armor] = 0,
				[armor_types.disgustingly_resilient] = 1,
				[armor_types.void_shield] = 1
			}
		},
		far = {
			attack = {
				[armor_types.unarmored] = 0,
				[armor_types.armored] = 0,
				[armor_types.resistant] = 0,
				[armor_types.player] = 0,
				[armor_types.berserker] = 0,
				[armor_types.super_armor] = 0,
				[armor_types.disgustingly_resilient] = 0,
				[armor_types.void_shield] = 0
			},
			impact = {
				[armor_types.unarmored] = 1,
				[armor_types.armored] = 1,
				[armor_types.resistant] = 1,
				[armor_types.player] = 1,
				[armor_types.berserker] = 1,
				[armor_types.super_armor] = 1,
				[armor_types.disgustingly_resilient] = 1,
				[armor_types.void_shield] = 1
			}
		}
	},
	power_distribution = {
		attack = 0.1,
		impact = 0.2
	},
	damage_type = damage_types.boltshell,
	gibbing_power = gibbing_power.heavy,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.renegade_captain_plasma_pistol = {
	disorientation_type = "heavy",
	suppression_value = 10,
	stagger_category = "ranged",
	toughness_multiplier = 30,
	ragdoll_push_force = 500,
	interrupt_alternate_fire = true,
	ogryn_disorientation_type = "ogryn_heavy",
	cleave_distribution = double_cleave,
	ranges = {
		max = 40,
		min = 10
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
				[armor_types.unarmored] = 1,
				[armor_types.armored] = 1,
				[armor_types.resistant] = 1,
				[armor_types.player] = 1,
				[armor_types.berserker] = 0.5,
				[armor_types.super_armor] = 0,
				[armor_types.disgustingly_resilient] = 1,
				[armor_types.void_shield] = 1
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
				[armor_types.unarmored] = 1,
				[armor_types.armored] = 0.5,
				[armor_types.resistant] = 1,
				[armor_types.player] = 1,
				[armor_types.berserker] = 0.5,
				[armor_types.super_armor] = 0.5,
				[armor_types.disgustingly_resilient] = 1,
				[armor_types.void_shield] = 1
			}
		}
	},
	power_distribution = {
		attack = 30,
		impact = 1.5
	},
	damage_type = damage_types.minion_plasma,
	on_kill_area_suppression = {
		distance = 8,
		suppression_value = 12
	},
	push_template = push_templates.renegade_captain,
	ogryn_push_template = push_templates.renegade_captain,
	gibbing_power = gibbing_power.heavy,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.renegade_captain_void_shield_explosion = {
	stagger_category = "melee",
	toughness_multiplier = 2,
	unblockable = true,
	interrupt_alternate_fire = true,
	ignore_depleting_toughness = true,
	armor_damage_modifier = {
		attack = default_armor_mod,
		impact = default_armor_mod
	},
	crit_mods = {
		attack = crit_armor_mod,
		impact = crit_impact_armor_mod
	},
	power_distribution = {
		attack = 0.2,
		impact = 0.5
	},
	cleave_distribution = {
		attack = 0.25,
		impact = 0.25
	},
	push_template = push_templates.medium,
	ogryn_push_template = push_templates.medium,
	catapulting_template = CatapultingTemplates.renegade_captain_void_shield_explosion_catapult,
	force_look_function = ForcedLookSettings.look_functions.to_or_from_attack_direction,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.minion_instakill = {
	stagger_category = "melee",
	toughness_multiplier = 2,
	unblockable = true,
	armor_damage_modifier = {
		attack = default_armor_mod,
		impact = default_armor_mod
	},
	power_distribution = {
		attack = 1,
		impact = 0
	},
	cleave_distribution = {
		attack = 1,
		impact = 0
	},
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.renegade_grenadier_fire_grenade_impact_close = {
	interrupt_alternate_fire = true,
	suppression_value = 15,
	ogryn_disorientation_type = "grenadier",
	ignore_stun_immunity = false,
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
		attack = 20,
		impact = 30
	},
	push_template = push_templates.grenadier_explosion
}
damage_templates.renegade_grenadier_fire_grenade_impact = table.clone(damage_templates.renegade_grenadier_fire_grenade_impact_close)
damage_templates.renegade_grenadier_fire_grenade_impact.power_distribution = {
	attack = 20,
	impact = 15
}
damage_templates.renegade_grenadier_grenade_blunt = table.clone(damage_templates.renegade_grenadier_fire_grenade_impact_close)
damage_templates.renegade_grenadier_grenade_blunt.power_distribution = {
	attack = 0,
	impact = 25
}
damage_templates.poxwalker_explosion = {
	suppression_value = 3,
	permanent_damage_ratio = 0.35,
	interrupt_alternate_fire = true,
	ignore_stun_immunity = true,
	override_allow_friendly_fire = true,
	ragdoll_push_force = 1200,
	on_depleted_toughness_function_override_name = "all_damage_spill_over",
	stagger_category = "ranged",
	toughness_multiplier = 10,
	ignore_stagger_reduction = true,
	cleave_distribution = {
		attack = 0.15,
		impact = 0.3
	},
	armor_damage_modifier_ranged = {
		near = {
			attack = {
				[armor_types.unarmored] = 5,
				[armor_types.armored] = 1,
				[armor_types.resistant] = 1,
				[armor_types.player] = 1,
				[armor_types.berserker] = 1,
				[armor_types.super_armor] = 0,
				[armor_types.disgustingly_resilient] = 20,
				[armor_types.void_shield] = 0
			},
			impact = {
				[armor_types.unarmored] = 6,
				[armor_types.armored] = 5,
				[armor_types.resistant] = 2,
				[armor_types.player] = 2,
				[armor_types.berserker] = 2,
				[armor_types.super_armor] = 0,
				[armor_types.disgustingly_resilient] = 5,
				[armor_types.void_shield] = 2
			}
		},
		far = {
			attack = {
				[armor_types.unarmored] = 3,
				[armor_types.armored] = 1,
				[armor_types.resistant] = 1,
				[armor_types.player] = 1,
				[armor_types.berserker] = 0,
				[armor_types.super_armor] = 0,
				[armor_types.disgustingly_resilient] = 20,
				[armor_types.void_shield] = 0
			},
			impact = {
				[armor_types.unarmored] = 2,
				[armor_types.armored] = 5,
				[armor_types.resistant] = 2,
				[armor_types.player] = 2,
				[armor_types.berserker] = 2,
				[armor_types.super_armor] = 2,
				[armor_types.disgustingly_resilient] = 6,
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
						[armor_types.disgustingly_resilient] = 20,
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
						[armor_types.disgustingly_resilient] = 20,
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
				attack = 0.5,
				impact = 20
			}
		}
	},
	power_distribution = {
		attack = 20,
		impact = 10
	},
	force_look_function = ForcedLookSettings.look_functions.heavy,
	gibbing_type = gibbing_types.explosion,
	gibbing_power = gibbing_power.heavy,
	catapulting_template = CatapultingTemplates.poxwalker_bomber
}
damage_templates.poxwalker_explosion_close = {
	suppression_value = 3,
	permanent_damage_ratio = 0.35,
	interrupt_alternate_fire = true,
	ignore_stun_immunity = true,
	override_allow_friendly_fire = true,
	ragdoll_push_force = 1200,
	on_depleted_toughness_function_override_name = "all_damage_spill_over",
	stagger_category = "ranged",
	toughness_multiplier = 10,
	ignore_stagger_reduction = true,
	cleave_distribution = {
		attack = 0.15,
		impact = 0.3
	},
	armor_damage_modifier_ranged = {
		near = {
			attack = {
				[armor_types.unarmored] = 5,
				[armor_types.armored] = 1,
				[armor_types.resistant] = 1,
				[armor_types.player] = 1,
				[armor_types.berserker] = 1,
				[armor_types.super_armor] = 0,
				[armor_types.disgustingly_resilient] = 99,
				[armor_types.void_shield] = 0
			},
			impact = {
				[armor_types.unarmored] = 6,
				[armor_types.armored] = 5,
				[armor_types.resistant] = 2,
				[armor_types.player] = 2,
				[armor_types.berserker] = 2,
				[armor_types.super_armor] = 0,
				[armor_types.disgustingly_resilient] = 5,
				[armor_types.void_shield] = 2
			}
		},
		far = {
			attack = {
				[armor_types.unarmored] = 3,
				[armor_types.armored] = 1,
				[armor_types.resistant] = 1,
				[armor_types.player] = 1,
				[armor_types.berserker] = 0,
				[armor_types.super_armor] = 0,
				[armor_types.disgustingly_resilient] = 99,
				[armor_types.void_shield] = 0
			},
			impact = {
				[armor_types.unarmored] = 2,
				[armor_types.armored] = 5,
				[armor_types.resistant] = 2,
				[armor_types.player] = 2,
				[armor_types.berserker] = 2,
				[armor_types.super_armor] = 2,
				[armor_types.disgustingly_resilient] = 6,
				[armor_types.void_shield] = 2
			}
		}
	},
	targets = {
		default_target = {
			armor_damage_modifier_ranged = {
				near = {
					attack = {
						[armor_types.unarmored] = 1,
						[armor_types.armored] = 1,
						[armor_types.resistant] = 1,
						[armor_types.player] = 1,
						[armor_types.berserker] = 1,
						[armor_types.super_armor] = 1,
						[armor_types.disgustingly_resilient] = 50,
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
						[armor_types.unarmored] = 1,
						[armor_types.armored] = 1,
						[armor_types.resistant] = 1,
						[armor_types.player] = 1,
						[armor_types.berserker] = 1,
						[armor_types.super_armor] = 1,
						[armor_types.disgustingly_resilient] = 50,
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
				attack = 125,
				impact = 20
			}
		}
	},
	power_distribution = {
		attack = 20,
		impact = 10
	},
	force_look_function = ForcedLookSettings.look_functions.heavy,
	gibbing_type = gibbing_types.explosion,
	gibbing_power = gibbing_power.heavy,
	catapulting_template = CatapultingTemplates.poxwalker_bomber,
	permanent_damage_ratio = 0.5,
	power_distribution = {
		attack = 30,
		impact = 50
	},
	catapulting_template = CatapultingTemplates.poxwalker_bomber_close
}
damage_templates.default_rifleman = {
	disorientation_type = "light",
	stagger_category = "ranged",
	suppression_value = 1,
	interrupt_alternate_fire = false,
	ogryn_disorientation_type = "ogryn_light",
	armor_damage_modifier = {
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
			[armor_types.unarmored] = 0.12,
			[armor_types.armored] = 0.3,
			[armor_types.resistant] = 1,
			[armor_types.player] = 1,
			[armor_types.berserker] = 0.5,
			[armor_types.super_armor] = 0,
			[armor_types.disgustingly_resilient] = 0.12,
			[armor_types.void_shield] = 0.5
		}
	},
	crit_mods = {
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
			[armor_types.unarmored] = 0.5,
			[armor_types.armored] = 0,
			[armor_types.resistant] = 1,
			[armor_types.player] = 1,
			[armor_types.berserker] = 1,
			[armor_types.super_armor] = 1,
			[armor_types.disgustingly_resilient] = 1,
			[armor_types.void_shield] = 1
		}
	},
	power_distribution = {
		attack = 24,
		impact = 10
	},
	cleave_distribution = {
		attack = 2,
		impact = 2
	},
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
overrides.renegade_rifleman = {
	parent_template_name = "default_rifleman",
	overrides = {}
}
overrides.renegade_rifleman_single_shot = {
	parent_template_name = "default_rifleman",
	overrides = {}
}
damage_templates.assaulter_auto_burst = {
	disorientation_type = "ranged_auto_light",
	toughness_multiplier = 2.25,
	stagger_category = "ranged",
	suppression_value = 0.75,
	ogryn_disorientation_type = "ogryn_light",
	armor_damage_modifier = {
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
			[armor_types.unarmored] = 0.12,
			[armor_types.armored] = 0.3,
			[armor_types.resistant] = 1,
			[armor_types.player] = 1,
			[armor_types.berserker] = 0.5,
			[armor_types.super_armor] = 0,
			[armor_types.disgustingly_resilient] = 0.12,
			[armor_types.void_shield] = 0.5
		}
	},
	crit_mods = {
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
			[armor_types.unarmored] = 0.5,
			[armor_types.armored] = 0,
			[armor_types.resistant] = 1,
			[armor_types.player] = 1,
			[armor_types.berserker] = 1,
			[armor_types.super_armor] = 0,
			[armor_types.disgustingly_resilient] = 0,
			[armor_types.void_shield] = 0
		}
	},
	power_distribution = {
		attack = 10,
		impact = 0
	},
	cleave_distribution = {
		attack = 0.01,
		impact = 0.01
	},
	force_look_function = ForcedLookSettings.look_functions.light,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
overrides.assaulter_las_burst = {
	parent_template_name = "assaulter_auto_burst",
	overrides = {}
}
damage_templates.shocktrooper_shotgun = {
	ogryn_disorientation_type = "ogryn_heavy",
	toughness_multiplier = 2,
	stagger_category = "ranged",
	on_depleted_toughness_function_override_name = "spill_over",
	suppression_value = 5,
	interrupt_alternate_fire = true,
	disorientation_type = "heavy",
	armor_damage_modifier = {
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
			[armor_types.unarmored] = 1,
			[armor_types.armored] = 0.5,
			[armor_types.resistant] = 1,
			[armor_types.player] = 1,
			[armor_types.berserker] = 0.5,
			[armor_types.super_armor] = 0,
			[armor_types.disgustingly_resilient] = 0.5,
			[armor_types.void_shield] = 0.5
		}
	},
	crit_mods = {
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
			[armor_types.unarmored] = 0.5,
			[armor_types.armored] = 0,
			[armor_types.resistant] = 1,
			[armor_types.player] = 1,
			[armor_types.berserker] = 1,
			[armor_types.super_armor] = 0,
			[armor_types.disgustingly_resilient] = 0,
			[armor_types.void_shield] = 0
		}
	},
	power_distribution = {
		attack = 7,
		impact = 0.25
	},
	cleave_distribution = {
		attack = 0.5,
		impact = 0.5
	},
	force_look_function = ForcedLookSettings.look_functions.heavy,
	push_template = push_templates.shocktrooper_shotgun,
	ogryn_push_template = push_templates.heavy,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.sniper_bullet = {
	ogryn_disorientation_type = "sniper",
	interrupt_alternate_fire = true,
	stagger_category = "ranged",
	on_depleted_toughness_function_override_name = "all_damage_spill_over",
	suppression_value = 5,
	toughness_multiplier = 10,
	ragdoll_push_force = 2000,
	unblockable = true,
	disorientation_type = "sniper",
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = 10,
			[armor_types.armored] = 10,
			[armor_types.resistant] = 10,
			[armor_types.player] = 1,
			[armor_types.berserker] = 10,
			[armor_types.super_armor] = 0,
			[armor_types.disgustingly_resilient] = 10,
			[armor_types.void_shield] = 0
		},
		impact = {
			[armor_types.unarmored] = 1,
			[armor_types.armored] = 0.5,
			[armor_types.resistant] = 1,
			[armor_types.player] = 1,
			[armor_types.berserker] = 0.5,
			[armor_types.super_armor] = 0,
			[armor_types.disgustingly_resilient] = 0.5,
			[armor_types.void_shield] = 0.5
		}
	},
	crit_mods = {
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
			[armor_types.unarmored] = 0.5,
			[armor_types.armored] = 0,
			[armor_types.resistant] = 1,
			[armor_types.player] = 1,
			[armor_types.berserker] = 1,
			[armor_types.super_armor] = 0,
			[armor_types.disgustingly_resilient] = 0,
			[armor_types.void_shield] = 0
		}
	},
	power_distribution = {
		attack = 0.7,
		impact = 0.25
	},
	cleave_distribution = {
		attack = 10,
		impact = 0.5
	},
	gibbing_power = gibbing_power.medium,
	gibbing_type = gibbing_types.ballistic,
	force_look_function = ForcedLookSettings.look_functions.heavy,
	push_template = push_templates.sniper_bullet,
	ogryn_push_template = push_templates.sniper_bullet,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.gunner_aimed = {
	ogryn_disorientation_type = "ogryn_medium",
	toughness_multiplier = 1,
	stagger_category = "ranged",
	suppression_value = 5,
	interrupt_alternate_fire = true,
	disorientation_type = "medium",
	armor_damage_modifier = {
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
			[armor_types.unarmored] = 0.12,
			[armor_types.armored] = 0.3,
			[armor_types.resistant] = 1,
			[armor_types.player] = 1,
			[armor_types.berserker] = 0.5,
			[armor_types.super_armor] = 0,
			[armor_types.disgustingly_resilient] = 0.12,
			[armor_types.void_shield] = 0.5
		}
	},
	crit_mods = {
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
			[armor_types.unarmored] = 1,
			[armor_types.armored] = 1,
			[armor_types.resistant] = 1,
			[armor_types.player] = 1,
			[armor_types.berserker] = 1,
			[armor_types.super_armor] = 1,
			[armor_types.disgustingly_resilient] = 1,
			[armor_types.void_shield] = 1
		}
	},
	power_distribution = {
		attack = 15,
		impact = 0.25
	},
	cleave_distribution = {
		attack = 0.5,
		impact = 0.5
	},
	force_look_function = ForcedLookSettings.look_functions.medium,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.gunner_spray_n_pray = {
	ogryn_disorientation_type = "ogryn_medium",
	toughness_multiplier = 1,
	stagger_category = "ranged",
	suppression_value = 5,
	interrupt_alternate_fire = true,
	disorientation_type = "medium",
	armor_damage_modifier = {
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
			[armor_types.unarmored] = 0.12,
			[armor_types.armored] = 0.3,
			[armor_types.resistant] = 1,
			[armor_types.player] = 1,
			[armor_types.berserker] = 0.5,
			[armor_types.super_armor] = 0,
			[armor_types.disgustingly_resilient] = 0.12,
			[armor_types.void_shield] = 0.5
		}
	},
	crit_mods = {
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
			[armor_types.unarmored] = 1,
			[armor_types.armored] = 1,
			[armor_types.resistant] = 1,
			[armor_types.player] = 1,
			[armor_types.berserker] = 1,
			[armor_types.super_armor] = 1,
			[armor_types.disgustingly_resilient] = 1,
			[armor_types.void_shield] = 1
		}
	},
	power_distribution = {
		attack = 10,
		impact = 0.25
	},
	cleave_distribution = {
		attack = 0.5,
		impact = 0.5
	},
	force_look_function = ForcedLookSettings.look_functions.medium,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.gunner_sweep = {
	interrupt_alternate_fire = true,
	toughness_multiplier = 1,
	ogryn_disorientation_type = "ogryn_medium",
	stagger_category = "ranged",
	suppression_value = 5,
	grace_cost = 2,
	disorientation_type = "medium",
	armor_damage_modifier = {
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
			[armor_types.unarmored] = 0.12,
			[armor_types.armored] = 0.3,
			[armor_types.resistant] = 1,
			[armor_types.player] = 1,
			[armor_types.berserker] = 0.5,
			[armor_types.super_armor] = 0,
			[armor_types.disgustingly_resilient] = 0.12,
			[armor_types.void_shield] = 0.5
		}
	},
	crit_mods = {
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
			[armor_types.unarmored] = 1,
			[armor_types.armored] = 1,
			[armor_types.resistant] = 1,
			[armor_types.player] = 1,
			[armor_types.berserker] = 1,
			[armor_types.super_armor] = 1,
			[armor_types.disgustingly_resilient] = 1,
			[armor_types.void_shield] = 1
		}
	},
	power_distribution = {
		attack = 7,
		impact = 15
	},
	cleave_distribution = {
		attack = 0.5,
		impact = 0.5
	},
	force_look_function = ForcedLookSettings.look_functions.medium,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.renegade_captain_spray = {
	toughness_multiplier = 1,
	disorientation_type = "medium",
	stagger_category = "ranged",
	suppression_value = 5,
	interrupt_alternate_fire = true,
	ogryn_disorientation_type = "ogryn_medium",
	armor_damage_modifier = {
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
			[armor_types.unarmored] = 1,
			[armor_types.armored] = 0.5,
			[armor_types.resistant] = 1,
			[armor_types.player] = 1,
			[armor_types.berserker] = 0.5,
			[armor_types.super_armor] = 0,
			[armor_types.disgustingly_resilient] = 0.5,
			[armor_types.void_shield] = 0.5
		}
	},
	power_distribution = {
		attack = 15,
		impact = 25
	},
	cleave_distribution = {
		attack = 0.5,
		impact = 0.5
	},
	push_template = push_templates.medium,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.renegade_captain_shotgun = {
	ogryn_disorientation_type = "ogryn_heavy",
	toughness_multiplier = 3,
	stagger_category = "ranged",
	suppression_value = 5,
	interrupt_alternate_fire = true,
	disorientation_type = "heavy",
	armor_damage_modifier = {
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
			[armor_types.unarmored] = 1,
			[armor_types.armored] = 0.5,
			[armor_types.resistant] = 1,
			[armor_types.player] = 1,
			[armor_types.berserker] = 0.5,
			[armor_types.super_armor] = 0,
			[armor_types.disgustingly_resilient] = 0.5,
			[armor_types.void_shield] = 0.5
		}
	},
	crit_mods = {
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
			[armor_types.unarmored] = 0.5,
			[armor_types.armored] = 0,
			[armor_types.resistant] = 1,
			[armor_types.player] = 1,
			[armor_types.berserker] = 1,
			[armor_types.super_armor] = 0,
			[armor_types.disgustingly_resilient] = 0,
			[armor_types.void_shield] = 0
		}
	},
	power_distribution = {
		attack = 10,
		impact = 0.25
	},
	cleave_distribution = {
		attack = 0.5,
		impact = 0.5
	},
	force_look_function = ForcedLookSettings.look_functions.heavy,
	push_template = push_templates.renegade_captain_shotgun,
	ogryn_push_template = push_templates.heavy,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.renegade_captain_frag_grenade_close = {
	ragdoll_push_force = 1250,
	suppression_value = 10,
	ignore_stagger_reduction = true,
	stagger_category = "explosion",
	cleave_distribution = {
		attack = 0.15,
		impact = 0.15
	},
	armor_damage_modifier_ranged = {
		near = {
			attack = {
				[armor_types.unarmored] = 1,
				[armor_types.armored] = 1,
				[armor_types.resistant] = 1,
				[armor_types.player] = 1,
				[armor_types.berserker] = 1,
				[armor_types.super_armor] = 0,
				[armor_types.disgustingly_resilient] = 0.75,
				[armor_types.void_shield] = 0.75
			},
			impact = {
				[armor_types.unarmored] = 2,
				[armor_types.armored] = 2,
				[armor_types.resistant] = 10,
				[armor_types.player] = 2,
				[armor_types.berserker] = 2,
				[armor_types.super_armor] = 5,
				[armor_types.disgustingly_resilient] = 2,
				[armor_types.void_shield] = 2
			}
		},
		far = {
			attack = {
				[armor_types.unarmored] = 0,
				[armor_types.armored] = 0,
				[armor_types.resistant] = 0,
				[armor_types.player] = 0,
				[armor_types.berserker] = 0,
				[armor_types.super_armor] = 0,
				[armor_types.disgustingly_resilient] = 0,
				[armor_types.void_shield] = 0
			},
			impact = {
				[armor_types.unarmored] = 0.2,
				[armor_types.armored] = 0.2,
				[armor_types.resistant] = 0.2,
				[armor_types.player] = 0.2,
				[armor_types.berserker] = 0.2,
				[armor_types.super_armor] = 0.2,
				[armor_types.disgustingly_resilient] = 0.2,
				[armor_types.void_shield] = 0.2
			}
		}
	},
	power_distribution = {
		attack = 500,
		impact = 100
	},
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	},
	catapulting_template = CatapultingTemplates.renegade_captain_frag_grenade_close_catapult
}
damage_templates.renegade_captain_frag_grenade = {
	ragdoll_push_force = 1000,
	suppression_value = 10,
	ignore_stagger_reduction = true,
	stagger_category = "explosion",
	cleave_distribution = {
		attack = 0.15,
		impact = 0.15
	},
	armor_damage_modifier_ranged = {
		near = {
			attack = {
				[armor_types.unarmored] = 1,
				[armor_types.armored] = 1,
				[armor_types.resistant] = 1,
				[armor_types.player] = 1,
				[armor_types.berserker] = 1,
				[armor_types.super_armor] = 0,
				[armor_types.disgustingly_resilient] = 0.75,
				[armor_types.void_shield] = 0.75
			},
			impact = {
				[armor_types.unarmored] = 2,
				[armor_types.armored] = 2,
				[armor_types.resistant] = 5,
				[armor_types.player] = 2,
				[armor_types.berserker] = 2,
				[armor_types.super_armor] = 5,
				[armor_types.disgustingly_resilient] = 2,
				[armor_types.void_shield] = 2
			}
		},
		far = {
			attack = {
				[armor_types.unarmored] = 0,
				[armor_types.armored] = 0,
				[armor_types.resistant] = 0,
				[armor_types.player] = 0,
				[armor_types.berserker] = 0,
				[armor_types.super_armor] = 0,
				[armor_types.disgustingly_resilient] = 0,
				[armor_types.void_shield] = 0
			},
			impact = {
				[armor_types.unarmored] = 0.2,
				[armor_types.armored] = 0.2,
				[armor_types.resistant] = 1,
				[armor_types.player] = 0.2,
				[armor_types.berserker] = 0.2,
				[armor_types.super_armor] = 0.2,
				[armor_types.disgustingly_resilient] = 0.2,
				[armor_types.void_shield] = 0.2
			}
		}
	},
	power_distribution_ranged = {
		attack = {
			far = 10,
			near = 100
		},
		impact = {
			far = 2,
			near = 30
		}
	},
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.renegade_shocktrooper_frag_grenade_close = {
	ignore_stagger_reduction = true,
	disorientation_type = "shocktrooper_frag",
	ogryn_disorientation_type = "shocktrooper_frag",
	stagger_category = "explosion",
	suppression_value = 10,
	ragdoll_push_force = 1250,
	interrupt_alternate_fire = true,
	cleave_distribution = {
		attack = 0.15,
		impact = 0.15
	},
	armor_damage_modifier_ranged = {
		near = {
			attack = {
				[armor_types.unarmored] = 1,
				[armor_types.armored] = 1,
				[armor_types.resistant] = 1,
				[armor_types.player] = 1,
				[armor_types.berserker] = 1,
				[armor_types.super_armor] = 0,
				[armor_types.disgustingly_resilient] = 0.75,
				[armor_types.void_shield] = 0.75
			},
			impact = {
				[armor_types.unarmored] = 2,
				[armor_types.armored] = 2,
				[armor_types.resistant] = 10,
				[armor_types.player] = 2,
				[armor_types.berserker] = 2,
				[armor_types.super_armor] = 5,
				[armor_types.disgustingly_resilient] = 2,
				[armor_types.void_shield] = 2
			}
		},
		far = {
			attack = {
				[armor_types.unarmored] = 0,
				[armor_types.armored] = 0,
				[armor_types.resistant] = 0,
				[armor_types.player] = 0,
				[armor_types.berserker] = 0,
				[armor_types.super_armor] = 0,
				[armor_types.disgustingly_resilient] = 0,
				[armor_types.void_shield] = 0
			},
			impact = {
				[armor_types.unarmored] = 0.2,
				[armor_types.armored] = 0.2,
				[armor_types.resistant] = 0.2,
				[armor_types.player] = 0.2,
				[armor_types.berserker] = 0.2,
				[armor_types.super_armor] = 0.2,
				[armor_types.disgustingly_resilient] = 0.2,
				[armor_types.void_shield] = 0.2
			}
		}
	},
	power_distribution = {
		attack = 20,
		impact = 20
	},
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	},
	push_template = push_templates.shocktrooper_frag,
	ogryn_push_template = push_templates.medium,
	force_look_function = ForcedLookSettings.look_functions.heavy
}
damage_templates.renegade_shocktrooper_frag_grenade = {
	ogryn_disorientation_type = "shocktrooper_frag",
	stagger_category = "explosion",
	suppression_value = 10,
	ragdoll_push_force = 1000,
	ignore_stagger_reduction = true,
	disorientation_type = "shocktrooper_frag",
	cleave_distribution = {
		attack = 0.15,
		impact = 0.15
	},
	armor_damage_modifier_ranged = {
		near = {
			attack = {
				[armor_types.unarmored] = 1,
				[armor_types.armored] = 1,
				[armor_types.resistant] = 1,
				[armor_types.player] = 1,
				[armor_types.berserker] = 1,
				[armor_types.super_armor] = 0,
				[armor_types.disgustingly_resilient] = 0.75,
				[armor_types.void_shield] = 0.75
			},
			impact = {
				[armor_types.unarmored] = 2,
				[armor_types.armored] = 2,
				[armor_types.resistant] = 5,
				[armor_types.player] = 2,
				[armor_types.berserker] = 2,
				[armor_types.super_armor] = 5,
				[armor_types.disgustingly_resilient] = 2,
				[armor_types.void_shield] = 2
			}
		},
		far = {
			attack = {
				[armor_types.unarmored] = 0,
				[armor_types.armored] = 0,
				[armor_types.resistant] = 0,
				[armor_types.player] = 0,
				[armor_types.berserker] = 0,
				[armor_types.super_armor] = 0,
				[armor_types.disgustingly_resilient] = 0,
				[armor_types.void_shield] = 0
			},
			impact = {
				[armor_types.unarmored] = 0.2,
				[armor_types.armored] = 0.2,
				[armor_types.resistant] = 1,
				[armor_types.player] = 0.2,
				[armor_types.berserker] = 0.2,
				[armor_types.super_armor] = 0.2,
				[armor_types.disgustingly_resilient] = 0.2,
				[armor_types.void_shield] = 0.2
			}
		}
	},
	power_distribution_ranged = {
		attack = {
			far = 5,
			near = 10
		},
		impact = {
			far = 2,
			near = 5
		}
	},
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	},
	push_template = push_templates.shocktrooper_frag,
	ogryn_push_template = push_templates.medium
}
damage_templates.default_rusher = {
	disorientation_type = "medium",
	stagger_category = "ranged",
	suppression_value = 0,
	interrupt_alternate_fire = true,
	ogryn_disorientation_type = "ogryn_medium",
	armor_damage_modifier = {
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
			[armor_types.unarmored] = 1,
			[armor_types.armored] = 0.5,
			[armor_types.resistant] = 1,
			[armor_types.player] = 1,
			[armor_types.berserker] = 0.5,
			[armor_types.super_armor] = 0,
			[armor_types.disgustingly_resilient] = 0.5,
			[armor_types.void_shield] = 0.5
		}
	},
	crit_mods = {
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
			[armor_types.unarmored] = 1,
			[armor_types.armored] = 1,
			[armor_types.resistant] = 1,
			[armor_types.player] = 1,
			[armor_types.berserker] = 1,
			[armor_types.super_armor] = 1,
			[armor_types.disgustingly_resilient] = 1,
			[armor_types.void_shield] = 1
		}
	},
	power_distribution = {
		attack = 20,
		impact = 5
	},
	cleave_distribution = {
		attack = 0.5,
		impact = 0.5
	},
	force_look_function = ForcedLookSettings.look_functions.medium,
	push_template = push_templates.medium,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
local chaos_hound_pounce = table.clone(damage_templates.melee_fighter_default)
chaos_hound_pounce.permanent_damage_ratio = 0.98
chaos_hound_pounce.melee_toughness_multiplier = 10
chaos_hound_pounce.on_depleted_toughness_function_override_name = "spill_over"
damage_templates.chaos_hound_pounce = chaos_hound_pounce
local chaos_hound_initial_pounce = table.clone(damage_templates.melee_fighter_default)
chaos_hound_initial_pounce.toughness_factor_spillover_modifier = 0
chaos_hound_initial_pounce.permanent_damage_ratio = 1
chaos_hound_initial_pounce.melee_toughness_multiplier = 0
damage_templates.chaos_hound_initial_pounce = chaos_hound_initial_pounce
local daemonhost_grab = table.clone(damage_templates.chaos_hound_pounce)
daemonhost_grab.ignores_knockdown = true
damage_templates.daemonhost_grab = daemonhost_grab
damage_templates.melee_executor_cleave = {
	ogryn_disorientation_type = "ogryn_heavy",
	melee_toughness_multiplier = 2,
	block_broken_disorientation_type = "block_broken_heavy",
	on_depleted_toughness_function_override_name = "spill_over",
	block_cost_multiplier = 10,
	stagger_category = "melee",
	toughness_factor_spillover_modifier = 0.75,
	unblockable = true,
	interrupt_alternate_fire = true,
	disorientation_type = "heavy",
	armor_damage_modifier = {
		attack = default_armor_mod,
		impact = default_armor_mod
	},
	crit_mods = {
		attack = crit_armor_mod,
		impact = crit_impact_armor_mod
	},
	power_distribution = {
		attack = 125,
		impact = 50
	},
	cleave_distribution = {
		attack = 0.25,
		impact = 0.25
	},
	force_look_function = ForcedLookSettings.look_functions.heavy,
	push_template = push_templates.medium,
	ogryn_push_template = push_templates.medium,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.melee_executor_default = {
	disorientation_type = "medium",
	melee_toughness_multiplier = 1,
	stagger_category = "melee",
	block_cost_multiplier = 4,
	interrupt_alternate_fire = true,
	ogryn_disorientation_type = "ogryn_medium",
	armor_damage_modifier = {
		attack = default_armor_mod,
		impact = default_armor_mod
	},
	crit_mods = {
		attack = crit_armor_mod,
		impact = crit_impact_armor_mod
	},
	power_distribution = {
		attack = 50,
		impact = 20
	},
	cleave_distribution = {
		attack = 0.25,
		impact = 0.25
	},
	force_look_function = ForcedLookSettings.look_functions.medium,
	push_template = push_templates.melee_executor_default,
	ogryn_push_template = push_templates.heavy,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.chaos_ogryn_executor_default = {
	disorientation_type = "heavy",
	melee_toughness_multiplier = 1,
	stagger_category = "melee",
	block_cost_multiplier = 4,
	interrupt_alternate_fire = true,
	ogryn_disorientation_type = "medium",
	armor_damage_modifier = {
		attack = default_armor_mod,
		impact = default_armor_mod
	},
	crit_mods = {
		attack = crit_armor_mod,
		impact = crit_impact_armor_mod
	},
	power_distribution = {
		attack = 75,
		impact = 20
	},
	cleave_distribution = {
		attack = 0.25,
		impact = 0.25
	},
	force_look_function = ForcedLookSettings.look_functions.heavy,
	push_template = push_templates.ogryn_executor_push,
	ogryn_push_template = push_templates.ogryn_executor_push,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.chaos_ogryn_executor_push = {
	disorientation_type = "heavy",
	block_cost_multiplier = 5,
	stagger_category = "melee",
	interrupt_alternate_fire = true,
	ogryn_disorientation_type = "medium",
	armor_damage_modifier = {
		attack = default_armor_mod,
		impact = default_armor_mod
	},
	crit_mods = {
		attack = crit_armor_mod,
		impact = crit_impact_armor_mod
	},
	power_distribution = {
		attack = 25,
		impact = 20
	},
	cleave_distribution = {
		attack = 0.25,
		impact = 0.25
	},
	force_look_function = ForcedLookSettings.look_functions.heavy,
	push_template = push_templates.ogryn_executor_push,
	ogryn_push_template = push_templates.ogryn_executor_push,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
local chaos_ogryn_executor_pommel = table.clone(damage_templates.chaos_ogryn_executor_push)
damage_templates.chaos_ogryn_executor_pommel = chaos_ogryn_executor_pommel
local chaos_ogryn_executor_punch = table.clone(damage_templates.chaos_ogryn_executor_push)
damage_templates.chaos_ogryn_executor_punch = chaos_ogryn_executor_punch
local chaos_ogryn_executor_kick = table.clone(damage_templates.chaos_ogryn_executor_push)
damage_templates.chaos_ogryn_executor_kick = chaos_ogryn_executor_kick
damage_templates.chaos_ogryn_executor_cleave = {
	disorientation_type = "ogryn_executor_heavy",
	melee_toughness_multiplier = 2,
	block_broken_disorientation_type = "block_broken_heavy",
	on_depleted_toughness_function_override_name = "spill_over",
	block_cost_multiplier = 20,
	stagger_category = "melee",
	toughness_factor_spillover_modifier = 0.75,
	unblockable = true,
	interrupt_alternate_fire = true,
	ogryn_disorientation_type = "ogryn_executor_heavy",
	armor_damage_modifier = {
		attack = default_armor_mod,
		impact = default_armor_mod
	},
	crit_mods = {
		attack = crit_armor_mod,
		impact = crit_impact_armor_mod
	},
	power_distribution = {
		attack = 130,
		impact = 100
	},
	cleave_distribution = {
		attack = 0.25,
		impact = 0.25
	},
	force_look_function = ForcedLookSettings.look_functions.heavy,
	push_template = push_templates.heavy,
	ogryn_push_template = push_templates.heavy,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.daemonhost_melee = {
	ignore_stagger_reduction = true,
	ogryn_disorientation_type = "ogryn_heavy",
	interrupt_alternate_fire = true,
	block_cost_multiplier = 3.5,
	stagger_category = "melee",
	toughness_multiplier = 2,
	disorientation_type = "heavy",
	armor_damage_modifier = {
		attack = default_armor_mod,
		impact = default_armor_mod
	},
	crit_mods = {
		attack = crit_armor_mod,
		impact = crit_impact_armor_mod
	},
	power_distribution = {
		attack = 0.2,
		impact = 2
	},
	cleave_distribution = {
		attack = 0.25,
		impact = 0.25
	},
	force_look_function = ForcedLookSettings.look_functions.heavy,
	push_template = push_templates.daemonhost,
	ogryn_push_template = push_templates.daemonhost,
	ragdoll_push_force = {
		500,
		800
	},
	gibbing_power = gibbing_power.heavy,
	gibbing_type = gibbing_types.explosion,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.daemonhost_offtarget_melee = {
	ignore_stagger_reduction = true,
	ogryn_disorientation_type = "ogryn_heavy",
	interrupt_alternate_fire = true,
	block_cost_multiplier = 3.5,
	stagger_category = "melee",
	toughness_multiplier = 2,
	disorientation_type = "heavy",
	armor_damage_modifier = {
		attack = default_armor_mod,
		impact = default_armor_mod
	},
	crit_mods = {
		attack = crit_armor_mod,
		impact = crit_impact_armor_mod
	},
	power_distribution = {
		attack = 0.001,
		impact = 40
	},
	cleave_distribution = {
		attack = 0.25,
		impact = 1
	},
	force_look_function = ForcedLookSettings.look_functions.heavy,
	push_template = push_templates.daemonhost_offtarget,
	ogryn_push_template = push_templates.daemonhost_offtarget,
	ragdoll_push_force = {
		500,
		800
	},
	gibbing_power = gibbing_power.heavy,
	gibbing_type = gibbing_types.sawing,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.daemonhost_melee_combo = {
	ignore_stagger_reduction = true,
	ogryn_disorientation_type = "ogryn_heavy",
	interrupt_alternate_fire = true,
	block_cost_multiplier = 3.5,
	stagger_category = "melee",
	toughness_multiplier = 2,
	disorientation_type = "heavy",
	armor_damage_modifier = {
		attack = default_armor_mod,
		impact = default_armor_mod
	},
	crit_mods = {
		attack = crit_armor_mod,
		impact = crit_impact_armor_mod
	},
	power_distribution = {
		attack = 0.075,
		impact = 40
	},
	cleave_distribution = {
		attack = 0.25,
		impact = 0.25
	},
	force_look_function = ForcedLookSettings.look_functions.heavy,
	push_template = push_templates.daemonhost,
	ogryn_push_template = push_templates.daemonhost,
	ragdoll_push_force = {
		500,
		800
	},
	gibbing_power = gibbing_power.heavy,
	gibbing_type = gibbing_types.sawing,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.daemonhost_warp_sweep = {
	ogryn_disorientation_type = "ogryn_heavy",
	interrupt_alternate_fire = true,
	stagger_category = "melee",
	toughness_multiplier = 2,
	unblockable = true,
	ignore_stagger_reduction = true,
	disorientation_type = "heavy",
	armor_damage_modifier = {
		attack = flat_one_armor_mod,
		impact = flat_one_armor_mod
	},
	crit_mods = {
		attack = flat_one_armor_mod,
		impact = flat_one_armor_mod
	},
	power_distribution = {
		attack = 0.15,
		impact = 40
	},
	cleave_distribution = {
		attack = 0.25,
		impact = 0.25
	},
	force_look_function = ForcedLookSettings.look_functions.heavy,
	push_template = push_templates.daemonhost,
	ragdoll_push_force = {
		500,
		800
	},
	gibbing_power = gibbing_power.heavy,
	gibbing_type = gibbing_types.sawing,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.bulwark_shield_push = {
	disorientation_type = "shield_push",
	stagger_category = "melee",
	toughness_multiplier = 2,
	unblockable = true,
	interrupt_alternate_fire = true,
	ogryn_disorientation_type = "shield_push",
	armor_damage_modifier = {
		attack = default_armor_mod,
		impact = default_armor_mod
	},
	crit_mods = {
		attack = crit_armor_mod,
		impact = crit_impact_armor_mod
	},
	power_distribution = {
		attack = 0,
		impact = 0.5
	},
	cleave_distribution = {
		attack = 0.25,
		impact = 0.25
	},
	force_look_function = ForcedLookSettings.look_functions.heavy,
	push_template = push_templates.shield_push,
	ogryn_push_template = push_templates.shield_push,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.bulwark_melee = {
	disorientation_type = "heavy",
	stagger_category = "melee",
	toughness_multiplier = 2,
	interrupt_alternate_fire = true,
	ogryn_disorientation_type = "medium",
	armor_damage_modifier = {
		attack = default_armor_mod,
		impact = default_armor_mod
	},
	crit_mods = {
		attack = crit_armor_mod,
		impact = crit_impact_armor_mod
	},
	power_distribution = {
		attack = 40,
		impact = 10
	},
	cleave_distribution = {
		attack = 1,
		impact = 1
	},
	force_look_function = ForcedLookSettings.look_functions.heavy,
	push_template = push_templates.medium,
	ogryn_push_template = push_templates.medium,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.chaos_ogryn_gunner_bullet = {
	ogryn_disorientation_type = "ogryn_medium",
	toughness_multiplier = 0.5,
	stagger_category = "ranged",
	suppression_value = 100000,
	interrupt_alternate_fire = true,
	disorientation_type = "chaos_ogryn_gunner_bullet",
	armor_damage_modifier = {
		attack = default_armor_mod,
		impact = {
			[armor_types.unarmored] = 0.25,
			[armor_types.armored] = 0.5,
			[armor_types.resistant] = 1,
			[armor_types.player] = 1,
			[armor_types.berserker] = 0.5,
			[armor_types.super_armor] = 0,
			[armor_types.disgustingly_resilient] = 0.25,
			[armor_types.void_shield] = 0.5
		}
	},
	crit_mods = {
		attack = crit_armor_mod,
		impact = crit_impact_armor_mod
	},
	power_distribution = {
		attack = 0.1,
		impact = 0.5
	},
	cleave_distribution = {
		attack = 0.175,
		impact = 0.25
	},
	force_look_function = ForcedLookSettings.look_functions.heavy,
	push_template = push_templates.chaos_ogryn_gunner_bullet,
	ogryn_push_template = push_templates.chaos_ogryn_gunner_bullet_ogryn,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.cultist_flamer_impact = {
	disorientation_type = "heavy",
	undodgeable = true,
	stagger_category = "melee",
	toughness_multiplier = 2,
	unblockable = true,
	interrupt_alternate_fire = true,
	ogryn_disorientation_type = "ogryn_heavy",
	armor_damage_modifier = {
		attack = default_armor_mod,
		impact = default_armor_mod
	},
	crit_mods = {
		attack = crit_armor_mod,
		impact = crit_impact_armor_mod
	},
	power_distribution = {
		attack = 0.5,
		impact = 2
	},
	cleave_distribution = {
		attack = 0.25,
		impact = 0.25
	},
	force_look_function = ForcedLookSettings.look_functions.heavy,
	push_template = push_templates.cultist_flamer_push,
	ogryn_push_template = push_templates.cultist_flamer_push,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.renegade_flamer_impact = {
	disorientation_type = "heavy",
	undodgeable = true,
	stagger_category = "melee",
	toughness_multiplier = 2,
	unblockable = true,
	interrupt_alternate_fire = true,
	ogryn_disorientation_type = "ogryn_heavy",
	armor_damage_modifier = {
		attack = default_armor_mod,
		impact = default_armor_mod
	},
	crit_mods = {
		attack = crit_armor_mod,
		impact = crit_impact_armor_mod
	},
	power_distribution = {
		attack = 0.5,
		impact = 2
	},
	cleave_distribution = {
		attack = 0.25,
		impact = 0.25
	},
	force_look_function = ForcedLookSettings.look_functions.heavy,
	push_template = push_templates.renegade_flamer_push,
	ogryn_push_template = push_templates.renegade_flamer_push,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.cultist_mutant_minion_charge_push = {
	disorientation_type = "heavy",
	stagger_category = "melee",
	toughness_multiplier = 2,
	unblockable = true,
	interrupt_alternate_fire = false,
	ogryn_disorientation_type = "ogryn_heavy",
	armor_damage_modifier = {
		attack = flat_one_armor_mod,
		impact = flat_one_armor_mod
	},
	crit_mods = {
		attack = flat_one_armor_mod,
		impact = flat_one_armor_mod
	},
	power_distribution = {
		attack = 0,
		impact = 20
	},
	cleave_distribution = {
		attack = 0.25,
		impact = 1
	},
	force_look_function = ForcedLookSettings.look_functions.heavy,
	push_template = push_templates.shield_push,
	ragdoll_push_force = {
		1500,
		3000
	},
	gibbing_power = gibbing_power.heavy,
	gibbing_type = gibbing_types.explosion,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.chaos_hound_push = {
	disorientation_type = "light",
	stagger_category = "melee",
	toughness_multiplier = 2,
	unblockable = true,
	interrupt_alternate_fire = false,
	ogryn_disorientation_type = "ogryn_light",
	armor_damage_modifier = {
		attack = flat_one_armor_mod,
		impact = flat_one_armor_mod
	},
	crit_mods = {
		attack = flat_one_armor_mod,
		impact = flat_one_armor_mod
	},
	power_distribution = {
		attack = 0,
		impact = 20
	},
	cleave_distribution = {
		attack = 0.25,
		impact = 1
	},
	push_template = push_templates.chaos_hound_push,
	ragdoll_push_force = {
		1500,
		3000
	},
	gibbing_power = gibbing_power.heavy,
	gibbing_type = gibbing_types.explosion,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	},
	ignore_toughness = true,
	push_template = push_templates.chaos_hound_pounced_push
}
damage_templates.beast_of_nurgle_push_players = table.clone(damage_templates.chaos_hound_push)
damage_templates.beast_of_nurgle_push_players.push_template = push_templates.beast_of_nurgle_move_push
damage_templates.beast_of_nurgle_push_players.disorientation_type = "medium"
damage_templates.beast_of_nurgle_push_players.ogryn_disorientation_type = "ogryn_medium"
damage_templates.beast_of_nurgle_push_minion = table.clone(damage_templates.chaos_hound_push)
damage_templates.chaos_spawn_push_players = table.clone(damage_templates.beast_of_nurgle_push_players)
damage_templates.chaos_spawn_push_minions = table.clone(damage_templates.chaos_hound_push)
damage_templates.chaos_ogryn_gunner_melee = {
	disorientation_type = "heavy",
	stagger_category = "melee",
	toughness_multiplier = 2,
	interrupt_alternate_fire = true,
	ogryn_disorientation_type = "medium",
	armor_damage_modifier = {
		attack = default_armor_mod,
		impact = default_armor_mod
	},
	crit_mods = {
		attack = crit_armor_mod,
		impact = crit_impact_armor_mod
	},
	power_distribution = {
		attack = 0.125,
		impact = 0.5
	},
	cleave_distribution = {
		attack = 0.25,
		impact = 0.25
	},
	force_look_function = ForcedLookSettings.look_functions.heavy,
	push_template = push_templates.shield_push,
	ogryn_push_template = push_templates.shield_push,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.cultist_mutant_smash = {
	disorientation_type = "medium",
	stagger_category = "melee",
	toughness_multiplier = 2,
	interrupt_alternate_fire = true,
	ogryn_disorientation_type = "ogryn_medium",
	armor_damage_modifier = {
		attack = default_armor_mod,
		impact = default_armor_mod
	},
	crit_mods = {
		attack = crit_armor_mod,
		impact = crit_impact_armor_mod
	},
	power_distribution = {
		attack = 0.1,
		impact = 0.5
	},
	cleave_distribution = {
		attack = 0.25,
		impact = 0.25
	},
	force_look_function = ForcedLookSettings.look_functions.medium,
	push_template = push_templates.medium,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.renegade_captain_toughness_depleted = {
	interrupt_alternate_fire = true,
	suppression_value = 3,
	toughness_multiplier = 2,
	ignore_stun_immunity = true,
	ragdoll_push_force = 1200,
	stagger_category = "ranged",
	ignore_stagger_reduction = true,
	cleave_distribution = {
		attack = 0,
		impact = 0.3
	},
	armor_damage_modifier_ranged = {
		near = {
			attack = {
				[armor_types.unarmored] = 5,
				[armor_types.armored] = 1,
				[armor_types.resistant] = 1,
				[armor_types.player] = 0,
				[armor_types.berserker] = 1,
				[armor_types.super_armor] = 0,
				[armor_types.disgustingly_resilient] = 99,
				[armor_types.void_shield] = 0
			},
			impact = {
				[armor_types.unarmored] = 6,
				[armor_types.armored] = 5,
				[armor_types.resistant] = 2,
				[armor_types.player] = 2,
				[armor_types.berserker] = 2,
				[armor_types.super_armor] = 0,
				[armor_types.disgustingly_resilient] = 5,
				[armor_types.void_shield] = 2
			}
		},
		far = {
			attack = {
				[armor_types.unarmored] = 3,
				[armor_types.armored] = 1,
				[armor_types.resistant] = 1,
				[armor_types.player] = 0,
				[armor_types.berserker] = 0,
				[armor_types.super_armor] = 0,
				[armor_types.disgustingly_resilient] = 9,
				[armor_types.void_shield] = 0
			},
			impact = {
				[armor_types.unarmored] = 2,
				[armor_types.armored] = 5,
				[armor_types.resistant] = 2,
				[armor_types.player] = 2,
				[armor_types.berserker] = 2,
				[armor_types.super_armor] = 2,
				[armor_types.disgustingly_resilient] = 6,
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
						[armor_types.player] = 0,
						[armor_types.berserker] = 0,
						[armor_types.super_armor] = 0,
						[armor_types.disgustingly_resilient] = 0,
						[armor_types.void_shield] = 0
					},
					impact = {
						[armor_types.unarmored] = 2,
						[armor_types.armored] = 5,
						[armor_types.resistant] = 2,
						[armor_types.player] = 0,
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
						[armor_types.player] = 0,
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
				attack = 0,
				impact = 20
			}
		}
	},
	power_distribution = {
		attack = 0,
		impact = 10
	},
	force_look_function = ForcedLookSettings.look_functions.heavy,
	gibbing_type = gibbing_types.explosion,
	gibbing_power = gibbing_power.heavy,
	push_template = push_templates.renegade_captain_heavy,
	ogryn_push_template = push_templates.renegade_captain_heavy
}
damage_templates.renegade_captain_offtarget_melee = {
	ignore_stagger_reduction = true,
	ogryn_disorientation_type = "ogryn_heavy",
	interrupt_alternate_fire = true,
	block_cost_multiplier = 3.5,
	stagger_category = "melee",
	toughness_multiplier = 2,
	disorientation_type = "heavy",
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = 10,
			[armor_types.armored] = 5,
			[armor_types.resistant] = 5,
			[armor_types.player] = 0.02,
			[armor_types.berserker] = 10,
			[armor_types.super_armor] = 5,
			[armor_types.disgustingly_resilient] = 10,
			[armor_types.void_shield] = 0.1
		},
		impact = default_armor_mod
	},
	crit_mods = {
		attack = crit_armor_mod,
		impact = crit_impact_armor_mod
	},
	power_distribution = {
		attack = 20,
		impact = 40
	},
	cleave_distribution = {
		attack = 0.25,
		impact = 1
	},
	force_look_function = ForcedLookSettings.look_functions.heavy,
	push_template = push_templates.daemonhost_offtarget,
	ogryn_push_template = push_templates.daemonhost_offtarget,
	ragdoll_push_force = {
		500,
		800
	},
	gibbing_power = gibbing_power.heavy,
	gibbing_type = gibbing_types.sawing,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.daemonhost_corruption_aura = {
	stagger_category = "ranged",
	ignore_toughness = true,
	permanent_damage_ratio = 1,
	power_distribution = {
		attack = 0.35,
		impact = 4
	},
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.mutator_green_corruption = {
	stagger_category = "ranged",
	ignore_toughness = true,
	permanent_damage_ratio = 1,
	power_distribution = {
		attack = 0.35,
		impact = 4
	},
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.mutator_corruption = {
	stagger_category = "ranged",
	ignore_toughness = true,
	permanent_damage_ratio = 1,
	power_distribution = {
		attack = 1,
		impact = 4
	},
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.mutator_gas_normal_damage = {
	toughness_multiplier = 0.75,
	stagger_category = "ranged",
	power_distribution = {
		attack = 1,
		impact = 4
	},
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.beast_of_nurgle_slime_liquid = {
	ogryn_disorientation_type = "corruption_tick",
	toughness_multiplier = 2,
	permanent_damage_ratio = 1,
	disorientation_type = "corruption_tick",
	ignore_toughness = true,
	stagger_category = "melee",
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = 0,
			[armor_types.armored] = 0,
			[armor_types.resistant] = 0,
			[armor_types.player] = 0.1,
			[armor_types.berserker] = 0,
			[armor_types.super_armor] = 0,
			[armor_types.disgustingly_resilient] = 0,
			[armor_types.void_shield] = 0
		},
		impact = {
			[armor_types.unarmored] = 0,
			[armor_types.armored] = 0,
			[armor_types.resistant] = 0,
			[armor_types.player] = 0.1,
			[armor_types.berserker] = 0,
			[armor_types.super_armor] = 0,
			[armor_types.disgustingly_resilient] = 0,
			[armor_types.void_shield] = 0
		}
	},
	power_distribution = {
		attack = 1,
		impact = 0
	},
	cleave_distribution = {
		attack = 1,
		impact = 0
	},
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.beast_of_nurgle_hit_by_vomit = {
	toughness_multiplier = 2,
	permanent_damage_ratio = 1,
	ignore_toughness = true,
	stagger_category = "melee",
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = 0,
			[armor_types.armored] = 0,
			[armor_types.resistant] = 0,
			[armor_types.player] = 0.08,
			[armor_types.berserker] = 0,
			[armor_types.super_armor] = 0,
			[armor_types.disgustingly_resilient] = 0,
			[armor_types.void_shield] = 0
		},
		impact = {
			[armor_types.unarmored] = 0,
			[armor_types.armored] = 0,
			[armor_types.resistant] = 0,
			[armor_types.player] = 0.1,
			[armor_types.berserker] = 0,
			[armor_types.super_armor] = 0,
			[armor_types.disgustingly_resilient] = 0,
			[armor_types.void_shield] = 0
		}
	},
	power_distribution = {
		attack = 1,
		impact = 0
	},
	cleave_distribution = {
		attack = 1,
		impact = 0
	},
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	},
	push_template = push_templates.medium,
	ogryn_push_template = push_templates.medium
}
damage_templates.beast_of_nurgle_tail_whip = {
	ogryn_disorientation_type = "ogryn_medium",
	stagger_category = "melee",
	toughness_multiplier = 20,
	unblockable = true,
	interrupt_alternate_fire = true,
	disorientation_type = "medium",
	armor_damage_modifier = {
		attack = default_armor_mod,
		impact = default_armor_mod
	},
	crit_mods = {
		attack = crit_armor_mod,
		impact = crit_impact_armor_mod
	},
	power_distribution = {
		attack = 0.2,
		impact = 0.5
	},
	cleave_distribution = {
		attack = 0.25,
		impact = 0.25
	},
	push_template = push_templates.medium,
	catapulting_template = CatapultingTemplates.plague_ogryn_catapult,
	force_look_function = ForcedLookSettings.look_functions.to_or_from_attack_direction,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.beast_of_nurgle_melee_friendly_fire = {
	interrupt_alternate_fire = true,
	toughness_multiplier = 2,
	block_cost_multiplier = 3.5,
	stagger_category = "melee",
	ogryn_disorientation_type = "ogryn_heavy",
	ignore_stagger_reduction = true,
	disorientation_type = "heavy",
	armor_damage_modifier = {
		attack = default_armor_mod,
		impact = default_armor_mod
	},
	crit_mods = {
		attack = crit_armor_mod,
		impact = crit_impact_armor_mod
	},
	power_distribution = {
		attack = 0.001,
		impact = 40
	},
	cleave_distribution = {
		attack = 0.25,
		impact = 1
	},
	force_look_function = ForcedLookSettings.look_functions.heavy,
	ragdoll_push_force = {
		500,
		800
	},
	gibbing_power = gibbing_power.heavy,
	gibbing_type = gibbing_types.sawing,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.beast_of_nurgle_self_gib = {
	stagger_category = "melee",
	armor_damage_modifier = {
		attack = default_armor_mod,
		impact = default_armor_mod
	},
	crit_mods = {
		attack = crit_armor_mod,
		impact = crit_impact_armor_mod
	},
	power_distribution = {
		attack = 1,
		impact = 1
	},
	cleave_distribution = {
		attack = 1,
		impact = 1
	},
	ragdoll_push_force = {
		500,
		800
	},
	gibbing_power = gibbing_power.impossible,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.toxic_gas_mutator = {
	ogryn_disorientation_type = "corruption_tick",
	toughness_multiplier = 3,
	permanent_damage_ratio = 1,
	stagger_category = "melee",
	ignore_mood_effects = false,
	ignore_toughness_broken_disorient = true,
	disorientation_type = "corruption_tick",
	ignore_depleting_toughness = true,
	armor_damage_modifier = {
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
			[armor_types.unarmored] = 0,
			[armor_types.armored] = 0,
			[armor_types.resistant] = 0,
			[armor_types.player] = 1,
			[armor_types.berserker] = 0,
			[armor_types.super_armor] = 0,
			[armor_types.disgustingly_resilient] = 0,
			[armor_types.void_shield] = 0
		}
	},
	power_distribution = {
		attack = 1,
		impact = 0
	},
	cleave_distribution = {
		attack = 1,
		impact = 0
	},
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.cultist_grenadier_gas = {
	ogryn_disorientation_type = "corruption_tick",
	toughness_disorientation_type = "toughness_corruption",
	toughness_multiplier = 7,
	permanent_damage_ratio = 0.8,
	stagger_category = "melee",
	ignore_mood_effects = false,
	ignore_toughness_broken_disorient = true,
	disorientation_type = "corruption_tick",
	ignore_depleting_toughness = true,
	armor_damage_modifier = {
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
			[armor_types.unarmored] = 0,
			[armor_types.armored] = 0,
			[armor_types.resistant] = 0,
			[armor_types.player] = 1,
			[armor_types.berserker] = 0,
			[armor_types.super_armor] = 0,
			[armor_types.disgustingly_resilient] = 0,
			[armor_types.void_shield] = 0
		}
	},
	power_distribution = {
		attack = 1,
		impact = 0
	},
	cleave_distribution = {
		attack = 1,
		impact = 0
	},
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.toxic_gas = {
	ogryn_disorientation_type = "corruption_tick",
	toughness_disorientation_type = "toughness_corruption",
	toughness_multiplier = 7,
	permanent_damage_ratio = 0.8,
	stagger_category = "melee",
	ignore_mood_effects = true,
	ignore_toughness_broken_disorient = true,
	disorientation_type = "corruption_tick",
	ignore_depleting_toughness = true,
	armor_damage_modifier = {
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
			[armor_types.unarmored] = 0,
			[armor_types.armored] = 0,
			[armor_types.resistant] = 0,
			[armor_types.player] = 1,
			[armor_types.berserker] = 0,
			[armor_types.super_armor] = 0,
			[armor_types.disgustingly_resilient] = 0,
			[armor_types.void_shield] = 0
		}
	},
	power_distribution = {
		attack = 1,
		impact = 0
	},
	cleave_distribution = {
		attack = 1,
		impact = 0
	},
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.mutator_yellow_stimmed_melee = {
	disorientation_type = "heavy",
	stagger_category = "melee",
	toughness_multiplier = 2,
	unblockable = true,
	interrupt_alternate_fire = true,
	ogryn_disorientation_type = "ogryn_heavy",
	armor_damage_modifier = {
		attack = default_armor_mod,
		impact = default_armor_mod
	},
	crit_mods = {
		attack = crit_armor_mod,
		impact = crit_impact_armor_mod
	},
	power_distribution = {
		attack = 60,
		impact = 0.5
	},
	cleave_distribution = {
		attack = 0.25,
		impact = 0.25
	},
	force_look_function = ForcedLookSettings.look_functions.heavy,
	push_template = push_templates.renegade_captain_heavy,
	ogryn_push_template = push_templates.renegade_captain_heavy,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.mutator_yellow_stimmed_melee_heavy = {
	disorientation_type = "heavy",
	stagger_category = "melee",
	toughness_multiplier = 2,
	unblockable = true,
	interrupt_alternate_fire = true,
	ogryn_disorientation_type = "ogryn_heavy",
	armor_damage_modifier = {
		attack = default_armor_mod,
		impact = default_armor_mod
	},
	crit_mods = {
		attack = crit_armor_mod,
		impact = crit_impact_armor_mod
	},
	power_distribution = {
		attack = 60,
		impact = 0.5
	},
	cleave_distribution = {
		attack = 0.25,
		impact = 0.25
	},
	force_look_function = ForcedLookSettings.look_functions.heavy,
	push_template = push_templates.renegade_captain_heavy,
	ogryn_push_template = push_templates.renegade_captain_heavy,
	catapulting_template = CatapultingTemplates.renegade_captain_powermaul_ground_slam_catapult,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.twin_grenade_explosion = {
	ignore_stagger_reduction = true,
	permanent_damage_ratio = 1,
	suppression_value = 15,
	ignore_stun_immunity = true,
	disorientation_type = "twin_grenade",
	ragdoll_push_force = 500,
	on_depleted_toughness_function_override_name = "spill_over",
	stagger_category = "ranged",
	toughness_multiplier = 3,
	ignore_toughness_broken_disorient = true,
	interrupt_alternate_fire = true,
	ogryn_disorientation_type = "twin_grenade",
	cleave_distribution = {
		attack = 1,
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
				attack = 65,
				impact = 4
			}
		}
	},
	power_distribution = {
		attack = 65,
		impact = 30
	},
	push_template = push_templates.twin_grenade,
	ogryn_push_template = push_templates.twin_grenade
}
damage_templates.twin_captain_two_aoe_sweep = {
	disorientation_type = "heavy",
	stagger_category = "melee",
	toughness_multiplier = 3,
	on_depleted_toughness_function_override_name = "spill_over",
	interrupt_alternate_fire = true,
	ogryn_disorientation_type = "ogryn_heavy",
	armor_damage_modifier = {
		attack = default_armor_mod,
		impact = default_armor_mod
	},
	crit_mods = {
		attack = crit_armor_mod,
		impact = crit_impact_armor_mod
	},
	power_distribution = {
		attack = 200,
		impact = 0.5
	},
	cleave_distribution = {
		attack = 0.25,
		impact = 0.25
	},
	force_look_function = ForcedLookSettings.look_functions.heavy,
	push_template = push_templates.renegade_twin_captain_sweep,
	ogryn_push_template = push_templates.renegade_twin_captain_sweep,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.twin_captain_two_melee_default = {
	disorientation_type = "heavy",
	stagger_category = "melee",
	toughness_multiplier = 2,
	interrupt_alternate_fire = true,
	ogryn_disorientation_type = "ogryn_heavy",
	armor_damage_modifier = {
		attack = default_armor_mod,
		impact = default_armor_mod
	},
	crit_mods = {
		attack = crit_armor_mod,
		impact = crit_impact_armor_mod
	},
	power_distribution = {
		attack = 60,
		impact = 0.5
	},
	cleave_distribution = {
		attack = 0.25,
		impact = 0.25
	},
	force_look_function = ForcedLookSettings.look_functions.heavy,
	push_template = push_templates.renegade_twin_captain_combo,
	ogryn_push_template = push_templates.renegade_twin_captain_combo,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}

return {
	base_templates = damage_templates,
	overrides = overrides
}
