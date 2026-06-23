-- chunkname: @scripts/settings/equipment/weapon_templates/arc_rifle/settings_templates/arc_rifle_damage_profile_templates.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local DamageProfileSettings = require("scripts/settings/damage/damage_profile_settings")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local GibbingSettings = require("scripts/settings/gibbing/gibbing_settings")
local HerdingTemplates = require("scripts/settings/damage/herding_templates")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local WoundsTemplates = require("scripts/settings/damage/wounds_templates")
local armor_types = ArmorSettings.types
local crit_impact_armor_mod = DamageProfileSettings.crit_impact_armor_mod
local damage_lerp_values = DamageProfileSettings.damage_lerp_values
local damage_types = DamageSettings.damage_types
local gibbing_power = GibbingSettings.gibbing_power
local gibbing_types = GibbingSettings.gibbing_types
local no_cleave = DamageProfileSettings.no_cleave
local light_cleave = DamageProfileSettings.light_cleave
local medium_cleave = DamageProfileSettings.medium_cleave
local single_cleave = DamageProfileSettings.single_cleave
local damage_templates = {}
local overrides = {}

table.make_unique(damage_templates)
table.make_unique(overrides)

local arc_rifle_p1_m1_adm = {
	near = {
		attack = {
			[armor_types.unarmored] = damage_lerp_values.lerp_0_6,
			[armor_types.armored] = damage_lerp_values.lerp_0_7,
			[armor_types.resistant] = damage_lerp_values.lerp_0_5,
			[armor_types.berserker] = damage_lerp_values.lerp_0_6,
			[armor_types.super_armor] = damage_lerp_values.lerp_0_3,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_5,
			[armor_types.void_shield] = damage_lerp_values.lerp_0_7,
			[armor_types.player] = damage_lerp_values.lerp_1,
		},
		impact = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1_25,
			[armor_types.armored] = damage_lerp_values.lerp_0_9,
			[armor_types.resistant] = damage_lerp_values.lerp_1_25,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_0_75,
			[armor_types.super_armor] = damage_lerp_values.lerp_0_75,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
			[armor_types.void_shield] = damage_lerp_values.lerp_1,
		},
	},
	far = {
		attack = {
			[armor_types.unarmored] = damage_lerp_values.lerp_0_5,
			[armor_types.armored] = damage_lerp_values.lerp_0_6,
			[armor_types.resistant] = damage_lerp_values.lerp_0_4,
			[armor_types.berserker] = damage_lerp_values.lerp_0_5,
			[armor_types.super_armor] = damage_lerp_values.lerp_0_2,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_4,
			[armor_types.void_shield] = damage_lerp_values.lerp_0_6,
			[armor_types.player] = damage_lerp_values.lerp_1,
		},
		impact = {
			[armor_types.unarmored] = damage_lerp_values.lerp_0_5,
			[armor_types.armored] = damage_lerp_values.lerp_0_6,
			[armor_types.resistant] = damage_lerp_values.lerp_0_4,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_0_5,
			[armor_types.super_armor] = damage_lerp_values.no_damage,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_6,
			[armor_types.void_shield] = damage_lerp_values.lerp_0_4,
		},
	},
}

