local explosion_trait_templates = {
	default_explosion_size_stat = {
		{
			"radius",
			{
				max = 1,
				min = 0
			}
		},
		{
			"close_radius",
			{
				max = 1,
				min = 0
			}
		},
		{
			"explosion_area_suppression",
			"distance",
			{
				max = 1,
				min = 0
			}
		},
		{
			"explosion_area_suppression",
			"suppression_value",
			{
				max = 1,
				min = 0
			}
		}
	},
	default_explosion_size_perk = {
		{
			"radius",
			0.05
		},
		{
			"explosion_area_suppression",
			"distance",
			0.05
		},
		{
			"explosion_area_suppression",
			"suppression_value",
			0.05
		}
	},
	default_explosion_damage_stat = {
		{
			"static_power_level",
			{
				max = 1,
				min = 0
			}
		}
	},
	dafault_explosion_damage_perk = {
		{
			"close_radius",
			0.05
		}
	},
	forcestaff_p1_m1_explosion_size_stat = {
		{
			"radius",
			{
				max = 1,
				min = 0
			}
		},
		{
			"close_radius",
			{
				max = 0.75,
				min = 0.25
			}
		}
	},
	forcestaff_p1_m1_explosion_size_perk = {
		{
			"radius",
			0.05
		},
		{
			"close_radius",
			0.05
		}
	},
	forcestaff_p4_m1_explosion_size_stat = {
		{
			"radius",
			{
				max = 1,
				min = 0
			}
		},
		{
			"close_radius",
			{
				max = 0.75,
				min = 0.25
			}
		}
	}
}

return explosion_trait_templates
