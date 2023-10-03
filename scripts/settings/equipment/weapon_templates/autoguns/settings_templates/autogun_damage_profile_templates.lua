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

local damage_lerp_values = DamageProfileSettings.damage_lerp_values
local single_cleave = DamageProfileSettings.single_cleave
local double_cleave = DamageProfileSettings.double_cleave
local default_shield_override_stagger_strength = 4
damage_templates.default_autogun_assault = {
	stagger_category = "killshot",
	cleave_distribution = single_cleave,
	ranges = {
		min = {
			10,
			20
		},
		max = {
			25,
			50
		}
	},
	herding_template = HerdingTemplates.shot,
	armor_damage_modifier_ranged = {
		near = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_0_6,
				[armor_types.resistant] = damage_lerp_values.lerp_1,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_1,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_05,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
				[armor_types.void_shield] = damage_lerp_values.lerp_1,
				[armor_types.prop_armor] = damage_lerp_values.lerp_0_75
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_0_8,
				[armor_types.armored] = damage_lerp_values.lerp_1,
				[armor_types.resistant] = damage_lerp_values.lerp_0_75,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_0_5,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_1,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_4,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_4,
				[armor_types.prop_armor] = damage_lerp_values.lerp_1_5
			}
		},
		far = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_0_8,
				[armor_types.armored] = damage_lerp_values.lerp_0_5,
				[armor_types.resistant] = damage_lerp_values.lerp_0_8,
				[armor_types.player] = damage_lerp_values.lerp_0_5,
				[armor_types.berserker] = damage_lerp_values.lerp_0_8,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_05,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_8,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_8,
				[armor_types.prop_armor] = damage_lerp_values.lerp_0_3
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_0_6,
				[armor_types.armored] = damage_lerp_values.lerp_1,
				[armor_types.resistant] = damage_lerp_values.lerp_0_4,
				[armor_types.player] = damage_lerp_values.lerp_0_4,
				[armor_types.berserker] = damage_lerp_values.lerp_0_1,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_1,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_6,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_4,
				[armor_types.prop_armor] = damage_lerp_values.lerp_1_25
			}
		}
	},
	critical_strike = {
		gibbing_power = GibbingPower.light,
		gibbing_type = gibbing_types.ballistic
	},
	power_distribution = {
		attack = {
			60,
			120
		},
		impact = {
			2,
			6
		}
	},
	accumulative_stagger_strength_multiplier = {
		0.5,
		1
	},
	shield_override_stagger_strength = default_shield_override_stagger_strength,
	damage_type = damage_types.auto_bullet,
	gibbing_power = GibbingPower.always,
	gibbing_type = gibbing_types.ballistic,
	wounds_template = WoundsTemplates.autogun,
	suppression_value = {
		0.5,
		1.5
	},
	on_kill_area_suppression = {
		suppression_value = {
			1,
			2
		},
		distance = {
			3,
			5
		}
	},
	ragdoll_push_force = {
		200,
		300
	},
	gib_push_force = GibbingSettings.gib_push_force.ranged_light,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default,
			finesse_boost = {
				[armor_types.unarmored] = 0.75,
				[armor_types.resistant] = 0.2,
				[armor_types.armored] = 0.8
			},
			boost_curve_multiplier_finesse = damage_lerp_values.lerp_2
		}
	}
}
damage_templates.default_autogun_killshot = {
	suppression_value = 0.5,
	ragdoll_push_force = 250,
	stagger_category = "killshot",
	cleave_distribution = single_cleave,
	ranges = {
		min = {
			10,
			20
		},
		max = {
			10,
			50
		}
	},
	armor_damage_modifier_ranged = {
		near = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_0_8,
				[armor_types.armored] = damage_lerp_values.lerp_0_5,
				[armor_types.resistant] = damage_lerp_values.lerp_0_75,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_0_8,
				[armor_types.super_armor] = damage_lerp_values.no_damage,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_8,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
				[armor_types.prop_armor] = damage_lerp_values.lerp_0_5
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_1,
				[armor_types.resistant] = damage_lerp_values.lerp_0_25,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_0_5,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_25,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_75,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
				[armor_types.prop_armor] = damage_lerp_values.lerp_1
			}
		},
		far = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_0_65,
				[armor_types.resistant] = damage_lerp_values.lerp_0_8,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_0_5,
				[armor_types.super_armor] = damage_lerp_values.no_damage,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
				[armor_types.prop_armor] = damage_lerp_values.lerp_0_65
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_1,
				[armor_types.resistant] = damage_lerp_values.lerp_0_25,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_0_5,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_25,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_5,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
				[armor_types.prop_armor] = damage_lerp_values.lerp_1
			}
		}
	},
	critical_strike = {
		gibbing_power = GibbingPower.light,
		gibbing_type = gibbing_types.ballistic
	},
	power_distribution = {
		attack = {
			150,
			300
		},
		impact = {
			5,
			15
		}
	},
	shield_override_stagger_strength = default_shield_override_stagger_strength,
	damage_type = damage_types.auto_bullet,
	gibbing_power = GibbingPower.always,
	gibbing_type = gibbing_types.ballistic,
	wounds_template = WoundsTemplates.autogun,
	on_kill_area_suppression = {
		distance = 3,
		suppression_value = 1
	},
	gib_push_force = GibbingSettings.gib_push_force.ranged_light,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default,
			finesse_boost = {
				[armor_types.unarmored] = 0.75
			},
			boost_curve_multiplier_finesse = {
				1.5,
				2.5
			}
		}
	}
}
damage_templates.default_autogun_snp = {
	suppression_value = 2,
	ragdoll_push_force = 250,
	stagger_category = "ranged",
	cleave_distribution = single_cleave,
	ranges = {
		max = 30,
		min = 15
	},
	armor_damage_modifier_ranged = {
		near = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_0_75,
				[armor_types.resistant] = damage_lerp_values.lerp_1,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_1,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_05,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_8,
				[armor_types.void_shield] = damage_lerp_values.lerp_1,
				[armor_types.prop_armor] = damage_lerp_values.lerp_0_75
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_1,
				[armor_types.resistant] = damage_lerp_values.lerp_1,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_0_5,
				[armor_types.super_armor] = damage_lerp_values.no_damage,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
				[armor_types.void_shield] = damage_lerp_values.lerp_1,
				[armor_types.prop_armor] = damage_lerp_values.lerp_1
			}
		},
		far = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_0_8,
				[armor_types.armored] = damage_lerp_values.lerp_0_6,
				[armor_types.resistant] = damage_lerp_values.lerp_0_8,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_0_8,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_05,
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
				[armor_types.super_armor] = damage_lerp_values.no_damage,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
				[armor_types.void_shield] = damage_lerp_values.lerp_1,
				[armor_types.prop_armor] = damage_lerp_values.lerp_1
			}
		}
	},
	critical_strike = {
		gibbing_power = GibbingPower.light,
		gibbing_type = gibbing_types.ballistic
	},
	power_distribution = {
		attack = {
			30,
			110
		},
		impact = {
			2,
			8
		}
	},
	shield_override_stagger_strength = default_shield_override_stagger_strength,
	damage_type = damage_types.auto_bullet,
	gibbing_power = GibbingPower.always,
	gibbing_type = gibbing_types.ballistic,
	wounds_template = WoundsTemplates.autogun,
	on_kill_area_suppression = {
		distance = 3,
		suppression_value = 1
	},
	gib_push_force = GibbingSettings.gib_push_force.ranged_light,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.autogun_burst_shot = {
	suppression_value = 0.5,
	ragdoll_push_force = 250,
	stagger_category = "killshot",
	cleave_distribution = single_cleave,
	ranges = {
		min = {
			10,
			20
		},
		max = {
			10,
			50
		}
	},
	armor_damage_modifier_ranged = {
		near = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_0_8,
				[armor_types.armored] = damage_lerp_values.lerp_0_5,
				[armor_types.resistant] = damage_lerp_values.lerp_0_75,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_0_5,
				[armor_types.super_armor] = damage_lerp_values.no_damage,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_5,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
				[armor_types.prop_armor] = damage_lerp_values.lerp_0_5
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_1,
				[armor_types.resistant] = damage_lerp_values.lerp_0_25,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_0_5,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_25,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_75,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
				[armor_types.prop_armor] = damage_lerp_values.lerp_1
			}
		},
		far = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_0_65,
				[armor_types.resistant] = damage_lerp_values.lerp_0_8,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_0_5,
				[armor_types.super_armor] = damage_lerp_values.no_damage,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_75,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
				[armor_types.prop_armor] = damage_lerp_values.lerp_0_65
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_1,
				[armor_types.resistant] = damage_lerp_values.lerp_0_25,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_0_5,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_25,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_5,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
				[armor_types.prop_armor] = damage_lerp_values.lerp_1
			}
		}
	},
	critical_strike = {
		gibbing_power = GibbingPower.light,
		gibbing_type = gibbing_types.ballistic
	},
	power_distribution = {
		attack = {
			40,
			100
		},
		impact = {
			2,
			6
		}
	},
	shield_override_stagger_strength = default_shield_override_stagger_strength,
	damage_type = damage_types.auto_bullet,
	gibbing_power = GibbingPower.always,
	gibbing_type = gibbing_types.ballistic,
	wounds_template = WoundsTemplates.autogun,
	on_kill_area_suppression = {
		distance = 3,
		suppression_value = 1
	},
	gib_push_force = GibbingSettings.gib_push_force.ranged_light,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default,
			finesse_boost = {
				[armor_types.unarmored] = 0.75
			},
			boost_curve_multiplier_finesse = {
				1.5,
				2.5
			}
		}
	}
}
damage_templates.autogun_p3_burst_shot = {
	suppression_value = 1,
	ragdoll_push_force = 250,
	stagger_category = "killshot",
	cleave_distribution = single_cleave,
	ranges = {
		min = {
			10,
			20
		},
		max = {
			25,
			50
		}
	},
	armor_damage_modifier_ranged = {
		near = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_1,
				[armor_types.resistant] = damage_lerp_values.lerp_0_8,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_0_6,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_05,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
				[armor_types.prop_armor] = damage_lerp_values.lerp_0_5
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_1,
				[armor_types.resistant] = damage_lerp_values.lerp_0_25,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_0_5,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_25,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_75,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
				[armor_types.prop_armor] = damage_lerp_values.lerp_1
			}
		},
		far = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_0_8,
				[armor_types.armored] = damage_lerp_values.lerp_0_8,
				[armor_types.resistant] = damage_lerp_values.lerp_0_6,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_0_5,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_05,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_8,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
				[armor_types.prop_armor] = damage_lerp_values.lerp_0_65
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_1,
				[armor_types.resistant] = damage_lerp_values.lerp_0_25,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_0_5,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_25,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_5,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
				[armor_types.prop_armor] = damage_lerp_values.lerp_1
			}
		}
	},
	critical_strike = {
		gibbing_power = GibbingPower.light,
		gibbing_type = gibbing_types.ballistic
	},
	power_distribution = {
		attack = {
			40,
			100
		},
		impact = {
			2,
			6
		}
	},
	shield_override_stagger_strength = default_shield_override_stagger_strength,
	damage_type = damage_types.auto_bullet,
	gibbing_power = GibbingPower.always,
	gibbing_type = gibbing_types.ballistic,
	wounds_template = WoundsTemplates.autogun,
	on_kill_area_suppression = {
		distance = 3,
		suppression_value = 1
	},
	gib_push_force = GibbingSettings.gib_push_force.ranged_light,
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default,
			finesse_boost = {
				[armor_types.unarmored] = 0.75
			},
			boost_curve_multiplier_finesse = {
				1,
				2
			}
		}
	}
}
overrides.autogun_p2_m1 = {
	parent_template_name = "default_autogun_snp",
	overrides = {
		{
			"suppression_value",
			{
				3.5,
				6
			}
		},
		{
			"power_distribution",
			"attack",
			{
				70,
				140
			}
		},
		{
			"power_distribution",
			"impact",
			{
				5,
				10
			}
		},
		{
			"ragdoll_push_force",
			{
				200,
				250
			}
		}
	}
}
overrides.autogun_p2_m2 = {
	parent_template_name = "default_autogun_snp",
	overrides = {
		{
			"suppression_value",
			{
				2,
				4
			}
		},
		{
			"power_distribution",
			"attack",
			{
				60,
				120
			}
		},
		{
			"power_distribution",
			"impact",
			{
				3.5,
				7
			}
		},
		{
			"ragdoll_push_force",
			{
				175,
				225
			}
		}
	}
}
overrides.autogun_p2_m3 = {
	parent_template_name = "default_autogun_snp",
	overrides = {
		{
			"suppression_value",
			{
				4,
				8
			}
		},
		{
			"power_distribution",
			"attack",
			{
				100,
				200
			}
		},
		{
			"power_distribution",
			"impact",
			{
				10,
				20
			}
		},
		{
			"ragdoll_push_force",
			{
				200,
				250
			}
		},
		{
			"cleave_distribution",
			double_cleave
		}
	}
}
overrides.autogun_p3_m1 = {
	parent_template_name = "autogun_p3_burst_shot",
	overrides = {
		{
			"power_distribution",
			"attack",
			{
				80,
				160
			}
		},
		{
			"power_distribution",
			"impact",
			{
				5,
				10
			}
		},
		{
			"ragdoll_push_force",
			{
				200,
				250
			}
		},
		{
			"targets",
			"default_target",
			"boost_curve_multiplier_finesse",
			{
				1.5,
				3
			}
		}
	}
}
overrides.autogun_p3_m2 = {
	parent_template_name = "autogun_p3_burst_shot",
	overrides = {
		{
			"suppression_value",
			1.5
		},
		{
			"power_distribution",
			"attack",
			{
				100,
				200
			}
		},
		{
			"power_distribution",
			"impact",
			{
				6,
				14
			}
		},
		{
			"ragdoll_push_force",
			{
				200,
				250
			}
		},
		{
			"targets",
			"default_target",
			"boost_curve_multiplier_finesse",
			{
				1.5,
				3
			}
		}
	}
}
overrides.autogun_p3_m3 = {
	parent_template_name = "autogun_p3_burst_shot",
	overrides = {
		{
			"power_distribution",
			"attack",
			{
				90,
				180
			}
		},
		{
			"power_distribution",
			"impact",
			{
				14,
				16
			}
		},
		{
			"ragdoll_push_force",
			{
				200,
				250
			}
		},
		{
			"targets",
			"default_target",
			"boost_curve_multiplier_finesse",
			{
				1.5,
				3
			}
		}
	}
}
damage_templates.autogun_weapon_special_push = {
	is_push = true,
	stagger_category = "melee",
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = 0.8,
			[armor_types.armored] = 0.3,
			[armor_types.resistant] = 0.5,
			[armor_types.player] = 0,
			[armor_types.berserker] = 0.6,
			[armor_types.super_armor] = 0,
			[armor_types.disgustingly_resilient] = 1,
			[armor_types.void_shield] = 0.1,
			[armor_types.prop_armor] = 0
		},
		impact = {
			[armor_types.unarmored] = 1.25,
			[armor_types.armored] = 1,
			[armor_types.resistant] = 1,
			[armor_types.player] = 0,
			[armor_types.berserker] = 0.5,
			[armor_types.super_armor] = 0.5,
			[armor_types.disgustingly_resilient] = 1,
			[armor_types.void_shield] = 0,
			[armor_types.prop_armor] = 1
		}
	},
	gibbing_power = GibbingPower.always,
	gibbing_type = gibbing_types.default,
	targets = {
		default_target = {
			power_distribution = {
				attack = {
					25,
					35
				},
				impact = {
					10,
					20
				}
			}
		}
	}
}
damage_templates.autogun_weapon_special_bash = {
	is_push = true,
	stagger_category = "melee",
	ragdoll_push_force = 100,
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = 0.8,
			[armor_types.armored] = 0.3,
			[armor_types.resistant] = 0.5,
			[armor_types.player] = 0,
			[armor_types.berserker] = 0.6,
			[armor_types.super_armor] = 0,
			[armor_types.disgustingly_resilient] = 1,
			[armor_types.void_shield] = 0.1,
			[armor_types.prop_armor] = 0
		},
		impact = {
			[armor_types.unarmored] = 1.25,
			[armor_types.armored] = 1,
			[armor_types.resistant] = 1,
			[armor_types.player] = 0,
			[armor_types.berserker] = 0.5,
			[armor_types.super_armor] = 0.5,
			[armor_types.disgustingly_resilient] = 1,
			[armor_types.void_shield] = 0,
			[armor_types.prop_armor] = 1
		}
	},
	gibbing_power = GibbingPower.always,
	gibbing_type = gibbing_types.default,
	targets = {
		default_target = {
			power_distribution = {
				attack = {
					25,
					75
				},
				impact = {
					3,
					7
				}
			}
		}
	}
}
overrides.autogun_weapon_special_bash_heavy = {
	parent_template_name = "autogun_weapon_special_bash",
	overrides = {
		{
			"targets",
			"default_target",
			"power_distribution",
			"attack",
			{
				50,
				150
			}
		},
		{
			"targets",
			"default_target",
			"power_distribution",
			"impact",
			{
				5,
				15
			}
		}
	}
}

return {
	base_templates = damage_templates,
	overrides = overrides
}
