-- chunkname: @scripts/settings/equipment/weapon_templates/power_swords_2h/settings_templates/power_sword_2h_damage_profile_templates.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local DamageProfileSettings = require("scripts/settings/damage/damage_profile_settings")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local GibbingSettings = require("scripts/settings/gibbing/gibbing_settings")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local WoundsTemplates = require("scripts/settings/damage/wounds_templates")
local armor_types = ArmorSettings.types
local damage_lerp_values = DamageProfileSettings.damage_lerp_values
local damage_types = DamageSettings.damage_types
local gibbing_power = GibbingSettings.gibbing_power
local gibbing_types = GibbingSettings.gibbing_types
local melee_attack_strengths = AttackSettings.melee_attack_strength
local big_cleave = DamageProfileSettings.big_cleave
local large_cleave = DamageProfileSettings.large_cleave
local light_cleave = DamageProfileSettings.light_cleave
local medium_cleave = DamageProfileSettings.medium_cleave
local single_cleave = DamageProfileSettings.single_cleave
local damage_templates = {}
local overrides = {}

table.make_unique(damage_templates)
table.make_unique(overrides)

local cutting_am = {
	attack = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1,
		[armor_types.armored] = damage_lerp_values.lerp_0_5,
		[armor_types.resistant] = damage_lerp_values.lerp_0_5,
		[armor_types.player] = damage_lerp_values.no_damage,
		[armor_types.berserker] = damage_lerp_values.lerp_0_75,
		[armor_types.super_armor] = damage_lerp_values.lerp_0_1,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_75,
		[armor_types.void_shield] = damage_lerp_values.lerp_0_75
	},
	impact = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1,
		[armor_types.armored] = damage_lerp_values.lerp_1,
		[armor_types.resistant] = damage_lerp_values.lerp_1,
		[armor_types.player] = damage_lerp_values.lerp_1,
		[armor_types.berserker] = damage_lerp_values.lerp_1,
		[armor_types.super_armor] = damage_lerp_values.lerp_1,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
		[armor_types.void_shield] = damage_lerp_values.lerp_1
	}
}
local power_am = {
	attack = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1,
		[armor_types.armored] = damage_lerp_values.lerp_1,
		[armor_types.resistant] = damage_lerp_values.lerp_1_25,
		[armor_types.player] = damage_lerp_values.no_damage,
		[armor_types.berserker] = damage_lerp_values.lerp_1,
		[armor_types.super_armor] = damage_lerp_values.lerp_0_75,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
		[armor_types.void_shield] = damage_lerp_values.lerp_0_9
	},
	impact = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1,
		[armor_types.armored] = damage_lerp_values.lerp_1,
		[armor_types.resistant] = damage_lerp_values.lerp_1,
		[armor_types.player] = damage_lerp_values.lerp_1,
		[armor_types.berserker] = damage_lerp_values.lerp_1,
		[armor_types.super_armor] = damage_lerp_values.lerp_1,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
		[armor_types.void_shield] = damage_lerp_values.lerp_1
	}
}
local power_stab_am = {
	attack = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1,
		[armor_types.armored] = damage_lerp_values.lerp_1,
		[armor_types.resistant] = damage_lerp_values.lerp_1_5,
		[armor_types.player] = damage_lerp_values.no_damage,
		[armor_types.berserker] = damage_lerp_values.lerp_1,
		[armor_types.super_armor] = damage_lerp_values.lerp_0_9,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
		[armor_types.void_shield] = damage_lerp_values.lerp_1
	},
	impact = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1,
		[armor_types.armored] = damage_lerp_values.lerp_1,
		[armor_types.resistant] = damage_lerp_values.lerp_1,
		[armor_types.player] = damage_lerp_values.lerp_1,
		[armor_types.berserker] = damage_lerp_values.lerp_1,
		[armor_types.super_armor] = damage_lerp_values.lerp_1,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
		[armor_types.void_shield] = damage_lerp_values.lerp_1
	}
}
local heavy_sword_am = {
	attack = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1,
		[armor_types.armored] = damage_lerp_values.lerp_0_9,
		[armor_types.resistant] = damage_lerp_values.lerp_0_9,
		[armor_types.player] = damage_lerp_values.no_damage,
		[armor_types.berserker] = damage_lerp_values.lerp_1,
		[armor_types.super_armor] = damage_lerp_values.lerp_0_7,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_9,
		[armor_types.void_shield] = damage_lerp_values.lerp_0_8
	},
	impact = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1,
		[armor_types.armored] = damage_lerp_values.lerp_1,
		[armor_types.resistant] = damage_lerp_values.lerp_1,
		[armor_types.player] = damage_lerp_values.lerp_1,
		[armor_types.berserker] = damage_lerp_values.lerp_1,
		[armor_types.super_armor] = damage_lerp_values.lerp_0_9,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
		[armor_types.void_shield] = damage_lerp_values.lerp_1
	}
}
local heavy_stab_am = {
	attack = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1,
		[armor_types.armored] = damage_lerp_values.lerp_1,
		[armor_types.resistant] = damage_lerp_values.lerp_1_2,
		[armor_types.player] = damage_lerp_values.no_damage,
		[armor_types.berserker] = damage_lerp_values.lerp_1,
		[armor_types.super_armor] = damage_lerp_values.lerp_0_8,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_9,
		[armor_types.void_shield] = damage_lerp_values.lerp_0_8
	},
	impact = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1,
		[armor_types.armored] = damage_lerp_values.lerp_1,
		[armor_types.resistant] = damage_lerp_values.lerp_1,
		[armor_types.player] = damage_lerp_values.lerp_1,
		[armor_types.berserker] = damage_lerp_values.lerp_1,
		[armor_types.super_armor] = damage_lerp_values.lerp_0_9,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
		[armor_types.void_shield] = damage_lerp_values.lerp_1
	}
}

