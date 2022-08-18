local WeaponMovementStateSettings = require("scripts/settings/equipment/weapon_movement_state_settings")
local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
local weapon_movement_states = WeaponMovementStateSettings.weapon_movement_states
local ALL_WEAPON_MOVEMENT_STATES = WeaponTweakTemplateSettings.ALL_WEAPON_MOVEMENT_STATES
local DEFAULT_LERP_VALUE = WeaponTweakTemplateSettings.DEFAULT_LERP_VALUE
local recoil_trait_templates = {
	default_recoil_stat = {
		{
			"still",
			"offset",
			1,
			"pitch",
			{
				max = 0.95,
				min = 0.05
			}
		},
		{
			"still",
			"offset",
			2,
			"pitch",
			{
				max = 0.95,
				min = 0.05
			}
		},
		{
			"still",
			"offset",
			3,
			"pitch",
			{
				max = 0.9,
				min = 0.1
			}
		},
		{
			"still",
			"offset",
			4,
			"pitch",
			{
				max = 0.75,
				min = 0.25
			}
		},
		{
			"still",
			"offset",
			5,
			"pitch",
			{
				max = 0.75,
				min = 0.25
			}
		},
		{
			"still",
			"offset",
			6,
			"pitch",
			{
				max = 0.75,
				min = 0.25
			}
		},
		{
			"still",
			"offset",
			1,
			"yaw",
			{
				max = 0.95,
				min = 0.05
			}
		},
		{
			"still",
			"offset",
			2,
			"yaw",
			{
				max = 0.95,
				min = 0.05
			}
		},
		{
			"still",
			"offset",
			3,
			"yaw",
			{
				max = 0.9,
				min = 0.1
			}
		},
		{
			"still",
			"offset",
			4,
			"yaw",
			{
				max = 0.75,
				min = 0.25
			}
		},
		{
			"still",
			"offset",
			5,
			"yaw",
			{
				max = 0.75,
				min = 0.25
			}
		},
		{
			"still",
			"offset",
			6,
			"yaw",
			{
				max = 0.75,
				min = 0.25
			}
		},
		{
			"moving",
			"offset",
			1,
			"pitch",
			{
				max = 0.95,
				min = 0.05
			}
		},
		{
			"moving",
			"offset",
			2,
			"pitch",
			{
				max = 0.95,
				min = 0.05
			}
		},
		{
			"moving",
			"offset",
			3,
			"pitch",
			{
				max = 0.9,
				min = 0.1
			}
		},
		{
			"moving",
			"offset",
			4,
			"pitch",
			{
				max = 0.75,
				min = 0.25
			}
		},
		{
			"moving",
			"offset",
			5,
			"pitch",
			{
				max = 0.75,
				min = 0.25
			}
		},
		{
			"moving",
			"offset",
			6,
			"pitch",
			{
				max = 0.75,
				min = 0.25
			}
		},
		{
			"moving",
			"offset",
			1,
			"yaw",
			{
				max = 0.95,
				min = 0.05
			}
		},
		{
			"moving",
			"offset",
			2,
			"yaw",
			{
				max = 0.95,
				min = 0.05
			}
		},
		{
			"moving",
			"offset",
			3,
			"yaw",
			{
				max = 0.9,
				min = 0.1
			}
		},
		{
			"moving",
			"offset",
			4,
			"yaw",
			{
				max = 0.75,
				min = 0.25
			}
		},
		{
			"moving",
			"offset",
			5,
			"yaw",
			{
				max = 0.75,
				min = 0.25
			}
		},
		{
			"moving",
			"offset",
			6,
			"yaw",
			{
				max = 0.75,
				min = 0.25
			}
		},
		{
			"still",
			"decay",
			"shooting",
			{
				max = 0.95,
				min = 0.05
			}
		},
		{
			"still",
			"decay",
			"idle",
			{
				max = 0.95,
				min = 0.05
			}
		},
		{
			"still",
			"rise",
			1,
			{
				max = 0.6,
				min = 0.4
			}
		},
		{
			"still",
			"rise",
			2,
			{
				max = 0.7,
				min = 0.3
			}
		},
		{
			"still",
			"rise",
			3,
			{
				max = 0.75,
				min = 0.25
			}
		},
		{
			"still",
			"rise",
			4,
			{
				max = 0.8,
				min = 0.2
			}
		}
	},
	default_recoil_perk = {
		{
			"still",
			"offset",
			1,
			"pitch",
			0.05
		},
		{
			"still",
			"offset",
			2,
			"pitch",
			0.05
		},
		{
			"still",
			"offset",
			3,
			"pitch",
			0.05
		},
		{
			"still",
			"offset",
			4,
			"pitch",
			0.05
		},
		{
			"still",
			"offset",
			1,
			"yaw",
			0.05
		},
		{
			"still",
			"offset",
			2,
			"yaw",
			0.05
		},
		{
			"still",
			"offset",
			3,
			"yaw",
			0.05
		},
		{
			"still",
			"offset",
			4,
			"yaw",
			0.05
		},
		{
			"moving",
			"offset",
			1,
			"pitch",
			0.05
		},
		{
			"moving",
			"offset",
			2,
			"pitch",
			0.05
		},
		{
			"moving",
			"offset",
			3,
			"pitch",
			0.05
		},
		{
			"moving",
			"offset",
			4,
			"pitch",
			0.05
		},
		{
			"moving",
			"offset",
			1,
			"yaw",
			0.05
		},
		{
			"moving",
			"offset",
			2,
			"yaw",
			0.05
		},
		{
			"moving",
			"offset",
			3,
			"yaw",
			0.05
		},
		{
			"moving",
			"offset",
			4,
			"yaw",
			0.05
		}
	},
	default_mobility_recoil_stat = {
		{
			"moving",
			"offset",
			1,
			"pitch",
			{
				max = 0.475,
				min = 0.05
			}
		},
		{
			"moving",
			"offset",
			2,
			"pitch",
			{
				max = 0.475,
				min = 0.05
			}
		},
		{
			"moving",
			"offset",
			3,
			"pitch",
			{
				max = 0.45,
				min = 0.05
			}
		},
		{
			"moving",
			"offset",
			4,
			"pitch",
			{
				max = 0.375,
				min = 0.05
			}
		},
		{
			"moving",
			"offset",
			5,
			"pitch",
			{
				max = 0.375,
				min = 0.05
			}
		},
		{
			"moving",
			"offset",
			6,
			"pitch",
			{
				max = 0.375,
				min = 0.05
			}
		},
		{
			"moving",
			"offset",
			1,
			"yaw",
			{
				max = 0.475,
				min = 0.05
			}
		},
		{
			"moving",
			"offset",
			2,
			"yaw",
			{
				max = 0.475,
				min = 0.05
			}
		},
		{
			"moving",
			"offset",
			3,
			"yaw",
			{
				max = 0.45,
				min = 0.05
			}
		},
		{
			"moving",
			"offset",
			4,
			"yaw",
			{
				max = 0.375,
				min = 0.05
			}
		},
		{
			"moving",
			"offset",
			5,
			"yaw",
			{
				max = 0.375,
				min = 0.05
			}
		},
		{
			"moving",
			"offset",
			6,
			"yaw",
			{
				max = 0.375,
				min = 0.05
			}
		}
	},
	default_mobility_recoil_perk = {
		{
			"moving",
			"offset",
			1,
			"pitch",
			0.05
		},
		{
			"moving",
			"offset",
			2,
			"pitch",
			0.05
		},
		{
			"moving",
			"offset",
			3,
			"pitch",
			0.05
		},
		{
			"moving",
			"offset",
			4,
			"pitch",
			0.05
		},
		{
			"moving",
			"offset",
			1,
			"yaw",
			0.05
		},
		{
			"moving",
			"offset",
			2,
			"yaw",
			0.05
		},
		{
			"moving",
			"offset",
			3,
			"yaw",
			0.05
		},
		{
			"moving",
			"offset",
			4,
			"yaw",
			0.05
		}
	},
	lasgun_p1_m1_recoil_stat = {
		{
			"still",
			"rise",
			1,
			{
				max = 1,
				min = 0
			}
		},
		{
			"still",
			"rise",
			2,
			{
				max = 0.95,
				min = 0.05
			}
		},
		{
			"still",
			"rise",
			3,
			{
				max = 0.8,
				min = 0.1
			}
		},
		{
			"still",
			"offset",
			1,
			"pitch",
			{
				max = 0.95,
				min = 0
			}
		},
		{
			"still",
			"offset",
			2,
			"pitch",
			{
				max = 0.9,
				min = 0.05
			}
		},
		{
			"still",
			"offset",
			3,
			"pitch",
			{
				max = 0.8,
				min = 0.1
			}
		},
		{
			"still",
			"offset",
			4,
			"pitch",
			{
				max = 0.75,
				min = 0.25
			}
		},
		{
			"still",
			"offset",
			1,
			"yaw",
			{
				max = 0.75,
				min = 0
			}
		},
		{
			"still",
			"offset",
			2,
			"yaw",
			{
				max = 0.75,
				min = 0.25
			}
		},
		{
			"still",
			"offset",
			3,
			"yaw",
			{
				max = 0.75,
				min = 0.25
			}
		},
		{
			"still",
			"offset",
			4,
			"yaw",
			{
				max = 0.75,
				min = 0.25
			}
		},
		{
			"still",
			"offset_random_range",
			1,
			"pitch",
			{
				max = 0.95,
				min = 0
			}
		},
		{
			"still",
			"offset_random_range",
			2,
			"pitch",
			{
				max = 0.9,
				min = 0.05
			}
		},
		{
			"still",
			"offset_random_range",
			3,
			"pitch",
			{
				max = 0.8,
				min = 0.1
			}
		},
		{
			"still",
			"offset_random_range",
			4,
			"pitch",
			{
				max = 0.75,
				min = 0.25
			}
		},
		{
			"still",
			"offset_random_range",
			1,
			"yaw",
			{
				max = 0.95,
				min = 0
			}
		},
		{
			"still",
			"offset_random_range",
			2,
			"yaw",
			{
				max = 0.9,
				min = 0.05
			}
		},
		{
			"still",
			"offset_random_range",
			3,
			"yaw",
			{
				max = 0.8,
				min = 0.1
			}
		},
		{
			"still",
			"offset_random_range",
			4,
			"yaw",
			{
				max = 0.75,
				min = 0.25
			}
		},
		{
			"moving",
			"offset",
			1,
			"pitch",
			{
				max = 0.75,
				min = 0.25
			}
		},
		{
			"moving",
			"offset",
			2,
			"pitch",
			{
				max = 0.75,
				min = 0.25
			}
		},
		{
			"moving",
			"offset",
			3,
			"pitch",
			{
				max = 0.75,
				min = 0.25
			}
		},
		{
			"moving",
			"offset",
			4,
			"pitch",
			{
				max = 0.75,
				min = 0.25
			}
		},
		{
			"moving",
			"offset",
			1,
			"yaw",
			{
				max = 0.75,
				min = 0.25
			}
		},
		{
			"moving",
			"offset",
			2,
			"yaw",
			{
				max = 0.75,
				min = 0.25
			}
		},
		{
			"moving",
			"offset",
			3,
			"yaw",
			{
				max = 0.75,
				min = 0.25
			}
		},
		{
			"moving",
			"offset",
			4,
			"yaw",
			{
				max = 0.75,
				min = 0.25
			}
		},
		{
			"moving",
			"offset_random_range",
			1,
			"pitch",
			{
				max = 0.95,
				min = 0
			}
		},
		{
			"moving",
			"offset_random_range",
			2,
			"pitch",
			{
				max = 0.9,
				min = 0.05
			}
		},
		{
			"moving",
			"offset_random_range",
			3,
			"pitch",
			{
				max = 0.8,
				min = 0.1
			}
		},
		{
			"moving",
			"offset_random_range",
			4,
			"pitch",
			{
				max = 0.75,
				min = 0.25
			}
		},
		{
			"moving",
			"offset_random_range",
			1,
			"yaw",
			{
				max = 0.95,
				min = 0
			}
		},
		{
			"moving",
			"offset_random_range",
			2,
			"yaw",
			{
				max = 0.9,
				min = 0.05
			}
		},
		{
			"moving",
			"offset_random_range",
			3,
			"yaw",
			{
				max = 0.8,
				min = 0.1
			}
		},
		{
			"moving",
			"offset_random_range",
			4,
			"yaw",
			{
				max = 0.75,
				min = 0.25
			}
		}
	},
	rippergun_p1_m1_recoil_stat = {
		{
			"still",
			"rise",
			1,
			{
				max = 1,
				min = 0
			}
		},
		{
			"still",
			"rise",
			2,
			{
				max = 0.75,
				min = 0.25
			}
		},
		{
			"still",
			"rise",
			3,
			{
				max = 0.75,
				min = 0.25
			}
		},
		{
			"still",
			"rise",
			4,
			{
				max = 0.75,
				min = 0.25
			}
		},
		{
			"still",
			"rise",
			5,
			{
				max = 0.75,
				min = 0.25
			}
		},
		{
			"still",
			"rise",
			6,
			{
				max = 0.75,
				min = 0.25
			}
		},
		{
			"still",
			"rise",
			7,
			{
				max = 0.75,
				min = 0.25
			}
		},
		{
			"still",
			"rise",
			8,
			{
				max = 0.75,
				min = 0.25
			}
		},
		{
			"still",
			"rise",
			9,
			{
				max = 0.75,
				min = 0.25
			}
		},
		{
			"still",
			"rise",
			10,
			{
				max = 0.75,
				min = 0.25
			}
		},
		{
			"still",
			"rise",
			11,
			{
				max = 0.75,
				min = 0.25
			}
		},
		{
			"still",
			"offset",
			1,
			"pitch",
			{
				max = 0.75,
				min = 0.25
			}
		},
		{
			"still",
			"offset",
			2,
			"pitch",
			{
				max = 0.75,
				min = 0.25
			}
		},
		{
			"still",
			"offset",
			3,
			"pitch",
			{
				max = 0.75,
				min = 0.25
			}
		},
		{
			"still",
			"offset",
			1,
			"yaw",
			{
				max = 0.75,
				min = 0.25
			}
		},
		{
			"still",
			"offset",
			2,
			"yaw",
			{
				max = 0.75,
				min = 0.25
			}
		},
		{
			"still",
			"offset",
			3,
			"yaw",
			{
				max = 0.75,
				min = 0.25
			}
		},
		{
			"moving",
			"offset",
			1,
			"pitch",
			{
				max = 0.75,
				min = 0.25
			}
		},
		{
			"moving",
			"offset",
			2,
			"pitch",
			{
				max = 0.75,
				min = 0.25
			}
		},
		{
			"moving",
			"offset",
			3,
			"pitch",
			{
				max = 0.75,
				min = 0.25
			}
		},
		{
			"moving",
			"offset",
			1,
			"yaw",
			{
				max = 0.75,
				min = 0.25
			}
		},
		{
			"moving",
			"offset",
			2,
			"yaw",
			{
				max = 0.75,
				min = 0.25
			}
		},
		{
			"moving",
			"offset",
			3,
			"yaw",
			{
				max = 0.75,
				min = 0.25
			}
		}
	},
	recoil_killshot_trait_01_a = {
		{
			"still",
			"offset",
			1,
			"pitch",
			1
		},
		{
			"still",
			"offset",
			2,
			"pitch",
			0.75
		},
		{
			"still",
			"offset",
			3,
			"pitch",
			0.5
		},
		{
			"still",
			"offset",
			4,
			"pitch",
			0.25
		},
		{
			"still",
			"offset",
			1,
			"yaw",
			1
		},
		{
			"still",
			"offset",
			2,
			"yaw",
			0.75
		},
		{
			"still",
			"offset",
			3,
			"yaw",
			0.5
		},
		{
			"still",
			"offset",
			4,
			"yaw",
			0.25
		},
		{
			"moving",
			"offset",
			1,
			"pitch",
			0.5
		},
		{
			"moving",
			"offset",
			2,
			"pitch",
			0.375
		},
		{
			"moving",
			"offset",
			3,
			"pitch",
			0.25
		},
		{
			"moving",
			"offset",
			4,
			"pitch",
			0.125
		},
		{
			"moving",
			"offset",
			1,
			"yaw",
			0.5
		},
		{
			"moving",
			"offset",
			2,
			"yaw",
			0.375
		},
		{
			"moving",
			"offset",
			3,
			"yaw",
			0.25
		},
		{
			"moving",
			"offset",
			4,
			"yaw",
			0.125
		},
		[DEFAULT_LERP_VALUE] = 0.1
	},
	recoil_killshot_trait_01_b = {
		{
			"still",
			"offset",
			1,
			"pitch",
			1
		},
		{
			"still",
			"offset",
			2,
			"pitch",
			0.75
		},
		{
			"still",
			"offset",
			3,
			"pitch",
			0.5
		},
		{
			"still",
			"offset",
			4,
			"pitch",
			0.25
		},
		{
			"still",
			"offset",
			1,
			"yaw",
			1
		},
		{
			"still",
			"offset",
			2,
			"yaw",
			0.75
		},
		{
			"still",
			"offset",
			3,
			"yaw",
			0.5
		},
		{
			"still",
			"offset",
			4,
			"yaw",
			0.25
		},
		{
			"moving",
			"offset",
			1,
			"pitch",
			0.5
		},
		{
			"moving",
			"offset",
			2,
			"pitch",
			0.375
		},
		{
			"moving",
			"offset",
			3,
			"pitch",
			0.25
		},
		{
			"moving",
			"offset",
			4,
			"pitch",
			0.125
		},
		{
			"moving",
			"offset",
			1,
			"yaw",
			0.5
		},
		{
			"moving",
			"offset",
			2,
			"yaw",
			0.375
		},
		{
			"moving",
			"offset",
			3,
			"yaw",
			0.25
		},
		{
			"moving",
			"offset",
			4,
			"yaw",
			0.125
		},
		[DEFAULT_LERP_VALUE] = 0.2
	},
	recoil_killshot_trait_01_c = {
		{
			"still",
			"offset",
			1,
			"pitch",
			1
		},
		{
			"still",
			"offset",
			2,
			"pitch",
			0.75
		},
		{
			"still",
			"offset",
			3,
			"pitch",
			0.5
		},
		{
			"still",
			"offset",
			4,
			"pitch",
			0.25
		},
		{
			"still",
			"offset",
			1,
			"yaw",
			1
		},
		{
			"still",
			"offset",
			2,
			"yaw",
			0.75
		},
		{
			"still",
			"offset",
			3,
			"yaw",
			0.5
		},
		{
			"still",
			"offset",
			4,
			"yaw",
			0.25
		},
		{
			"moving",
			"offset",
			1,
			"pitch",
			0.5
		},
		{
			"moving",
			"offset",
			2,
			"pitch",
			0.375
		},
		{
			"moving",
			"offset",
			3,
			"pitch",
			0.25
		},
		{
			"moving",
			"offset",
			4,
			"pitch",
			0.125
		},
		{
			"moving",
			"offset",
			1,
			"yaw",
			0.5
		},
		{
			"moving",
			"offset",
			2,
			"yaw",
			0.375
		},
		{
			"moving",
			"offset",
			3,
			"yaw",
			0.25
		},
		{
			"moving",
			"offset",
			4,
			"yaw",
			0.125
		},
		[DEFAULT_LERP_VALUE] = 0.3
	},
	recoil_killshot_trait_02_a = {
		{
			"still",
			"offset_random_range",
			1,
			"pitch",
			1
		},
		{
			"still",
			"offset_random_range",
			2,
			"pitch",
			0.75
		},
		{
			"still",
			"offset_random_range",
			3,
			"pitch",
			0.5
		},
		{
			"still",
			"offset_random_range",
			4,
			"pitch",
			0.25
		},
		{
			"still",
			"offset_random_range",
			1,
			"yaw",
			1
		},
		{
			"still",
			"offset_random_range",
			2,
			"yaw",
			0.75
		},
		{
			"still",
			"offset_random_range",
			3,
			"yaw",
			0.5
		},
		{
			"still",
			"offset_random_range",
			4,
			"yaw",
			0.25
		},
		{
			"moving",
			"offset_random_range",
			1,
			"pitch",
			0.5
		},
		{
			"moving",
			"offset_random_range",
			2,
			"pitch",
			0.30000000000000004
		},
		{
			"moving",
			"offset_random_range",
			3,
			"pitch",
			0.125
		},
		{
			"moving",
			"offset_random_range",
			4,
			"pitch",
			0.0625
		},
		{
			"moving",
			"offset_random_range",
			1,
			"yaw",
			0.5
		},
		{
			"moving",
			"offset_random_range",
			2,
			"yaw",
			0.30000000000000004
		},
		{
			"moving",
			"offset_random_range",
			3,
			"yaw",
			0.125
		},
		{
			"moving",
			"offset_random_range",
			4,
			"yaw",
			0.0625
		},
		[DEFAULT_LERP_VALUE] = 0.1
	},
	recoil_killshot_trait_02_b = {
		{
			"still",
			"offset_random_range",
			1,
			"pitch",
			1
		},
		{
			"still",
			"offset_random_range",
			2,
			"pitch",
			0.75
		},
		{
			"still",
			"offset_random_range",
			3,
			"pitch",
			0.5
		},
		{
			"still",
			"offset_random_range",
			4,
			"pitch",
			0.25
		},
		{
			"still",
			"offset_random_range",
			1,
			"yaw",
			1
		},
		{
			"still",
			"offset_random_range",
			2,
			"yaw",
			0.75
		},
		{
			"still",
			"offset_random_range",
			3,
			"yaw",
			0.5
		},
		{
			"still",
			"offset_random_range",
			4,
			"yaw",
			0.25
		},
		{
			"moving",
			"offset_random_range",
			1,
			"pitch",
			0.5
		},
		{
			"moving",
			"offset_random_range",
			2,
			"pitch",
			0.30000000000000004
		},
		{
			"moving",
			"offset_random_range",
			3,
			"pitch",
			0.125
		},
		{
			"moving",
			"offset_random_range",
			4,
			"pitch",
			0.0625
		},
		{
			"moving",
			"offset_random_range",
			1,
			"yaw",
			0.5
		},
		{
			"moving",
			"offset_random_range",
			2,
			"yaw",
			0.30000000000000004
		},
		{
			"moving",
			"offset_random_range",
			3,
			"yaw",
			0.125
		},
		{
			"moving",
			"offset_random_range",
			4,
			"yaw",
			0.0625
		},
		[DEFAULT_LERP_VALUE] = 0.2
	},
	recoil_killshot_trait_02_c = {
		{
			"still",
			"offset_random_range",
			1,
			"pitch",
			1
		},
		{
			"still",
			"offset_random_range",
			2,
			"pitch",
			0.75
		},
		{
			"still",
			"offset_random_range",
			3,
			"pitch",
			0.5
		},
		{
			"still",
			"offset_random_range",
			4,
			"pitch",
			0.25
		},
		{
			"still",
			"offset_random_range",
			1,
			"yaw",
			1
		},
		{
			"still",
			"offset_random_range",
			2,
			"yaw",
			0.75
		},
		{
			"still",
			"offset_random_range",
			3,
			"yaw",
			0.5
		},
		{
			"still",
			"offset_random_range",
			4,
			"yaw",
			0.25
		},
		{
			"moving",
			"offset_random_range",
			1,
			"pitch",
			0.5
		},
		{
			"moving",
			"offset_random_range",
			2,
			"pitch",
			0.30000000000000004
		},
		{
			"moving",
			"offset_random_range",
			3,
			"pitch",
			0.125
		},
		{
			"moving",
			"offset_random_range",
			4,
			"pitch",
			0.0625
		},
		{
			"moving",
			"offset_random_range",
			1,
			"yaw",
			0.5
		},
		{
			"moving",
			"offset_random_range",
			2,
			"yaw",
			0.30000000000000004
		},
		{
			"moving",
			"offset_random_range",
			3,
			"yaw",
			0.125
		},
		{
			"moving",
			"offset_random_range",
			4,
			"yaw",
			0.0625
		},
		[DEFAULT_LERP_VALUE] = 0.3
	},
	recoil_spraynpray_trait_01_a = {
		{
			"still",
			"offset",
			1,
			"pitch",
			0.75
		},
		{
			"still",
			"offset",
			2,
			"pitch",
			0.7
		},
		{
			"still",
			"offset",
			3,
			"pitch",
			0.65
		},
		{
			"still",
			"offset",
			4,
			"pitch",
			0.6
		},
		{
			"still",
			"offset",
			5,
			"pitch",
			0.55
		},
		{
			"still",
			"offset",
			6,
			"pitch",
			0.5
		},
		{
			"still",
			"offset",
			7,
			"pitch",
			0.45
		},
		{
			"still",
			"offset",
			8,
			"pitch",
			0.4
		},
		{
			"still",
			"offset",
			9,
			"pitch",
			0.35
		},
		{
			"still",
			"offset",
			10,
			"pitch",
			0.3
		},
		{
			"still",
			"offset",
			1,
			"yaw",
			0.75
		},
		{
			"still",
			"offset",
			2,
			"yaw",
			0.7
		},
		{
			"still",
			"offset",
			3,
			"yaw",
			0.65
		},
		{
			"still",
			"offset",
			4,
			"yaw",
			0.6
		},
		{
			"still",
			"offset",
			5,
			"yaw",
			0.55
		},
		{
			"still",
			"offset",
			6,
			"yaw",
			0.5
		},
		{
			"still",
			"offset",
			7,
			"yaw",
			0.45
		},
		{
			"still",
			"offset",
			8,
			"yaw",
			0.4
		},
		{
			"still",
			"offset",
			9,
			"yaw",
			0.35
		},
		{
			"still",
			"offset",
			10,
			"yaw",
			0.35
		},
		[DEFAULT_LERP_VALUE] = 0.1
	},
	recoil_spraynpray_trait_01_b = {
		{
			"still",
			"offset",
			1,
			"pitch",
			0.75
		},
		{
			"still",
			"offset",
			2,
			"pitch",
			0.7
		},
		{
			"still",
			"offset",
			3,
			"pitch",
			0.65
		},
		{
			"still",
			"offset",
			4,
			"pitch",
			0.6
		},
		{
			"still",
			"offset",
			5,
			"pitch",
			0.55
		},
		{
			"still",
			"offset",
			6,
			"pitch",
			0.5
		},
		{
			"still",
			"offset",
			7,
			"pitch",
			0.45
		},
		{
			"still",
			"offset",
			8,
			"pitch",
			0.4
		},
		{
			"still",
			"offset",
			9,
			"pitch",
			0.35
		},
		{
			"still",
			"offset",
			10,
			"pitch",
			0.3
		},
		{
			"still",
			"offset",
			1,
			"yaw",
			0.75
		},
		{
			"still",
			"offset",
			2,
			"yaw",
			0.7
		},
		{
			"still",
			"offset",
			3,
			"yaw",
			0.65
		},
		{
			"still",
			"offset",
			4,
			"yaw",
			0.6
		},
		{
			"still",
			"offset",
			5,
			"yaw",
			0.55
		},
		{
			"still",
			"offset",
			6,
			"yaw",
			0.5
		},
		{
			"still",
			"offset",
			7,
			"yaw",
			0.45
		},
		{
			"still",
			"offset",
			8,
			"yaw",
			0.4
		},
		{
			"still",
			"offset",
			9,
			"yaw",
			0.35
		},
		{
			"still",
			"offset",
			10,
			"yaw",
			0.35
		},
		[DEFAULT_LERP_VALUE] = 0.2
	},
	recoil_spraynpray_trait_01_c = {
		{
			"still",
			"offset",
			1,
			"pitch",
			0.75
		},
		{
			"still",
			"offset",
			2,
			"pitch",
			0.7
		},
		{
			"still",
			"offset",
			3,
			"pitch",
			0.65
		},
		{
			"still",
			"offset",
			4,
			"pitch",
			0.6
		},
		{
			"still",
			"offset",
			5,
			"pitch",
			0.55
		},
		{
			"still",
			"offset",
			6,
			"pitch",
			0.5
		},
		{
			"still",
			"offset",
			7,
			"pitch",
			0.45
		},
		{
			"still",
			"offset",
			8,
			"pitch",
			0.4
		},
		{
			"still",
			"offset",
			9,
			"pitch",
			0.35
		},
		{
			"still",
			"offset",
			10,
			"pitch",
			0.3
		},
		{
			"still",
			"offset",
			1,
			"yaw",
			0.75
		},
		{
			"still",
			"offset",
			2,
			"yaw",
			0.7
		},
		{
			"still",
			"offset",
			3,
			"yaw",
			0.65
		},
		{
			"still",
			"offset",
			4,
			"yaw",
			0.6
		},
		{
			"still",
			"offset",
			5,
			"yaw",
			0.55
		},
		{
			"still",
			"offset",
			6,
			"yaw",
			0.5
		},
		{
			"still",
			"offset",
			7,
			"yaw",
			0.45
		},
		{
			"still",
			"offset",
			8,
			"yaw",
			0.4
		},
		{
			"still",
			"offset",
			9,
			"yaw",
			0.35
		},
		{
			"still",
			"offset",
			10,
			"yaw",
			0.35
		},
		[DEFAULT_LERP_VALUE] = 0.3
	},
	recoil_assault_trait_01_a = {
		{
			ALL_WEAPON_MOVEMENT_STATES,
			"offset",
			1,
			"pitch",
			0.75
		},
		{
			ALL_WEAPON_MOVEMENT_STATES,
			"offset",
			2,
			"pitch",
			0.5625
		},
		{
			ALL_WEAPON_MOVEMENT_STATES,
			"offset",
			3,
			"pitch",
			0.375
		},
		{
			ALL_WEAPON_MOVEMENT_STATES,
			"offset",
			4,
			"pitch",
			0.1875
		},
		{
			ALL_WEAPON_MOVEMENT_STATES,
			"offset",
			1,
			"yaw",
			0.75
		},
		{
			ALL_WEAPON_MOVEMENT_STATES,
			"offset",
			2,
			"yaw",
			0.5625
		},
		{
			ALL_WEAPON_MOVEMENT_STATES,
			"offset",
			3,
			"yaw",
			0.375
		},
		{
			ALL_WEAPON_MOVEMENT_STATES,
			"offset",
			4,
			"yaw",
			0.1875
		},
		[DEFAULT_LERP_VALUE] = 0.1
	},
	recoil_assault_trait_01_b = {
		{
			ALL_WEAPON_MOVEMENT_STATES,
			"offset",
			1,
			"pitch",
			0.75
		},
		{
			ALL_WEAPON_MOVEMENT_STATES,
			"offset",
			2,
			"pitch",
			0.5625
		},
		{
			ALL_WEAPON_MOVEMENT_STATES,
			"offset",
			3,
			"pitch",
			0.375
		},
		{
			ALL_WEAPON_MOVEMENT_STATES,
			"offset",
			4,
			"pitch",
			0.1875
		},
		{
			ALL_WEAPON_MOVEMENT_STATES,
			"offset",
			1,
			"yaw",
			0.75
		},
		{
			ALL_WEAPON_MOVEMENT_STATES,
			"offset",
			2,
			"yaw",
			0.5625
		},
		{
			ALL_WEAPON_MOVEMENT_STATES,
			"offset",
			3,
			"yaw",
			0.375
		},
		{
			ALL_WEAPON_MOVEMENT_STATES,
			"offset",
			4,
			"yaw",
			0.1875
		},
		[DEFAULT_LERP_VALUE] = 0.2
	},
	recoil_assault_trait_01_c = {
		{
			ALL_WEAPON_MOVEMENT_STATES,
			"offset",
			1,
			"pitch",
			0.75
		},
		{
			ALL_WEAPON_MOVEMENT_STATES,
			"offset",
			2,
			"pitch",
			0.5625
		},
		{
			ALL_WEAPON_MOVEMENT_STATES,
			"offset",
			3,
			"pitch",
			0.375
		},
		{
			ALL_WEAPON_MOVEMENT_STATES,
			"offset",
			4,
			"pitch",
			0.1875
		},
		{
			ALL_WEAPON_MOVEMENT_STATES,
			"offset",
			1,
			"yaw",
			0.75
		},
		{
			ALL_WEAPON_MOVEMENT_STATES,
			"offset",
			2,
			"yaw",
			0.5625
		},
		{
			ALL_WEAPON_MOVEMENT_STATES,
			"offset",
			3,
			"yaw",
			0.375
		},
		{
			ALL_WEAPON_MOVEMENT_STATES,
			"offset",
			4,
			"yaw",
			0.1875
		},
		[DEFAULT_LERP_VALUE] = 0.3
	},
	stubrevolver_recoil_stat = {
		{
			"still",
			"offset",
			1,
			"pitch",
			{
				max = 0.75,
				min = 0.25
			}
		},
		{
			"still",
			"offset",
			2,
			"pitch",
			{
				max = 0.75,
				min = 0.25
			}
		},
		{
			"still",
			"offset",
			1,
			"yaw",
			{
				max = 0.75,
				min = 0.25
			}
		},
		{
			"still",
			"offset",
			2,
			"yaw",
			{
				max = 0.75,
				min = 0.25
			}
		},
		{
			"moving",
			"offset",
			1,
			"pitch",
			{
				max = 0.75,
				min = 0.25
			}
		},
		{
			"moving",
			"offset",
			2,
			"pitch",
			{
				max = 0.75,
				min = 0.25
			}
		},
		{
			"moving",
			"offset",
			1,
			"yaw",
			{
				max = 0.75,
				min = 0.25
			}
		},
		{
			"moving",
			"offset",
			2,
			"yaw",
			{
				max = 0.75,
				min = 0.25
			}
		}
	}
}

return recoil_trait_templates
