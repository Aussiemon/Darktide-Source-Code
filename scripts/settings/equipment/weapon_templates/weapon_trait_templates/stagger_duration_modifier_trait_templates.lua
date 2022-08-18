local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
local DEFAULT_LERP_VALUE = WeaponTweakTemplateSettings.DEFAULT_LERP_VALUE
local stagger_duration_modifier_trait_templates = {
	thunderhammer_p1_m1_control_stat = {
		{
			"targets",
			1,
			"stagger_duration",
			{
				max = 0.75,
				min = 0.25
			}
		},
		{
			"targets",
			2,
			"stagger_duration",
			{
				max = 0.75,
				min = 0.25
			}
		},
		{
			"targets",
			3,
			"stagger_duration",
			{
				max = 0.75,
				min = 0.25
			}
		},
		{
			"targets",
			4,
			"stagger_duration",
			{
				max = 0.75,
				min = 0.25
			}
		},
		{
			"targets",
			5,
			"stagger_duration",
			{
				max = 0.75,
				min = 0.25
			}
		}
	}
}

return stagger_duration_modifier_trait_templates
