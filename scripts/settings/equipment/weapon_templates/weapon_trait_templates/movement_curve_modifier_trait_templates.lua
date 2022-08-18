local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
local DEFAULT_LERP_VALUE = WeaponTweakTemplateSettings.DEFAULT_LERP_VALUE
local movement_curve_modifier_trait_templates = {
	default_movement_curve_modifier_stat = {
		{
			"modifier",
			{
				max = 0.95,
				min = 0.05
			}
		}
	},
	default_movement_curve_modifier_perk = {
		{
			"modifier",
			0.05
		}
	}
}

return movement_curve_modifier_trait_templates
