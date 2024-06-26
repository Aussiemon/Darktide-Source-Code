-- chunkname: @scripts/settings/equipment/weapon_handling_templates/weapon_handling_templates.lua

local function lerpable_timescale(value)
	return {
		lerp_basic = value * 0.75,
		lerp_perfect = value * 1.25,
	}
end

local multiplier
local ninja_crit_bump = 0.15
local hatchet_crit_bump = {
	lerp_basic = 0,
	lerp_perfect = 0.15,
}
local weapon_handling_templates = {
	time_scale_0_5 = {
		time_scale = lerpable_timescale(0.5),
	},
	time_scale_0_6 = {
		time_scale = lerpable_timescale(0.6),
	},
	time_scale_0_7 = {
		time_scale = lerpable_timescale(0.7),
	},
	time_scale_0_75 = {
		time_scale = lerpable_timescale(0.75),
	},
	time_scale_0_8 = {
		time_scale = lerpable_timescale(0.8),
	},
	time_scale_0_85 = {
		time_scale = lerpable_timescale(0.85),
	},
	time_scale_0_9 = {
		time_scale = lerpable_timescale(0.9),
	},
	time_scale_0_95 = {
		time_scale = lerpable_timescale(0.95),
	},
	time_scale_1 = {
		time_scale = lerpable_timescale(1),
	},
	time_scale_1_05 = {
		time_scale = lerpable_timescale(1.05),
	},
	time_scale_1_1 = {
		time_scale = lerpable_timescale(1.1),
	},
	time_scale_1_2 = {
		time_scale = lerpable_timescale(1.2),
	},
	time_scale_1_3 = {
		time_scale = lerpable_timescale(1.3),
	},
	time_scale_1_4 = {
		time_scale = lerpable_timescale(1.4),
	},
	time_scale_1_5 = {
		time_scale = lerpable_timescale(1.5),
	},
	time_scale_1_65 = {
		time_scale = lerpable_timescale(1.65),
	},
	time_scale_1_75 = {
		time_scale = lerpable_timescale(1.75),
	},
	time_scale_2_0 = {
		time_scale = lerpable_timescale(2),
	},
	time_scale_2_5 = {
		time_scale = lerpable_timescale(2.5),
	},
	time_scale_0_9_hatchet = {
		time_scale = lerpable_timescale(0.9),
		critical_strike = {
			chance_modifier = hatchet_crit_bump,
		},
	},
	time_scale_1_hatchet = {
		time_scale = lerpable_timescale(1),
		critical_strike = {
			chance_modifier = hatchet_crit_bump,
		},
	},
	time_scale_1_1_hatchet = {
		time_scale = lerpable_timescale(1.1),
		critical_strike = {
			chance_modifier = hatchet_crit_bump,
		},
	},
	time_scale_1_3_hatchet = {
		time_scale = lerpable_timescale(1.3),
		critical_strike = {
			chance_modifier = hatchet_crit_bump,
		},
	},
	time_scale_0_75_ninja = {
		time_scale = lerpable_timescale(0.75),
		critical_strike = {
			chance_modifier = ninja_crit_bump,
		},
	},
	time_scale_0_7_ninja = {
		time_scale_ninja = lerpable_timescale(0.7),
		critical_strike = {
			chance_modifier = ninja_crit_bump,
		},
	},
	time_scale_0_8_ninja = {
		time_scale = lerpable_timescale(0.8),
		critical_strike = {
			chance_modifier = ninja_crit_bump,
		},
	},
	time_scale_0_85_ninja = {
		time_scale = lerpable_timescale(0.85),
		critical_strike = {
			chance_modifier = ninja_crit_bump,
		},
	},
	time_scale_0_9_ninja = {
		time_scale = lerpable_timescale(0.9),
		critical_strike = {
			chance_modifier = ninja_crit_bump,
		},
	},
	time_scale_0_95_ninja = {
		time_scale = lerpable_timescale(0.95),
		critical_strike = {
			chance_modifier = ninja_crit_bump,
		},
	},
	time_scale_1_ninja = {
		time_scale = lerpable_timescale(1),
		critical_strike = {
			chance_modifier = ninja_crit_bump,
		},
	},
	time_scale_1_05_ninja = {
		time_scale = lerpable_timescale(1.05),
		critical_strike = {
			chance_modifier = ninja_crit_bump,
		},
	},
	time_scale_1_1_ninja = {
		time_scale = lerpable_timescale(1.1),
		critical_strike = {
			chance_modifier = ninja_crit_bump,
		},
	},
	time_scale_1_2_ninja = {
		time_scale = lerpable_timescale(1.2),
		critical_strike = {
			chance_modifier = ninja_crit_bump,
		},
	},
	time_scale_1_3_ninja = {
		time_scale = lerpable_timescale(1.3),
		critical_strike = {
			chance_modifier = ninja_crit_bump,
		},
	},
	time_scale_1_4_ninja = {
		time_scale = lerpable_timescale(1.4),
		critical_strike = {
			chance_modifier = ninja_crit_bump,
		},
	},
	time_scale_1_5_ninja = {
		time_scale = lerpable_timescale(1.5),
		critical_strike = {
			chance_modifier = ninja_crit_bump,
		},
	},
	time_scale_1_65_ninja = {
		time_scale = lerpable_timescale(1.65),
		critical_strike = {
			chance_modifier = ninja_crit_bump,
		},
	},
	time_scale_1_75_ninja = {
		time_scale = lerpable_timescale(1.75),
		critical_strike = {
			chance_modifier = ninja_crit_bump,
		},
	},
	time_scale_2_0_ninja = {
		time_scale = lerpable_timescale(2),
		critical_strike = {
			chance_modifier = ninja_crit_bump,
		},
	},
	time_scale_2_5_ninja = {
		time_scale = lerpable_timescale(2.5),
		critical_strike = {
			chance_modifier = ninja_crit_bump,
		},
	},
	increased_reload_speed = {
		time_scale = 1.1,
	},
	immediate_single_shot = {
		fire_rate = {
			fire_time = 0,
		},
		critical_strike = {
			chance_modifier = 0.05,
		},
	},
	immediate_single_shot_pistol = {
		fire_rate = {
			fire_time = 0,
		},
		critical_strike = {
			chance_modifier = 0.15,
		},
	},
	flamer_burst = {
		fire_rate = {
			fire_time = 0.1,
			max_shots = 1,
		},
	},
	flamer_auto = {
		fire_rate = {
			auto_fire_time = 0.25,
			fire_time = 0.1,
		},
		flamer_ramp_up_times = {
			{
				lerp_basic = 0.4,
				lerp_perfect = 0.2,
			},
			{
				lerp_basic = 0.4,
				lerp_perfect = 0.2,
			},
			{
				lerp_basic = 0.4,
				lerp_perfect = 0.2,
			},
			{
				lerp_basic = 0.5,
				lerp_perfect = 0.25,
			},
			{
				lerp_basic = 0.5,
				lerp_perfect = 0.25,
			},
			{
				lerp_basic = 0.5,
				lerp_perfect = 0.25,
			},
			{
				lerp_basic = 0.6,
				lerp_perfect = 0.3,
			},
		},
		critical_strike = {
			max_critical_shots = 3,
		},
	},
	forcestaff_p2_m1_burst = {
		fire_rate = {
			fire_time = 0.1,
			max_shots = 1,
		},
	},
	forcestaff_p2_m1_auto = {
		fire_rate = {
			auto_fire_time = 0.25,
			fire_time = 0.1,
		},
		flamer_ramp_up_times = {
			{
				lerp_basic = 0.4,
				lerp_perfect = 0.2,
			},
			{
				lerp_basic = 0.4,
				lerp_perfect = 0.2,
			},
			{
				lerp_basic = 0.4,
				lerp_perfect = 0.2,
			},
			{
				lerp_basic = 0.5,
				lerp_perfect = 0.25,
			},
			{
				lerp_basic = 0.5,
				lerp_perfect = 0.25,
			},
			{
				lerp_basic = 0.5,
				lerp_perfect = 0.25,
			},
			{
				lerp_basic = 0.6,
				lerp_perfect = 0.3,
			},
		},
		critical_strike = {
			max_critical_shots = 3,
		},
	},
	forcestaff_p3_m1_single_shot = {
		time_scale = lerpable_timescale(1.5),
		critical_strike = {
			chance_modifier = {
				lerp_basic = 0.05,
				lerp_perfect = 0.25,
			},
		},
	},
	forcestaff_p3_m1_chain_lightning = {
		critical_strike = {
			chance_modifier = {
				lerp_basic = 0.05,
				lerp_perfect = 0.25,
			},
		},
	},
	shotgun_from_reload = {
		fire_rate = {
			fire_time = 0.3,
		},
	},
	bolter_full_auto = {
		fire_rate = {
			fire_time = 0,
			auto_fire_time = {
				lerp_basic = 0.15,
				lerp_perfect = 0.15,
			},
		},
	},
	bolter_m2_full_auto = {
		fire_rate = {
			fire_time = 0,
			auto_fire_time = {
				lerp_basic = 0.36,
				lerp_perfect = 0.26,
			},
		},
	},
	bolter_m3_full_auto = {
		fire_rate = {
			fire_time = 0,
			auto_fire_time = {
				lerp_basic = 0.09,
				lerp_perfect = 0.03,
			},
		},
	},
	grenade_throw = {
		time_scale = 1,
		fire_rate = {
			fire_time = 0.05,
		},
		critical_strike = {
			chance_modifier = -0.05,
		},
	},
	rippergun_full_auto = {
		fire_rate = {
			fire_time = 0.1,
			auto_fire_time = {
				lerp_basic = 0.25,
				lerp_perfect = 0.15,
			},
		},
	},
	rippergun_full_auto_slow = {
		fire_rate = {
			fire_time = 0.1,
			max_shots = math.huge,
			auto_fire_time = {
				lerp_basic = 0.225,
				lerp_perfect = 0.125,
			},
		},
	},
	rippergun_burst = {
		fire_rate = {
			fire_time = 0.1,
			max_shots = 3,
			auto_fire_time = {
				lerp_basic = 0.15,
				lerp_perfect = 0.075,
			},
		},
	},
	rippergun_semi = {
		fire_rate = {
			fire_time = 0.1,
			max_shots = 2,
			auto_fire_time = {
				lerp_basic = 0.125,
				lerp_perfect = 0.075,
			},
		},
	},
	lasgun_triple_burst = {
		fire_rate = {
			auto_fire_time = 0.1,
			fire_time = 0,
			max_shots = 3,
		},
	},
	lasgun_full_auto = {
		fire_rate = {
			fire_time = 0,
			auto_fire_time = {
				lerp_basic = 0.125,
				lerp_perfect = 0.1,
			},
		},
	},
	lasgun_p3_m1_full_auto = {
		fire_rate = {
			fire_time = 0,
			auto_fire_time = {
				lerp_basic = 0.09999999999999999,
				lerp_perfect = 0.08,
			},
		},
		critical_strike = {
			chance_modifier = 0.02,
			max_critical_shots = 2,
		},
	},
	lasgun_p3_m3_full_auto = {
		fire_rate = {
			fire_time = 0,
			auto_fire_time = {
				lerp_basic = 0.14,
				lerp_perfect = 0.12000000000000001,
			},
		},
		critical_strike = {
			chance_modifier = 0.02,
			max_critical_shots = 2,
		},
	},
	lasgun_p3_m2_full_auto = {
		fire_rate = {
			fire_time = 0,
			auto_fire_time = {
				lerp_basic = 0.060000000000000005,
				lerp_perfect = 0.04,
			},
		},
		critical_strike = {
			chance_modifier = 0.02,
			max_critical_shots = 2,
		},
	},
	lasgun_triple_burst_slow = {
		fire_rate = {
			auto_fire_time = 0.175,
			fire_time = 0,
			max_shots = 3,
		},
	},
	lasgun_elysian_burst = {
		fire_rate = {
			fire_time = 0,
			max_shots = 4,
			auto_fire_time = {
				lerp_basic = 0.09999999999999999,
				lerp_perfect = 0.08,
			},
		},
	},
	lasgun_krieg_full_auto = {
		fire_rate = {
			fire_time = 0,
			auto_fire_time = {
				lerp_basic = 0.15,
				lerp_perfect = 0.12,
			},
		},
	},
	lasgun_krieg_full_auto_slow = {
		fire_rate = {
			fire_time = 0,
			auto_fire_time = {
				lerp_basic = 0.255,
				lerp_perfect = 0.18,
			},
		},
	},
	autogun_single_shot = {
		fire_rate = {
			fire_time = 0,
			max_shots = 1,
		},
	},
	autogun_triple_burst = {
		fire_rate = {
			auto_fire_time = 0.125,
			fire_time = 0,
			max_shots = 3,
		},
	},
	autogun_quad_burst = {
		fire_rate = {
			auto_fire_time = 0.085,
			fire_time = 0,
			max_shots = 2,
		},
	},
	autogun_quintuple_burst_fast = {
		fire_rate = {
			auto_fire_time = 0.059,
			fire_time = 0,
			max_shots = 5,
		},
	},
	autogun_full_auto = {
		fire_rate = {
			fire_time = 0,
			auto_fire_time = {
				lerp_basic = 0.11,
				lerp_perfect = 0.09000000000000001,
			},
		},
		critical_strike = {
			chance_modifier = -0.02,
			max_critical_shots = 3,
		},
	},
	autogun_full_auto_slow = {
		fire_rate = {
			fire_time = 0,
			auto_fire_time = {
				lerp_basic = 0.14,
				lerp_perfect = 0.12000000000000001,
			},
		},
		critical_strike = {
			chance_modifier = -0.02,
			max_critical_shots = 2,
		},
	},
	autogun_full_auto_fast = {
		fire_rate = {
			fire_time = 0,
			auto_fire_time = {
				lerp_basic = 0.08499999999999999,
				lerp_perfect = 0.065,
			},
		},
		critical_strike = {
			chance_modifier = -0.02,
			max_critical_shots = 3,
		},
	},
	autogun_p2_m1 = {
		fire_rate = {
			fire_time = 0,
			auto_fire_time = {
				lerp_basic = 0.09999999999999999,
				lerp_perfect = 0.08,
			},
		},
		critical_strike = {
			chance_modifier = -0.02,
			max_critical_shots = 2,
		},
	},
	autogun_p2_m2 = {
		fire_rate = {
			fire_time = 0,
			auto_fire_time = {
				lerp_basic = 0.08,
				lerp_perfect = 0.060000000000000005,
			},
		},
		critical_strike = {
			chance_modifier = -0.02,
			max_critical_shots = 2,
		},
	},
	autogun_p2_m2_hip = {
		fire_rate = {
			fire_time = 0,
			auto_fire_time = {
				lerp_basic = 0.09999999999999999,
				lerp_perfect = 0.08,
			},
		},
		critical_strike = {
			chance_modifier = -0.02,
			max_critical_shots = 2,
		},
	},
	autogun_p2_m3 = {
		fire_rate = {
			fire_time = 0,
			auto_fire_time = {
				lerp_basic = 0.13,
				lerp_perfect = 0.11,
			},
		},
		critical_strike = {
			chance_modifier = -0.02,
			max_critical_shots = 2,
		},
	},
	autogun_full_auto_assault = {
		fire_rate = {
			fire_time = 0,
			auto_fire_time = {
				lerp_basic = 0.085,
				lerp_perfect = 0.068,
			},
		},
		critical_strike = {
			chance_modifier = -0.02,
			max_critical_shots = 3,
		},
	},
	stubrevolver_single_shot = {
		fire_rate = {
			fire_time = 0,
		},
		critical_strike = {
			chance_modifier = {
				lerp_basic = 0.05,
				lerp_perfect = 0.25,
			},
		},
	},
	default_reload_speed_modify = {
		time_scale = {
			lerp_basic = 0.2,
			lerp_perfect = 1,
		},
	},
	ogryn_heavystubber_p1_m1_full_auto = {
		fire_rate = {
			auto_fire_time = 0.11,
			fire_time = 0.22,
		},
		critical_strike = {
			chance_modifier = -0.02,
			max_critical_shots = 6,
		},
	},
	ogryn_heavystubber_p1_m1_hip_fire = {
		fire_rate = {
			auto_fire_time = 0.11,
			fire_time = 0.22,
		},
		critical_strike = {
			chance_modifier = -0.02,
			max_critical_shots = 6,
		},
	},
	ogryn_heavystubber_p1_m2_full_auto = {
		fire_rate = {
			auto_fire_time = 0.16,
			fire_time = 0.22,
		},
		critical_strike = {
			chance_modifier = -0.02,
			max_critical_shots = 6,
		},
	},
	ogryn_heavystubber_p1_m2_hip_fire = {
		fire_rate = {
			auto_fire_time = 0.16,
			fire_time = 0.22,
		},
		critical_strike = {
			chance_modifier = -0.02,
			max_critical_shots = 6,
		},
	},
	ogryn_heavystubber_p1_m3_full_auto = {
		fire_rate = {
			auto_fire_time = 0.093,
			fire_time = 0,
		},
		critical_strike = {
			chance_modifier = -0.02,
			max_critical_shots = 6,
		},
	},
	ogryn_heavystubber_p1_m3_hip_fire = {
		fire_rate = {
			auto_fire_time = 0.093,
			fire_time = 0,
		},
		critical_strike = {
			chance_modifier = -0.02,
			max_critical_shots = 6,
		},
	},
	shotgun_double_shot = {
		fire_rate = {
			auto_fire_time = 0.0005,
			fire_time = 0,
			max_shots = 2,
		},
	},
}

return settings("WeaponHandlingTemplates", weapon_handling_templates)
