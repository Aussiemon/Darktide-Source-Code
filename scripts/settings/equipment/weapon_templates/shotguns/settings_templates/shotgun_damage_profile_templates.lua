local ArmorSettings = require("scripts/settings/damage/armor_settings")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local DamageProfileSettings = require("scripts/settings/damage/damage_profile_settings")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local GibbingSettings = require("scripts/settings/gibbing/gibbing_settings")
local GibbingPower = GibbingSettings.gibbing_power
local gibbing_types = GibbingSettings.gibbing_types
local HerdingTemplates = require("scripts/settings/damage/herding_templates")
local WoundsTemplates = require("scripts/settings/damage/wounds_templates")
local damage_types = DamageSettings.damage_types
local armor_types = ArmorSettings.types
local damage_templates = {}
local overrides = {}

table.make_unique(damage_templates)
table.make_unique(overrides)

local crit_armor_mod = DamageProfileSettings.crit_armor_mod
local crit_impact_armor_mod = DamageProfileSettings.crit_impact_armor_mod
local damage_lerp_values = DamageProfileSettings.damage_lerp_values
local single_cleave = DamageProfileSettings.single_cleave
local double_cleave = DamageProfileSettings.double_cleave
damage_templates.default_shotgun_killshot = {
	ragdoll_only = true,
	stagger_category = "melee",
	ignore_stagger_reduction = true,
	cleave_distribution = {
		attack = 0.01,
		impact = 0.01
	},
	ranges = {
		min = {
			6,
			14
		},
		max = {
			20,
			40
		}
	},
	herding_template = HerdingTemplates.shotgun,
	armor_damage_modifier_ranged = {
		near = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_0_75,
				[armor_types.resistant] = damage_lerp_values.lerp_0_8,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_0_9,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_05,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
				[armor_types.void_shield] = damage_lerp_values.lerp_1,
				[armor_types.prop_armor] = damage_lerp_values.lerp_0_5
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_1_5,
				[armor_types.resistant] = damage_lerp_values.lerp_0_75,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_1,
				[armor_types.super_armor] = damage_lerp_values.lerp_1,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_2,
				[armor_types.void_shield] = damage_lerp_values.lerp_2,
				[armor_types.prop_armor] = damage_lerp_values.lerp_1_5
			}
		},
		far = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_0_5,
				[armor_types.armored] = damage_lerp_values.lerp_0_5,
				[armor_types.resistant] = damage_lerp_values.lerp_0_5,
				[armor_types.player] = damage_lerp_values.lerp_0_1,
				[armor_types.berserker] = damage_lerp_values.lerp_0_5,
				[armor_types.super_armor] = damage_lerp_values.no_damage,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_5,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_4,
				[armor_types.prop_armor] = damage_lerp_values.lerp_0_3
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_0_75,
				[armor_types.armored] = damage_lerp_values.lerp_0_75,
				[armor_types.resistant] = damage_lerp_values.lerp_0_5,
				[armor_types.player] = damage_lerp_values.no_damage,
				[armor_types.berserker] = damage_lerp_values.lerp_0_5,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_5,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
				[armor_types.prop_armor] = damage_lerp_values.lerp_0_75
			}
		}
	},
	critical_strike = {
		gibbing_power = GibbingPower.heavy,
		gibbing_type = gibbing_types.ballistic
	},
	power_distribution = {
		attack = {
			250,
			400
		},
		impact = {
			20,
			40
		}
	},
	damage_type = damage_types.pellet,
	gibbing_power = GibbingPower.medium,
	gibbing_type = gibbing_types.ballistic,
	suppression_value = {
		0.25,
		0.75
	},
	wounds_template = WoundsTemplates.shotgun,
	on_kill_area_suppression = {
		suppression_value = {
			1,
			3
		},
		distance = {
			2,
			4
		}
	},
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default,
			finesse_boost = {
				[armor_types.unarmored] = 0.75
			},
			boost_curve_multiplier_finesse = {
				0.8,
				1.6
			}
		}
	},
	ragdoll_push_force = {
		50,
		50
	},
	gib_push_force = GibbingSettings.gib_push_force.ranged_medium
}
damage_templates.default_shotgun_assault = {
	ragdoll_only = true,
	stagger_category = "ranged",
	ignore_stagger_reduction = true,
	cleave_distribution = {
		attack = 1.3,
		impact = 0.01
	},
	ranges = {
		min = {
			6,
			14
		},
		max = {
			15,
			25
		}
	},
	herding_template = HerdingTemplates.shotgun,
	armor_damage_modifier_ranged = {
		near = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_0_75,
				[armor_types.resistant] = damage_lerp_values.lerp_0_8,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_0_9,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_05,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
				[armor_types.void_shield] = damage_lerp_values.lerp_1,
				[armor_types.prop_armor] = damage_lerp_values.lerp_0_5
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_1,
				[armor_types.resistant] = damage_lerp_values.lerp_0_75,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_1,
				[armor_types.super_armor] = damage_lerp_values.lerp_1,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
				[armor_types.void_shield] = damage_lerp_values.lerp_1,
				[armor_types.prop_armor] = damage_lerp_values.lerp_1
			}
		},
		far = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_0_5,
				[armor_types.armored] = damage_lerp_values.lerp_0_5,
				[armor_types.resistant] = damage_lerp_values.lerp_0_5,
				[armor_types.player] = damage_lerp_values.lerp_0_1,
				[armor_types.berserker] = damage_lerp_values.lerp_0_5,
				[armor_types.super_armor] = damage_lerp_values.no_damage,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_5,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_4,
				[armor_types.prop_armor] = damage_lerp_values.lerp_0_3
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_0_75,
				[armor_types.armored] = damage_lerp_values.lerp_0_75,
				[armor_types.resistant] = damage_lerp_values.lerp_0_5,
				[armor_types.player] = damage_lerp_values.no_damage,
				[armor_types.berserker] = damage_lerp_values.lerp_0_5,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_5,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
				[armor_types.prop_armor] = damage_lerp_values.lerp_0_75
			}
		}
	},
	critical_strike = {
		gibbing_power = GibbingPower.heavy,
		gibbing_type = gibbing_types.ballistic
	},
	power_distribution = {
		attack = {
			250,
			400
		},
		impact = {
			20,
			40
		}
	},
	damage_type = damage_types.pellet,
	gibbing_power = GibbingPower.medium,
	gibbing_type = gibbing_types.ballistic,
	suppression_value = {
		0.25,
		0.75
	},
	wounds_template = WoundsTemplates.shotgun,
	on_kill_area_suppression = {
		suppression_value = {
			1,
			3
		},
		distance = {
			2,
			4
		}
	},
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default,
			finesse_boost = {
				[armor_types.unarmored] = 0.75
			},
			boost_curve_multiplier_finesse = {
				0.25,
				0.75
			}
		}
	},
	ragdoll_push_force = {
		50,
		50
	},
	gib_push_force = GibbingSettings.gib_push_force.ranged_medium
}
damage_templates.shotgun_cleaving_special = {
	ragdoll_only = true,
	stagger_category = "melee",
	ignore_stagger_reduction = true,
	cleave_distribution = double_cleave,
	ranges = {
		min = {
			6,
			14
		},
		max = {
			20,
			40
		}
	},
	herding_template = HerdingTemplates.shotgun,
	armor_damage_modifier_ranged = {
		near = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_0_75,
				[armor_types.resistant] = damage_lerp_values.lerp_0_8,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_0_9,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_05,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
				[armor_types.void_shield] = damage_lerp_values.lerp_1,
				[armor_types.prop_armor] = damage_lerp_values.lerp_0_5
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_1_5,
				[armor_types.resistant] = damage_lerp_values.lerp_0_75,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_1,
				[armor_types.super_armor] = damage_lerp_values.lerp_1,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_2,
				[armor_types.void_shield] = damage_lerp_values.lerp_2,
				[armor_types.prop_armor] = damage_lerp_values.lerp_1_5
			}
		},
		far = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_0_5,
				[armor_types.armored] = damage_lerp_values.lerp_0_5,
				[armor_types.resistant] = damage_lerp_values.lerp_0_5,
				[armor_types.player] = damage_lerp_values.lerp_0_1,
				[armor_types.berserker] = damage_lerp_values.lerp_0_5,
				[armor_types.super_armor] = damage_lerp_values.no_damage,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_5,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_4,
				[armor_types.prop_armor] = damage_lerp_values.lerp_0_3
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_0_75,
				[armor_types.armored] = damage_lerp_values.lerp_0_75,
				[armor_types.resistant] = damage_lerp_values.lerp_0_5,
				[armor_types.player] = damage_lerp_values.no_damage,
				[armor_types.berserker] = damage_lerp_values.lerp_0_5,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_5,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
				[armor_types.prop_armor] = damage_lerp_values.lerp_0_75
			}
		}
	},
	critical_strike = {
		gibbing_power = GibbingPower.heavy,
		gibbing_type = gibbing_types.ballistic
	},
	power_distribution = {
		attack = {
			250,
			400
		},
		impact = {
			40,
			80
		}
	},
	damage_type = damage_types.pellet,
	gibbing_power = GibbingPower.heavy,
	gibbing_type = gibbing_types.ballistic,
	suppression_value = {
		0.25,
		0.75
	},
	wounds_template = WoundsTemplates.shotgun,
	on_kill_area_suppression = {
		suppression_value = {
			1,
			3
		},
		distance = {
			2,
			4
		}
	},
	targets = {
		{
			power_distribution = {
				attack = {
					250,
					400
				},
				impact = {
					20,
					40
				}
			}
		},
		default_target = {
			power_distribution = {
				attack = {
					50,
					100
				},
				impact = {
					5,
					10
				}
			},
			boost_curve = PowerLevelSettings.boost_curves.default,
			finesse_boost = {
				[armor_types.unarmored] = 0.75
			},
			boost_curve_multiplier_finesse = {
				0.8,
				1.6
			}
		}
	},
	ragdoll_push_force = {
		50,
		50
	},
	gib_push_force = GibbingSettings.gib_push_force.ranged_medium
}
overrides.shotgun_assault_burninating = {
	parent_template_name = "default_shotgun_assault",
	overrides = {
		{
			"power_distribution",
			"attack",
			1,
			50
		},
		{
			"power_distribution",
			"attack",
			2,
			100
		}
	}
}
damage_templates.shotgun_slug_special = {
	ignore_stagger_reduction = true,
	ragdoll_only = true,
	stagger_category = "melee",
	shield_override_stagger_strength = 250,
	cleave_distribution = double_cleave,
	ranges = {
		min = {
			10,
			20
		},
		max = {
			25,
			35
		}
	},
	herding_template = HerdingTemplates.shotgun,
	armor_damage_modifier_ranged = {
		near = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_0_75,
				[armor_types.resistant] = damage_lerp_values.lerp_0_8,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_0_9,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_05,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
				[armor_types.void_shield] = damage_lerp_values.lerp_1,
				[armor_types.prop_armor] = damage_lerp_values.lerp_0_5
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_1_5,
				[armor_types.resistant] = damage_lerp_values.lerp_0_75,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_1,
				[armor_types.super_armor] = damage_lerp_values.lerp_1,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_2,
				[armor_types.void_shield] = damage_lerp_values.lerp_2,
				[armor_types.prop_armor] = damage_lerp_values.lerp_1_5
			}
		},
		far = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_0_5,
				[armor_types.armored] = damage_lerp_values.lerp_0_5,
				[armor_types.resistant] = damage_lerp_values.lerp_0_5,
				[armor_types.player] = damage_lerp_values.lerp_0_1,
				[armor_types.berserker] = damage_lerp_values.lerp_0_5,
				[armor_types.super_armor] = damage_lerp_values.no_damage,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_5,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_4,
				[armor_types.prop_armor] = damage_lerp_values.lerp_0_3
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_0_75,
				[armor_types.armored] = damage_lerp_values.lerp_0_75,
				[armor_types.resistant] = damage_lerp_values.lerp_0_5,
				[armor_types.player] = damage_lerp_values.no_damage,
				[armor_types.berserker] = damage_lerp_values.lerp_0_5,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_5,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
				[armor_types.prop_armor] = damage_lerp_values.lerp_0_75
			}
		}
	},
	critical_strike = {
		gibbing_power = GibbingPower.heavy,
		gibbing_type = gibbing_types.ballistic
	},
	power_distribution = {
		attack = {
			300,
			400
		},
		impact = {
			80,
			100
		}
	},
	damage_type = damage_types.pellet,
	gibbing_power = GibbingPower.heavy,
	gibbing_type = gibbing_types.ballistic,
	suppression_value = {
		3.5,
		4.5
	},
	wounds_template = WoundsTemplates.shotgun,
	on_kill_area_suppression = {
		suppression_value = {
			10,
			15
		},
		distance = {
			6,
			8
		}
	},
	targets = {
		default_target = {
			power_distribution = {
				attack = {
					300,
					400
				},
				impact = {
					50,
					50
				}
			},
			boost_curve = PowerLevelSettings.boost_curves.default,
			finesse_boost = {
				[armor_types.unarmored] = 0.75
			},
			boost_curve_multiplier_finesse = {
				0.8,
				1.6
			}
		}
	},
	ragdoll_push_force = {
		50,
		50
	},
	gib_push_force = GibbingSettings.gib_push_force.ranged_medium
}
overrides.shotgun_p1_m2_assault = {
	parent_template_name = "default_shotgun_assault",
	overrides = {
		{
			"suppression_value",
			{
				0.15,
				0.45
			}
		},
		{
			"power_distribution",
			"attack",
			{
				150,
				240
			}
		},
		{
			"power_distribution",
			"impact",
			{
				12,
				24
			}
		},
		{
			"ranges",
			{
				min = {
					6,
					14
				},
				max = {
					18.75,
					31.25
				}
			}
		}
	}
}
overrides.shotgun_p1_m3_assault = {
	parent_template_name = "default_shotgun_assault",
	overrides = {
		{
			"suppression_value",
			{
				0.325,
				0.975
			}
		},
		{
			"power_distribution",
			"attack",
			{
				325,
				520
			}
		},
		{
			"power_distribution",
			"impact",
			{
				26,
				52
			}
		},
		{
			"ranges",
			{
				min = {
					6,
					14
				},
				max = {
					11.25,
					18.75
				}
			}
		},
		{
			"armor_damage_modifier_ranged",
			"far",
			{
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_0_3,
					[armor_types.armored] = damage_lerp_values.lerp_0_3,
					[armor_types.resistant] = damage_lerp_values.lerp_0_3,
					[armor_types.player] = damage_lerp_values.lerp_0_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_3,
					[armor_types.super_armor] = damage_lerp_values.no_damage,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_3,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_3,
					[armor_types.prop_armor] = damage_lerp_values.lerp_0_2
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_0_5,
					[armor_types.armored] = damage_lerp_values.lerp_0_5,
					[armor_types.resistant] = damage_lerp_values.lerp_0_3,
					[armor_types.player] = damage_lerp_values.no_damage,
					[armor_types.berserker] = damage_lerp_values.lerp_0_3,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_3,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_3,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_3,
					[armor_types.prop_armor] = damage_lerp_values.lerp_0_5
				}
			}
		}
	}
}
overrides.shotgun_p1_m2_killshot = {
	parent_template_name = "default_shotgun_killshot",
	overrides = {
		{
			"suppression_value",
			{
				0.15,
				0.45
			}
		},
		{
			"power_distribution",
			"attack",
			{
				150,
				240
			}
		},
		{
			"power_distribution",
			"impact",
			{
				12,
				24
			}
		},
		{
			"ranges",
			{
				min = {
					6,
					14
				},
				max = {
					18.75,
					31.25
				}
			}
		}
	}
}
overrides.shotgun_p1_m3_killshot = {
	parent_template_name = "default_shotgun_killshot",
	overrides = {
		{
			"suppression_value",
			{
				0.325,
				0.975
			}
		},
		{
			"power_distribution",
			"attack",
			{
				325,
				520
			}
		},
		{
			"power_distribution",
			"impact",
			{
				26,
				52
			}
		},
		{
			"ranges",
			{
				min = {
					6,
					14
				},
				max = {
					11.25,
					18.75
				}
			}
		},
		{
			"armor_damage_modifier_ranged",
			"far",
			{
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_0_3,
					[armor_types.armored] = damage_lerp_values.lerp_0_3,
					[armor_types.resistant] = damage_lerp_values.lerp_0_3,
					[armor_types.player] = damage_lerp_values.lerp_0_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_3,
					[armor_types.super_armor] = damage_lerp_values.no_damage,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_3,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_3,
					[armor_types.prop_armor] = damage_lerp_values.lerp_0_2
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_0_5,
					[armor_types.armored] = damage_lerp_values.lerp_0_5,
					[armor_types.resistant] = damage_lerp_values.lerp_0_3,
					[armor_types.player] = damage_lerp_values.no_damage,
					[armor_types.berserker] = damage_lerp_values.lerp_0_3,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_3,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_3,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_3,
					[armor_types.prop_armor] = damage_lerp_values.lerp_0_5
				}
			}
		}
	}
}

return {
	base_templates = damage_templates,
	overrides = overrides
}
