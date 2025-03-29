-- chunkname: @scripts/settings/equipment/weapon_templates/weapon_trait_templates/size_of_flame_trait_templates.lua

local size_of_flame_trait_templates = {}

size_of_flame_trait_templates.flamer_p1_m1_size_of_flame_stat = {
	{
		"range",
		{
			max = 1,
			min = 0,
		},
	},
	{
		"spread_angle",
		{
			max = 1,
			min = 0,
		},
	},
	{
		"suppression_cone_radius",
		{
			max = 1,
			min = 0,
		},
	},
}
size_of_flame_trait_templates.flamer_p1_m1_range_perk = {
	{
		"range",
		0.1,
	},
	{
		"suppression",
		0.1,
	},
}
size_of_flame_trait_templates.flamer_p1_m1_spread_angle_perk = {
	{
		"spread_angle",
		0.1,
	},
}
size_of_flame_trait_templates.forcestaff_p2_m1_size_of_flame_stat = {
	{
		"range",
		{
			max = 1,
			min = 0,
		},
	},
	{
		"spread_angle",
		{
			max = 1,
			min = 0,
		},
	},
	{
		"suppression_cone_radius",
		{
			max = 1,
			min = 0,
		},
	},
}

return size_of_flame_trait_templates
