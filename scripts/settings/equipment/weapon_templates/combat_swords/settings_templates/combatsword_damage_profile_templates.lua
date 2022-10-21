local ArmorSettings = require("scripts/settings/damage/armor_settings")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local DamageProfileSettings = require("scripts/settings/damage/damage_profile_settings")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local GibbingSettings = require("scripts/settings/gibbing/gibbing_settings")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local WoundsTemplates = require("scripts/settings/damage/wounds_templates")
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
local light_cleave = DamageProfileSettings.light_cleave
local medium_cleave = DamageProfileSettings.medium_cleave
local cutting_am = {
	attack = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1,
		[armor_types.armored] = damage_lerp_values.lerp_0_3,
		[armor_types.resistant] = damage_lerp_values.lerp_0_5,
		[armor_types.player] = damage_lerp_values.no_damage,
		[armor_types.berserker] = damage_lerp_values.lerp_1,
		[armor_types.super_armor] = damage_lerp_values.lerp_0_075,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_75,
		[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
		[armor_types.prop_armor] = damage_lerp_values.lerp_0_5
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
}
local p2_am = {
	attack = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1,
		[armor_types.armored] = damage_lerp_values.lerp_0_3,
		[armor_types.resistant] = damage_lerp_values.lerp_0_5,
		[armor_types.player] = damage_lerp_values.no_damage,
		[armor_types.berserker] = damage_lerp_values.lerp_1,
		[armor_types.super_armor] = damage_lerp_values.lerp_0_05,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_75,
		[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
		[armor_types.prop_armor] = damage_lerp_values.lerp_0_5
	},
	impact = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1,
		[armor_types.armored] = damage_lerp_values.lerp_0_5,
		[armor_types.resistant] = damage_lerp_values.lerp_1,
		[armor_types.player] = damage_lerp_values.lerp_1,
		[armor_types.berserker] = damage_lerp_values.lerp_0_5,
		[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
		[armor_types.void_shield] = damage_lerp_values.lerp_1,
		[armor_types.prop_armor] = damage_lerp_values.lerp_1
	}
}
local smiter_am = {
	attack = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1,
		[armor_types.armored] = damage_lerp_values.lerp_0_75,
		[armor_types.resistant] = damage_lerp_values.lerp_1,
		[armor_types.player] = damage_lerp_values.no_damage,
		[armor_types.berserker] = damage_lerp_values.lerp_1,
		[armor_types.super_armor] = damage_lerp_values.lerp_0_25,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
		[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
		[armor_types.prop_armor] = damage_lerp_values.lerp_0_5
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
}
damage_templates.light_combatsword_linesman = {
	ragdoll_push_force = 200,
	stagger_category = "melee",
	cleave_distribution = light_cleave,
	damage_type = damage_types.metal_slashing_light,
	gibbing_power = GibbingPower.light,
	gibbing_type = GibbingTypes.sawing,
	melee_attack_strength = melee_attack_strengths.light,
	wounds_template = WoundsTemplates.combat_sword,
	armor_damage_modifier = cutting_am,
	targets = {
		{
			armor_damage_modifier = cutting_am,
			boost_curve_multiplier_finesse = {
				0.5,
				1.5
			},
			power_level_multiplier = {
				0.5,
				1.5
			},
			power_distribution = {
				attack = {
					35,
					75
				},
				impact = {
					4,
					8
				}
			}
		},
		{
			power_distribution = {
				attack = {
					25,
					60
				},
				impact = {
					3,
					6
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
					2,
					4
				}
			}
		},
		default_target = {
			power_distribution = {
				attack = {
					8,
					12
				},
				impact = {
					2,
					4
				}
			},
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.light_combatsword_linesman_p2 = {
	stagger_category = "melee",
	cleave_distribution = medium_cleave,
	damage_type = damage_types.metal_slashing_light,
	gibbing_power = GibbingPower.light,
	gibbing_type = GibbingTypes.sawing,
	melee_attack_strength = melee_attack_strengths.light,
	wounds_template = WoundsTemplates.combat_sword,
	armor_damage_modifier = p2_am,
	targets = {
		{
			boost_curve_multiplier_finesse = {
				0.5,
				1.5
			},
			power_level_multiplier = {
				0.5,
				1.5
			},
			power_distribution = {
				attack = {
					35,
					70
				},
				impact = {
					3,
					6
				}
			}
		},
		{
			power_distribution = {
				attack = {
					30,
					65
				},
				impact = {
					3,
					6
				}
			}
		},
		{
			power_distribution = {
				attack = {
					25,
					55
				},
				impact = {
					2,
					4
				}
			}
		},
		{
			power_distribution = {
				attack = {
					20,
					45
				},
				impact = {
					2,
					4
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
					2,
					4
				}
			}
		},
		default_target = {
			power_distribution = {
				attack = {
					8,
					12
				},
				impact = {
					2,
					4
				}
			},
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.light_combatsword_smiter = {
	stagger_category = "melee",
	cleave_distribution = single_cleave,
	damage_type = damage_types.metal_slashing_light,
	gibbing_power = GibbingPower.light,
	gibbing_type = GibbingTypes.sawing,
	melee_attack_strength = melee_attack_strengths.light,
	wounds_template = WoundsTemplates.combat_sword,
	armor_damage_modifier = smiter_am,
	targets = {
		{
			armor_damage_modifier = smiter_am,
			boost_curve_multiplier_finesse = {
				0.5,
				1.5
			},
			power_level_multiplier = {
				0.5,
				1.5
			},
			power_distribution = {
				attack = {
					75,
					150
				},
				impact = {
					6,
					12
				}
			}
		},
		{
			power_distribution = {
				attack = {
					25,
					60
				},
				impact = {
					3,
					6
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
					2,
					4
				}
			}
		},
		default_target = {
			power_distribution = {
				attack = {
					10,
					20
				},
				impact = {
					2,
					4
				}
			},
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.heavy_combatsword = {
	ignore_gib_push = true,
	ragdoll_push_force = 500,
	stagger_category = "uppercut",
	cleave_distribution = medium_cleave,
	damage_type = damage_types.metal_slashing_medium,
	gibbing_power = GibbingPower.medium,
	gibbing_type = GibbingTypes.sawing,
	melee_attack_strength = melee_attack_strengths.heavy,
	wounds_template = WoundsTemplates.combat_sword,
	armor_damage_modifier = cutting_am,
	targets = {
		{
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_5,
					[armor_types.resistant] = damage_lerp_values.lerp_0_75,
					[armor_types.player] = damage_lerp_values.no_damage,
					[armor_types.berserker] = damage_lerp_values.lerp_1,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_25,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
					[armor_types.prop_armor] = damage_lerp_values.lerp_0_75
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_75,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_1,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_75,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_1,
					[armor_types.prop_armor] = damage_lerp_values.lerp_1
				}
			},
			boost_curve_multiplier_finesse = {
				0.5,
				1.5
			},
			power_level_multiplier = {
				0.5,
				1.5
			},
			power_distribution = {
				attack = {
					100,
					200
				},
				impact = {
					6,
					12
				}
			}
		},
		{
			power_distribution = {
				attack = {
					35,
					65
				},
				impact = {
					5,
					8
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
					4,
					8
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
					4,
					8
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
			power_distribution = {
				attack = {
					20,
					40
				},
				impact = {
					2,
					5
				}
			},
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.heavy_combatsword_smiter = {
	ignore_gib_push = true,
	ragdoll_push_force = 500,
	stagger_category = "melee",
	cleave_distribution = single_cleave,
	damage_type = damage_types.metal_slashing_medium,
	gibbing_power = GibbingPower.medium,
	gibbing_type = GibbingTypes.sawing,
	melee_attack_strength = melee_attack_strengths.heavy,
	wounds_template = WoundsTemplates.combat_sword,
	armor_damage_modifier = cutting_am,
	targets = {
		{
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_6,
					[armor_types.resistant] = damage_lerp_values.lerp_0_75,
					[armor_types.player] = damage_lerp_values.no_damage,
					[armor_types.berserker] = damage_lerp_values.lerp_1,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_4,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
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
			boost_curve_multiplier_finesse = {
				0.5,
				1.5
			},
			power_level_multiplier = {
				0.5,
				1.5
			},
			power_distribution = {
				attack = {
					150,
					300
				},
				impact = {
					8,
					16
				}
			}
		},
		{
			power_distribution = {
				attack = {
					35,
					65
				},
				impact = {
					5,
					8
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
					4,
					8
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
					4,
					8
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
			power_distribution = {
				attack = {
					20,
					40
				},
				impact = {
					2,
					5
				}
			},
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}

return {
	base_templates = damage_templates,
	overrides = overrides
}
