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
local hammer_smiter_light_am = {
	attack = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1,
		[armor_types.armored] = damage_lerp_values.lerp_0_5,
		[armor_types.resistant] = damage_lerp_values.lerp_1,
		[armor_types.player] = damage_lerp_values.no_damage,
		[armor_types.berserker] = damage_lerp_values.lerp_0_5,
		[armor_types.super_armor] = damage_lerp_values.lerp_0_01,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_75,
		[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
		[armor_types.prop_armor] = damage_lerp_values.lerp_0_5
	},
	impact = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1,
		[armor_types.armored] = damage_lerp_values.lerp_0_75,
		[armor_types.resistant] = damage_lerp_values.lerp_1,
		[armor_types.player] = damage_lerp_values.no_damage,
		[armor_types.berserker] = damage_lerp_values.lerp_0_5,
		[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_75,
		[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
		[armor_types.prop_armor] = damage_lerp_values.lerp_0_75
	}
}
local hammer_smiter_light_active_am = {
	attack = {
		[armor_types.unarmored] = damage_lerp_values.lerp_2,
		[armor_types.armored] = damage_lerp_values.lerp_2,
		[armor_types.resistant] = {
			2,
			3
		},
		[armor_types.player] = damage_lerp_values.no_damage,
		[armor_types.berserker] = damage_lerp_values.lerp_2,
		[armor_types.super_armor] = damage_lerp_values.lerp_2,
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
local hammer_smiter_light_default_am = {
	attack = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1,
		[armor_types.armored] = damage_lerp_values.lerp_0_5,
		[armor_types.resistant] = damage_lerp_values.lerp_1,
		[armor_types.player] = damage_lerp_values.no_damage,
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
		[armor_types.player] = damage_lerp_values.no_damage,
		[armor_types.berserker] = damage_lerp_values.lerp_0_5,
		[armor_types.super_armor] = damage_lerp_values.lerp_1,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_75,
		[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
		[armor_types.prop_armor] = damage_lerp_values.lerp_1
	}
}
local hammer_tank_heavy_first_am = {
	attack = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1,
		[armor_types.armored] = damage_lerp_values.lerp_0_75,
		[armor_types.resistant] = damage_lerp_values.lerp_1,
		[armor_types.player] = damage_lerp_values.no_damage,
		[armor_types.berserker] = damage_lerp_values.lerp_0_5,
		[armor_types.super_armor] = damage_lerp_values.lerp_0_2,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
		[armor_types.void_shield] = damage_lerp_values.lerp_1,
		[armor_types.prop_armor] = damage_lerp_values.lerp_0_75
	},
	impact = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1,
		[armor_types.armored] = damage_lerp_values.lerp_1,
		[armor_types.resistant] = damage_lerp_values.lerp_1,
		[armor_types.player] = damage_lerp_values.no_damage,
		[armor_types.berserker] = damage_lerp_values.lerp_0_5,
		[armor_types.super_armor] = damage_lerp_values.lerp_1,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
		[armor_types.void_shield] = damage_lerp_values.lerp_1,
		[armor_types.prop_armor] = damage_lerp_values.lerp_1
	}
}
local hammer_tank_heavy_first_active_am = {
	attack = {
		[armor_types.unarmored] = damage_lerp_values.lerp_2,
		[armor_types.armored] = damage_lerp_values.lerp_2,
		[armor_types.resistant] = {
			3,
			5
		},
		[armor_types.player] = damage_lerp_values.no_damage,
		[armor_types.berserker] = damage_lerp_values.lerp_2,
		[armor_types.super_armor] = damage_lerp_values.lerp_2,
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
local hammer_tank_heavy_am = {
	attack = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1,
		[armor_types.armored] = damage_lerp_values.no_damage,
		[armor_types.resistant] = damage_lerp_values.lerp_1,
		[armor_types.player] = damage_lerp_values.no_damage,
		[armor_types.berserker] = damage_lerp_values.lerp_0_5,
		[armor_types.super_armor] = damage_lerp_values.no_damage,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
		[armor_types.void_shield] = damage_lerp_values.lerp_1,
		[armor_types.prop_armor] = damage_lerp_values.no_damage
	},
	impact = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1,
		[armor_types.armored] = damage_lerp_values.lerp_1,
		[armor_types.resistant] = damage_lerp_values.lerp_1,
		[armor_types.player] = damage_lerp_values.no_damage,
		[armor_types.berserker] = damage_lerp_values.lerp_0_5,
		[armor_types.super_armor] = damage_lerp_values.lerp_1,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
		[armor_types.void_shield] = damage_lerp_values.lerp_1,
		[armor_types.prop_armor] = damage_lerp_values.lerp_1
	}
}
damage_templates.thunderhammer_light = {
	finesse_ability_damage_multiplier = 1.5,
	ragdoll_push_force = 500,
	ragdoll_only = true,
	stagger_category = "melee",
	cleave_distribution = {
		attack = 0.01,
		impact = 0.01
	},
	damage_type = damage_types.blunt_thunder,
	gibbing_power = GibbingPower.light,
	gibbing_type = GibbingTypes.crushing,
	melee_attack_strength = melee_attack_strengths.light,
	wounds_template = WoundsTemplates.thunder_hammer,
	armor_damage_modifier = hammer_smiter_light_default_am,
	stagger_duration_modifier = {
		0.1,
		0.5
	},
	targets = {
		{
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_75,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
					[armor_types.player] = damage_lerp_values.no_damage,
					[armor_types.berserker] = damage_lerp_values.lerp_0_5,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_01,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_75,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
					[armor_types.prop_armor] = damage_lerp_values.lerp_0_75
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_75,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
					[armor_types.player] = damage_lerp_values.no_damage,
					[armor_types.berserker] = damage_lerp_values.lerp_0_5,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_75,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_75,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
					[armor_types.prop_armor] = damage_lerp_values.lerp_0_75
				}
			},
			power_distribution = {
				attack = {
					80,
					160
				},
				impact = {
					15,
					45
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
			},
			boost_curve_multiplier_finesse = {
				0.25,
				0.75
			},
			power_level_multiplier = {
				0.75,
				1.25
			}
		},
		{
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = {
					15,
					25
				},
				impact = {
					9,
					11
				}
			}
		},
		default_target = {
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = {
					8,
					12
				},
				impact = {
					5,
					5
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
	}
}
damage_templates.thunderhammer_light_active = {
	weapon_special = true,
	finesse_ability_damage_multiplier = 1.5,
	shield_override_stagger_strength = 500,
	ragdoll_push_force = 1000,
	ragdoll_only = true,
	stagger_category = "melee",
	cleave_distribution = {
		attack = 0.01,
		impact = 0.01
	},
	damage_type = damage_types.blunt_thunder,
	gibbing_power = GibbingPower.medium,
	gibbing_type = GibbingTypes.default,
	melee_attack_strength = melee_attack_strengths.light,
	wounds_template = WoundsTemplates.thunder_hammer_active,
	armor_damage_modifier = hammer_smiter_light_default_am,
	targets = {
		{
			boost_curve_multiplier_finesse = 0.25,
			armor_damage_modifier = hammer_smiter_light_active_am,
			power_distribution = {
				attack = {
					200,
					300
				},
				impact = {
					25,
					35
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
			},
			power_level_multiplier = {
				0.75,
				1.25
			}
		},
		{
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = {
					15,
					25
				},
				impact = {
					8,
					12
				}
			}
		},
		default_target = {
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = {
					8,
					12
				},
				impact = {
					4,
					6
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
	}
}
overrides.thunderhammer_pushfollow_active = {
	parent_template_name = "thunderhammer_light_active",
	overrides = {
		{
			"cleave_distribution",
			"attack",
			0.01
		},
		{
			"cleave_distribution",
			"impact",
			0.01
		}
	}
}
overrides.thunderhammer_pushfollow = {
	parent_template_name = "thunderhammer_light",
	overrides = {
		{
			"cleave_distribution",
			"attack",
			0.1
		},
		{
			"cleave_distribution",
			"impact",
			0.1
		},
		{
			"ragdoll_push_force",
			250
		}
	}
}
damage_templates.thunderhammer_heavy = {
	finesse_ability_damage_multiplier = 1.5,
	ragdoll_push_force = 750,
	ragdoll_only = true,
	stagger_category = "melee",
	armor_damage_modifier = hammer_tank_heavy_am,
	cleave_distribution = {
		attack = {
			20,
			30
		},
		impact = {
			20,
			30
		}
	},
	damage_type = damage_types.blunt_thunder,
	gibbing_power = GibbingPower.light,
	gibbing_type = GibbingTypes.crushing,
	melee_attack_strength = melee_attack_strengths.heavy,
	wounds_template = WoundsTemplates.thunder_hammer,
	targets = {
		{
			armor_damage_modifier = hammer_tank_heavy_first_am,
			power_distribution = {
				attack = {
					100,
					200
				},
				impact = {
					45,
					55
				}
			},
			boost_curve_multiplier_finesse = {
				0.25,
				0.75
			},
			power_level_multiplier = {
				0.75,
				1.25
			}
		},
		{
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = {
					35,
					65
				},
				impact = {
					25,
					35
				}
			}
		},
		{
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = {
					10,
					40
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
					0,
					0
				},
				impact = {
					10,
					20
				}
			}
		},
		{
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = {
					0,
					0
				},
				impact = {
					10,
					20
				}
			}
		},
		default_target = {
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = {
					0,
					0
				},
				impact = {
					5,
					15
				}
			},
			armor_damage_modifier = hammer_tank_heavy_am,
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.thunderhammer_heavy_active = {
	shield_override_stagger_strength = 500,
	finesse_ability_damage_multiplier = 1.5,
	weapon_special = true,
	ragdoll_push_force = 1000,
	ragdoll_only = true,
	stagger_category = "melee",
	armor_damage_modifier = hammer_tank_heavy_am,
	cleave_distribution = {
		attack = 0.01,
		impact = 0.01
	},
	damage_type = damage_types.blunt_thunder,
	gibbing_power = GibbingPower.heavy,
	gibbing_type = GibbingTypes.explosion,
	melee_attack_strength = melee_attack_strengths.heavy,
	wounds_template = WoundsTemplates.thunder_hammer_active,
	targets = {
		{
			boost_curve_multiplier_finesse = 0.25,
			armor_damage_modifier = hammer_tank_heavy_first_active_am,
			power_distribution = {
				attack = {
					300,
					500
				},
				impact = {
					45,
					55
				}
			},
			power_level_multiplier = {
				0.75,
				1.25
			}
		},
		{
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = {
					35,
					65
				},
				impact = {
					25,
					35
				}
			}
		},
		{
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = {
					10,
					40
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
					0,
					0
				},
				impact = {
					10,
					20
				}
			}
		},
		{
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = {
					0,
					0
				},
				impact = {
					10,
					20
				}
			}
		},
		default_target = {
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = {
					0,
					0
				},
				impact = {
					5,
					15
				}
			},
			armor_damage_modifier = hammer_tank_heavy_am,
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}

return {
	base_templates = damage_templates,
	overrides = overrides
}
