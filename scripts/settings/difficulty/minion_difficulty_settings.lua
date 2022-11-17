local minion_difficulty_settings = {}

local function _equal_difficulty_values(val, val_2)
	local diff_table = {}

	for i = 1, 5 do
		diff_table[i] = {
			val,
			val_2
		}
	end

	return diff_table
end

local function _health_steps(health)
	local health_steps = {
		health * 0.65,
		health * 0.8,
		health * 1,
		health * 1.5,
		health * 2
	}

	return health_steps
end

local function _elite_health_steps(health)
	local health_steps = {
		health * 0.75,
		health * 0.75,
		health * 1,
		health * 1.25,
		health * 1.5
	}

	return health_steps
end

local function _step_dmg(damage)
	local damage_steps = {
		damage * 0.5,
		damage * 0.75,
		damage * 1,
		damage * 1.5,
		damage * 2
	}

	return damage_steps
end

local function _shoot_steps_asc(from, to, ceil)
	local steps = {
		0.75,
		0.85,
		1,
		1.25,
		1.5
	}
	local shoot_steps = {}

	for i = 1, #steps do
		local value = steps[i]
		shoot_steps[i] = ceil and {
			math.ceil(from * value),
			math.ceil(to * value)
		} or {
			from * value,
			to * value
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
		0.925
	}
	local shoot_steps = {}

	for i = 1, #steps do
		local value = steps[i]
		shoot_steps[i] = ceil and {
			math.ceil(from * value),
			math.ceil(to * value)
		} or {
			from * value,
			to * value
		}
	end

	return shoot_steps
end

