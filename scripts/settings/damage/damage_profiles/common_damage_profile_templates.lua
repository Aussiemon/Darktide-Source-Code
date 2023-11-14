local ArmorSettings = require("scripts/settings/damage/armor_settings")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local ForcedLookSettings = require("scripts/settings/damage/forced_look_settings")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local PushSettings = require("scripts/settings/damage/push_settings")
local DamageProfileSettings = require("scripts/settings/damage/damage_profile_settings")
local armor_types = ArmorSettings.types
local damage_types = DamageSettings.damage_types
local push_templates = PushSettings.push_templates
local damage_templates = {}
local overrides = {}

table.make_unique(damage_templates)
table.make_unique(overrides)

local default_armor_mod = DamageProfileSettings.default_armor_mod
local crit_armor_mod = DamageProfileSettings.crit_armor_mod
local crit_impact_armor_mod = DamageProfileSettings.crit_impact_armor_mod
damage_templates.default = {
	stagger_category = "melee",
	armor_damage_modifier = {
		attack = default_armor_mod,
		impact = default_armor_mod
	},
	power_distribution = {
		attack = 0.1,
		impact = 0.5
	},
	cleave_distribution = {
		attack = 0.25,
		impact = 0.25
	},
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.default_ranged = {
	stagger_category = "ranged",
	suppression_value = 0,
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = 1,
			[armor_types.armored] = 0.5,
			[armor_types.resistant] = 1,
			[armor_types.player] = 1,
			[armor_types.berserker] = 0.5,
			[armor_types.super_armor] = 0,
			[armor_types.disgustingly_resilient] = 1,
			[armor_types.void_shield] = 1
		},
		impact = {
			[armor_types.unarmored] = 1,
			[armor_types.armored] = 0.5,
			[armor_types.resistant] = 1,
			[armor_types.player] = 1,
			[armor_types.berserker] = 0.5,
			[armor_types.super_armor] = 0,
			[armor_types.disgustingly_resilient] = 0.75,
			[armor_types.void_shield] = 0.75
		}
	},
	power_distribution = {
		attack = 0.1,
		impact = 0.25
	},
	cleave_distribution = {
		attack = 0.25,
		impact = 0.25
	},
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.light_push = {
	is_push = true,
	stagger_category = "melee",
	shield_override_stagger_strength = 10,
	power_distribution = {
		attack = 0,
		impact = {
			4,
			8
		}
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
			[armor_types.void_shield] = 0
		},
		impact = {
			[armor_types.unarmored] = 1,
			[armor_types.armored] = 1,
			[armor_types.resistant] = 1,
			[armor_types.player] = 1,
			[armor_types.berserker] = 0.5,
			[armor_types.super_armor] = 0.5,
			[armor_types.disgustingly_resilient] = 0.75,
			[armor_types.void_shield] = 0.75
		}
	},
	targets = {
		default_target = {}
	}
}
damage_templates.default_push = {
	is_push = true,
	shield_override_stagger_strength = 20,
	stagger_category = "melee",
	power_distribution = {
		attack = 0,
		impact = {
			8,
			12
		}
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
			[armor_types.void_shield] = 0
		},
		impact = {
			[armor_types.unarmored] = 1,
			[armor_types.armored] = 1,
			[armor_types.resistant] = 1,
			[armor_types.player] = 0,
			[armor_types.berserker] = 0.5,
			[armor_types.super_armor] = 0.5,
			[armor_types.disgustingly_resilient] = 1,
			[armor_types.void_shield] = 0
		}
	},
	stagger_duration_modifier = {
		0.5,
		0.75
	},
	targets = {
		default_target = {}
	}
}
damage_templates.ninja_push = {
	is_push = true,
	shield_override_stagger_strength = 15,
	stagger_category = "melee",
	power_distribution = {
		attack = 0,
		impact = {
			6,
			10
		}
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
			[armor_types.void_shield] = 0
		},
		impact = {
			[armor_types.unarmored] = 1,
			[armor_types.armored] = 1,
			[armor_types.resistant] = 1,
			[armor_types.player] = 1,
			[armor_types.berserker] = 0.5,
			[armor_types.super_armor] = 0.5,
			[armor_types.disgustingly_resilient] = 0.75,
			[armor_types.void_shield] = 0.75
		}
	},
	stagger_duration_modifier = {
		0.5,
		0.75
	},
	targets = {
		default_target = {}
	}
}
damage_templates.push_test = {
	is_push = true,
	stagger_category = "melee",
	shield_override_stagger_strength = 20,
	power_distribution = {
		attack = 0,
		impact = {
			5,
			9
		}
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
			[armor_types.void_shield] = 0
		},
		impact = {
			[armor_types.unarmored] = 1.25,
			[armor_types.armored] = 1,
			[armor_types.resistant] = 1,
			[armor_types.player] = 0,
			[armor_types.berserker] = 0.5,
			[armor_types.super_armor] = 0.5,
			[armor_types.disgustingly_resilient] = 1,
			[armor_types.void_shield] = 0
		}
	},
	targets = {
		default_target = {}
	}
}
damage_templates.push_psyker = {
	is_push = true,
	stagger_category = "melee",
	shield_override_stagger_strength = 30,
	power_distribution = {
		attack = 0,
		impact = 100
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
			[armor_types.void_shield] = 0
		},
		impact = {
			[armor_types.unarmored] = 1,
			[armor_types.armored] = 0.1,
			[armor_types.resistant] = 0.2,
			[armor_types.player] = 0,
			[armor_types.berserker] = 0.4,
			[armor_types.super_armor] = 0.01,
			[armor_types.disgustingly_resilient] = 0.7,
			[armor_types.void_shield] = 0
		}
	},
	targets = {
		default_target = {}
	}
}
damage_templates.push_psyker_outer = {
	is_push = true,
	stagger_category = "melee",
	stagger_override = "light",
	power_distribution = {
		attack = 0,
		impact = 10
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
			[armor_types.void_shield] = 0
		},
		impact = {
			[armor_types.unarmored] = 1,
			[armor_types.armored] = 1,
			[armor_types.resistant] = 1,
			[armor_types.player] = 0,
			[armor_types.berserker] = 0.5,
			[armor_types.super_armor] = 0.5,
			[armor_types.disgustingly_resilient] = 1,
			[armor_types.void_shield] = 0
		}
	},
	targets = {
		default_target = {}
	}
}
damage_templates.ogryn_push = {
	is_push = true,
	shield_override_stagger_strength = 30,
	ignore_stagger_reduction = true,
	stagger_category = "melee",
	power_distribution = {
		attack = 0,
		impact = {
			8,
			16
		}
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
			[armor_types.void_shield] = 0
		},
		impact = {
			[armor_types.unarmored] = 1.25,
			[armor_types.armored] = 1,
			[armor_types.resistant] = 1,
			[armor_types.player] = 0,
			[armor_types.berserker] = 0.5,
			[armor_types.super_armor] = 0.5,
			[armor_types.disgustingly_resilient] = 1,
			[armor_types.void_shield] = 0
		}
	},
	targets = {
		default_target = {}
	}
}
damage_templates.ogryn_shield_push = {
	is_push = true,
	shield_override_stagger_strength = 30,
	ignore_stagger_reduction = true,
	stagger_category = "melee",
	power_distribution = {
		attack = 0,
		impact = {
			16,
			32
		}
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
			[armor_types.void_shield] = 0
		},
		impact = {
			[armor_types.unarmored] = 1.25,
			[armor_types.armored] = 1,
			[armor_types.resistant] = 1,
			[armor_types.player] = 0,
			[armor_types.berserker] = 0.5,
			[armor_types.super_armor] = 0.5,
			[armor_types.disgustingly_resilient] = 1,
			[armor_types.void_shield] = 0
		}
	},
	targets = {
		default_target = {}
	}
}
damage_templates.default_shield_push = {
	is_push = true,
	shield_override_stagger_strength = 20,
	stagger_category = "melee",
	power_distribution = {
		attack = 0,
		impact = {
			8,
			12
		}
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
			[armor_types.void_shield] = 0
		},
		impact = {
			[armor_types.unarmored] = 1,
			[armor_types.armored] = 1,
			[armor_types.resistant] = 1,
			[armor_types.player] = 0,
			[armor_types.berserker] = 0.5,
			[armor_types.super_armor] = 0.5,
			[armor_types.disgustingly_resilient] = 1,
			[armor_types.void_shield] = 0
		}
	},
	stagger_duration_modifier = {
		0.5,
		0.75
	},
	targets = {
		default_target = {}
	}
}
damage_templates.plasma_vent_damage = {
	toughness_multiplier = 2,
	ignore_shield = true,
	ignore_toughness = false,
	stagger_category = "ranged",
	ignore_depleting_toughness = true,
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = 1,
			[armor_types.armored] = 1,
			[armor_types.resistant] = 1,
			[armor_types.player] = 1,
			[armor_types.berserker] = 1,
			[armor_types.super_armor] = 1,
			[armor_types.disgustingly_resilient] = 1,
			[armor_types.void_shield] = 1
		},
		impact = {
			[armor_types.unarmored] = 0,
			[armor_types.armored] = 0,
			[armor_types.resistant] = 0,
			[armor_types.player] = 0,
			[armor_types.berserker] = 0,
			[armor_types.super_armor] = 0,
			[armor_types.disgustingly_resilient] = 0,
			[armor_types.void_shield] = 0
		}
	},
	power_distribution = {
		attack = 8,
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
damage_templates.plasma_vent_damage_proficiency = {
	toughness_multiplier = 2,
	ignore_shield = true,
	ignore_toughness = false,
	stagger_category = "ranged",
	ignore_depleting_toughness = true,
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = 1,
			[armor_types.armored] = 1,
			[armor_types.resistant] = 1,
			[armor_types.player] = 1,
			[armor_types.berserker] = 1,
			[armor_types.super_armor] = 1,
			[armor_types.disgustingly_resilient] = 1,
			[armor_types.void_shield] = 1
		},
		impact = {
			[armor_types.unarmored] = 0,
			[armor_types.armored] = 0,
			[armor_types.resistant] = 0,
			[armor_types.player] = 0,
			[armor_types.berserker] = 0,
			[armor_types.super_armor] = 0,
			[armor_types.disgustingly_resilient] = 0,
			[armor_types.void_shield] = 0
		}
	},
	power_distribution = {
		attack = 8,
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
damage_templates.plasma_overheat = {
	ignore_shield = true,
	ignore_toughness = false,
	shield_override_stagger_strength = 120,
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
			[armor_types.void_shield] = 1
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
		attack = 600,
		impact = 1
	},
	power_distribution_ranged = {
		attack = {
			far = 100,
			near = 600
		},
		impact = {
			far = 10,
			near = 75
		}
	},
	cleave_distribution = {
		attack = 1,
		impact = 1
	},
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.knocked_down_tick = {
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
			[armor_types.void_shield] = 1
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
		attack = 70,
		impact = 0
	},
	cleave_distribution = {
		attack = 1,
		impact = 1
	},
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.netted_tick = {
	ignore_toughness = true,
	stagger_category = "melee",
	permanent_damage_ratio = 0.9,
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = 1,
			[armor_types.armored] = 0.75,
			[armor_types.resistant] = 0.75,
			[armor_types.player] = 0.1,
			[armor_types.berserker] = 0.5,
			[armor_types.super_armor] = 0.5,
			[armor_types.disgustingly_resilient] = 0.75,
			[armor_types.void_shield] = 0
		},
		impact = {
			[armor_types.unarmored] = 1,
			[armor_types.armored] = 0.75,
			[armor_types.resistant] = 0.75,
			[armor_types.player] = 0.1,
			[armor_types.berserker] = 0.5,
			[armor_types.super_armor] = 0.5,
			[armor_types.disgustingly_resilient] = 0.75,
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
damage_templates.grimoire_tick = {
	stagger_category = "ranged",
	permanent_damage_ratio = 1,
	ignore_shield = true,
	ignore_toughness = true,
	skip_on_hit_proc = true,
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = 1,
			[armor_types.armored] = 1,
			[armor_types.resistant] = 1,
			[armor_types.player] = 1,
			[armor_types.berserker] = 1,
			[armor_types.super_armor] = 1,
			[armor_types.disgustingly_resilient] = 1,
			[armor_types.void_shield] = 1
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
		impact = 0
	},
	cleave_distribution = {
		attack = 1,
		impact = 0
	},
	damage_type = damage_types.grimoire,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.overheat_exploding_tick = {
	ignore_shield = true,
	ignore_toughness = true,
	stagger_category = "melee",
	armor_damage_modifier = {
		attack = default_armor_mod,
		impact = default_armor_mod
	},
	power_distribution = {
		attack = 0,
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
damage_templates.warp_charge_exploding_tick = {
	ignore_shield = true,
	ignore_toughness = true,
	stagger_category = "melee",
	armor_damage_modifier = {
		attack = default_armor_mod,
		impact = default_armor_mod
	},
	power_distribution = {
		attack = 0,
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
damage_templates.falling_light = {
	ogryn_disorientation_type = "falling_light",
	stagger_category = "ranged",
	ignore_shield = true,
	ignore_toughness = true,
	interrupt_alternate_fire = true,
	disorientation_type = "falling_light",
	armor_damage_modifier = {
		attack = default_armor_mod,
		impact = default_armor_mod
	},
	power_distribution = {
		attack = 0.4,
		impact = 0.4
	},
	cleave_distribution = {
		attack = 0.25,
		impact = 0.25
	},
	force_look_function = ForcedLookSettings.look_functions.light,
	push_template = push_templates.heavy,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
overrides.falling_heavy = {
	parent_template_name = "falling_light",
	overrides = {
		{
			"power_distribution",
			"attack",
			1.4
		},
		{
			"power_distribution",
			"impact",
			1.4
		},
		{
			"force_look_function",
			ForcedLookSettings.look_functions.heavy
		},
		{
			"disorientation_type",
			"falling_heavy"
		}
	}
}
damage_templates.kill_volume_and_off_navmesh = {
	stagger_category = "melee",
	armor_damage_modifier = {
		attack = default_armor_mod,
		impact = default_armor_mod
	},
	power_distribution = {
		attack = 0.1,
		impact = 0.5
	},
	cleave_distribution = {
		attack = 0.25,
		impact = 0.25
	},
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
