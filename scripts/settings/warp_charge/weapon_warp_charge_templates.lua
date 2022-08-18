local weapon_warp_charge_templates = {
	default = {
		default_threshold_decay_rate_modifier = 2,
		low_threshold_decay_rate_modifier = 2,
		vent_duration_modifier = 1,
		critical_threshold_modifier = 1,
		auto_vent_delay_modifier = 1,
		high_threshold_decay_rate_modifier = 2,
		vent_interval_modifier = 1,
		critical_threshold_decay_rate_modifier = 2,
		low_threshold_modifier = 1,
		auto_vent_duration_modifier = 1,
		high_threshold_modifier = 1,
		vent_power_level_modifier = {
			1,
			1
		}
	},
	forcestaff_p1_m1 = {
		default_threshold_decay_rate_modifier = 2,
		low_threshold_decay_rate_modifier = 2,
		critical_threshold_modifier = 1,
		auto_vent_delay_modifier = 1,
		high_threshold_decay_rate_modifier = 2,
		vent_interval_modifier = 1,
		critical_threshold_decay_rate_modifier = 2,
		low_threshold_modifier = 1,
		high_threshold_modifier = 1,
		vent_duration_modifier = {
			lerp_perfect = 0.5,
			lerp_basic = 1.5
		},
		auto_vent_duration_modifier = {
			lerp_perfect = 1,
			lerp_basic = 5
		},
		vent_power_level_modifier = {
			0,
			0
		}
	},
	forcesword_p1_m1 = {
		default_threshold_decay_rate_modifier = 2,
		low_threshold_decay_rate_modifier = 2,
		critical_threshold_modifier = 1,
		auto_vent_delay_modifier = 1,
		high_threshold_decay_rate_modifier = 2,
		vent_interval_modifier = 1,
		critical_threshold_decay_rate_modifier = 2,
		low_threshold_modifier = 1,
		high_threshold_modifier = 1,
		vent_duration_modifier = {
			lerp_perfect = 0.75,
			lerp_basic = 1.25
		},
		auto_vent_duration_modifier = {
			lerp_perfect = 2.5,
			lerp_basic = 5
		},
		vent_power_level_modifier = {
			0,
			0
		}
	},
	psyker_smite = {
		default_threshold_decay_rate_modifier = 2,
		low_threshold_decay_rate_modifier = 2,
		critical_threshold_modifier = 1,
		auto_vent_delay_modifier = 1,
		high_threshold_decay_rate_modifier = 2,
		vent_interval_modifier = 1,
		critical_threshold_decay_rate_modifier = 2,
		low_threshold_modifier = 1,
		high_threshold_modifier = 1,
		vent_duration_modifier = {
			lerp_perfect = 0.75,
			lerp_basic = 1.25
		},
		auto_vent_duration_modifier = {
			lerp_perfect = 2.5,
			lerp_basic = 5
		},
		vent_power_level_modifier = {
			0,
			0
		}
	}
}

return settings("WeaponWarpChargeTemplates", weapon_warp_charge_templates)
