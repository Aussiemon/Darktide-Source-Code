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
local big_cleave = DamageProfileSettings.big_cleave
local medium_cleave = DamageProfileSettings.medium_cleave
local smiter_light_default_am = {
	attack = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1,
		[armor_types.armored] = damage_lerp_values.lerp_0_75,
		[armor_types.resistant] = damage_lerp_values.lerp_0_75,
		[armor_types.player] = damage_lerp_values.lerp_1,
		[armor_types.berserker] = damage_lerp_values.lerp_0_5,
		[armor_types.super_armor] = damage_lerp_values.lerp_0_75,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_75,
		[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
		[armor_types.prop_armor] = damage_lerp_values.lerp_2
	},
	impact = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1,
		[armor_types.armored] = damage_lerp_values.lerp_1,
		[armor_types.resistant] = damage_lerp_values.lerp_1,
		[armor_types.player] = damage_lerp_values.lerp_1,
		[armor_types.berserker] = damage_lerp_values.lerp_1,
		[armor_types.super_armor] = damage_lerp_values.lerp_1,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_75,
		[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
		[armor_types.prop_armor] = damage_lerp_values.lerp_1
	}
}
local linesman_light_default_am = {
	attack = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1,
		[armor_types.armored] = damage_lerp_values.lerp_0_75,
		[armor_types.resistant] = damage_lerp_values.lerp_0_75,
		[armor_types.player] = damage_lerp_values.lerp_1,
		[armor_types.berserker] = damage_lerp_values.lerp_0_5,
		[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_75,
		[armor_types.void_shield] = damage_lerp_values.lerp_1,
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
local tank_heavy_default_am = {
	attack = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1,
		[armor_types.armored] = damage_lerp_values.lerp_0_75,
		[armor_types.resistant] = damage_lerp_values.lerp_1,
		[armor_types.player] = damage_lerp_values.lerp_1,
		[armor_types.berserker] = damage_lerp_values.lerp_0_5,
		[armor_types.super_armor] = damage_lerp_values.lerp_0_75,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
		[armor_types.void_shield] = damage_lerp_values.lerp_1,
		[armor_types.prop_armor] = damage_lerp_values.lerp_0_75
	},
	impact = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1,
		[armor_types.armored] = damage_lerp_values.lerp_1,
		[armor_types.resistant] = damage_lerp_values.lerp_1,
		[armor_types.player] = damage_lerp_values.lerp_1,
		[armor_types.berserker] = damage_lerp_values.lerp_0_5,
		[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
		[armor_types.void_shield] = damage_lerp_values.lerp_1,
		[armor_types.prop_armor] = damage_lerp_values.lerp_1
	}
}
local light_active_am = {
	attack = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1,
		[armor_types.armored] = damage_lerp_values.lerp_1,
		[armor_types.resistant] = damage_lerp_values.lerp_1_5,
		[armor_types.player] = damage_lerp_values.no_damage,
		[armor_types.berserker] = damage_lerp_values.lerp_1,
		[armor_types.super_armor] = damage_lerp_values.lerp_1,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
		[armor_types.void_shield] = damage_lerp_values.lerp_1,
		[armor_types.prop_armor] = damage_lerp_values.lerp_2
	},
	impact = {
		[armor_types.unarmored] = damage_lerp_values.lerp_2,
		[armor_types.armored] = damage_lerp_values.lerp_2,
		[armor_types.resistant] = damage_lerp_values.lerp_1,
		[armor_types.player] = damage_lerp_values.no_damage,
		[armor_types.berserker] = damage_lerp_values.lerp_1,
		[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_2,
		[armor_types.void_shield] = damage_lerp_values.lerp_2,
		[armor_types.prop_armor] = damage_lerp_values.lerp_2
	}
}
local tank_heavy_active_am = {
	attack = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1,
		[armor_types.armored] = damage_lerp_values.lerp_1,
		[armor_types.resistant] = damage_lerp_values.lerp_1_5,
		[armor_types.player] = damage_lerp_values.no_damage,
		[armor_types.berserker] = damage_lerp_values.lerp_1,
		[armor_types.super_armor] = damage_lerp_values.lerp_1,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
		[armor_types.void_shield] = damage_lerp_values.lerp_1,
		[armor_types.prop_armor] = damage_lerp_values.lerp_2
	},
	impact = {
		[armor_types.unarmored] = damage_lerp_values.lerp_2,
		[armor_types.armored] = damage_lerp_values.lerp_2,
		[armor_types.resistant] = damage_lerp_values.lerp_1,
		[armor_types.player] = damage_lerp_values.no_damage,
		[armor_types.berserker] = damage_lerp_values.lerp_1,
		[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_2,
		[armor_types.void_shield] = damage_lerp_values.lerp_2,
		[armor_types.prop_armor] = damage_lerp_values.lerp_2
	}
}
damage_templates.ogryn_powermaul_light_smiter = {
	ragdoll_push_force = 200,
	ignore_shield = false,
	ragdoll_only = true,
	stagger_category = "melee",
	cleave_distribution = single_cleave,
	gibbing_power = GibbingPower.always,
	gibbing_type = GibbingTypes.default,
	melee_attack_strength = melee_attack_strengths.light,
	wounds_template = WoundsTemplates.ogryn_power_maul,
	stagger_duration_modifier = {
		0.1,
		0.5
	},
	armor_damage_modifier = smiter_light_default_am,
	targets = {
		{
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = {
					110,
					220
				},
				impact = {
					10,
					20
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
					60,
					80
				},
				impact = {
					8,
					13
				}
			}
		},
		default_target = {
			power_distribution = {
				impact = 12,
				attack = {
					20,
					40
				}
			}
		}
	}
}
overrides.ogryn_powermaul_light_smiter_active = {
	parent_template_name = "ogryn_powermaul_light_smiter",
	overrides = {
		{
			"ignore_shield",
			true
		},
		{
			"cleave_distribution",
			"impact",
			0.01
		},
		{
			"stagger_duration_modifier",
			{
				0.1,
				0.2
			}
		},
		{
			"armor_damage_modifier",
			light_active_am
		},
		{
			"targets",
			1,
			"power_distribution",
			"attack",
			{
				220,
				440
			}
		},
		{
			"targets",
			1,
			"power_distribution",
			"impact",
			{
				40,
				80
			}
		},
		{
			"gibbing_power",
			GibbingPower.heavy
		},
		{
			"gibbing_type",
			GibbingTypes.explosion
		},
		{
			"wounds_template",
			WoundsTemplates.ogryn_power_maul_activated
		},
		{
			"cleave_distribution",
			"attack",
			math.huge
		},
		{
			"cleave_distribution",
			"impact",
			math.huge
		}
	}
}
overrides.powermaul_2h_heavy_smiter = {
	parent_template_name = "ogryn_powermaul_light_smiter",
	overrides = {
		{
			"melee_attack_strength",
			melee_attack_strengths.heavy
		},
		{
			"targets",
			1,
			"power_distribution",
			"attack",
			{
				120,
				220
			}
		}
	}
}
overrides.powermaul_2h_heavy_smiter_active = {
	parent_template_name = "ogryn_powermaul_light_smiter",
	overrides = {
		overrides = {
			{
				"cleave_distribution",
				"attack",
				0.01
			},
			{
				"cleave_distribution",
				"impact",
				0.01
			},
			{
				"stagger_duration_modifier",
				{
					0.2,
					0.5
				}
			},
			{
				"armor_damage_modifier",
				tank_heavy_active_am
			},
			{
				"targets",
				1,
				"power_distribution",
				"attack",
				{
					325,
					600
				}
			},
			{
				"targets",
				1,
				"power_distribution",
				"impact",
				{
					40,
					80
				}
			},
			{
				"gibbing_power",
				GibbingPower.heavy
			},
			{
				"gibbing_type",
				GibbingTypes.explosion
			}
		}
	}
}
damage_templates.ogryn_powermaul_light_linesman = {
	ragdoll_push_force = 300,
	ragdoll_only = true,
	stagger_category = "melee",
	cleave_distribution = double_cleave,
	damage_type = damage_types.ogryn_pipe_club,
	gibbing_power = GibbingPower.always,
	gibbing_type = GibbingTypes.default,
	melee_attack_strength = melee_attack_strengths.light,
	wounds_template = WoundsTemplates.ogryn_power_maul,
	stagger_duration_modifier = {
		0.1,
		0.5
	},
	armor_damage_modifier = linesman_light_default_am,
	targets = {
		{
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = {
					90,
					135
				},
				impact = {
					10,
					15
				}
			}
		},
		{
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = {
					80,
					90
				},
				impact = {
					6,
					13
				}
			}
		},
		{
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = {
					5,
					20
				},
				impact = {
					3,
					8
				}
			}
		},
		default_target = {
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = 0,
				impact = 5
			},
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
overrides.ogryn_powermaul_light_linesman_active = {
	parent_template_name = "ogryn_powermaul_light_linesman",
	overrides = {
		{
			"stagger_duration_modifier",
			{
				0.1,
				0.2
			}
		},
		{
			"armor_damage_modifier",
			light_active_am
		},
		{
			"targets",
			1,
			"power_distribution",
			"attack",
			{
				90,
				165
			}
		},
		{
			"targets",
			1,
			"power_distribution",
			"impact",
			{
				40,
				80
			}
		},
		{
			"gibbing_power",
			GibbingPower.heavy
		},
		{
			"gibbing_type",
			GibbingTypes.explosion
		},
		{
			"wounds_template",
			WoundsTemplates.ogryn_power_maul_activated
		},
		{
			"cleave_distribution",
			"attack",
			math.huge
		},
		{
			"cleave_distribution",
			"impact",
			math.huge
		}
	}
}
damage_templates.ogryn_powermaul_heavy_tank = {
	ragdoll_push_force = 400,
	ragdoll_only = true,
	stagger_category = "melee",
	cleave_distribution = big_cleave,
	damage_type = damage_types.ogryn_pipe_club_heavy,
	gibbing_power = GibbingPower.always,
	gibbing_type = GibbingTypes.default,
	melee_attack_strength = melee_attack_strengths.heavy,
	wounds_template = WoundsTemplates.ogryn_power_maul,
	stagger_duration_modifier = {
		0.1,
		0.5
	},
	armor_damage_modifier = tank_heavy_default_am,
	targets = {
		{
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = {
					120,
					220
				},
				impact = {
					30,
					35
				}
			}
		},
		{
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = {
					80,
					110
				},
				impact = {
					20,
					25
				}
			}
		},
		{
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = {
					20,
					30
				},
				impact = {
					15,
					20
				}
			}
		},
		{
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = {
					10,
					25
				},
				impact = {
					10,
					15
				}
			}
		},
		default_target = {
			boost_curve_multiplier_finesse = 0.25,
			armor_damage_modifier = tank_heavy_default_am,
			power_distribution = {
				attack = {
					0,
					0
				},
				impact = {
					10,
					15
				}
			},
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
overrides.ogryn_powermaul_heavy_tank_active = {
	parent_template_name = "ogryn_powermaul_heavy_tank",
	overrides = {
		{
			"stagger_duration_modifier",
			{
				0.2,
				0.5
			}
		},
		{
			"armor_damage_modifier",
			tank_heavy_active_am
		},
		{
			"targets",
			1,
			"power_distribution",
			"attack",
			{
				220,
				440
			}
		},
		{
			"targets",
			1,
			"power_distribution",
			"impact",
			{
				40,
				70
			}
		},
		{
			"gibbing_power",
			GibbingPower.heavy
		},
		{
			"gibbing_type",
			GibbingTypes.explosion
		},
		{
			"wounds_template",
			WoundsTemplates.ogryn_power_maul_activated
		},
		{
			"cleave_distribution",
			"attack",
			math.huge
		},
		{
			"cleave_distribution",
			"impact",
			math.huge
		}
	}
}
damage_templates.ogryn_powermaul_heavy_smiter = {
	ragdoll_push_force = 400,
	ragdoll_only = true,
	stagger_category = "melee",
	cleave_distribution = double_cleave,
	damage_type = damage_types.ogryn_pipe_club_heavy,
	gibbing_power = GibbingPower.always,
	gibbing_type = GibbingTypes.default,
	melee_attack_strength = melee_attack_strengths.heavy,
	stagger_duration_modifier = {
		0.1,
		0.5
	},
	armor_damage_modifier = tank_heavy_default_am,
	targets = {
		{
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = {
					200,
					400
				},
				impact = {
					30,
					35
				}
			}
		},
		{
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = {
					90,
					150
				},
				impact = {
					20,
					25
				}
			}
		},
		default_target = {
			boost_curve_multiplier_finesse = 0.25,
			armor_damage_modifier = tank_heavy_default_am,
			power_distribution = {
				attack = {
					0,
					0
				},
				impact = {
					10,
					15
				}
			},
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
overrides.ogryn_powermaul_heavy_smiter_active = {
	parent_template_name = "ogryn_powermaul_heavy_smiter",
	overrides = {
		{
			"stagger_duration_modifier",
			{
				0.2,
				0.5
			}
		},
		{
			"armor_damage_modifier",
			tank_heavy_active_am
		},
		{
			"targets",
			1,
			"power_distribution",
			"attack",
			{
				300,
				600
			}
		},
		{
			"gibbing_power",
			GibbingPower.heavy
		},
		{
			"gibbing_type",
			GibbingTypes.explosion
		},
		{
			"cleave_distribution",
			"attack",
			math.huge
		},
		{
			"cleave_distribution",
			"impact",
			math.huge
		}
	}
}
damage_templates.ogryn_powermaul_slabshield_smite = {
	ragdoll_push_force = 1000,
	ragdoll_only = true,
	ignore_stagger_reduction = true,
	stagger_category = "melee",
	cleave_distribution = medium_cleave,
	damage_type = damage_types.blunt_heavy,
	gibbing_power = GibbingPower.always,
	gibbing_type = GibbingTypes.default,
	melee_attack_strength = melee_attack_strengths.heavy,
	stagger_duration_modifier = {
		0.1,
		0.5
	},
	armor_damage_modifier = tank_heavy_default_am,
	targets = {
		{
			power_distribution = {
				attack = {
					100,
					200
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
					30,
					90
				},
				impact = {
					20,
					30
				}
			}
		},
		{
			power_distribution = {
				attack = {
					10,
					10
				},
				impact = {
					15,
					20
				}
			}
		},
		default_target = {
			armor_damage_modifier = tank_heavy_default_am,
			power_distribution = {
				attack = {
					0,
					0
				},
				impact = {
					10,
					15
				}
			}
		}
	}
}
damage_templates.ogryn_powermaul_slabshield_tank = {
	ragdoll_push_force = 900,
	ragdoll_only = true,
	ignore_stagger_reduction = true,
	stagger_category = "melee",
	cleave_distribution = {
		attack = math.huge,
		impact = math.huge
	},
	damage_type = damage_types.blunt_heavy,
	gibbing_power = GibbingPower.low,
	gibbing_type = GibbingTypes.default,
	melee_attack_strength = melee_attack_strengths.heavy,
	stagger_duration_modifier = {
		0.1,
		0.5
	},
	armor_damage_modifier = tank_heavy_default_am,
	targets = {
		{
			power_distribution = {
				attack = {
					50,
					100
				},
				impact = {
					20,
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
					15,
					20
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
					10,
					20
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
					5,
					15
				}
			}
		},
		default_target = {
			armor_damage_modifier = tank_heavy_default_am,
			power_distribution = {
				attack = {
					0,
					0
				},
				impact = {
					5,
					15
				}
			}
		}
	}
}
damage_templates.ogryn_powermaul_light_tank = {
	ragdoll_push_force = 500,
	ragdoll_only = true,
	stagger_category = "melee",
	cleave_distribution = medium_cleave,
	damage_type = damage_types.ogryn_pipe_club,
	gibbing_power = GibbingPower.always,
	gibbing_type = GibbingTypes.default,
	melee_attack_strength = melee_attack_strengths.light,
	wounds_template = WoundsTemplates.ogryn_power_maul,
	stagger_duration_modifier = {
		0.1,
		0.5
	},
	armor_damage_modifier = tank_heavy_default_am,
	targets = {
		{
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = {
					75,
					100
				},
				impact = {
					15,
					25
				}
			}
		},
		{
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = {
					60,
					90
				},
				impact = {
					11,
					18
				}
			}
		},
		{
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = {
					20,
					30
				},
				impact = {
					5,
					10
				}
			}
		},
		{
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = {
					10,
					20
				},
				impact = {
					3,
					10
				}
			}
		},
		default_target = {
			boost_curve_multiplier_finesse = 0.25,
			armor_damage_modifier = tank_heavy_default_am,
			power_distribution = {
				attack = {
					0,
					0
				},
				impact = {
					3,
					10
				}
			},
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
overrides.ogryn_powermaul_light_tank_active = {
	parent_template_name = "ogryn_powermaul_light_tank",
	overrides = {
		{
			"stagger_duration_modifier",
			{
				0.1,
				0.2
			}
		},
		{
			"armor_damage_modifier",
			light_active_am
		},
		{
			"targets",
			1,
			"power_distribution",
			"attack",
			{
				150,
				300
			}
		},
		{
			"targets",
			1,
			"power_distribution",
			"impact",
			{
				40,
				80
			}
		},
		{
			"gibbing_power",
			GibbingPower.heavy
		},
		{
			"gibbing_type",
			GibbingTypes.explosion
		},
		{
			"wounds_template",
			WoundsTemplates.ogryn_power_maul_activated
		},
		{
			"cleave_distribution",
			"attack",
			math.huge
		},
		{
			"cleave_distribution",
			"impact",
			math.huge
		}
	}
}
damage_templates.powermaul_explosion = {
	ignore_shield = true,
	suppression_type = "ability",
	ragdoll_push_force = 700,
	ignore_stagger_reduction = true,
	stagger_category = "flamer",
	power_distribution = {
		attack = 25,
		impact = 25
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
			[armor_types.void_shield] = 1,
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
	stagger_duration_modifier = {
		0.1,
		0.5
	},
	damage_type = damage_types.kinetic,
	targets = {
		default_target = {}
	}
}
damage_templates.powermaul_explosion_outer = {
	ignore_shield = true,
	suppression_type = "ability",
	ragdoll_push_force = 1000,
	ignore_stagger_reduction = true,
	stagger_category = "flamer",
	power_distribution = {
		attack = 0,
		impact = 15
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
				[armor_types.void_shield] = 1,
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
		far = {
			attack = {
				[armor_types.unarmored] = 0,
				[armor_types.armored] = 0,
				[armor_types.resistant] = 0,
				[armor_types.player] = 0,
				[armor_types.berserker] = 0,
				[armor_types.super_armor] = 0,
				[armor_types.disgustingly_resilient] = 0,
				[armor_types.void_shield] = 0,
				[armor_types.prop_armor] = 0
			},
			impact = {
				[armor_types.unarmored] = 1,
				[armor_types.armored] = 1,
				[armor_types.resistant] = 1,
				[armor_types.player] = 0.2,
				[armor_types.berserker] = 0.5,
				[armor_types.super_armor] = 0.2,
				[armor_types.disgustingly_resilient] = 0.2,
				[armor_types.void_shield] = 0.2,
				[armor_types.prop_armor] = 0.2
			}
		}
	},
	stagger_duration_modifier = {
		0.1,
		0.2
	},
	damage_type = damage_types.plasma,
	targets = {
		default_target = {}
	}
}

return {
	base_templates = damage_templates,
	overrides = overrides
}
