local ArmorSettings = require("scripts/settings/damage/armor_settings")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local DamageProfileSettings = require("scripts/settings/damage/damage_profile_settings")
local GibbingSettings = require("scripts/settings/gibbing/gibbing_settings")
local GibbingPower = GibbingSettings.gibbing_power
local GibbingTypes = GibbingSettings.gibbing_types
local armor_types = ArmorSettings.types
local damage_templates = {}
local overrides = {}

table.make_unique(damage_templates)
table.make_unique(overrides)

local crit_armor_mod = DamageProfileSettings.crit_armor_mod
local crit_impact_armor_mod = DamageProfileSettings.crit_impact_armor_mod
local single_cleave = DamageProfileSettings.single_cleave
local double_cleave = DamageProfileSettings.double_cleave
local killshot_armor_mod = {
	near = {
		attack = {
			[armor_types.unarmored] = 0.8,
			[armor_types.armored] = 0.7,
			[armor_types.resistant] = 1,
			[armor_types.player] = 1,
			[armor_types.berserker] = 0.5,
			[armor_types.super_armor] = 0,
			[armor_types.disgustingly_resilient] = 0.5,
			[armor_types.void_shield] = 0.5
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
	far = {
		attack = {
			[armor_types.unarmored] = 1,
			[armor_types.armored] = 0.8,
			[armor_types.resistant] = 1,
			[armor_types.player] = 1,
			[armor_types.berserker] = 0.5,
			[armor_types.super_armor] = 0,
			[armor_types.disgustingly_resilient] = 0.75,
			[armor_types.void_shield] = 0.75
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
	}
}
damage_templates.default_killshot = {
	suppression_value = 0.6,
	ragdoll_push_force = 300,
	stagger_category = "killshot",
	cleave_distribution = double_cleave,
	ranges = {
		max = 12,
		min = 7
	},
	armor_damage_modifier_ranged = {
		near = {
			attack = {
				[armor_types.unarmored] = 0.8,
				[armor_types.armored] = 0.75,
				[armor_types.resistant] = 1,
				[armor_types.player] = 1,
				[armor_types.berserker] = 0.5,
				[armor_types.super_armor] = 0,
				[armor_types.disgustingly_resilient] = 0.5,
				[armor_types.void_shield] = 0.5
			},
			impact = {
				[armor_types.unarmored] = 1,
				[armor_types.armored] = 2,
				[armor_types.resistant] = 1,
				[armor_types.player] = 1,
				[armor_types.berserker] = 1,
				[armor_types.super_armor] = 0,
				[armor_types.disgustingly_resilient] = 0.5,
				[armor_types.void_shield] = 0.5
			}
		},
		far = {
			attack = {
				[armor_types.unarmored] = 1,
				[armor_types.armored] = 0.8,
				[armor_types.resistant] = 1,
				[armor_types.player] = 1,
				[armor_types.berserker] = 0.5,
				[armor_types.super_armor] = 0,
				[armor_types.disgustingly_resilient] = 0.4,
				[armor_types.void_shield] = 0.4
			},
			impact = {
				[armor_types.unarmored] = 1,
				[armor_types.armored] = 0.5,
				[armor_types.resistant] = 1,
				[armor_types.player] = 1,
				[armor_types.berserker] = 0.5,
				[armor_types.super_armor] = 0,
				[armor_types.disgustingly_resilient] = 0.4,
				[armor_types.void_shield] = 0.4
			}
		}
	},
	power_distribution = {
		attack = 0.175,
		impact = 0.4
	},
	gibbing_power = GibbingPower.heavy,
	on_kill_area_suppression = {
		distance = 0,
		suppression_value = 0
	},
	targets = {
		default_target = {
			boost_curve_multiplier_finesse = 2,
			boost_curve = PowerLevelSettings.boost_curves.default,
			finesse_boost = {
				[armor_types.unarmored] = 0.75,
				[armor_types.armored] = 0.75
			}
		}
	}
}
damage_templates.close_killshot = {
	suppression_value = 0.6,
	ragdoll_push_force = 150,
	stagger_category = "killshot",
	cleave_distribution = single_cleave,
	ranges = {
		max = 25,
		min = 8
	},
	armor_damage_modifier_ranged = killshot_armor_mod,
	power_distribution = {
		attack = 0.25,
		impact = 0.2
	},
	gibbing_power = GibbingPower.light,
	on_kill_area_suppression = {
		distance = 0,
		suppression_value = 0
	},
	targets = {
		default_target = {
			boost_curve_multiplier_finesse = 0.5,
			boost_curve = PowerLevelSettings.boost_curves.default,
			finesse_boost = {
				[armor_types.unarmored] = 0.5,
				[armor_types.armored] = 0.5
			}
		}
	}
}
damage_templates.medium_killshot = {
	suppression_value = 1,
	ragdoll_push_force = 500,
	stagger_category = "killshot",
	cleave_distribution = single_cleave,
	ranges = {
		max = 40,
		min = 10
	},
	armor_damage_modifier_ranged = {
		near = {
			attack = {
				[armor_types.unarmored] = 0.8,
				[armor_types.armored] = 0.75,
				[armor_types.resistant] = 1,
				[armor_types.player] = 1,
				[armor_types.berserker] = 0.5,
				[armor_types.super_armor] = 0,
				[armor_types.disgustingly_resilient] = 0.5,
				[armor_types.void_shield] = 0.5
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
		far = {
			attack = {
				[armor_types.unarmored] = 1,
				[armor_types.armored] = 0.9,
				[armor_types.resistant] = 1,
				[armor_types.player] = 1,
				[armor_types.berserker] = 0.5,
				[armor_types.super_armor] = 0,
				[armor_types.disgustingly_resilient] = 0.75,
				[armor_types.void_shield] = 0.75
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
		}
	},
	power_distribution = {
		attack = 0.4,
		impact = 0.2
	},
	gibbing_power = GibbingPower.medium,
	on_kill_area_suppression = {
		distance = 0,
		suppression_value = 0
	},
	targets = {
		default_target = {
			boost_curve_multiplier_finesse = 1.2,
			boost_curve = PowerLevelSettings.boost_curves.default,
			finesse_boost = {
				[armor_types.unarmored] = 0.75
			}
		}
	}
}
damage_templates.heavy_killshot = {
	suppression_value = 10,
	shield_multiplier = 10,
	ragdoll_push_force = 500,
	stagger_category = "killshot",
	cleave_distribution = double_cleave,
	ranges = {
		max = 40,
		min = 10
	},
	armor_damage_modifier_ranged = {
		near = {
			attack = {
				[armor_types.unarmored] = 0.9,
				[armor_types.armored] = 0.85,
				[armor_types.resistant] = 1.25,
				[armor_types.player] = 1,
				[armor_types.berserker] = 0.5,
				[armor_types.super_armor] = 0.5,
				[armor_types.disgustingly_resilient] = 0.5,
				[armor_types.void_shield] = 0.5
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
				[armor_types.unarmored] = 1,
				[armor_types.armored] = 0.9,
				[armor_types.resistant] = 1.25,
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
				[armor_types.super_armor] = 0.5,
				[armor_types.disgustingly_resilient] = 1,
				[armor_types.void_shield] = 1
			}
		}
	},
	power_distribution = {
		attack = 1,
		impact = 1.5
	},
	gibbing_power = GibbingPower.heavy,
	on_kill_area_suppression = {
		distance = 8,
		suppression_value = 12
	},
	targets = {
		default_target = {
			boost_curve_multiplier_finesse = 1.2,
			boost_curve = PowerLevelSettings.boost_curves.default,
			finesse_boost = {
				[armor_types.unarmored] = 1,
				[armor_types.armored] = 1
			}
		}
	}
}
damage_templates.heavy_killshot_bolter = table.clone(damage_templates.heavy_killshot)
damage_templates.shotgun_killshot = {
	ignore_stagger_reduction = true,
	suppression_value = 5,
	ragdoll_push_force = 500,
	ragdoll_only = true,
	stagger_category = "melee",
	cleave_distribution = {
		attack = 0.01,
		impact = 0.01
	},
	ranges = {
		max = 50,
		min = 10
	},
	armor_damage_modifier_ranged = {
		near = {
			attack = {
				[armor_types.unarmored] = 1,
				[armor_types.armored] = 0.75,
				[armor_types.resistant] = 0.8,
				[armor_types.player] = 1,
				[armor_types.berserker] = 0.9,
				[armor_types.super_armor] = 0.2,
				[armor_types.disgustingly_resilient] = 0.5,
				[armor_types.void_shield] = 0.5
			},
			impact = {
				[armor_types.unarmored] = 2,
				[armor_types.armored] = 3,
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
				[armor_types.unarmored] = 0.5,
				[armor_types.armored] = 0.5,
				[armor_types.resistant] = 0.5,
				[armor_types.player] = 0.1,
				[armor_types.berserker] = 0.2,
				[armor_types.super_armor] = 0,
				[armor_types.disgustingly_resilient] = 0.4,
				[armor_types.void_shield] = 0.4
			},
			impact = {
				[armor_types.unarmored] = 1,
				[armor_types.armored] = 1.25,
				[armor_types.resistant] = 0.5,
				[armor_types.player] = 0,
				[armor_types.berserker] = 0.5,
				[armor_types.super_armor] = 0,
				[armor_types.disgustingly_resilient] = 0.5,
				[armor_types.void_shield] = 0.5
			}
		}
	},
	power_distribution = {
		attack = 1,
		impact = 0.75
	},
	gibbing_power = GibbingPower.light,
	targets = {
		default_target = {
			boost_curve_multiplier_finesse = 1.2,
			boost_curve = PowerLevelSettings.boost_curves.default,
			finesse_boost = {
				[armor_types.unarmored] = 0.75
			}
		}
	}
}

return {
	base_templates = damage_templates,
	overrides = overrides
}
