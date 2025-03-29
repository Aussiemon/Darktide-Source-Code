-- chunkname: @scripts/settings/equipment/weapon_templates/weapon_trait_templates/movement_curve_modifier_trait_templates.lua

local movement_curve_modifier_trait_templates = {}

movement_curve_modifier_trait_templates.default_movement_curve_modifier_stat = {
	{
		"modifier",
		{
			max = 0.95,
			min = 0.05,
		},
	},
}
movement_curve_modifier_trait_templates.default_movement_curve_modifier_perk = {
	{
		"modifier",
		0.05,
	},
}

return movement_curve_modifier_trait_templates
