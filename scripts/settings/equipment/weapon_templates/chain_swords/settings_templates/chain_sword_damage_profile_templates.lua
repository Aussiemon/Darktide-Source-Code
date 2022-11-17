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
local no_cleave = DamageProfileSettings.no_cleave
local single_cleave = DamageProfileSettings.single_cleave
local double_cleave = DamageProfileSettings.double_cleave
local light_cleave = DamageProfileSettings.light_cleave
local medium_cleave = DamageProfileSettings.medium_cleave
local big_cleave = DamageProfileSettings.big_cleave
local chainsword_sawing = {
	attack = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1,
		[armor_types.armored] = damage_lerp_values.lerp_1,
		[armor_types.resistant] = damage_lerp_values.lerp_1_5,
		[armor_types.player] = damage_lerp_values.lerp_1,
		[armor_types.berserker] = damage_lerp_values.lerp_1,
		[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
		[armor_types.void_shield] = damage_lerp_values.lerp_1,
		[armor_types.prop_armor] = damage_lerp_values.lerp_1
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
local chain_sword_crit_mod = {
	attack = {
		[armor_types.unarmored] = 0,
		[armor_types.armored] = 0.3,
		[armor_types.resistant] = 0,
		[armor_types.player] = 0,
		[armor_types.berserker] = 0,
		[armor_types.super_armor] = 0.2,
		[armor_types.disgustingly_resilient] = 0,
		[armor_types.void_shield] = 0,
		[armor_types.prop_armor] = 0
	},
	impact = {
		[armor_types.unarmored] = 0,
		[armor_types.armored] = 0,
		[armor_types.resistant] = 0,
		[armor_types.player] = 0,
		[armor_types.berserker] = 0,
		[armor_types.super_armor] = 0.5,
		[armor_types.disgustingly_resilient] = 0,
		[armor_types.void_shield] = 0,
		[armor_types.prop_armor] = 0
	}
}
local just_one = {
	0.75,
	1.25
}
local chain_sword_light_mod = {
	attack = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1,
		[armor_types.armored] = damage_lerp_values.lerp_0_5,
		[armor_types.resistant] = damage_lerp_values.lerp_1,
		[armor_types.player] = damage_lerp_values.lerp_1,
		[armor_types.berserker] = damage_lerp_values.lerp_0_5,
		[armor_types.super_armor] = damage_lerp_values.no_damage,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_75,
		[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
		[armor_types.prop_armor] = damage_lerp_values.lerp_0_75
	},
	impact = {
		[armor_types.unarmored] = damage_lerp_values.lerp_0_75,
		[armor_types.armored] = damage_lerp_values.lerp_1,
		[armor_types.resistant] = damage_lerp_values.lerp_1,
		[armor_types.player] = damage_lerp_values.lerp_1,
		[armor_types.berserker] = damage_lerp_values.lerp_0_75,
		[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_75,
		[armor_types.void_shield] = damage_lerp_values.lerp_1,
		[armor_types.prop_armor] = damage_lerp_values.lerp_1
	}
}
local chain_sword_light_smiter_mod = {
	attack = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1,
		[armor_types.armored] = damage_lerp_values.lerp_0_75,
		[armor_types.resistant] = damage_lerp_values.lerp_1,
		[armor_types.player] = damage_lerp_values.lerp_1,
		[armor_types.berserker] = damage_lerp_values.lerp_0_5,
		[armor_types.super_armor] = damage_lerp_values.lerp_0_25,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_75,
		[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
		[armor_types.prop_armor] = damage_lerp_values.lerp_0_75
	},
	impact = {
		[armor_types.unarmored] = damage_lerp_values.lerp_0_75,
		[armor_types.armored] = damage_lerp_values.lerp_1,
		[armor_types.resistant] = damage_lerp_values.lerp_1,
		[armor_types.player] = damage_lerp_values.lerp_1,
		[armor_types.berserker] = damage_lerp_values.lerp_0_75,
		[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_75,
		[armor_types.void_shield] = damage_lerp_values.lerp_1,
		[armor_types.prop_armor] = damage_lerp_values.lerp_1
	}
}
local chain_sword_heavy_mod = {
	attack = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1,
		[armor_types.armored] = damage_lerp_values.lerp_0_6,
		[armor_types.resistant] = damage_lerp_values.lerp_1,
		[armor_types.player] = damage_lerp_values.lerp_1,
		[armor_types.berserker] = damage_lerp_values.lerp_1,
		[armor_types.super_armor] = damage_lerp_values.no_damage,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
		[armor_types.void_shield] = damage_lerp_values.lerp_1,
		[armor_types.prop_armor] = damage_lerp_values.lerp_0_6
	},
	impact = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1,
		[armor_types.armored] = damage_lerp_values.lerp_1,
		[armor_types.resistant] = damage_lerp_values.lerp_1,
		[armor_types.player] = damage_lerp_values.lerp_1,
		[armor_types.berserker] = damage_lerp_values.lerp_1_75,
		[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
		[armor_types.void_shield] = damage_lerp_values.lerp_1,
		[armor_types.prop_armor] = damage_lerp_values.lerp_1
	}
}
damage_templates.heavy_chainsword = {
	sticky_attack = false,
	ragdoll_push_force = 600,
	finesse_ability_damage_multiplier = 1.5,
	ragdoll_only = true,
	stagger_category = "melee",
	crit_mod = chain_sword_crit_mod,
	cleave_distribution = medium_cleave,
	damage_type = damage_types.sawing,
	gibbing_power = GibbingPower.medium,
	gibbing_type = GibbingTypes.default,
	melee_attack_strength = melee_attack_strengths.heavy,
	gib_push_force = GibbingSettings.gib_push_force.sawing_heavy,
	wounds_template = WoundsTemplates.chainsword,
	stagger_duration_modifier = {
		0.1,
		0.5
	},
	armor_damage_modifier = chain_sword_heavy_mod,
	targets = {
		{
			armor_damage_modifier = {
				attack = {
					[armor_types.armored] = damage_lerp_values.lerp_0_6,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_4
				},
				impact = {
					[armor_types.super_armor] = damage_lerp_values.lerp_1
				}
			},
			power_distribution = {
				attack = {
					100,
					200
				},
				impact = {
					8,
					16
				}
			},
			boost_curve_multiplier_finesse = damage_lerp_values.lerp_0_5,
			power_level_multiplier = {
				0.6,
				1.4
			}
		},
		{
			armor_damage_modifier = {
				attack = {
					[armor_types.armored] = damage_lerp_values.lerp_1
				},
				impact = {
					[armor_types.super_armor] = damage_lerp_values.lerp_0_65
				}
			},
			power_distribution = {
				attack = {
					75,
					150
				},
				impact = {
					6,
					12
				}
			}
		},
		default_target = {
			armor_damage_modifier = chain_sword_heavy_mod,
			power_distribution = {
				attack = {
					20,
					40
				},
				impact = {
					5,
					10
				}
			},
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
overrides.heavy_chainsword_active = {
	parent_template_name = "heavy_chainsword",
	overrides = {
		{
			"stagger_category",
			"melee"
		},
		{
			"stagger_override",
			"light"
		},
		{
			"shield_stagger_category",
			"melee"
		},
		{
			"ignore_stagger_reduction",
			true
		},
		{
			"damage_type",
			damage_types.sawing_stuck
		},
		{
			"ignore_instant_ragdoll_chance",
			true
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
			1,
			"power_distribution",
			"impact",
			{
				10,
				20
			}
		},
		{
			"targets",
			1,
			"power_level_multiplier",
			{
				0.5,
				1.5
			}
		},
		{
			"targets",
			1,
			"boost_curve_multiplier_finesse",
			{
				0.2,
				0.6
			}
		},
		{
			"cleave_distribution",
			no_cleave
		},
		{
			"gibbing_power",
			GibbingPower.heavy
		},
		{
			"gibbing_type",
			GibbingTypes.sawing
		},
		{
			"wounds_template",
			WoundsTemplates.chainsword_sawing
		},
		{
			"targets",
			1,
			"armor_damage_modifier",
			chainsword_sawing
		},
		{
			"weapon_special",
			true
		}
	}
}
overrides.heavy_chainsword_sticky = {
	parent_template_name = "heavy_chainsword",
	overrides = {
		{
			"stagger_category",
			"sticky"
		},
		{
			"stagger_override",
			"sticky"
		},
		{
			"shield_stagger_category",
			"sticky"
		},
		{
			"ignore_stagger_reduction",
			true
		},
		{
			"damage_type",
			damage_types.sawing_stuck
		},
		{
			"sticky_attack",
			true
		},
		{
			"ignore_instant_ragdoll_chance",
			true
		},
		{
			"gibbing_power",
			GibbingPower.heavy
		},
		{
			"gibbing_type",
			GibbingTypes.sawing
		},
		{
			"wounds_template"
		},
		{
			"targets",
			1,
			"power_distribution",
			"attack",
			{
				75,
				150
			}
		},
		{
			"targets",
			1,
			"power_distribution",
			"impact",
			{
				10,
				20
			}
		},
		{
			"targets",
			1,
			"power_level_multiplier",
			{
				0.5,
				1.5
			}
		},
		{
			"targets",
			1,
			"boost_curve_multiplier_finesse",
			{
				0.2,
				0.6
			}
		},
		{
			"targets",
			1,
			"armor_damage_modifier",
			chainsword_sawing
		},
		{
			"weapon_special",
			true
		},
		{
			"skip_on_hit_proc",
			true
		}
	}
}
overrides.heavy_chainsword_sticky_last = {
	parent_template_name = "heavy_chainsword",
	overrides = {
		{
			"stagger_category",
			"sticky"
		},
		{
			"shield_stagger_category",
			"sticky"
		},
		{
			"ignore_shield",
			true
		},
		{
			"damage_type",
			damage_types.sawing_stuck
		},
		{
			"sticky_attack",
			true
		},
		{
			"ignore_instant_ragdoll_chance",
			true
		},
		{
			"gibbing_power",
			GibbingPower.heavy
		},
		{
			"gibbing_type",
			GibbingTypes.sawing
		},
		{
			"wounds_template",
			WoundsTemplates.chainsword_sawing
		},
		{
			"targets",
			1,
			"power_distribution",
			"attack",
			{
				250,
				500
			}
		},
		{
			"targets",
			1,
			"power_distribution",
			"impact",
			{
				0,
				0
			}
		},
		{
			"targets",
			1,
			"power_level_multiplier",
			{
				0.5,
				1.5
			}
		},
		{
			"targets",
			1,
			"boost_curve_multiplier_finesse",
			{
				0.2,
				0.6
			}
		},
		{
			"targets",
			1,
			"armor_damage_modifier",
			chainsword_sawing
		},
		{
			"weapon_special",
			true
		},
		{
			"skip_on_hit_proc",
			true
		}
	}
}
damage_templates.default_light_chainsword = {
	sticky_attack = false,
	finesse_ability_damage_multiplier = 1.5,
	ragdoll_only = true,
	ragdoll_push_force = 150,
	stagger_category = "melee",
	crit_mod = chain_sword_crit_mod,
	cleave_distribution = double_cleave,
	damage_type = damage_types.sawing,
	gibbing_power = GibbingPower.always,
	gibbing_type = GibbingTypes.sawing,
	melee_attack_strength = melee_attack_strengths.light,
	gib_push_force = GibbingSettings.gib_push_force.sawing_heavy,
	wounds_template = WoundsTemplates.chainsword,
	armor_damage_modifier = chain_sword_light_mod,
	targets = {
		{
			armor_damage_modifier = {
				attack = {
					[armor_types.armored] = damage_lerp_values.lerp_0_75
				},
				impact = {
					[armor_types.super_armor] = {
						0.25,
						0.375
					}
				}
			},
			power_distribution = {
				attack = {
					80,
					160
				},
				impact = {
					6,
					12
				}
			},
			boost_curve_multiplier_finesse = {
				0.4,
				1
			},
			power_level_multiplier = {
				0.6,
				1.4
			}
		},
		{
			power_distribution = {
				attack = {
					25,
					50
				},
				impact = {
					3,
					7
				}
			}
		},
		default_target = {
			power_distribution = {
				attack = {
					15,
					30
				},
				impact = {
					2,
					5
				}
			},
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
overrides.light_chainsword_active = {
	parent_template_name = "default_light_chainsword",
	overrides = {
		{
			"stagger_category",
			"sticky"
		},
		{
			"stagger_override",
			"sticky"
		},
		{
			"shield_stagger_category",
			"melee"
		},
		{
			"damage_type",
			damage_types.sawing_stuck
		},
		{
			"ignore_instant_ragdoll_chance",
			true
		},
		{
			"targets",
			1,
			"power_distribution",
			"attack",
			10
		},
		{
			"targets",
			1,
			"power_distribution",
			"impact",
			{
				2,
				4
			}
		},
		{
			"targets",
			1,
			"power_level_multiplier",
			{
				0.5,
				1.5
			}
		},
		{
			"targets",
			1,
			"boost_curve_multiplier_finesse",
			{
				0.2,
				0.6
			}
		},
		{
			"cleave_distribution",
			no_cleave
		},
		{
			"weapon_special",
			true
		},
		{
			"wounds_template",
			WoundsTemplates.chainsword_sawing
		}
	}
}
overrides.light_chainsword_sticky = {
	parent_template_name = "default_light_chainsword",
	overrides = {
		{
			"stagger_category",
			"sticky"
		},
		{
			"stagger_override",
			"sticky"
		},
		{
			"shield_stagger_category",
			"sticky"
		},
		{
			"damage_type",
			damage_types.sawing_stuck
		},
		{
			"ignore_instant_ragdoll_chance",
			true
		},
		{
			"ignore_stagger_reduction",
			true
		},
		{
			"gibbing_power",
			GibbingPower.medium
		},
		{
			"sticky_attack",
			true
		},
		{
			"gibbing_type",
			GibbingTypes.sawing
		},
		{
			"wounds_template",
			WoundsTemplates.chainsword_sawing
		},
		{
			"targets",
			1,
			"power_distribution",
			"attack",
			{
				75,
				150
			}
		},
		{
			"targets",
			1,
			"power_distribution",
			"impact",
			{
				5,
				10
			}
		},
		{
			"targets",
			1,
			"power_level_multiplier",
			{
				0.5,
				1.5
			}
		},
		{
			"targets",
			1,
			"boost_curve_multiplier_finesse",
			{
				0.2,
				0.6
			}
		},
		{
			"targets",
			1,
			"armor_damage_modifier",
			chainsword_sawing
		},
		{
			"weapon_special",
			true
		},
		{
			"skip_on_hit_proc",
			true
		}
	}
}
overrides.light_chainsword_sticky_last = {
	parent_template_name = "default_light_chainsword",
	overrides = {
		{
			"stagger_category",
			"sticky"
		},
		{
			"shield_stagger_category",
			"sticky"
		},
		{
			"damage_type",
			damage_types.sawing_stuck
		},
		{
			"ignore_shield",
			true
		},
		{
			"ragdoll_only",
			true
		},
		{
			"gibbing_power",
			GibbingPower.medium
		},
		{
			"sticky_attack",
			true
		},
		{
			"gibbing_type",
			GibbingTypes.sawing
		},
		{
			"wounds_template",
			WoundsTemplates.chainsword_sawing
		},
		{
			"targets",
			1,
			"power_distribution",
			"attack",
			{
				200,
				400
			}
		},
		{
			"targets",
			1,
			"power_distribution",
			"impact",
			{
				0,
				0
			}
		},
		{
			"targets",
			1,
			"power_level_multiplier",
			{
				0.5,
				1.5
			}
		},
		{
			"targets",
			1,
			"boost_curve_multiplier_finesse",
			{
				0.2,
				0.6
			}
		},
		{
			"targets",
			1,
			"armor_damage_modifier",
			chainsword_sawing
		},
		{
			"weapon_special",
			true
		},
		{
			"skip_on_hit_proc",
			true
		}
	}
}
damage_templates.default_light_chainsword_stab = {
	sticky_attack = false,
	ragdoll_only = true,
	ignore_stagger_reduction = true,
	ragdoll_push_force = 300,
	stagger_category = "killshot",
	crit_mod = chain_sword_crit_mod,
	cleave_distribution = single_cleave,
	damage_type = damage_types.sawing,
	gibbing_power = GibbingPower.always,
	gibbing_type = GibbingTypes.default,
	melee_attack_strength = melee_attack_strengths.light,
	gib_push_force = GibbingSettings.gib_push_force.sawing_heavy,
	wounds_template = WoundsTemplates.chainsword,
	armor_damage_modifier = chain_sword_light_mod,
	targets = {
		{
			armor_damage_modifier = {
				attack = {
					[armor_types.armored] = {
						0.5,
						0.8
					}
				},
				impact = {
					[armor_types.super_armor] = {
						0.25,
						0.375
					}
				}
			},
			power_distribution = {
				attack = {
					80,
					160
				},
				impact = {
					4,
					8
				}
			},
			boost_curve_multiplier_finesse = damage_lerp_values.lerp_1,
			power_level_multiplier = {
				0.6,
				1.4
			}
		},
		{
			power_distribution = {
				attack = {
					20,
					35
				},
				impact = {
					3,
					7
				}
			}
		},
		default_target = {
			power_distribution = {
				attack = {
					0,
					0
				},
				impact = {
					2,
					5
				}
			},
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
overrides.light_chainsword_stab_active = {
	parent_template_name = "default_light_chainsword_stab",
	overrides = {
		{
			"stagger_category",
			"sticky"
		},
		{
			"ignore_hit_reacts",
			true
		},
		{
			"damage_type",
			damage_types.sawing_stuck
		},
		{
			"ignore_instant_ragdoll_chance",
			true
		},
		{
			"targets",
			1,
			"power_distribution",
			"attack",
			10
		},
		{
			"targets",
			1,
			"power_level_multiplier",
			{
				0.5,
				1.5
			}
		},
		{
			"targets",
			1,
			"boost_curve_multiplier_finesse",
			{
				0.2,
				0.6
			}
		},
		{
			"cleave_distribution",
			no_cleave
		},
		{
			"ignore_stagger_reduction",
			true
		},
		{
			"wounds_template",
			WoundsTemplates.chainsword_sawing
		},
		{
			"weapon_special",
			true
		},
		{
			"ragdoll_push_force",
			50
		},
		{
			"ragdoll_only",
			false
		}
	}
}
overrides.default_light_chainsword_stab_sticky = {
	parent_template_name = "default_light_chainsword_stab",
	overrides = {
		{
			"stagger_category",
			"sticky"
		},
		{
			"stagger_override",
			"sticky"
		},
		{
			"shield_stagger_category",
			"sticky"
		},
		{
			"damage_type",
			damage_types.sawing_stuck
		},
		{
			"ignore_instant_ragdoll_chance",
			true
		},
		{
			"ignore_stagger_reduction",
			true
		},
		{
			"sticky_attack",
			true
		},
		{
			"wounds_template",
			WoundsTemplates.chainsword_sawing
		},
		{
			"targets",
			1,
			"power_distribution",
			"attack",
			{
				75,
				150
			}
		},
		{
			"targets",
			1,
			"power_distribution",
			"impact",
			{
				10,
				10
			}
		},
		{
			"targets",
			1,
			"power_level_multiplier",
			{
				0.5,
				1.5
			}
		},
		{
			"targets",
			1,
			"boost_curve_multiplier_finesse",
			{
				0.2,
				0.6
			}
		},
		{
			"targets",
			1,
			"armor_damage_modifier",
			chainsword_sawing
		},
		{
			"weapon_special",
			true
		},
		{
			"ragdoll_push_force",
			50
		},
		{
			"ragdoll_only",
			false
		}
	}
}
overrides.default_light_chainsword_stab_sticky_last = {
	parent_template_name = "default_light_chainsword_stab",
	overrides = {
		{
			"stagger_category",
			"sticky"
		},
		{
			"shield_stagger_category",
			"sticky"
		},
		{
			"damage_type",
			damage_types.sawing_stuck
		},
		{
			"ignore_instant_ragdoll_chance",
			true
		},
		{
			"wounds_template",
			WoundsTemplates.chainsword_sawing
		},
		{
			"sticky_attack",
			true
		},
		{
			"targets",
			1,
			"power_distribution",
			"attack",
			{
				200,
				400
			}
		},
		{
			"targets",
			1,
			"power_distribution",
			"impact",
			{
				0,
				0
			}
		},
		{
			"targets",
			1,
			"power_level_multiplier",
			{
				0.5,
				1.5
			}
		},
		{
			"targets",
			1,
			"boost_curve_multiplier_finesse",
			{
				0.2,
				0.6
			}
		},
		{
			"targets",
			1,
			"armor_damage_modifier",
			chainsword_sawing
		},
		{
			"weapon_special",
			true
		},
		{
			"ragdoll_push_force",
			50
		},
		{
			"ragdoll_only",
			false
		}
	}
}
damage_templates.default_light_chainsword_2h = {
	sticky_attack = false,
	finesse_ability_damage_multiplier = 1.5,
	ragdoll_only = true,
	ragdoll_push_force = 380,
	stagger_category = "melee",
	crit_mod = chain_sword_crit_mod,
	cleave_distribution = light_cleave,
	damage_type = damage_types.sawing,
	gibbing_power = GibbingPower.medium,
	gibbing_type = GibbingTypes.sawing,
	melee_attack_strength = melee_attack_strengths.light,
	gib_push_force = GibbingSettings.gib_push_force.sawing_heavy,
	wounds_template = WoundsTemplates.chainsword_2h,
	armor_damage_modifier = chain_sword_light_mod,
	targets = {
		{
			armor_damage_modifier = {
				attack = {
					[armor_types.armored] = damage_lerp_values.lerp_1,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_25
				},
				impact = {
					[armor_types.super_armor] = damage_lerp_values.lerp_0_25
				}
			},
			power_distribution = {
				attack = {
					70,
					140
				},
				impact = {
					8,
					15
				}
			},
			boost_curve_multiplier_finesse = {
				0.4,
				1
			},
			power_level_multiplier = {
				0.6,
				1.4
			}
		},
		{
			power_distribution = {
				attack = {
					60,
					120
				},
				impact = {
					4,
					11
				}
			}
		},
		{
			power_distribution = {
				attack = {
					50,
					100
				},
				impact = {
					3,
					9
				}
			}
		},
		default_target = {
			power_distribution = {
				attack = damage_lerp_values.no_damage,
				impact = {
					2,
					5
				}
			},
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
overrides.light_chainsword_active_2h_push_follow = {
	parent_template_name = "default_light_chainsword_2h",
	overrides = {
		{
			"targets",
			1,
			"power_distribution",
			"attack",
			{
				75,
				150
			}
		},
		{
			"targets",
			1,
			"power_distribution",
			"impact",
			{
				10,
				20
			}
		},
		{
			"targets",
			2,
			"power_distribution",
			"attack",
			{
				50,
				100
			}
		},
		{
			"targets",
			2,
			"power_distribution",
			"impact",
			{
				8,
				16
			}
		},
		{
			"targets",
			3,
			"power_distribution",
			"attack",
			{
				40,
				80
			}
		},
		{
			"targets",
			3,
			"power_distribution",
			"impact",
			{
				7,
				14
			}
		},
		{
			"ragdoll_push_force",
			450
		}
	}
}
overrides.light_chainsword_active_2h = {
	parent_template_name = "default_light_chainsword_2h",
	overrides = {
		{
			"stagger_category",
			"sticky"
		},
		{
			"stagger_override",
			"sticky"
		},
		{
			"shield_stagger_category",
			"melee"
		},
		{
			"ignore_hit_reacts",
			true
		},
		{
			"ignore_shield",
			true
		},
		{
			"damage_type",
			damage_types.sawing_stuck
		},
		{
			"ignore_instant_ragdoll_chance",
			true
		},
		{
			"targets",
			1,
			"power_distribution",
			"attack",
			0
		},
		{
			"targets",
			1,
			"power_level_multiplier",
			{
				0.5,
				1.5
			}
		},
		{
			"targets",
			1,
			"boost_curve_multiplier_finesse",
			{
				0.2,
				0.6
			}
		},
		{
			"cleave_distribution",
			no_cleave
		},
		{
			"ignore_stagger_reduction",
			true
		},
		{
			"weapon_special",
			true
		},
		{
			"wounds_template",
			WoundsTemplates.chainsword_sawing_2h
		},
		{
			"skip_on_hit_proc",
			true
		}
	}
}
overrides.light_chainsword_sticky_2h = {
	parent_template_name = "default_light_chainsword_2h",
	overrides = {
		{
			"stagger_category",
			"sticky"
		},
		{
			"stagger_override",
			"sticky"
		},
		{
			"shield_stagger_category",
			"melee"
		},
		{
			"damage_type",
			damage_types.sawing_stuck
		},
		{
			"ignore_instant_ragdoll_chance",
			true
		},
		{
			"ignore_stagger_reduction",
			true
		},
		{
			"ignore_shield",
			true
		},
		{
			"gibbing_power",
			GibbingPower.medium
		},
		{
			"sticky_attack",
			true
		},
		{
			"gibbing_type",
			GibbingTypes.sawing
		},
		{
			"wounds_template",
			WoundsTemplates.chainsword_sawing_2h
		},
		{
			"melee_attack_strength",
			melee_attack_strengths.heavy
		},
		{
			"targets",
			1,
			"power_distribution",
			"attack",
			{
				50,
				100
			}
		},
		{
			"targets",
			1,
			"power_distribution",
			"impact",
			{
				10,
				10
			}
		},
		{
			"targets",
			1,
			"power_level_multiplier",
			{
				0.5,
				1.5
			}
		},
		{
			"targets",
			1,
			"boost_curve_multiplier_finesse",
			{
				0.2,
				0.6
			}
		},
		{
			"targets",
			1,
			"armor_damage_modifier",
			chainsword_sawing
		},
		{
			"weapon_special",
			true
		},
		{
			"skip_on_hit_proc",
			true
		}
	}
}
overrides.light_chainsword_sticky_last_2h = {
	parent_template_name = "default_light_chainsword_2h",
	overrides = {
		{
			"stagger_category",
			"sticky"
		},
		{
			"shield_stagger_category",
			"melee"
		},
		{
			"damage_type",
			damage_types.sawing_stuck
		},
		{
			"ignore_shield",
			true
		},
		{
			"ragdoll_only",
			true
		},
		{
			"gibbing_power",
			GibbingPower.medium
		},
		{
			"sticky_attack",
			true
		},
		{
			"gibbing_type",
			GibbingTypes.sawing
		},
		{
			"wounds_template",
			WoundsTemplates.chainsword_sawing_2h
		},
		{
			"melee_attack_strength",
			melee_attack_strengths.heavy
		},
		{
			"targets",
			1,
			"power_distribution",
			"attack",
			{
				300,
				600
			}
		},
		{
			"targets",
			1,
			"power_level_multiplier",
			{
				0.5,
				1.5
			}
		},
		{
			"targets",
			1,
			"boost_curve_multiplier_finesse",
			{
				0.2,
				0.6
			}
		},
		{
			"targets",
			1,
			"armor_damage_modifier",
			chainsword_sawing
		},
		{
			"weapon_special",
			true
		},
		{
			"skip_on_hit_proc",
			true
		}
	}
}
damage_templates.smiter_light_chainsword_2h = {
	sticky_attack = false,
	finesse_ability_damage_multiplier = 1.5,
	ragdoll_only = true,
	ragdoll_push_force = 300,
	stagger_category = "melee",
	crit_mod = chain_sword_crit_mod,
	cleave_distribution = single_cleave,
	damage_type = damage_types.sawing,
	gibbing_power = GibbingPower.light,
	gibbing_type = GibbingTypes.crushing,
	melee_attack_strength = melee_attack_strengths.light,
	gib_push_force = GibbingSettings.gib_push_force.sawing_heavy,
	wounds_template = WoundsTemplates.chainsword_2h,
	armor_damage_modifier = chain_sword_light_smiter_mod,
	targets = {
		{
			armor_damage_modifier = {
				attack = {
					[armor_types.armored] = damage_lerp_values.lerp_1,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_1
				},
				impact = {
					[armor_types.super_armor] = damage_lerp_values.lerp_0_3
				}
			},
			power_distribution = {
				attack = {
					125,
					250
				},
				impact = {
					7,
					14
				}
			},
			boost_curve_multiplier_finesse = {
				0.4,
				1
			},
			power_level_multiplier = {
				0.6,
				1.4
			}
		},
		{
			power_distribution = {
				attack = {
					30,
					60
				},
				impact = {
					3,
					8
				}
			},
			boost_curve_multiplier_finesse = {
				0.4,
				1
			},
			power_level_multiplier = {
				0.6,
				1.4
			}
		},
		default_target = {
			power_distribution = {
				attack = damage_lerp_values.no_damage,
				impact = {
					2,
					5
				}
			},
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
overrides.smiter_light_chainsword_2h_active = {
	parent_template_name = "smiter_light_chainsword_2h",
	overrides = {
		{
			"stagger_category",
			"sticky"
		},
		{
			"stagger_override",
			"sticky"
		},
		{
			"shield_stagger_category",
			"melee"
		},
		{
			"ignore_hit_reacts",
			true
		},
		{
			"damage_type",
			damage_types.sawing_stuck
		},
		{
			"ignore_instant_ragdoll_chance",
			true
		},
		{
			"targets",
			1,
			"power_distribution",
			"attack",
			0
		},
		{
			"targets",
			1,
			"power_level_multiplier",
			{
				0.5,
				1.5
			}
		},
		{
			"targets",
			1,
			"boost_curve_multiplier_finesse",
			{
				0.2,
				0.6
			}
		},
		{
			"cleave_distribution",
			no_cleave
		},
		{
			"ignore_stagger_reduction",
			true
		},
		{
			"weapon_special",
			true
		},
		{
			"wounds_template",
			WoundsTemplates.chainsword_sawing_2h
		}
	}
}
overrides.smiter_light_chainsword_2h_sticky = {
	parent_template_name = "smiter_light_chainsword_2h",
	overrides = {
		{
			"stagger_category",
			"sticky"
		},
		{
			"stagger_override",
			"sticky"
		},
		{
			"shield_stagger_category",
			"melee"
		},
		{
			"damage_type",
			damage_types.sawing_stuck
		},
		{
			"ignore_instant_ragdoll_chance",
			true
		},
		{
			"ignore_stagger_reduction",
			true
		},
		{
			"gibbing_power",
			GibbingPower.medium
		},
		{
			"sticky_attack",
			true
		},
		{
			"gibbing_type",
			GibbingTypes.sawing
		},
		{
			"wounds_template",
			WoundsTemplates.chainsword_sawing_2h
		},
		{
			"melee_attack_strength",
			melee_attack_strengths.heavy
		},
		{
			"targets",
			1,
			"power_distribution",
			"attack",
			{
				50,
				100
			}
		},
		{
			"targets",
			1,
			"power_distribution",
			"impact",
			{
				10,
				10
			}
		},
		{
			"targets",
			1,
			"power_level_multiplier",
			{
				0.5,
				1.5
			}
		},
		{
			"targets",
			1,
			"boost_curve_multiplier_finesse",
			{
				0.2,
				0.6
			}
		},
		{
			"targets",
			1,
			"armor_damage_modifier",
			chainsword_sawing
		},
		{
			"weapon_special",
			true
		},
		{
			"skip_on_hit_proc",
			true
		}
	}
}
overrides.smiter_light_chainsword_sticky_last_2h = {
	parent_template_name = "smiter_light_chainsword_2h",
	overrides = {
		{
			"stagger_category",
			"sticky"
		},
		{
			"shield_stagger_category",
			"melee"
		},
		{
			"damage_type",
			damage_types.sawing_stuck
		},
		{
			"ragdoll_only",
			true
		},
		{
			"gibbing_power",
			GibbingPower.medium
		},
		{
			"sticky_attack",
			true
		},
		{
			"gibbing_type",
			GibbingTypes.sawing
		},
		{
			"wounds_template",
			WoundsTemplates.chainsword_sawing_2h
		},
		{
			"melee_attack_strength",
			melee_attack_strengths.heavy
		},
		{
			"targets",
			1,
			"power_distribution",
			"attack",
			{
				300,
				600
			}
		},
		{
			"targets",
			1,
			"power_distribution",
			"impact",
			{
				0,
				0
			}
		},
		{
			"targets",
			1,
			"power_level_multiplier",
			{
				0.5,
				1.5
			}
		},
		{
			"targets",
			1,
			"boost_curve_multiplier_finesse",
			{
				0.2,
				0.6
			}
		},
		{
			"targets",
			1,
			"armor_damage_modifier",
			chainsword_sawing
		},
		{
			"weapon_special",
			true
		}
	}
}
damage_templates.heavy_chainsword_2h = {
	sticky_attack = false,
	ragdoll_push_force = 800,
	finesse_ability_damage_multiplier = 1.5,
	ragdoll_only = true,
	stagger_category = "melee",
	crit_mod = chain_sword_crit_mod,
	cleave_distribution = {
		attack = {
			1.5,
			6
		},
		impact = {
			1.5,
			6
		}
	},
	damage_type = damage_types.sawing,
	gibbing_power = GibbingPower.heavy,
	gibbing_type = GibbingTypes.sawing,
	melee_attack_strength = melee_attack_strengths.heavy,
	gib_push_force = GibbingSettings.gib_push_force.sawing_heavy,
	wounds_template = WoundsTemplates.chainsword_2h,
	stagger_duration_modifier = {
		0.1,
		0.5
	},
	armor_damage_modifier = chain_sword_heavy_mod,
	targets = {
		{
			armor_damage_modifier = {
				attack = {
					[armor_types.armored] = damage_lerp_values.lerp_1,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_25
				},
				impact = {
					[armor_types.super_armor] = damage_lerp_values.lerp_1
				}
			},
			power_distribution = {
				attack = {
					125,
					250
				},
				impact = {
					12,
					24
				}
			},
			boost_curve_multiplier_finesse = damage_lerp_values.lerp_0_5
		},
		{
			armor_damage_modifier = {
				attack = {
					[armor_types.armored] = damage_lerp_values.lerp_1
				},
				impact = {
					[armor_types.super_armor] = damage_lerp_values.lerp_0_65
				}
			},
			power_distribution = {
				attack = {
					50,
					100
				},
				impact = {
					11,
					22
				}
			}
		},
		{
			armor_damage_modifier = {
				attack = {
					[armor_types.armored] = damage_lerp_values.lerp_1
				},
				impact = {
					[armor_types.super_armor] = damage_lerp_values.lerp_0_65
				}
			},
			power_distribution = {
				attack = {
					40,
					80
				},
				impact = {
					8,
					16
				}
			}
		},
		{
			armor_damage_modifier = {
				attack = {
					[armor_types.armored] = damage_lerp_values.lerp_1
				},
				impact = {
					[armor_types.super_armor] = damage_lerp_values.lerp_0_65
				}
			},
			power_distribution = {
				attack = {
					25,
					50
				},
				impact = {
					5,
					9
				}
			}
		},
		default_target = {
			armor_damage_modifier = chain_sword_heavy_mod,
			power_distribution = {
				attack = {
					0,
					0
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
damage_templates.heavy_chainsword_2h_smiter = {
	sticky_attack = false,
	finesse_ability_damage_multiplier = 1.5,
	ragdoll_push_force = 400,
	stagger_category = "melee",
	crit_mod = chain_sword_crit_mod,
	cleave_distribution = no_cleave,
	damage_type = damage_types.sawing,
	gibbing_power = GibbingPower.medium,
	gibbing_type = GibbingTypes.sawing,
	melee_attack_strength = melee_attack_strengths.heavy,
	gib_push_force = GibbingSettings.gib_push_force.sawing_heavy,
	wounds_template = WoundsTemplates.chainsword_2h,
	stagger_duration_modifier = {
		0.1,
		0.5
	},
	armor_damage_modifier = chain_sword_heavy_mod,
	targets = {
		{
			armor_damage_modifier = {
				attack = {
					[armor_types.armored] = damage_lerp_values.lerp_1,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_25
				},
				impact = {
					[armor_types.super_armor] = damage_lerp_values.lerp_1
				}
			},
			power_distribution = {
				attack = {
					150,
					300
				},
				impact = {
					8,
					16
				}
			},
			boost_curve_multiplier_finesse = damage_lerp_values.lerp_0_5,
			power_level_multiplier = {
				0.7,
				1.3
			}
		},
		{
			armor_damage_modifier = {
				attack = {
					[armor_types.armored] = damage_lerp_values.lerp_1
				},
				impact = {
					[armor_types.super_armor] = damage_lerp_values.lerp_0_65
				}
			},
			power_distribution = {
				attack = {
					50,
					100
				},
				impact = {
					8,
					14
				}
			}
		},
		{
			armor_damage_modifier = {
				attack = {
					[armor_types.armored] = damage_lerp_values.lerp_1
				},
				impact = {
					[armor_types.super_armor] = damage_lerp_values.lerp_0_65
				}
			},
			power_distribution = {
				attack = {
					40,
					80
				},
				impact = {
					7,
					10
				}
			}
		},
		{
			armor_damage_modifier = {
				attack = {
					[armor_types.armored] = damage_lerp_values.lerp_1
				},
				impact = {
					[armor_types.super_armor] = damage_lerp_values.lerp_0_65
				}
			},
			power_distribution = {
				attack = {
					25,
					50
				},
				impact = {
					5,
					9
				}
			}
		},
		default_target = {
			armor_damage_modifier = chain_sword_heavy_mod,
			power_distribution = {
				attack = {
					0,
					0
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
overrides.heavy_chainsword_active_2h = {
	parent_template_name = "heavy_chainsword_2h",
	overrides = {
		{
			"stagger_category",
			"melee"
		},
		{
			"shield_stagger_category",
			"melee"
		},
		{
			"damage_type",
			damage_types.sawing_stuck
		},
		{
			"ragdoll_push_force",
			1300
		},
		{
			"targets",
			1,
			"power_distribution",
			"attack",
			{
				150,
				300
			}
		},
		{
			"targets",
			1,
			"power_distribution",
			"impact",
			{
				18,
				24
			}
		},
		{
			"targets",
			2,
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
			"impact",
			{
				18,
				24
			}
		},
		{
			"targets",
			3,
			"power_distribution",
			"attack",
			{
				80,
				160
			}
		},
		{
			"targets",
			3,
			"power_distribution",
			"impact",
			{
				18,
				24
			}
		},
		{
			"targets",
			4,
			"power_distribution",
			"attack",
			{
				50,
				100
			}
		},
		{
			"targets",
			4,
			"power_distribution",
			"impact",
			{
				18,
				24
			}
		},
		{
			"targets",
			"default_target",
			"power_distribution",
			"attack",
			{
				40,
				80
			}
		},
		{
			"targets",
			"default_target",
			"power_distribution",
			"impact",
			{
				18,
				24
			}
		},
		{
			"targets",
			1,
			"power_level_multiplier",
			{
				0.5,
				1.5
			}
		},
		{
			"targets",
			1,
			"boost_curve_multiplier_finesse",
			{
				0.2,
				0.6
			}
		},
		{
			"gibbing_power",
			6
		},
		{
			"gibbing_type",
			GibbingTypes.sawing
		},
		{
			"wounds_template",
			WoundsTemplates.chainsword_sawing_2h
		},
		{
			"targets",
			1,
			"armor_damage_modifier",
			chainsword_sawing
		},
		{
			"weapon_special",
			true
		}
	}
}
overrides.heavy_chainsword_active_abort_2h = {
	parent_template_name = "heavy_chainsword_2h_smiter",
	overrides = {
		{
			"stagger_category",
			"sticky"
		},
		{
			"stagger_override",
			"sticky"
		},
		{
			"shield_stagger_category",
			"melee"
		},
		{
			"ignore_stagger_reduction",
			true
		},
		{
			"damage_type",
			damage_types.sawing_stuck
		},
		{
			"targets",
			1,
			"power_distribution",
			"attack",
			{
				0,
				0
			}
		},
		{
			"targets",
			1,
			"power_distribution",
			"impact",
			{
				18,
				24
			}
		},
		{
			"targets",
			1,
			"power_level_multiplier",
			{
				0.5,
				1.5
			}
		},
		{
			"targets",
			1,
			"boost_curve_multiplier_finesse",
			{
				0.2,
				0.6
			}
		},
		{
			"cleave_distribution",
			medium_cleave
		},
		{
			"gibbing_power",
			6
		},
		{
			"gibbing_type",
			GibbingTypes.sawing
		},
		{
			"wounds_template",
			WoundsTemplates.chainsword_sawing_2h
		},
		{
			"targets",
			1,
			"armor_damage_modifier",
			chainsword_sawing
		},
		{
			"weapon_special",
			true
		}
	}
}
overrides.heavy_chainsword_sticky_2h = {
	parent_template_name = "heavy_chainsword_2h",
	overrides = {
		{
			"stagger_category",
			"sticky"
		},
		{
			"stagger_override",
			"sticky"
		},
		{
			"shield_stagger_category",
			"melee"
		},
		{
			"ignore_stagger_reduction",
			true
		},
		{
			"damage_type",
			damage_types.sawing_stuck
		},
		{
			"sticky_attack",
			true
		},
		{
			"ignore_instant_ragdoll_chance",
			true
		},
		{
			"gibbing_power",
			6
		},
		{
			"gibbing_type",
			GibbingTypes.sawing
		},
		{
			"wounds_template"
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
			1,
			"power_distribution",
			"impact",
			{
				12,
				24
			}
		},
		{
			"targets",
			1,
			"power_level_multiplier",
			{
				0.5,
				1.5
			}
		},
		{
			"targets",
			1,
			"boost_curve_multiplier_finesse",
			{
				0.2,
				0.6
			}
		},
		{
			"targets",
			1,
			"armor_damage_modifier",
			chainsword_sawing
		},
		{
			"weapon_special",
			true
		},
		{
			"skip_on_hit_proc",
			true
		}
	}
}
overrides.heavy_chainsword_smiter_sticky_quick_2h = {
	parent_template_name = "heavy_chainsword_2h",
	overrides = {
		{
			"stagger_category",
			"sticky"
		},
		{
			"stagger_override",
			"sticky"
		},
		{
			"shield_stagger_category",
			"melee"
		},
		{
			"ignore_stagger_reduction",
			true
		},
		{
			"damage_type",
			damage_types.sawing_stuck
		},
		{
			"sticky_attack",
			true
		},
		{
			"ignore_instant_ragdoll_chance",
			true
		},
		{
			"gibbing_power",
			GibbingPower.light
		},
		{
			"gibbing_type",
			GibbingTypes.sawing
		},
		{
			"wounds_template"
		},
		{
			"targets",
			1,
			"power_distribution",
			"attack",
			{
				50,
				100
			}
		},
		{
			"targets",
			1,
			"power_distribution",
			"impact",
			{
				12,
				24
			}
		},
		{
			"targets",
			1,
			"power_level_multiplier",
			{
				0.5,
				1.5
			}
		},
		{
			"targets",
			1,
			"boost_curve_multiplier_finesse",
			{
				0.2,
				0.6
			}
		},
		{
			"targets",
			1,
			"armor_damage_modifier",
			chainsword_sawing
		},
		{
			"weapon_special",
			true
		},
		{
			"skip_on_hit_proc",
			true
		}
	}
}
overrides.heavy_chainsword_sticky_last_2h = {
	parent_template_name = "heavy_chainsword_2h",
	overrides = {
		{
			"stagger_category",
			"sticky"
		},
		{
			"shield_stagger_category",
			"melee"
		},
		{
			"damage_type",
			damage_types.sawing_stuck
		},
		{
			"sticky_attack",
			true
		},
		{
			"ignore_instant_ragdoll_chance",
			true
		},
		{
			"gibbing_power",
			6
		},
		{
			"gibbing_type",
			GibbingTypes.sawing
		},
		{
			"wounds_template",
			WoundsTemplates.chainsword_sawing_2h
		},
		{
			"targets",
			1,
			"power_distribution",
			"attack",
			{
				300,
				600
			}
		},
		{
			"targets",
			1,
			"power_distribution",
			"impact",
			{
				0,
				0
			}
		},
		{
			"targets",
			1,
			"power_level_multiplier",
			{
				0.5,
				1.5
			}
		},
		{
			"targets",
			1,
			"boost_curve_multiplier_finesse",
			{
				0.2,
				0.6
			}
		},
		{
			"targets",
			1,
			"armor_damage_modifier",
			chainsword_sawing
		},
		{
			"weapon_special",
			true
		},
		{
			"skip_on_hit_proc",
			true
		}
	}
}
overrides.heavy_chainsword_sticky_quick_last_2h = {
	parent_template_name = "heavy_chainsword_2h",
	overrides = {
		{
			"stagger_category",
			"sticky"
		},
		{
			"shield_stagger_category",
			"melee"
		},
		{
			"damage_type",
			damage_types.sawing_stuck
		},
		{
			"sticky_attack",
			true
		},
		{
			"ignore_instant_ragdoll_chance",
			true
		},
		{
			"gibbing_power",
			GibbingPower.heavy
		},
		{
			"gibbing_type",
			GibbingTypes.sawing
		},
		{
			"wounds_template",
			WoundsTemplates.chainsword_sawing_2h
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
			1,
			"power_distribution",
			"impact",
			{
				0,
				0
			}
		},
		{
			"targets",
			1,
			"power_level_multiplier",
			{
				0.5,
				1.5
			}
		},
		{
			"targets",
			1,
			"boost_curve_multiplier_finesse",
			{
				0.2,
				0.6
			}
		},
		{
			"targets",
			1,
			"armor_damage_modifier",
			chainsword_sawing
		},
		{
			"weapon_special",
			true
		},
		{
			"skip_on_hit_proc",
			true
		}
	}
}
overrides.heavy_chainsword_smiter_sticky_quick_last_2h = {
	parent_template_name = "heavy_chainsword_2h",
	overrides = {
		{
			"stagger_category",
			"sticky"
		},
		{
			"shield_stagger_category",
			"melee"
		},
		{
			"damage_type",
			damage_types.sawing_stuck
		},
		{
			"sticky_attack",
			true
		},
		{
			"ignore_instant_ragdoll_chance",
			true
		},
		{
			"gibbing_power",
			GibbingPower.light
		},
		{
			"gibbing_type",
			GibbingTypes.sawing
		},
		{
			"wounds_template",
			WoundsTemplates.chainsword_sawing_2h
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
			1,
			"power_distribution",
			"impact",
			{
				0,
				0
			}
		},
		{
			"targets",
			1,
			"power_level_multiplier",
			{
				0.5,
				1.5
			}
		},
		{
			"targets",
			1,
			"boost_curve_multiplier_finesse",
			{
				0.2,
				0.6
			}
		},
		{
			"targets",
			1,
			"armor_damage_modifier",
			chainsword_sawing
		},
		{
			"weapon_special",
			true
		},
		{
			"skip_on_hit_proc",
			true
		}
	}
}
overrides.heavy_chainsword_smiter_active_abort_2h = {
	parent_template_name = "heavy_chainsword_2h_smiter",
	overrides = {
		{
			"stagger_category",
			"sticky"
		},
		{
			"stagger_override",
			"sticky"
		},
		{
			"shield_stagger_category",
			"melee"
		},
		{
			"ignore_stagger_reduction",
			true
		},
		{
			"ragdoll_push_force",
			300
		},
		{
			"damage_type",
			damage_types.sawing_stuck
		},
		{
			"targets",
			1,
			"power_distribution",
			"attack",
			{
				0,
				0
			}
		},
		{
			"targets",
			1,
			"power_distribution",
			"impact",
			{
				18,
				24
			}
		},
		{
			"targets",
			1,
			"power_level_multiplier",
			{
				0.5,
				1.5
			}
		},
		{
			"targets",
			1,
			"boost_curve_multiplier_finesse",
			{
				0.2,
				0.6
			}
		},
		{
			"cleave_distribution",
			no_cleave
		},
		{
			"gibbing_power",
			GibbingPower.light
		},
		{
			"gibbing_type",
			GibbingTypes.sawing
		},
		{
			"wounds_template",
			WoundsTemplates.chainsword_sawing_2h
		},
		{
			"targets",
			1,
			"armor_damage_modifier",
			chainsword_sawing
		},
		{
			"weapon_special",
			true
		}
	}
}
overrides.heavy_chainsword_smiter_sticky_2h = {
	parent_template_name = "heavy_chainsword_2h_smiter",
	overrides = {
		{
			"stagger_category",
			"sticky"
		},
		{
			"stagger_override",
			"sticky"
		},
		{
			"shield_stagger_category",
			"melee"
		},
		{
			"ignore_stagger_reduction",
			true
		},
		{
			"ragdoll_push_force",
			300
		},
		{
			"damage_type",
			damage_types.sawing_stuck
		},
		{
			"sticky_attack",
			true
		},
		{
			"ignore_instant_ragdoll_chance",
			true
		},
		{
			"gibbing_power",
			GibbingPower.light
		},
		{
			"gibbing_type",
			GibbingTypes.sawing
		},
		{
			"wounds_template"
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
			1,
			"power_distribution",
			"impact",
			{
				10,
				20
			}
		},
		{
			"targets",
			1,
			"power_level_multiplier",
			{
				0.5,
				1.5
			}
		},
		{
			"targets",
			1,
			"boost_curve_multiplier_finesse",
			{
				0.2,
				0.6
			}
		},
		{
			"targets",
			1,
			"armor_damage_modifier",
			chainsword_sawing
		},
		{
			"weapon_special",
			true
		},
		{
			"skip_on_hit_proc",
			true
		}
	}
}
overrides.heavy_chainsword_smiter_sticky_last_2h = {
	parent_template_name = "heavy_chainsword_2h_smiter",
	overrides = {
		{
			"stagger_category",
			"sticky"
		},
		{
			"shield_stagger_category",
			"melee"
		},
		{
			"ragdoll_push_force",
			300
		},
		{
			"damage_type",
			damage_types.sawing_stuck
		},
		{
			"sticky_attack",
			true
		},
		{
			"ignore_instant_ragdoll_chance",
			true
		},
		{
			"gibbing_power",
			GibbingPower.light
		},
		{
			"gibbing_type",
			GibbingTypes.sawing
		},
		{
			"wounds_template",
			WoundsTemplates.chainsword_sawing_2h
		},
		{
			"targets",
			1,
			"power_distribution",
			"attack",
			{
				300,
				600
			}
		},
		{
			"targets",
			1,
			"power_distribution",
			"impact",
			{
				0,
				0
			}
		},
		{
			"targets",
			1,
			"power_level_multiplier",
			{
				0.5,
				1.5
			}
		},
		{
			"targets",
			1,
			"boost_curve_multiplier_finesse",
			{
				0.2,
				0.6
			}
		},
		{
			"targets",
			1,
			"armor_damage_modifier",
			chainsword_sawing
		},
		{
			"weapon_special",
			true
		},
		{
			"skip_on_hit_proc",
			true
		}
	}
}

return {
	base_templates = damage_templates,
	overrides = overrides
}
