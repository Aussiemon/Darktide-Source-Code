-- chunkname: @scripts/settings/equipment/smart_targeting_templates.lua

local Range = require("scripts/utilities/range")

local function _degrees_to_radians(degrees)
	return degrees * 0.0174532925
end

local HEAD = "enemy_aim_target_03"
local TORSO = "enemy_aim_target_02"
local smart_targeting_templates = {}

smart_targeting_templates.killshot = {
	precision_target = {
		max_range = 100,
		min_range = 1.5,
		min_angle = _degrees_to_radians(0.15),
		max_angle = _degrees_to_radians(0.3),
		wanted_target = TORSO,
	},
	aim_assist = {
		always_auto_aim = false,
		base_multiplier = 0.05,
		no_aim_input_multiplier = 0,
	},
	trajectory_assist = {
		assist_multiplier = 0.6,
		range = 30,
		falloff_func = Range.power_4,
		min_angle = _degrees_to_radians(1),
		max_angle = _degrees_to_radians(2.3),
	},
}
smart_targeting_templates.alternate_fire_killshot = {
	precision_target = {
		max_range = 100,
		min_range = 1.5,
		min_angle = _degrees_to_radians(0.15),
		max_angle = _degrees_to_radians(0.3),
		wanted_target = TORSO,
	},
	aim_assist = {
		always_auto_aim = true,
		base_multiplier = 1.2,
		no_aim_input_multiplier = 0,
	},
	trajectory_assist = {
		assist_multiplier = 0.6,
		range = 30,
		falloff_func = Range.power_4,
		min_angle = _degrees_to_radians(1),
		max_angle = _degrees_to_radians(2),
	},
}
smart_targeting_templates.assault = {
	precision_target = {
		max_range = 100,
		min_range = 1.5,
		min_angle = _degrees_to_radians(0.15),
		max_angle = _degrees_to_radians(0.3),
		wanted_target = TORSO,
	},
	aim_assist = {
		always_auto_aim = false,
		base_multiplier = 0.15,
		no_aim_input_multiplier = 0,
	},
	trajectory_assist = {
		assist_multiplier = 0.6,
		range = 20,
		falloff_func = Range.power_4,
		min_angle = _degrees_to_radians(0.15),
		max_angle = _degrees_to_radians(0.3),
	},
}
smart_targeting_templates.alternate_fire_assault = {
	precision_target = {
		max_range = 100,
		min_range = 1.5,
		min_angle = _degrees_to_radians(0.15),
		max_angle = _degrees_to_radians(0.3),
		wanted_target = TORSO,
	},
	aim_assist = {
		always_auto_aim = true,
		base_multiplier = 0.9,
		no_aim_input_multiplier = 0,
	},
	trajectory_assist = {
		assist_multiplier = 0.6,
		range = 20,
		falloff_func = Range.power_4,
		min_angle = _degrees_to_radians(0.5),
		max_angle = _degrees_to_radians(1),
	},
}
smart_targeting_templates.spray_n_pray = {
	precision_target = {
		max_range = 100,
		min_range = 1.5,
		min_angle = _degrees_to_radians(0.15),
		max_angle = _degrees_to_radians(0.3),
		wanted_target = TORSO,
	},
	aim_assist = {
		always_auto_aim = false,
		base_multiplier = 0.15,
		no_aim_input_multiplier = 0,
	},
}
smart_targeting_templates.alternate_fire_snp = {
	precision_target = {
		max_range = 100,
		min_range = 1.5,
		min_angle = _degrees_to_radians(0.15),
		max_angle = _degrees_to_radians(0.3),
		wanted_target = TORSO,
	},
	aim_assist = {
		always_auto_aim = true,
		base_multiplier = 0.6,
		no_aim_input_multiplier = 0,
	},
}
smart_targeting_templates.alternate_fire_bfg = {
	precision_target = {
		max_range = 100,
		min_range = 1.5,
		min_angle = _degrees_to_radians(0.15),
		max_angle = _degrees_to_radians(0.3),
		wanted_target = TORSO,
	},
	aim_assist = {
		always_auto_aim = true,
		base_multiplier = 0.7,
		no_aim_input_multiplier = 0,
	},
}
smart_targeting_templates.alternate_fire_slow_brace = {
	precision_target = {
		max_range = 100,
		min_range = 1.5,
		min_angle = _degrees_to_radians(0.15),
		max_angle = _degrees_to_radians(0.3),
		wanted_target = TORSO,
	},
	aim_assist = {
		always_auto_aim = true,
		base_multiplier = 0.3,
		no_aim_input_multiplier = 0,
	},
}
smart_targeting_templates.default_melee = {
	precision_target = {
		max_range = 100,
		min_range = 1,
		min_angle = _degrees_to_radians(0.1),
		max_angle = _degrees_to_radians(0.2),
		wanted_target = TORSO,
	},
	aim_assist = {
		always_auto_aim = false,
		base_multiplier = 0,
		no_aim_input_multiplier = 0,
	},
	proximity = {
		angle_weight = 0.8,
		distance_weight = 0.2,
		max_range = 5,
		max_results = 5,
		min_range = 1,
		max_angle = math.pi * 0.25,
	},
}
smart_targeting_templates.tank = {
	precision_target = {
		max_range = 100,
		min_range = 1,
		min_angle = _degrees_to_radians(0.1),
		max_angle = _degrees_to_radians(0.2),
		wanted_target = TORSO,
	},
	aim_assist = {
		always_auto_aim = false,
		base_multiplier = 0,
		no_aim_input_multiplier = 0,
	},
	proximity = {
		angle_weight = 0.8,
		distance_weight = 0.2,
		max_range = 5,
		max_results = 5,
		min_range = 1,
		max_angle = math.pi * 0.25,
	},
}
smart_targeting_templates.force_staff_single_target = {
	precision_target = {
		max_range = 100,
		min_range = 1,
		min_angle = _degrees_to_radians(0.05),
		max_angle = _degrees_to_radians(0.1),
		wanted_target = TORSO,
	},
	aim_assist = {
		always_auto_aim = true,
		base_multiplier = 0.07,
		no_aim_input_multiplier = 0,
	},
	trajectory_assist = {
		assist_multiplier = 1,
		range = 35,
		falloff_func = Range.power_4,
		min_angle = _degrees_to_radians(3),
		max_angle = _degrees_to_radians(15),
	},
}
smart_targeting_templates.force_staff_p1_single_target = {
	precision_target = {
		max_range = 25,
		min_range = 1,
		min_angle = _degrees_to_radians(0.05),
		max_angle = _degrees_to_radians(0.1),
		wanted_target = TORSO,
	},
	aim_assist = {
		always_auto_aim = true,
		base_multiplier = 0.07,
		no_aim_input_multiplier = 0,
	},
	trajectory_assist = {
		assist_multiplier = 1,
		range = 35,
		falloff_func = Range.power_4,
		min_angle = _degrees_to_radians(3),
		max_angle = _degrees_to_radians(15),
	},
}
smart_targeting_templates.force_sword_single_target = {
	precision_target = {
		max_range = 10,
		min_range = 1,
		min_angle = _degrees_to_radians(0.05),
		max_angle = _degrees_to_radians(0.1),
		wanted_target = HEAD,
	},
	aim_assist = {
		always_auto_aim = true,
		base_multiplier = 0,
		no_aim_input_multiplier = 0,
	},
	proximity = {
		angle_weight = 0.8,
		distance_weight = 0.2,
		max_range = 5,
		max_results = 5,
		min_range = 1,
		max_angle = math.pi * 0.25,
	},
}
smart_targeting_templates.smite = {
	precision_target = {
		max_range = 100,
		min_range = 1,
		within_distance_to_box_x = 0.3,
		within_distance_to_box_y = 0.15,
		breed_weights = {
			chaos_armored_infected = 1,
			chaos_beast_of_nurgle = 5,
			chaos_daemonhost = 5,
			chaos_hound = 20,
			chaos_hound_mutator = 20,
			chaos_newly_infected = 1,
			chaos_ogryn_bulwark = 10,
			chaos_ogryn_executor = 10,
			chaos_ogryn_gunner = 10,
			chaos_plague_ogryn = 5,
			chaos_poxwalker = 1,
			chaos_poxwalker_bomber = 20,
			chaos_spawn = 5,
			cultist_assault = 1,
			cultist_berzerker = 10,
			cultist_captain = 5,
			cultist_flamer = 20,
			cultist_grenadier = 20,
			cultist_gunner = 10,
			cultist_melee = 1,
			cultist_mutant = 20,
			cultist_mutant_mutator = 20,
			cultist_shocktrooper = 10,
			renegade_assault = 1,
			renegade_berzerker = 10,
			renegade_captain = 5,
			renegade_executor = 10,
			renegade_flamer = 20,
			renegade_grenadier = 20,
			renegade_gunner = 10,
			renegade_melee = 1,
			renegade_netgunner = 20,
			renegade_rifleman = 1,
			renegade_shocktrooper = 10,
			renegade_sniper = 20,
			renegade_twin_captain = 10,
			renegade_twin_captain_two = 10,
		},
		min_angle = _degrees_to_radians(0.05),
		max_angle = _degrees_to_radians(0.1),
		wanted_target = TORSO,
		wanted_target_fallback = HEAD,
	},
	aim_assist = {
		always_auto_aim = true,
		base_multiplier = 0.07,
		no_aim_input_multiplier = 0,
	},
	trajectory_assist = {
		assist_multiplier = 1,
		range = 35,
		falloff_func = Range.power_4,
		min_angle = _degrees_to_radians(3),
		max_angle = _degrees_to_radians(15),
	},
}
smart_targeting_templates.chain_lightning_single_target = {
	precision_target = {
		max_range = 15,
		min_range = 1,
		within_distance_to_box_x = 0.3,
		within_distance_to_box_y = 0.15,
		breed_weights = {
			chaos_armored_infected = 1,
			chaos_beast_of_nurgle = 5,
			chaos_daemonhost = 5,
			chaos_hound = 20,
			chaos_hound_mutator = 20,
			chaos_newly_infected = 1,
			chaos_ogryn_bulwark = 10,
			chaos_ogryn_executor = 10,
			chaos_ogryn_gunner = 10,
			chaos_plague_ogryn = 5,
			chaos_poxwalker = 1,
			chaos_poxwalker_bomber = 20,
			chaos_spawn = 5,
			cultist_assault = 1,
			cultist_berzerker = 10,
			cultist_captain = 5,
			cultist_flamer = 20,
			cultist_grenadier = 20,
			cultist_gunner = 10,
			cultist_melee = 1,
			cultist_mutant = 20,
			cultist_mutant_mutator = 20,
			cultist_shocktrooper = 10,
			renegade_assault = 1,
			renegade_berzerker = 10,
			renegade_captain = 5,
			renegade_executor = 10,
			renegade_flamer = 20,
			renegade_grenadier = 20,
			renegade_gunner = 10,
			renegade_melee = 1,
			renegade_netgunner = 20,
			renegade_rifleman = 1,
			renegade_shocktrooper = 10,
			renegade_sniper = 20,
			renegade_twin_captain = 10,
			renegade_twin_captain_two = 10,
		},
		min_angle = _degrees_to_radians(0.05),
		max_angle = _degrees_to_radians(0.1),
		wanted_target = TORSO,
		wanted_target_fallback = TORSO,
	},
	aim_assist = {
		always_auto_aim = true,
		base_multiplier = 0.07,
		no_aim_input_multiplier = 0,
	},
	trajectory_assist = {
		assist_multiplier = 1,
		range = 35,
		falloff_func = Range.power_4,
		min_angle = _degrees_to_radians(3),
		max_angle = _degrees_to_radians(15),
	},
}
smart_targeting_templates.target_ally = {
	precision_target = {
		collision_filter = "filter_player_unit",
		max_range = 100,
		min_range = 1,
		min_angle = _degrees_to_radians(0.05),
		max_angle = _degrees_to_radians(0.1),
		wanted_target = TORSO,
		wanted_target_fallback = HEAD,
	},
	aim_assist = {
		always_auto_aim = true,
		base_multiplier = 0.07,
		no_aim_input_multiplier = 0,
	},
	trajectory_assist = {
		assist_multiplier = 1,
		range = 35,
		falloff_func = Range.power_4,
		min_angle = _degrees_to_radians(3),
		max_angle = _degrees_to_radians(15),
	},
}
smart_targeting_templates.target_ally_close = {
	precision_target = {
		collision_filter = "filter_player_unit",
		max_range = 2,
		min_range = 0.5,
		min_angle = _degrees_to_radians(0.05),
		max_angle = _degrees_to_radians(0.1),
		wanted_target = TORSO,
		wanted_target_fallback = HEAD,
	},
	aim_assist = {
		always_auto_aim = true,
		base_multiplier = 0.07,
		no_aim_input_multiplier = 0,
	},
	trajectory_assist = {
		assist_multiplier = 1,
		range = 35,
		falloff_func = Range.power_4,
		min_angle = _degrees_to_radians(3),
		max_angle = _degrees_to_radians(15),
	},
}
smart_targeting_templates.throwing_knives_default = {
	precision_target = {
		max_range = 100,
		min_range = 1,
		min_angle = _degrees_to_radians(0.05),
		max_angle = _degrees_to_radians(0.1),
		wanted_target = HEAD,
	},
}
smart_targeting_templates.throwing_knifes_single_target = {
	precision_target = {
		max_range = 50,
		min_range = 1,
		min_angle = _degrees_to_radians(0.05),
		max_angle = _degrees_to_radians(0.1),
		wanted_target = HEAD,
	},
}
smart_targeting_templates.smart_tag_target = {
	precision_target = {
		max_range = 100,
		max_unit_range = 100,
		min_range = 1,
		smart_tagging = true,
		breed_weights = {
			chaos_armored_infected = 1,
			chaos_beast_of_nurgle = 30,
			chaos_daemonhost = 30,
			chaos_hound = 80,
			chaos_hound_mutator = 80,
			chaos_newly_infected = 1,
			chaos_ogryn_bulwark = 10,
			chaos_ogryn_executor = 10,
			chaos_ogryn_gunner = 20,
			chaos_plague_ogryn = 30,
			chaos_poxwalker = 1,
			chaos_poxwalker_bomber = 60,
			chaos_spawn = 30,
			cultist_assault = 1,
			cultist_berzerker = 10,
			cultist_captain = 30,
			cultist_flamer = 20,
			cultist_grenadier = 20,
			cultist_gunner = 15,
			cultist_melee = 1,
			cultist_mutant = 20,
			cultist_mutant_mutator = 20,
			cultist_shocktrooper = 10,
			renegade_assault = 1,
			renegade_berzerker = 10,
			renegade_captain = 30,
			renegade_executor = 10,
			renegade_flamer = 20,
			renegade_grenadier = 20,
			renegade_gunner = 15,
			renegade_melee = 1,
			renegade_netgunner = 20,
			renegade_rifleman = 1,
			renegade_shocktrooper = 10,
			renegade_sniper = 20,
			renegade_twin_captain = 10,
			renegade_twin_captain_two = 10,
		},
		min_angle = _degrees_to_radians(0.05),
		max_angle = _degrees_to_radians(0.1),
		wanted_target = TORSO,
		wanted_target_fallback = HEAD,
	},
}

for name, template in pairs(smart_targeting_templates) do
	template.name = name
end

return settings("SmartTargetingTemplates", smart_targeting_templates)
