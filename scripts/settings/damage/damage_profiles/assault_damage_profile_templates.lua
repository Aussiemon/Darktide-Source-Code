-- chunkname: @scripts/settings/damage/damage_profiles/assault_damage_profile_templates.lua

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

local single_cleave = DamageProfileSettings.single_cleave
local assault_armor_mod = {
	near = {
		attack = {
			[armor_types.unarmored] = 1,
			[armor_types.armored] = 0.25,
			[armor_types.resistant] = 1,
			[armor_types.player] = 1,
			[armor_types.berserker] = 0.5,
			[armor_types.super_armor] = 0,
			[armor_types.disgustingly_resilient] = 0.75,
			[armor_types.void_shield] = 0.75
		},
		impact = {
			[armor_types.unarmored] = 1,
			[armor_types.armored] = 0,
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
			[armor_types.unarmored] = 0.75,
			[armor_types.armored] = 0.1,
			[armor_types.resistant] = 0.5,
			[armor_types.player] = 0.5,
			[armor_types.berserker] = 0.5,
			[armor_types.super_armor] = 0,
			[armor_types.disgustingly_resilient] = 0.5,
			[armor_types.void_shield] = 0.5
		},
		impact = {
			[armor_types.unarmored] = 0.25,
			[armor_types.armored] = 0,
			[armor_types.resistant] = 0.35,
			[armor_types.player] = 0.35,
			[armor_types.berserker] = 0.1,
			[armor_types.super_armor] = 0,
			[armor_types.disgustingly_resilient] = 0.5,
			[armor_types.void_shield] = 0.5
		}
	}
}

