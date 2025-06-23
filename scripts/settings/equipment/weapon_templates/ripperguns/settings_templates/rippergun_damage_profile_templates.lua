-- chunkname: @scripts/settings/equipment/weapon_templates/ripperguns/settings_templates/rippergun_damage_profile_templates.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local DamageProfileSettings = require("scripts/settings/damage/damage_profile_settings")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local GibbingSettings = require("scripts/settings/gibbing/gibbing_settings")
local HerdingTemplates = require("scripts/settings/damage/herding_templates")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local WoundsTemplates = require("scripts/settings/damage/wounds_templates")
local armor_types = ArmorSettings.types
local damage_lerp_values = DamageProfileSettings.damage_lerp_values
local damage_types = DamageSettings.damage_types
local gibbing_power = GibbingSettings.gibbing_power
local gibbing_types = GibbingSettings.gibbing_types
local melee_attack_strengths = AttackSettings.melee_attack_strength
local double_cleave = DamageProfileSettings.double_cleave
local damage_templates = {}
local overrides = {}

table.make_unique(damage_templates)
table.make_unique(overrides)

damage_templates.default_rippergun_assault = {
	ragdoll_only = true,
	stagger_category = "ranged",
	ignore_stagger_reduction = true,
	cleave_distribution = double_cleave,
	ranges = {
		min = {
			6,
			15
		},
		max = {
			12,
			40
		}
	},
	armor_damage_modifier_ranged = {
		near = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_0_75,
				[armor_types.resistant] = damage_lerp_values.lerp_0_5,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_0_75,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_05,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
				[armor_types.void_shield] = damage_lerp_values.lerp_1
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_1,
				[armor_types.resistant] = damage_lerp_values.lerp_0_75,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_1,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_1,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
				[armor_types.void_shield] = damage_lerp_values.lerp_1
			}
		},
		far = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_0_3,
				[armor_types.armored] = damage_lerp_values.lerp_0_25,
				[armor_types.resistant] = damage_lerp_values.lerp_0_25,
				[armor_types.player] = damage_lerp_values.lerp_0_1,
				[armor_types.berserker] = damage_lerp_values.lerp_0_3,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_01,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_3,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_3
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_0_5,
				[armor_types.armored] = damage_lerp_values.lerp_0_5,
				[armor_types.resistant] = damage_lerp_values.lerp_0_5,
				[armor_types.player] = damage_lerp_values.no_damage,
				[armor_types.berserker] = damage_lerp_values.lerp_0_2,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_1,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_5,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_5
			}
		}
	},
	critical_strike = {
		gibbing_power = gibbing_power.heavy,
		gibbing_type = gibbing_types.ballistic
	},
	power_distribution = {
		attack = {
			350,
			700
		},
		impact = {
			20,
			60
		}
	},
	herding_template = HerdingTemplates.shotgun,
	damage_type = damage_types.rippergun_pellet,
	wounds_template = WoundsTemplates.rippergun,
	gibbing_power = gibbing_power.medium,
	gibbing_type = gibbing_types.ballistic,
	suppression_value = {
		0.05,
		1
	},
	on_kill_area_suppression = {
		suppression_value = {
			1,
			8
		},
		distance = {
			3,
			6
		}
	},
	targets = {
		default_target = {
			boost_curve_multiplier_finesse = 0.5,
			boost_curve = PowerLevelSettings.boost_curves.default,
			finesse_boost = {
				[armor_types.unarmored] = 0.25
			}
		}
	},
	ragdoll_push_force = {
		50,
		50
	},
	gib_push_force = GibbingSettings.gib_push_force.ranged_heavy
}
damage_templates.rippergun_p1_m2_assault = {
	ragdoll_only = true,
	stagger_category = "ranged",
	ignore_stagger_reduction = true,
	cleave_distribution = double_cleave,
	ranges = {
		min = {
			6,
			15
		},
		max = {
			22,
			50
		}
	},
	armor_damage_modifier_ranged = {
		near = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_0_75,
				[armor_types.resistant] = damage_lerp_values.lerp_0_75,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_0_75,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_05,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
				[armor_types.void_shield] = damage_lerp_values.lerp_1
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_1,
				[armor_types.resistant] = damage_lerp_values.lerp_0_75,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_1,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_1,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
				[armor_types.void_shield] = damage_lerp_values.lerp_1
			}
		},
		far = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_0_5,
				[armor_types.armored] = damage_lerp_values.lerp_0_4,
				[armor_types.resistant] = damage_lerp_values.lerp_0_4,
				[armor_types.player] = damage_lerp_values.lerp_0_1,
				[armor_types.berserker] = damage_lerp_values.lerp_0_5,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_01,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_5,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_3
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_0_5,
				[armor_types.armored] = damage_lerp_values.lerp_0_5,
				[armor_types.resistant] = damage_lerp_values.lerp_0_5,
				[armor_types.player] = damage_lerp_values.no_damage,
				[armor_types.berserker] = damage_lerp_values.lerp_0_2,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_1,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_5,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_5
			}
		}
	},
	critical_strike = {
		gibbing_power = gibbing_power.heavy,
		gibbing_type = gibbing_types.ballistic
	},
	power_distribution = {
		attack = {
			250,
			500
		},
		impact = {
			20,
			60
		}
	},
	herding_template = HerdingTemplates.shotgun,
	damage_type = damage_types.rippergun_pellet,
	wounds_template = WoundsTemplates.rippergun,
	gibbing_power = gibbing_power.medium,
	gibbing_type = gibbing_types.ballistic,
	suppression_value = {
		0.05,
		1
	},
	on_kill_area_suppression = {
		suppression_value = {
			1,
			8
		},
		distance = {
			3,
			6
		}
	},
	targets = {
		default_target = {
			boost_curve_multiplier_finesse = 0.5,
			boost_curve = PowerLevelSettings.boost_curves.default,
			finesse_boost = {
				[armor_types.unarmored] = 0.25
			}
		}
	},
	ragdoll_push_force = {
		50,
		50
	},
	gib_push_force = GibbingSettings.gib_push_force.ranged_heavy
}
damage_templates.rippergun_p1_m3_assault = {
	ragdoll_only = true,
	stagger_category = "ranged",
	ignore_stagger_reduction = true,
	cleave_distribution = double_cleave,
	ranges = {
		min = {
			6,
			15
		},
		max = {
			22,
			50
		}
	},
	armor_damage_modifier_ranged = {
		near = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_0_75,
				[armor_types.resistant] = damage_lerp_values.lerp_0_75,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_0_75,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_05,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
				[armor_types.void_shield] = damage_lerp_values.lerp_1
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_1,
				[armor_types.resistant] = damage_lerp_values.lerp_0_75,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_1,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_1,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
				[armor_types.void_shield] = damage_lerp_values.lerp_1
			}
		},
		far = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_0_7,
				[armor_types.armored] = damage_lerp_values.lerp_0_5,
				[armor_types.resistant] = damage_lerp_values.lerp_0_4,
				[armor_types.player] = damage_lerp_values.lerp_0_1,
				[armor_types.berserker] = damage_lerp_values.lerp_0_6,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_01,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_6,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_3
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_0_5,
				[armor_types.armored] = damage_lerp_values.lerp_0_5,
				[armor_types.resistant] = damage_lerp_values.lerp_0_5,
				[armor_types.player] = damage_lerp_values.no_damage,
				[armor_types.berserker] = damage_lerp_values.lerp_0_2,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_1,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_5,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_5
			}
		}
	},
	critical_strike = {
		gibbing_power = gibbing_power.heavy,
		gibbing_type = gibbing_types.ballistic
	},
	power_distribution = {
		attack = {
			250,
			500
		},
		impact = {
			20,
			60
		}
	},
	herding_template = HerdingTemplates.shotgun,
	damage_type = damage_types.rippergun_pellet,
	wounds_template = WoundsTemplates.rippergun,
	gibbing_power = gibbing_power.medium,
	gibbing_type = gibbing_types.ballistic,
	suppression_value = {
		0.05,
		1
	},
	on_kill_area_suppression = {
		suppression_value = {
			1,
			8
		},
		distance = {
			3,
			6
		}
	},
	targets = {
		default_target = {
			boost_curve_multiplier_finesse = 1.5,
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	},
	ragdoll_push_force = {
		50,
		50
	},
	gib_push_force = GibbingSettings.gib_push_force.ranged_heavy
}
damage_templates.default_rippergun_snp = {
	ragdoll_only = true,
	stagger_category = "ranged",
	ignore_stagger_reduction = true,
	cleave_distribution = double_cleave,
	ranges = {
		min = {
			6,
			15
		},
		max = {
			12,
			40
		}
	},
	armor_damage_modifier_ranged = {
		near = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_0_75,
				[armor_types.resistant] = damage_lerp_values.lerp_0_5,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_0_75,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_05,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
				[armor_types.void_shield] = damage_lerp_values.lerp_1
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_1,
				[armor_types.armored] = damage_lerp_values.lerp_1,
				[armor_types.resistant] = damage_lerp_values.lerp_0_75,
				[armor_types.player] = damage_lerp_values.lerp_1,
				[armor_types.berserker] = damage_lerp_values.lerp_1,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_1,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
				[armor_types.void_shield] = damage_lerp_values.lerp_1
			}
		},
		far = {
			attack = {
				[armor_types.unarmored] = damage_lerp_values.lerp_0_3,
				[armor_types.armored] = damage_lerp_values.lerp_0_25,
				[armor_types.resistant] = damage_lerp_values.lerp_0_25,
				[armor_types.player] = damage_lerp_values.lerp_0_1,
				[armor_types.berserker] = damage_lerp_values.lerp_0_3,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_01,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_3,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_3
			},
			impact = {
				[armor_types.unarmored] = damage_lerp_values.lerp_0_5,
				[armor_types.armored] = damage_lerp_values.lerp_0_5,
				[armor_types.resistant] = damage_lerp_values.lerp_0_5,
				[armor_types.player] = damage_lerp_values.no_damage,
				[armor_types.berserker] = damage_lerp_values.lerp_0_2,
				[armor_types.super_armor] = damage_lerp_values.lerp_0_1,
				[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_5,
				[armor_types.void_shield] = damage_lerp_values.lerp_0_5
			}
		}
	},
	critical_strike = {
		gibbing_power = gibbing_power.heavy,
		gibbing_type = gibbing_types.ballistic
	},
	power_distribution = {
		attack = {
			350,
			700
		},
		impact = {
			10,
			60
		}
	},
	herding_template = HerdingTemplates.shotgun,
	damage_type = damage_types.rippergun_pellet,
	wounds_template = WoundsTemplates.rippergun,
	gibbing_power = gibbing_power.medium,
	gibbing_type = gibbing_types.ballistic,
	suppression_value = {
		0.05,
		1
	},
	on_kill_area_suppression = {
		suppression_value = {
			1,
			8
		},
		distance = {
			3,
			6
		}
	},
	targets = {
		default_target = {
			boost_curve_multiplier_finesse = 0.5,
			boost_curve = PowerLevelSettings.boost_curves.default,
			finesse_boost = {
				[armor_types.unarmored] = 0.25
			}
		}
	},
	ragdoll_push_force = {
		50,
		50
	},
	gib_push_force = GibbingSettings.gib_push_force.ranged_heavy
}
damage_templates.rippergun_weapon_special = {
	ragdoll_push_force = 50,
	ragdoll_only = true,
	ignore_stagger_reduction = true,
	stagger_category = "flamer",
	cleave_distribution = double_cleave,
	damage_type = damage_types.combat_blade,
	gibbing_power = gibbing_power.light,
	gibbing_type = gibbing_types.sawing,
	melee_attack_strength = melee_attack_strengths.light,
	wounds_template = WoundsTemplates.combat_blade,
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_0_5,
			[armor_types.resistant] = damage_lerp_values.lerp_1,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_0_5,
			[armor_types.super_armor] = damage_lerp_values.no_damage,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
			[armor_types.void_shield] = damage_lerp_values.lerp_1
		},
		impact = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_1,
			[armor_types.resistant] = damage_lerp_values.lerp_1,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_0_5,
			[armor_types.super_armor] = damage_lerp_values.lerp_0_3,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
			[armor_types.void_shield] = damage_lerp_values.lerp_1
		}
	},
	targets = {
		{
			boost_curve_multiplier_finesse = 1.2,
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_1,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_5,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_75
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_1,
					[armor_types.resistant] = damage_lerp_values.lerp_2,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_1,
					[armor_types.super_armor] = damage_lerp_values.lerp_1,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_75
				}
			},
			power_distribution = {
				attack = 300,
				impact = 30
			},
			finesse_boost = {
				[armor_types.unarmored] = 0.25,
				[armor_types.armored] = 0.5,
				[armor_types.resistant] = 0.1,
				[armor_types.player] = 0.1,
				[armor_types.berserker] = 0.2,
				[armor_types.super_armor] = 0.1,
				[armor_types.disgustingly_resilient] = 0.25,
				[armor_types.void_shield] = 0.25
			}
		},
		{
			boost_curve_multiplier_finesse = 0.5,
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_5,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_5,
					[armor_types.super_armor] = damage_lerp_values.no_damage,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_5,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_5
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_1,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_5,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_5,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_5
				}
			},
			power_distribution = {
				attack = 50,
				impact = 12
			}
		},
		default_target = {
			boost_curve_multiplier_finesse = 0.5,
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_5,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_5,
					[armor_types.super_armor] = damage_lerp_values.no_damage,
					[armor_types.disgustingly_resilient] = damage_lerp_values.no_damage,
					[armor_types.void_shield] = 0
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.no_damage,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_5,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_25,
					[armor_types.disgustingly_resilient] = damage_lerp_values.no_damage,
					[armor_types.void_shield] = damage_lerp_values.no_damage
				}
			},
			power_distribution = {
				attack = 25,
				impact = 5
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
				[armor_types.void_shield] = 0.5
			}
		}
	},
	gib_push_force = GibbingSettings.gib_push_force.sawing_medium
}

return {
	base_templates = damage_templates,
	overrides = overrides
}