minion_difficulty_settings.health = {
	chaos_poxwalker = _health_steps(150),
	chaos_newly_infected = _health_steps(100),
	chaos_hound = _health_steps(900),
	chaos_poxwalker_bomber = _health_steps(700),
	chaos_plague_ogryn = _health_steps(16000),
	chaos_plague_ogryn_sprayer = _health_steps(16000),
	chaos_beast_of_nurgle = _health_steps(16000),
	renegade_netgunner = _health_steps(450),
	cultist_mutant = _health_steps(2000),
	cultist_flamer = _health_steps(750),
	renegade_flamer = _health_steps(750),
	cultist_grenadier = _health_steps(400),
	renegade_grenadier = _health_steps(400),
	renegade_sniper = _health_steps(250),
	chaos_ogryn_gunner = _elite_health_steps(2500),
	chaos_ogryn_bulwark = _elite_health_steps(1800),
	chaos_ogryn_executor = _elite_health_steps(1700),
	chaos_daemonhost = _health_steps(16000),
	renegade_captain = _health_steps(16000),
	renegade_melee = _health_steps(200),
	renegade_rifleman = _health_steps(150),
	renegade_assault = _health_steps(180),
	renegade_executor = _elite_health_steps(1200),
	renegade_shocktrooper = _elite_health_steps(500),
	renegade_gunner = _elite_health_steps(600),
	renegade_berzerker = _elite_health_steps(900),
	cultist_melee = _health_steps(225),
	cultist_assault = _health_steps(200),
	cultist_shocktrooper = _elite_health_steps(500),
	cultist_gunner = _elite_health_steps(700),
	cultist_berzerker = _elite_health_steps(900)
}
minion_difficulty_settings.power_level = {
	chaos_ogryn_executor_melee = _step_dmg(500),
	chaos_poxwalker_bomber_explosion = {
		200,
		250,
		300,
		350,
		400
	},
	chaos_ogryn_default_melee = _step_dmg(500),
	chaos_ogryn_default_ranged = _step_dmg(320),
	chaos_daemonhost_melee = {
		350,
		600,
		800,
		1000,
		1250
	},
	renegade_default_melee = _step_dmg(400),
	renegade_default_shot = _step_dmg(400),
	renegade_executor_melee = _step_dmg(500),
	renegade_gunner_shot = _step_dmg(300),
	renegade_shotgun_shot = _step_dmg(250),
	renegade_assault_shot = _step_dmg(225),
	cultist_assault_shot = _step_dmg(270),
	cultist_flamer_default = _step_dmg(50),
	cultist_flamer_on_hit_fire = {
		35,
		50,
		75,
		100,
		125
	},
	cultist_flamer_fire = {
		75,
		100,
		125,
		150,
		175
	},
	renegade_flamer_default = _step_dmg(50),
	renegade_flamer_on_hit_fire = {
		35,
		50,
		75,
		100,
		125
	},
	renegade_flamer_fire = {
		75,
		100,
		125,
		150,
		175
	},
	renegade_grenadier_fire = _step_dmg(100),
	renegade_sniper_shot = {
		125,
		175,
		200,
		300,
		350
	},
	renegade_captain_melee_one_hand = {
		75,
		100,
		250,
		400,
		600
	},
	renegade_captain_melee_two_hand = {
		100,
		150,
		300,
		500,
		800
	},
	renegade_captain_default_shot = _step_dmg(225),
	daemonhost_corruption_aura = {
		6,
		15,
		20,
		30,
		40
	},
	chaos_plague_ogryn_melee = {
		250,
		400,
		600,
		700,
		800
	},
	chaos_beast_of_nurgle_melee = {
		150,
		250,
		300,
		350,
		400
	},
	chaos_beast_of_nurgle_ranged = {
		25,
		40,
		50,
		60,
		70
	},
	chaos_beast_of_nurgle_hit_by_vomit_tick = {
		1,
		2,
		3,
		6,
		8
	},
	chaos_beast_of_nurgle_being_eaten = {
		0.35,
		0.425,
		0.5,
		0.5,
		0.5
	}
}
minion_difficulty_settings.shooting = {
	chaos_ogryn_gunner = {
		aim_durations = _equal_difficulty_values(1.3, 1.3),
		shoot_cooldown = _shoot_steps_desc(2, 3),
		time_per_shot = _equal_difficulty_values(0.115, 0.115),
		num_shots = _shoot_steps_asc(60, 60, true)
	},
	cultist_flamer = {
		aim_durations = _equal_difficulty_values(1, 1),
		shoot_cooldown = _shoot_steps_desc(3, 4),
		time_per_shot = _equal_difficulty_values(0.35, 0.35)
	},
	renegade_flamer = {
		aim_durations = _equal_difficulty_values(1, 1),
		shoot_cooldown = _shoot_steps_desc(3, 4),
		time_per_shot = _equal_difficulty_values(0.35, 0.35)
	},
	renegade_assault = {
		aim_durations = _shoot_steps_desc(0.6, 0.8),
		shoot_cooldown = _shoot_steps_desc(0.75, 1),
		time_per_shot = _equal_difficulty_values(0.085, 0.085),
		num_shots = _equal_difficulty_values(4, 4),
		shoot_dodge_window = _equal_difficulty_values(0.5, 0.5)
	},
	renegade_gunner = {
		aim_durations = _shoot_steps_desc(0.5, 0.75),
		shoot_cooldown = _shoot_steps_desc(2, 3),
		time_per_shot = _equal_difficulty_values(0.0923, 0.0923),
		num_shots = _shoot_steps_asc(50, 50, true),
		num_shots_cover = _shoot_steps_asc(50, 50, true)
	},
	renegade_netgunner = {
		num_shots = {
			1,
			1,
			1,
			1,
			1
		}
	},
	renegade_rifleman = {
		aim_durations = _shoot_steps_desc(0.2, 0.45),
		shoot_cooldown = _shoot_steps_desc(2, 2.5),
		time_per_shot = _equal_difficulty_values(0.2, 0.25),
		time_per_shot_tg_sprint = _equal_difficulty_values(0.4, 0.6),
		num_shots = _equal_difficulty_values(2, 3),
		num_shots_cover = _equal_difficulty_values(2, 4, true)
	},
	renegade_shocktrooper = {
		aim_durations = _shoot_steps_desc(0.1, 0.2),
		shoot_cooldown = _shoot_steps_desc(1, 1.25),
		time_per_shot = _equal_difficulty_values(0, 0),
		num_shots = _equal_difficulty_values(10, 10),
		shoot_dodge_window = _equal_difficulty_values(0.75, 0.75)
	},
	cultist_assault = {
		aim_durations = _shoot_steps_desc(0.4, 0.5),
		shoot_cooldown = _shoot_steps_desc(1, 1.25),
		time_per_shot = _equal_difficulty_values(0.0923, 0.0923),
		num_shots = _equal_difficulty_values(4, 5, true),
		shoot_dodge_window = _equal_difficulty_values(0.5, 0.5),
		num_shots_cover = _shoot_steps_asc(4, 7, true)
	},
	cultist_gunner = {
		aim_durations = _shoot_steps_desc(0.5, 0.75),
		shoot_cooldown = _shoot_steps_desc(2, 3),
		time_per_shot = _equal_difficulty_values(0.1, 0.1),
		num_shots = _shoot_steps_asc(40, 40, true),
		num_shots_cover = _shoot_steps_asc(40, 40, true)
	},
	renegade_captain_bolt_pistol = {
		aim_durations = _shoot_steps_desc(0.75, 0.75),
		shoot_cooldown = _shoot_steps_desc(2, 2.5),
		time_per_shot = _equal_difficulty_values(1.25, 1.25),
		num_shots = _equal_difficulty_values(5, 5),
		shoot_dodge_window = _equal_difficulty_values(0.5, 0.5)
	},
	renegade_captain_plasma_pistol = {
		aim_durations = _shoot_steps_desc(0.75, 0.75),
		shoot_cooldown = _shoot_steps_desc(2, 2.5),
		time_per_shot = _equal_difficulty_values(1.5, 1.5),
		num_shots = _equal_difficulty_values(3, 3),
		shoot_dodge_window = _equal_difficulty_values(0.5, 0.5)
	},
	renegade_captain_plasma_pistol_volley = {
		aim_durations = _shoot_steps_desc(1.25, 1.25),
		shoot_cooldown = _shoot_steps_desc(2, 2.5),
		time_per_shot = _equal_difficulty_values(1.5, 1.5),
		num_shots = _equal_difficulty_values(8, 8),
		shoot_dodge_window = _equal_difficulty_values(0.5, 0.5)
	},
	renegade_captain_burst = {
		aim_durations = _shoot_steps_desc(0.3, 0.5),
		shoot_cooldown = _shoot_steps_desc(0.5, 0.7),
		time_per_shot = _equal_difficulty_values(0.0923, 0.0923),
		num_shots = _shoot_steps_asc(10, 10, true),
		shoot_dodge_window = _equal_difficulty_values(0.5, 0.5)
	},
	renegade_captain_fullauto = {
		aim_durations = _shoot_steps_desc(1, 1.25),
		shoot_cooldown = _shoot_steps_desc(0.5, 0.7),
		time_per_shot = _equal_difficulty_values(0.0923, 0.0923),
		num_shots = _shoot_steps_asc(125, 125, true)
	},
	renegade_captain_shoot_sweep = {
		aim_durations = _shoot_steps_desc(0.3, 0.5),
		shoot_cooldown = _shoot_steps_desc(0.5, 0.7),
		time_per_shot = _equal_difficulty_values(0.0723, 0.0723),
		num_shots = _shoot_steps_asc(100, 100, true)
	},
	renegade_captain_netgun = {
		num_shots = {
			1,
			1,
			1,
			1,
			2
		}
	},
	renegade_captain_shotgun = {
		aim_durations = _shoot_steps_desc(0.4, 0.5),
		shoot_cooldown = _shoot_steps_desc(1, 1.5),
		time_per_shot = _equal_difficulty_values(0, 0),
		num_shots = _equal_difficulty_values(12, 12),
		shoot_dodge_window = _equal_difficulty_values(0.75, 0.75)
	}
}
minion_difficulty_settings.tension_to_add = {
	killed_by_daemonhost = {
		75,
		75,
		75,
		75,
		75
	},
	knocked_down = {
		60,
		60,
		60,
		60,
		60
	},
	netted = {
		15,
		15,
		15,
		15,
		15
	},
	pounced = {
		30,
		20,
		20,
		20,
		20
	},
	died = {
		60,
		60,
		60,
		60,
		60
	}
}
minion_difficulty_settings.damage_tension_to_add = {
	damaged = {
		0.3,
		0.2,
		0.175,
		0.125,
		0.1
	},
	absorbed_damage = {
		0.05,
		0.04,
		0.03,
		0.02,
		0.01
	}
}
minion_difficulty_settings.cooldowns = {
	chaos_hound_pounce = {
		10,
		8,
		6,
		5,
		4
	},
	chaos_hound_pounce_fail = {
		6,
		6,
		4,
		3,
		2
	},
	shoot_net_cooldown = {
		10,
		10,
		10,
		10,
		10
	},
	grenadier_throw = {
		10,
		8,
		6,
		4,
		3
	}
}
minion_difficulty_settings.terror_event_point_costs = {
	1,
	1.25,
	1.75,
	2.25,
	2.75
}

return settings("MinionDifficultySettings", minion_difficulty_settings)
