-- chunkname: @scripts/settings/equipment/weapon_templates/weapon_trait_templates/sprint_trait_templates.lua

local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
local DEFAULT_LERP_VALUE = WeaponTweakTemplateSettings.DEFAULT_LERP_VALUE
local sprint_trait_templates = {}

sprint_trait_templates.default_sprint_stat = {
	{
		"sprint_speed_mod",
		{
			max = 0.95,
			min = 0.05,
		},
	},
	{
		"sprint_forward_acceleration",
		{
			max = 0.95,
			min = 0.05,
		},
	},
}
sprint_trait_templates.default_sprint_perk = {
	{
		"sprint_speed_mod",
		0.05,
	},
	{
		"sprint_forward_acceleration",
		0.05,
	},
}
sprint_trait_templates.sprint_trait_01_a = {
	{
		"sprint_speed_mod",
		0.6,
	},
	{
		"sprint_forward_acceleration",
		0.6,
	},
	[DEFAULT_LERP_VALUE] = 0.1,
}
sprint_trait_templates.sprint_trait_01_b = {
	{
		"sprint_speed_mod",
		0.8,
	},
	{
		"sprint_forward_acceleration",
		0.8,
	},
	[DEFAULT_LERP_VALUE] = 0.2,
}
sprint_trait_templates.sprint_trait_01_c = {
	{
		"sprint_speed_mod",
		1,
	},
	{
		"sprint_forward_acceleration",
		1,
	},
	[DEFAULT_LERP_VALUE] = 0.3,
}

return sprint_trait_templates