damage_templates.arc_rifle_p1_m1_damage = {
	ragdoll_push_force = 200,
	stagger_category = "ranged",
	suppression_value = 7.5,
	cleave_distribution = no_cleave,
	ranges = {
		min = {
			11,
			22,
		},
		max = {
			23,
			40,
		},
	},
	wounds_template = WoundsTemplates.stubber,
	armor_damage_modifier_ranged = arc_rifle_p1_m1_adm,
	crit_mod = {
		attack = {
			[armor_types.unarmored] = {
				0.1,
				0.2,
			},
			[armor_types.armored] = {
				0.1,
				0.2,
			},
			[armor_types.resistant] = {
				0.1,
				0.2,
			},
			[armor_types.player] = {
				0.1,
				0.2,
			},
			[armor_types.berserker] = {
				0.1,
				0.2,
			},
			[armor_types.super_armor] = {
				0.1,
				0.2,
			},
			[armor_types.disgustingly_resilient] = {
				0.1,
				0.2,
			},
			[armor_types.void_shield] = {
				0.1,
				0.2,
			},
		},
		impact = crit_impact_armor_mod,
	},
	power_distribution = {
		attack = {
			370,
			570,
		},
		impact = {
			3,
			6,
		},
	},
	targets = {
		default_target = {
			boost_curve_multiplier_finesse = 0.1,
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
	damage_type = damage_types.auto_bullet,
	gibbing_power = gibbing_power.medium,
	gibbing_type = gibbing_types.arc,
	critical_strike = {
		gibbing_power = gibbing_power.heavy,
		gibbing_type = gibbing_types.arc,
	},
	gib_push_force = GibbingSettings.gib_push_force.ranged_heavy,
	on_kill_area_suppression = {
		distance = 3,
		suppression_value = 4,
	},
}
damage_templates.arc_rifle_p1_m1_damage_braced = {
	ragdoll_push_force = 200,
	stagger_category = "ranged",
	suppression_value = 9.5,
	cleave_distribution = no_cleave,
	ranges = {
		min = {
			11,
			22,
		},
		max = {
			23,
			40,
		},
	},
	wounds_template = WoundsTemplates.stubber,
	armor_damage_modifier_ranged = arc_rifle_p1_m1_adm,
	crit_mod = {
		attack = {
			[armor_types.unarmored] = {
				0.1,
				0.2,
			},
			[armor_types.armored] = {
				0.1,
				0.2,
			},
			[armor_types.resistant] = {
				0.1,
				0.2,
			},
			[armor_types.player] = {
				0.1,
				0.2,
			},
			[armor_types.berserker] = {
				0.1,
				0.2,
			},
			[armor_types.super_armor] = {
				0.1,
				0.2,
			},
			[armor_types.disgustingly_resilient] = {
				0.1,
				0.2,
			},
			[armor_types.void_shield] = {
				0.1,
				0.2,
			},
		},
		impact = crit_impact_armor_mod,
	},
	power_distribution = {
		attack = {
			380,
			580,
		},
		impact = {
			4,
			8,
		},
	},
	targets = {
		default_target = {
			boost_curve_multiplier_finesse = 0.1,
			boost_curve = PowerLevelSettings.boost_curves.default,
		},
	},
	damage_type = damage_types.auto_bullet,
	gibbing_power = gibbing_power.medium,
	gibbing_type = gibbing_types.arc,
	critical_strike = {
		gibbing_power = gibbing_power.heavy,
		gibbing_type = gibbing_types.arc,
	},
	gib_push_force = GibbingSettings.gib_push_force.ranged_heavy,
	on_kill_area_suppression = {
		distance = 3,
		suppression_value = 6,
	},
}
damage_templates.arc_rifle_arc_chain_lightning_link_damage = {
	ignore_hitzone_multiplier = true,
	ignore_stagger_reduction = false,
	stagger_category = "ranged",
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = damage_lerp_values.lerp_0_6,
			[armor_types.armored] = damage_lerp_values.lerp_0_7,
			[armor_types.resistant] = damage_lerp_values.lerp_0_5,
			[armor_types.berserker] = damage_lerp_values.lerp_0_6,
			[armor_types.super_armor] = damage_lerp_values.lerp_0_4,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_5,
			[armor_types.void_shield] = damage_lerp_values.lerp_0_7,
			[armor_types.player] = damage_lerp_values.lerp_1,
		},
		impact = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1_25,
			[armor_types.armored] = damage_lerp_values.lerp_0_9,
			[armor_types.resistant] = damage_lerp_values.lerp_1_25,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_0_75,
			[armor_types.super_armor] = damage_lerp_values.lerp_0_75,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
			[armor_types.void_shield] = damage_lerp_values.lerp_1,
		},
	},
	cleave_distribution = {
		attack = 5,
		impact = 5,
	},
	power_distribution = {
		attack = 10,
		impact = 10,
	},
	ranges = {
		min = {
			3,
			6,
		},
		max = {
			7,
			12,
		},
	},
	damage_type = damage_types.arc_chain,
	gibbing_power = gibbing_power.medium,
	gibbing_type = gibbing_types.arc,
	critical_strike = {
		gibbing_power = gibbing_power.heavy,
		gibbing_type = gibbing_types.arc,
	},
	gib_push_force = GibbingSettings.gib_push_force.ranged_heavy,
	targets = {
		{
			power_distribution = {
				attack = {
					40,
					80,
				},
				impact = {
					2,
					3,
				},
			},
		},
		{
			power_distribution = {
				attack = {
					200,
					220,
				},
				impact = {
					6,
					10,
				},
			},
		},
		{
			power_distribution = {
				attack = {
					220,
					320,
				},
				impact = {
					5,
					8,
				},
			},
		},
		default_target = {
			power_distribution = {
				attack = {
					300,
					350,
				},
				impact = {
					2,
					5,
				},
			},
		},
	},
	stat_buffs = {
		"arc_chain_damage",
	},
}
damage_templates.arc_rifle_arc_chain_lightning_link_damage_brace = {
	ignore_hitzone_multiplier = true,
	ignore_stagger_reduction = false,
	stagger_category = "sticky",
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = damage_lerp_values.lerp_0_6,
			[armor_types.armored] = damage_lerp_values.lerp_0_7,
			[armor_types.resistant] = damage_lerp_values.lerp_0_5,
			[armor_types.berserker] = damage_lerp_values.lerp_0_6,
			[armor_types.super_armor] = damage_lerp_values.lerp_0_4,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_5,
			[armor_types.void_shield] = damage_lerp_values.lerp_0_7,
			[armor_types.player] = damage_lerp_values.lerp_1,
		},
		impact = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1_25,
			[armor_types.armored] = damage_lerp_values.lerp_0_9,
			[armor_types.resistant] = damage_lerp_values.lerp_1_25,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_0_75,
			[armor_types.super_armor] = damage_lerp_values.lerp_0_75,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
			[armor_types.void_shield] = damage_lerp_values.lerp_1,
		},
	},
	cleave_distribution = {
		attack = 5,
		impact = 5,
	},
	power_distribution = {
		attack = 10,
		impact = 10,
	},
	damage_type = damage_types.arc_chain,
	gibbing_power = gibbing_power.medium,
	gibbing_type = gibbing_types.arc,
	critical_strike = {
		gibbing_power = gibbing_power.heavy,
		gibbing_type = gibbing_types.arc,
	},
	gib_push_force = GibbingSettings.gib_push_force.ranged_heavy,
	targets = {
		{
			power_distribution = {
				attack = {
					80,
					100,
				},
				impact = {
					3,
					4,
				},
			},
		},
		{
			power_distribution = {
				attack = {
					90,
					130,
				},
				impact = {
					6,
					10,
				},
			},
		},
		{
			power_distribution = {
				attack = {
					130,
					180,
				},
				impact = {
					5,
					8,
				},
			},
		},
		{
			power_distribution = {
				attack = {
					150,
					200,
				},
				impact = {
					4,
					7,
				},
			},
		},
		{
			power_distribution = {
				attack = {
					180,
					220,
				},
				impact = {
					3,
					6,
				},
			},
		},
		default_target = {
			power_distribution = {
				attack = {
					180,
					220,
				},
				impact = {
					2,
					5,
				},
			},
		},
	},
	stat_buffs = {
		"arc_chain_damage",
	},
}

return {
	base_templates = damage_templates,
	overrides = overrides,
}
