-- chunkname: @scripts/settings/equipment/weapon_templates/weapon_trait_templates/charge_trait_templates.lua

local charge_trait_templates = {}

charge_trait_templates.forcestaff_p1_m1_charge_speed_stat = {
	{
		"charge_duration",
		{
			max = 0.8,
			min = 0.2
		}
	}
}
charge_trait_templates.forcestaff_p1_m1_charge_speed_perk = {
	{
		"charge_duration",
		0.05
	}
}
charge_trait_templates.forcestaff_p1_m1_warp_charge_cost_stat = {
	{
		"warp_charge_percent",
		{
			max = 0.75,
			min = 0.25
		}
	},
	{
		"extra_warp_charge_percent",
		{
			max = 0.75,
			min = 0.25
		}
	},
	{
		"forcestaff_p1_m1_use_aoe",
		{
			max = 0.75,
			min = 0.25
		}
	}
}
charge_trait_templates.forcestaff_p1_m1_warp_charge_cost_perk = {
	{
		"warp_charge_percent",
		0.05
	},
	{
		"extra_warp_charge_percent",
		0.05
	}
}
charge_trait_templates.forcestaff_p2_m1_warp_charge_cost_stat = {
	{
		"warp_charge_percent",
		{
			max = 0.75,
			min = 0.25
		}
	},
	{
		"extra_warp_charge_percent",
		{
			max = 0.75,
			min = 0.25
		}
	}
}
charge_trait_templates.forcestaff_p3_m1_warp_charge_cost_stat = {
	{
		"warp_charge_percent",
		{
			max = 0.75,
			min = 0.25
		}
	},
	{
		"extra_warp_charge_percent",
		{
			max = 0.75,
			min = 0.25
		}
	}
}
charge_trait_templates.forcestaff_p3_m1_charge_speed_stat = {
	{
		"charge_duration",
		{
			max = 0.8,
			min = 0.2
		}
	}
}
charge_trait_templates.forcestaff_p4_m1_charge_speed_stat = {
	{
		"charge_duration",
		{
			max = 0.8,
			min = 0.2
		}
	}
}
charge_trait_templates.forcestaff_p4_m1_warp_charge_cost_stat = {
	{
		"warp_charge_percent",
		{
			max = 0.75,
			min = 0.25
		}
	},
	{
		"extra_warp_charge_percent",
		{
			max = 0.75,
			min = 0.25
		}
	}
}
charge_trait_templates.forcestaff_secondary_action_charge_cost_stat = {
	{
		"warp_charge_percent",
		{
			max = 1,
			min = 0
		}
	}
}
charge_trait_templates.forcesword_p1_m1_warp_charge_cost_stat = {
	{
		"warp_charge_percent",
		{
			max = 0.75,
			min = 0.25
		}
	},
	{
		"extra_warp_charge_percent",
		{
			max = 0.75,
			min = 0.25
		}
	}
}
charge_trait_templates.forcesword_p1_m1_warp_charge_cost_perk = {
	{
		"warp_charge_percent",
		0.05
	},
	{
		"extra_warp_charge_percent",
		0.05
	}
}
charge_trait_templates.forcesword_p1_m1_weapon_special_warp_charge_cost = {
	{
		"warp_charge_percent",
		{
			max = 0.9,
			min = 0.1
		}
	}
}
charge_trait_templates.plasmagun_charge_speed_stat = {
	{
		"charge_duration",
		{
			max = 1,
			min = 0
		}
	}
}
charge_trait_templates.plasmagun_charge_cost_stat = {
	{
		"overheat_percent",
		{
			max = 1,
			min = 0
		}
	},
	{
		"extra_overheat_percent",
		{
			max = 1,
			min = 0
		}
	}
}

return charge_trait_templates
