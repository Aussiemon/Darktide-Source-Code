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
damage_templates.ogryn_powermaul_light_smiter = {
	ragdoll_push_force = 200,
	ragdoll_only = true,
	stagger_category = "melee",
	cleave_distribution = single_cleave,
	gibbing_power = GibbingPower.light,
	gibbing_type = GibbingTypes.crushing,
	melee_attack_strength = melee_attack_strengths.light,
	armor_damage_modifier = smiter_light_default_am,
	targets = {
		{
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = {
					110,
					150
				},
				impact = {
					15,
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
					15,
					20
				}
			}
		},
		default_target = {
			power_distribution = {
				impact = 20,
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
			"stagger_duration_modifier",
			{
				0.1,
				0.5
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
				120,
				200
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
damage_templates.ogryn_powermaul_light_linesman = {
	ragdoll_push_force = 400,
	ragdoll_only = true,
	stagger_category = "melee",
	cleave_distribution = double_cleave,
	damage_type = damage_types.ogryn_pipe_club_heavy,
	gibbing_power = GibbingPower.light,
	gibbing_type = GibbingTypes.crushing,
	melee_attack_strength = melee_attack_strengths.light,
	armor_damage_modifier = linesman_light_default_am,
	targets = {
		{
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = {
					105,
					135
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
				attack = 70,
				impact = 0.3
			}
		},
		{
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = 10,
				impact = 7
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
			"armor_damage_modifier",
			light_active_am
		},
		{
			"targets",
			1,
			"power_distribution",
			"attack",
			{
				120,
				200
			}
		},
		{
			"targets",
			1,
			"power_distribution",
			"impact",
			{
				100,
				200
			}
		}
	}
}
damage_templates.ogryn_powermaul_heavy_tank = {
	ragdoll_push_force = 800,
	ragdoll_only = true,
	stagger_category = "melee",
	cleave_distribution = big_cleave,
	damage_type = damage_types.ogryn_pipe_club_heavy,
	gibbing_power = GibbingPower.medium,
	gibbing_type = GibbingTypes.crushing,
	melee_attack_strength = melee_attack_strengths.heavy,
	armor_damage_modifier = tank_heavy_default_am,
	targets = {
		{
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = {
					120,
					150
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
					100
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
		default_target = {
			boost_curve_multiplier_finesse = 0.25,
			armor_damage_modifier = tank_heavy_default_am,
			power_distribution = {
				attack = {
					0,
					0
				},
				impact = {
					15,
					20
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
				0.1,
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
				150,
				220
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
damage_templates.powermaul_explosion = {
	ignore_shield = true,
	suppression_type = "ability",
	stagger_duration_modifier = 1,
	ignore_stagger_reduction = true,
	stagger_category = "explosion",
	power_distribution = {
		attack = 0,
		impact = 50
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
	damage_type = damage_types.kinetic,
	targets = {
		default_target = {}
	}
}
overrides.powermaul_explosion_outer = {
	parent_template_name = "powermaul_explosion",
	overrides = {
		{
			"power_distribution",
			"attack",
			15
		},
		{
			"power_distribution",
			"impact",
			20
		}
	}
}

return {
	base_templates = damage_templates,
	overrides = overrides
}
