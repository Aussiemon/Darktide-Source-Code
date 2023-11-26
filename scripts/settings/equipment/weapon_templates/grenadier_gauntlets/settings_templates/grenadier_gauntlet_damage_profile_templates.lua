-- chunkname: @scripts/settings/equipment/weapon_templates/grenadier_gauntlets/settings_templates/grenadier_gauntlet_damage_profile_templates.lua

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
local medium_cleave = DamageProfileSettings.medium_cleave
local big_cleave = DamageProfileSettings.big_cleave

damage_templates.light_grenadier_gauntlet_tank = {
	dead_ragdoll_mod = 1.5,
	ragdoll_push_force = 500,
	ragdoll_only = true,
	ignore_stagger_reduction = true,
	stagger_category = "melee",
	cleave_distribution = big_cleave,
	damage_type = damage_types.blunt_thunder,
	gibbing_type = GibbingTypes.default,
	gibbing_power = GibbingPower.always,
	wounds_template = WoundsTemplates.gauntlet_melee,
	melee_attack_strength = melee_attack_strengths.light,
	targets = {
		{
			boost_curve_multiplier_finesse = 0.25,
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_75,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_5,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_1,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_1_5
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_5,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_25,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_25,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_1_5
				}
			},
			power_distribution = {
				attack = {
					80,
					160
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
					40,
					80
				},
				impact = {
					13,
					20
				}
			}
		},
		{
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = {
					35,
					70
				},
				impact = {
					13,
					20
				}
			}
		},
		{
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = {
					30,
					60
				},
				impact = {
					11,
					17
				}
			}
		},
		default_target = {
			boost_curve_multiplier_finesse = 0.25,
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_5,
					[armor_types.resistant] = damage_lerp_values.lerp_0_5,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_5,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_1,
					[armor_types.disgustingly_resilient] = damage_lerp_values.no_damage,
					[armor_types.void_shield] = damage_lerp_values.no_damage
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_5,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_5,
					[armor_types.super_armor] = damage_lerp_values.no_damage,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_1
				}
			},
			power_distribution = {
				attack = {
					20,
					40
				},
				impact = {
					5,
					10
				}
			},
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
overrides.heavy_grenadier_gauntlet_tank = {
	parent_template_name = "light_grenadier_gauntlet_tank",
	overrides = {
		{
			"targets",
			1,
			"power_distribution",
			"attack",
			{
				120,
				240
			}
		},
		{
			"melee_attack_strength",
			melee_attack_strengths.heavy
		}
	}
}
damage_templates.light_grenadier_gauntlet_smiter = {
	ragdoll_push_force = 1200,
	ignore_shield = false,
	dead_ragdoll_mod = 2,
	ragdoll_only = true,
	stagger_category = "melee",
	cleave_distribution = medium_cleave,
	gibbing_power = GibbingPower.always,
	gibbing_type = GibbingTypes.crushing,
	melee_attack_strength = melee_attack_strengths.light,
	wounds_template = WoundsTemplates.gauntlet_melee,
	stagger_duration_modifier = {
		0.1,
		0.5
	},
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1_25,
			[armor_types.armored] = damage_lerp_values.lerp_1_25,
			[armor_types.resistant] = damage_lerp_values.lerp_1_5,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_1,
			[armor_types.super_armor] = damage_lerp_values.lerp_0_2,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1_25,
			[armor_types.void_shield] = damage_lerp_values.lerp_0_75
		},
		impact = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_1,
			[armor_types.resistant] = damage_lerp_values.lerp_1,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_1,
			[armor_types.super_armor] = damage_lerp_values.lerp_1,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_75,
			[armor_types.void_shield] = damage_lerp_values.lerp_0_75
		}
	},
	targets = {
		{
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
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_1_25,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_1,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_2,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1_25,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_75
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_1,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_1,
					[armor_types.super_armor] = damage_lerp_values.lerp_1,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_75,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_75
				}
			}
		},
		{
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
					60,
					80
				}
			}
		}
	}
}
overrides.heavy_grenadier_gauntlet_smiter = {
	parent_template_name = "light_grenadier_gauntlet_smiter",
	overrides = {
		{
			"targets",
			1,
			"power_distribution",
			"attack",
			{
				130,
				250
			}
		},
		{
			"melee_attack_strength",
			melee_attack_strengths.heavy
		},
		{
			"targets",
			1,
			"armor_damage_modifier",
			"attack",
			"super_armor",
			damage_lerp_values.lerp_0_75
		}
	}
}
damage_templates.special_grenadier_gauntlet_tank = {
	stagger_override = "killshot",
	ragdoll_push_force = 800,
	ragdoll_only = true,
	ignore_stagger_reduction = true,
	stagger_category = "killshot",
	cleave_distribution = {
		attack = 0.01,
		impact = 0.01
	},
	damage_type = damage_types.blunt,
	gibbing_type = GibbingTypes.default,
	gibbing_power = GibbingPower.always,
	melee_attack_strength = melee_attack_strengths.heavy,
	targets = {
		{
			boost_curve_multiplier_finesse = 0.25,
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_1,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_5,
					[armor_types.super_armor] = damage_lerp_values.lerp_1,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1_5,
					[armor_types.void_shield] = damage_lerp_values.lerp_1_5
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_1,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_5,
					[armor_types.super_armor] = damage_lerp_values.lerp_1,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1_5,
					[armor_types.void_shield] = damage_lerp_values.lerp_1_5
				}
			},
			power_distribution = {
				attack = 50,
				impact = 50
			}
		},
		{
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = 0,
				impact = 50
			}
		},
		{
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = 0,
				impact = 25
			}
		},
		{
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = 0,
				impact = 15
			}
		},
		default_target = {
			boost_curve_multiplier_finesse = 0.25,
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.no_damage,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_5,
					[armor_types.super_armor] = damage_lerp_values.no_damage,
					[armor_types.disgustingly_resilient] = damage_lerp_values.no_damage,
					[armor_types.void_shield] = damage_lerp_values.no_damage
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_5,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_5,
					[armor_types.super_armor] = damage_lerp_values.no_damage,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_1
				}
			},
			power_distribution = {
				attack = 0,
				impact = 1
			},
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.default_gauntlet_bfg = {
	ignore_shield = true,
	suppression_value = 4,
	ragdoll_push_force = 750,
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
				[armor_types.resistant] = damage_lerp_values.lerp_0_75,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_1,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_75
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_1,
				[armor_types.resistant] = damage_lerp_values.lerp_1,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_1,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
				[armor_types.void_shield] = damage_lerp_values.lerp_1
			}
		},
		far = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_0_75,
				[armor_types.armored] = damage_lerp_values.lerp_0_5,
				[armor_types.resistant] = damage_lerp_values.lerp_1,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_1,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_2,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
				[armor_types.void_shield] = damage_lerp_values.lerp_1
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_1,
				[armor_types.resistant] = damage_lerp_values.lerp_1,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_1,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
				[armor_types.void_shield] = damage_lerp_values.lerp_1
			}
		}
	},
	power_distribution = {
		attack = {
			300,
			600
		},
		impact = {
			40,
			80
		}
	},
	damage_type = damage_types.blunt,
	gibbing_type = GibbingTypes.default,
	gibbing_power = GibbingPower.always,
	wounds_template = WoundsTemplates.bolter,
	on_kill_area_suppression = {
		distance = 8,
		suppression_value = 10
	},
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default,
			finesse_boost = {
				[armor_types.unarmored] = 0.75
			},
			boost_curve_multiplier_finesse = {
				0.2,
				0.4
			}
		}
	},
	gib_push_force = GibbingSettings.gib_push_force.explosive
}
damage_templates.default_gauntlet_demolitions = {
	stagger_category = "melee",
	suppression_value = 20,
	opt_in_stagger_duration_multiplier = true,
	ragdoll_push_force = 400,
	ignore_stagger_reduction = false,
	cleave_distribution = {
		attack = 0.15,
		impact = 0.15
	},
	armor_damage_modifier_ranged = {
		near = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_0_5,
				[armor_types.resistant] = damage_lerp_values.lerp_0_2,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_0_2,
				[armor_types.super_armor] = damage_lerp_values.no_damage,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_25,
				[armor_types.void_shield] = damage_lerp_values.no_damage
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
		},
		far = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_0_1,
				[armor_types.armored] = damage_lerp_values.lerp_0_1,
				[armor_types.resistant] = damage_lerp_values.lerp_0_1,
				[armor_types.player] = damage_lerp_values.lerp_0_1,
				[armor_types.berserker] = damage_lerp_values.lerp_0_1,
				[armor_types.super_armor] = damage_lerp_values.no_damage,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_1,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_1
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_0_5,
				[armor_types.armored] = damage_lerp_values.lerp_0_5,
				[armor_types.resistant] = damage_lerp_values.lerp_0_5,
				[armor_types.player] = damage_lerp_values.lerp_0_5,
				[armor_types.berserker] = damage_lerp_values.lerp_0_5,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_5,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_5
			}
		}
	},
	power_distribution_ranged = {
		attack = {
			near = {
				50,
				100
			},
			far = {
				10,
				20
			}
		},
		impact = {
			near = {
				25,
				50
			},
			far = {
				5,
				10
			}
		}
	},
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	},
	damage_type = damage_types.grenade_frag,
	gibbing_type = GibbingTypes.explosion,
	gibbing_power = GibbingPower.heavy,
	gib_push_force = GibbingSettings.gib_push_force.explosive
}
damage_templates.close_gauntlet_demolitions = {
	suppression_value = 20,
	ragdoll_push_force = 600,
	ignore_stagger_reduction = true,
	stagger_category = "melee",
	cleave_distribution = {
		attack = 0.15,
		impact = 0.15
	},
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_1_25,
			[armor_types.resistant] = damage_lerp_values.lerp_0_3,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_1,
			[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
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
	},
	power_distribution = {
		attack = {
			250,
			450
		},
		impact = {
			40,
			80
		}
	},
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	},
	damage_type = damage_types.grenade_frag,
	gibbing_type = GibbingTypes.explosion,
	gibbing_power = GibbingPower.heavy,
	wounds_template = WoundsTemplates.bolter,
	gib_push_force = GibbingSettings.gib_push_force.explosive,
	on_kill_area_suppression = {
		distance = 8,
		suppression_value = 10
	}
}
damage_templates.close_special_gauntlet_demolitions = {
	suppression_value = 20,
	ragdoll_push_force = 600,
	ignore_stagger_reduction = true,
	stagger_category = "melee",
	cleave_distribution = {
		attack = 0.15,
		impact = 0.15
	},
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_1_25,
			[armor_types.resistant] = damage_lerp_values.lerp_1,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_1,
			[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
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
	},
	power_distribution = {
		attack = {
			600,
			1000
		},
		impact = {
			30,
			60
		}
	},
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	},
	damage_type = damage_types.grenade_frag,
	gibbing_type = GibbingTypes.explosion,
	gibbing_power = GibbingPower.heavy,
	wounds_template = WoundsTemplates.bolter,
	gib_push_force = GibbingSettings.gib_push_force.explosive,
	on_kill_area_suppression = {
		distance = 8,
		suppression_value = 10
	}
}

return {
	base_templates = damage_templates,
	overrides = overrides
}
