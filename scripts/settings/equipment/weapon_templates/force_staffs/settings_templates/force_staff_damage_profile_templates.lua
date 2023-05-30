local ArmorSettings = require("scripts/settings/damage/armor_settings")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local DamageProfileSettings = require("scripts/settings/damage/damage_profile_settings")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local GibbingSettings = require("scripts/settings/gibbing/gibbing_settings")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local WoundsTemplates = require("scripts/settings/damage/wounds_templates")
local GibbingPower = GibbingSettings.gibbing_power
local GibbingTypes = GibbingSettings.gibbing_types
local armor_types = ArmorSettings.types
local damage_types = DamageSettings.damage_types
local damage_templates = {}
local overrides = {}

table.make_unique(damage_templates)
table.make_unique(overrides)

local melee_attack_strengths = AttackSettings.melee_attack_strength
local crit_armor_mod = DamageProfileSettings.crit_armor_mod
local crit_impact_armor_mod = DamageProfileSettings.crit_impact_armor_mod
local damage_lerp_values = DamageProfileSettings.damage_lerp_values
local default_armor_mod = DamageProfileSettings.default_armor_mod
local flat_one_armor_mod = DamageProfileSettings.flat_one_armor_mod
local single_cleave = DamageProfileSettings.single_cleave
local medium_cleave = DamageProfileSettings.medium_cleave
local double_cleave = DamageProfileSettings.double_cleave
local big_cleave = DamageProfileSettings.big_cleave
damage_templates.force_staff_ball = {
	force_weapon_damage = true,
	stagger_override = "medium",
	stagger_category = "melee",
	suppression_attack_delay = 0.6,
	ragdoll_push_force = 600,
	ignore_stagger_reduction = true,
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_1,
			[armor_types.resistant] = damage_lerp_values.lerp_0_6,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_1,
			[armor_types.super_armor] = damage_lerp_values.lerp_0_1,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
			[armor_types.void_shield] = damage_lerp_values.lerp_0_6,
			[armor_types.prop_armor] = damage_lerp_values.lerp_1
		},
		impact = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_1,
			[armor_types.resistant] = damage_lerp_values.lerp_0_6,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_0_5,
			[armor_types.super_armor] = damage_lerp_values.no_damage,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_8,
			[armor_types.void_shield] = damage_lerp_values.lerp_0_8,
			[armor_types.prop_armor] = damage_lerp_values.lerp_0_6
		}
	},
	cleave_distribution = {
		attack = 0.25,
		impact = 0.25
	},
	crit_mod = {
		attack = crit_armor_mod,
		impact = crit_impact_armor_mod
	},
	power_distribution = {
		attack = {
			60,
			180
		},
		impact = {
			4,
			8
		}
	},
	gibbing_power = GibbingPower.light,
	gibbing_type = GibbingTypes.warp,
	gib_push_force = GibbingSettings.gib_push_force.force_assault,
	wounds_template = WoundsTemplates.psyker_ball,
	suppression_value = {
		10,
		15
	},
	on_kill_area_suppression = {
		distance = 3,
		suppression_value = 5
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
damage_templates.default_force_staff_bfg = {
	force_weapon_damage = true,
	ignore_shield = true,
	ragdoll_push_force = 800,
	ragdoll_only = true,
	stagger_category = "explosion",
	cleave_distribution = medium_cleave,
	gibbing_power = GibbingPower.heavy,
	gibbing_type = GibbingTypes.warp,
	gib_push_force = GibbingSettings.gib_push_force.force_bfg,
	targets = {
		default_target = {
			boost_curve_multiplier_finesse = 0.5,
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_75,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_6,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_75,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_2,
					[armor_types.prop_armor] = damage_lerp_values.lerp_1
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_2,
					[armor_types.armored] = damage_lerp_values.lerp_1,
					[armor_types.resistant] = damage_lerp_values.lerp_0_1,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_1,
					[armor_types.super_armor] = damage_lerp_values.lerp_1,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_2,
					[armor_types.void_shield] = damage_lerp_values.lerp_2_35,
					[armor_types.prop_armor] = damage_lerp_values.lerp_1
				}
			},
			power_distribution = {
				attack = {
					250,
					500
				},
				impact = {
					15,
					30
				}
			},
			boost_curve = PowerLevelSettings.boost_curves.default,
			finesse_boost = {
				[armor_types.unarmored] = 0.5,
				[armor_types.armored] = 0.5,
				[armor_types.resistant] = 0.5,
				[armor_types.player] = 0.5,
				[armor_types.berserker] = 0.5,
				[armor_types.super_armor] = 0.5,
				[armor_types.disgustingly_resilient] = 0.5,
				[armor_types.void_shield] = 0.5,
				[armor_types.prop_armor] = 0.5
			}
		}
	},
	on_kill_area_suppression = {
		distance = 8,
		suppression_value = 12
	},
	charge_level_scaler = {
		{
			modifier = 1,
			t = 1
		},
		start_modifier = 0.25
	}
}
damage_templates.default_force_staff_demolition = {
	suppression_value = 10,
	force_weapon_damage = true,
	ragdoll_push_force = 200,
	ignore_stagger_reduction = true,
	stagger_category = "melee",
	cleave_distribution = {
		attack = 0.15,
		impact = 0.15
	},
	ranges = {
		max = 50,
		min = 40
	},
	armor_damage_modifier_ranged = {
		near = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_0_75,
				[armor_types.resistant] = damage_lerp_values.lerp_1,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_1,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_25,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_75,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
				[armor_types.prop_armor] = damage_lerp_values.lerp_1
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_0_5,
				[armor_types.resistant] = damage_lerp_values.lerp_0_5,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_1,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_25,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
				[armor_types.void_shield] = damage_lerp_values.lerp_1,
				[armor_types.prop_armor] = damage_lerp_values.lerp_1
			}
		},
		far = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_0_75,
				[armor_types.resistant] = damage_lerp_values.lerp_1,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_1,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_25,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_75,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
				[armor_types.prop_armor] = damage_lerp_values.lerp_1
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_0_5,
				[armor_types.resistant] = damage_lerp_values.lerp_0_5,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_1,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_25,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
				[armor_types.void_shield] = damage_lerp_values.lerp_1,
				[armor_types.prop_armor] = damage_lerp_values.lerp_1
			}
		}
	},
	power_distribution = {
		attack = {
			15,
			40
		},
		impact = {
			8,
			24
		}
	},
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	},
	gibbing_type = GibbingTypes.warp,
	gibbing_power = GibbingPower.medium,
	gib_push_force = GibbingSettings.gib_push_force.force_assault
}
damage_templates.close_force_staff_p4_demolition = {
	force_weapon_damage = true,
	suppression_value = 10,
	ragdoll_push_force = 600,
	ignore_stagger_reduction = true,
	stagger_category = "melee",
	cleave_distribution = {
		attack = 0.15,
		impact = 0.15
	},
	ranges = {
		max = 3,
		min = 0.25
	},
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_1,
			[armor_types.resistant] = damage_lerp_values.lerp_1,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_1,
			[armor_types.super_armor] = damage_lerp_values.lerp_1,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_75,
			[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
			[armor_types.prop_armor] = damage_lerp_values.lerp_1
		},
		impact = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_1,
			[armor_types.resistant] = damage_lerp_values.lerp_1,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_1,
			[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
			[armor_types.void_shield] = damage_lerp_values.lerp_1,
			[armor_types.prop_armor] = damage_lerp_values.lerp_1
		}
	},
	power_distribution = {
		attack = {
			25,
			50
		},
		impact = {
			25,
			50
		}
	},
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	},
	gibbing_type = GibbingTypes.warp,
	gibbing_power = GibbingPower.heavy,
	gib_push_force = GibbingSettings.gib_push_force.force_assault
}
damage_templates.force_staff_p4_demolition = {
	suppression_value = 10,
	force_weapon_damage = true,
	ragdoll_push_force = 200,
	ignore_stagger_reduction = true,
	stagger_category = "melee",
	cleave_distribution = {
		attack = 0.15,
		impact = 0.15
	},
	ranges = {
		max = 50,
		min = 40
	},
	armor_damage_modifier_ranged = {
		near = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_0_75,
				[armor_types.resistant] = damage_lerp_values.lerp_1,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_1,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_25,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_75,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
				[armor_types.prop_armor] = damage_lerp_values.lerp_1
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_0_5,
				[armor_types.resistant] = damage_lerp_values.lerp_0_5,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_1,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_25,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
				[armor_types.void_shield] = damage_lerp_values.lerp_1,
				[armor_types.prop_armor] = damage_lerp_values.lerp_1
			}
		},
		far = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_0_1,
				[armor_types.armored] = damage_lerp_values.lerp_0_1,
				[armor_types.resistant] = damage_lerp_values.lerp_0_1,
				[armor_types.player] = damage_lerp_values.lerp_0_1,
				[armor_types.berserker] = damage_lerp_values.lerp_0_1,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_1,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_1,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_1,
				[armor_types.prop_armor] = damage_lerp_values.lerp_0_1
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_0_1,
				[armor_types.armored] = damage_lerp_values.lerp_0_1,
				[armor_types.resistant] = damage_lerp_values.lerp_0_1,
				[armor_types.player] = damage_lerp_values.lerp_0_1,
				[armor_types.berserker] = damage_lerp_values.lerp_0_1,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_1,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_1,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_1,
				[armor_types.prop_armor] = damage_lerp_values.lerp_0_1
			}
		}
	},
	power_distribution = {
		attack = {
			10,
			20
		},
		impact = {
			8,
			24
		}
	},
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	},
	gibbing_type = GibbingTypes.warp,
	gibbing_power = GibbingPower.heavy,
	gib_push_force = GibbingSettings.gib_push_force.force_demolition
}
damage_templates.close_force_staff_demolition = {
	force_weapon_damage = true,
	suppression_value = 10,
	ragdoll_push_force = 600,
	ignore_stagger_reduction = true,
	stagger_category = "melee",
	cleave_distribution = {
		attack = 0.15,
		impact = 0.15
	},
	ranges = {
		max = 3,
		min = 0.25
	},
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_1,
			[armor_types.resistant] = damage_lerp_values.lerp_1,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_1,
			[armor_types.super_armor] = damage_lerp_values.lerp_1,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_75,
			[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
			[armor_types.prop_armor] = damage_lerp_values.lerp_1
		},
		impact = {
			[armor_types.unarmored] = damage_lerp_values.lerp_2,
			[armor_types.armored] = damage_lerp_values.lerp_2,
			[armor_types.resistant] = damage_lerp_values.lerp_2,
			[armor_types.player] = damage_lerp_values.lerp_2,
			[armor_types.berserker] = damage_lerp_values.lerp_2,
			[armor_types.super_armor] = damage_lerp_values.lerp_2,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_2,
			[armor_types.void_shield] = damage_lerp_values.lerp_2,
			[armor_types.prop_armor] = damage_lerp_values.lerp_2
		}
	},
	power_distribution = {
		attack = {
			250,
			450
		},
		impact = {
			100,
			100
		}
	},
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	},
	gibbing_type = GibbingTypes.warp,
	gibbing_power = GibbingPower.heavy,
	gib_push_force = GibbingSettings.gib_push_force.force_demolition
}
damage_templates.force_staff_bash = {
	force_weapon_damage = true,
	ragdoll_push_force = 200,
	ragdoll_only = true,
	stagger_category = "melee",
	cleave_distribution = single_cleave,
	gibbing_power = GibbingPower.always,
	gibbing_type = GibbingTypes.ballistic,
	melee_attack_strength = melee_attack_strengths.light,
	damage_type = damage_types.bash,
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = damage_lerp_values.lerp_0_25,
			[armor_types.armored] = damage_lerp_values.lerp_0_5,
			[armor_types.resistant] = damage_lerp_values.lerp_1,
			[armor_types.player] = damage_lerp_values.no_damage,
			[armor_types.berserker] = damage_lerp_values.lerp_0_5,
			[armor_types.super_armor] = damage_lerp_values.no_damage,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_75,
			[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
			[armor_types.prop_armor] = damage_lerp_values.lerp_0_5
		},
		impact = {
			[armor_types.unarmored] = damage_lerp_values.lerp_0_25,
			[armor_types.armored] = damage_lerp_values.lerp_1,
			[armor_types.resistant] = damage_lerp_values.lerp_1,
			[armor_types.player] = damage_lerp_values.no_damage,
			[armor_types.berserker] = damage_lerp_values.lerp_0_5,
			[armor_types.super_armor] = damage_lerp_values.lerp_0_3,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_75,
			[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
			[armor_types.prop_armor] = damage_lerp_values.lerp_1
		}
	},
	stagger_duration_modifier = {
		0.1,
		0.5
	},
	targets = {
		{
			boost_curve_multiplier_finesse = 0.25,
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_0_25,
					[armor_types.armored] = damage_lerp_values.lerp_0_5,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
					[armor_types.player] = damage_lerp_values.no_damage,
					[armor_types.berserker] = damage_lerp_values.lerp_0_5,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_01,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_75,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
					[armor_types.prop_armor] = damage_lerp_values.lerp_0_5
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_75,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
					[armor_types.player] = damage_lerp_values.no_damage,
					[armor_types.berserker] = damage_lerp_values.lerp_0_5,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_4,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_75,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
					[armor_types.prop_armor] = damage_lerp_values.lerp_0_75
				}
			},
			power_distribution = {
				attack = {
					30,
					60
				},
				impact = {
					8,
					16
				}
			},
			finesse_boost = {
				[armor_types.unarmored] = 0.1,
				[armor_types.armored] = 0.5,
				[armor_types.resistant] = 0.1,
				[armor_types.player] = 0.1,
				[armor_types.berserker] = 0.1,
				[armor_types.super_armor] = 0.1,
				[armor_types.disgustingly_resilient] = 0.25,
				[armor_types.void_shield] = 0.25,
				[armor_types.prop_armor] = 0.25
			}
		},
		{
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = {
					15,
					25
				},
				impact = {
					8,
					16
				}
			}
		},
		default_target = {
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = {
					8,
					12
				},
				impact = {
					3,
					6
				}
			},
			boost_curve = PowerLevelSettings.boost_curves.default,
			finesse_boost = {
				[armor_types.unarmored] = 0.05,
				[armor_types.armored] = 0.5,
				[armor_types.resistant] = 0.1,
				[armor_types.player] = 0.1,
				[armor_types.berserker] = 0.1,
				[armor_types.super_armor] = 0.1,
				[armor_types.disgustingly_resilient] = 0.5,
				[armor_types.void_shield] = 0.5,
				[armor_types.prop_armor] = 0.5
			}
		}
	},
	critical_strike = {
		gibbing_type = GibbingTypes.crushing
	}
}
local assault_warpfire_armor_mod = {
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
damage_templates.default_warpfire_assault = {
	duration_scale_bonus = 0.5,
	accumulative_stagger_strength_multiplier = 0.5,
	force_weapon_damage = true,
	ragdoll_push_force = 10,
	suppression_value = 10,
	stagger_category = "flamer",
	cleave_distribution = {
		attack = 0.1,
		impact = 0.1
	},
	ranges = {
		max = 15,
		min = 5
	},
	armor_damage_modifier_ranged = assault_warpfire_armor_mod,
	gibbing_type = GibbingTypes.warp,
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
damage_templates.default_warpfire_assault_burst = {
	duration_scale_bonus = 0.1,
	suppression_value = 5,
	force_weapon_damage = true,
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
	armor_damage_modifier_ranged = assault_warpfire_armor_mod,
	gibbing_type = GibbingTypes.warp,
	power_distribution = {
		attack = {
			5,
			15
		},
		impact = {
			5,
			10
		}
	},
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default,
			power_distribution = {
				attack = {
					10,
					20
				},
				impact = {
					10,
					15
				}
			}
		}
	}
}
damage_templates.default_chain_lighting_attack = {
	ragdoll_push_force = 10,
	attack_direction_override = "push",
	chain_lightning = true,
	stagger_category = "sticky",
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = damage_lerp_values.lerp_0_35,
			[armor_types.armored] = damage_lerp_values.lerp_1_5,
			[armor_types.resistant] = damage_lerp_values.lerp_1,
			[armor_types.player] = damage_lerp_values.lerp_0_75,
			[armor_types.berserker] = damage_lerp_values.lerp_1,
			[armor_types.super_armor] = damage_lerp_values.lerp_1_5,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_35,
			[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
			[armor_types.prop_armor] = damage_lerp_values.lerp_0_75
		},
		impact = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_1,
			[armor_types.resistant] = damage_lerp_values.lerp_1,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_1,
			[armor_types.super_armor] = damage_lerp_values.lerp_1,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
			[armor_types.void_shield] = damage_lerp_values.lerp_1,
			[armor_types.prop_armor] = damage_lerp_values.lerp_1
		}
	},
	cleave_distribution = {
		attack = 8,
		impact = 20
	},
	power_distribution = {
		impact = 60,
		attack = {
			200,
			200
		}
	},
	random_damage = {
		{
			max = 1.1,
			min = 0.9
		},
		{
			max = 1,
			min = 0.5
		},
		{
			max = 0.5,
			min = 0.25
		},
		{
			max = 0.5,
			min = 0.25
		}
	},
	charge_level_scaler = {
		{
			modifier = 1,
			t = 1
		},
		start_modifier = 0
	},
	crit_mod = {
		attack = {
			[armor_types.unarmored] = {
				0,
				0.3
			},
			[armor_types.armored] = {
				0,
				0
			},
			[armor_types.resistant] = {
				0,
				0.3
			},
			[armor_types.player] = {
				0,
				0.3
			},
			[armor_types.berserker] = {
				0,
				0.3
			},
			[armor_types.super_armor] = {
				0,
				0
			},
			[armor_types.disgustingly_resilient] = {
				0,
				0.3
			},
			[armor_types.void_shield] = {
				0,
				0.3
			},
			[armor_types.prop_armor] = {
				0,
				0.3
			}
		},
		impact = crit_impact_armor_mod
	},
	damage_type = damage_types.electrocution,
	targets = {
		{
			power_distribution = {
				attack = {
					200,
					400
				},
				impact = {
					40,
					60
				}
			}
		},
		{
			power_distribution = {
				attack = {
					75,
					150
				},
				impact = {
					20,
					40
				}
			}
		},
		{
			power_distribution = {
				attack = {
					50,
					100
				},
				impact = {
					15,
					30
				}
			}
		},
		{
			power_distribution = {
				attack = {
					35,
					70
				},
				impact = {
					10,
					20
				}
			}
		},
		{
			power_distribution = {
				attack = {
					30,
					60
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
					20,
					40
				},
				impact = {
					3,
					6
				}
			}
		},
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		},
		boost_curve_multiplier_finesse = damage_lerp_values.lerp_1
	}
}
damage_templates.default_chain_lighting_interval = {
	chain_lightning = true,
	stagger_category = "sticky",
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = damage_lerp_values.lerp_0_75,
			[armor_types.armored] = damage_lerp_values.lerp_0_75,
			[armor_types.resistant] = damage_lerp_values.lerp_1,
			[armor_types.player] = damage_lerp_values.lerp_0_75,
			[armor_types.berserker] = damage_lerp_values.lerp_1,
			[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_75,
			[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
			[armor_types.prop_armor] = damage_lerp_values.lerp_0_75
		},
		impact = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_2,
			[armor_types.resistant] = damage_lerp_values.lerp_1,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_1,
			[armor_types.super_armor] = damage_lerp_values.lerp_1_5,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
			[armor_types.void_shield] = damage_lerp_values.lerp_1,
			[armor_types.prop_armor] = damage_lerp_values.lerp_1
		}
	},
	cleave_distribution = {
		attack = 5,
		impact = 20
	},
	power_distribution = {
		attack = 8,
		impact = 250
	},
	damage_type = damage_types.electrocution,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		},
		boost_curve_multiplier_finesse = damage_lerp_values.lerp_1
	}
}

return {
	base_templates = damage_templates,
	overrides = overrides
}