damage_templates.light_powersword_2h = {
	finesse_ability_damage_multiplier = 1.2,
	stagger_category = "melee",
	cleave_distribution = medium_cleave,
	damage_type = damage_types.metal_slashing_medium,
	gibbing_power = gibbing_power.light,
	gibbing_type = gibbing_types.sawing,
	gib_push_force = GibbingSettings.gib_push_force.sawing_medium,
	melee_attack_strength = melee_attack_strengths.light,
	wounds_template = WoundsTemplates.power_sword,
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_0_75,
			[armor_types.resistant] = damage_lerp_values.lerp_1,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_0_8,
			[armor_types.super_armor] = damage_lerp_values.lerp_0_1,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
			[armor_types.void_shield] = damage_lerp_values.lerp_1
		},
		impact = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_1,
			[armor_types.resistant] = damage_lerp_values.lerp_1,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_0_5,
			[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
			[armor_types.void_shield] = damage_lerp_values.lerp_1
		}
	},
	targets = {
		{
			boost_curve_multiplier_finesse = {
				0.4,
				0.8
			},
			power_distribution = {
				attack = {
					120,
					270
				},
				impact = {
					5,
					10
				}
			}
		},
		{
			boost_curve_multiplier_finesse = {
				0.4,
				0.8
			},
			power_distribution = {
				attack = {
					90,
					200
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
					70,
					160
				},
				impact = {
					3,
					7
				}
			}
		},
		{
			power_distribution = {
				attack = {
					40,
					110
				},
				impact = {
					3,
					7
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
					5
				}
			}
		},
		default_target = {
			power_distribution = {
				attack = {
					20,
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
damage_templates.light_powersword_2h_active = {
	finesse_ability_damage_multiplier = 1.5,
	weapon_special = true,
	stagger_category = "melee",
	cleave_distribution = big_cleave,
	damage_type = damage_types.power_sword,
	gibbing_power = gibbing_power.heavy,
	gibbing_type = gibbing_types.sawing,
	gib_push_force = GibbingSettings.gib_push_force.sawing_medium,
	melee_attack_strength = melee_attack_strengths.light,
	wounds_template = WoundsTemplates.power_sword_active,
	armor_damage_modifier = power_am,
	targets = {
		{
			armor_damage_modifier = power_am,
			boost_curve_multiplier_finesse = {
				0.4,
				0.8
			},
			power_distribution = {
				attack = {
					190,
					380
				},
				impact = {
					7,
					10
				}
			}
		},
		{
			armor_damage_modifier = power_am,
			boost_curve_multiplier_finesse = {
				0.4,
				0.8
			},
			power_distribution = {
				attack = {
					150,
					300
				},
				impact = {
					7,
					10
				}
			}
		},
		{
			armor_damage_modifier = power_am,
			boost_curve_multiplier_finesse = {
				0.4,
				0.8
			},
			power_distribution = {
				attack = {
					125,
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
					50,
					100
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
damage_templates.light_powersword_2h_smiter = {
	finesse_ability_damage_multiplier = 2,
	stagger_category = "melee",
	cleave_distribution = single_cleave,
	damage_type = damage_types.metal_slashing_medium,
	gibbing_power = gibbing_power.light,
	gibbing_type = gibbing_types.sawing,
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
					[armor_types.super_armor] = damage_lerp_values.lerp_0_4,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_1
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_75,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_75,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_1
				}
			},
			boost_curve_multiplier_finesse = {
				1,
				2
			},
			power_distribution = {
				attack = {
					150,
					300
				},
				impact = {
					5,
					10
				}
			}
		},
		{
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_1,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
					[armor_types.player] = damage_lerp_values.no_damage,
					[armor_types.berserker] = damage_lerp_values.lerp_1,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_4,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_1
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_75,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_75,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_1
				}
			},
			boost_curve_multiplier_finesse = {
				1,
				2
			},
			power_distribution = {
				attack = {
					50,
					100
				},
				impact = {
					5,
					10
				}
			}
		},
		default_target = {
			armor_damage_modifier = cutting_am,
			power_distribution = {
				attack = {
					10,
					45
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
damage_templates.light_powersword_2h_smiter_active = {
	finesse_ability_damage_multiplier = 2,
	weapon_special = true,
	stagger_category = "melee",
	cleave_distribution = big_cleave,
	damage_type = damage_types.power_sword,
	gibbing_power = gibbing_power.heavy,
	gibbing_type = gibbing_types.sawing,
	gib_push_force = GibbingSettings.gib_push_force.sawing_medium,
	melee_attack_strength = melee_attack_strengths.light,
	wounds_template = WoundsTemplates.power_sword_active,
	armor_damage_modifier = power_am,
	targets = {
		{
			armor_damage_modifier = power_am,
			power_distribution = {
				attack = {
					225,
					450
				},
				impact = {
					7,
					10
				}
			},
			boost_curve_multiplier_finesse = {
				1,
				1.5
			}
		},
		{
			armor_damage_modifier = power_am,
			power_distribution = {
				attack = {
					150,
					300
				},
				impact = {
					7,
					9
				}
			},
			boost_curve_multiplier_finesse = {
				0.5,
				1
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
					4,
					6
				}
			},
			boost_curve_multiplier_finesse = {
				0.5,
				1
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
					2,
					4
				}
			},
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.light_powersword_2h_stab = {
	finesse_ability_damage_multiplier = 2,
	stagger_category = "melee",
	cleave_distribution = single_cleave,
	damage_type = damage_types.metal_slashing_medium,
	gibbing_power = gibbing_power.light,
	gibbing_type = gibbing_types.sawing,
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
					[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_1
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_75,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_75,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_1
				}
			},
			boost_curve_multiplier_finesse = {
				1.5,
				2.5
			},
			power_distribution = {
				attack = {
					150,
					300
				},
				impact = {
					10,
					15
				}
			}
		},
		{
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_1,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
					[armor_types.player] = damage_lerp_values.no_damage,
					[armor_types.berserker] = damage_lerp_values.lerp_1,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_4,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_1
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_75,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_75,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_1
				}
			},
			power_distribution = {
				attack = {
					50,
					100
				},
				impact = {
					5,
					10
				}
			}
		},
		default_target = {
			armor_damage_modifier = cutting_am,
			power_distribution = {
				attack = {
					10,
					45
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
damage_templates.light_powersword_2h_stab_active = {
	ignore_stagger_reduction = "true",
	finesse_ability_damage_multiplier = 2,
	weapon_special = true,
	stagger_category = "melee",
	cleave_distribution = light_cleave,
	damage_type = damage_types.power_sword,
	gibbing_power = gibbing_power.heavy,
	gibbing_type = gibbing_types.sawing,
	gib_push_force = GibbingSettings.gib_push_force.sawing_medium,
	melee_attack_strength = melee_attack_strengths.light,
	wounds_template = WoundsTemplates.power_sword_active,
	armor_damage_modifier = power_am,
	targets = {
		{
			armor_damage_modifier = power_am,
			power_distribution = {
				attack = {
					225,
					450
				},
				impact = {
					7,
					12
				}
			},
			boost_curve_multiplier_finesse = {
				1,
				2
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
					7,
					9
				}
			},
			boost_curve_multiplier_finesse = {
				0.5,
				1
			}
		},
		{
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
			boost_curve_multiplier_finesse = {
				0.5,
				1
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
damage_templates.powersword_2h_heavy_smiter = {
	finesse_ability_damage_multiplier = 2,
	ragdoll_push_force = 150,
	stagger_category = "melee",
	cleave_distribution = medium_cleave,
	damage_type = damage_types.metal_slashing_medium,
	gibbing_power = gibbing_power.medium,
	gibbing_type = gibbing_types.sawing,
	gib_push_force = GibbingSettings.gib_push_force.sawing_heavy,
	melee_attack_strength = melee_attack_strengths.heavy,
	wounds_template = WoundsTemplates.power_sword,
	armor_damage_modifier = heavy_sword_am,
	targets = {
		{
			armor_damage_modifier = heavy_sword_am,
			boost_curve_multiplier_finesse = {
				1,
				2
			},
			power_distribution = {
				attack = {
					200,
					400
				},
				impact = {
					15,
					25
				}
			}
		},
		{
			armor_damage_modifier = heavy_sword_am,
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
damage_templates.powersword_2h_heavy_smiter_active = {
	finesse_ability_damage_multiplier = 2,
	ignore_stagger_reduction = "true",
	weapon_special = true,
	stagger_category = "melee",
	cleave_distribution = big_cleave,
	damage_type = damage_types.power_sword,
	gibbing_power = gibbing_power.heavy,
	gibbing_type = gibbing_types.sawing,
	gib_push_force = GibbingSettings.gib_push_force.sawing_medium,
	melee_attack_strength = melee_attack_strengths.heavy,
	wounds_template = WoundsTemplates.power_sword,
	armor_damage_modifier = power_am,
	targets = {
		{
			armor_damage_modifier = power_am,
			boost_curve_multiplier_finesse = {
				1,
				2
			},
			power_distribution = {
				attack = {
					325,
					650
				},
				impact = {
					15,
					25
				}
			}
		},
		{
			armor_damage_modifier = power_am,
			boost_curve_multiplier_finesse = {
				1,
				2
			},
			power_distribution = {
				attack = {
					150,
					300
				},
				impact = {
					6,
					12
				}
			}
		},
		{
			armor_damage_modifier = power_am,
			boost_curve_multiplier_finesse = {
				1,
				2
			},
			power_distribution = {
				attack = {
					125,
					250
				},
				impact = {
					5,
					10
				}
			}
		},
		{
			armor_damage_modifier = power_am,
			boost_curve_multiplier_finesse = {
				1,
				2
			},
			power_distribution = {
				attack = {
					60,
					120
				},
				impact = {
					5,
					10
				}
			}
		},
		default_target = {
			armor_damage_modifier = power_am,
			power_distribution = {
				attack = {
					40,
					80
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
damage_templates.powersword_2h_heavy_stab = {
	finesse_ability_damage_multiplier = 2,
	ragdoll_push_force = 150,
	stagger_category = "melee",
	cleave_distribution = medium_cleave,
	damage_type = damage_types.metal_slashing_medium,
	gibbing_power = gibbing_power.medium,
	gibbing_type = gibbing_types.sawing,
	gib_push_force = GibbingSettings.gib_push_force.sawing_heavy,
	melee_attack_strength = melee_attack_strengths.heavy,
	wounds_template = WoundsTemplates.power_sword,
	armor_damage_modifier = heavy_stab_am,
	targets = {
		{
			armor_damage_modifier = heavy_stab_am,
			boost_curve_multiplier_finesse = {
				1.5,
				2.5
			},
			power_distribution = {
				attack = {
					200,
					400
				},
				impact = {
					15,
					25
				}
			}
		},
		{
			armor_damage_modifier = heavy_stab_am,
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
			armor_damage_modifier = heavy_stab_am,
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
			armor_damage_modifier = heavy_stab_am,
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
damage_templates.powersword_2h_heavy_stab_active = {
	finesse_ability_damage_multiplier = 2,
	ignore_stagger_reduction = "true",
	weapon_special = true,
	stagger_category = "melee",
	cleave_distribution = big_cleave,
	damage_type = damage_types.power_sword,
	gibbing_power = gibbing_power.heavy,
	gibbing_type = gibbing_types.sawing,
	gib_push_force = GibbingSettings.gib_push_force.sawing_medium,
	melee_attack_strength = melee_attack_strengths.heavy,
	wounds_template = WoundsTemplates.power_sword,
	armor_damage_modifier = power_stab_am,
	targets = {
		{
			armor_damage_modifier = power_stab_am,
			boost_curve_multiplier_finesse = {
				1.5,
				2.5
			},
			power_distribution = {
				attack = {
					325,
					650
				},
				impact = {
					15,
					25
				}
			}
		},
		{
			armor_damage_modifier = power_stab_am,
			power_distribution = {
				attack = {
					150,
					300
				},
				impact = {
					6,
					12
				}
			}
		},
		{
			armor_damage_modifier = power_stab_am,
			power_distribution = {
				attack = {
					60,
					120
				},
				impact = {
					5,
					10
				}
			}
		},
		default_target = {
			armor_damage_modifier = power_stab_am,
			power_distribution = {
				attack = {
					30,
					60
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
damage_templates.powersword_2h_heavy_linesman = {
	finesse_ability_damage_multiplier = 1.5,
	ragdoll_push_force = 150,
	stagger_category = "melee",
	cleave_distribution = large_cleave,
	damage_type = damage_types.metal_slashing_medium,
	gibbing_power = gibbing_power.medium,
	gibbing_type = gibbing_types.sawing,
	gib_push_force = GibbingSettings.gib_push_force.sawing_heavy,
	melee_attack_strength = melee_attack_strengths.heavy,
	wounds_template = WoundsTemplates.power_sword,
	armor_damage_modifier = cutting_am,
	targets = {
		{
			armor_damage_modifier = heavy_sword_am,
			boost_curve_multiplier_finesse = {
				0.8,
				1.4
			},
			power_distribution = {
				attack = {
					165,
					330
				},
				impact = {
					10,
					20
				}
			}
		},
		{
			armor_damage_modifier = heavy_sword_am,
			boost_curve_multiplier_finesse = {
				0.4,
				0.8
			},
			power_distribution = {
				attack = {
					150,
					250
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
					100,
					200
				},
				impact = {
					5,
					10
				}
			}
		},
		{
			armor_damage_modifier = heavy_sword_am,
			power_distribution = {
				attack = {
					80,
					160
				},
				impact = {
					3,
					6
				}
			}
		},
		{
			armor_damage_modifier = heavy_sword_am,
			power_distribution = {
				attack = {
					50,
					100
				},
				impact = {
					3,
					6
				}
			}
		},
		{
			armor_damage_modifier = heavy_sword_am,
			power_distribution = {
				attack = {
					40,
					80
				},
				impact = {
					2,
					4
				}
			}
		},
		default_target = {
			armor_damage_modifier = heavy_sword_am,
			power_distribution = {
				attack = {
					35,
					65
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
damage_templates.powersword_2h_heavy_linesman_active = {
	finesse_ability_damage_multiplier = 1.5,
	ignore_stagger_reduction = "true",
	weapon_special = true,
	stagger_category = "melee",
	cleave_distribution = big_cleave,
	damage_type = damage_types.power_sword,
	gibbing_power = gibbing_power.heavy,
	gibbing_type = gibbing_types.sawing,
	gib_push_force = GibbingSettings.gib_push_force.sawing_medium,
	melee_attack_strength = melee_attack_strengths.heavy,
	wounds_template = WoundsTemplates.power_sword,
	armor_damage_modifier = power_am,
	targets = {
		{
			armor_damage_modifier = power_am,
			boost_curve_multiplier_finesse = {
				0.8,
				1.6
			},
			power_distribution = {
				attack = {
					250,
					500
				},
				impact = {
					10,
					20
				}
			}
		},
		{
			armor_damage_modifier = power_am,
			boost_curve_multiplier_finesse = {
				0.6,
				1.2
			},
			power_distribution = {
				attack = {
					170,
					340
				},
				impact = {
					8,
					12
				}
			}
		},
		{
			armor_damage_modifier = power_am,
			boost_curve_multiplier_finesse = {
				0.4,
				0.8
			},
			power_distribution = {
				attack = {
					160,
					320
				},
				impact = {
					5,
					10
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
					5,
					10
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
					4,
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
					4,
					8
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
					4,
					8
				}
			}
		},
		default_target = {
			armor_damage_modifier = power_am,
			power_distribution = {
				attack = {
					40,
					80
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
damage_templates.powersword_explosion = {
	ragdoll_push_force = 1200,
	ignore_shield = true,
	suppression_type = "ability",
	ragdoll_only = true,
	ignore_stagger_reduction = true,
	stagger_category = "uppercut",
	power_distribution = {
		attack = 25,
		impact = 62
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
			[armor_types.void_shield] = 1
		},
		impact = {
			[armor_types.unarmored] = 1,
			[armor_types.armored] = 1,
			[armor_types.resistant] = 1,
			[armor_types.player] = 1,
			[armor_types.berserker] = 1,
			[armor_types.super_armor] = 1,
			[armor_types.disgustingly_resilient] = 1,
			[armor_types.void_shield] = 1
		}
	},
	stagger_duration_modifier = {
		0.5,
		1.5
	},
	damage_type = damage_types.kinetic,
	targets = {
		default_target = {}
	}
}
damage_templates.powersword_explosion_outer = {
	ignore_shield = true,
	suppression_type = "ability",
	ragdoll_push_force = 1000,
	ignore_stagger_reduction = true,
	stagger_category = "uppercut",
	power_distribution = {
		attack = 0,
		impact = 35
	},
	armor_damage_modifier_ranged = {
		near = {
			attack = {
				[armor_types.unarmored] = 1,
				[armor_types.armored] = 1,
				[armor_types.resistant] = 1,
				[armor_types.player] = 1,
				[armor_types.berserker] = 1,
				[armor_types.super_armor] = 1,
				[armor_types.disgustingly_resilient] = 1,
				[armor_types.void_shield] = 1
			},
			impact = {
				[armor_types.unarmored] = 1,
				[armor_types.armored] = 1,
				[armor_types.resistant] = 1,
				[armor_types.player] = 1,
				[armor_types.berserker] = 1,
				[armor_types.super_armor] = 1,
				[armor_types.disgustingly_resilient] = 1,
				[armor_types.void_shield] = 1
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
				[armor_types.unarmored] = 1,
				[armor_types.armored] = 1,
				[armor_types.resistant] = 1,
				[armor_types.player] = 0.2,
				[armor_types.berserker] = 0.5,
				[armor_types.super_armor] = 0.2,
				[armor_types.disgustingly_resilient] = 1,
				[armor_types.void_shield] = 0.2
			}
		}
	},
	stagger_duration_modifier = {
		0.1,
		0.5
	},
	gibbing_power = gibbing_power.always,
	damage_type = damage_types.plasma,
	targets = {
		default_target = {}
	}
}

return {
	base_templates = damage_templates,
	overrides = overrides
}
