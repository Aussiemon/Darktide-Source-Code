-- chunkname: @scripts/settings/equipment/weapon_templates/ogryn_clubs/settings_templates/ogryn_club_damage_profile_templates.lua

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
local big_cleave = DamageProfileSettings.big_cleave
local double_cleave = DamageProfileSettings.double_cleave
local medium_cleave = DamageProfileSettings.medium_cleave
local single_cleave = DamageProfileSettings.single_cleave
local damage_templates = {}
local overrides = {}

table.make_unique(damage_templates)
table.make_unique(overrides)

local tank_light_am_1 = {
	attack = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1,
		[armor_types.armored] = damage_lerp_values.lerp_0_8,
		[armor_types.resistant] = damage_lerp_values.lerp_0_8,
		[armor_types.player] = damage_lerp_values.lerp_1,
		[armor_types.berserker] = damage_lerp_values.lerp_0_8,
		[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
		[armor_types.void_shield] = damage_lerp_values.lerp_1_25
	},
	impact = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1,
		[armor_types.armored] = damage_lerp_values.lerp_1,
		[armor_types.resistant] = damage_lerp_values.lerp_1,
		[armor_types.player] = damage_lerp_values.lerp_1,
		[armor_types.berserker] = damage_lerp_values.lerp_0_5,
		[armor_types.super_armor] = damage_lerp_values.lerp_1,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
		[armor_types.void_shield] = damage_lerp_values.lerp_1
	}
}
local tank_light_am_default = {
	attack = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1,
		[armor_types.armored] = damage_lerp_values.lerp_0_75,
		[armor_types.resistant] = damage_lerp_values.lerp_0_7,
		[armor_types.player] = damage_lerp_values.lerp_1,
		[armor_types.berserker] = damage_lerp_values.lerp_0_5,
		[armor_types.super_armor] = damage_lerp_values.lerp_0_2,
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
}
local tank_heavy_am_1 = {
	attack = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1,
		[armor_types.armored] = damage_lerp_values.lerp_0_9,
		[armor_types.resistant] = damage_lerp_values.lerp_1,
		[armor_types.player] = damage_lerp_values.lerp_1,
		[armor_types.berserker] = damage_lerp_values.lerp_0_8,
		[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
		[armor_types.void_shield] = damage_lerp_values.lerp_1_25
	},
	impact = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1_25,
		[armor_types.armored] = damage_lerp_values.lerp_1_25,
		[armor_types.resistant] = damage_lerp_values.lerp_1_25,
		[armor_types.player] = damage_lerp_values.lerp_1_25,
		[armor_types.berserker] = damage_lerp_values.lerp_0_75,
		[armor_types.super_armor] = damage_lerp_values.lerp_1_25,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1_25,
		[armor_types.void_shield] = damage_lerp_values.lerp_1_25
	}
}
local tank_heavy_am_default = {
	attack = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1,
		[armor_types.armored] = damage_lerp_values.lerp_0_75,
		[armor_types.resistant] = damage_lerp_values.lerp_0_8,
		[armor_types.player] = damage_lerp_values.lerp_1,
		[armor_types.berserker] = damage_lerp_values.lerp_0_5,
		[armor_types.super_armor] = damage_lerp_values.lerp_0_3,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
		[armor_types.void_shield] = damage_lerp_values.lerp_1
	},
	impact = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1,
		[armor_types.armored] = damage_lerp_values.lerp_1,
		[armor_types.resistant] = damage_lerp_values.lerp_1,
		[armor_types.player] = damage_lerp_values.lerp_1,
		[armor_types.berserker] = damage_lerp_values.lerp_0_75,
		[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
		[armor_types.void_shield] = damage_lerp_values.lerp_1
	}
}
local smiter_light_default_am = {
	attack = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1,
		[armor_types.armored] = damage_lerp_values.lerp_1_5,
		[armor_types.resistant] = damage_lerp_values.lerp_1,
		[armor_types.player] = damage_lerp_values.lerp_1,
		[armor_types.berserker] = damage_lerp_values.lerp_1,
		[armor_types.super_armor] = damage_lerp_values.lerp_1,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
		[armor_types.void_shield] = damage_lerp_values.lerp_0_75
	},
	impact = {
		[armor_types.unarmored] = damage_lerp_values.lerp_1,
		[armor_types.armored] = damage_lerp_values.lerp_1,
		[armor_types.resistant] = damage_lerp_values.lerp_1,
		[armor_types.player] = damage_lerp_values.lerp_1,
		[armor_types.berserker] = damage_lerp_values.lerp_0_5,
		[armor_types.super_armor] = damage_lerp_values.lerp_1,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_75,
		[armor_types.void_shield] = damage_lerp_values.lerp_0_75
	}
}

