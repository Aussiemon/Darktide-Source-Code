-- chunkname: @scripts/settings/equipment/weapon_templates/weapon_trait_templates/ammo_trait_templates.lua

local ammo_trait_templates = {}

ammo_trait_templates.default_ammo_stat = {
	{
		"ammunition_clip",
		{
			max = 1,
			min = 0,
		},
	},
	{
		"ammunition_reserve",
		{
			max = 1,
			min = 0,
		},
	},
}
ammo_trait_templates.default_ammo_perk = {
	{
		"ammunition_clip",
		0.05,
	},
	{
		"ammunition_reserve",
		0.05,
	},
}
ammo_trait_templates.flamer_p1_m1_ammo_stat = {
	{
		"ammunition_clip",
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"ammunition_reserve",
		{
			max = 0.75,
			min = 0.25,
		},
	},
}
ammo_trait_templates.default_explosive_ammo_stat = {
	{
		"ammunition_reserve",
		{
			max = 1,
			min = 0,
		},
	},
}
ammo_trait_templates.default_explosive_ammo_perk = {
	{
		"ammunition_reserve",
		0.05,
	},
}

return ammo_trait_templates
