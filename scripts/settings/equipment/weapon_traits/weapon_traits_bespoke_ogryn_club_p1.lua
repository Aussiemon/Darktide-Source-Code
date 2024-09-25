﻿-- chunkname: @scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_ogryn_club_p1.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local stat_buffs = BuffSettings.stat_buffs
local templates = {}

table.make_unique(templates)

templates.weapon_trait_bespoke_ogryn_club_p1_windup_increases_power = {
	buffs = {
		weapon_trait_bespoke_ogryn_club_p1_windup_increases_power_parent = {
			{
				stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.05,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.1,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.15,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.2,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_ogryn_club_p1_toughness_recovery_on_chained_attacks = {
	buffs = {
		weapon_trait_bespoke_ogryn_club_p1_toughness_recovery_on_chained_attacks = {
			{
				toughness_fixed_percentage = 0.05,
			},
			{
				toughness_fixed_percentage = 0.06,
			},
			{
				toughness_fixed_percentage = 0.07,
			},
			{
				toughness_fixed_percentage = 0.08,
			},
		},
	},
}
templates.weapon_trait_bespoke_ogryn_club_p1_targets_receive_rending_debuff = {
	buffs = {
		weapon_trait_bespoke_ogryn_club_p1_targets_receive_rending_debuff = {
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
templates.weapon_trait_bespoke_ogryn_club_p1_infinite_melee_cleave_on_weakspot_kill = {
	buffs = {
		weapon_trait_bespoke_ogryn_club_p1_infinite_melee_cleave_on_weakspot_kill = {
			{
				stat_buffs = {
					[stat_buffs.melee_weakspot_damage] = 0.075,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.melee_weakspot_damage] = 0.1,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.melee_weakspot_damage] = 0.125,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.melee_weakspot_damage] = 0.15,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_ogryn_club_p1_staggered_targets_receive_increased_damage_debuff = {
	buffs = {
		weapon_trait_bespoke_ogryn_club_p1_staggered_targets_receive_increased_damage_debuff = {
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
templates.weapon_trait_bespoke_ogryn_club_p1_pass_past_armor_on_crit = {
	buffs = {
		weapon_trait_bespoke_ogryn_club_p1_pass_past_armor_on_crit = {
			{
				conditional_stat_buffs = {
					[stat_buffs.melee_critical_strike_damage] = 0.025,
				},
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.melee_critical_strike_damage] = 0.05,
				},
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.melee_critical_strike_damage] = 0.075,
				},
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.melee_critical_strike_damage] = 0.1,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_ogryn_club_p1_rending_vs_staggered = {
	buffs = {
		weapon_trait_bespoke_ogryn_club_p1_rending_vs_staggered = {
			{
				conditional_stat_buffs = {
					[stat_buffs.rending_vs_staggered_multiplier] = 0.1,
				},
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.rending_vs_staggered_multiplier] = 0.15,
				},
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.rending_vs_staggered_multiplier] = 0.2,
				},
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.rending_vs_staggered_multiplier] = 0.25,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_ogryn_club_p1_increased_crit_chance_on_weapon_special_hit = {
	buffs = {
		weapon_trait_bespoke_ogryn_club_p1_increased_crit_chance_on_weapon_special_hit = {
			{
				active_duration = 3,
				proc_stat_buffs = {
					[stat_buffs.melee_critical_strike_chance] = 0.075,
				},
			},
			{
				active_duration = 3,
				proc_stat_buffs = {
					[stat_buffs.melee_critical_strike_chance] = 0.1,
				},
			},
			{
				active_duration = 3,
				proc_stat_buffs = {
					[stat_buffs.melee_critical_strike_chance] = 0.125,
				},
			},
			{
				active_duration = 3,
				proc_stat_buffs = {
					[stat_buffs.melee_critical_strike_chance] = 0.15,
				},
			},
		},
	},
}

return templates
