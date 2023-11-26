-- chunkname: @scripts/settings/equipment/weapon_templates/weapon_trait_templates/weapon_handling_trait_templates.lua

local weapon_handling_trait_templates = {}

weapon_handling_trait_templates.test_01 = {
	{
		"fire_rate",
		"auto_fire_time",
		0
	}
}
weapon_handling_trait_templates.rate_of_fire_01 = {
	{
		"fire_rate",
		"auto_fire_time",
		1
	}
}
weapon_handling_trait_templates.default_finesse_stat = {
	{
		"time_scale",
		{
			max = 0.6,
			min = 0.3
		}
	}
}
weapon_handling_trait_templates.default_finesse_perk = {
	{
		"time_scale",
		0.05
	}
}
weapon_handling_trait_templates.flamer_p1_m1_ramp_up_stat = {
	{
		"flamer_ramp_up_times",
		1,
		{
			max = 0.75,
			min = 0.25
		}
	},
	{
		"flamer_ramp_up_times",
		2,
		{
			max = 0.75,
			min = 0.25
		}
	},
	{
		"flamer_ramp_up_times",
		3,
		{
			max = 0.75,
			min = 0.25
		}
	},
	{
		"flamer_ramp_up_times",
		4,
		{
			max = 0.75,
			min = 0.25
		}
	},
	{
		"flamer_ramp_up_times",
		5,
		{
			max = 0.75,
			min = 0.25
		}
	},
	{
		"flamer_ramp_up_times",
		6,
		{
			max = 0.75,
			min = 0.25
		}
	},
	{
		"flamer_ramp_up_times",
		7,
		{
			max = 0.75,
			min = 0.25
		}
	}
}
weapon_handling_trait_templates.flamer_p1_m1_ramp_up_perk = {
	{
		"flamer_ramp_up_times",
		1,
		0.05
	},
	{
		"flamer_ramp_up_times",
		2,
		0.05
	},
	{
		"flamer_ramp_up_times",
		3,
		0.05
	},
	{
		"flamer_ramp_up_times",
		4,
		0.05
	},
	{
		"flamer_ramp_up_times",
		5,
		0.05
	},
	{
		"flamer_ramp_up_times",
		6,
		0.05
	},
	{
		"flamer_ramp_up_times",
		7,
		0.05
	}
}
weapon_handling_trait_templates.forcestaff_p2_m1_ramp_up_stat = {
	{
		"flamer_ramp_up_times",
		1,
		{
			max = 0.75,
			min = 0.25
		}
	},
	{
		"flamer_ramp_up_times",
		2,
		{
			max = 0.75,
			min = 0.25
		}
	},
	{
		"flamer_ramp_up_times",
		3,
		{
			max = 0.75,
			min = 0.25
		}
	},
	{
		"flamer_ramp_up_times",
		4,
		{
			max = 0.75,
			min = 0.25
		}
	},
	{
		"flamer_ramp_up_times",
		5,
		{
			max = 0.75,
			min = 0.25
		}
	},
	{
		"flamer_ramp_up_times",
		6,
		{
			max = 0.75,
			min = 0.25
		}
	},
	{
		"flamer_ramp_up_times",
		7,
		{
			max = 0.75,
			min = 0.25
		}
	}
}
weapon_handling_trait_templates.forcestaff_p3_m1_crit_stat = {
	{
		"critical_strike",
		"chance_modifier",
		{
			max = 1,
			min = 0
		}
	}
}
weapon_handling_trait_templates.stubrevolver_crit_stat = {
	{
		"critical_strike",
		"chance_modifier",
		{
			max = 1,
			min = 0
		}
	}
}
weapon_handling_trait_templates.default_reload_speed_modify = {
	{
		"time_scale",
		{
			max = 0.75,
			min = 0.1
		}
	}
}
weapon_handling_trait_templates.max_reload_speed_modify = {
	{
		"time_scale",
		{
			max = 0.75,
			min = 0
		}
	}
}

return weapon_handling_trait_templates
