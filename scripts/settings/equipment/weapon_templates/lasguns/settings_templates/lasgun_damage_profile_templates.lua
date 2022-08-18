local ArmorSettings = require("scripts/settings/damage/armor_settings")
local DamageProfileSettings = require("scripts/settings/damage/damage_profile_settings")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local GibbingSettings = require("scripts/settings/gibbing/gibbing_settings")
local HerdingTemplates = require("scripts/settings/damage/herding_templates")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local WoundsTemplates = require("scripts/settings/damage/wounds_templates")
local armor_types = ArmorSettings.types
local damage_types = DamageSettings.damage_types
local gibbing_power = GibbingSettings.gibbing_power
local gibbing_types = GibbingSettings.gibbing_types
local damage_templates = {}
local overrides = {}

table.make_unique(damage_templates)
table.make_unique(overrides)

local crit_armor_mod = DamageProfileSettings.crit_armor_mod
local crit_impact_armor_mod = DamageProfileSettings.crit_impact_armor_mod
local damage_lerp_values = DamageProfileSettings.damage_lerp_values
local single_cleave = DamageProfileSettings.single_cleave
local no_cleave = DamageProfileSettings.single_cleave
local double_cleave = DamageProfileSettings.double_cleave
local medium_cleave = DamageProfileSettings.medium_cleave
local big_cleave = DamageProfileSettings.big_cleave
local lasgun_armor_mod_default = {
	near = {
		attack = {
			[armor_types.unarmored] = damage_lerp_values.lerp_0_8,
			[armor_types.armored] = damage_lerp_values.lerp_0_8,
			[armor_types.resistant] = damage_lerp_values.lerp_0_4,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_1,
			[armor_types.super_armor] = damage_lerp_values.lerp_0_01,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_8,
			[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
			[armor_types.prop_armor] = damage_lerp_values.lerp_0_75
		},
		impact = {
			[armor_types.unarmored] = damage_lerp_values.lerp_0_6,
			[armor_types.armored] = damage_lerp_values.lerp_0_5,
			[armor_types.resistant] = damage_lerp_values.lerp_0_75,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_0_5,
			[armor_types.super_armor] = damage_lerp_values.no_damage,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_25,
			[armor_types.void_shield] = damage_lerp_values.lerp_0_25,
			[armor_types.prop_armor] = damage_lerp_values.lerp_0_25
		}
	},
	far = {
		attack = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_1,
			[armor_types.resistant] = damage_lerp_values.lerp_0_5,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_1_5,
			[armor_types.super_armor] = damage_lerp_values.lerp_0_01,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
			[armor_types.void_shield] = damage_lerp_values.lerp_0_6,
			[armor_types.prop_armor] = damage_lerp_values.lerp_1
		},
		impact = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_1,
			[armor_types.resistant] = damage_lerp_values.lerp_0_5,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_0_5,
			[armor_types.super_armor] = damage_lerp_values.no_damage,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
			[armor_types.void_shield] = damage_lerp_values.lerp_0_8,
			[armor_types.prop_armor] = damage_lerp_values.lerp_0_6
		}
	}
}
damage_templates.default_lasgun_killshot = {
	crit_boost = 0.25,
	staggering_headshot = true,
	stagger_category = "killshot",
	cleave_distribution = no_cleave,
	ranges = {
		max = 15,
		min = 7
	},
	herding_template = HerdingTemplates.shot,
	wounds_template = WoundsTemplates.lasgun,
	armor_damage_modifier_ranged = lasgun_armor_mod_default,
	critical_strike = {
		gibbing_power = gibbing_power.light,
		gibbing_type = gibbing_types.laser
	},
	power_distribution = {
		attack = {
			50,
			125
		},
		impact = {
			4,
			12
		}
	},
	gibbing_power = gibbing_power.light,
	gibbing_type = gibbing_types.laser,
	suppression_value = {
		0.4,
		0.6
	},
	on_kill_area_suppression = {
		suppression_value = {
			0.4,
			0.6
		},
		distance = {
			2,
			3
		}
	},
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default,
			finesse_boost = {
				[armor_types.armored] = 0.75,
				[armor_types.super_armor] = 0.1,
				[armor_types.berserker] = 0.25,
				[armor_types.resistant] = 0.25
			},
			boost_curve_multiplier_finesse = damage_lerp_values.lerp_2
		}
	},
	ragdoll_push_force = {
		150,
		250
	}
}
overrides.lasgun_p1_m1_killshot = {
	parent_template_name = "default_lasgun_killshot",
	overrides = {
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
				4,
				10
			}
		},
		{
			"armor_damage_modifier_ranged",
			"near",
			"attack",
			"resistant",
			damage_lerp_values.lerp_0_5
		},
		{
			"armor_damage_modifier_ranged",
			"far",
			"attack",
			"resistant",
			damage_lerp_values.lerp_0_6
		}
	}
}
overrides.lasgun_p1_m2_killshot = {
	parent_template_name = "default_lasgun_killshot",
	overrides = {
		{
			"suppression_value",
			{
				0.5,
				1
			}
		},
		{
			"power_distribution",
			"attack",
			{
				50,
				125
			}
		},
		{
			"power_distribution",
			"impact",
			{
				3,
				6
			}
		}
	}
}
overrides.lasgun_p1_m3_killshot = {
	parent_template_name = "default_lasgun_killshot",
	overrides = {
		{
			"suppression_value",
			{
				2.5,
				5
			}
		},
		{
			"power_distribution",
			"attack",
			{
				175,
				350
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
				250,
				350
			}
		},
		{
			"armor_damage_modifier_ranged",
			"near",
			"attack",
			"resistant",
			damage_lerp_values.lerp_0_8
		},
		{
			"armor_damage_modifier_ranged",
			"far",
			"attack",
			"resistant",
			damage_lerp_values.lerp_1
		}
	}
}
damage_templates.default_lasgun_assault = {
	suppression_value = 0.5,
	ragdoll_push_force = 5000,
	stagger_category = "ranged",
	cleave_distribution = single_cleave,
	ranges = {
		max = 15,
		min = 8
	},
	herding_template = HerdingTemplates.shot,
	wounds_template = WoundsTemplates.lasgun,
	armor_damage_modifier_ranged = {
		near = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_0_25,
				[armor_types.resistant] = damage_lerp_values.lerp_1,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_0_5,
				[armor_types.super_armor] = damage_lerp_values.no_damage,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_75,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
				[armor_types.prop_armor] = damage_lerp_values.lerp_0_25
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.no_damage,
				[armor_types.resistant] = damage_lerp_values.lerp_1,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_0_5,
				[armor_types.super_armor] = damage_lerp_values.no_damage,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_75,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
				[armor_types.prop_armor] = damage_lerp_values.no_damage
			}
		},
		far = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_0_75,
				[armor_types.armored] = damage_lerp_values.lerp_0_1,
				[armor_types.resistant] = damage_lerp_values.lerp_0_5,
				[armor_types.player] = damage_lerp_values.lerp_0_5,
				[armor_types.berserker] = damage_lerp_values.lerp_0_5,
				[armor_types.super_armor] = damage_lerp_values.no_damage,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_5,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
				[armor_types.prop_armor] = damage_lerp_values.lerp_0_1
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_0_25,
				[armor_types.armored] = damage_lerp_values.lerp_2,
				[armor_types.resistant] = damage_lerp_values.lerp_0_35,
				[armor_types.player] = damage_lerp_values.lerp_0_35,
				[armor_types.berserker] = damage_lerp_values.lerp_0_1,
				[armor_types.super_armor] = damage_lerp_values.no_damage,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_5,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
				[armor_types.prop_armor] = damage_lerp_values.lerp_2
			}
		}
	},
	critical_strike = {
		gibbing_power = gibbing_power.medium,
		gibbing_type = gibbing_types.laser
	},
	power_distribution = {
		attack = 30,
		impact = 10
	},
	damage_type = damage_types.laser,
	gibbing_power = gibbing_power.medium,
	gibbing_type = gibbing_types.laser,
	on_kill_area_suppression = {
		distance = 3,
		suppression_value = 1
	},
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.default_lasgun_snp = {
	suppression_value = 1,
	stagger_category = "ranged",
	cleave_distribution = single_cleave,
	ranges = {
		max = 15,
		min = 5
	},
	armor_damage_modifier_ranged = {
		near = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_0_5,
				[armor_types.resistant] = damage_lerp_values.lerp_1,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_0_5,
				[armor_types.super_armor] = damage_lerp_values.no_damage,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_75,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
				[armor_types.prop_armor] = damage_lerp_values.lerp_0_5
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_1,
				[armor_types.resistant] = damage_lerp_values.lerp_1,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_0_5,
				[armor_types.super_armor] = damage_lerp_values.no_damage,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_25,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_25,
				[armor_types.prop_armor] = damage_lerp_values.lerp_1
			}
		},
		far = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_0_75,
				[armor_types.armored] = damage_lerp_values.lerp_0_5,
				[armor_types.resistant] = damage_lerp_values.lerp_1,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_0_5,
				[armor_types.super_armor] = damage_lerp_values.no_damage,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_5,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
				[armor_types.prop_armor] = damage_lerp_values.lerp_0_5
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_2,
				[armor_types.resistant] = damage_lerp_values.lerp_1,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_0_5,
				[armor_types.super_armor] = damage_lerp_values.no_damage,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_25,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_25,
				[armor_types.prop_armor] = damage_lerp_values.lerp_2
			}
		}
	},
	critical_strike = {
		gibbing_power = gibbing_power.medium,
		gibbing_type = gibbing_types.laser
	},
	power_distribution = {
		impact = 3,
		attack = {
			10,
			40
		}
	},
	damage_type = damage_types.laser,
	gibbing_power = gibbing_power.medium,
	gibbing_type = gibbing_types.laser,
	on_kill_area_suppression = {
		distance = 3,
		suppression_value = 2
	},
	targets = {
		default_target = {
			boost_curve_multiplier_finesse = 0.5,
			boost_curve = PowerLevelSettings.boost_curves.default,
			finesse_boost = {
				[armor_types.unarmored] = 0.75
			}
		}
	}
}
overrides.heavy_lasgun_snp = {
	parent_template_name = "default_lasgun_snp",
	overrides = {
		{
			"ranges",
			"min",
			8
		},
		{
			"ranges",
			"max",
			25
		},
		{
			"power_distribution",
			"attack",
			50
		},
		{
			"suppression_value",
			1
		}
	}
}
overrides.light_lasgun_snp = {
	parent_template_name = "default_lasgun_snp",
	overrides = {
		{
			"ranges",
			"min",
			8
		},
		{
			"ranges",
			"max",
			25
		},
		{
			"power_distribution",
			"attack",
			25
		},
		{
			"suppression_value",
			1
		}
	}
}
damage_templates.default_lasgun_bfg = {
	suppression_value = 4,
	ignore_shield = true,
	ragdoll_push_force = 750,
	ignore_stagger_reduction = true,
	stagger_category = "ranged",
	cleave_distribution = medium_cleave,
	ranges = {
		max = 20,
		min = 10
	},
	armor_damage_modifier_ranged = {
		near = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_0_5,
				[armor_types.armored] = damage_lerp_values.lerp_1,
				[armor_types.resistant] = damage_lerp_values.lerp_1,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_1,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_75,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
				[armor_types.prop_armor] = damage_lerp_values.lerp_1
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_2,
				[armor_types.armored] = damage_lerp_values.lerp_3,
				[armor_types.resistant] = damage_lerp_values.lerp_2,
				[armor_types.player] = damage_lerp_values.lerp_2,
				[armor_types.berserker] = damage_lerp_values.lerp_2,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_2_5,
				[armor_types.void_shield] = damage_lerp_values.lerp_2_5,
				[armor_types.prop_armor] = damage_lerp_values.lerp_3
			}
		},
		far = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_0_5,
				[armor_types.armored] = damage_lerp_values.lerp_1,
				[armor_types.resistant] = damage_lerp_values.lerp_1,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_1,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
				[armor_types.void_shield] = damage_lerp_values.lerp_1,
				[armor_types.prop_armor] = damage_lerp_values.lerp_1
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_2,
				[armor_types.armored] = damage_lerp_values.lerp_3,
				[armor_types.resistant] = damage_lerp_values.lerp_2,
				[armor_types.player] = damage_lerp_values.lerp_2,
				[armor_types.berserker] = damage_lerp_values.lerp_2,
				[armor_types.super_armor] = damage_lerp_values.lerp_2,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_2_5,
				[armor_types.void_shield] = damage_lerp_values.lerp_2_5,
				[armor_types.prop_armor] = damage_lerp_values.lerp_3
			}
		}
	},
	critical_strike = {
		gibbing_power = gibbing_power.heavy,
		gibbing_type = gibbing_types.laser
	},
	power_distribution = {
		attack = 200,
		impact = 50
	},
	damage_type = damage_types.plasma,
	gibbing_power = gibbing_power.heavy,
	gibbing_type = gibbing_types.laser,
	on_kill_area_suppression = {
		distance = 8,
		suppression_value = 10
	},
	targets = {
		default_target = {
			boost_curve_multiplier_finesse = 1.2,
			boost_curve = PowerLevelSettings.boost_curves.default,
			finesse_boost = {
				[armor_types.unarmored] = 0.75
			}
		}
	}
}
overrides.spray_lasgun_bfg = {
	parent_template_name = "default_lasgun_bfg",
	overrides = {
		{
			"power_distribution",
			"attack",
			50
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