damage_templates.ogryn_club_light_tank = {
	ragdoll_push_force = 400,
	ragdoll_only = true,
	stagger_category = "melee",
	cleave_distribution = big_cleave,
	damage_type = damage_types.ogryn_pipe_club_heavy,
	gibbing_power = gibbing_power.always,
	gibbing_type = gibbing_types.default,
	melee_attack_strength = melee_attack_strengths.light,
	wounds_template = WoundsTemplates.ogryn_club,
	armor_damage_modifier = tank_light_am_default,
	targets = {
		{
			boost_curve_multiplier_finesse = 0.25,
			armor_damage_modifier = tank_light_am_1,
			power_distribution = {
				attack = {
					90,
					180
				},
				impact = {
					20,
					25
				}
			}
		},
		{
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = {
					60,
					120
				},
				impact = {
					16,
					22
				}
			}
		},
		{
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = {
					35,
					70
				},
				impact = {
					15,
					20
				}
			}
		},
		{
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = {
					25,
					50
				},
				impact = {
					12,
					18
				}
			}
		},
		{
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = {
					20,
					40
				},
				impact = {
					10,
					16
				}
			}
		},
		default_target = {
			boost_curve_multiplier_finesse = 0.25,
			armor_damage_modifier = tank_light_am_default,
			power_distribution = {
				attack = {
					15,
					30
				},
				impact = {
					6,
					12
				}
			},
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	},
	gib_push_force = GibbingSettings.gib_push_force.blunt_heavy
}
damage_templates.ogryn_club_heavy_tank = {
	ragdoll_push_force = 800,
	ragdoll_only = true,
	stagger_category = "melee",
	cleave_distribution = big_cleave,
	damage_type = damage_types.ogryn_pipe_club_heavy,
	gibbing_power = gibbing_power.light,
	gibbing_type = gibbing_types.default,
	melee_attack_strength = melee_attack_strengths.heavy,
	wounds_template = WoundsTemplates.ogryn_club,
	targets = {
		{
			boost_curve_multiplier_finesse = 0.35,
			armor_damage_modifier = tank_heavy_am_1,
			power_distribution = {
				attack = {
					150,
					310
				},
				impact = {
					30,
					35
				}
			}
		},
		{
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = {
					90,
					180
				},
				impact = {
					20,
					25
				}
			}
		},
		{
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = {
					45,
					90
				},
				impact = {
					15,
					20
				}
			}
		},
		{
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = {
					40,
					70
				},
				impact = {
					12,
					18
				}
			}
		},
		{
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = {
					25,
					50
				},
				impact = {
					10,
					16
				}
			}
		},
		default_target = {
			boost_curve_multiplier_finesse = 0.25,
			armor_damage_modifier = tank_heavy_am_default,
			power_distribution = {
				attack = {
					20,
					40
				},
				impact = {
					8,
					14
				}
			},
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	},
	gib_push_force = GibbingSettings.gib_push_force.blunt_heavy
}
damage_templates.ogryn_club_light_smiter = {
	ragdoll_push_force = 500,
	ragdoll_only = true,
	stagger_category = "melee",
	cleave_distribution = double_cleave,
	gibbing_power = gibbing_power.always,
	gibbing_type = gibbing_types.default,
	melee_attack_strength = melee_attack_strengths.light,
	wounds_template = WoundsTemplates.ogryn_club,
	armor_damage_modifier = smiter_light_default_am,
	targets = {
		{
			boost_curve_multiplier_finesse = 0.35,
			power_distribution = {
				attack = {
					150,
					300
				},
				impact = {
					15,
					20
				}
			}
		},
		{
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = {
					60,
					80
				},
				impact = {
					15,
					20
				}
			}
		},
		default_target = {
			boost_curve_multiplier_finesse = 0.25,
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_1,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_5,
					[armor_types.super_armor] = damage_lerp_values.no_damage,
					[armor_types.disgustingly_resilient] = damage_lerp_values.no_damage,
					[armor_types.void_shield] = damage_lerp_values.no_damage
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_1,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_5,
					[armor_types.super_armor] = damage_lerp_values.lerp_1,
					[armor_types.disgustingly_resilient] = damage_lerp_values.no_damage,
					[armor_types.void_shield] = damage_lerp_values.no_damage
				}
			},
			power_distribution = {
				attack = {
					20,
					30
				},
				impact = {
					15,
					20
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
				[armor_types.void_shield] = 0.5
			}
		}
	}
}
damage_templates.ogryn_club_light_smiter_alt = {
	ragdoll_push_force = 500,
	ragdoll_only = true,
	stagger_category = "melee",
	cleave_distribution = double_cleave,
	gibbing_power = gibbing_power.always,
	gibbing_type = gibbing_types.default,
	melee_attack_strength = melee_attack_strengths.light,
	wounds_template = WoundsTemplates.ogryn_club,
	armor_damage_modifier = smiter_light_default_am,
	targets = {
		{
			boost_curve_multiplier_finesse = 0.35,
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_9,
					[armor_types.resistant] = damage_lerp_values.lerp_0_8,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_8,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_6,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_1_25
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_1,
					[armor_types.resistant] = damage_lerp_values.lerp_0_9,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_5,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_9,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_75,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_75
				}
			},
			power_distribution = {
				attack = {
					185,
					370
				},
				impact = {
					15,
					30
				}
			}
		},
		{
			boost_curve_multiplier_finesse = 0.25,
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_8,
					[armor_types.resistant] = damage_lerp_values.lerp_0_7,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_7,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_4,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_1
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_1,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_5,
					[armor_types.super_armor] = damage_lerp_values.lerp_1,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_75,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_75
				}
			},
			power_distribution = {
				attack = {
					60,
					80
				},
				impact = {
					10,
					15
				}
			}
		},
		default_target = {
			boost_curve_multiplier_finesse = 0.25,
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_7,
					[armor_types.resistant] = damage_lerp_values.lerp_0_5,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_5,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_3,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_75
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_1,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_5,
					[armor_types.super_armor] = damage_lerp_values.lerp_1,
					[armor_types.disgustingly_resilient] = damage_lerp_values.no_damage,
					[armor_types.void_shield] = damage_lerp_values.no_damage
				}
			},
			power_distribution = {
				attack = {
					20,
					30
				},
				impact = {
					5,
					10
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
				[armor_types.void_shield] = 0.5
			}
		}
	}
}
damage_templates.ogryn_club_heavy_smiter = {
	ragdoll_push_force = 1000,
	ragdoll_only = true,
	stagger_category = "uppercut",
	cleave_distribution = double_cleave,
	gibbing_power = gibbing_power.light,
	gibbing_type = gibbing_types.crushing,
	melee_attack_strength = melee_attack_strengths.heavy,
	wounds_template = WoundsTemplates.ogryn_club,
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_0_8,
			[armor_types.resistant] = damage_lerp_values.lerp_1,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_0_9,
			[armor_types.super_armor] = damage_lerp_values.lerp_0_7,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
			[armor_types.void_shield] = damage_lerp_values.lerp_1
		},
		impact = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_0_9,
			[armor_types.resistant] = damage_lerp_values.lerp_0_8,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_0_5,
			[armor_types.super_armor] = damage_lerp_values.lerp_0_8,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_9,
			[armor_types.void_shield] = damage_lerp_values.lerp_0_75
		}
	},
	targets = {
		{
			boost_curve_multiplier_finesse = 0.35,
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_9,
					[armor_types.resistant] = damage_lerp_values.lerp_1_1,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_1,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_75,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_1_25
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_1,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_7,
					[armor_types.super_armor] = damage_lerp_values.lerp_1,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_75,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_75
				}
			},
			power_distribution = {
				attack = {
					250,
					500
				},
				impact = {
					15,
					30
				}
			},
			finesse_boost = {
				[armor_types.unarmored] = 0.5,
				[armor_types.armored] = 0.5,
				[armor_types.resistant] = 0.5,
				[armor_types.player] = 0.1,
				[armor_types.berserker] = 0.5,
				[armor_types.super_armor] = 0.3,
				[armor_types.disgustingly_resilient] = 0.5,
				[armor_types.void_shield] = 0.25
			}
		},
		{
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = {
					90,
					180
				},
				impact = {
					15,
					20
				}
			},
			finesse_boost = {
				[armor_types.unarmored] = 0.5,
				[armor_types.armored] = 0.5,
				[armor_types.resistant] = 0.5,
				[armor_types.player] = 0.1,
				[armor_types.berserker] = 0.5,
				[armor_types.super_armor] = 0.3,
				[armor_types.disgustingly_resilient] = 0.5,
				[armor_types.void_shield] = 0.25
			}
		},
		default_target = {
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = {
					40,
					80
				},
				impact = {
					15,
					20
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
				[armor_types.void_shield] = 0.5
			}
		}
	}
}
damage_templates.ogryn_club_special = {
	stagger_category = "explosion",
	ignore_stagger_reduction = true,
	ragdoll_push_force = 250,
	weakspot_stagger_resistance_modifier = 0.4,
	weapon_special = true,
	cleave_distribution = medium_cleave,
	gibbing_power = gibbing_power.always,
	gibbing_type = gibbing_types.default,
	melee_attack_strength = melee_attack_strengths.light,
	targets = {
		{
			boost_curve_multiplier_finesse = 0,
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_5,
					[armor_types.resistant] = damage_lerp_values.lerp_0_7,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_5,
					[armor_types.super_armor] = damage_lerp_values.no_damage,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_9,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_1
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_5,
					[armor_types.resistant] = damage_lerp_values.lerp_0_6,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_5,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_9,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_25
				}
			},
			power_distribution = {
				impact = 16,
				attack = {
					45,
					90
				}
			}
		},
		default_target = {
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_4,
					[armor_types.resistant] = damage_lerp_values.lerp_0_6,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_5,
					[armor_types.super_armor] = damage_lerp_values.no_damage,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_8,
					[armor_types.void_shield] = damage_lerp_values.no_damage
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_5,
					[armor_types.resistant] = damage_lerp_values.lerp_0_5,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_5,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_4,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_9,
					[armor_types.void_shield] = damage_lerp_values.lerp_0_25
				}
			},
			power_distribution = {
				impact = 6,
				attack = {
					20,
					40
				}
			},
			boost_curve = PowerLevelSettings.boost_curves.default
		}
	}
}
damage_templates.ogryn_club_light_punch = {
	weakspot_stagger_resistance_modifier = 0.08,
	weapon_special = true,
	ragdoll_push_force = 500,
	ignore_stagger_reduction = true,
	ragdoll_only = true,
	stagger_category = "uppercut",
	cleave_distribution = double_cleave,
	damage_type = damage_types.blunt_thunder,
	gibbing_power = gibbing_power.always,
	gibbing_type = gibbing_types.default,
	melee_attack_strength = melee_attack_strengths.light,
	stagger_duration_modifier = {
		0.25,
		0.5
	},
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_0_5,
			[armor_types.resistant] = damage_lerp_values.lerp_0_2,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_0_7,
			[armor_types.super_armor] = damage_lerp_values.lerp_0_05,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
			[armor_types.void_shield] = damage_lerp_values.lerp_1
		},
		impact = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_0_5,
			[armor_types.resistant] = damage_lerp_values.lerp_1,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_0_7,
			[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
			[armor_types.void_shield] = damage_lerp_values.lerp_1
		}
	},
	targets = {
		{
			boost_curve_multiplier_finesse = 0.35,
			power_distribution = {
				attack = {
					190,
					290
				},
				impact = {
					30,
					70
				}
			},
			power_level_multiplier = {
				0.6,
				1.4
			}
		},
		{
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = {
					50,
					100
				},
				impact = {
					25,
					55
				}
			},
			power_level_multiplier = {
				0.6,
				1.4
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
					35
				}
			},
			power_level_multiplier = {
				0.6,
				1.4
			}
		},
		default_target = {
			boost_curve_multiplier_finesse = 0.25,
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.no_damage,
					[armor_types.resistant] = damage_lerp_values.no_damage,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_5,
					[armor_types.super_armor] = damage_lerp_values.no_damage,
					[armor_types.disgustingly_resilient] = damage_lerp_values.no_damage,
					[armor_types.void_shield] = damage_lerp_values.no_damage
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_5,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_5,
					[armor_types.super_armor] = damage_lerp_values.no_damage,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_1
				}
			},
			power_distribution = {
				attack = 0,
				impact = 1
			},
			boost_curve = PowerLevelSettings.boost_curves.default,
			power_level_multiplier = {
				0.6,
				1.4
			}
		}
	},
	gib_push_force = GibbingSettings.gib_push_force.blunt_heavy
}
overrides.ogryn_club_linesman_pushfollow = {
	parent_template_name = "ogryn_club_light_linesman",
	overrides = {
		{
			"targets",
			1,
			"power_distribution",
			"attack",
			{
				110,
				220
			}
		},
		{
			"cleave_distribution",
			"attack",
			10
		},
		{
			"cleave_distribution",
			"impact",
			10
		}
	}
}
overrides.ogryn_club_smiter_pushfollow_active = {
	parent_template_name = "ogryn_club_heavy_smiter",
	overrides = {
		{
			"cleave_distribution",
			"attack",
			0.2
		},
		{
			"cleave_distribution",
			"impact",
			0.6
		},
		{
			"targets",
			1,
			"power_distribution",
			"attack",
			{
				10,
				10
			}
		},
		{
			"targets",
			1,
			"power_distribution",
			"impact",
			{
				100,
				200
			}
		}
	}
}
damage_templates.ogryn_club_light_linesman = {
	ragdoll_push_force = 400,
	ragdoll_only = true,
	stagger_category = "melee",
	cleave_distribution = medium_cleave,
	damage_type = damage_types.ogryn_pipe_club_heavy,
	gibbing_power = gibbing_power.always,
	gibbing_type = gibbing_types.default,
	melee_attack_strength = melee_attack_strengths.light,
	wounds_template = WoundsTemplates.ogryn_club,
	armor_damage_modifier = {
		attack = {
			[armor_types.unarmored] = damage_lerp_values.lerp_1,
			[armor_types.armored] = damage_lerp_values.lerp_0_8,
			[armor_types.resistant] = damage_lerp_values.lerp_0_7,
			[armor_types.player] = damage_lerp_values.lerp_1,
			[armor_types.berserker] = damage_lerp_values.lerp_0_7,
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
			[armor_types.super_armor] = damage_lerp_values.lerp_0_2,
			[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
			[armor_types.void_shield] = damage_lerp_values.lerp_1
		}
	},
	targets = {
		{
			boost_curve_multiplier_finesse = 0.35,
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_9,
					[armor_types.resistant] = damage_lerp_values.lerp_0_8,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_75,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_4,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_1
				},
				impact = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_1,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_5,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_2,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_1
				}
			},
			power_distribution = {
				attack = {
					100,
					210
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
					70,
					140
				},
				impact = {
					8,
					16
				}
			}
		},
		{
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = {
					55,
					110
				},
				impact = {
					7,
					14
				}
			}
		},
		{
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = {
					45,
					90
				},
				impact = {
					6,
					12
				}
			}
		},
		{
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = {
					30,
					60
				},
				impact = {
					5,
					10
				}
			}
		},
		default_target = {
			boost_curve_multiplier_finesse = 0.25,
			power_distribution = {
				attack = {
					20,
					40
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
damage_templates.club_uppercut = {
	weapon_special = true,
	ragdoll_push_force = 500,
	stagger_category = "melee",
	cleave_distribution = medium_cleave,
	damage_type = damage_types.axe_light,
	gibbing_power = gibbing_power.always,
	gibbing_type = gibbing_types.default,
	melee_attack_strength = melee_attack_strengths.light,
	gib_push_force = GibbingSettings.gib_push_force.blunt_heavy,
	targets = {
		{
			boost_curve_multiplier_finesse = 0.5,
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_75,
					[armor_types.resistant] = damage_lerp_values.lerp_2,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_1,
					[armor_types.super_armor] = damage_lerp_values.lerp_0_75,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
					[armor_types.void_shield] = damage_lerp_values.lerp_1
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
			},
			power_distribution = {
				impact = 55,
				attack = {
					60,
					100
				}
			}
		},
		default_target = {
			armor_damage_modifier = {
				attack = {
					[armor_types.unarmored] = damage_lerp_values.lerp_1,
					[armor_types.armored] = damage_lerp_values.lerp_0_5,
					[armor_types.resistant] = damage_lerp_values.lerp_1,
					[armor_types.player] = damage_lerp_values.lerp_1,
					[armor_types.berserker] = damage_lerp_values.lerp_0_5,
					[armor_types.super_armor] = damage_lerp_values.no_damage,
					[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_75,
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
			},
			power_distribution = {
				impact = 20,
				attack = {
					20,
					40
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
