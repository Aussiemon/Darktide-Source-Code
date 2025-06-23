-- chunkname: @scripts/settings/equipment/weapon_templates/force_swords_2h/settings_templates/force_sword_2h_damage_profile_templates.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local DamageProfileSettings = require("scripts/settings/damage/damage_profile_settings")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local GibbingSettings = require("scripts/settings/gibbing/gibbing_settings")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local WoundsTemplates = require("scripts/settings/damage/wounds_templates")
local armor_types = ArmorSettings.types
local damage_lerp_values = DamageProfileSettings.damage_lerp_values
local damage_types = DamageSettings.damage_types
local gibbing_power = GibbingSettings.gibbing_power
local gibbing_types = GibbingSettings.gibbing_types
local melee_attack_strengths = AttackSettings.melee_attack_strength
local large_cleave = DamageProfileSettings.large_cleave
local medium_cleave = DamageProfileSettings.medium_cleave
local single_cleave = DamageProfileSettings.single_cleave
local damage_templates = {}
local overrides = {}

table.make_unique(damage_templates)
table.make_unique(overrides)

local DEFAULT_SHIELD_OVERRIDE_STAGGER_STRENGTH = 4
local weapon_special_am = {
	attack = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1,
		[armor_types.armored] = damage_lerp_values.lerp_0_9,
		[armor_types.resistant] = damage_lerp_values.lerp_1_75,
		[armor_types.player] = damage_lerp_values.no_damage,
		[armor_types.berserker] = damage_lerp_values.lerp_1,
		[armor_types.super_armor] = damage_lerp_values.lerp_0_7,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
		[armor_types.void_shield] = damage_lerp_values.lerp_0_75
	},
	impact = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1,
		[armor_types.armored] = damage_lerp_values.lerp_1,
		[armor_types.resistant] = damage_lerp_values.lerp_1,
		[armor_types.player] = damage_lerp_values.lerp_1,
		[armor_types.berserker] = damage_lerp_values.lerp_1,
		[armor_types.super_armor] = damage_lerp_values.lerp_1,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
		[armor_types.void_shield] = damage_lerp_values.lerp_1
	}
}

