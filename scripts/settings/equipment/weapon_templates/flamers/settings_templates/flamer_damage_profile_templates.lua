local ArmorSettings = require("scripts/settings/damage/armor_settings")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local DamageProfileSettings = require("scripts/settings/damage/damage_profile_settings")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local GibbingSettings = require("scripts/settings/gibbing/gibbing_settings")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local GibbingPower = GibbingSettings.gibbing_power
local GibbingTypes = GibbingSettings.gibbing_types
local damage_types = DamageSettings.damage_types
local armor_types = ArmorSettings.types
local damage_templates = {}
local overrides = {}

table.make_unique(damage_templates)
table.make_unique(overrides)

local melee_attack_strengths = AttackSettings.melee_attack_strength
local crit_armor_mod = DamageProfileSettings.crit_armor_mod
local crit_impact_armor_mod = DamageProfileSettings.crit_impact_armor_mod
local damage_lerp_values = DamageProfileSettings.damage_lerp_values
local single_cleave = DamageProfileSettings.single_cleave
local double_cleave = DamageProfileSettings.double_cleave
local medium_cleave = DamageProfileSettings.medium_cleave
damage_templates.default_flamer_killshot = {
	suppression_value = 4,
	ignore_shield = false,
	ragdoll_push_force = 750,
	ignore_stagger_reduction = true,
	stagger_category = "ranged",
	cleave_distribution = {
		attack = 0.1,
		impact = 0.1
	},
	ranges = {
		max = 30,
		min = 20
	},
	armor_damage_modifier_ranged = {
		near = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_1,
				[armor_types.resistant] = damage_lerp_values.lerp_2,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_1,
				[armor_types.super_armor] = damage_lerp_values.lerp_2,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
				[armor_types.void_shield] = damage_lerp_values.lerp_1,
				[armor_types.prop_armor] = damage_lerp_values.lerp_1
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_2,
				[armor_types.armored] = damage_lerp_values.lerp_3,
				[armor_types.resistant] = damage_lerp_values.lerp_2,
				[armor_types.player] = damage_lerp_values.lerp_2,
				[armor_types.berserker] = damage_lerp_values.lerp_2,
				[armor_types.super_armor] = damage_lerp_values.lerp_2,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_2_5,
				[armor_types.void_shield] = damage_lerp_values.lerp_2_5,
				[armor_types.prop_armor] = damage_lerp_values.lerp_3
			}
		},
		far = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_1,
				[armor_types.resistant] = damage_lerp_values.lerp_2,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_1,
				[armor_types.super_armor] = damage_lerp_values.lerp_2,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
				[armor_types.void_shield] = damage_lerp_values.lerp_1,
				[armor_types.prop_armor] = damage_lerp_values.lerp_1
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_2,
				[armor_types.armored] = damage_lerp_values.lerp_3,
				[armor_types.resistant] = damage_lerp_values.lerp_2,
				[armor_types.player] = damage_lerp_values.lerp_2,
				[armor_types.berserker] = damage_lerp_values.lerp_2,
				[armor_types.super_armor] = damage_lerp_values.lerp_2,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_2_5,
				[armor_types.void_shield] = damage_lerp_values.lerp_2_5,
				[armor_types.prop_armor] = damage_lerp_values.lerp_3
			}
		}
	},
	power_distribution = {
		attack = 2,
		impact = 1.5
	},
	damage_type = damage_types.plasma,
	gibbing_power = GibbingPower.medium,
	gibbing_type = GibbingTypes.plasma,
	on_kill_area_suppression = {
		distance = 8,
		suppression_value = 10
	},
	targets = {
		default_target = {
			boost_curve_multiplier_finesse = 0.5,
			boost_curve = PowerLevelSettings.boost_curves.default,
			finesse_boost = {
				[armor_types.unarmored] = 0.75
			}
		}
	}
}
damage_templates.default_flamer_bfg = {
	suppression_value = 8,
	ignore_shield = true,
	ragdoll_push_force = 100,
	ignore_stagger_reduction = true,
	stagger_category = "ranged",
	cleave_distribution = {
		attack = 0.15,
		impact = 0.15
	},
	ranges = {
		max = 20,
		min = 10
	},
	armor_damage_modifier_ranged = {
		near = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_1,
				[armor_types.resistant] = damage_lerp_values.lerp_1,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_1,
				[armor_types.super_armor] = damage_lerp_values.no_damage,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
				[armor_types.void_shield] = damage_lerp_values.lerp_1,
				[armor_types.prop_armor] = damage_lerp_values.lerp_1
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_2,
				[armor_types.armored] = damage_lerp_values.lerp_3,
				[armor_types.resistant] = damage_lerp_values.lerp_2,
				[armor_types.player] = damage_lerp_values.lerp_2,
				[armor_types.berserker] = damage_lerp_values.lerp_2,
				[armor_types.super_armor] = damage_lerp_values.no_damage,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_3,
				[armor_types.void_shield] = damage_lerp_values.lerp_3,
				[armor_types.prop_armor] = damage_lerp_values.lerp_3
			}
		},
		far = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_1,
				[armor_types.resistant] = damage_lerp_values.lerp_1,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_1,
				[armor_types.super_armor] = damage_lerp_values.no_damage,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
				[armor_types.void_shield] = damage_lerp_values.lerp_1,
				[armor_types.prop_armor] = damage_lerp_values.lerp_1
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_2,
				[armor_types.armored] = damage_lerp_values.lerp_3,
				[armor_types.resistant] = damage_lerp_values.lerp_2,
				[armor_types.player] = damage_lerp_values.lerp_2,
				[armor_types.berserker] = damage_lerp_values.lerp_2,
				[armor_types.super_armor] = damage_lerp_values.lerp_2,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_3,
				[armor_types.void_shield] = damage_lerp_values.lerp_3,
				[armor_types.prop_armor] = damage_lerp_values.lerp_3
			}
		}
	},
	power_distribution = {
		attack = 4,
		impact = 4
	},
	damage_type = damage_types.plasma,
	gibbing_power = GibbingPower.heavy,
	gibbing_type = GibbingTypes.plasma,
	on_kill_area_suppression = {
		distance = 8,
		suppression_value = 10
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
damage_templates.default_flamer_demolition = {
	suppression_value = 0.5,
	ragdoll_push_force = 12,
	ignore_stagger_reduction = true,
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
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_1,
				[armor_types.resistant] = damage_lerp_values.lerp_1,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_1,
				[armor_types.super_armor] = damage_lerp_values.no_damage,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
				[armor_types.void_shield] = damage_lerp_values.lerp_1,
				[armor_types.prop_armor] = damage_lerp_values.lerp_1
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_2,
				[armor_types.resistant] = damage_lerp_values.lerp_1,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_1,
				[armor_types.super_armor] = damage_lerp_values.no_damage,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_2,
				[armor_types.void_shield] = damage_lerp_values.lerp_2,
				[armor_types.prop_armor] = damage_lerp_values.lerp_2
			}
		},
		far = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_1,
				[armor_types.resistant] = damage_lerp_values.lerp_1,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_1,
				[armor_types.super_armor] = damage_lerp_values.no_damage,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
				[armor_types.void_shield] = damage_lerp_values.lerp_1,
				[armor_types.prop_armor] = damage_lerp_values.lerp_1
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_2,
				[armor_types.resistant] = damage_lerp_values.lerp_1,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_1,
				[armor_types.super_armor] = damage_lerp_values.no_damage,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_2,
				[armor_types.void_shield] = damage_lerp_values.lerp_2,
				[armor_types.prop_armor] = damage_lerp_values.lerp_2
			}
		}
	},
	power_distribution = {
		attack = 1,
		impact = 3
	},
	damage_type = damage_types.laser,
	gibbing_type = GibbingTypes.plasma,
	gibbing_power = GibbingPower.heavy,
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
overrides.light_flamer_demolition = {
	parent_template_name = "default_flamer_demolition",
	overrides = {
		{
			"power_distribution",
			"attack",
			0.25
		},
		{
			"power_distribution",
			"impact",
			0.5
		}
	}
}
local assault_flamer_armor_mod = {
	near = {
		attack = {
			[armor_types.unarmored] = 2,
			[armor_types.armored] = 1.75,
			[armor_types.resistant] = 2,
			[armor_types.player] = 1,
			[armor_types.berserker] = 2.5,
			[armor_types.super_armor] = 0.25,
			[armor_types.disgustingly_resilient] = 1.5,
			[armor_types.void_shield] = 1,
			[armor_types.prop_armor] = 1
		},
		impact = {
			[armor_types.unarmored] = 1,
			[armor_types.armored] = 0.75,
			[armor_types.resistant] = 0.75,
			[armor_types.player] = 1,
			[armor_types.berserker] = 1.5,
			[armor_types.super_armor] = 0.2,
			[armor_types.disgustingly_resilient] = 1,
			[armor_types.void_shield] = 1,
			[armor_types.prop_armor] = 1
		}
	},
	far = {
		attack = {
			[armor_types.unarmored] = 1,
			[armor_types.armored] = 0.75,
			[armor_types.resistant] = 1,
			[armor_types.player] = 1,
			[armor_types.berserker] = 1,
			[armor_types.super_armor] = 0,
			[armor_types.disgustingly_resilient] = 0.7,
			[armor_types.void_shield] = 1,
			[armor_types.prop_armor] = 0.75
		},
		impact = {
			[armor_types.unarmored] = 0.75,
			[armor_types.armored] = 0.25,
			[armor_types.resistant] = 0.3,
			[armor_types.player] = 0,
			[armor_types.berserker] = 1.25,
			[armor_types.super_armor] = 0.1,
			[armor_types.disgustingly_resilient] = 0.75,
			[armor_types.void_shield] = 0.5,
			[armor_types.prop_armor] = 0.75
		}
	}
}
damage_templates.default_flamer_assault = {
	duration_scale_bonus = 0.5,
	accumulative_stagger_strength_multiplier = 0.5,
	suppression_value = 10,
	ragdoll_push_force = 10,
	gibbing_power = 0,
	stagger_category = "flamer",
	cleave_distribution = {
		attack = 0.1,
		impact = 0.1
	},
	ranges = {
		max = 15,
		min = 5
	},
	armor_damage_modifier_ranged = assault_flamer_armor_mod,
	damage_type = damage_types.burning,
	gibbing_type = GibbingTypes.plasma,
	targets = {
		{
			power_distribution = {
				attack = {
					8,
					12
				},
				impact = {
					5,
					9
				}
			}
		},
		{
			power_distribution = {
				attack = {
					10,
					16
				},
				impact = {
					5,
					10
				}
			}
		},
		{
			power_distribution = {
				attack = {
					12,
					20
				},
				impact = {
					7,
					12
				}
			}
		},
		{
			power_distribution = {
				attack = {
					15,
					30
				},
				impact = {
					8,
					15
				}
			}
		},
		{
			power_distribution = {
				attack = {
					17.5,
					35
				},
				impact = {
					10,
					15
				}
			}
		},
		{
			power_distribution = {
				attack = {
					20,
					40
				},
				impact = {
					10,
					15
				}
			}
		},
		default_target = {
			power_distribution = {
				attack = {
					40,
					60
				},
				impact = {
					10,
					15
				}
			}
		}
	}
}
damage_templates.default_flamer_assault_burst = {
	duration_scale_bonus = 0.1,
	suppression_value = 5,
	gibbing_power = 0,
	ragdoll_push_force = 12,
	ignore_stagger_reduction = true,
	stagger_category = "flamer",
	cleave_distribution = {
		attack = 0.1,
		impact = 0.1
	},
	ranges = {
		max = 15,
		min = 5
	},
	armor_damage_modifier_ranged = assault_flamer_armor_mod,
	damage_type = damage_types.burning,
	gibbing_type = GibbingTypes.plasma,
	power_distribution = {
		attack = {
			5,
			25
		},
		impact = {
			5,
			10
		}
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
