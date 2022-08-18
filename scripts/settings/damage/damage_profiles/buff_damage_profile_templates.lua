local ArmorSettings = require("scripts/settings/damage/armor_settings")
local DamageProfileSettings = require("scripts/settings/damage/damage_profile_settings")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local armor_types = ArmorSettings.types
local damage_types = DamageSettings.damage_types
local damage_templates = {}
local overrides = {}

table.make_unique(damage_templates)
table.make_unique(overrides)

local burninating_adm = {
	[armor_types.unarmored] = 1.5,
	[armor_types.armored] = 2,
	[armor_types.resistant] = 3,
	[armor_types.player] = 0.125,
	[armor_types.berserker] = 1,
	[armor_types.super_armor] = 0.1,
	[armor_types.disgustingly_resilient] = 1.25,
	[armor_types.void_shield] = 1,
	[armor_types.prop_armor] = 0.75
}
local burninating_barrel_adm = {
	[armor_types.unarmored] = 2,
	[armor_types.armored] = 1.75,
	[armor_types.resistant] = 3,
	[armor_types.player] = 0.5,
	[armor_types.berserker] = 2,
	[armor_types.super_armor] = 0.1,
	[armor_types.disgustingly_resilient] = 2.25,
	[armor_types.void_shield] = 2,
	[armor_types.prop_armor] = 1.75
}
local bleeding_adm = {
	[armor_types.unarmored] = 1,
	[armor_types.armored] = 0.75,
	[armor_types.resistant] = 2,
	[armor_types.player] = 1,
	[armor_types.berserker] = 1,
	[armor_types.super_armor] = 0.1,
	[armor_types.disgustingly_resilient] = 1.25,
	[armor_types.void_shield] = 1,
	[armor_types.prop_armor] = 0.75
}
local corruptor_corruption_adm = {
	[armor_types.unarmored] = 1,
	[armor_types.armored] = 0.75,
	[armor_types.resistant] = 0.75,
	[armor_types.player] = 0.1,
	[armor_types.berserker] = 0.5,
	[armor_types.super_armor] = 0.5,
	[armor_types.disgustingly_resilient] = 0.75,
	[armor_types.void_shield] = 0,
	[armor_types.prop_armor] = 0
}
damage_templates.liquid_area_fire_burning = {
	override_allow_friendly_fire = true,
	ignore_shield = true,
	ignore_toughness = true,
	stagger_category = "melee",
	armor_damage_modifier = {
		attack = burninating_adm,
		impact = burninating_adm
	},
	power_distribution = {
		attack = 40,
		impact = 0
	},
	cleave_distribution = {
		attack = 0.125,
		impact = 0
	},
	suppression_value = {
		100,
		100
	},
	on_kill_area_suppression = {
		suppression_value = {
			1,
			2
		},
		distance = {
			3,
			5
		}
	},
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.liquid_area_fire_burning_barrel = {
	override_allow_friendly_fire = true,
	ignore_shield = true,
	ignore_toughness = true,
	stagger_category = "melee",
	armor_damage_modifier = {
		attack = burninating_barrel_adm,
		impact = burninating_barrel_adm
	},
	power_distribution = {
		attack = 20,
		impact = 0
	},
	cleave_distribution = {
		attack = 0.125,
		impact = 0
	},
	suppression_value = {
		100,
		100
	},
	on_kill_area_suppression = {
		suppression_value = {
			1,
			2
		},
		distance = {
			3,
			5
		}
	},
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.grenadier_liquid_fire_burning = {
	disorientation_type = "burninating",
	toughness_multiplier = 3,
	ignore_shield = true,
	stagger_category = "melee",
	ogryn_disorientation_type = "burninating",
	armor_damage_modifier = {
		attack = DamageProfileSettings.flat_one_armor_mod,
		impact = DamageProfileSettings.flat_one_armor_mod
	},
	power_distribution = {
		attack = 20,
		impact = 0
	},
	cleave_distribution = {
		attack = 0.125,
		impact = 0
	},
	suppression_value = {
		5,
		10
	},
	on_kill_area_suppression = {
		suppression_value = {
			1,
			2
		},
		distance = {
			3,
			5
		}
	},
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.cultist_flamer_liquid_fire_burning = {
	disorientation_type = "burninating",
	toughness_multiplier = 3,
	ignore_shield = true,
	stagger_category = "melee",
	ogryn_disorientation_type = "burninating",
	armor_damage_modifier = {
		attack = DamageProfileSettings.flat_one_armor_mod,
		impact = DamageProfileSettings.flat_one_armor_mod
	},
	power_distribution = {
		attack = 20,
		impact = 0
	},
	cleave_distribution = {
		attack = 0.125,
		impact = 0
	},
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.burning = {
	disorientation_type = "burninating",
	toughness_multiplier = 3,
	ignore_shield = true,
	stagger_category = "melee",
	ogryn_disorientation_type = "burninating",
	armor_damage_modifier = {
		attack = burninating_adm,
		impact = burninating_adm
	},
	power_distribution = {
		attack = 400,
		impact = 0
	},
	cleave_distribution = {
		attack = 0.125,
		impact = 0
	},
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.corruptor_liquid_corruption = {
	ignore_toughness = true,
	stagger_category = "melee",
	permanent_damage_ratio = 1,
	armor_damage_modifier = {
		attack = corruptor_corruption_adm,
		impact = corruptor_corruption_adm
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
damage_templates.warpfire = {
	disorientation_type = "burninating",
	toughness_multiplier = 3,
	ignore_shield = true,
	stagger_category = "melee",
	ogryn_disorientation_type = "burninating",
	armor_damage_modifier = {
		attack = burninating_adm,
		impact = burninating_adm
	},
	power_distribution = {
		attack = 20,
		impact = 0
	},
	cleave_distribution = {
		attack = 0.125,
		impact = 0
	},
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.bleeding = {
	stagger_category = "melee",
	toughness_multiplier = 3,
	ignore_shield = true,
	armor_damage_modifier = {
		attack = bleeding_adm,
		impact = bleeding_adm
	},
	power_distribution = {
		attack = 400,
		impact = 0
	},
	cleave_distribution = {
		attack = 0.125,
		impact = 0
	},
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.protectorate_force_field = {
	stagger_category = "force_field",
	ignore_shield = true,
	power_distribution = {
		attack = 0.15,
		impact = 0.01
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
			[armor_types.prop_armor] = 1
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
			[armor_types.prop_armor] = 1
		}
	},
	damage_type = damage_types.warp,
	targets = {
		default_target = {}
	}
}
damage_templates.buff_instakill = {
	ignore_shield = true,
	stagger_category = "ranged",
	power_distribution = {
		attack = 0,
		impact = 0
	},
	targets = {
		default_target = {}
	}
}

return {
	base_templates = damage_templates,
	overrides = overrides
}