damage_templates.light_force_sword_2h_linesman = {
	sticky_attack = false,
	force_weapon_damage = true,
	ragdoll_push_force = 50,
	stagger_category = "melee",
	cleave_distribution = medium_cleave,
	gibbing_power = gibbing_power.light,
	gibbing_type = gibbing_types.sawing,
	melee_attack_strength = melee_attack_strengths.light,
	gib_push_force = GibbingSettings.gib_push_force.force_sword,
	wounds_template = WoundsTemplates.force_sword,
	shield_override_stagger_strength = DEFAULT_SHIELD_OVERRIDE_STAGGER_STRENGTH,
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_0_75,
			[armor_types.resistant] = damage_lerp_values.lerp_1,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_0_8,
			[armor_types.super_armor] = damage_lerp_values.lerp_0_01,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
			[armor_types.void_shield] = damage_lerp_values.lerp_1
		},
		impact = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_1,
			[armor_types.resistant] = damage_lerp_values.lerp_1,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_0_5,
			[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
			[armor_types.void_shield] = damage_lerp_values.lerp_1
		}
	},
	targets = {
		{
			power_distribution = {
				attack = {
					75,
					160
				},
				impact = {
					4,
					8
				}
			},
			boost_curve_multiplier_finesse = {
				1,
				2
			},
			power_level_multiplier = {
				0.8,
				1.6
			}
		},
		{
			power_distribution = {
				attack = {
					60,
					130
				},
				impact = {
					3,
					6
				}
			}
		},
		{
			power_distribution = {
				attack = {
					40,
					110
				},
				impact = {
					2,
					4
				}
			}
		},
		{
			power_distribution = {
				attack = {
					30,
					60
				},
				impact = {
					2,
					4
				}
			}
		},
		default_target = {
			power_distribution = {
				attack = {
					20,
					30
				},
				impact = {
					1.5,
					3
				}
			},
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.light_force_sword_2h_uppercut = {
	sticky_attack = false,
	force_weapon_damage = true,
	ragdoll_push_force = 50,
	stagger_category = "melee",
	cleave_distribution = medium_cleave,
	gibbing_power = gibbing_power.light,
	gibbing_type = gibbing_types.sawing,
	melee_attack_strength = melee_attack_strengths.light,
	gib_push_force = GibbingSettings.gib_push_force.force_sword,
	wounds_template = WoundsTemplates.force_sword,
	shield_override_stagger_strength = DEFAULT_SHIELD_OVERRIDE_STAGGER_STRENGTH,
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_0_75,
			[armor_types.resistant] = damage_lerp_values.lerp_1,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_0_8,
			[armor_types.super_armor] = damage_lerp_values.lerp_0_01,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
			[armor_types.void_shield] = damage_lerp_values.lerp_1
		},
		impact = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_1,
			[armor_types.resistant] = damage_lerp_values.lerp_1,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_0_5,
			[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
			[armor_types.void_shield] = damage_lerp_values.lerp_1
		}
	},
	targets = {
		{
			power_distribution = {
				attack = {
					75,
					160
				},
				impact = {
					4,
					8
				}
			},
			boost_curve_multiplier_finesse = {
				1.2,
				3.3
			},
			power_level_multiplier = {
				0.8,
				1.6
			}
		},
		{
			power_distribution = {
				attack = {
					60,
					130
				},
				impact = {
					3,
					6
				}
			},
			boost_curve_multiplier_finesse = {
				1,
				3
			}
		},
		{
			power_distribution = {
				attack = {
					40,
					110
				},
				impact = {
					2,
					4
				}
			}
		},
		{
			power_distribution = {
				attack = {
					30,
					60
				},
				impact = {
					2,
					4
				}
			}
		},
		default_target = {
			power_distribution = {
				attack = {
					20,
					30
				},
				impact = {
					1.5,
					3
				}
			},
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.light_force_sword_2h_smiter = {
	sticky_attack = false,
	force_weapon_damage = true,
	ragdoll_push_force = 50,
	stagger_category = "melee",
	cleave_distribution = single_cleave,
	gibbing_power = gibbing_power.light,
	gibbing_type = gibbing_types.sawing,
	melee_attack_strength = melee_attack_strengths.light,
	gib_push_force = GibbingSettings.gib_push_force.force_sword,
	wounds_template = WoundsTemplates.force_sword,
	shield_override_stagger_strength = DEFAULT_SHIELD_OVERRIDE_STAGGER_STRENGTH,
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_0_9,
			[armor_types.resistant] = damage_lerp_values.lerp_1,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_1,
			[armor_types.super_armor] = damage_lerp_values.lerp_0_3,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
			[armor_types.void_shield] = damage_lerp_values.lerp_1
		},
		impact = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_1,
			[armor_types.resistant] = damage_lerp_values.lerp_1,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_0_5,
			[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
			[armor_types.void_shield] = damage_lerp_values.lerp_1
		}
	},
	targets = {
		{
			power_distribution = {
				attack = {
					110,
					220
				},
				impact = {
					4,
					8
				}
			},
			boost_curve_multiplier_finesse = {
				1,
				3
			},
			power_level_multiplier = {
				1,
				2
			}
		},
		{
			power_distribution = {
				attack = {
					60,
					130
				},
				impact = {
					3,
					6
				}
			}
		},
		default_target = {
			power_distribution = {
				attack = {
					20,
					30
				},
				impact = {
					1.5,
					3
				}
			},
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
overrides.light_force_sword_2h_special = {
	parent_template_name = "light_force_sword_2h_linesman",
	overrides = {
		{
			"armor_damage_modifier",
			weapon_special_am
		},
		{
			"cleave_distribution",
			"attack",
			math.huge
		},
		{
			"cleave_distribution",
			"impact",
			math.huge
		},
		{
			"targets",
			1,
			"power_distribution",
			"attack",
			{
				100,
				200
			}
		},
		{
			"targets",
			2,
			"power_distribution",
			"attack",
			{
				80,
				150
			}
		}
	}
}
overrides.heavy_force_sword_2h_special = {
	parent_template_name = "heavy_force_sword_2h_linesman",
	overrides = {
		{
			"armor_damage_modifier",
			weapon_special_am
		},
		{
			"cleave_distribution",
			"attack",
			math.huge
		},
		{
			"cleave_distribution",
			"impact",
			math.huge
		},
		{
			"targets",
			1,
			"power_distribution",
			"attack",
			{
				150,
				375
			}
		},
		{
			"targets",
			2,
			"power_distribution",
			"attack",
			{
				125,
				300
			}
		},
		{
			"targets",
			3,
			"power_distribution",
			"attack",
			{
				100,
				200
			}
		},
		{
			"targets",
			4,
			"power_distribution",
			"attack",
			{
				60,
				120
			}
		}
	}
}
damage_templates.light_force_sword_stab_2h = {
	sticky_attack = false,
	force_weapon_damage = true,
	ragdoll_push_force = 50,
	gibbing_power = 0,
	stagger_category = "melee",
	cleave_distribution = single_cleave,
	gibbing_type = gibbing_types.sawing,
	wounds_template = WoundsTemplates.force_sword,
	melee_attack_strength = melee_attack_strengths.light,
	gib_push_force = GibbingSettings.gib_push_force.force_sword,
	shield_override_stagger_strength = DEFAULT_SHIELD_OVERRIDE_STAGGER_STRENGTH,
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_1,
			[armor_types.resistant] = damage_lerp_values.lerp_1,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_0_9,
			[armor_types.super_armor] = damage_lerp_values.lerp_0_4,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
			[armor_types.void_shield] = damage_lerp_values.lerp_1
		},
		impact = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_0_5,
			[armor_types.resistant] = damage_lerp_values.lerp_1,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_0_5,
			[armor_types.super_armor] = damage_lerp_values.no_damage,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_75,
			[armor_types.void_shield] = damage_lerp_values.lerp_0_75
		}
	},
	targets = {
		{
			power_distribution = {
				attack = {
					110,
					220
				},
				impact = {
					5,
					10
				}
			},
			boost_curve_multiplier_finesse = {
				1,
				3
			},
			power_level_multiplier = {
				1.2,
				2.4
			}
		},
		{
			power_distribution = {
				attack = {
					35,
					65
				},
				impact = {
					5,
					10
				}
			}
		},
		default_target = {
			power_distribution = {
				attack = {
					15,
					45
				},
				impact = {
					4,
					8
				}
			},
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.heavy_force_sword_stab_2h = {
	sticky_attack = false,
	force_weapon_damage = true,
	ragdoll_push_force = 50,
	gibbing_power = 0,
	stagger_category = "melee",
	cleave_distribution = single_cleave,
	gibbing_type = gibbing_types.sawing,
	wounds_template = WoundsTemplates.force_sword,
	melee_attack_strength = melee_attack_strengths.heavy,
	gib_push_force = GibbingSettings.gib_push_force.force_sword,
	shield_override_stagger_strength = DEFAULT_SHIELD_OVERRIDE_STAGGER_STRENGTH,
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_1,
			[armor_types.resistant] = damage_lerp_values.lerp_1_25,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_0_9,
			[armor_types.super_armor] = damage_lerp_values.lerp_0_75,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
			[armor_types.void_shield] = damage_lerp_values.lerp_1
		},
		impact = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_0_5,
			[armor_types.resistant] = damage_lerp_values.lerp_1,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_0_5,
			[armor_types.super_armor] = damage_lerp_values.lerp_0_2,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_75,
			[armor_types.void_shield] = damage_lerp_values.lerp_0_75
		}
	},
	targets = {
		{
			power_distribution = {
				attack = {
					240,
					480
				},
				impact = {
					8,
					12
				}
			},
			boost_curve_multiplier_finesse = {
				1,
				2.2
			},
			power_level_multiplier = {
				1.2,
				2.4
			}
		},
		{
			power_distribution = {
				attack = {
					150,
					300
				},
				impact = {
					8,
					12
				}
			}
		},
		{
			power_distribution = {
				attack = {
					100,
					200
				},
				impact = {
					6,
					10
				}
			}
		},
		default_target = {
			power_distribution = {
				attack = {
					30,
					60
				},
				impact = {
					4,
					8
				}
			},
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.heavy_force_sword_2h_smiter = {
	sticky_attack = false,
	force_weapon_damage = true,
	ragdoll_push_force = 300,
	stagger_category = "melee",
	cleave_distribution = single_cleave,
	gibbing_power = gibbing_power.medium,
	gibbing_type = gibbing_types.sawing,
	melee_attack_strength = melee_attack_strengths.heavy,
	wounds_template = WoundsTemplates.force_sword,
	gib_push_force = GibbingSettings.gib_push_force.force_sword,
	shield_override_stagger_strength = DEFAULT_SHIELD_OVERRIDE_STAGGER_STRENGTH,
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_1,
			[armor_types.resistant] = damage_lerp_values.lerp_1,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_1,
			[armor_types.super_armor] = damage_lerp_values.lerp_0_75,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
			[armor_types.void_shield] = damage_lerp_values.lerp_1
		},
		impact = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_0_5,
			[armor_types.resistant] = damage_lerp_values.lerp_1,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_0_5,
			[armor_types.super_armor] = damage_lerp_values.lerp_1,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_75,
			[armor_types.void_shield] = damage_lerp_values.lerp_1
		}
	},
	targets = {
		{
			power_distribution = {
				attack = {
					200,
					400
				},
				impact = {
					12,
					20
				}
			},
			boost_curve_multiplier_finesse = {
				0.5,
				2
			},
			power_level_multiplier = {
				1,
				2
			}
		},
		default_target = {
			power_distribution = {
				attack = {
					35,
					65
				},
				impact = {
					2,
					4
				}
			},
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.heavy_force_sword_2h_linesman = {
	sticky_attack = false,
	force_weapon_damage = true,
	ragdoll_push_force = 300,
	stagger_category = "melee",
	cleave_distribution = large_cleave,
	gibbing_power = gibbing_power.medium,
	gibbing_type = gibbing_types.sawing,
	melee_attack_strength = melee_attack_strengths.heavy,
	wounds_template = WoundsTemplates.force_sword,
	gib_push_force = GibbingSettings.gib_push_force.force_sword,
	shield_override_stagger_strength = DEFAULT_SHIELD_OVERRIDE_STAGGER_STRENGTH,
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_0_8,
			[armor_types.resistant] = damage_lerp_values.lerp_1,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_0_9,
			[armor_types.super_armor] = damage_lerp_values.lerp_0_25,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
			[armor_types.void_shield] = damage_lerp_values.lerp_1
		},
		impact = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_0_5,
			[armor_types.resistant] = damage_lerp_values.lerp_1,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_0_5,
			[armor_types.super_armor] = damage_lerp_values.lerp_1,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_75,
			[armor_types.void_shield] = damage_lerp_values.lerp_1
		}
	},
	targets = {
		{
			power_distribution = {
				attack = {
					125,
					250
				},
				impact = {
					12,
					22
				}
			},
			boost_curve_multiplier_finesse = {
				0.5,
				2
			},
			power_level_multiplier = {
				1,
				2
			}
		},
		{
			power_distribution = {
				attack = {
					115,
					225
				},
				impact = {
					5,
					10
				}
			},
			boost_curve_multiplier_finesse = {
				0.5,
				1
			}
		},
		{
			power_distribution = {
				attack = {
					90,
					180
				},
				impact = {
					3,
					6
				}
			}
		},
		{
			power_distribution = {
				attack = {
					60,
					120
				},
				impact = {
					3,
					6
				}
			}
		},
		default_target = {
			power_distribution = {
				attack = {
					35,
					65
				},
				impact = {
					2,
					4
				}
			},
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.forcesword_force_slash_low = {
	suppression_value = 30,
	ignore_shield = true,
	suppression_type = "ability",
	stagger_duration_modifier = 1,
	ignore_stagger_reduction = true,
	stagger_category = "melee",
	power_distribution = {
		attack = 100,
		impact = 15
	},
	ranges = {
		max = 16,
		min = 8
	},
	armor_damage_modifier_ranged = {
		near = {
			attack = {
				[armor_types.unarmored] = 1,
				[armor_types.armored] = 0.9,
				[armor_types.resistant] = 1,
				[armor_types.player] = 1,
				[armor_types.berserker] = 1,
				[armor_types.super_armor] = 0.7,
				[armor_types.disgustingly_resilient] = 1,
				[armor_types.void_shield] = 0.75
			},
			impact = {
				[armor_types.unarmored] = 1,
				[armor_types.armored] = 1,
				[armor_types.resistant] = 1,
				[armor_types.player] = 1,
				[armor_types.berserker] = 1,
				[armor_types.super_armor] = 1,
				[armor_types.disgustingly_resilient] = 1,
				[armor_types.void_shield] = 1
			}
		},
		far = {
			attack = {
				[armor_types.unarmored] = 0.1,
				[armor_types.armored] = 0.1,
				[armor_types.resistant] = 0.1,
				[armor_types.player] = 0.1,
				[armor_types.berserker] = 0.1,
				[armor_types.super_armor] = 0.1,
				[armor_types.disgustingly_resilient] = 0.1,
				[armor_types.void_shield] = 0.1
			},
			impact = {
				[armor_types.unarmored] = 0.5,
				[armor_types.armored] = 0.5,
				[armor_types.resistant] = 0.5,
				[armor_types.player] = 0.5,
				[armor_types.berserker] = 0.5,
				[armor_types.super_armor] = 0.5,
				[armor_types.disgustingly_resilient] = 0.5,
				[armor_types.void_shield] = 0.5
			}
		}
	},
	damage_type = damage_types.psyker_biomancer_discharge,
	gibbing_power = gibbing_power.light,
	gibbing_type = gibbing_types.warp,
	targets = {
		default_target = {}
	}
}
overrides.forcesword_force_slash_middle = {
	parent_template_name = "forcesword_force_slash_low",
	overrides = {
		{
			"power_distribution",
			"attack",
			450
		},
		{
			"power_distribution",
			"impact",
			20
		},
		{
			"gibbing_power",
			gibbing_power.medium
		},
		{
			"ranges",
			"min",
			10
		},
		{
			"ranges",
			"max",
			18
		}
	}
}
overrides.forcesword_force_slash_high = {
	parent_template_name = "forcesword_force_slash_low",
	overrides = {
		{
			"power_distribution",
			"attack",
			850
		},
		{
			"power_distribution",
			"impact",
			40
		},
		{
			"gibbing_power",
			gibbing_power.heavy
		},
		{
			"gibbing_type",
			gibbing_types.warp_wind_slash_high
		},
		{
			"ranges",
			"min",
			12
		},
		{
			"ranges",
			"max",
			20
		}
	}
}

return {
	base_templates = damage_templates,
	overrides = overrides
}
