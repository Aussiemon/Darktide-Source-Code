-- chunkname: @scripts/settings/difficulty/minion_difficulty_settings.lua

local minion_difficulty_settings = {}

local function _equal_difficulty_values(val, val_2)
	local diff_table = {}

	for ii = 1, 5 do
		diff_table[ii] = {
			val,
			val_2,
		}
	end

	return diff_table
end

local function _monster_health_steps(health)
	local health_steps = {
		health * 1,
		health * 1.25,
		health * 1.5,
		health * 2,
		health * 3,
	}

	return health_steps
end

local function _roamer_health_steps(health)
	local health_steps = {
		health * 1,
		health * 1.25,
		health * 1.5,
		health * 2,
		health * 2.5,
	}

	return health_steps
end

local function _horde_health_steps(health)
	local health_steps = {
		health * 1,
		health * 1.25,
		health * 1.5,
		health * 2,
		health * 2.5,
	}

	return health_steps
end

local function _special_health_steps(health)
	local health_steps = {
		health * 0.85,
		health * 1,
		health * 1.25,
		health * 1.5,
		health * 2,
	}

	return health_steps
end

local function _elite_health_steps(health)
	local health_steps = {
		health * 0.75,
		health * 1,
		health * 1.25,
		health * 1.5,
		health * 2,
	}

	return health_steps
end

local function _step_dmg_horde_melee(damage)
	local damage_steps = {
		damage * 0.75,
		damage * 1,
		damage * 1.5,
		damage * 2,
		damage * 3,
		damage * 4,
	}

	return damage_steps
end

local function _step_dmg_roamer_melee(damage)
	local damage_steps = {
		damage * 1,
		damage * 1,
		damage * 1.5,
		damage * 2,
		damage * 3,
		damage * 3.5,
	}

	return damage_steps
end

local function _step_dmg_berzerker_melee(damage)
	local damage_steps = {
		damage * 1,
		damage * 1.5,
		damage * 2,
		damage * 2.5,
		damage * 3,
		damage * 3.5,
	}

	return damage_steps
end

local function _step_dmg_melee(damage)
	local damage_steps = {
		damage * 1.25,
		damage * 2,
		damage * 2.5,
		damage * 3,
		damage * 4,
		damage * 5,
	}

	return damage_steps
end

local function _step_dmg_ranged(damage)
	local damage_steps = {
		damage * 0.75,
		damage * 1.25,
		damage * 1.5,
		damage * 2,
		damage * 2.5,
		damage * 3.5,
	}

	return damage_steps
end

local function _sup_scale(sup)
	local t = {
		sup * 1,
		sup * 1,
		sup * 1,
		sup * 1,
		sup * 1,
		sup * 2,
	}

	return t
end

local function _sup_div_scale(sup)
	local t = {
		sup * 1,
		sup * 1,
		sup * 1,
		sup * 1,
		sup * 1,
		sup / 3,
	}

	return t
end

local function _shoot_steps_asc(from, to, ceil)
	local steps = {
		0.75,
		0.85,
		1,
		1.25,
		1.5,
		2.5,
	}
	local shoot_steps = {}

	for ii = 1, #steps do
		local value = steps[ii]

		shoot_steps[ii] = ceil and {
			math.ceil(from * value),
			math.ceil(to * value),
		} or {
			from * value,
			to * value,
		}
	end

	return shoot_steps
end

local function _shoot_steps_desc(from, to, ceil)
	local steps = {
		1.5,
		1.35,
		1.2,
		1.05,
		0.925,
		0.925,
	}
	local shoot_steps = {}

	for ii = 1, #steps do
		local value = steps[ii]

		shoot_steps[ii] = ceil and {
			math.ceil(from * value),
			math.ceil(to * value),
		} or {
			from * value,
			to * value,
		}
	end

	return shoot_steps
end

