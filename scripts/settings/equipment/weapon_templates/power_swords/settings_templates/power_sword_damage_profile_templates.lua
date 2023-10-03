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
local big_cleave = DamageProfileSettings.big_cleave
local cutting_am = {
	attack = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1,
		[armor_types.armored] = damage_lerp_values.lerp_0_5,
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
local power_am = {
	attack = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1,
		[armor_types.armored] = damage_lerp_values.lerp_1,
		[armor_types.resistant] = damage_lerp_values.lerp_1_75,
		[armor_types.player] = damage_lerp_values.no_damage,
		[armor_types.berserker] = damage_lerp_values.lerp_1,
		[armor_types.super_armor] = damage_lerp_values.lerp_0_75,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
		[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
		[armor_types.prop_armor] = damage_lerp_values.lerp_1
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
damage_templates.light_sword = {
	finesse_ability_damage_multiplier = 2,
	stagger_category = "melee",
	cleave_distribution = {
		attack = {
			1.5,
			3.25
		},
		impact = {
			1.5,
			3.25
		}
	},
	damage_type = damage_types.metal_slashing_medium,
	gibbing_power = GibbingPower.light,
	gibbing_type = GibbingTypes.sawing,
	gib_push_force = GibbingSettings.gib_push_force.sawing_medium,
	melee_attack_strength = melee_attack_strengths.light,
	wounds_template = WoundsTemplates.power_sword,
	armor_damage_modifier = cutting_am,
	targets = {
		{
			armor_damage_modifier = cutting_am,
			boost_curve_multiplier_finesse = {
				0.5,
				1
			},
			power_distribution = {
				attack = {
					60,
					120
				},
				impact = {
					5,
					9
				}
			}
		},
		{
			armor_damage_modifier = cutting_am,
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
			armor_damage_modifier = cutting_am,
			power_distribution = {
				attack = {
					15,
					35
				},
				impact = {
					3,
					7
				}
			}
		},
		default_target = {
			armor_damage_modifier = cutting_am,
			power_distribution = {
				attack = {
					10,
					30
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
damage_templates.light_sword_smiter = {
	finesse_ability_damage_multiplier = 2,
	stagger_category = "melee",
	cleave_distribution = single_cleave,
	damage_type = damage_types.metal_slashing_medium,
	gibbing_power = GibbingPower.light,
	gibbing_type = GibbingTypes.sawing,
	gib_push_force = GibbingSettings.gib_push_force.sawing_medium,
	melee_attack_strength = melee_attack_strengths.light,
	wounds_template = WoundsTemplates.power_sword,
	armor_damage_modifier = cutting_am,
	targets = {
		{
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_1,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
					[armor_types.player] = damage_lerp_values.no_damage,
					[armor_types.berserker] = damage_lerp_values.lerp_1,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_25,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_1,
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
			boost_curve_multiplier_finesse = {
				0.5,
				1
			},
			power_distribution = {
				attack = {
					125,
					250
				},
				impact = {
					5,
					9
				}
			}
		},
		default_target = {
			armor_damage_modifier = cutting_am,
			power_distribution = {
				attack = {
					10,
					30
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
overrides.light_sword_stab = {
	parent_template_name = "light_sword_smiter",
	overrides = {
		{
			"targets",
			1,
			"boost_curve_multiplier_finesse",
			{
				1,
				2
			}
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
			"gibbing_power",
			0
		}
	}
}
damage_templates.light_powersword = {
	finesse_ability_damage_multiplier = 2,
	weapon_special = true,
	stagger_category = "melee",
	cleave_distribution = big_cleave,
	damage_type = damage_types.power_sword,
	gibbing_power = GibbingPower.heavy,
	gibbing_type = GibbingTypes.sawing,
	gib_push_force = GibbingSettings.gib_push_force.sawing_medium,
	melee_attack_strength = melee_attack_strengths.light,
	wounds_template = WoundsTemplates.power_sword,
	armor_damage_modifier = power_am,
	targets = {
		{
			armor_damage_modifier = power_am,
			boost_curve_multiplier_finesse = {
				0.4,
				1
			},
			power_distribution = {
				attack = {
					150,
					300
				},
				impact = {
					7,
					9
				}
			}
		},
		{
			armor_damage_modifier = power_am,
			boost_curve_multiplier_finesse = {
				0.4,
				1
			},
			power_distribution = {
				attack = {
					100,
					200
				},
				impact = {
					7,
					9
				}
			}
		},
		{
			armor_damage_modifier = power_am,
			boost_curve_multiplier_finesse = {
				0.4,
				1
			},
			power_distribution = {
				attack = {
					80,
					160
				},
				impact = {
					7,
					9
				}
			}
		},
		{
			armor_damage_modifier = power_am,
			power_distribution = {
				attack = {
					60,
					120
				},
				impact = {
					5,
					7
				}
			}
		},
		{
			armor_damage_modifier = power_am,
			power_distribution = {
				attack = {
					40,
					80
				},
				impact = {
					5,
					7
				}
			}
		},
		{
			armor_damage_modifier = power_am,
			power_distribution = {
				attack = {
					25,
					65
				},
				impact = {
					5,
					7
				}
			}
		},
		{
			armor_damage_modifier = power_am,
			power_distribution = {
				attack = {
					20,
					60
				},
				impact = {
					5,
					7
				}
			}
		},
		default_target = {
			armor_damage_modifier = power_am,
			power_distribution = {
				attack = {
					10,
					50
				},
				impact = {
					4,
					6
				}
			},
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
overrides.light_powersword_active = {
	parent_template_name = "light_powersword",
	overrides = {
		{
			"wounds_template",
			WoundsTemplates.power_sword_active
		},
		{
			"ignore_stagger_reduction",
			true
		}
	}
}
damage_templates.light_powersword_smiter = {
	finesse_ability_damage_multiplier = 2,
	weapon_special = true,
	stagger_category = "melee",
	cleave_distribution = big_cleave,
	damage_type = damage_types.power_sword,
	gibbing_power = GibbingPower.heavy,
	gibbing_type = GibbingTypes.sawing,
	gib_push_force = GibbingSettings.gib_push_force.sawing_medium,
	melee_attack_strength = melee_attack_strengths.light,
	wounds_template = WoundsTemplates.power_sword,
	armor_damage_modifier = power_am,
	targets = {
		{
			armor_damage_modifier = power_am,
			boost_curve_multiplier_finesse = {
				0.4,
				1
			},
			power_distribution = {
				attack = {
					150,
					250
				},
				impact = {
					7,
					9
				}
			}
		},
		{
			armor_damage_modifier = power_am,
			boost_curve_multiplier_finesse = {
				0.4,
				1
			},
			power_distribution = {
				attack = {
					60,
					120
				},
				impact = {
					7,
					9
				}
			}
		},
		{
			armor_damage_modifier = power_am,
			boost_curve_multiplier_finesse = {
				0.4,
				1
			},
			power_distribution = {
				attack = {
					60,
					120
				},
				impact = {
					7,
					9
				}
			}
		},
		{
			armor_damage_modifier = power_am,
			power_distribution = {
				attack = {
					60,
					120
				},
				impact = {
					5,
					7
				}
			}
		},
		{
			armor_damage_modifier = power_am,
			power_distribution = {
				attack = {
					60,
					120
				},
				impact = {
					5,
					7
				}
			}
		},
		{
			armor_damage_modifier = power_am,
			power_distribution = {
				attack = {
					60,
					120
				},
				impact = {
					5,
					7
				}
			}
		},
		{
			armor_damage_modifier = power_am,
			power_distribution = {
				attack = {
					20,
					60
				},
				impact = {
					5,
					7
				}
			}
		},
		default_target = {
			armor_damage_modifier = power_am,
			power_distribution = {
				attack = {
					10,
					50
				},
				impact = {
					4,
					6
				}
			},
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
overrides.light_powersword_active_smiter = {
	parent_template_name = "light_powersword",
	overrides = {
		{
			"wounds_template",
			WoundsTemplates.power_sword_active
		}
	}
}
overrides.light_powersword_stab_active = {
	parent_template_name = "light_powersword_smiter",
	overrides = {
		{
			"targets",
			1,
			"boost_curve_multiplier_finesse",
			{
				1,
				2
			}
		},
		{
			"wounds_template",
			WoundsTemplates.power_sword_active
		}
	}
}
damage_templates.heavy_powersword = {
	finesse_ability_damage_multiplier = 2,
	ragdoll_only = true,
	weapon_special = true,
	ragdoll_push_force = 100,
	gibbing_power = 10,
	stagger_category = "melee",
	cleave_distribution = big_cleave,
	damage_type = damage_types.power_sword,
	gibbing_type = GibbingTypes.default,
	melee_attack_strength = melee_attack_strengths.heavy,
	gib_push_force = GibbingSettings.gib_push_force.sawing_heavy,
	wounds_template = WoundsTemplates.power_sword,
	armor_damage_modifier = power_am,
	targets = {
		{
			armor_damage_modifier = power_am,
			boost_curve_multiplier_finesse = {
				0.4,
				1
			},
			power_distribution = {
				attack = {
					150,
					300
				},
				impact = {
					6,
					8
				}
			}
		},
		{
			armor_damage_modifier = power_am,
			boost_curve_multiplier_finesse = {
				0.4,
				1
			},
			power_distribution = {
				attack = {
					130,
					260
				},
				impact = {
					6,
					8
				}
			}
		},
		{
			armor_damage_modifier = power_am,
			boost_curve_multiplier_finesse = {
				0.4,
				1
			},
			power_distribution = {
				attack = {
					130,
					260
				},
				impact = {
					6,
					8
				}
			}
		},
		{
			armor_damage_modifier = power_am,
			power_distribution = {
				attack = {
					100,
					200
				},
				impact = {
					6,
					8
				}
			}
		},
		{
			armor_damage_modifier = power_am,
			power_distribution = {
				attack = {
					90,
					180
				},
				impact = {
					6,
					8
				}
			}
		},
		{
			armor_damage_modifier = power_am,
			power_distribution = {
				attack = {
					80,
					160
				},
				impact = {
					6,
					8
				}
			}
		},
		{
			armor_damage_modifier = power_am,
			power_distribution = {
				attack = {
					70,
					140
				},
				impact = {
					6,
					8
				}
			}
		},
		default_target = {
			armor_damage_modifier = power_am,
			power_distribution = {
				attack = {
					50,
					100
				},
				impact = {
					6,
					8
				}
			},
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
overrides.heavy_powersword_active = {
	parent_template_name = "heavy_powersword",
	overrides = {
		{
			"ignore_stagger_reduction",
			true
		},
		{
			"wounds_template",
			WoundsTemplates.power_sword_active
		}
	}
}
local heavy_sword_am = {
	attack = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1,
		[armor_types.armored] = damage_lerp_values.lerp_0_75,
		[armor_types.resistant] = damage_lerp_values.lerp_0_75,
		[armor_types.player] = damage_lerp_values.no_damage,
		[armor_types.berserker] = damage_lerp_values.lerp_1,
		[armor_types.super_armor] = damage_lerp_values.lerp_0_25,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_75,
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
}
damage_templates.heavy_sword = {
	finesse_ability_damage_multiplier = 2,
	ragdoll_push_force = 150,
	stagger_category = "melee",
	cleave_distribution = medium_cleave,
	damage_type = damage_types.metal_slashing_medium,
	gibbing_power = GibbingPower.medium,
	gibbing_type = GibbingTypes.sawing,
	gib_push_force = GibbingSettings.gib_push_force.sawing_heavy,
	melee_attack_strength = melee_attack_strengths.heavy,
	wounds_template = WoundsTemplates.power_sword,
	armor_damage_modifier = cutting_am,
	targets = {
		{
			armor_damage_modifier = heavy_sword_am,
			boost_curve_multiplier_finesse = {
				0.2,
				1
			},
			power_distribution = {
				attack = {
					100,
					200
				},
				impact = {
					8,
					16
				}
			}
		},
		{
			armor_damage_modifier = heavy_sword_am,
			power_distribution = {
				attack = {
					60,
					120
				},
				impact = {
					6,
					12
				}
			}
		},
		{
			armor_damage_modifier = heavy_sword_am,
			power_distribution = {
				attack = {
					20,
					60
				},
				impact = {
					5,
					10
				}
			}
		},
		default_target = {
			armor_damage_modifier = heavy_sword_am,
			power_distribution = {
				attack = {
					10,
					50
				},
				impact = {
					4,
					8
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
