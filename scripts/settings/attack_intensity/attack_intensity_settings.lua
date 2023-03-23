local attack_intensity_settings = {
	constants = {
		default_attack_intensity_clamp = 15,
		sprint_decay_multiplier = 4,
		low_intensity_grace_mod = 0.25,
		low_intensity_threshold = 0.2,
		zero_dogpile_decay_multiplier = 2
	},
	attacked_allowed_time_range = {
		{
			0.3,
			0.4
		},
		{
			0.2,
			0.3
		},
		{
			0.15,
			0.2
		},
		{
			0.1,
			0.15
		},
		{
			0.025,
			0.05
		}
	},
	locked_in_melee_settings = {
		update_frequency = 0.1,
		radius = 4.5,
		delay = 0.5,
		needed_challenge_rating = {
			0.75,
			1.25,
			3,
			4,
			6
		},
		default_melee_kill_delay = {
			1,
			0.75,
			0.5,
			0.4,
			0.25
		}
	},
	toughness_broken_grace = {
		{
			spread_multiplier = 3,
			duration = 2
		},
		{
			spread_multiplier = 3,
			duration = 2
		},
		{
			spread_multiplier = 2.5,
			duration = 1.5
		},
		{
			spread_multiplier = 2,
			duration = 1.25
		},
		{
			spread_multiplier = 2,
			duration = 1
		},
		{
			dont_max_out_intensity = true,
			duration = 2,
			spread_multiplier = 4
		}
	},
	toughness_broken_grace_cooldown = {
		1.5,
		2,
		3,
		5,
		8,
		12
	},
	attack_intensities = {
		melee = {
			{
				attack_allowed_decay_multiplier = 0.25,
				decay_grace = 0.5,
				attack_intensity_clamp = 8,
				threshold = 3,
				decay = 1,
				reset = 0.25,
				ignored_movement_states = {
					sprint = true
				}
			},
			{
				attack_allowed_decay_multiplier = 0.25,
				decay_grace = 0.25,
				attack_intensity_clamp = 12,
				threshold = 6,
				decay = 2,
				reset = 0.25,
				ignored_movement_states = {
					sprint = true
				}
			},
			{
				attack_allowed_decay_multiplier = 0.25,
				decay_grace = 0.25,
				attack_intensity_clamp = 14,
				threshold = 10,
				decay = 3,
				reset = 0.25,
				ignored_movement_states = {
					sprint = true
				}
			},
			{
				attack_allowed_decay_multiplier = 0.25,
				decay_grace = 0.25,
				attack_intensity_clamp = 20,
				threshold = 16,
				decay = 8,
				reset = 0.25,
				ignored_movement_states = {
					sprint = true
				}
			},
			{
				attack_allowed_decay_multiplier = 0.25,
				decay_grace = 0.25,
				attack_intensity_clamp = 25,
				threshold = 20,
				decay = 12,
				reset = 0.25,
				ignored_movement_states = {
					sprint = true
				}
			},
			{
				attack_allowed_decay_multiplier = 0.25,
				decay_grace = 0.25,
				attack_intensity_clamp = 45,
				threshold = 40,
				decay = 20,
				reset = 0.25,
				ignored_movement_states = {
					sprint = true
				}
			}
		},
		moving_melee = {
			{
				attack_allowed_decay_multiplier = 0.25,
				decay_grace = 0.5,
				attack_intensity_clamp = 10,
				threshold = 3,
				decay = 1,
				reset = 0.25,
				ignored_movement_states = {
					sprint = true
				}
			},
			{
				attack_allowed_decay_multiplier = 0.25,
				decay_grace = 0.5,
				attack_intensity_clamp = 10,
				threshold = 6,
				decay = 2,
				reset = 0.25,
				ignored_movement_states = {
					sprint = true
				}
			},
			{
				attack_allowed_decay_multiplier = 0.25,
				decay_grace = 0.5,
				attack_intensity_clamp = 15,
				threshold = 12,
				decay = 4,
				reset = 0.25,
				ignored_movement_states = {
					sprint = true
				}
			},
			{
				attack_allowed_decay_multiplier = 0.25,
				decay_grace = 0.5,
				attack_intensity_clamp = 20,
				threshold = 16,
				decay = 8,
				reset = 0.25,
				ignored_movement_states = {
					sprint = true
				}
			},
			{
				attack_allowed_decay_multiplier = 0.25,
				decay_grace = 0.5,
				attack_intensity_clamp = 28,
				threshold = 24,
				decay = 12,
				reset = 0.25,
				ignored_movement_states = {
					sprint = true
				}
			},
			{
				attack_allowed_decay_multiplier = 0.25,
				decay_grace = 0.5,
				attack_intensity_clamp = 55,
				threshold = 48,
				decay = 20,
				reset = 0.25,
				ignored_movement_states = {
					sprint = true
				}
			}
		},
		running_melee = {
			{
				attack_allowed_decay_multiplier = 0.25,
				decay_grace = 1,
				attack_intensity_clamp = 6,
				threshold = 2,
				decay = 0.75,
				reset = 0.25,
				ignored_movement_states = {
					sprint = true
				}
			},
			{
				attack_allowed_decay_multiplier = 0.25,
				decay_grace = 1,
				attack_intensity_clamp = 7,
				threshold = 3,
				decay = 0.75,
				reset = 0.25,
				ignored_movement_states = {
					sprint = true
				}
			},
			{
				attack_allowed_decay_multiplier = 0.25,
				decay_grace = 1,
				attack_intensity_clamp = 8,
				threshold = 5,
				decay = 2,
				reset = 0.25,
				ignored_movement_states = {
					sprint = true
				}
			},
			{
				attack_allowed_decay_multiplier = 0.25,
				decay_grace = 1,
				attack_intensity_clamp = 15,
				threshold = 10,
				decay = 4,
				reset = 0.25,
				ignored_movement_states = {
					sprint = true
				}
			},
			{
				attack_allowed_decay_multiplier = 0.25,
				decay_grace = 1,
				attack_intensity_clamp = 20,
				threshold = 15,
				decay = 6,
				reset = 0.25,
				ignored_movement_states = {
					sprint = true
				}
			},
			{
				attack_allowed_decay_multiplier = 0.25,
				decay_grace = 1,
				attack_intensity_clamp = 35,
				threshold = 30,
				decay = 12,
				reset = 0.25,
				ignored_movement_states = {
					sprint = true
				}
			}
		},
		elite_ranged = {
			{
				attack_allowed_decay_multiplier = 1,
				decay = 2,
				attack_intensity_clamp = 12,
				threshold = 8,
				disallow_when_suppressed = false,
				decay_grace = 2,
				locked_in_melee_check = true,
				reset = 1,
				ignored_movement_states = {
					sprint = false
				}
			},
			{
				attack_allowed_decay_multiplier = 0.2,
				decay = 3,
				attack_intensity_clamp = 15,
				threshold = 12,
				disallow_when_suppressed = false,
				decay_grace = 2,
				locked_in_melee_check = true,
				reset = 1,
				ignored_movement_states = {
					sprint = false
				}
			},
			{
				attack_allowed_decay_multiplier = 1,
				decay = 5,
				attack_intensity_clamp = 20,
				threshold = 14,
				disallow_when_suppressed = false,
				decay_grace = 2,
				locked_in_melee_check = true,
				reset = 2.5,
				ignored_movement_states = {
					sprint = false
				}
			},
			{
				attack_allowed_decay_multiplier = 1.25,
				decay = 8,
				attack_intensity_clamp = 25,
				threshold = 16,
				disallow_when_suppressed = false,
				decay_grace = 2,
				locked_in_melee_check = true,
				reset = 2.5,
				ignored_movement_states = {
					sprint = false
				}
			},
			{
				attack_allowed_decay_multiplier = 1.5,
				decay = 12,
				attack_intensity_clamp = 30,
				threshold = 20,
				disallow_when_suppressed = false,
				decay_grace = 2,
				locked_in_melee_check = true,
				reset = 2.5,
				ignored_movement_states = {
					sprint = false
				}
			},
			{
				attack_allowed_decay_multiplier = 1.5,
				decay = 20,
				attack_intensity_clamp = 50,
				threshold = 40,
				disallow_when_suppressed = false,
				decay_grace = 2,
				locked_in_melee_check = true,
				reset = 2.5,
				ignored_movement_states = {
					sprint = false
				}
			}
		},
		elite_shotgun = {
			{
				attack_allowed_decay_multiplier = 1,
				decay = 2,
				attack_intensity_clamp = 12,
				threshold = 8,
				disallow_when_suppressed = false,
				decay_grace = 2,
				locked_in_melee_check = true,
				reset = 1,
				ignored_movement_states = {
					sprint = false
				}
			},
			{
				attack_allowed_decay_multiplier = 0.2,
				decay = 2.2,
				attack_intensity_clamp = 15,
				threshold = 12,
				disallow_when_suppressed = true,
				decay_grace = 1.5,
				locked_in_melee_check = true,
				reset = 1,
				ignored_movement_states = {
					sprint = false
				}
			},
			{
				attack_allowed_decay_multiplier = 1,
				decay = 3,
				attack_intensity_clamp = 20,
				threshold = 14,
				disallow_when_suppressed = true,
				decay_grace = 1,
				locked_in_melee_check = false,
				reset = 2.5,
				ignored_movement_states = {
					sprint = false
				}
			},
			{
				attack_allowed_decay_multiplier = 1,
				decay = 4,
				attack_intensity_clamp = 25,
				threshold = 16,
				disallow_when_suppressed = true,
				decay_grace = 1,
				locked_in_melee_check = false,
				reset = 2.5,
				ignored_movement_states = {
					sprint = false
				}
			},
			{
				attack_allowed_decay_multiplier = 1,
				decay = 10,
				attack_intensity_clamp = 30,
				threshold = 20,
				disallow_when_suppressed = true,
				decay_grace = 1,
				locked_in_melee_check = false,
				reset = 2.5,
				ignored_movement_states = {
					sprint = false
				}
			},
			{
				attack_allowed_decay_multiplier = 1,
				decay = 20,
				attack_intensity_clamp = 50,
				threshold = 40,
				disallow_when_suppressed = true,
				decay_grace = 1,
				locked_in_melee_check = false,
				reset = 2.5,
				ignored_movement_states = {
					sprint = false
				}
			}
		},
		ranged = {
			{
				attack_allowed_decay_multiplier = 1,
				decay = 1.5,
				attack_intensity_clamp = 8,
				threshold = 6,
				disallow_when_suppressed = true,
				decay_grace = 0.5,
				locked_in_melee_check = true,
				reset = 1,
				ignored_movement_states = {
					sprint = false
				}
			},
			{
				attack_allowed_decay_multiplier = 1,
				decay = 3.5,
				attack_intensity_clamp = 15,
				threshold = 10,
				disallow_when_suppressed = true,
				decay_grace = 0.5,
				locked_in_melee_check = true,
				reset = 1,
				ignored_movement_states = {
					sprint = false
				}
			},
			{
				attack_allowed_decay_multiplier = 1.25,
				decay = 4.5,
				attack_intensity_clamp = 15,
				threshold = 14,
				disallow_when_suppressed = true,
				decay_grace = 0.35,
				locked_in_melee_check = true,
				reset = 2,
				ignored_movement_states = {
					sprint = false
				}
			},
			{
				attack_allowed_decay_multiplier = 1.5,
				decay = 8,
				attack_intensity_clamp = 20,
				threshold = 16,
				disallow_when_suppressed = true,
				decay_grace = 0.25,
				locked_in_melee_check = true,
				reset = 2,
				ignored_movement_states = {
					sprint = false
				}
			},
			{
				attack_allowed_decay_multiplier = 2,
				decay = 12,
				attack_intensity_clamp = 25,
				threshold = 22,
				disallow_when_suppressed = true,
				decay_grace = 0.2,
				locked_in_melee_check = true,
				reset = 2,
				ignored_movement_states = {
					sprint = false
				}
			},
			{
				attack_allowed_decay_multiplier = 2,
				decay = 20,
				attack_intensity_clamp = 54,
				threshold = 44,
				disallow_when_suppressed = true,
				decay_grace = 0.2,
				locked_in_melee_check = true,
				reset = 2,
				ignored_movement_states = {
					sprint = false
				}
			}
		},
		ranged_close = {
			{
				attack_allowed_decay_multiplier = 1,
				decay = 1.5,
				attack_intensity_clamp = 8,
				threshold = 6,
				disallow_when_suppressed = true,
				decay_grace = 0.5,
				locked_in_melee_check = true,
				reset = 1,
				ignored_movement_states = {
					sprint = false
				}
			},
			{
				attack_allowed_decay_multiplier = 1,
				decay = 3.5,
				attack_intensity_clamp = 15,
				threshold = 10,
				disallow_when_suppressed = true,
				decay_grace = 0.5,
				locked_in_melee_check = true,
				reset = 1,
				ignored_movement_states = {
					sprint = false
				}
			},
			{
				attack_allowed_decay_multiplier = 1.25,
				decay = 4.5,
				attack_intensity_clamp = 15,
				threshold = 12,
				disallow_when_suppressed = true,
				decay_grace = 0.35,
				locked_in_melee_check = true,
				reset = 2,
				ignored_movement_states = {
					sprint = false
				}
			},
			{
				attack_allowed_decay_multiplier = 1.5,
				decay_grace = 0.25,
				disallow_when_suppressed = true,
				threshold = 14,
				decay = 8,
				reset = 2,
				attack_intensity_clamp = 20,
				ignored_movement_states = {
					sprint = false
				}
			},
			{
				attack_allowed_decay_multiplier = 2,
				decay_grace = 0.2,
				disallow_when_suppressed = true,
				threshold = 20,
				decay = 12,
				reset = 2,
				attack_intensity_clamp = 25,
				ignored_movement_states = {
					sprint = false
				}
			},
			{
				attack_allowed_decay_multiplier = 2,
				decay_grace = 0.2,
				disallow_when_suppressed = true,
				threshold = 40,
				decay = 20,
				reset = 2,
				attack_intensity_clamp = 45,
				ignored_movement_states = {
					sprint = false
				}
			}
		},
		disabling = {
			{
				attack_allowed_decay_multiplier = 0.25,
				decay_grace = 0.25,
				threshold = 1.5,
				decay = 1.75,
				reset = 0.25,
				ignored_movement_states = {
					sprint = false
				}
			},
			{
				attack_allowed_decay_multiplier = 0.25,
				decay_grace = 0.25,
				threshold = 1.5,
				decay = 1.75,
				reset = 0.25,
				ignored_movement_states = {
					sprint = false
				}
			},
			{
				attack_allowed_decay_multiplier = 0.25,
				decay_grace = 0.25,
				threshold = 1.5,
				decay = 1.75,
				reset = 0.25,
				ignored_movement_states = {
					sprint = false
				}
			},
			{
				attack_allowed_decay_multiplier = 0.25,
				decay_grace = 0.25,
				threshold = 1.5,
				decay = 1.75,
				reset = 0.25,
				ignored_movement_states = {
					sprint = false
				}
			},
			{
				attack_allowed_decay_multiplier = 0.25,
				decay_grace = 0.25,
				threshold = 1.5,
				decay = 1.75,
				reset = 0.25,
				ignored_movement_states = {
					sprint = false
				}
			}
		}
	}
}

return settings("AttackIntensitySettings", attack_intensity_settings)
