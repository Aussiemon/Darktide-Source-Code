local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
local DEFAULT_LERP_VALUE = WeaponTweakTemplateSettings.DEFAULT_LERP_VALUE
local dodge_trait_templates = {
	default_dodge_stat = {
		{
			"distance_scale",
			{
				max = 0.75,
				min = 0.25
			}
		},
		{
			"diminishing_return_distance_modifier",
			{
				max = 0.75,
				min = 0.25
			}
		},
		{
			"diminishing_return_start",
			{
				max = 0.75,
				min = 0.25
			}
		},
		{
			"diminishing_return_limit",
			{
				max = 0.75,
				min = 0.25
			}
		},
		{
			"speed_modifier",
			{
				max = 0.75,
				min = 0.25
			}
		}
	},
	ogryn_dodge_stat = {
		{
			"distance_scale",
			{
				max = 0.6,
				min = 0.4
			}
		},
		{
			"diminishing_return_distance_modifier",
			{
				max = 0.6,
				min = 0.4
			}
		},
		{
			"diminishing_return_start",
			{
				max = 0.7,
				min = 0.3
			}
		},
		{
			"diminishing_return_limit",
			{
				max = 0.7,
				min = 0.3
			}
		},
		{
			"speed_modifier",
			{
				max = 0.6,
				min = 0.4
			}
		}
	},
	default_dodge_perk = {
		{
			"distance_scale",
			0.05
		},
		{
			"diminishing_return_distance_modifier",
			0.05
		},
		{
			"diminishing_return_start",
			0.05
		},
		{
			"diminishing_return_limit",
			0.05
		},
		{
			"speed_modifier",
			0.05
		}
	},
	dodge_trait_01_a = {
		{
			"distance_scale",
			0.6
		},
		{
			"diminishing_return_distance_modifier",
			0.6
		},
		{
			"diminishing_return_start",
			0.6
		},
		{
			"diminishing_return_limit",
			0.6
		},
		{
			"speed_modifier",
			0.6
		},
		[DEFAULT_LERP_VALUE] = 0.1
	},
	dodge_trait_01_b = {
		{
			"distance_scale",
			0.8
		},
		{
			"diminishing_return_distance_modifier",
			0.8
		},
		{
			"diminishing_return_start",
			0.8
		},
		{
			"diminishing_return_limit",
			0.8
		},
		{
			"speed_modifier",
			0.8
		},
		[DEFAULT_LERP_VALUE] = 0.2
	},
	dodge_trait_01_c = {
		{
			"distance_scale",
			1
		},
		{
			"diminishing_return_distance_modifier",
			1
		},
		{
			"diminishing_return_start",
			1
		},
		{
			"diminishing_return_limit",
			1
		},
		{
			"speed_modifier",
			1
		},
		[DEFAULT_LERP_VALUE] = 0.3
	}
}

return dodge_trait_templates
