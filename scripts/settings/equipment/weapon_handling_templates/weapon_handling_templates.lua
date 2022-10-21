local function lerpable_timescale(value)
	return {
		lerp_basic = value * 0.75,
		lerp_perfect = value * 1.25
	}
end

local multiplier = nil
local weapon_handling_templates = {
	time_scale_0_75 = {
		time_scale = lerpable_timescale(0.75)
	},
	time_scale_0_7 = {
		time_scale = lerpable_timescale(0.7)
	},
	time_scale_0_8 = {
		time_scale = lerpable_timescale(0.8)
	},
	time_scale_0_85 = {
		time_scale = lerpable_timescale(0.85)
	},
	time_scale_0_9 = {
		time_scale = lerpable_timescale(0.9)
	},
	time_scale_0_95 = {
		time_scale = lerpable_timescale(0.95)
	},
	time_scale_1 = {
		time_scale = lerpable_timescale(1)
	},
	time_scale_1_05 = {
		time_scale = lerpable_timescale(1.05)
	},
	time_scale_1_1 = {
		time_scale = lerpable_timescale(1.1)
	},
	time_scale_1_2 = {
		time_scale = lerpable_timescale(1.2)
	},
	time_scale_1_3 = {
		time_scale = lerpable_timescale(1.3)
	},
	time_scale_1_5 = {
		time_scale = lerpable_timescale(1.5)
	},
	time_scale_1_65 = {
		time_scale = lerpable_timescale(1.65)
	},
	time_scale_1_75 = {
		time_scale = lerpable_timescale(1.75)
	},
	time_scale_2_0 = {
		time_scale = lerpable_timescale(2)
	},
	time_scale_2_5 = {
		time_scale = lerpable_timescale(2.5)
	},
	increased_reload_speed = {
		time_scale = 1.1
	},
	immediate_single_shot = {
		fire_rate = {
			fire_time = 0
		},
		critical_strike = {
			chance_modifier = 0.05
		}
	},
	flamer_burst = {
		fire_rate = {
			max_shots = 1,
			fire_time = 0.3
		}
	},
	flamer_auto = {
		fire_rate = {
			fire_time = 0.1,
			auto_fire_time = 0.25
		},
		flamer_ramp_up_times = {
			{
				lerp_perfect = 0.2,
				lerp_basic = 0.4
			},
			{
				lerp_perfect = 0.2,
				lerp_basic = 0.4
			},
			{
				lerp_perfect = 0.2,
				lerp_basic = 0.4
			},
			{
				lerp_perfect = 0.25,
				lerp_basic = 0.5
			},
			{
				lerp_perfect = 0.25,
				lerp_basic = 0.5
			},
			{
				lerp_perfect = 0.25,
				lerp_basic = 0.5
			},
			{
				lerp_perfect = 0.3,
				lerp_basic = 0.6
			}
		}
	},
	shotgun_from_reload = {
		fire_rate = {
			fire_time = 0.3
		}
	},
	bolter_full_auto = {
		fire_rate = {
			fire_time = 0,
			auto_fire_time = {
				lerp_perfect = 0.15,
				lerp_basic = 0.15
			}
		}
	},
	bolter_m2_full_auto = {
		fire_rate = {
			fire_time = 0,
			auto_fire_time = {
				lerp_perfect = 0.26,
				lerp_basic = 0.36
			}
		}
	},
	bolter_m3_full_auto = {
		fire_rate = {
			fire_time = 0,
			auto_fire_time = {
				lerp_perfect = 0.03,
				lerp_basic = 0.09
			}
		}
	},
	grenade_throw = {
		time_scale = 1,
		fire_rate = {
			fire_time = 0.05
		},
		critical_strike = {
			chance_modifier = -0.05
		}
	},
	rippergun_full_auto = {
		fire_rate = {
			fire_time = 0.1,
			auto_fire_time = {
				lerp_perfect = 0.15,
				lerp_basic = 0.25
			}
		}
	},
	rippergun_full_auto_slow = {
		fire_rate = {
			fire_time = 0.1,
			max_shots = math.huge,
			auto_fire_time = {
				lerp_perfect = 0.125,
				lerp_basic = 0.225
			}
		}
	},
	rippergun_burst = {
		fire_rate = {
			max_shots = 3,
			fire_time = 0.1,
			auto_fire_time = {
				lerp_perfect = 0.075,
				lerp_basic = 0.15
			}
		}
	},
	rippergun_semi = {
		fire_rate = {
			max_shots = 2,
			fire_time = 0.1,
			auto_fire_time = {
				lerp_perfect = 0.075,
				lerp_basic = 0.125
			}
		}
	},
	lasgun_triple_burst = {
		fire_rate = {
			max_shots = 3,
			auto_fire_time = 0.1,
			fire_time = 0
		}
	},
	lasgun_full_auto = {
		fire_rate = {
			fire_time = 0,
			auto_fire_time = {
				lerp_perfect = 0.1,
				lerp_basic = 0.125
			}
		}
	},
	lasgun_p3_m1_full_auto = {
		fire_rate = {
			fire_time = 0,
			auto_fire_time = {
				lerp_perfect = 0.12000000000000001,
				lerp_basic = 0.14
			}
		},
		critical_strike = {
			chance_modifier = -0.02,
			max_critical_shots = 2
		}
	},
	lasgun_p3_m3_full_auto = {
		fire_rate = {
			fire_time = 0,
			auto_fire_time = {
				lerp_perfect = 0.16,
				lerp_basic = 0.18000000000000002
			}
		},
		critical_strike = {
			chance_modifier = -0.02,
			max_critical_shots = 2
		}
	},
	lasgun_p3_m2_full_auto = {
		fire_rate = {
			fire_time = 0,
			auto_fire_time = {
				lerp_perfect = 0.08,
				lerp_basic = 0.09999999999999999
			}
		},
		critical_strike = {
			chance_modifier = -0.02,
			max_critical_shots = 2
		}
	},
	lasgun_triple_burst_slow = {
		fire_rate = {
			max_shots = 3,
			auto_fire_time = 0.175,
			fire_time = 0
		}
	},
	lasgun_elysian_triple_burst = {
		fire_rate = {
			max_shots = 3,
			auto_fire_time = 0.135,
			fire_time = 0
		}
	},
	lasgun_krieg_full_auto = {
		fire_rate = {
			fire_time = 0,
			auto_fire_time = {
				lerp_perfect = 0.12,
				lerp_basic = 0.15
			}
		}
	},
	lasgun_krieg_full_auto_slow = {
		fire_rate = {
			fire_time = 0,
			auto_fire_time = {
				lerp_perfect = 0.18,
				lerp_basic = 0.255
			}
		}
	},
	autogun_triple_burst = {
		fire_rate = {
			max_shots = 3,
			auto_fire_time = 0.075,
			fire_time = 0
		}
	},
	autogun_triple_burst_slow = {
		fire_rate = {
			max_shots = 3,
			auto_fire_time = 0.11,
			fire_time = 0
		}
	},
	autogun_double_burst_slow = {
		fire_rate = {
			max_shots = 2,
			auto_fire_time = 0.1,
			fire_time = 0
		}
	},
	autogun_quad_burst = {
		fire_rate = {
			max_shots = 4,
			auto_fire_time = 0.075,
			fire_time = 0
		}
	},
	autogun_quad_burst_fast = {
		fire_rate = {
			max_shots = 4,
			auto_fire_time = 0.065,
			fire_time = 0
		}
	},
	autogun_full_auto = {
		fire_rate = {
			fire_time = 0,
			auto_fire_time = {
				lerp_perfect = 0.09000000000000001,
				lerp_basic = 0.11
			}
		},
		critical_strike = {
			chance_modifier = -0.02,
			max_critical_shots = 3
		}
	},
	autogun_full_auto_slow = {
		fire_rate = {
			fire_time = 0,
			auto_fire_time = {
				lerp_perfect = 0.12000000000000001,
				lerp_basic = 0.14
			}
		},
		critical_strike = {
			chance_modifier = -0.02,
			max_critical_shots = 2
		}
	},
	autogun_full_auto_fast = {
		fire_rate = {
			fire_time = 0,
			auto_fire_time = {
				lerp_perfect = 0.065,
				lerp_basic = 0.08499999999999999
			}
		},
		critical_strike = {
			chance_modifier = -0.02,
			max_critical_shots = 4
		}
	},
	autogun_full_auto_support = {
		fire_rate = {
			fire_time = 0.2,
			auto_fire_time = {
				lerp_perfect = 0.05,
				lerp_basic = 0.06
			}
		},
		critical_strike = {
			chance_modifier = -0.02,
			max_critical_shots = 3
		}
	},
	autogun_full_auto_support_braced = {
		fire_rate = {
			fire_time = 0,
			auto_fire_time = {
				lerp_perfect = 0.052,
				lerp_basic = 0.065
			}
		},
		critical_strike = {
			chance_modifier = -0.02,
			max_critical_shots = 3
		}
	},
	autogun_full_auto_assault = {
		fire_rate = {
			fire_time = 0,
			auto_fire_time = {
				lerp_perfect = 0.068,
				lerp_basic = 0.085
			}
		},
		critical_strike = {
			chance_modifier = -0.02,
			max_critical_shots = 3
		}
	},
	stubrevolver_single_shot = {
		fire_rate = {
			fire_time = 0
		},
		critical_strike = {
			chance_modifier = {
				lerp_perfect = 0.25,
				lerp_basic = 0.05
			}
		}
	},
	default_reload_speed_modify = {
		time_scale = {
			lerp_perfect = 1,
			lerp_basic = 0.2
		}
	},
	ogryn_heavystubber_p1_m1_full_auto = {
		fire_rate = {
			fire_time = 0.22,
			auto_fire_time = 0.05
		},
		critical_strike = {
			chance_modifier = -0.02,
			max_critical_shots = 3
		}
	},
	ogryn_heavystubber_p1_m1_hip_fire = {
		fire_rate = {
			fire_time = 0.22,
			auto_fire_time = 0.05
		},
		critical_strike = {
			chance_modifier = -0.02,
			max_critical_shots = 3
		}
	}
}

return settings("WeaponHandlingTemplates", weapon_handling_templates)
