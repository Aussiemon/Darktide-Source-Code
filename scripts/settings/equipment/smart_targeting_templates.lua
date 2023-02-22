local Range = require("scripts/utilities/range")

local function _degrees_to_radians(degrees)
	return degrees * 0.0174532925
end

local HEAD = "enemy_aim_target_03"
local TORSO = "enemy_aim_target_02"
local HIPS = "enemy_aim_target_01"
local smart_targeting_templates = {
	killshot = {
		precision_target = {
			max_range = 100,
			min_range = 1.5,
			breed_weights = {},
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
			breed_weights = {},
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
			breed_weights = {},
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
			breed_weights = {},
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
			breed_weights = {},
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
			breed_weights = {},
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
			breed_weights = {},
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
			breed_weights = {},
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
			breed_weights = {},
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
			breed_weights = {},
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
			max_range = 3,
			min_range = 1,
			breed_weights = {},
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
				chaos_poxwalker_bomber = 20,
				chaos_ogryn_executor = 10,
				renegade_grenadier = 20,
				renegade_netgunner = 20,
				chaos_beast_of_nurgle = 5,
				renegade_captain = 5,
				chaos_daemonhost = 5,
				chaos_plague_ogryn = 5,
				cultist_mutant = 20,
				cultist_shocktrooper = 10,
				chaos_ogryn_gunner = 10,
				renegade_sniper = 20,
				renegade_shocktrooper = 10,
				renegade_gunner = 10,
				cultist_berzerker = 10,
				cultist_grenadier = 20,
				chaos_hound = 20,
				chaos_ogryn_bulwark = 10,
				cultist_gunner = 10,
				renegade_executor = 10,
				cultist_flamer = 20
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
	target_ally = {
		precision_target = {
			max_range = 100,
			min_range = 1,
			collision_filter = "filter_player_unit",
			breed_weights = {},
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
	throwing_knifes_single_target = {
		precision_target = {
			max_range = 100,
			min_range = 1,
			breed_weights = {},
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
				chaos_poxwalker_bomber = 60,
				chaos_ogryn_executor = 10,
				renegade_grenadier = 20,
				renegade_netgunner = 20,
				chaos_beast_of_nurgle = 30,
				renegade_captain = 30,
				chaos_daemonhost = 30,
				chaos_plague_ogryn = 30,
				cultist_mutant = 20,
				cultist_shocktrooper = 10,
				chaos_ogryn_gunner = 20,
				renegade_sniper = 20,
				renegade_shocktrooper = 10,
				renegade_gunner = 15,
				cultist_berzerker = 10,
				cultist_grenadier = 20,
				chaos_hound = 80,
				chaos_ogryn_bulwark = 10,
				cultist_gunner = 15,
				renegade_executor = 10,
				cultist_flamer = 20
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
