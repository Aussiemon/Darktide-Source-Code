local ArmorSettings = require("scripts/settings/damage/armor_settings")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local DamageProfileSettings = require("scripts/settings/damage/damage_profile_settings")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local GibbingSettings = require("scripts/settings/gibbing/gibbing_settings")
local GibbingPower = GibbingSettings.gibbing_power
local gibbing_types = GibbingSettings.gibbing_types
local HerdingTemplates = require("scripts/settings/damage/herding_templates")
local WoundsTemplates = require("scripts/settings/damage/wounds_templates")
local damage_types = DamageSettings.damage_types
local armor_types = ArmorSettings.types
local damage_templates = {}
local overrides = {}

table.make_unique(damage_templates)
table.make_unique(overrides)

local damage_lerp_values = DamageProfileSettings.damage_lerp_values
local single_cleave = DamageProfileSettings.single_cleave
local light_cleave = DamageProfileSettings.light_cleave
local default_shield_override_stagger_strength = 4
damage_templates.default_ogryn_heavystubber_assault_snp = {
	suppression_value = 2.5,
	ragdoll_push_force = 600,
	stagger_category = "ranged",
	cleave_distribution = light_cleave,
	ranges = {
		min = {
			9,
			12
		},
		max = {
			25,
			40
		}
	},
	wounds_template = WoundsTemplates.heavy_stubber,
	armor_damage_modifier_ranged = {
		near = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_0_5,
				[armor_types.resistant] = damage_lerp_values.lerp_0_6,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_1,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_1,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_8,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_8
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1_25,
				[armor_types.armored] = damage_lerp_values.lerp_1,
				[armor_types.resistant] = damage_lerp_values.lerp_1_25,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_0_75,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
				[armor_types.void_shield] = damage_lerp_values.lerp_1
			}
		},
		far = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_0_8,
				[armor_types.armored] = damage_lerp_values.lerp_0_3,
				[armor_types.resistant] = damage_lerp_values.lerp_0_3,
				[armor_types.player] = damage_lerp_values.lerp_0_5,
				[armor_types.berserker] = damage_lerp_values.lerp_0_8,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_01,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_8,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_5
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_0_8,
				[armor_types.resistant] = damage_lerp_values.lerp_0_8,
				[armor_types.player] = damage_lerp_values.lerp_0_4,
				[armor_types.berserker] = damage_lerp_values.lerp_0_1,
				[armor_types.super_armor] = damage_lerp_values.no_damage,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_6,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_4
			}
		}
	},
	power_distribution = {
		attack = {
			100,
			200
		},
		impact = {
			10,
			20
		}
	},
	shield_override_stagger_strength = default_shield_override_stagger_strength,
	damage_type = damage_types.auto_bullet,
	gibbing_power = GibbingPower.heavy,
	gibbing_type = gibbing_types.ballistic,
	on_kill_area_suppression = {
		distance = 3,
		suppression_value = 1
	},
	gib_push_force = GibbingSettings.gib_push_force.ranged_heavy,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.default_ogryn_heavystubber_assault_snp_m2 = {
	suppression_value = 2.5,
	ragdoll_push_force = 600,
	stagger_category = "ranged",
	cleave_distribution = light_cleave,
	ranges = {
		min = {
			12,
			15
		},
		max = {
			30,
			60
		}
	},
	wounds_template = WoundsTemplates.heavy_stubber,
	armor_damage_modifier_ranged = {
		near = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_0_75,
				[armor_types.resistant] = damage_lerp_values.lerp_0_6,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_1,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_1,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_8,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_8
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1_25,
				[armor_types.armored] = damage_lerp_values.lerp_1,
				[armor_types.resistant] = damage_lerp_values.lerp_1_25,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_0_75,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
				[armor_types.void_shield] = damage_lerp_values.lerp_1
			}
		},
		far = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_0_8,
				[armor_types.armored] = damage_lerp_values.lerp_0_5,
				[armor_types.resistant] = damage_lerp_values.lerp_0_3,
				[armor_types.player] = damage_lerp_values.lerp_0_5,
				[armor_types.berserker] = damage_lerp_values.lerp_0_8,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_01,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_8,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_5
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_0_8,
				[armor_types.resistant] = damage_lerp_values.lerp_0_8,
				[armor_types.player] = damage_lerp_values.lerp_0_4,
				[armor_types.berserker] = damage_lerp_values.lerp_0_1,
				[armor_types.super_armor] = damage_lerp_values.no_damage,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_6,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_4
			}
		}
	},
	power_distribution = {
		attack = {
			140,
			290
		},
		impact = {
			20,
			40
		}
	},
	shield_override_stagger_strength = default_shield_override_stagger_strength,
	damage_type = damage_types.auto_bullet,
	gibbing_power = GibbingPower.heavy,
	gibbing_type = gibbing_types.ballistic,
	on_kill_area_suppression = {
		distance = 3,
		suppression_value = 1
	},
	gib_push_force = GibbingSettings.gib_push_force.ranged_heavy,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.default_ogryn_heavystubber_assault_snp_m3 = {
	suppression_value = 2.5,
	ragdoll_push_force = 600,
	stagger_category = "ranged",
	cleave_distribution = light_cleave,
	ranges = {
		min = {
			8,
			15
		},
		max = {
			20,
			35
		}
	},
	wounds_template = WoundsTemplates.heavy_stubber,
	armor_damage_modifier_ranged = {
		near = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_0_5,
				[armor_types.resistant] = damage_lerp_values.lerp_0_75,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_1,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_1,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_8
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1_25,
				[armor_types.armored] = damage_lerp_values.lerp_1,
				[armor_types.resistant] = damage_lerp_values.lerp_1_25,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_0_75,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
				[armor_types.void_shield] = damage_lerp_values.lerp_1
			}
		},
		far = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_0_8,
				[armor_types.armored] = damage_lerp_values.lerp_0_3,
				[armor_types.resistant] = damage_lerp_values.lerp_0_3,
				[armor_types.player] = damage_lerp_values.lerp_0_5,
				[armor_types.berserker] = damage_lerp_values.lerp_0_8,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_01,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_8,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_5
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_0_8,
				[armor_types.resistant] = damage_lerp_values.lerp_0_8,
				[armor_types.player] = damage_lerp_values.lerp_0_4,
				[armor_types.berserker] = damage_lerp_values.lerp_0_1,
				[armor_types.super_armor] = damage_lerp_values.no_damage,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_6,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_4
			}
		}
	},
	power_distribution = {
		attack = {
			80,
			160
		},
		impact = {
			8,
			16
		}
	},
	shield_override_stagger_strength = default_shield_override_stagger_strength,
	damage_type = damage_types.auto_bullet,
	gibbing_power = GibbingPower.medium,
	gibbing_type = gibbing_types.ballistic,
	on_kill_area_suppression = {
		distance = 3,
		suppression_value = 1
	},
	gib_push_force = GibbingSettings.gib_push_force.ranged_heavy,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.default_ogryn_heavystubber_assault = {
	stagger_category = "killshot",
	cleave_distribution = single_cleave,
	ranges = {
		min = {
			10,
			20
		},
		max = {
			25,
			50
		}
	},
	herding_template = HerdingTemplates.shot,
	wounds_template = WoundsTemplates.heavy_stubber,
	armor_damage_modifier_ranged = {
		near = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_0_8,
				[armor_types.resistant] = damage_lerp_values.lerp_0_6,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_0_75,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_01,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_6
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_0_8,
				[armor_types.armored] = damage_lerp_values.lerp_1,
				[armor_types.resistant] = damage_lerp_values.lerp_0_75,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_0_5,
				[armor_types.super_armor] = damage_lerp_values.no_damage,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_4,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_4
			}
		},
		far = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_0_8,
				[armor_types.armored] = damage_lerp_values.lerp_0_6,
				[armor_types.resistant] = damage_lerp_values.lerp_0_5,
				[armor_types.player] = damage_lerp_values.lerp_0_5,
				[armor_types.berserker] = damage_lerp_values.lerp_0_6,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_01,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_8,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_5
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_0_6,
				[armor_types.armored] = damage_lerp_values.lerp_1,
				[armor_types.resistant] = damage_lerp_values.lerp_0_4,
				[armor_types.player] = damage_lerp_values.lerp_0_4,
				[armor_types.berserker] = damage_lerp_values.lerp_0_1,
				[armor_types.super_armor] = damage_lerp_values.no_damage,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_6,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_4
			}
		}
	},
	critical_strike = {
		gibbing_power = GibbingPower.medium,
		gibbing_type = gibbing_types.ballistic
	},
	power_distribution = {
		attack = {
			40,
			100
		},
		impact = {
			2,
			6
		}
	},
	accumulative_stagger_strength_multiplier = {
		0.5,
		1
	},
	shield_override_stagger_strength = default_shield_override_stagger_strength,
	damage_type = damage_types.auto_bullet,
	gibbing_power = GibbingPower.light,
	gibbing_type = gibbing_types.ballistic,
	suppression_value = {
		0.5,
		1.5
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
	ragdoll_push_force = {
		200,
		300
	},
	gib_push_force = GibbingSettings.gib_push_force.ranged_heavy,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default,
			finesse_boost = {
				[armor_types.unarmored] = 0.75,
				[armor_types.resistant] = 0.2,
				[armor_types.armored] = 0.8
			},
			boost_curve_multiplier_finesse = damage_lerp_values.lerp_2
		}
	}
}

return {
	base_templates = damage_templates,
	overrides = overrides
}
