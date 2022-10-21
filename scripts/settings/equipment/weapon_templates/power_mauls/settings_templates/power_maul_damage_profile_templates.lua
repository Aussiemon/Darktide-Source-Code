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
local big_cleave = DamageProfileSettings.big_cleave
local smiter_light_default_am = {
	attack = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1,
		[armor_types.armored] = damage_lerp_values.lerp_1,
		[armor_types.resistant] = damage_lerp_values.lerp_1,
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
		[armor_types.berserker] = damage_lerp_values.lerp_0_5,
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
		[armor_types.resistant] = damage_lerp_values.lerp_1,
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
		[armor_types.berserker] = damage_lerp_values.lerp_0_5,
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
		[armor_types.unarmored] = damage_lerp_values.lerp_1_5,
		[armor_types.armored] = damage_lerp_values.lerp_1_5,
		[armor_types.resistant] = {
			1.2,
			1.8
		},
		[armor_types.player] = damage_lerp_values.no_damage,
		[armor_types.berserker] = damage_lerp_values.lerp_1_5,
		[armor_types.super_armor] = damage_lerp_values.lerp_1_5,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1_5,
		[armor_types.void_shield] = damage_lerp_values.lerp_1_5,
		[armor_types.prop_armor] = damage_lerp_values.lerp_2
	},
	impact = {
		[armor_types.unarmored] = damage_lerp_values.lerp_2,
		[armor_types.armored] = damage_lerp_values.lerp_2,
		[armor_types.resistant] = {
			15,
			25
		},
		[armor_types.player] = damage_lerp_values.no_damage,
		[armor_types.berserker] = damage_lerp_values.lerp_2,
		[armor_types.super_armor] = damage_lerp_values.lerp_2,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_2,
		[armor_types.void_shield] = damage_lerp_values.lerp_2,
		[armor_types.prop_armor] = damage_lerp_values.lerp_2
	}
}
local tank_heavy_active_am = {
	attack = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1_5,
		[armor_types.armored] = damage_lerp_values.lerp_1_5,
		[armor_types.resistant] = {
			1.5,
			2
		},
		[armor_types.player] = damage_lerp_values.no_damage,
		[armor_types.berserker] = damage_lerp_values.lerp_1_5,
		[armor_types.super_armor] = damage_lerp_values.lerp_1_5,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1_5,
		[armor_types.void_shield] = damage_lerp_values.lerp_1_5,
		[armor_types.prop_armor] = damage_lerp_values.lerp_2
	},
	impact = {
		[armor_types.unarmored] = damage_lerp_values.lerp_2,
		[armor_types.armored] = damage_lerp_values.lerp_2,
		[armor_types.resistant] = {
			15,
			25
		},
		[armor_types.player] = damage_lerp_values.no_damage,
		[armor_types.berserker] = damage_lerp_values.lerp_2,
		[armor_types.super_armor] = damage_lerp_values.lerp_2,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_2,
		[armor_types.void_shield] = damage_lerp_values.lerp_2,
		[armor_types.prop_armor] = damage_lerp_values.lerp_2
	}
}
damage_templates.powermaul_light_smiter = {
	ragdoll_only = true,
	ragdoll_push_force = 100,
	stagger_category = "melee",
	cleave_distribution = single_cleave,
	damage_type = damage_types.spiked_blunt,
	gibbing_power = GibbingPower.light,
	gibbing_type = GibbingTypes.crushing,
	melee_attack_strength = melee_attack_strengths.light,
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
					50,
					90
				},
				impact = {
					5,
					9
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
					30,
					50
				},
				impact = {
					7,
					10
				}
			}
		},
		default_target = {
			power_distribution = {
				impact = 5,
				attack = {
					20,
					40
				}
			}
		}
	}
}
damage_templates.powermaul_light_linesman = {
	ragdoll_push_force = 200,
	ragdoll_only = true,
	stagger_category = "melee",
	cleave_distribution = double_cleave,
	damage_type = damage_types.spiked_blunt,
	gibbing_power = GibbingPower.light,
	gibbing_type = GibbingTypes.crushing,
	melee_attack_strength = melee_attack_strengths.light,
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
					0,
					0
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
damage_templates.powermaul_heavy_tank = {
	ragdoll_push_force = 300,
	ragdoll_only = true,
	stagger_category = "melee",
	cleave_distribution = big_cleave,
	damage_type = damage_types.spiked_blunt,
	gibbing_power = GibbingPower.medium,
	gibbing_type = GibbingTypes.crushing,
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
					60,
					120
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
					30,
					60
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
damage_templates.powermaul_light_tank = {
	ragdoll_push_force = 150,
	ragdoll_only = true,
	stagger_category = "melee",
	cleave_distribution = big_cleave,
	damage_type = damage_types.spiked_blunt,
	gibbing_power = GibbingPower.light,
	gibbing_type = GibbingTypes.crushing,
	melee_attack_strength = melee_attack_strengths.light,
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
					30,
					70
				},
				impact = {
					7,
					10
				}
			}
		},
		{
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = {
					20,
					45
				},
				impact = {
					6,
					9
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
					8
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
					8
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

return {
	base_templates = damage_templates,
	overrides = overrides
}
