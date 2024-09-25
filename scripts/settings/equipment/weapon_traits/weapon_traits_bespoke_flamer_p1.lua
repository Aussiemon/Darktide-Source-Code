﻿-- chunkname: @scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_flamer_p1.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local templates = {}

table.make_unique(templates)

local stat_buffs = BuffSettings.stat_buffs
local proc_events = BuffSettings.proc_events

templates.weapon_trait_bespoke_flamer_p1_toughness_on_continuous_fire = {
	buffs = {
		weapon_trait_bespoke_flamer_p1_toughness_on_continuous_fire = {
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
templates.weapon_trait_bespoke_flamer_p1_power_bonus_on_continuous_fire = {
	buffs = {
		weapon_trait_bespoke_flamer_p1_power_bonus_on_continuous_fire = {
			{
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.05,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.06,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.07,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.08,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_flamer_p1_faster_reload_on_empty_clip = {
	buffs = {
		weapon_trait_bespoke_flamer_p1_faster_reload_on_empty_clip = {
			{
				stat_buffs = {
					[stat_buffs.reload_speed] = 0.24,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.reload_speed] = 0.28,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.reload_speed] = 0.32,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.reload_speed] = 0.36,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_flamer_p1_power_scales_with_clip_percentage = {
	buffs = {
		weapon_trait_bespoke_flamer_p1_power_scales_with_clip_percentage = {
			{
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.02,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.03,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.04,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.05,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_flamer_p1_negate_stagger_reduction_with_primary_on_burning = {
	buffs = {
		weapon_trait_bespoke_flamer_p1_negate_stagger_reduction_with_primary_on_burning = {
			{
				conditional_stat_buffs = {
					[stat_buffs.stagger_burning_reduction_modifier] = 0.6,
					[stat_buffs.ranged_impact_modifier] = 0.3,
				},
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.stagger_burning_reduction_modifier] = 0.5,
					[stat_buffs.ranged_impact_modifier] = 0.35,
				},
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.stagger_burning_reduction_modifier] = 0.4,
					[stat_buffs.ranged_impact_modifier] = 0.4,
				},
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.stagger_burning_reduction_modifier] = 0.3,
					[stat_buffs.ranged_impact_modifier] = 0.45,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_flamer_p1_chance_to_explode_elites_on_kill = {
	buffs = {
		weapon_trait_bespoke_flamer_p1_chance_to_explode_elites_on_kill = {
			{
				proc_events = {
					[proc_events.on_kill] = 0.14,
				},
			},
			{
				proc_events = {
					[proc_events.on_kill] = 0.16,
				},
			},
			{
				proc_events = {
					[proc_events.on_kill] = 0.18,
				},
			},
			{
				proc_events = {
					[proc_events.on_kill] = 0.2,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_flamer_p1_ammo_from_reserve_on_crit = {
	buffs = {
		weapon_trait_bespoke_flamer_p1_ammo_from_reserve_on_crit = {
			{
				num_ammmo_to_move = 2,
			},
			{
				num_ammmo_to_move = 3,
			},
			{
				num_ammmo_to_move = 4,
			},
			{
				num_ammmo_to_move = 5,
			},
		},
	},
}
templates.weapon_trait_bespoke_flamer_p1_burned_targets_receive_rending_debuff = {
	buffs = {
		weapon_trait_bespoke_flamer_p1_burned_targets_receive_rending_debuff = {
			{
				target_buff_data = {
					num_stacks_on_proc = 1,
				},
			},
			{
				target_buff_data = {
					num_stacks_on_proc = 2,
				},
			},
			{
				target_buff_data = {
					num_stacks_on_proc = 3,
				},
			},
			{
				target_buff_data = {
					num_stacks_on_proc = 4,
				},
			},
		},
	},
}

return templates
