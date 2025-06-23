-- chunkname: @scripts/settings/warp_charge/weapon_warp_charge_templates.lua

local weapon_warp_charge_templates = {}

weapon_warp_charge_templates.default = {
	default_threshold_decay_rate_modifier = 1,
	low_threshold_decay_rate_modifier = 1,
	critical_threshold_modifier = 1,
	auto_vent_delay_modifier = 1,
	high_threshold_decay_rate_modifier = 1,
	vent_interval_modifier = 1,
	critical_threshold_decay_rate_modifier = 1,
	low_threshold_modifier = 1,
	high_threshold_modifier = 1,
	vent_duration_modifier = {
		lerp_perfect = 0.5,
		lerp_basic = 1.5
	},
	auto_vent_duration_modifier = {
		lerp_perfect = 0.5,
		lerp_basic = 1.5
	},
	vent_power_level_modifier = {
		1,
		1
	}
}
weapon_warp_charge_templates.forcestaff_p1_m1 = {
	default_threshold_decay_rate_modifier = 1,
	low_threshold_decay_rate_modifier = 1,
	critical_threshold_modifier = 1,
	auto_vent_delay_modifier = 1,
	high_threshold_decay_rate_modifier = 1,
	vent_interval_modifier = 1,
	critical_threshold_decay_rate_modifier = 1,
	low_threshold_modifier = 1,
	high_threshold_modifier = 1,
	vent_duration_modifier = {
		lerp_perfect = 0.5,
		lerp_basic = 1.5
	},
	auto_vent_duration_modifier = {
		lerp_perfect = 0.6,
		lerp_basic = 1.4
	},
	vent_power_level_modifier = {
		0,
		0
	}
}
weapon_warp_charge_templates.forcestaff_p2_m1 = {
	default_threshold_decay_rate_modifier = 1,
	low_threshold_decay_rate_modifier = 1,
	critical_threshold_modifier = 1,
	auto_vent_delay_modifier = 1,
	high_threshold_decay_rate_modifier = 1,
	vent_interval_modifier = 1,
	critical_threshold_decay_rate_modifier = 1,
	low_threshold_modifier = 1,
	high_threshold_modifier = 1,
	vent_duration_modifier = {
		lerp_perfect = 0.5,
		lerp_basic = 1.5
	},
	auto_vent_duration_modifier = {
		lerp_perfect = 0.6,
		lerp_basic = 1.4
	},
	vent_power_level_modifier = {
		0,
		0
	}
}
weapon_warp_charge_templates.forcestaff_p3_m1 = {
	default_threshold_decay_rate_modifier = 1,
	low_threshold_decay_rate_modifier = 1,
	critical_threshold_modifier = 1,
	auto_vent_delay_modifier = 1,
	high_threshold_decay_rate_modifier = 1,
	vent_interval_modifier = 1,
	critical_threshold_decay_rate_modifier = 1,
	low_threshold_modifier = 1,
	high_threshold_modifier = 1,
	vent_duration_modifier = {
		lerp_perfect = 0.5,
		lerp_basic = 1.5
	},
	auto_vent_duration_modifier = {
		lerp_perfect = 0.6,
		lerp_basic = 1.4
	},
	vent_power_level_modifier = {
		0,
		0
	}
}
weapon_warp_charge_templates.forcestaff_p4_m1 = {
	default_threshold_decay_rate_modifier = 1,
	low_threshold_decay_rate_modifier = 1,
	critical_threshold_modifier = 1,
	auto_vent_delay_modifier = 1,
	high_threshold_decay_rate_modifier = 1,
	vent_interval_modifier = 1,
	critical_threshold_decay_rate_modifier = 1,
	low_threshold_modifier = 1,
	high_threshold_modifier = 1,
	vent_duration_modifier = {
		lerp_perfect = 0.5,
		lerp_basic = 1.5
	},
	auto_vent_duration_modifier = {
		lerp_perfect = 0.6,
		lerp_basic = 1.4
	},
	vent_power_level_modifier = {
		0,
		0
	}
}
weapon_warp_charge_templates.forcesword_p1_m1 = {
	default_threshold_decay_rate_modifier = 1,
	low_threshold_decay_rate_modifier = 1,
	critical_threshold_modifier = 1,
	auto_vent_delay_modifier = 1,
	high_threshold_decay_rate_modifier = 1,
	vent_interval_modifier = 1,
	critical_threshold_decay_rate_modifier = 1,
	low_threshold_modifier = 1,
	high_threshold_modifier = 1,
	vent_duration_modifier = {
		lerp_perfect = 0.5,
		lerp_basic = 1.5
	},
	auto_vent_duration_modifier = {
		lerp_perfect = 0.6,
		lerp_basic = 1.4
	},
	vent_power_level_modifier = {
		0,
		0
	}
}
weapon_warp_charge_templates.forcesword_2h = {
	default_threshold_decay_rate_modifier = 1,
	low_threshold_decay_rate_modifier = 1,
	critical_threshold_modifier = 1,
	auto_vent_delay_modifier = 1,
	high_threshold_decay_rate_modifier = 1,
	vent_interval_modifier = 1,
	critical_threshold_decay_rate_modifier = 1,
	low_threshold_modifier = 1,
	high_threshold_modifier = 1,
	vent_duration_modifier = {
		lerp_perfect = 0.6,
		lerp_basic = 1.75
	},
	auto_vent_duration_modifier = {
		lerp_perfect = 0.65,
		lerp_basic = 1.55
	},
	vent_power_level_modifier = {
		0,
		0
	}
}
weapon_warp_charge_templates.psyker_smite = {
	default_threshold_decay_rate_modifier = 1,
	low_threshold_decay_rate_modifier = 1,
	critical_threshold_modifier = 1,
	auto_vent_delay_modifier = 1,
	high_threshold_decay_rate_modifier = 1,
	vent_interval_modifier = 1,
	critical_threshold_decay_rate_modifier = 1,
	low_threshold_modifier = 1,
	high_threshold_modifier = 1,
	vent_duration_modifier = {
		lerp_perfect = 0.75,
		lerp_basic = 1.25
	},
	auto_vent_duration_modifier = {
		lerp_perfect = 0.6,
		lerp_basic = 1.4
	},
	vent_power_level_modifier = {
		0,
		0
	}
}

return settings("WeaponWarpChargeTemplates", weapon_warp_charge_templates)
