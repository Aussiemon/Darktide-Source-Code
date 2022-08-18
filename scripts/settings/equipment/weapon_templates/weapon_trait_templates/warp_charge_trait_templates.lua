local warp_charge_trait_templates = {
	forcestaff_p1_m1_vent_speed_stat = {
		{
			"vent_duration_modifier",
			{
				max = 0.75,
				min = 0.25
			}
		},
		{
			"auto_vent_duration_modifier",
			{
				max = 0.75,
				min = 0.25
			}
		}
	},
	forcestaff_p1_m1_vent_speed_perk = {
		{
			"vent_duration_modifier",
			0.05
		},
		{
			"auto_vent_duration_modifier",
			0.05
		}
	}
}

return warp_charge_trait_templates
