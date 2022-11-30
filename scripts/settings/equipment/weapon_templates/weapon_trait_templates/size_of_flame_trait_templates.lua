local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
local DEFAULT_LERP_VALUE = WeaponTweakTemplateSettings.DEFAULT_LERP_VALUE
local size_of_flame_trait_templates = {
	flamer_p1_m1_size_of_flame_stat = {
		{
			"range",
			{
				max = 1,
				min = 0
			}
		},
		{
			"spread_angle",
			{
				max = 1,
				min = 0
			}
		},
		{
			"suppression_cone_radius",
			{
				max = 1,
				min = 0
			}
		}
	},
	flamer_p1_m1_range_perk = {
		{
			"range",
			0.1
		},
		{
			"suppression",
			0.1
		}
	},
	flamer_p1_m1_spread_angle_perk = {
		{
			"spread_angle",
			0.1
		}
	},
	forcestaff_p2_m1_size_of_flame_stat = {
		{
			"range",
			{
				max = 1,
				min = 0
			}
		},
		{
			"spread_angle",
			{
				max = 1,
				min = 0
			}
		},
		{
			"suppression_cone_radius",
			{
				max = 1,
				min = 0
			}
		}
	}
}

return size_of_flame_trait_templates
