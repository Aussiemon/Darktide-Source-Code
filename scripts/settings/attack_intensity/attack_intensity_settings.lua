﻿-- chunkname: @scripts/settings/attack_intensity/attack_intensity_settings.lua

local attack_intensity_settings = {}

attack_intensity_settings.constants = {
	default_attack_intensity_clamp = 15,
	low_intensity_grace_mod = 0.25,
	low_intensity_threshold = 0.2,
	sprint_decay_multiplier = 4,
	zero_dogpile_decay_multiplier = 2,
}
attack_intensity_settings.attacked_allowed_time_range = {
	{
		0.3,
		0.4,
	},
	{
		0.2,
		0.3,
	},
	{
		0.15,
		0.2,
	},
	{
		0.1,
		0.15,
	},
	{
		0.025,
		0.05,
	},
}
attack_intensity_settings.locked_in_melee_settings = {
	delay = 0.5,
	radius = 4.5,
	update_frequency = 0.1,
	needed_challenge_rating = {
		0.75,
		1.25,
		3,
		4,
		6,
	},
	default_melee_kill_delay = {
		1,
		0.75,
		0.5,
		0.4,
		0.25,
	},
}
attack_intensity_settings.toughness_broken_grace = {
	{
		duration = 2,
		spread_multiplier = 3,
	},
	{
		duration = 2,
		spread_multiplier = 3,
	},
	{
		duration = 1.5,
		spread_multiplier = 2.5,
	},
	{
		duration = 1.25,
		spread_multiplier = 2,
	},
	{
		duration = 1,
		spread_multiplier = 2,
	},
	{
		dont_max_out_intensity = true,
		duration = 1,
		spread_multiplier = 4,
	},
}
attack_intensity_settings.toughness_broken_grace_cooldown = {
	1.5,
	2,
	3,
	5,
	8,
	20,
}
attack_intensity_settings.toughness_broken_grace_power_multiplier = {
	0.15,
	0.2,
	0.3,
	0.4,
	0.5,
	0.75,
}
attack_intensity_settings.attack_intensities = {
	melee = {
		{
			attack_allowed_decay_multiplier = 0.25,
			attack_intensity_clamp = 8,
			decay = 1,
			decay_grace = 0.5,
			reset = 0.25,
			threshold = 3,
			ignored_movement_states = {
				sprint = true,
			},
		},
		{
			attack_allowed_decay_multiplier = 0.25,
			attack_intensity_clamp = 12,
			decay = 2,
			decay_grace = 0.25,
			reset = 0.25,
			threshold = 6,
			ignored_movement_states = {
				sprint = true,
			},
		},
		{
			attack_allowed_decay_multiplier = 0.25,
			attack_intensity_clamp = 14,
			decay = 3,
			decay_grace = 0.25,
			reset = 0.25,
			threshold = 10,
			ignored_movement_states = {
				sprint = true,
			},
		},
		{
			attack_allowed_decay_multiplier = 0.25,
			attack_intensity_clamp = 20,
			decay = 8,
			decay_grace = 0.25,
			reset = 0.25,
			threshold = 16,
			ignored_movement_states = {
				sprint = true,
			},
		},
		{
			attack_allowed_decay_multiplier = 0.25,
			attack_intensity_clamp = 25,
			decay = 12,
			decay_grace = 0.25,
			reset = 0.25,
			threshold = 20,
			ignored_movement_states = {
				sprint = true,
			},
		},
		{
			attack_allowed_decay_multiplier = 0.25,
			attack_intensity_clamp = 45,
			decay = 20,
			decay_grace = 0.25,
			reset = 0.25,
			threshold = 40,
			ignored_movement_states = {
				sprint = true,
			},
		},
	},
	moving_melee = {
		{
			attack_allowed_decay_multiplier = 0.25,
			attack_intensity_clamp = 10,
			decay = 1,
			decay_grace = 0.5,
			reset = 0.25,
			threshold = 3,
			ignored_movement_states = {
				sprint = true,
			},
		},
		{
			attack_allowed_decay_multiplier = 0.25,
			attack_intensity_clamp = 10,
			decay = 2,
			decay_grace = 0.5,
			reset = 0.25,
			threshold = 6,
			ignored_movement_states = {
				sprint = true,
			},
		},
		{
			attack_allowed_decay_multiplier = 0.25,
			attack_intensity_clamp = 15,
			decay = 4,
			decay_grace = 0.5,
			reset = 0.25,
			threshold = 12,
			ignored_movement_states = {
				sprint = true,
			},
		},
		{
			attack_allowed_decay_multiplier = 0.25,
			attack_intensity_clamp = 20,
			decay = 8,
			decay_grace = 0.5,
			reset = 0.25,
			threshold = 16,
			ignored_movement_states = {
				sprint = true,
			},
		},
		{
			attack_allowed_decay_multiplier = 0.25,
			attack_intensity_clamp = 28,
			decay = 12,
			decay_grace = 0.5,
			reset = 0.25,
			threshold = 24,
			ignored_movement_states = {
				sprint = true,
			},
		},
		{
			attack_allowed_decay_multiplier = 0.25,
			attack_intensity_clamp = 55,
			decay = 20,
			decay_grace = 0.5,
			reset = 0.25,
			threshold = 48,
			ignored_movement_states = {
				sprint = true,
			},
		},
	},
	running_melee = {
		{
			attack_allowed_decay_multiplier = 0.25,
			attack_intensity_clamp = 6,
			decay = 0.75,
			decay_grace = 1,
			reset = 0.25,
			threshold = 2,
			ignored_movement_states = {
				sprint = true,
			},
		},
		{
			attack_allowed_decay_multiplier = 0.25,
			attack_intensity_clamp = 7,
			decay = 0.75,
			decay_grace = 1,
			reset = 0.25,
			threshold = 3,
			ignored_movement_states = {
				sprint = true,
			},
		},
		{
			attack_allowed_decay_multiplier = 0.25,
			attack_intensity_clamp = 8,
			decay = 2,
			decay_grace = 1,
			reset = 0.25,
			threshold = 5,
			ignored_movement_states = {
				sprint = true,
			},
		},
		{
			attack_allowed_decay_multiplier = 0.25,
			attack_intensity_clamp = 15,
			decay = 4,
			decay_grace = 1,
			reset = 0.25,
			threshold = 10,
			ignored_movement_states = {
				sprint = true,
			},
		},
		{
			attack_allowed_decay_multiplier = 0.25,
			attack_intensity_clamp = 20,
			decay = 6,
			decay_grace = 1,
			reset = 0.25,
			threshold = 15,
			ignored_movement_states = {
				sprint = true,
			},
		},
		{
			attack_allowed_decay_multiplier = 0.25,
			attack_intensity_clamp = 35,
			decay = 12,
			decay_grace = 1,
			reset = 0.25,
			threshold = 30,
			ignored_movement_states = {
				sprint = true,
			},
		},
	},
	elite_ranged = {
		{
			attack_allowed_decay_multiplier = 1,
			attack_intensity_clamp = 12,
			decay = 2,
			decay_grace = 2,
			disallow_when_suppressed = false,
			locked_in_melee_check = true,
			reset = 1,
			threshold = 8,
			ignored_movement_states = {
				sprint = false,
			},
		},
		{
			attack_allowed_decay_multiplier = 0.2,
			attack_intensity_clamp = 15,
			decay = 3,
			decay_grace = 2,
			disallow_when_suppressed = false,
			locked_in_melee_check = true,
			reset = 1,
			threshold = 12,
			ignored_movement_states = {
				sprint = false,
			},
		},
		{
			attack_allowed_decay_multiplier = 1,
			attack_intensity_clamp = 20,
			decay = 5,
			decay_grace = 2,
			disallow_when_suppressed = false,
			locked_in_melee_check = true,
			reset = 2.5,
			threshold = 14,
			ignored_movement_states = {
				sprint = false,
			},
		},
		{
			attack_allowed_decay_multiplier = 1.25,
			attack_intensity_clamp = 25,
			decay = 8,
			decay_grace = 2,
			disallow_when_suppressed = false,
			locked_in_melee_check = true,
			reset = 2.5,
			threshold = 16,
			ignored_movement_states = {
				sprint = false,
			},
		},
		{
			attack_allowed_decay_multiplier = 1.5,
			attack_intensity_clamp = 30,
			decay = 12,
			decay_grace = 2,
			disallow_when_suppressed = false,
			locked_in_melee_check = true,
			reset = 2.5,
			threshold = 20,
			ignored_movement_states = {
				sprint = false,
			},
		},
		{
			attack_allowed_decay_multiplier = 1.5,
			attack_intensity_clamp = 50,
			decay = 20,
			decay_grace = 2,
			disallow_when_suppressed = false,
			locked_in_melee_check = true,
			reset = 2.5,
			threshold = 40,
			ignored_movement_states = {
				sprint = false,
			},
		},
	},
	elite_shotgun = {
		{
			attack_allowed_decay_multiplier = 1,
			attack_intensity_clamp = 12,
			decay = 2,
			decay_grace = 2,
			disallow_when_suppressed = false,
			locked_in_melee_check = true,
			reset = 1,
			threshold = 8,
			ignored_movement_states = {
				sprint = false,
			},
		},
		{
			attack_allowed_decay_multiplier = 0.2,
			attack_intensity_clamp = 15,
			decay = 2.2,
			decay_grace = 1.5,
			disallow_when_suppressed = true,
			locked_in_melee_check = true,
			reset = 1,
			threshold = 12,
			ignored_movement_states = {
				sprint = false,
			},
		},
		{
			attack_allowed_decay_multiplier = 1,
			attack_intensity_clamp = 20,
			decay = 3,
			decay_grace = 1,
			disallow_when_suppressed = true,
			locked_in_melee_check = false,
			reset = 2.5,
			threshold = 14,
			ignored_movement_states = {
				sprint = false,
			},
		},
		{
			attack_allowed_decay_multiplier = 1,
			attack_intensity_clamp = 25,
			decay = 4,
			decay_grace = 1,
			disallow_when_suppressed = true,
			locked_in_melee_check = false,
			reset = 2.5,
			threshold = 16,
			ignored_movement_states = {
				sprint = false,
			},
		},
		{
			attack_allowed_decay_multiplier = 1,
			attack_intensity_clamp = 30,
			decay = 10,
			decay_grace = 1,
			disallow_when_suppressed = true,
			locked_in_melee_check = false,
			reset = 2.5,
			threshold = 20,
			ignored_movement_states = {
				sprint = false,
			},
		},
		{
			attack_allowed_decay_multiplier = 1,
			attack_intensity_clamp = 50,
			decay = 20,
			decay_grace = 1,
			disallow_when_suppressed = true,
			locked_in_melee_check = false,
			reset = 2.5,
			threshold = 40,
			ignored_movement_states = {
				sprint = false,
			},
		},
	},
	ranged = {
		{
			attack_allowed_decay_multiplier = 1,
			attack_intensity_clamp = 8,
			decay = 1.5,
			decay_grace = 0.5,
			disallow_when_suppressed = true,
			locked_in_melee_check = true,
			reset = 1,
			threshold = 6,
			ignored_movement_states = {
				sprint = false,
			},
		},
		{
			attack_allowed_decay_multiplier = 1,
			attack_intensity_clamp = 15,
			decay = 3.5,
			decay_grace = 0.5,
			disallow_when_suppressed = true,
			locked_in_melee_check = true,
			reset = 1,
			threshold = 10,
			ignored_movement_states = {
				sprint = false,
			},
		},
		{
			attack_allowed_decay_multiplier = 1.25,
			attack_intensity_clamp = 15,
			decay = 4.5,
			decay_grace = 0.35,
			disallow_when_suppressed = true,
			locked_in_melee_check = true,
			reset = 2,
			threshold = 14,
			ignored_movement_states = {
				sprint = false,
			},
		},
		{
			attack_allowed_decay_multiplier = 1.5,
			attack_intensity_clamp = 20,
			decay = 8,
			decay_grace = 0.25,
			disallow_when_suppressed = true,
			locked_in_melee_check = true,
			reset = 2,
			threshold = 16,
			ignored_movement_states = {
				sprint = false,
			},
		},
		{
			attack_allowed_decay_multiplier = 2,
			attack_intensity_clamp = 25,
			decay = 12,
			decay_grace = 0.2,
			disallow_when_suppressed = true,
			locked_in_melee_check = true,
			reset = 2,
			threshold = 22,
			ignored_movement_states = {
				sprint = false,
			},
		},
		{
			attack_allowed_decay_multiplier = 2,
			attack_intensity_clamp = 54,
			decay = 20,
			decay_grace = 0.2,
			disallow_when_suppressed = true,
			locked_in_melee_check = true,
			reset = 2,
			threshold = 44,
			ignored_movement_states = {
				sprint = false,
			},
		},
	},
	ranged_close = {
		{
			attack_allowed_decay_multiplier = 1,
			attack_intensity_clamp = 8,
			decay = 1.5,
			decay_grace = 0.5,
			disallow_when_suppressed = true,
			locked_in_melee_check = true,
			reset = 1,
			threshold = 6,
			ignored_movement_states = {
				sprint = false,
			},
		},
		{
			attack_allowed_decay_multiplier = 1,
			attack_intensity_clamp = 15,
			decay = 3.5,
			decay_grace = 0.5,
			disallow_when_suppressed = true,
			locked_in_melee_check = true,
			reset = 1,
			threshold = 10,
			ignored_movement_states = {
				sprint = false,
			},
		},
		{
			attack_allowed_decay_multiplier = 1.25,
			attack_intensity_clamp = 15,
			decay = 4.5,
			decay_grace = 0.35,
			disallow_when_suppressed = true,
			locked_in_melee_check = true,
			reset = 2,
			threshold = 12,
			ignored_movement_states = {
				sprint = false,
			},
		},
		{
			attack_allowed_decay_multiplier = 1.5,
			attack_intensity_clamp = 20,
			decay = 8,
			decay_grace = 0.25,
			disallow_when_suppressed = true,
			reset = 2,
			threshold = 14,
			ignored_movement_states = {
				sprint = false,
			},
		},
		{
			attack_allowed_decay_multiplier = 2,
			attack_intensity_clamp = 25,
			decay = 12,
			decay_grace = 0.2,
			disallow_when_suppressed = true,
			reset = 2,
			threshold = 20,
			ignored_movement_states = {
				sprint = false,
			},
		},
		{
			attack_allowed_decay_multiplier = 2,
			attack_intensity_clamp = 45,
			decay = 20,
			decay_grace = 0.2,
			disallow_when_suppressed = true,
			reset = 2,
			threshold = 40,
			ignored_movement_states = {
				sprint = false,
			},
		},
	},
	disabling = {
		{
			attack_allowed_decay_multiplier = 0.25,
			decay = 1.75,
			decay_grace = 0.25,
			reset = 0.25,
			threshold = 1.5,
			ignored_movement_states = {
				sprint = false,
			},
		},
		{
			attack_allowed_decay_multiplier = 0.25,
			decay = 1.75,
			decay_grace = 0.25,
			reset = 0.25,
			threshold = 1.5,
			ignored_movement_states = {
				sprint = false,
			},
		},
		{
			attack_allowed_decay_multiplier = 0.25,
			decay = 1.75,
			decay_grace = 0.25,
			reset = 0.25,
			threshold = 1.5,
			ignored_movement_states = {
				sprint = false,
			},
		},
		{
			attack_allowed_decay_multiplier = 0.25,
			decay = 1.75,
			decay_grace = 0.25,
			reset = 0.25,
			threshold = 1.5,
			ignored_movement_states = {
				sprint = false,
			},
		},
		{
			attack_allowed_decay_multiplier = 0.25,
			decay = 1.75,
			decay_grace = 0.25,
			reset = 0.25,
			threshold = 1.5,
			ignored_movement_states = {
				sprint = false,
			},
		},
	},
}

return settings("AttackIntensitySettings", attack_intensity_settings)
