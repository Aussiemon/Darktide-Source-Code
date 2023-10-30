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
local chainsword_sawing = {
	attack = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1,
		[armor_types.armored] = damage_lerp_values.lerp_1,
		[armor_types.resistant] = damage_lerp_values.lerp_1_5,
		[armor_types.player] = damage_lerp_values.lerp_1,
		[armor_types.berserker] = damage_lerp_values.lerp_1,
		[armor_types.super_armor] = damage_lerp_values.lerp_0_75,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
		[armor_types.void_shield] = damage_lerp_values.lerp_1,
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
local chain_axe_light_mod = {
	attack = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1,
		[armor_types.armored] = damage_lerp_values.lerp_0_75,
		[armor_types.resistant] = damage_lerp_values.lerp_1,
		[armor_types.player] = damage_lerp_values.lerp_1,
		[armor_types.berserker] = damage_lerp_values.lerp_0_75,
		[armor_types.super_armor] = damage_lerp_values.no_damage,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
		[armor_types.void_shield] = damage_lerp_values.lerp_0_75,
		[armor_types.prop_armor] = damage_lerp_values.lerp_0_75
	},
	impact = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1,
		[armor_types.armored] = damage_lerp_values.lerp_1,
		[armor_types.resistant] = damage_lerp_values.lerp_0_25,
		[armor_types.player] = damage_lerp_values.lerp_1,
		[armor_types.berserker] = damage_lerp_values.lerp_0_25,
		[armor_types.super_armor] = damage_lerp_values.no_damage,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
		[armor_types.void_shield] = damage_lerp_values.lerp_1,
		[armor_types.prop_armor] = damage_lerp_values.lerp_1
	}
}
local chain_axe_heavy_mod = {
	attack = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1,
		[armor_types.armored] = damage_lerp_values.lerp_0_6,
		[armor_types.resistant] = damage_lerp_values.lerp_1,
		[armor_types.player] = damage_lerp_values.lerp_1,
		[armor_types.berserker] = damage_lerp_values.lerp_0_8,
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
		[armor_types.berserker] = damage_lerp_values.lerp_0_5,
		[armor_types.super_armor] = damage_lerp_values.no_damage,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
		[armor_types.void_shield] = damage_lerp_values.lerp_1,
		[armor_types.prop_armor] = damage_lerp_values.lerp_1
	}
}
damage_templates.default_light_chainaxe = {
	sticky_attack = false,
	finesse_ability_damage_multiplier = 1.5,
	ragdoll_only = true,
	ragdoll_push_force = 150,
	stagger_category = "melee",
	crit_mod = chain_sword_crit_mod,
	cleave_distribution = single_cleave,
	damage_type = damage_types.sawing,
	gibbing_power = GibbingPower.always,
	gibbing_type = GibbingTypes.sawing,
	melee_attack_strength = melee_attack_strengths.light,
	gib_push_force = GibbingSettings.gib_push_force.sawing_heavy,
	wounds_template = WoundsTemplates.chainaxe,
	armor_damage_modifier = chain_axe_light_mod,
	targets = {
		{
			armor_damage_modifier = {
				attack = {
					[armor_types.armored] = damage_lerp_values.lerp_1_5,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_75,
					[armor_types.resistant] = damage_lerp_values.lerp_1_5
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
					20,
					30
				},
				impact = {
					3,
					6
				}
			}
		},
		default_target = {
			power_distribution = {
				attack = damage_lerp_values.no_damage,
				impact = {
					1,
					3
				}
			},
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
overrides.light_chainaxe_active = {
	parent_template_name = "default_light_chainaxe",
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
			"targets",
			1,
			"power_distribution",
			"attack",
			50
		},
		{
			"targets",
			1,
			"armor_damage_modifier",
			chainsword_sawing
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
			WoundsTemplates.chainaxe_sawing
		}
	}
}
overrides.light_chainaxe_active_sticky = {
	parent_template_name = "default_light_chainaxe",
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
			WoundsTemplates.chainaxe_sawing
		},
		{
			"melee_attack_strength",
			melee_attack_strengths.light
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
				10
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
overrides.light_chainaxe_active_sticky_last = {
	parent_template_name = "default_light_chainaxe",
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
			"ignore_stagger_reduction",
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
			WoundsTemplates.chainaxe_sawing
		},
		{
			"melee_attack_strength",
			melee_attack_strengths.light
		},
		{
			"targets",
			1,
			"power_distribution",
			"attack",
			{
				300,
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
overrides.light_chainaxe_sticky = {
	parent_template_name = "default_light_chainaxe",
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
			"ignore_instant_ragdoll_chance",
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
			WoundsTemplates.chainaxe_sawing
		},
		{
			"melee_attack_strength",
			melee_attack_strengths.light
		},
		{
			"targets",
			1,
			"power_distribution",
			"attack",
			{
				30,
				60
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
			"skip_on_hit_proc",
			true
		}
	}
}
overrides.light_chainaxe_sticky_last_quick = {
	parent_template_name = "default_light_chainaxe",
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
			WoundsTemplates.chainaxe_sawing
		},
		{
			"melee_attack_strength",
			melee_attack_strengths.light
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
			"skip_on_hit_proc",
			true
		}
	}
}
damage_templates.heavy_chainaxe = {
	sticky_attack = false,
	ragdoll_push_force = 600,
	finesse_ability_damage_multiplier = 1.5,
	ragdoll_only = true,
	stagger_category = "melee",
	crit_mod = chain_sword_crit_mod,
	cleave_distribution = medium_cleave,
	damage_type = damage_types.sawing,
	gibbing_power = GibbingPower.always,
	gibbing_type = GibbingTypes.sawing,
	melee_attack_strength = melee_attack_strengths.heavy,
	gib_push_force = GibbingSettings.gib_push_force.sawing_heavy,
	wounds_template = WoundsTemplates.chainaxe,
	stagger_duration_modifier = {
		0.1,
		0.5
	},
	armor_damage_modifier = chain_axe_heavy_mod,
	targets = {
		{
			armor_damage_modifier = {
				attack = {
					[armor_types.armored] = damage_lerp_values.lerp_0_75,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_3
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
					7,
					14
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
					100,
					200
				},
				impact = {
					6,
					12
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
					75,
					140
				},
				impact = {
					5,
					9
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
					10,
					55
				},
				impact = {
					6,
					8
				}
			}
		},
		default_target = {
			armor_damage_modifier = chain_axe_heavy_mod,
			power_distribution = {
				attack = {
					0,
					0
				},
				impact = {
					4,
					6
				}
			},
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
overrides.heavy_chainaxe_active = {
	parent_template_name = "heavy_chainaxe",
	overrides = {
		{
			"stagger_category",
			"melee"
		},
		{
			"stagger_override",
			"medium"
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
			WoundsTemplates.chainaxe_sawing
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
overrides.heavy_chainaxe_active_sticky = {
	parent_template_name = "heavy_chainaxe",
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
overrides.heavy_chainaxe_active_sticky_last = {
	parent_template_name = "heavy_chainaxe",
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
			"wounds_template",
			WoundsTemplates.chainaxe_sawing
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
overrides.heavy_chainaxe_sticky = {
	parent_template_name = "heavy_chainaxe",
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
			"wounds_template"
		},
		{
			"targets",
			1,
			"power_distribution",
			"attack",
			{
				20,
				60
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
overrides.heavy_chainaxe_sticky_last_quick = {
	parent_template_name = "heavy_chainaxe",
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
			"ignore_stagger_reduction",
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
			WoundsTemplates.chainaxe_sawing
		},
		{
			"targets",
			1,
			"power_distribution",
			"attack",
			{
				30,
				70
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
damage_templates.chainaxe_tank = {
	ragdoll_only = true,
	ragdoll_push_force = 250,
	stagger_category = "melee",
	cleave_distribution = medium_cleave,
	damage_type = damage_types.blunt_light,
	gibbing_power = GibbingPower.always,
	gibbing_type = GibbingTypes.sawing,
	melee_attack_strength = melee_attack_strengths.light,
	gib_push_force = GibbingSettings.gib_push_force.sawing_heavy,
	armor_damage_modifier = chain_axe_light_mod,
	targets = {
		{
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_5,
					[armor_types.resistant] = damage_lerp_values.lerp_0_75,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_5,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_1,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_1,
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
			},
			power_distribution = {
				attack = {
					100,
					200
				},
				impact = {
					6,
					12
				}
			},
			power_level_multiplier = {
				0.5,
				1.5
			}
		},
		{
			power_distribution = {
				attack = {
					50,
					100
				},
				impact = {
					5,
					10
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
					4,
					8
				}
			}
		},
		default_target = {
			power_distribution = {
				attack = {
					5,
					20
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
overrides.chainaxe_light_stab = {
	parent_template_name = "chainaxe_tank",
	overrides = {
		{
			"targets",
			1,
			"armor_damage_modifier",
			"attack",
			"armored",
			damage_lerp_values.lerp_1
		},
		{
			"targets",
			1,
			"armor_damage_modifier",
			"attack",
			"super_armor",
			damage_lerp_values.lerp_0_5
		},
		{
			"targets",
			1,
			"armor_damage_modifier",
			"attack",
			"resistant",
			damage_lerp_values.lerp_0_9
		}
	}
}

return {
	base_templates = damage_templates,
	overrides = overrides
}
