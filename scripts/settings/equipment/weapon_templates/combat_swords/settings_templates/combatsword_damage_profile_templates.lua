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
local ninjafencer_finesse_boost = PowerLevelSettings.ninjafencer_finesse_boost_amount
local smiter_finesse_boost_amount = PowerLevelSettings.smiter_finesse_boost_amount
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
		[armor_types.armored] = damage_lerp_values.lerp_0_5,
		[armor_types.resistant] = damage_lerp_values.lerp_0_5,
		[armor_types.player] = damage_lerp_values.no_damage,
		[armor_types.berserker] = damage_lerp_values.lerp_1,
		[armor_types.super_armor] = damage_lerp_values.lerp_0_05,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
		[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
		[armor_types.prop_armor] = damage_lerp_values.lerp_0_5
	},
	impact = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1,
		[armor_types.armored] = damage_lerp_values.lerp_0_75,
		[armor_types.resistant] = damage_lerp_values.lerp_1,
		[armor_types.player] = damage_lerp_values.lerp_1,
		[armor_types.berserker] = damage_lerp_values.lerp_0_75,
		[armor_types.super_armor] = damage_lerp_values.lerp_0_75,
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
	ragdoll_push_force = 100,
	stagger_category = "melee",
	cleave_distribution = light_cleave,
	damage_type = damage_types.metal_slashing_light,
	gibbing_power = GibbingPower.light,
	gibbing_type = GibbingTypes.sawing,
	melee_attack_strength = melee_attack_strengths.light,
	wounds_template = WoundsTemplates.combat_sword,
	gib_push_force = GibbingSettings.gib_push_force.sawing_medium,
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
	ragdoll_push_force = 100,
	gibbing_power = 0,
	stagger_category = "melee",
	cleave_distribution = medium_cleave,
	damage_type = damage_types.metal_slashing_light,
	critical_strike = {
		gibbing_power = GibbingPower.light,
		gibbing_type = GibbingTypes.sawing
	},
	gibbing_type = GibbingTypes.sawing,
	melee_attack_strength = melee_attack_strengths.light,
	wounds_template = WoundsTemplates.combat_sword,
	gib_push_force = GibbingSettings.gib_push_force.sawing_medium,
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
					40,
					80
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
					60
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
					25,
					50
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
					40
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
					20,
					40
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
damage_templates.light_combatsword_linesman_tank_p2 = {
	ragdoll_push_force = 100,
	gibbing_power = 0,
	stagger_category = "uppercut",
	cleave_distribution = light_cleave,
	damage_type = damage_types.metal_slashing_light,
	critical_strike = {
		gibbing_power = GibbingPower.light,
		gibbing_type = GibbingTypes.sawing
	},
	gibbing_type = GibbingTypes.sawing,
	melee_attack_strength = melee_attack_strengths.light,
	wounds_template = WoundsTemplates.combat_sword,
	gib_push_force = GibbingSettings.gib_push_force.sawing_medium,
	armor_damage_modifier = p2_am,
	stagger_duration_modifier = {
		1,
		1.2
	},
	targets = {
		{
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
					6,
					12
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
					30,
					60
				},
				impact = {
					4.5,
					8
				}
			}
		},
		{
			power_distribution = {
				attack = {
					25,
					50
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
					50
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
					3,
					6
				}
			},
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.heavy_combatsword_p2_smiter = {
	ragdoll_push_force = 200,
	stagger_category = "melee",
	cleave_distribution = single_cleave,
	damage_type = damage_types.metal_slashing_light,
	critical_strike = {
		gibbing_power = GibbingPower.light,
		gibbing_type = GibbingTypes.sawing
	},
	gibbing_power = GibbingPower.always,
	gibbing_type = GibbingTypes.sawing,
	melee_attack_strength = melee_attack_strengths.light,
	wounds_template = WoundsTemplates.combat_sword,
	gib_push_force = GibbingSettings.gib_push_force.sawing_heavy,
	armor_damage_modifier = smiter_am,
	targets = {
		{
			armor_damage_modifier = smiter_am,
			boost_curve_multiplier_finesse = {
				1,
				2
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
					75,
					150
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
damage_templates.heavy_combatsword_p2_smiter_up = {
	ragdoll_push_force = 600,
	stagger_category = "melee",
	cleave_distribution = light_cleave,
	damage_type = damage_types.metal_slashing_light,
	critical_strike = {
		gibbing_power = GibbingPower.heavy,
		gibbing_type = GibbingTypes.sawing
	},
	gibbing_power = GibbingPower.medium,
	gibbing_type = GibbingTypes.sawing,
	melee_attack_strength = melee_attack_strengths.light,
	wounds_template = WoundsTemplates.combat_sword,
	gib_push_force = GibbingSettings.gib_push_force.sawing_heavy,
	armor_damage_modifier = smiter_am,
	targets = {
		{
			armor_damage_modifier = smiter_am,
			boost_curve_multiplier_finesse = {
				1,
				2
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
					75,
					150
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
local p3_fencer_crit_mod = {
	attack = {
		[armor_types.unarmored] = 0,
		[armor_types.armored] = 0.7,
		[armor_types.resistant] = 0.25,
		[armor_types.player] = 0,
		[armor_types.berserker] = 0.5,
		[armor_types.super_armor] = 0.25,
		[armor_types.disgustingly_resilient] = 0.25,
		[armor_types.void_shield] = 0,
		[armor_types.prop_armor] = 0
	},
	impact = {
		[armor_types.unarmored] = 0.75,
		[armor_types.armored] = 0.75,
		[armor_types.resistant] = 0.75,
		[armor_types.player] = 0.75,
		[armor_types.berserker] = 0.75,
		[armor_types.super_armor] = 0.75,
		[armor_types.disgustingly_resilient] = 0.75,
		[armor_types.void_shield] = 0.75,
		[armor_types.prop_armor] = 0.75
	}
}
damage_templates.light_combatsword_linesman_p3 = {
	ragdoll_push_force = 100,
	stagger_category = "melee",
	cleave_distribution = double_cleave,
	damage_type = damage_types.metal_slashing_light,
	critical_strike = {
		gibbing_power = GibbingPower.light,
		gibbing_type = GibbingTypes.sawing
	},
	gibbing_power = GibbingPower.always,
	gibbing_type = GibbingTypes.sawing,
	melee_attack_strength = melee_attack_strengths.light,
	wounds_template = WoundsTemplates.combat_sword,
	crit_mod = p3_fencer_crit_mod,
	gib_push_force = GibbingSettings.gib_push_force.sawing_medium,
	armor_damage_modifier = cutting_am,
	targets = {
		{
			armor_damage_modifier = cutting_am,
			boost_curve_multiplier_finesse = {
				1.25,
				2.5
			},
			power_level_multiplier = {
				0.5,
				1.5
			},
			finesse_boost = ninjafencer_finesse_boost,
			power_distribution = {
				attack = {
					25,
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
					50
				},
				impact = {
					3,
					5
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
overrides.light_combatsword_pushfollowup_linesman_p3 = {
	parent_template_name = "light_combatsword_linesman_p3",
	overrides = {
		{
			"cleave_distribution",
			medium_cleave
		},
		{
			"targets",
			2,
			{
				power_distribution = {
					attack = {
						25,
						50
					},
					impact = {
						3,
						5
					}
				},
				boost_curve_multiplier_finesse = {
					1.25,
					2.5
				},
				power_level_multiplier = {
					0.5,
					1.5
				},
				finesse_boost = ninjafencer_finesse_boost
			}
		},
		{
			"targets",
			3,
			{
				power_distribution = {
					attack = {
						20,
						40
					},
					impact = {
						2,
						4
					}
				},
				boost_curve_multiplier_finesse = {
					1.25,
					2.5
				},
				power_level_multiplier = {
					0.5,
					1.5
				},
				finesse_boost = ninjafencer_finesse_boost
			}
		}
	}
}
damage_templates.light_combatsword_p3_stab = {
	ignore_stagger_reduction = true,
	stagger_category = "uppercut",
	cleave_distribution = single_cleave,
	damage_type = damage_types.metal_slashing_light,
	gibbing_power = GibbingPower.always,
	gibbing_type = GibbingTypes.sawing,
	melee_attack_strength = melee_attack_strengths.light,
	wounds_template = WoundsTemplates.combat_sword,
	armor_damage_modifier = {
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
	},
	targets = {
		{
			armor_damage_modifier = {
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
					[armor_types.armored] = damage_lerp_values.lerp_0_5,
					[armor_types.resistant] = damage_lerp_values.lerp_0_25,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_1,
					[armor_types.super_armor] = damage_lerp_values.lerp_1,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_1,
					[armor_types.prop_armor] = damage_lerp_values.lerp_1
				}
			},
			boost_curve_multiplier_finesse = {
				0.2,
				0.4
			},
			power_level_multiplier = {
				0.5,
				1.5
			},
			finesse_boost = smiter_finesse_boost_amount,
			power_distribution = {
				attack = {
					40,
					80
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
damage_templates.light_combatsword_p2_special = {
	ignore_stagger_reduction = true,
	stagger_category = "sticky",
	cleave_distribution = single_cleave,
	damage_type = damage_types.metal_slashing_light,
	critical_strike = {
		gibbing_power = GibbingPower.light,
		gibbing_type = GibbingTypes.sawing
	},
	gibbing_power = GibbingPower.always,
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
					5,
					10
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
damage_templates.light_combatsword_smiter = {
	stagger_category = "melee",
	cleave_distribution = single_cleave,
	damage_type = damage_types.metal_slashing_light,
	critical_strike = {
		gibbing_power = GibbingPower.light,
		gibbing_type = GibbingTypes.sawing
	},
	gibbing_power = GibbingPower.always,
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
	gib_push_force = GibbingSettings.gib_push_force.sawing_heavy,
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
overrides.heavy_combatsword_linesman_p3 = {
	parent_template_name = "heavy_combatsword",
	overrides = {
		{
			"cleave_distribution",
			double_cleave
		},
		{
			"ragdoll_push_force",
			200
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
	gib_push_force = GibbingSettings.gib_push_force.sawing_heavy,
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
overrides.heavy_combatsword_smiter_stab = {
	parent_template_name = "heavy_combatsword_smiter",
	overrides = {
		{
			"cleave_distribution",
			single_cleave
		},
		{
			"targets",
			1,
			"power_distribution",
			"attack",
			{
				100,
				200
			}
		},
		{
			"targets",
			1,
			"power_distribution",
			"impact",
			{
				6,
				12
			}
		},
		{
			"gibbing_power",
			0
		},
		{
			"ragdoll_push_force",
			150
		}
	}
}
overrides.heavy_combatsword_p3_smiter = {
	parent_template_name = "heavy_combatsword_smiter",
	overrides = {
		{
			"cleave_distribution",
			double_cleave
		},
		{
			"targets",
			1,
			"power_distribution",
			"attack",
			{
				125,
				250
			}
		},
		{
			"targets",
			1,
			"power_distribution",
			"impact",
			{
				6,
				12
			}
		},
		{
			"gibbing_power",
			0
		},
		{
			"ragdoll_push_force",
			150
		}
	}
}

return {
	base_templates = damage_templates,
	overrides = overrides
}
