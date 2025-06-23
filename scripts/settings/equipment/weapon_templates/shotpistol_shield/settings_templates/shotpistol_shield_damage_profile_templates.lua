-- chunkname: @scripts/settings/equipment/weapon_templates/shotpistol_shield/settings_templates/shotpistol_shield_damage_profile_templates.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local DamageProfileSettings = require("scripts/settings/damage/damage_profile_settings")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local GibbingSettings = require("scripts/settings/gibbing/gibbing_settings")
local HerdingTemplates = require("scripts/settings/damage/herding_templates")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local WoundsTemplates = require("scripts/settings/damage/wounds_templates")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local melee_attack_strengths = AttackSettings.melee_attack_strength
local armor_types = ArmorSettings.types
local damage_lerp_values = DamageProfileSettings.damage_lerp_values
local damage_types = DamageSettings.damage_types
local gibbing_power = GibbingSettings.gibbing_power
local gibbing_types = GibbingSettings.gibbing_types
local damage_templates = {}
local overrides = {}

table.make_unique(damage_templates)
table.make_unique(overrides)

damage_templates.damage_shotpistol_shield_p1 = {
	ragdoll_only = false,
	stagger_category = "ranged",
	ignore_stagger_reduction = true,
	cleave_distribution = {
		attack = 3.5,
		impact = 3.5
	},
	ranges = {
		min = {
			12,
			15
		},
		max = {
			16,
			25
		}
	},
	herding_template = HerdingTemplates.shotgun,
	armor_damage_modifier_ranged = {
		near = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_0_6,
				[armor_types.resistant] = damage_lerp_values.lerp_0_7,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_0_75,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_1,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_5
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_1,
				[armor_types.resistant] = damage_lerp_values.lerp_0_75,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_1,
				[armor_types.super_armor] = damage_lerp_values.lerp_1,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
				[armor_types.void_shield] = damage_lerp_values.lerp_1
			}
		},
		far = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_0_75,
				[armor_types.armored] = damage_lerp_values.lerp_0_5,
				[armor_types.resistant] = damage_lerp_values.lerp_0_5,
				[armor_types.player] = damage_lerp_values.lerp_0_1,
				[armor_types.berserker] = damage_lerp_values.lerp_0_5,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_05,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_5,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_4
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_0_75,
				[armor_types.armored] = damage_lerp_values.lerp_0_75,
				[armor_types.resistant] = damage_lerp_values.lerp_0_5,
				[armor_types.player] = damage_lerp_values.no_damage,
				[armor_types.berserker] = damage_lerp_values.lerp_0_5,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_5,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_5
			}
		}
	},
	critical_strike = {
		gibbing_power = gibbing_power.medium,
		gibbing_type = gibbing_types.ballistic
	},
	power_distribution = {
		attack = {
			600,
			1100
		},
		impact = {
			16,
			32
		}
	},
	damage_type = damage_types.pellet,
	gibbing_power = gibbing_power.light,
	gibbing_type = gibbing_types.ballistic,
	suppression_value = {
		0.6,
		1.35
	},
	wounds_template = WoundsTemplates.shotgun,
	on_kill_area_suppression = {
		suppression_value = {
			3.2,
			4.5
		},
		distance = {
			3,
			4
		}
	},
	targets = {
		default_target = {
			boost_curve = PowerLevelSettings.boost_curves.default,
			finesse_boost = {},
			boost_curve_multiplier_finesse = {
				0.75,
				1
			}
		}
	},
	ragdoll_push_force = {
		200,
		350
	},
	gib_push_force = GibbingSettings.gib_push_force.ranged_medium
}
damage_templates.shotpistol_weapon_special_light = {
	is_push = true,
	stagger_category = "melee",
	ignore_stagger_reduction = true,
	cleave_distribution = {
		attack = 13,
		impact = 13
	},
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = 1,
			[armor_types.armored] = 0.3,
			[armor_types.resistant] = 0.5,
			[armor_types.player] = 0,
			[armor_types.berserker] = 0.6,
			[armor_types.super_armor] = 0,
			[armor_types.disgustingly_resilient] = 1,
			[armor_types.void_shield] = 0.1
		},
		impact = {
			[armor_types.unarmored] = 1.25,
			[armor_types.armored] = 1,
			[armor_types.resistant] = 1,
			[armor_types.player] = 0,
			[armor_types.berserker] = 0.5,
			[armor_types.super_armor] = 0.5,
			[armor_types.disgustingly_resilient] = 1,
			[armor_types.void_shield] = 0
		}
	},
	gibbing_power = gibbing_power.always,
	gibbing_type = gibbing_types.crushing,
	targets = {
		{
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = {
					20,
					40
				},
				impact = {
					8,
					12
				}
			}
		},
		{
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = {
					15,
					35
				},
				impact = {
					7,
					11
				}
			}
		},
		{
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = {
					10,
					30
				},
				impact = {
					6,
					10
				}
			}
		},
		{
			power_distribution = {
				attack = {
					8,
					25
				},
				impact = {
					5,
					8
				}
			}
		},
		default_target = {
			power_distribution = {
				attack = {
					10,
					10
				},
				impact = {
					4,
					6
				}
			}
		}
	}
}
damage_templates.shotpistol_weapon_special_heavy = {
	ragdoll_push_force = 270,
	ragdoll_only = true,
	ignore_stagger_reduction = true,
	stagger_category = "uppercut",
	damage_type = damage_types.blunt_heavy,
	cleave_distribution = {
		attack = 12.5,
		impact = 12.5
	},
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = 1,
			[armor_types.armored] = 0.8,
			[armor_types.resistant] = 0.7,
			[armor_types.player] = 0,
			[armor_types.berserker] = 0.7,
			[armor_types.super_armor] = 0.5,
			[armor_types.disgustingly_resilient] = 1,
			[armor_types.void_shield] = 0.6
		},
		impact = {
			[armor_types.unarmored] = 1,
			[armor_types.armored] = 1,
			[armor_types.resistant] = 0.8,
			[armor_types.player] = 0,
			[armor_types.berserker] = 0.8,
			[armor_types.super_armor] = 0.8,
			[armor_types.disgustingly_resilient] = 1,
			[armor_types.void_shield] = 0
		}
	},
	gibbing_power = gibbing_power.always,
	gibbing_type = gibbing_types.crushing,
	melee_attack_strength = melee_attack_strengths.heavy,
	targets = {
		{
			power_distribution = {
				attack = {
					150,
					310
				},
				impact = {
					15,
					30
				}
			},
			boost_curve_multiplier_finesse = {
				0.4,
				0.8
			}
		},
		{
			power_distribution = {
				attack = {
					110,
					210
				},
				impact = {
					9,
					24
				}
			}
		},
		{
			power_distribution = {
				attack = {
					70,
					130
				},
				impact = {
					7,
					19
				}
			}
		},
		{
			power_distribution = {
				attack = {
					40,
					75
				},
				impact = {
					6,
					15
				}
			}
		},
		{
			power_distribution = {
				attack = {
					30,
					45
				},
				impact = {
					4,
					12
				}
			}
		},
		{
			power_distribution = {
				attack = {
					30,
					45
				},
				impact = {
					3,
					10
				}
			}
		},
		default_target = {
			power_distribution = {
				attack = {
					20,
					50
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
