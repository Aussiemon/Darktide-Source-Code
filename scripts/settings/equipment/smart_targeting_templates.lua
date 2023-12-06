local Range = require("scripts/utilities/range")

local function _degrees_to_radians(degrees)
	return degrees * 0.0174532925
end

local HEAD = "enemy_aim_target_03"
local TORSO = "enemy_aim_target_02"
local smart_targeting_templates = {
	killshot = {
		precision_target = {
			max_range = 100,
			min_range = 1.5,
			min_angle = _degrees_to_radians(0.15),
			max_angle = _degrees_to_radians(0.3),
			wanted_target = TORSO
		},
		aim_assist = {
			base_multiplier = 0.05,
			no_aim_input_multiplier = 0,
			always_auto_aim = false
		},
		trajectory_assist = {
			range = 30,
			assist_multiplier = 0.6,
			falloff_func = Range.power_4,
			min_angle = _degrees_to_radians(1),
			max_angle = _degrees_to_radians(2.3)
		}
	},
	alternate_fire_killshot = {
		precision_target = {
			max_range = 100,
			min_range = 1.5,
			min_angle = _degrees_to_radians(0.15),
			max_angle = _degrees_to_radians(0.3),
			wanted_target = TORSO
		},
		aim_assist = {
			base_multiplier = 1.2,
			no_aim_input_multiplier = 0,
			always_auto_aim = true
		},
		trajectory_assist = {
			range = 30,
			assist_multiplier = 0.6,
			falloff_func = Range.power_4,
			min_angle = _degrees_to_radians(1),
			max_angle = _degrees_to_radians(2)
		}
	},
	assault = {
		precision_target = {
			max_range = 100,
			min_range = 1.5,
			min_angle = _degrees_to_radians(0.15),
			max_angle = _degrees_to_radians(0.3),
			wanted_target = TORSO
		},
		aim_assist = {
			base_multiplier = 0.15,
			no_aim_input_multiplier = 0,
			always_auto_aim = false
		},
		trajectory_assist = {
			range = 20,
			assist_multiplier = 0.6,
			falloff_func = Range.power_4,
			min_angle = _degrees_to_radians(0.15),
			max_angle = _degrees_to_radians(0.3)
		}
	},
	alternate_fire_assault = {
		precision_target = {
			max_range = 100,
			min_range = 1.5,
			min_angle = _degrees_to_radians(0.15),
			max_angle = _degrees_to_radians(0.3),
			wanted_target = TORSO
		},
		aim_assist = {
			base_multiplier = 0.9,
			no_aim_input_multiplier = 0,
			always_auto_aim = true
		},
		trajectory_assist = {
			range = 20,
			assist_multiplier = 0.6,
			falloff_func = Range.power_4,
			min_angle = _degrees_to_radians(0.5),
			max_angle = _degrees_to_radians(1)
		}
	},
	alternate_fire_snp = {
		precision_target = {
			max_range = 100,
			min_range = 1.5,
			min_angle = _degrees_to_radians(0.15),
			max_angle = _degrees_to_radians(0.3),
			wanted_target = TORSO
		},
		aim_assist = {
			base_multiplier = 0.6,
			no_aim_input_multiplier = 0,
			always_auto_aim = true
		}
	},
	alternate_fire_bfg = {
		precision_target = {
			max_range = 100,
			min_range = 1.5,
			min_angle = _degrees_to_radians(0.15),
			max_angle = _degrees_to_radians(0.3),
			wanted_target = TORSO
		},
		aim_assist = {
			base_multiplier = 0.7,
			no_aim_input_multiplier = 0,
			always_auto_aim = true
		}
	},
	alternate_fire_slow_brace = {
		precision_target = {
			max_range = 100,
			min_range = 1.5,
			min_angle = _degrees_to_radians(0.15),
			max_angle = _degrees_to_radians(0.3),
			wanted_target = TORSO
		},
		aim_assist = {
			base_multiplier = 0.3,
			no_aim_input_multiplier = 0,
			always_auto_aim = true
		}
	},
	default_melee = {
		precision_target = {
			max_range = 100,
			min_range = 1,
			min_angle = _degrees_to_radians(0.1),
			max_angle = _degrees_to_radians(0.2),
			wanted_target = TORSO
		},
		aim_assist = {
			base_multiplier = 0,
			no_aim_input_multiplier = 0,
			always_auto_aim = false
		},
		proximity = {
			max_range = 5,
			max_results = 5,
			angle_weight = 0.8,
			min_range = 1,
			distance_weight = 0.2,
			max_angle = math.pi * 0.25
		}
	},
	tank = {
		precision_target = {
			max_range = 100,
			min_range = 1,
			min_angle = _degrees_to_radians(0.1),
			max_angle = _degrees_to_radians(0.2),
			wanted_target = TORSO
		},
		aim_assist = {
			base_multiplier = 0,
			no_aim_input_multiplier = 0,
			always_auto_aim = false
		},
		proximity = {
			max_range = 5,
			max_results = 5,
			angle_weight = 0.8,
			min_range = 1,
			distance_weight = 0.2,
			max_angle = math.pi * 0.25
		}
	},
	force_staff_single_target = {
		precision_target = {
			max_range = 100,
			min_range = 1,
			min_angle = _degrees_to_radians(0.05),
			max_angle = _degrees_to_radians(0.1),
			wanted_target = TORSO
		},
		aim_assist = {
			base_multiplier = 0.07,
			no_aim_input_multiplier = 0,
			always_auto_aim = true
		},
		trajectory_assist = {
			range = 35,
			assist_multiplier = 1,
			falloff_func = Range.power_4,
			min_angle = _degrees_to_radians(3),
			max_angle = _degrees_to_radians(15)
		}
	},
	force_staff_p1_single_target = {
		precision_target = {
			max_range = 25,
			min_range = 1,
			min_angle = _degrees_to_radians(0.05),
			max_angle = _degrees_to_radians(0.1),
			wanted_target = TORSO
		},
		aim_assist = {
			base_multiplier = 0.07,
			no_aim_input_multiplier = 0,
			always_auto_aim = true
		},
		trajectory_assist = {
			range = 35,
			assist_multiplier = 1,
			falloff_func = Range.power_4,
			min_angle = _degrees_to_radians(3),
			max_angle = _degrees_to_radians(15)
		}
	},
	force_sword_single_target = {
		precision_target = {
			max_range = 10,
			min_range = 1,
			min_angle = _degrees_to_radians(0.05),
			max_angle = _degrees_to_radians(0.1),
			wanted_target = HEAD
		},
		aim_assist = {
			base_multiplier = 0,
			no_aim_input_multiplier = 0,
			always_auto_aim = true
		},
		proximity = {
			max_range = 5,
			max_results = 5,
			angle_weight = 0.8,
			min_range = 1,
			distance_weight = 0.2,
			max_angle = math.pi * 0.25
		}
	},
	smite = {
		precision_target = {
			max_range = 100,
			within_distance_to_box_y = 0.15,
			min_range = 1,
			within_distance_to_box_x = 0.3,
			breed_weights = {
				renegade_flamer = 20,
				chaos_beast_of_nurgle = 5,
				renegade_assault = 1,
				cultist_mutant = 20,
				renegade_twin_captain_two = 10,
				chaos_hound_mutator = 20,
				chaos_ogryn_executor = 10,
				chaos_poxwalker_bomber = 20,
				cultist_melee = 1,
				chaos_poxwalker = 1,
				renegade_rifleman = 1,
				cultist_shocktrooper = 10,
				chaos_ogryn_gunner = 10,
				renegade_shocktrooper = 10,
				renegade_gunner = 10,
				cultist_berzerker = 10,
				renegade_twin_captain = 10,
				chaos_newly_infected = 1,
				chaos_spawn = 5,
				renegade_melee = 1,
				cultist_flamer = 20,
				cultist_assault = 1,
				renegade_grenadier = 20,
				chaos_daemonhost = 5,
				chaos_plague_ogryn = 5,
				renegade_berzerker = 10,
				renegade_sniper = 20,
				renegade_netgunner = 20,
				renegade_captain = 5,
				chaos_hound = 20,
				chaos_ogryn_bulwark = 10,
				cultist_gunner = 10,
				renegade_executor = 10
			},
			min_angle = _degrees_to_radians(0.05),
			max_angle = _degrees_to_radians(0.1),
			wanted_target = TORSO,
			wanted_target_fallback = HEAD
		},
		aim_assist = {
			base_multiplier = 0.07,
			no_aim_input_multiplier = 0,
			always_auto_aim = true
		},
		trajectory_assist = {
			range = 35,
			assist_multiplier = 1,
			falloff_func = Range.power_4,
			min_angle = _degrees_to_radians(3),
			max_angle = _degrees_to_radians(15)
		}
	},
	chain_lightning_single_target = {
		precision_target = {
			max_range = 15,
			within_distance_to_box_y = 0.15,
			min_range = 1,
			within_distance_to_box_x = 0.3,
			breed_weights = {
				renegade_flamer = 20,
				chaos_beast_of_nurgle = 5,
				renegade_assault = 1,
				cultist_mutant = 20,
				renegade_twin_captain_two = 10,
				chaos_hound_mutator = 20,
				chaos_ogryn_executor = 10,
				chaos_poxwalker_bomber = 20,
				cultist_melee = 1,
				chaos_poxwalker = 1,
				renegade_rifleman = 1,
				cultist_shocktrooper = 10,
				chaos_ogryn_gunner = 10,
				renegade_shocktrooper = 10,
				renegade_gunner = 10,
				cultist_berzerker = 10,
				renegade_twin_captain = 10,
				chaos_newly_infected = 1,
				chaos_spawn = 5,
				renegade_melee = 1,
				cultist_flamer = 20,
				cultist_assault = 1,
				renegade_grenadier = 20,
				chaos_daemonhost = 5,
				chaos_plague_ogryn = 5,
				renegade_berzerker = 10,
				renegade_sniper = 20,
				renegade_netgunner = 20,
				renegade_captain = 5,
				chaos_hound = 20,
				chaos_ogryn_bulwark = 10,
				cultist_gunner = 10,
				renegade_executor = 10
			},
			min_angle = _degrees_to_radians(0.05),
			max_angle = _degrees_to_radians(0.1),
			wanted_target = TORSO,
			wanted_target_fallback = TORSO
		},
		aim_assist = {
			base_multiplier = 0.07,
			no_aim_input_multiplier = 0,
			always_auto_aim = true
		},
		trajectory_assist = {
			range = 35,
			assist_multiplier = 1,
			falloff_func = Range.power_4,
			min_angle = _degrees_to_radians(3),
			max_angle = _degrees_to_radians(15)
		}
	},
	target_ally = {
		precision_target = {
			max_range = 100,
			min_range = 1,
			collision_filter = "filter_player_unit",
			min_angle = _degrees_to_radians(0.05),
			max_angle = _degrees_to_radians(0.1),
			wanted_target = TORSO,
			wanted_target_fallback = HEAD
		},
		aim_assist = {
			base_multiplier = 0.07,
			no_aim_input_multiplier = 0,
			always_auto_aim = true
		},
		trajectory_assist = {
			range = 35,
			assist_multiplier = 1,
			falloff_func = Range.power_4,
			min_angle = _degrees_to_radians(3),
			max_angle = _degrees_to_radians(15)
		}
	},
	target_ally_close = {
		precision_target = {
			max_range = 2,
			min_range = 0.5,
			collision_filter = "filter_player_unit",
			min_angle = _degrees_to_radians(0.05),
			max_angle = _degrees_to_radians(0.1),
			wanted_target = TORSO,
			wanted_target_fallback = HEAD
		},
		aim_assist = {
			base_multiplier = 0.07,
			no_aim_input_multiplier = 0,
			always_auto_aim = true
		},
		trajectory_assist = {
			range = 35,
			assist_multiplier = 1,
			falloff_func = Range.power_4,
			min_angle = _degrees_to_radians(3),
			max_angle = _degrees_to_radians(15)
		}
	},
	throwing_knives_default = {
		precision_target = {
			max_range = 100,
			min_range = 1,
			min_angle = _degrees_to_radians(0.05),
			max_angle = _degrees_to_radians(0.1),
			wanted_target = HEAD
		}
	},
	throwing_knifes_single_target = {
		precision_target = {
			max_range = 50,
			min_range = 1,
			min_angle = _degrees_to_radians(0.05),
			max_angle = _degrees_to_radians(0.1),
			wanted_target = HEAD
		}
	},
	smart_tag_target = {
		precision_target = {
			max_range = 100,
			min_range = 1,
			smart_tagging = true,
			max_unit_range = 100,
			breed_weights = {
				renegade_flamer = 20,
				chaos_beast_of_nurgle = 30,
				renegade_assault = 1,
				cultist_mutant = 20,
				renegade_twin_captain_two = 10,
				chaos_hound_mutator = 80,
				chaos_ogryn_executor = 10,
				chaos_poxwalker_bomber = 60,
				cultist_melee = 1,
				chaos_poxwalker = 1,
				renegade_rifleman = 1,
				cultist_shocktrooper = 10,
				chaos_ogryn_gunner = 20,
				renegade_shocktrooper = 10,
				renegade_gunner = 15,
				cultist_berzerker = 10,
				renegade_twin_captain = 10,
				chaos_newly_infected = 1,
				chaos_spawn = 30,
				renegade_melee = 1,
				cultist_flamer = 20,
				cultist_assault = 1,
				renegade_grenadier = 20,
				chaos_daemonhost = 30,
				chaos_plague_ogryn = 30,
				renegade_berzerker = 10,
				renegade_sniper = 20,
				renegade_netgunner = 20,
				renegade_captain = 30,
				chaos_hound = 80,
				chaos_ogryn_bulwark = 10,
				cultist_gunner = 15,
				renegade_executor = 10
			},
			min_angle = _degrees_to_radians(0.05),
			max_angle = _degrees_to_radians(0.1),
			wanted_target = TORSO,
			wanted_target_fallback = HEAD
		}
	}
}

for name, template in pairs(smart_targeting_templates) do
	template.name = name
end

return settings("SmartTargetingTemplates", smart_targeting_templates)