damage_templates.default_assault = {
	suppression_value = 1,
	ragdoll_push_force = 150,
	stagger_category = "ranged",
	cleave_distribution = single_cleave,
	ranges = {
		max = 15,
		min = 8
	},
	armor_damage_modifier_ranged = assault_armor_mod,
	power_distribution = {
		attack = 0.2,
		impact = 0.35
	},
	gibbing_power = GibbingPower.medium,
	on_kill_area_suppression = {
		distance = 5,
		suppression_value = 8
	},
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.autogun_assault = {
	suppression_value = 0.6,
	ragdoll_push_force = 250,
	stagger_category = "ranged",
	cleave_distribution = single_cleave,
	ranges = {
		max = 25,
		min = 10
	},
	armor_damage_modifier_ranged = {
		near = {
			attack = {
				[armor_types.unarmored] = 1,
				[armor_types.armored] = 0.65,
				[armor_types.resistant] = 0.5,
				[armor_types.player] = 1,
				[armor_types.berserker] = 0.5,
				[armor_types.super_armor] = 0.05,
				[armor_types.disgustingly_resilient] = 0.6,
				[armor_types.void_shield] = 0.6
			},
			impact = {
				[armor_types.unarmored] = 1,
				[armor_types.armored] = 1,
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
				[armor_types.unarmored] = 0.75,
				[armor_types.armored] = 0.5,
				[armor_types.resistant] = 0.3,
				[armor_types.player] = 0.5,
				[armor_types.berserker] = 0.5,
				[armor_types.super_armor] = 0.05,
				[armor_types.disgustingly_resilient] = 0.5,
				[armor_types.void_shield] = 0.5
			},
			impact = {
				[armor_types.unarmored] = 0.5,
				[armor_types.armored] = 0.5,
				[armor_types.resistant] = 0.35,
				[armor_types.player] = 0.35,
				[armor_types.berserker] = 0.1,
				[armor_types.super_armor] = 0,
				[armor_types.disgustingly_resilient] = 0.4,
				[armor_types.void_shield] = 0.4
			}
		}
	},
	power_distribution = {
		attack = 0.3,
		impact = 0.4
	},
	gibbing_power = GibbingPower.medium,
	on_kill_area_suppression = {
		distance = 5,
		suppression_value = 8
	},
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.autopistol_assault = table.clone(damage_templates.autogun_assault)
damage_templates.autopistol_assault.ragdoll_push_force = {
	100,
	150
}
damage_templates.autopistol_assault.power_distribution.attack = 0.175
damage_templates.autopistol_assault.power_distribution.impact = 0.25
damage_templates.autopistol_assault.gibbing_power = GibbingPower.light
damage_templates.autopistol_assault.armor_damage_modifier_ranged = {
	near = {
		attack = {
			[armor_types.unarmored] = 1,
			[armor_types.armored] = 0.75,
			[armor_types.resistant] = 0.5,
			[armor_types.player] = 1,
			[armor_types.berserker] = 0.5,
			[armor_types.super_armor] = 0.05,
			[armor_types.disgustingly_resilient] = 0.6,
			[armor_types.void_shield] = 0.6
		},
		impact = {
			[armor_types.unarmored] = 1,
			[armor_types.armored] = 1,
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
			[armor_types.unarmored] = 0.75,
			[armor_types.armored] = 0.5,
			[armor_types.resistant] = 0.3,
			[armor_types.player] = 0.5,
			[armor_types.berserker] = 0.5,
			[armor_types.super_armor] = 0.05,
			[armor_types.disgustingly_resilient] = 0.5,
			[armor_types.void_shield] = 0.5
		},
		impact = {
			[armor_types.unarmored] = 0.5,
			[armor_types.armored] = 0.5,
			[armor_types.resistant] = 0.35,
			[armor_types.player] = 0.35,
			[armor_types.berserker] = 0.1,
			[armor_types.super_armor] = 0,
			[armor_types.disgustingly_resilient] = 0.4,
			[armor_types.void_shield] = 0.4
		}
	}
}
damage_templates.autopistol_snp_assault = table.clone(damage_templates.autopistol_assault)
damage_templates.autopistol_snp_assault.suppression_value = 2
damage_templates.autopistol_snp_assault.suppression_value = 2
damage_templates.ogryn_shotgun = {
	ignore_stagger_reduction = true,
	suppression_value = 5,
	ragdoll_push_force = 1000,
	ragdoll_only = true,
	stagger_category = "melee",
	cleave_distribution = {
		attack = 0.01,
		impact = 0.1
	},
	ranges = {
		max = 40,
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
				[armor_types.armored] = 0.75,
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
		attack = 3.5,
		impact = 5
	},
	gibbing_power = GibbingPower.heavy,
	gibbing_type = GibbingTypes.plasma,
	on_kill_area_suppression = {
		distance = 5,
		suppression_value = 8
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
damage_templates.shotgun_assault = {
	ignore_stagger_reduction = true,
	suppression_value = 5,
	ragdoll_only = true,
	stagger_category = "ranged",
	cleave_distribution = {
		attack = 0.01,
		impact = 0.01
	},
	ranges = {
		max = 16,
		min = 8
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
				[armor_types.disgustingly_resilient] = 1,
				[armor_types.void_shield] = 1
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
				[armor_types.unarmored] = 0.3,
				[armor_types.armored] = 0.2,
				[armor_types.resistant] = 0.2,
				[armor_types.player] = 0.1,
				[armor_types.berserker] = 0.2,
				[armor_types.super_armor] = 0,
				[armor_types.disgustingly_resilient] = 0.4,
				[armor_types.void_shield] = 0.4
			},
			impact = {
				[armor_types.unarmored] = 1,
				[armor_types.armored] = 0.75,
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
		attack = 1.5,
		impact = 1.75
	},
	gibbing_power = GibbingPower.light,
	on_kill_area_suppression = {
		distance = 5,
		suppression_value = 8
	},
	targets = {
		default_target = {
			boost_curve_multiplier_finesse = 1.2,
			boost_curve = PowerLevelSettings.boost_curves.default,
			finesse_boost = {
				[armor_types.unarmored] = 0.75
			}
		}
	},
	ragdoll_push_force = {
		400,
		600
	}
}
damage_templates.rippergun_assault = table.clone(damage_templates.shotgun_assault)

return {
	base_templates = damage_templates,
	overrides = overrides
}
