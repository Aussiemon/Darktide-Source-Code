local ArmorSettings = require("scripts/settings/damage/armor_settings")
local DamageProfileSettings = require("scripts/settings/damage/damage_profile_settings")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local GibbingSettings = require("scripts/settings/gibbing/gibbing_settings")
local HerdingTemplates = require("scripts/settings/damage/herding_templates")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local WoundsTemplates = require("scripts/settings/damage/wounds_templates")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local armor_types = ArmorSettings.types
local damage_types = DamageSettings.damage_types
local gibbing_power = GibbingSettings.gibbing_power
local gibbing_types = GibbingSettings.gibbing_types
local melee_attack_strengths = AttackSettings.melee_attack_strength
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
local lasgun_armor_mod_default = {
	near = {
		attack = {
			[armor_types.unarmored] = damage_lerp_values.lerp_0_8,
			[armor_types.armored] = damage_lerp_values.lerp_0_4,
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
			[armor_types.armored] = damage_lerp_values.lerp_0_5,
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
local lasgun_p2_armor_mod_charged = {
	near = {
		attack = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_1,
			[armor_types.resistant] = damage_lerp_values.lerp_1_5,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_1,
			[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
			[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
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
	far = {
		attack = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_1,
			[armor_types.resistant] = damage_lerp_values.lerp_1_5,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_1_5,
			[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
			[armor_types.void_shield] = damage_lerp_values.lerp_0_6,
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
}
local lasgun_p2_armor_mod_low_charged = {
	near = {
		attack = {
			[armor_types.unarmored] = damage_lerp_values.lerp_0_8,
			[armor_types.armored] = damage_lerp_values.lerp_0_5,
			[armor_types.resistant] = damage_lerp_values.lerp_0_5,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_1,
			[armor_types.super_armor] = damage_lerp_values.lerp_0_05,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_8,
			[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
			[armor_types.prop_armor] = damage_lerp_values.lerp_0_75
		},
		impact = {
			[armor_types.unarmored] = damage_lerp_values.lerp_0_8,
			[armor_types.armored] = damage_lerp_values.lerp_0_75,
			[armor_types.resistant] = damage_lerp_values.lerp_0_75,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_0_5,
			[armor_types.super_armor] = damage_lerp_values.no_damage,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_75,
			[armor_types.void_shield] = damage_lerp_values.lerp_0_25,
			[armor_types.prop_armor] = damage_lerp_values.lerp_0_25
		}
	},
	far = {
		attack = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_0_6,
			[armor_types.resistant] = damage_lerp_values.lerp_0_6,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_1_5,
			[armor_types.super_armor] = damage_lerp_values.lerp_0_05,
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
	staggering_headshot = true,
	stagger_category = "killshot",
	crit_boost = 0.25,
	cleave_distribution = no_cleave,
	ranges = {
		max = 15,
		min = 7
	},
	herding_template = HerdingTemplates.shot,
	wounds_template = WoundsTemplates.lasgun,
	armor_damage_modifier_ranged = lasgun_armor_mod_default,
	critical_strike = {
		gibbing_power = gibbing_power.always,
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
	gibbing_power = gibbing_power.always,
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
	},
	charge_level_scaler = {
		{
			modifier = 1,
			t = 1
		},
		start_modifier = 0
	}
}
damage_templates.lasgun_p2_charge_killshot = {
	staggering_headshot = true,
	stagger_category = "ranged",
	crit_boost = 0.25,
	cleave_distribution = double_cleave,
	ranges = {
		max = 25,
		min = 10
	},
	herding_template = HerdingTemplates.shot_back,
	wounds_template = WoundsTemplates.lasgun,
	armor_damage_modifier_ranged = lasgun_p2_armor_mod_low_charged,
	armor_damage_modifier_ranged_charged = lasgun_p2_armor_mod_charged,
	critical_strike = {
		gibbing_power = gibbing_power.always,
		gibbing_type = gibbing_types.laser
	},
	power_distribution = {
		attack = {
			300,
			600
		},
		impact = {
			4,
			12
		}
	},
	gibbing_power = gibbing_power.always,
	gibbing_type = gibbing_types.laser,
	suppression_value = {
		1,
		2
	},
	on_kill_area_suppression = {
		suppression_value = {
			1.5,
			3
		},
		distance = {
			3,
			4
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
		400,
		600
	},
	charge_level_scaler = {
		{
			modifier = 0.3,
			t = 0.1
		},
		{
			modifier = 1,
			t = 1
		},
		start_modifier = 0.3
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
				75,
				150
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
overrides.lasgun_p2_m1_charge_killshot = {
	parent_template_name = "lasgun_p2_charge_killshot",
	overrides = {
		{
			"power_distribution",
			"attack",
			{
				250,
				500
			}
		},
		{
			"power_distribution",
			"impact",
			{
				12.5,
				25
			}
		},
		{
			"charge_level_scaler",
			"start_modifier",
			0.4
		},
		{
			"charge_level_scaler",
			1,
			"modifier",
			0.4
		},
		{
			"charge_level_scaler",
			2,
			"modifier",
			1
		}
	}
}
overrides.lasgun_p2_m2_charge_killshot = {
	parent_template_name = "lasgun_p2_charge_killshot",
	overrides = {
		{
			"power_distribution",
			"attack",
			{
				200,
				400
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
			"charge_level_scaler",
			"start_modifier",
			0.5
		},
		{
			"charge_level_scaler",
			1,
			"modifier",
			0.5
		},
		{
			"charge_level_scaler",
			2,
			"modifier",
			1
		},
		{
			"armor_damage_modifier_ranged",
			"near",
			"attack",
			"armored",
			damage_lerp_values.lerp_0_6
		},
		{
			"armor_damage_modifier_ranged",
			"far",
			"attack",
			"armored",
			damage_lerp_values.lerp_0_6
		},
		{
			"armor_damage_modifier_ranged_charged",
			"near",
			"attack",
			"super_armor",
			damage_lerp_values.lerp_0_6
		},
		{
			"armor_damage_modifier_ranged_charged",
			"far",
			"attack",
			"super_armor",
			damage_lerp_values.lerp_0_75
		}
	}
}
overrides.lasgun_p2_m3_charge_killshot = {
	parent_template_name = "lasgun_p2_charge_killshot",
	overrides = {
		{
			"power_distribution",
			"attack",
			{
				300,
				600
			}
		},
		{
			"power_distribution",
			"impact",
			{
				21,
				36
			}
		},
		{
			"charge_level_scaler",
			"start_modifier",
			0.3
		},
		{
			"charge_level_scaler",
			1,
			"modifier",
			0.3
		},
		{
			"charge_level_scaler",
			2,
			"modifier",
			1
		},
		{
			"armor_damage_modifier_ranged",
			"near",
			"attack",
			"armored",
			damage_lerp_values.lerp_0_8
		},
		{
			"armor_damage_modifier_ranged",
			"far",
			"attack",
			"armored",
			damage_lerp_values.lerp_0_9
		},
		{
			"armor_damage_modifier_ranged_charged",
			"near",
			"attack",
			"super_armor",
			damage_lerp_values.lerp_0_8
		},
		{
			"armor_damage_modifier_ranged_charged",
			"far",
			"attack",
			"super_armor",
			damage_lerp_values.lerp_0_8
		},
		{
			"armor_damage_modifier_ranged_charged",
			"near",
			"attack",
			"resistant",
			damage_lerp_values.lerp_1_75
		},
		{
			"armor_damage_modifier_ranged_charged",
			"far",
			"attack",
			"resistant",
			damage_lerp_values.lerp_1_75
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
		gibbing_power = gibbing_power.always,
		gibbing_type = gibbing_types.laser
	},
	power_distribution = {
		attack = 30,
		impact = 10
	},
	damage_type = damage_types.laser,
	gibbing_power = gibbing_power.always,
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
	staggering_headshot = true,
	stagger_category = "ranged",
	cleave_distribution = no_cleave,
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
				[armor_types.berserker] = damage_lerp_values.lerp_0_6,
				[armor_types.super_armor] = damage_lerp_values.no_damage,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
				[armor_types.prop_armor] = damage_lerp_values.lerp_0_5
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_1,
				[armor_types.resistant] = damage_lerp_values.lerp_0_5,
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
				[armor_types.armored] = damage_lerp_values.lerp_0_75,
				[armor_types.resistant] = damage_lerp_values.lerp_0_5,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_0_5,
				[armor_types.super_armor] = damage_lerp_values.no_damage,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_75,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
				[armor_types.prop_armor] = damage_lerp_values.lerp_0_5
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_1,
				[armor_types.resistant] = damage_lerp_values.lerp_1,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_0_25,
				[armor_types.super_armor] = damage_lerp_values.no_damage,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_25,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_25,
				[armor_types.prop_armor] = damage_lerp_values.lerp_2
			}
		}
	},
	wounds_template = WoundsTemplates.lasgun,
	critical_strike = {
		gibbing_power = gibbing_power.always,
		gibbing_type = gibbing_types.laser
	},
	accumulative_stagger_strength_multiplier = {
		0.5,
		2
	},
	power_distribution = {
		attack = {
			30,
			60
		},
		impact = {
			1,
			2
		}
	},
	damage_type = damage_types.laser,
	gibbing_power = gibbing_power.always,
	gibbing_type = gibbing_types.laser,
	on_kill_area_suppression = {
		distance = 3,
		suppression_value = 2
	},
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default,
			finesse_boost = {
				[armor_types.unarmored] = 0.75
			},
			boost_curve_multiplier_finesse = damage_lerp_values.lerp_0_75
		}
	},
	ragdoll_push_force = {
		30,
		50
	}
}
overrides.heavy_lasgun_snp = {
	parent_template_name = "default_lasgun_snp",
	overrides = {
		{
			"ranges",
			"min",
			10
		},
		{
			"ranges",
			"max",
			20
		},
		{
			"armor_damage_modifier_ranged",
			{
				near = {
					attack = {
						[armor_types.unarmored] = damage_lerp_values.lerp_1,
						[armor_types.armored] = damage_lerp_values.lerp_1,
						[armor_types.resistant] = damage_lerp_values.lerp_1,
						[armor_types.player] = damage_lerp_values.lerp_1,
						[armor_types.berserker] = damage_lerp_values.lerp_0_75,
						[armor_types.super_armor] = damage_lerp_values.no_damage,
						[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
						[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
						[armor_types.prop_armor] = damage_lerp_values.lerp_0_5
					},
					impact = {
						[armor_types.unarmored] = damage_lerp_values.lerp_1,
						[armor_types.armored] = damage_lerp_values.lerp_1,
						[armor_types.resistant] = damage_lerp_values.lerp_0_5,
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
						[armor_types.armored] = damage_lerp_values.lerp_0_75,
						[armor_types.resistant] = damage_lerp_values.lerp_1,
						[armor_types.player] = damage_lerp_values.lerp_1,
						[armor_types.berserker] = damage_lerp_values.lerp_0_75,
						[armor_types.super_armor] = damage_lerp_values.no_damage,
						[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_75,
						[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
						[armor_types.prop_armor] = damage_lerp_values.lerp_0_5
					},
					impact = {
						[armor_types.unarmored] = damage_lerp_values.lerp_1,
						[armor_types.armored] = damage_lerp_values.lerp_1,
						[armor_types.resistant] = damage_lerp_values.lerp_1,
						[armor_types.player] = damage_lerp_values.lerp_1,
						[armor_types.berserker] = damage_lerp_values.lerp_0_25,
						[armor_types.super_armor] = damage_lerp_values.no_damage,
						[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_25,
						[armor_types.void_shield] = damage_lerp_values.lerp_0_25,
						[armor_types.prop_armor] = damage_lerp_values.lerp_2
					}
				}
			}
		}
	}
}
overrides.light_lasgun_snp = {
	parent_template_name = "default_lasgun_snp",
	overrides = {
		{
			"ranges",
			"min",
			10
		},
		{
			"ranges",
			"max",
			20
		},
		{
			"suppression_value",
			1
		},
		{
			"armor_damage_modifier_ranged",
			{
				near = {
					attack = {
						[armor_types.unarmored] = damage_lerp_values.lerp_0_75,
						[armor_types.armored] = damage_lerp_values.lerp_0_75,
						[armor_types.resistant] = damage_lerp_values.lerp_0_5,
						[armor_types.player] = damage_lerp_values.lerp_1,
						[armor_types.berserker] = damage_lerp_values.lerp_0_5,
						[armor_types.super_armor] = damage_lerp_values.no_damage,
						[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_75,
						[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
						[armor_types.prop_armor] = damage_lerp_values.lerp_0_5
					},
					impact = {
						[armor_types.unarmored] = damage_lerp_values.lerp_1,
						[armor_types.armored] = damage_lerp_values.lerp_1,
						[armor_types.resistant] = damage_lerp_values.lerp_1,
						[armor_types.player] = damage_lerp_values.lerp_1,
						[armor_types.berserker] = damage_lerp_values.lerp_0_25,
						[armor_types.super_armor] = damage_lerp_values.no_damage,
						[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_25,
						[armor_types.void_shield] = damage_lerp_values.lerp_0_25,
						[armor_types.prop_armor] = damage_lerp_values.lerp_2
					}
				},
				far = {
					attack = {
						[armor_types.unarmored] = damage_lerp_values.lerp_1,
						[armor_types.armored] = damage_lerp_values.lerp_1,
						[armor_types.resistant] = damage_lerp_values.lerp_0_75,
						[armor_types.player] = damage_lerp_values.lerp_1,
						[armor_types.berserker] = damage_lerp_values.lerp_0_6,
						[armor_types.super_armor] = damage_lerp_values.no_damage,
						[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
						[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
						[armor_types.prop_armor] = damage_lerp_values.lerp_0_5
					},
					impact = {
						[armor_types.unarmored] = damage_lerp_values.lerp_1,
						[armor_types.armored] = damage_lerp_values.lerp_1,
						[armor_types.resistant] = damage_lerp_values.lerp_0_5,
						[armor_types.player] = damage_lerp_values.lerp_1,
						[armor_types.berserker] = damage_lerp_values.lerp_0_5,
						[armor_types.super_armor] = damage_lerp_values.no_damage,
						[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_25,
						[armor_types.void_shield] = damage_lerp_values.lerp_0_25,
						[armor_types.prop_armor] = damage_lerp_values.lerp_1
					}
				}
			}
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
		gibbing_power = gibbing_power.always,
		gibbing_type = gibbing_types.laser
	},
	power_distribution = {
		attack = 200,
		impact = 50
	},
	damage_type = damage_types.plasma,
	gibbing_power = gibbing_power.always,
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
damage_templates.bayonette_weapon_special_stab = {
	ragdoll_push_force = 250,
	ragdoll_only = true,
	stagger_category = "melee",
	cleave_distribution = double_cleave,
	damage_type = damage_types.combat_blade,
	gibbing_power = gibbing_power.always,
	gibbing_type = gibbing_types.sawing,
	melee_attack_strength = melee_attack_strengths.heavy,
	wounds_template = WoundsTemplates.bayonet,
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_0_5,
			[armor_types.resistant] = damage_lerp_values.lerp_1,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_0_5,
			[armor_types.super_armor] = damage_lerp_values.no_damage,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
			[armor_types.void_shield] = damage_lerp_values.lerp_1,
			[armor_types.prop_armor] = damage_lerp_values.lerp_0_5
		},
		impact = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_1,
			[armor_types.resistant] = damage_lerp_values.lerp_1,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_0_5,
			[armor_types.super_armor] = damage_lerp_values.lerp_0_3,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
			[armor_types.void_shield] = damage_lerp_values.lerp_1,
			[armor_types.prop_armor] = damage_lerp_values.lerp_1
		}
	},
	targets = {
		{
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = {
					75,
					150
				},
				impact = {
					8,
					14
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
				[armor_types.prop_armor] = 0.5
			}
		},
		{
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = {
					40,
					50
				},
				impact = {
					6,
					10
				}
			}
		},
		default_target = {
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				impact = 5,
				attack = {
					25,
					35
				}
			},
			boost_curve = PowerLevelSettings.boost_curves.default,
			finesse_boost = {
				[armor_types.unarmored] = 0.1,
				[armor_types.armored] = 0.5,
				[armor_types.resistant] = 0.1,
				[armor_types.player] = 0.1,
				[armor_types.berserker] = 0.1,
				[armor_types.super_armor] = 0.1,
				[armor_types.disgustingly_resilient] = 0.5,
				[armor_types.void_shield] = 0.5,
				[armor_types.prop_armor] = 0.5
			}
		}
	},
	gib_push_force = GibbingSettings.gib_push_force.ranged_light
}
damage_templates.bayonette_weapon_special_slash = {
	ragdoll_push_force = 250,
	ragdoll_only = true,
	stagger_category = "melee",
	cleave_distribution = double_cleave,
	damage_type = damage_types.combat_blade,
	gibbing_power = gibbing_power.light,
	gibbing_type = gibbing_types.sawing,
	melee_attack_strength = melee_attack_strengths.heavy,
	wounds_template = WoundsTemplates.bayonet,
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_0_5,
			[armor_types.resistant] = damage_lerp_values.lerp_1,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_0_5,
			[armor_types.super_armor] = damage_lerp_values.no_damage,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
			[armor_types.void_shield] = damage_lerp_values.lerp_1,
			[armor_types.prop_armor] = damage_lerp_values.lerp_0_5
		},
		impact = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_1,
			[armor_types.resistant] = damage_lerp_values.lerp_1,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_0_5,
			[armor_types.super_armor] = damage_lerp_values.lerp_0_3,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
			[armor_types.void_shield] = damage_lerp_values.lerp_1,
			[armor_types.prop_armor] = damage_lerp_values.lerp_1
		}
	},
	targets = {
		{
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				impact = 10,
				attack = {
					100,
					200
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
				[armor_types.prop_armor] = 0.5
			}
		},
		{
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				impact = 6,
				attack = {
					75,
					100
				}
			}
		},
		default_target = {
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				impact = 5,
				attack = {
					25,
					35
				}
			},
			boost_curve = PowerLevelSettings.boost_curves.default,
			finesse_boost = {
				[armor_types.unarmored] = 0.1,
				[armor_types.armored] = 0.5,
				[armor_types.resistant] = 0.1,
				[armor_types.player] = 0.1,
				[armor_types.berserker] = 0.1,
				[armor_types.super_armor] = 0.1,
				[armor_types.disgustingly_resilient] = 0.5,
				[armor_types.void_shield] = 0.5,
				[armor_types.prop_armor] = 0.5
			}
		}
	},
	gib_push_force = GibbingSettings.gib_push_force.ranged_light
}

return {
	base_templates = damage_templates,
	overrides = overrides
}
