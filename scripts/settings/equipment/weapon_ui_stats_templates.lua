-- chunkname: @scripts/settings/equipment/weapon_ui_stats_templates.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
local WeaponUIStatsDamageSettings = require("scripts/settings/equipment/weapon_ui_stats_damage_settings")
local template_types = WeaponTweakTemplateSettings.template_types
local DAMAGE_ALL = WeaponUIStatsDamageSettings.DAMAGE_ALL
local DAMAGE_NONE = WeaponUIStatsDamageSettings.DAMAGE_NONE
local default_attack_settings = {
	ArmorSettings.types.unarmored,
	DAMAGE_ALL,
	DAMAGE_ALL,
	ArmorSettings.types.disgustingly_resilient,
	DAMAGE_ALL,
	DAMAGE_ALL,
	ArmorSettings.types.armored,
	DAMAGE_ALL,
	DAMAGE_ALL,
	ArmorSettings.types.resistant,
	DAMAGE_ALL,
	DAMAGE_ALL,
	ArmorSettings.types.super_armor,
	DAMAGE_ALL,
	DAMAGE_ALL,
	ArmorSettings.types.berserker,
	DAMAGE_ALL,
	DAMAGE_ALL
}
local default_stats = {
	{
		"diminishing_return_start",
		target = "base",
		ui_identifier = "effective_dodges",
		template_type = template_types.dodge
	},
	{
		"distance_scale",
		target = "base",
		ui_identifier = "dodge_distance",
		template_type = template_types.dodge
	},
	{
		"sprint_speed_mod",
		target = "base",
		ui_identifier = "sprint_speed",
		template_type = template_types.sprint
	},
	{
		"stamina_modifier",
		target = "base",
		ui_identifier = "stamina",
		template_type = template_types.stamina
	},
	{
		"sprint_cost_per_second",
		target = "base",
		ui_identifier = "sprint_cost",
		template_type = template_types.stamina
	},
	{
		"ammunition_clip",
		target = "base",
		ui_identifier = "ammo_clip",
		template_type = template_types.ammo
	},
	{
		"ammunition_reserve",
		target = "base",
		ui_identifier = "ammo_reserve",
		template_type = template_types.ammo
	},
	{
		"block_cost_melee",
		"inner",
		target = "base",
		template_type = template_types.stamina
	},
	{
		"block_cost_ranged",
		"inner",
		target = "base",
		template_type = template_types.stamina
	},
	{
		"block_cost_default",
		"inner",
		target = "base",
		template_type = template_types.stamina
	},
	{
		"block_cost_melee",
		"outer",
		target = "base",
		template_type = template_types.stamina
	},
	{
		"block_cost_ranged",
		"outer",
		target = "base",
		template_type = template_types.stamina
	},
	{
		"block_cost_default",
		"outer",
		target = "base",
		template_type = template_types.stamina
	},
	{
		"modifier",
		target = "base",
		template_type = template_types.movement_curve_modifier
	}
}
local WeaponUIStatsTemplates = {
	settings = {
		default_attack_settings = default_attack_settings,
		default_stats = default_stats,
		default_ranged_damage_profile_stats = {},
		default_ranged_per_action_stats = {}
	},
	plasmagun_p1_m1 = {
		stats = default_stats,
		power_stats = {
			{
				charge_level = 0.516133333,
				display_name = "loc_weapon_action_title_primary",
				dropoff_scalar = 0,
				action_name = "action_shoot",
				target_index = 1
			},
			{
				charge_level = 1,
				display_name = "loc_weapon_keyword_charged_attack",
				dropoff_scalar = 0,
				action_name = "action_shoot_charged",
				target_index = 1
			}
		},
		damage = {
			{
				{
					display_name = "action_shoot",
					dropoff_scalar = 0,
					charge_level = 0.516133333,
					action_name = "action_shoot",
					target_index = 1,
					attack = default_attack_settings,
					damage_profile_stats = {},
					per_action_stats = {}
				}
			},
			{
				{
					display_name = "action_shoot_charged",
					dropoff_scalar = 0,
					charge_level = 1,
					action_name = "action_shoot_charged",
					target_index = 1,
					attack = default_attack_settings,
					damage_profile_stats = {},
					per_action_stats = {}
				}
			}
		}
	},
	lasgun_p2 = {
		stats = default_stats,
		power_stats = {
			{
				charge_level = 0,
				display_name = "loc_weapon_action_title_primary",
				dropoff_scalar = 1,
				action_name = "action_shoot_hip_charged",
				target_index = 1
			},
			{
				charge_level = 1,
				display_name = "loc_weapon_keyword_charged_attack",
				dropoff_scalar = 1,
				action_name = "action_zoom_shoot_charged",
				target_index = 1
			}
		},
		damage = {
			{
				{
					display_name = "action_shoot_hip_charged",
					dropoff_scalar = 1,
					charge_level = 0,
					action_name = "action_shoot_hip_charged",
					target_index = 1,
					attack = default_attack_settings,
					damage_profile_stats = {},
					per_action_stats = {}
				}
			},
			{
				{
					display_name = "action_zoom_shoot_charged",
					dropoff_scalar = 1,
					charge_level = 1,
					action_name = "action_zoom_shoot_charged",
					target_index = 1,
					attack = default_attack_settings,
					damage_profile_stats = {},
					per_action_stats = {}
				}
			},
			{
				{
					display_name = "action_stab",
					dropoff_scalar = 1,
					charge_level = 1,
					action_name = "action_stab",
					target_index = 1,
					attack = default_attack_settings,
					damage_profile_stats = {},
					per_action_stats = {}
				}
			}
		}
	},
	lasgun_p2_m3 = {
		stats = default_stats,
		power_stats = {
			{
				charge_level = 0,
				display_name = "loc_weapon_action_title_primary",
				dropoff_scalar = 1,
				action_name = "action_shoot_hip_charged",
				target_index = 1
			},
			{
				charge_level = 1,
				display_name = "loc_weapon_keyword_charged_attack",
				dropoff_scalar = 1,
				action_name = "action_zoom_shoot_charged",
				target_index = 1
			}
		},
		damage = {
			{
				{
					display_name = "action_shoot_hip_charged",
					dropoff_scalar = 1,
					charge_level = 0,
					action_name = "action_shoot_hip_charged",
					target_index = 1,
					attack = default_attack_settings,
					damage_profile_stats = {},
					per_action_stats = {}
				}
			},
			{
				{
					display_name = "action_zoom_shoot_charged",
					dropoff_scalar = 1,
					charge_level = 1,
					action_name = "action_zoom_shoot_charged",
					target_index = 1,
					attack = default_attack_settings,
					damage_profile_stats = {},
					per_action_stats = {}
				}
			},
			{
				{
					display_name = "action_slash",
					dropoff_scalar = 1,
					charge_level = 1,
					action_name = "action_slash",
					target_index = 1,
					attack = default_attack_settings,
					damage_profile_stats = {},
					per_action_stats = {}
				}
			}
		}
	},
	ogryn_gauntlet = {
		stats = default_stats,
		power_stats = {
			{
				charge_level = 1,
				display_name = "loc_weapon_action_title_light",
				dropoff_scalar = 1,
				action_name = "action_swing",
				target_index = 1
			},
			{
				charge_level = 1,
				display_name = "loc_weapon_action_title_heavy",
				dropoff_scalar = 1,
				action_name = "action_left_heavy",
				target_index = 1
			}
		},
		damage = {
			{
				{
					display_name = "action_swing",
					dropoff_scalar = 1,
					charge_level = 1,
					action_name = "action_swing",
					target_index = 1,
					attack = default_attack_settings,
					damage_profile_stats = {},
					per_action_stats = {}
				},
				{
					display_name = "action_swing_right",
					dropoff_scalar = 1,
					charge_level = 1,
					action_name = "action_swing_right",
					target_index = 1,
					attack = default_attack_settings,
					damage_profile_stats = {},
					per_action_stats = {}
				},
				{
					display_name = "action_swing_up",
					dropoff_scalar = 1,
					charge_level = 1,
					action_name = "action_swing_up",
					target_index = 1,
					attack = default_attack_settings,
					damage_profile_stats = {},
					per_action_stats = {}
				}
			},
			{
				{
					display_name = "action_left_heavy",
					dropoff_scalar = 1,
					charge_level = 1,
					action_name = "action_left_heavy",
					target_index = 1,
					attack = default_attack_settings,
					damage_profile_stats = {},
					per_action_stats = {}
				},
				{
					display_name = "action_left_heavy_2",
					dropoff_scalar = 1,
					charge_level = 1,
					action_name = "action_left_heavy_2",
					target_index = 1,
					attack = default_attack_settings,
					damage_profile_stats = {},
					per_action_stats = {}
				}
			},
			{
				{
					display_name = "action_execute_special",
					dropoff_scalar = 1,
					charge_level = 1,
					action_name = "action_execute_special",
					target_index = 1,
					attack = default_attack_settings,
					damage_profile_stats = {},
					per_action_stats = {}
				}
			},
			{
				{
					display_name = "action_shoot_zoomed",
					dropoff_scalar = 1,
					charge_level = 1,
					action_name = "action_shoot_zoomed",
					target_index = 1,
					attack = default_attack_settings,
					damage_profile_stats = {},
					per_action_stats = {}
				}
			}
		}
	},
	ogryn_thumper_p1_m2 = {
		stats = default_stats,
		power_stats = {
			{
				charge_level = 1,
				display_name = "loc_weapon_action_title_primary",
				dropoff_scalar = 1,
				action_name = "action_shoot_hip",
				target_index = 1
			},
			{
				charge_level = 1,
				display_name = "loc_weapon_action_title_secondary",
				dropoff_scalar = 1,
				action_name = "action_shoot_zoomed",
				target_index = 1
			}
		},
		damage = {
			{
				{
					display_name = "action_shoot_hip",
					dropoff_scalar = 1,
					charge_level = 1,
					action_name = "action_shoot_hip",
					target_index = 1,
					attack = default_attack_settings,
					damage_profile_stats = {},
					per_action_stats = {}
				}
			},
			{
				{
					display_name = "action_shoot_zoomed",
					dropoff_scalar = 1,
					charge_level = 1,
					action_name = "action_shoot_zoomed",
					target_index = 1,
					attack = default_attack_settings,
					damage_profile_stats = {},
					per_action_stats = {}
				}
			},
			{
				{
					display_name = "action_bash",
					dropoff_scalar = 1,
					charge_level = 1,
					action_name = "action_bash",
					target_index = 1,
					attack = default_attack_settings,
					damage_profile_stats = {},
					per_action_stats = {}
				}
			}
		}
	}
}

return WeaponUIStatsTemplates
