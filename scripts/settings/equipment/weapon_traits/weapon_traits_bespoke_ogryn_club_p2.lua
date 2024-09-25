﻿-- chunkname: @scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_ogryn_club_p2.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local stat_buffs = BuffSettings.stat_buffs
local templates = {}

table.make_unique(templates)

templates.weapon_trait_bespoke_ogryn_club_p2_pass_past_armor_on_crit = {
	buffs = {
		weapon_trait_bespoke_ogryn_club_p2_pass_past_armor_on_crit = {
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
templates.weapon_trait_bespoke_ogryn_club_p2_windup_increases_power = {
	buffs = {
		weapon_trait_bespoke_ogryn_club_p2_windup_increases_power_parent = {
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
templates.weapon_trait_bespoke_ogryn_club_p2_targets_receive_rending_debuff = {
	buffs = {
		weapon_trait_bespoke_ogryn_club_p2_targets_receive_rending_debuff = {
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
templates.weapon_trait_bespoke_ogryn_club_p2_toughness_recovery_on_multiple_hits = {
	buffs = {
		weapon_trait_bespoke_ogryn_club_p2_toughness_recovery_on_multiple_hits = {
			{
				buff_data = {
					replenish_percentage = 0.12,
					required_num_hits = 3,
				},
			},
			{
				buff_data = {
					replenish_percentage = 0.13,
					required_num_hits = 3,
				},
			},
			{
				buff_data = {
					replenish_percentage = 0.14,
					required_num_hits = 3,
				},
			},
			{
				buff_data = {
					replenish_percentage = 0.15,
					required_num_hits = 3,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_ogryn_club_p2_toughness_recovery_on_chained_attacks = {
	buffs = {
		weapon_trait_bespoke_ogryn_club_p2_toughness_recovery_on_chained_attacks = {
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
templates.weapon_trait_bespoke_ogryn_club_p2_staggered_targets_receive_increased_damage_debuff = {
	buffs = {
		weapon_trait_bespoke_ogryn_club_p2_staggered_targets_receive_increased_damage_debuff = {
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
templates.weapon_trait_bespoke_ogryn_club_p2_heavy_chained_hits_increases_killing_blow_chance = {
	buffs = {
		weapon_trait_bespoke_ogryn_club_p2_heavy_chained_hits_increases_killing_blow_chance_parent = {
			{
				target_buff_data = {
					killing_blow_chance = 0.01,
				},
			},
			{
				target_buff_data = {
					killing_blow_chance = 0.02,
				},
			},
			{
				target_buff_data = {
					killing_blow_chance = 0.03,
				},
			},
			{
				target_buff_data = {
					killing_blow_chance = 0.04,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_ogryn_club_p2_increased_crit_chance_on_staggered_weapon_special_hit = {
	buffs = {
		weapon_trait_bespoke_ogryn_club_p2_increased_crit_chance_on_staggered_weapon_special_hit_parent = {
			{
				stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.125,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.15,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.175,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.2,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_ogryn_club_p2_toughness_regen_on_weapon_special_elites = {
	buffs = {
		weapon_trait_bespoke_ogryn_club_p2_toughness_regen_on_weapon_special_elites = {
			{
				active_duration = 2,
				proc_stat_buffs = {
					[stat_buffs.toughness_extra_regen_rate] = 0.5,
				},
			},
			{
				active_duration = 3,
				proc_stat_buffs = {
					[stat_buffs.toughness_extra_regen_rate] = 0.5,
				},
			},
			{
				active_duration = 4,
				proc_stat_buffs = {
					[stat_buffs.toughness_extra_regen_rate] = 0.5,
				},
			},
			{
				active_duration = 5,
				proc_stat_buffs = {
					[stat_buffs.toughness_extra_regen_rate] = 0.5,
				},
			},
		},
	},
}

return templates
