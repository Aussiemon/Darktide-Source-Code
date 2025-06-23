-- chunkname: @scripts/settings/damage/damage_profiles/archetypes/ogryn_damage_profile_templates.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local DamageProfileSettings = require("scripts/settings/damage/damage_profile_settings")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local GibbingSettings = require("scripts/settings/gibbing/gibbing_settings")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local WoundsTemplates = require("scripts/settings/damage/wounds_templates")
local armor_types = ArmorSettings.types
local damage_types = DamageSettings.damage_types
local gibbing_power = GibbingSettings.gibbing_power
local gibbing_types = GibbingSettings.gibbing_types
local damage_templates = {}
local overrides = {}

table.make_unique(damage_templates)
table.make_unique(overrides)

damage_templates.shout_stagger_ogryn_taunt = {
	stagger_category = "melee",
	gibbing_power = 0,
	suppression_value = 10,
	suppression_type = "ability",
	power_distribution = {
		attack = 0,
		impact = 1
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
			[armor_types.unarmored] = 0.1,
			[armor_types.armored] = 0.1,
			[armor_types.resistant] = 0.1,
			[armor_types.player] = 0.1,
			[armor_types.berserker] = 0.1,
			[armor_types.super_armor] = 0.1,
			[armor_types.disgustingly_resilient] = 0.1,
			[armor_types.void_shield] = 0.1
		}
	},
	targets = {
		default_target = {}
	}
}
damage_templates.ogryn_charge_impact = {
	is_push = true,
	stagger_category = "explosion",
	ignore_stagger_reduction = true,
	power_distribution = {
		attack = 0,
		impact = 250
	},
	cleave_distribution = {
		attack = 0,
		impact = math.huge
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
			[armor_types.unarmored] = 6,
			[armor_types.armored] = 6,
			[armor_types.resistant] = 6,
			[armor_types.player] = 6,
			[armor_types.berserker] = 6,
			[armor_types.super_armor] = 6,
			[armor_types.disgustingly_resilient] = 6,
			[armor_types.void_shield] = 6
		}
	},
	targets = {
		default_target = {}
	},
	attacker_impact_effects = {
		camera_effect_shake_event = "ogryn_charge_impact"
	}
}
damage_templates.ogryn_charge_finish = {
	stagger_category = "explosion",
	ragdoll_push_force = 500,
	ignore_stagger_reduction = true,
	cleave_distribution = {
		attack = 0.1,
		impact = 0.1
	},
	ranges = {
		max = 20,
		min = 19
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
				[armor_types.unarmored] = 5,
				[armor_types.armored] = 5,
				[armor_types.resistant] = 5,
				[armor_types.player] = 5,
				[armor_types.berserker] = 5,
				[armor_types.super_armor] = 5,
				[armor_types.disgustingly_resilient] = 5,
				[armor_types.void_shield] = 5
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
				[armor_types.unarmored] = 5,
				[armor_types.armored] = 5,
				[armor_types.resistant] = 5,
				[armor_types.player] = 5,
				[armor_types.berserker] = 5,
				[armor_types.super_armor] = 5,
				[armor_types.disgustingly_resilient] = 5,
				[armor_types.void_shield] = 5
			}
		}
	},
	power_distribution = {
		attack = 0,
		impact = 10
	},
	targets = {
		default_target = {
			boost_curve_multiplier_finesse = 1.2,
			boost_curve = PowerLevelSettings.boost_curves.default,
			finesse_boost = {
				[armor_types.unarmored] = 1
			}
		}
	}
}
damage_templates.ogryn_charge_impact_damage = {
	stagger_duration_modifier = 1.5,
	is_push = true,
	ignore_stagger_reduction = true,
	stagger_category = "explosion",
	power_distribution = {
		attack = 50,
		impact = 250
	},
	cleave_distribution = {
		attack = 0,
		impact = 1
	},
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = 1,
			[armor_types.armored] = 1,
			[armor_types.resistant] = 1,
			[armor_types.player] = 1,
			[armor_types.berserker] = 0.5,
			[armor_types.super_armor] = 0.1,
			[armor_types.disgustingly_resilient] = 0.5,
			[armor_types.void_shield] = 0.5
		},
		impact = {
			[armor_types.unarmored] = 6,
			[armor_types.armored] = 6,
			[armor_types.resistant] = 6,
			[armor_types.player] = 6,
			[armor_types.berserker] = 6,
			[armor_types.super_armor] = 6,
			[armor_types.disgustingly_resilient] = 6,
			[armor_types.void_shield] = 6
		}
	},
	targets = {
		default_target = {}
	},
	attacker_impact_effects = {
		camera_effect_shake_event = "ogryn_charge_impact"
	}
}
damage_templates.ogryn_charge_finish_damage = {
	stagger_duration_modifier = 1.5,
	ragdoll_push_force = 500,
	ignore_stagger_reduction = true,
	stagger_category = "explosion",
	power_distribution = {
		attack = 50,
		impact = 250
	},
	cleave_distribution = {
		attack = 0.1,
		impact = 0.1
	},
	ranges = {
		max = 20,
		min = 19
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
				[armor_types.unarmored] = 5,
				[armor_types.armored] = 5,
				[armor_types.resistant] = 5,
				[armor_types.player] = 5,
				[armor_types.berserker] = 5,
				[armor_types.super_armor] = 5,
				[armor_types.disgustingly_resilient] = 5,
				[armor_types.void_shield] = 5
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
				[armor_types.unarmored] = 5,
				[armor_types.armored] = 5,
				[armor_types.resistant] = 5,
				[armor_types.player] = 5,
				[armor_types.berserker] = 5,
				[armor_types.super_armor] = 5,
				[armor_types.disgustingly_resilient] = 5,
				[armor_types.void_shield] = 5
			}
		}
	},
	targets = {
		default_target = {
			boost_curve_multiplier_finesse = 1.2,
			boost_curve = PowerLevelSettings.boost_curves.default,
			finesse_boost = {
				[armor_types.unarmored] = 1
			}
		}
	}
}

return {
	base_templates = damage_templates,
	overrides = overrides
}