minion_difficulty_settings.health = {
	chaos_poxwalker = _horde_health_steps(150),
	chaos_lesser_mutated_poxwalker = _horde_health_steps(160),
	chaos_mutated_poxwalker = _horde_health_steps(180),
	chaos_newly_infected = _horde_health_steps(120),
	chaos_armored_infected = _horde_health_steps(250),
	chaos_mutator_ritualist = _roamer_health_steps(1000),
	chaos_hound = _special_health_steps(700),
	chaos_hound_mutator = _special_health_steps(150),
	chaos_poxwalker_bomber = _special_health_steps(700),
	chaos_plague_ogryn = _monster_health_steps(20000),
	chaos_beast_of_nurgle = _monster_health_steps(17500),
	chaos_spawn = _monster_health_steps(15750),
	renegade_netgunner = _special_health_steps(450),
	cultist_mutant = _special_health_steps(2000),
	cultist_mutant_mutator = _special_health_steps(1000),
	cultist_captain = {
		14000,
		17500,
		21000,
		40000,
		50000,
	},
	cultist_flamer = _special_health_steps(700),
	renegade_flamer = _special_health_steps(700),
	renegade_flamer_mutator = _special_health_steps(700),
	cultist_grenadier = _special_health_steps(500),
	renegade_grenadier = _special_health_steps(375),
	renegade_sniper = _special_health_steps(250),
	chaos_ogryn_gunner = _elite_health_steps(2000),
	chaos_ogryn_bulwark = _elite_health_steps(2400),
	chaos_ogryn_executor = {
		1350,
		2250,
		2700,
		4875,
		6500,
	},
	chaos_daemonhost = _roamer_health_steps(16000),
	chaos_mutator_daemonhost = _roamer_health_steps(16000),
	renegade_captain = {
		16000,
		20000,
		24000,
		40000,
		50000,
	},
	renegade_melee = {
		250,
		313,
		375,
		650,
		815,
	},
	renegade_rifleman = {
		150,
		188,
		225,
		400,
		500,
	},
	renegade_assault = {
		180,
		225,
		270,
		500,
		625,
	},
	renegade_executor = {
		1250,
		1500,
		1875,
		2775,
		3700,
	},
	renegade_shocktrooper = {
		350,
		500,
		625,
		1125,
		1500,
	},
	renegade_plasma_gunner = _elite_health_steps(900),
	renegade_twin_captain = _monster_health_steps(24000),
	renegade_twin_captain_two = _monster_health_steps(24000),
	renegade_gunner = {
		450,
		600,
		900,
		1275,
		1700,
	},
	renegade_radio_operator = _elite_health_steps(1000),
	renegade_berzerker = {
		850,
		1000,
		1250,
		1875,
		2500,
	},
	cultist_berzerker = _elite_health_steps(1000),
	cultist_ritualist = _roamer_health_steps(1000),
	cultist_melee = _roamer_health_steps(275),
	cultist_assault = _roamer_health_steps(200),
	cultist_shocktrooper = _elite_health_steps(500),
	cultist_gunner = _elite_health_steps(700),
	companion_dog = _roamer_health_steps(700),
}
minion_difficulty_settings.hit_mass = {
	chaos_beast_of_nurgle = 20,
	chaos_daemonhost = 20,
	chaos_hound = 4,
	chaos_hound_mutator = 2,
	chaos_mutator_daemonhost = 20,
	chaos_ogryn_bulwark = 12.5,
	chaos_ogryn_executor = 12.5,
	chaos_ogryn_gunner = 12.5,
	chaos_plague_ogryn = 20,
	chaos_poxwalker_bomber = 2.5,
	chaos_spawn = 20,
	cultist_berzerker = 4,
	cultist_captain = 20,
	cultist_flamer = 2,
	cultist_grenadier = 2,
	cultist_gunner = 4,
	cultist_mutant = 10,
	cultist_mutant_mutator = 8,
	renegade_berzerker = 10,
	renegade_captain = 20,
	renegade_executor = 10,
	renegade_flamer = 2,
	renegade_flamer_mutator = 2,
	renegade_grenadier = 2,
	renegade_netgunner = 3,
	renegade_plasma_gunner = 4,
	renegade_sniper = 2,
	renegade_twin_captain = 4,
	renegade_twin_captain_two = 4,
	chaos_armored_infected = {
		1.5,
		1.5,
		1.5,
		1.5,
		1.5,
		2.5,
	},
	chaos_lesser_mutated_poxwalker = {
		1.25,
		1.25,
		1.25,
		1.5,
		1.5,
		1.5,
	},
	chaos_mutated_poxwalker = {
		1.25,
		1.25,
		1.25,
		1.5,
		1.5,
		1.5,
	},
	chaos_newly_infected = {
		1,
		1,
		1,
		1.25,
		1.25,
		1.25,
	},
	chaos_poxwalker = {
		1.25,
		1.25,
		1.25,
		1.5,
		1.5,
		1.5,
	},
	chaos_mutator_ritualist = {
		2.5,
		2.5,
		2.5,
		2.5,
		2.5,
		3,
	},
	cultist_assault = {
		1.75,
		1.75,
		1.75,
		1.75,
		1.75,
		2.5,
	},
	cultist_melee = {
		2.5,
		2.5,
		2.5,
		2.5,
		2.5,
		3,
	},
	cultist_ritualist = {
		2.5,
		2.5,
		2.5,
		2.5,
		2.5,
		3,
	},
	cultist_shocktrooper = {
		4,
		4,
		4,
		4,
		4,
		4,
	},
	renegade_assault = {
		1.5,
		1.5,
		1.5,
		1.5,
		1.5,
		2.5,
	},
	renegade_gunner = {
		5,
		5,
		5,
		5,
		5,
		8,
	},
	renegade_melee = {
		3.5,
		3.5,
		3.5,
		3.5,
		3.5,
		4,
	},
	renegade_radio_operator = {
		5,
		5,
		5,
		5,
		5,
		8,
	},
	renegade_rifleman = {
		1.5,
		1.5,
		1.5,
		1.5,
		1.5,
		2,
	},
	renegade_shocktrooper = {
		5,
		5,
		5,
		5,
		5,
		6,
	},
}
minion_difficulty_settings.power_level = {
	horde_default_melee = _step_dmg_horde_melee(400),
	renegade_default_melee = _step_dmg_roamer_melee(300),
	chaos_engulfed_enemy_fire_attack = {
		35,
		50,
		75,
		100,
		125,
		200,
	},
	chaos_ogryn_executor_melee = _step_dmg_melee(400),
	chaos_poxwalker_bomber_explosion = {
		200,
		250,
		300,
		350,
		400,
		500,
	},
	chaos_ogryn_default_melee = _step_dmg_melee(500),
	chaos_ogryn_default_ranged = _step_dmg_ranged(320),
	chaos_daemonhost_melee = {
		350,
		600,
		800,
		1000,
		1250,
		1600,
	},
	renegade_default_shot = _step_dmg_ranged(275),
	renegade_executor_melee = _step_dmg_melee(300),
	renegade_gunner_shot = _step_dmg_ranged(325),
	renegade_plasma_gunner = _step_dmg_ranged(550),
	renegade_radio_operator_shot = _step_dmg_ranged(325),
	renegade_shotgun_shot = _step_dmg_ranged(300),
	renegade_assault_shot = _step_dmg_ranged(225),
	cultist_assault_shot = _step_dmg_ranged(250),
	cultist_captain_melee_one_hand = {
		75,
		100,
		250,
		400,
		600,
	},
	cultist_captain_melee_two_hand = {
		250,
		500,
		750,
		1000,
		1250,
	},
	cultist_captain_default_shot = _step_dmg_ranged(225),
	cultist_flamer_default = _step_dmg_ranged(50),
	cultist_flamer_on_hit_fire = {
		35,
		50,
		75,
		100,
		125,
		200,
	},
	cultist_flamer_fire = {
		100,
		125,
		150,
		175,
		200,
		300,
	},
	renegade_flamer_default = _step_dmg_ranged(50),
	renegade_flamer_on_hit_fire = {
		35,
		50,
		75,
		100,
		125,
	},
	renegade_flamer_fire = {
		100,
		125,
		150,
		175,
		200,
	},
	renegade_grenadier_fire = _step_dmg_ranged(100),
	renegade_sniper_shot = {
		125,
		175,
		200,
		300,
		350,
		600,
	},
	renegade_captain_melee_one_hand = {
		75,
		100,
		250,
		400,
		600,
	},
	renegade_captain_melee_two_hand = {
		100,
		150,
		300,
		500,
		800,
	},
	renegade_captain_default_shot = _step_dmg_ranged(350),
	daemonhost_corruption_aura = {
		6,
		15,
		20,
		30,
		40,
		60,
	},
	chaos_spawn_melee = {
		250,
		400,
		600,
		700,
		800,
		1000,
	},
	chaos_plague_ogryn_melee = {
		250,
		400,
		600,
		700,
		800,
		1200,
	},
	chaos_beast_of_nurgle_melee = {
		150,
		250,
		300,
		350,
		400,
		600,
	},
	chaos_beast_of_nurgle_ranged = {
		25,
		40,
		50,
		60,
		70,
		100,
	},
	chaos_beast_of_nurgle_hit_by_vomit_tick = {
		1,
		2,
		3,
		6,
		8,
		12,
	},
	chaos_beast_of_nurgle_being_eaten = {
		0.2,
		0.2,
		0.3,
		0.3,
		0.3,
		0.3,
	},
	berzerker_default_melee = _step_dmg_berzerker_melee(400),
	renegade_twin_captain_two_melee = {
		80,
		100,
		120,
		200,
		225,
		250,
	},
}
minion_difficulty_settings.shooting = {
	chaos_ogryn_gunner = {
		aim_durations = _equal_difficulty_values(1, 1),
		shoot_cooldown = _shoot_steps_desc(2, 3),
		time_per_shot = _equal_difficulty_values(0.1, 0.1),
		num_shots = _shoot_steps_asc(60, 60, true),
	},
	cultist_flamer = {
		aim_durations = {
			{
				1,
				1,
			},
			{
				0.8,
				0.8,
			},
			{
				0.7,
				0.7,
			},
			{
				0.6,
				0.6,
			},
			{
				0.55,
				0.55,
			},
		},
		shoot_cooldown = _shoot_steps_desc(3, 4),
		time_per_shot = _equal_difficulty_values(0.35, 0.35),
	},
	renegade_flamer = {
		aim_durations = {
			{
				1,
				1,
			},
			{
				0.8,
				0.8,
			},
			{
				0.7,
				0.7,
			},
			{
				0.6,
				0.6,
			},
			{
				0.55,
				0.55,
			},
		},
		shoot_cooldown = _shoot_steps_desc(3, 4),
		time_per_shot = _equal_difficulty_values(0.35, 0.35),
	},
	renegade_assault = {
		aim_durations = _equal_difficulty_values(0.6, 0.8),
		shoot_cooldown = _shoot_steps_desc(1, 1.25),
		time_per_shot = _equal_difficulty_values(0.085, 0.085),
		num_shots = _equal_difficulty_values(4, 4),
		shoot_dodge_window = _equal_difficulty_values(0.5, 0.5),
	},
	renegade_gunner = {
		aim_durations = _shoot_steps_desc(0.5, 0.75),
		shoot_cooldown = _shoot_steps_desc(2, 3),
		time_per_shot = _equal_difficulty_values(0.0923, 0.0923),
		num_shots = _shoot_steps_asc(50, 50, true),
		num_shots_cover = _shoot_steps_asc(50, 50, true),
	},
	renegade_radio_operator = {
		aim_durations = _shoot_steps_desc(0.5, 0.75),
		shoot_cooldown = _shoot_steps_desc(2, 3),
		time_per_shot = _equal_difficulty_values(0.0923, 0.0923),
		num_shots = _shoot_steps_asc(50, 50, true),
		num_shots_cover = _shoot_steps_asc(50, 50, true),
	},
	renegade_netgunner = {
		num_shots = {
			1,
			1,
			1,
			1,
			1,
		},
	},
	renegade_rifleman = {
		aim_durations = _shoot_steps_desc(0.3, 0.5),
		shoot_cooldown = _shoot_steps_desc(2.25, 2.75),
		time_per_shot = _equal_difficulty_values(0.2, 0.25),
		time_per_shot_tg_sprint = _equal_difficulty_values(0.4, 0.6),
		num_shots = _equal_difficulty_values(2, 3),
		num_shots_cover = _equal_difficulty_values(2, 4, true),
		shoot_dodge_window = _equal_difficulty_values(0.5, 0.5),
	},
	renegade_shocktrooper = {
		aim_durations = _equal_difficulty_values(0.1, 0.2),
		shoot_cooldown = _shoot_steps_desc(1, 1.25),
		time_per_shot = _equal_difficulty_values(0, 0),
		num_shots = _equal_difficulty_values(10, 10),
		shoot_dodge_window = _equal_difficulty_values(0.75, 0.75),
	},
	renegade_plasma_gunner = {
		aim_durations = _shoot_steps_desc(0.75, 0.75),
		shoot_cooldown = _shoot_steps_desc(2, 2.4),
		time_per_shot = _equal_difficulty_values(2, 2),
		num_shots = _equal_difficulty_values(1, 1),
		shoot_dodge_window = _equal_difficulty_values(0.6, 0.6),
	},
	cultist_assault = {
		aim_durations = _shoot_steps_desc(0.4, 0.5),
		shoot_cooldown = _shoot_steps_desc(1.5, 2),
		time_per_shot = _equal_difficulty_values(0.0923, 0.0923),
		num_shots = _equal_difficulty_values(4, 5, true),
		shoot_dodge_window = _equal_difficulty_values(0.5, 0.5),
		num_shots_cover = _equal_difficulty_values(4, 7, true),
	},
	cultist_gunner = {
		aim_durations = _shoot_steps_desc(0.5, 0.75),
		shoot_cooldown = _shoot_steps_desc(2, 3),
		time_per_shot = _equal_difficulty_values(0.1, 0.1),
		num_shots = _shoot_steps_asc(40, 40, true),
		num_shots_cover = _shoot_steps_asc(40, 40, true),
	},
	renegade_twin_captain_las_pistol = {
		aim_durations = _equal_difficulty_values(0.25, 0.25),
		shoot_cooldown = _equal_difficulty_values(2, 2),
		time_per_shot = _equal_difficulty_values(0.225, 0.35),
		num_shots = _equal_difficulty_values(5, 6),
		shoot_dodge_window = _equal_difficulty_values(0.5, 0.5),
	},
	renegade_captain_bolt_pistol = {
		aim_durations = _shoot_steps_desc(0.75, 0.75),
		shoot_cooldown = _shoot_steps_desc(2, 2.5),
		time_per_shot = _equal_difficulty_values(1.25, 1.25),
		num_shots = _equal_difficulty_values(5, 5),
		shoot_dodge_window = _equal_difficulty_values(0.5, 0.5),
	},
	renegade_captain_plasma_pistol = {
		aim_durations = _shoot_steps_desc(0.75, 0.75),
		shoot_cooldown = _shoot_steps_desc(2, 2.5),
		time_per_shot = _equal_difficulty_values(1.5, 1.5),
		num_shots = _equal_difficulty_values(1, 1),
		shoot_dodge_window = _equal_difficulty_values(0.5, 0.5),
	},
	renegade_captain_plasma_pistol_volley = {
		aim_durations = _shoot_steps_desc(1.25, 1.25),
		shoot_cooldown = _shoot_steps_desc(2, 2.5),
		time_per_shot = _equal_difficulty_values(1.5, 1.5),
		num_shots = _equal_difficulty_values(8, 8),
		shoot_dodge_window = _equal_difficulty_values(0.5, 0.5),
	},
	renegade_captain_burst = {
		aim_durations = _shoot_steps_desc(0.3, 0.5),
		shoot_cooldown = _shoot_steps_desc(0.5, 0.7),
		time_per_shot = _equal_difficulty_values(0.0923, 0.0923),
		num_shots = _shoot_steps_asc(10, 10, true),
		shoot_dodge_window = _equal_difficulty_values(0.5, 0.5),
	},
	renegade_captain_fullauto = {
		aim_durations = _shoot_steps_desc(1, 1.25),
		shoot_cooldown = _shoot_steps_desc(0.5, 0.7),
		time_per_shot = _equal_difficulty_values(0.0923, 0.0923),
		num_shots = _shoot_steps_asc(125, 125, true),
	},
	renegade_captain_shoot_sweep = {
		aim_durations = _shoot_steps_desc(0.3, 0.5),
		shoot_cooldown = _shoot_steps_desc(0.5, 0.7),
		time_per_shot = _equal_difficulty_values(0.0723, 0.0723),
		num_shots = _shoot_steps_asc(100, 100, true),
	},
	renegade_captain_netgun = {
		num_shots = {
			1,
			1,
			1,
			1,
			2,
		},
	},
	renegade_captain_shotgun = {
		aim_durations = _shoot_steps_desc(0.4, 0.5),
		shoot_cooldown = _shoot_steps_desc(1, 1.5),
		time_per_shot = _equal_difficulty_values(0, 0),
		num_shots = _equal_difficulty_values(12, 12),
		shoot_dodge_window = _equal_difficulty_values(0.75, 0.75),
	},
	renegade_twin_captain_plasma_pistol = {
		aim_durations = _shoot_steps_desc(0.25, 0.25),
		shoot_cooldown = _shoot_steps_desc(1.25, 1.8),
		time_per_shot = _equal_difficulty_values(0, 0),
		num_shots = _equal_difficulty_values(1, 1),
		shoot_dodge_window = _equal_difficulty_values(0.75, 0.75),
	},
}
minion_difficulty_settings.tension_to_add = {
	killed_by_daemonhost = {
		120,
		75,
		75,
		75,
		75,
		20,
	},
	knocked_down = {
		120,
		80,
		60,
		60,
		60,
		20,
	},
	netted = {
		15,
		15,
		15,
		15,
		15,
		5,
	},
	pounced = {
		60,
		20,
		20,
		20,
		20,
		10,
	},
	died = {
		60,
		60,
		60,
		60,
		60,
		20,
	},
}
minion_difficulty_settings.damage_tension_to_add = {
	damaged = {
		0.3,
		0.2,
		0.175,
		0.1,
		0.05,
	},
	absorbed_damage = {
		0.05,
		0.04,
		0.03,
		0.02,
		0.01,
	},
}
minion_difficulty_settings.cooldowns = {
	chaos_hound_pounce = {
		10,
		8,
		6,
		5,
		4,
	},
	chaos_hound_pounce_fail = {
		6,
		6,
		4,
		3,
		3,
	},
	shoot_net_cooldown = {
		12,
		12,
		12,
		12,
		12,
	},
	grenadier_throw = {
		10,
		8,
		6,
		4,
		3,
	},
	cultist_grenadier_throw = {
		16,
		14,
		12,
		10,
		8,
	},
}
minion_difficulty_settings.terror_event_point_costs = {
	1,
	1.25,
	1.5,
	2,
	2.5,
}
minion_difficulty_settings.terror_event_duration_modifier = {
	1,
	1,
	0.9,
	0.75,
	0.5,
}
minion_difficulty_settings.suppression = {
	renegade_rifleman = {
		above_threshold_decay_multiplier = 2,
		disable_cover_threshold = 25,
		max_value = {
			melee = _sup_scale(25),
			close = _sup_scale(25),
			far = _sup_scale(25),
		},
		threshold = {
			melee = _sup_scale(10),
			close = _sup_scale(10),
			far = _sup_scale(10),
		},
		decay_speeds = {
			melee = _sup_div_scale(0.05),
			close = _sup_div_scale(0.3),
			far = _sup_div_scale(0.5),
		},
		immunity_duration = {
			0.25,
			0.5,
		},
	},
	cultist_assault = {
		above_threshold_decay_multiplier = 2,
		max_value = {
			melee = _sup_scale(35),
			close = _sup_scale(35),
			far = _sup_scale(25),
		},
		threshold = {
			melee = _sup_scale(20),
			close = _sup_scale(20),
			far = _sup_scale(10),
		},
		decay_speeds = {
			melee = _sup_div_scale(0.05),
			close = _sup_div_scale(0.3),
			far = _sup_div_scale(0.5),
		},
		disable_cover_threshold = {
			close = 20,
			far = 15,
			melee = 20,
		},
		immunity_duration = {
			0.25,
			0.5,
		},
	},
	renegade_assault = {
		max_value = {
			melee = _sup_scale(50),
			close = _sup_scale(30),
			far = _sup_scale(15),
		},
		threshold = {
			melee = _sup_scale(44),
			close = _sup_scale(25),
			far = _sup_scale(10),
		},
		decay_speeds = {
			melee = _sup_div_scale(0.05),
			close = _sup_div_scale(0.25),
			far = _sup_div_scale(0.5),
		},
		immunity_duration = {
			0.25,
			0.5,
		},
	},
	chaos_newly_infected = {
		above_threshold_decay_multiplier = 2,
		max_value = {
			melee = _sup_scale(40),
			close = _sup_scale(40),
			far = _sup_scale(25),
		},
		threshold = {
			melee = _sup_scale(30),
			close = _sup_scale(30),
			far = _sup_scale(10),
		},
		decay_speeds = {
			melee = _sup_div_scale(0.05),
			close = _sup_div_scale(0.3),
			far = _sup_div_scale(0.5),
		},
		disable_cover_threshold = {
			close = 20,
			far = 15,
			melee = 20,
		},
		immunity_duration = {
			0.2,
			0.25,
		},
	},
	renegade_melee = {
		max_value = {
			melee = _sup_scale(20),
			close = _sup_scale(20),
			far = _sup_scale(20),
		},
		threshold = {
			melee = _sup_scale(20),
			close = _sup_scale(20),
			far = _sup_scale(20),
		},
		decay_speeds = {
			melee = _sup_div_scale(0.05),
			close = _sup_div_scale(0.2),
			far = _sup_div_scale(0.2),
		},
		immunity_duration = {
			0.75,
			1.25,
		},
	},
	chaos_ogryn_gunner = {
		ignore_attack_delay = true,
		max_value = {
			melee = _sup_scale(50),
			close = _sup_scale(50),
			far = _sup_scale(50),
		},
		threshold = {
			melee = _sup_scale(45),
			close = _sup_scale(45),
			far = _sup_scale(45),
		},
		decay_speeds = {
			melee = _sup_div_scale(0.05),
			close = _sup_div_scale(0.3),
			far = _sup_div_scale(0.3),
		},
		immunity_duration = {
			2.75,
			3.25,
		},
	},
	cultist_gunner = {
		above_threshold_decay_multiplier = 2,
		disable_cover_threshold = 35,
		max_value = {
			melee = _sup_scale(40),
			close = _sup_scale(40),
			far = _sup_scale(40),
		},
		threshold = {
			melee = _sup_scale(27.5),
			close = _sup_scale(27.5),
			far = _sup_scale(27.5),
		},
		decay_speeds = {
			melee = _sup_div_scale(0.05),
			close = _sup_div_scale(0.3),
			far = _sup_div_scale(0.5),
		},
		immunity_duration = {
			0.25,
			0.5,
		},
	},
	renegade_gunner = {
		above_threshold_decay_multiplier = 2,
		disable_cover_threshold = 35,
		max_value = {
			melee = _sup_scale(40),
			close = _sup_scale(40),
			far = _sup_scale(40),
		},
		threshold = {
			melee = _sup_scale(27.5),
			close = _sup_scale(27.5),
			far = _sup_scale(27.5),
		},
		decay_speeds = {
			melee = _sup_div_scale(0.05),
			close = _sup_div_scale(0.3),
			far = _sup_div_scale(0.5),
		},
		immunity_duration = {
			0.25,
			0.5,
		},
	},
	renegade_radio_operator = {
		above_threshold_decay_multiplier = 2,
		disable_cover_threshold = 35,
		max_value = {
			melee = _sup_scale(40),
			close = _sup_scale(40),
			far = _sup_scale(40),
		},
		threshold = {
			melee = _sup_scale(27.5),
			close = _sup_scale(27.5),
			far = _sup_scale(27.5),
		},
		decay_speeds = {
			melee = _sup_div_scale(0.05),
			close = _sup_div_scale(0.3),
			far = _sup_div_scale(0.5),
		},
		immunity_duration = {
			0.25,
			0.5,
		},
	},
	renegade_executor = {
		max_value = {
			melee = _sup_scale(50),
			close = _sup_scale(50),
			far = _sup_scale(50),
		},
		threshold = {
			melee = _sup_scale(40),
			close = _sup_scale(40),
			far = _sup_scale(40),
		},
		decay_speeds = {
			melee = _sup_div_scale(0.05),
			close = _sup_div_scale(0.2),
			far = _sup_div_scale(0.5),
		},
		flinch_threshold = math.huge,
		immunity_duration = {
			2.75,
			3.25,
		},
	},
	renegade_sniper = {
		max_value = {
			melee = _sup_scale(30),
			close = _sup_scale(30),
			far = _sup_scale(30),
		},
		threshold = {
			melee = _sup_scale(20),
			close = _sup_scale(20),
			far = _sup_scale(20),
		},
		decay_speeds = {
			melee = _sup_div_scale(0.05),
			close = _sup_div_scale(0.2),
			far = _sup_div_scale(0.5),
		},
		immunity_duration = {
			2.75,
			3.25,
		},
		suppression_types_allowed = {
			ability = true,
		},
	},
}

return settings("MinionDifficultySettings", minion_difficulty_settings)
