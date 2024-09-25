﻿-- chunkname: @scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_autogun_p2.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local templates = {}

table.make_unique(templates)

local stat_buffs = BuffSettings.stat_buffs

templates.weapon_trait_bespoke_autogun_p2_increase_power_on_close_kill = {
	buffs = {
		weapon_trait_bespoke_autogun_p2_increase_power_on_close_kill_parent = {
			{
				child_duration = 3.5,
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.05,
				},
			},
			{
				child_duration = 3.5,
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.055,
				},
			},
			{
				child_duration = 3.5,
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.06,
				},
			},
			{
				child_duration = 3.5,
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.065,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_autogun_p2_increase_close_damage_on_close_kill = {
	buffs = {
		weapon_trait_bespoke_autogun_p2_increase_close_damage_on_close_kill_parent = {
			{
				child_duration = 3.5,
				stat_buffs = {
					[stat_buffs.damage_near] = 0.07,
				},
			},
			{
				child_duration = 3.5,
				stat_buffs = {
					[stat_buffs.damage_near] = 0.08,
				},
			},
			{
				child_duration = 3.5,
				stat_buffs = {
					[stat_buffs.damage_near] = 0.09,
				},
			},
			{
				child_duration = 3.5,
				stat_buffs = {
					[stat_buffs.damage_near] = 0.1,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_autogun_p2_count_as_dodge_vs_ranged_on_close_kill = {
	buffs = {
		weapon_trait_bespoke_autogun_p2_count_as_dodge_vs_ranged_on_close_kill = {
			{
				active_duration = 0.7,
			},
			{
				active_duration = 0.8,
			},
			{
				active_duration = 0.9,
			},
			{
				active_duration = 1,
			},
		},
	},
}
templates.weapon_trait_bespoke_autogun_p2_suppression_on_close_kill = {
	buffs = {
		weapon_trait_bespoke_autogun_p2_suppression_on_close_kill = {
			{
				suppression_settings = {
					distance = 12,
					instant_aggro = true,
					suppression_falloff = false,
					suppression_value = 15,
				},
			},
			{
				suppression_settings = {
					distance = 12,
					instant_aggro = true,
					suppression_falloff = false,
					suppression_value = 20,
				},
			},
			{
				suppression_settings = {
					distance = 12,
					instant_aggro = true,
					suppression_falloff = false,
					suppression_value = 25,
				},
			},
			{
				suppression_settings = {
					distance = 12,
					instant_aggro = true,
					suppression_falloff = false,
					suppression_value = 30,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_autogun_p2_reload_speed_on_slide = {
	buffs = {
		weapon_trait_bespoke_autogun_p2_reload_speed_on_slide_parent = {
			{
				child_duration = 2.5,
				stat_buffs = {
					[stat_buffs.reload_speed] = 0.07,
				},
			},
			{
				child_duration = 2.5,
				stat_buffs = {
					[stat_buffs.reload_speed] = 0.08,
				},
			},
			{
				child_duration = 2.5,
				stat_buffs = {
					[stat_buffs.reload_speed] = 0.09,
				},
			},
			{
				child_duration = 2.5,
				stat_buffs = {
					[stat_buffs.reload_speed] = 0.1,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_autogun_p2_increased_sprint_speed = {
	buffs = {
		weapon_trait_bespoke_autogun_p2_increased_sprint_speed = {
			{
				conditional_threshold = 0.8,
			},
			{
				conditional_threshold = 0.7,
			},
			{
				conditional_threshold = 0.6,
			},
			{
				conditional_threshold = 0.5,
			},
		},
	},
}
templates.weapon_trait_bespoke_autogun_p2_increased_suppression_on_continuous_fire = {
	buffs = {
		weapon_trait_bespoke_autogun_p2_increased_suppression_on_continuous_fire = {
			{
				stat_buffs = {
					[stat_buffs.suppression_dealt] = 0.2,
					[stat_buffs.damage_vs_suppressed] = 0.06,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.suppression_dealt] = 0.2,
					[stat_buffs.damage_vs_suppressed] = 0.06,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.suppression_dealt] = 0.2,
					[stat_buffs.damage_vs_suppressed] = 0.06,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.suppression_dealt] = 0.2,
					[stat_buffs.damage_vs_suppressed] = 0.06,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_autogun_p2_movement_speed_on_continous_fire = {
	buffs = {
		weapon_trait_bespoke_autogun_p2_movement_speed_on_continous_fire = {
			{
				stat_buffs = {
					[stat_buffs.alternate_fire_movement_speed_reduction_modifier] = 0.9,
					[stat_buffs.weapon_action_movespeed_reduction_multiplier] = 0.9,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.alternate_fire_movement_speed_reduction_modifier] = 0.85,
					[stat_buffs.weapon_action_movespeed_reduction_multiplier] = 0.85,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.alternate_fire_movement_speed_reduction_modifier] = 0.8,
					[stat_buffs.weapon_action_movespeed_reduction_multiplier] = 0.8,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.alternate_fire_movement_speed_reduction_modifier] = 0.75,
					[stat_buffs.weapon_action_movespeed_reduction_multiplier] = 0.75,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_autogun_p2_toughness_on_continuous_fire = {
	buffs = {
		weapon_trait_bespoke_autogun_p2_toughness_on_continuous_fire = {
			{
				toughness_fixed_percentage = 0.01,
			},
			{
				toughness_fixed_percentage = 0.02,
			},
			{
				toughness_fixed_percentage = 0.03,
			},
			{
				toughness_fixed_percentage = 0.04,
			},
		},
	},
}

return templates
