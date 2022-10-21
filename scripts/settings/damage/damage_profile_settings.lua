local ArmorSettings = require("scripts/settings/damage/armor_settings")
local armor_types = ArmorSettings.types
local damage_profile_settings = {
	default_crit_mod = 0,
	min_crit_mod = 0.25,
	damage_lerp_values = {
		lerp_3 = {
			2.22,
			3.78
		},
		lerp_2_5 = {
			1.825,
			3.175
		},
		lerp_2_35 = {
			1.692,
			3.008
		},
		lerp_2 = {
			1.42,
			2.58
		},
		lerp_1_75 = {
			1.225,
			2.275
		},
		lerp_1_5 = {
			1.035,
			1.965
		},
		lerp_1_25 = {
			0.85,
			1.65
		},
		lerp_1 = {
			0.67,
			1.33
		},
		lerp_0_9 = {
			0.594,
			1.206
		},
		lerp_0_8 = {
			0.52,
			1.08
		},
		lerp_0_75 = {
			0.48,
			1.02
		},
		lerp_0_65 = {
			0.41,
			0.891
		},
		lerp_0_6 = {
			0.372,
			0.828
		},
		lerp_0_5 = {
			0.305,
			0.695
		},
		lerp_0_4 = {
			0.24,
			0.56
		},
		lerp_0_35 = {
			0.207,
			0.494
		},
		lerp_0_3 = {
			0.174,
			0.426
		},
		lerp_0_25 = {
			0.143,
			0.358
		},
		lerp_0_2 = {
			0.112,
			0.288
		},
		lerp_0_15 = {
			0.083,
			0.218
		},
		lerp_0_1 = {
			0.054,
			0.146
		},
		lerp_0_075 = {
			0.04,
			0.11
		},
		lerp_0_05 = {
			0.026,
			0.074
		},
		lerp_0_01 = {
			0.005,
			0.015
		},
		no_damage = {
			0,
			0
		}
	}
}
local damage_lerp_values = damage_profile_settings.damage_lerp_values
damage_profile_settings.flat_one_armor_mod = {
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
damage_profile_settings.default_armor_mod = {
	[armor_types.unarmored] = damage_lerp_values.lerp_1,
	[armor_types.armored] = damage_lerp_values.lerp_0_5,
	[armor_types.resistant] = damage_lerp_values.lerp_1,
	[armor_types.player] = damage_lerp_values.lerp_1,
	[armor_types.berserker] = damage_lerp_values.lerp_0_5,
	[armor_types.super_armor] = damage_lerp_values.no_damage,
	[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_1,
	[armor_types.void_shield] = damage_lerp_values.lerp_1,
	[armor_types.prop_armor] = damage_lerp_values.lerp_0_5
}
damage_profile_settings.crit_armor_mod = {
	[armor_types.unarmored] = damage_lerp_values.lerp_0_25,
	[armor_types.armored] = damage_lerp_values.lerp_0_25,
	[armor_types.resistant] = damage_lerp_values.no_damage,
	[armor_types.player] = damage_lerp_values.no_damage,
	[armor_types.berserker] = damage_lerp_values.lerp_0_25,
	[armor_types.super_armor] = damage_lerp_values.lerp_0_1,
	[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_25,
	[armor_types.void_shield] = damage_lerp_values.lerp_0_25,
	[armor_types.prop_armor] = damage_lerp_values.lerp_0_25
}
damage_profile_settings.crit_impact_armor_mod = {
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
damage_profile_settings.base_crit_mod = {
	attack = {
		[armor_types.unarmored] = damage_lerp_values.lerp_0_5,
		[armor_types.armored] = damage_lerp_values.lerp_0_5,
		[armor_types.resistant] = damage_lerp_values.lerp_1,
		[armor_types.player] = damage_lerp_values.lerp_0_5,
		[armor_types.berserker] = damage_lerp_values.lerp_0_5,
		[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_5,
		[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
		[armor_types.prop_armor] = damage_lerp_values.lerp_0_5
	},
	impact = {
		[armor_types.unarmored] = damage_lerp_values.lerp_0_5,
		[armor_types.armored] = damage_lerp_values.lerp_0_5,
		[armor_types.resistant] = damage_lerp_values.lerp_0_5,
		[armor_types.player] = damage_lerp_values.lerp_0_5,
		[armor_types.berserker] = damage_lerp_values.lerp_0_5,
		[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_5,
		[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
		[armor_types.prop_armor] = damage_lerp_values.lerp_0_5
	}
}
damage_profile_settings.no_crit_mod = {
	attack = {
		[armor_types.unarmored] = damage_lerp_values.no_damage,
		[armor_types.armored] = damage_lerp_values.no_damage,
		[armor_types.resistant] = damage_lerp_values.no_damage,
		[armor_types.player] = damage_lerp_values.no_damage,
		[armor_types.berserker] = damage_lerp_values.no_damage,
		[armor_types.super_armor] = damage_lerp_values.no_damage,
		[armor_types.disgustingly_resilient] = damage_lerp_values.no_damage,
		[armor_types.void_shield] = damage_lerp_values.no_damage,
		[armor_types.prop_armor] = damage_lerp_values.no_damage
	},
	impact = {
		[armor_types.unarmored] = damage_lerp_values.no_damage,
		[armor_types.armored] = damage_lerp_values.no_damage,
		[armor_types.resistant] = damage_lerp_values.no_damage,
		[armor_types.player] = damage_lerp_values.no_damage,
		[armor_types.berserker] = damage_lerp_values.no_damage,
		[armor_types.super_armor] = damage_lerp_values.no_damage,
		[armor_types.disgustingly_resilient] = damage_lerp_values.no_damage,
		[armor_types.void_shield] = damage_lerp_values.no_damage,
		[armor_types.prop_armor] = damage_lerp_values.no_damage
	}
}
damage_profile_settings.finesse_crit_mod = {
	attack = {
		[armor_types.unarmored] = damage_lerp_values.lerp_0_5,
		[armor_types.armored] = damage_lerp_values.lerp_0_5,
		[armor_types.resistant] = damage_lerp_values.lerp_2_35,
		[armor_types.player] = damage_lerp_values.lerp_0_5,
		[armor_types.berserker] = damage_lerp_values.lerp_0_5,
		[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_5,
		[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
		[armor_types.prop_armor] = damage_lerp_values.lerp_0_5
	},
	impact = {
		[armor_types.unarmored] = damage_lerp_values.lerp_0_5,
		[armor_types.armored] = damage_lerp_values.lerp_0_5,
		[armor_types.resistant] = damage_lerp_values.lerp_0_5,
		[armor_types.player] = damage_lerp_values.lerp_0_5,
		[armor_types.berserker] = damage_lerp_values.lerp_0_5,
		[armor_types.super_armor] = damage_lerp_values.lerp_0_5,
		[armor_types.disgustingly_resilient] = damage_lerp_values.lerp_0_5,
		[armor_types.void_shield] = damage_lerp_values.lerp_0_5,
		[armor_types.prop_armor] = damage_lerp_values.lerp_0_5
	}
}
damage_profile_settings.no_cleave = {
	attack = {
		0.001,
		0.001
	},
	impact = {
		0.001,
		0.001
	}
}
damage_profile_settings.single_cleave = {
	attack = {
		0.75,
		1
	},
	impact = {
		0.75,
		1
	}
}
damage_profile_settings.double_cleave = {
	attack = {
		1,
		3
	},
	impact = {
		1,
		3
	}
}
damage_profile_settings.light_cleave = {
	attack = {
		2,
		4
	},
	impact = {
		2,
		4
	}
}
damage_profile_settings.medium_cleave = {
	attack = {
		3.5,
		8.5
	},
	impact = {
		3.5,
		8.5
	}
}
damage_profile_settings.big_cleave = {
	attack = {
		8.5,
		12.5
	},
	impact = {
		8.5,
		12.5
	}
}

return damage_profile_settings
