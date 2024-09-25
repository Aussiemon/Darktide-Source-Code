-- chunkname: @scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_ogryn_gauntlet_p1.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local templates = {}

table.make_unique(templates)

local stat_buffs = BuffSettings.stat_buffs

templates.weapon_trait_bespoke_ogryn_gauntlet_p1_power_bonus_on_continuous_fire = {
	buffs = {
		weapon_trait_bespoke_ogryn_gauntlet_p1_power_bonus_on_continuous_fire = {
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
templates.weapon_trait_bespoke_ogryn_gauntlet_p1_toughness_on_elite_kills = {
	buffs = {
		weapon_trait_bespoke_ogryn_gauntlet_p1_toughness_on_elite_kills = {
			{
				toughness_fixed_percentage = 0.2,
			},
			{
				toughness_fixed_percentage = 0.25,
			},
			{
				toughness_fixed_percentage = 0.3,
			},
			{
				toughness_fixed_percentage = 0.35,
			},
		},
	},
}
templates.weapon_trait_bespoke_ogryn_gauntlet_p1_toughness_on_crit_kills = {
	buffs = {
		weapon_trait_bespoke_ogryn_gauntlet_p1_toughness_on_crit_kills = {
			{
				toughness_fixed_percentage = 0.24,
			},
			{
				toughness_fixed_percentage = 0.28,
			},
			{
				toughness_fixed_percentage = 0.32,
			},
			{
				toughness_fixed_percentage = 0.36,
			},
		},
	},
}
templates.weapon_trait_bespoke_ogryn_gauntlet_p1_targets_receive_rending_debuff = {
	buffs = {
		weapon_trait_bespoke_ogryn_gauntlet_p1_targets_receive_rending_debuff = {
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
templates.weapon_trait_bespoke_ogryn_gauntlet_p1_windup_increases_power = {
	buffs = {
		weapon_trait_bespoke_ogryn_gauntlet_p1_windup_increases_power = {
			{
				duration_per_stack = 0.4,
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.05,
				},
			},
			{
				duration_per_stack = 0.4,
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.06,
				},
			},
			{
				duration_per_stack = 0.4,
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.07,
				},
			},
			{
				duration_per_stack = 0.4,
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.08,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_ogryn_gauntlet_p1_crit_chance_bonus_on_melee_kills = {
	buffs = {
		weapon_trait_bespoke_ogryn_gauntlet_p1_crit_chance_bonus_on_melee_kills = {
			{
				active_duration = 3,
				proc_stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.1,
				},
			},
			{
				active_duration = 3,
				proc_stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.15,
				},
			},
			{
				active_duration = 3,
				proc_stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.2,
				},
			},
			{
				active_duration = 3,
				proc_stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.25,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_ogryn_gauntlet_p1_chained_melee_hits_increases_power = {
	buffs = {
		weapon_trait_bespoke_ogryn_gauntlet_p1_chained_melee_hits_increases_power_parent = {
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
templates.weapon_trait_bespoke_ogryn_gauntlet_p1_melee_power_after_ranged_explosion = {
	buffs = {
		weapon_trait_bespoke_ogryn_gauntlet_p1_melee_power_after_ranged_explosion = {
			{
				active_duration = 3.5,
				proc_stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.15,
				},
			},
			{
				active_duration = 3.5,
				proc_stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.2,
				},
			},
			{
				active_duration = 3.5,
				proc_stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.25,
				},
			},
			{
				active_duration = 3.5,
				proc_stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.3,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_ogryn_gauntlet_p1_power_bonus_after_weapon_special_multiple = {
	buffs = {
		weapon_trait_bespoke_ogryn_gauntlet_p1_power_bonus_after_weapon_special_multiple = {
			{
				proc_stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.06,
				},
			},
			{
				proc_stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.09,
				},
			},
			{
				proc_stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.12,
				},
			},
			{
				proc_stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.15,
				},
			},
		},
	},
}

return templates
