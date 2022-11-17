local BuffSettings = require("scripts/settings/buff/buff_settings")
local templates = {}
local stat_buffs = BuffSettings.stat_buffs
local proc_events = BuffSettings.proc_events
templates.weapon_trait_bespoke_bolter_p1_targets_receive_rending_debuff = {
	weapon_trait_bespoke_bolter_p1_targets_receive_rending_debuff = {
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
}
templates.weapon_trait_bespoke_bolter_p1_stacking_power_bonus_on_staggering_enemies = {
	weapon_trait_bespoke_bolter_p1_stacking_power_bonus_on_staggering_enemies_parent = {
		{
			max_stacks = 5,
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.06
			}
		},
		{
			max_stacks = 5,
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.12
			}
		},
		{
			max_stacks = 5,
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.17
			}
		},
		{
			max_stacks = 5,
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.2
			}
		}
	}
}
templates.weapon_trait_bespoke_bolter_p1_crit_chance_based_on_aim_time = {
	weapon_trait_bespoke_bolter_p1_crit_chance_based_on_aim_time = {
		{
			stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.02
			}
		},
		{
			stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.03
			}
		},
		{
			stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.04
			}
		},
		{
			stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.05
			}
		}
	}
}
templates.weapon_trait_bespoke_bolter_p1_toughness_on_elite_kills = {
	weapon_trait_bespoke_bolter_p1_toughness_on_elite_kills = {
		{
			toughness_fixed_percentage = 0.05
		},
		{
			toughness_fixed_percentage = 0.065
		},
		{
			toughness_fixed_percentage = 0.085
		},
		{
			toughness_fixed_percentage = 0.1
		}
	}
}
templates.weapon_trait_bespoke_bolter_p1_stacking_crit_bonus_on_continuous_fire = {
	weapon_trait_bespoke_bolter_p1_stacking_crit_bonus_on_continuous_fire = {
		{
			stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.01
			}
		},
		{
			stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.02
			}
		},
		{
			stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.03
			}
		},
		{
			stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.04
			}
		}
	}
}
templates.weapon_trait_bespoke_bolter_p1_toughness_on_continuous_fire = {
	weapon_trait_bespoke_bolter_p1_toughness_on_continuous_fire = {
		{
			stat_buffs = {
				[stat_buffs.toughness_extra_regen_rate] = 0.5
			}
		}
	}
}

return templates
