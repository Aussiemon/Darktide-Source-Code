-- chunkname: @scripts/settings/equipment/weapon_templates/weapon_trait_templates/burninating_trait_templates.lua

local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
local DEFAULT_LERP_VALUE = WeaponTweakTemplateSettings.DEFAULT_LERP_VALUE
local burninating_trait_templates = {}

burninating_trait_templates.flamer_p1_m1_burninating_stat = {
	{
		"max_stacks",
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"stack_application_rate",
		{
			max = 0.75,
			min = 0.25,
		},
	},
}
burninating_trait_templates.flamer_p1_m1_burninating_perk = {
	{
		"max_stacks",
		0.1,
	},
	{
		"stack_application_rate",
		0.1,
	},
}
burninating_trait_templates.forcestaff_p2_m1_burninating_stat = {
	{
		"max_stacks",
		{
			max = 0.75,
			min = 0.25,
		},
	},
	{
		"stack_application_rate",
		{
			max = 0.75,
			min = 0.25,
		},
	},
}

return burninating_trait_templates
