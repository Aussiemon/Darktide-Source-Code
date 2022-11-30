local BuffSettings = require("scripts/settings/buff/buff_settings")
local stat_buffs = BuffSettings.stat_buffs
local templates = {
	weapon_trait_bespoke_ogryn_club_p1_windup_increases_power = {
		weapon_trait_bespoke_ogryn_club_p1_windup_increases_power_parent = {
			{
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.05
				}
			},
			{
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.1
				}
			},
			{
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.15
				}
			},
			{
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.2
				}
			}
		}
	},
	weapon_trait_bespoke_ogryn_club_p1_toughness_recovery_on_chained_attacks = {
		weapon_trait_bespoke_ogryn_club_p1_toughness_recovery_on_chained_attacks = {
			{
				toughness_fixed_percentage = 0.05
			},
			{
				toughness_fixed_percentage = 0.06
			},
			{
				toughness_fixed_percentage = 0.07
			},
			{
				toughness_fixed_percentage = 0.08
			}
		}
	},
	weapon_trait_bespoke_ogryn_club_p1_targets_receive_rending_debuff = {
		weapon_trait_bespoke_ogryn_club_p1_targets_receive_rending_debuff = {
			{
				target_buff_data = {
					num_stacks_on_proc = 1
				}
			},
			{
				target_buff_data = {
					num_stacks_on_proc = 2
				}
			},
			{
				target_buff_data = {
					num_stacks_on_proc = 3
				}
			},
			{
				target_buff_data = {
					num_stacks_on_proc = 4
				}
			}
		}
	},
	weapon_trait_bespoke_ogryn_club_p1_infinite_melee_cleave_on_weakspot_kill = {
		weapon_trait_bespoke_ogryn_club_p1_infinite_melee_cleave_on_weakspot_kill = {
			{
				active_duration = 1.5
			},
			{
				active_duration = 2.5
			},
			{
				active_duration = 3.5
			},
			{
				active_duration = 4.5
			}
		}
	},
	weapon_trait_bespoke_ogryn_club_p1_staggered_targets_receive_increased_damage_debuff = {
		weapon_trait_bespoke_ogryn_club_p1_staggered_targets_receive_increased_damage_debuff = {
			{
				target_buff_data = {
					num_stacks_on_proc = 1
				}
			},
			{
				target_buff_data = {
					num_stacks_on_proc = 2
				}
			},
			{
				target_buff_data = {
					num_stacks_on_proc = 3
				}
			},
			{
				target_buff_data = {
					num_stacks_on_proc = 4
				}
			}
		}
	},
	weapon_trait_bespoke_ogryn_club_p1_pass_past_armor_on_crit = {
		weapon_trait_bespoke_ogryn_club_p1_pass_past_armor_on_crit = {
			{}
		}
	}
}

return templates
