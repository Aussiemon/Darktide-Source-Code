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
				[stat_buffs.power_level_modifier] = 0.05
			}
		},
		{
			max_stacks = 5,
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.1
			}
		},
		{
			max_stacks = 5,
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.15
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
			duration_per_stack = 0.25,
			stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.02
			}
		},
		{
			duration_per_stack = 0.25,
			stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.03
			}
		},
		{
			duration_per_stack = 0.25,
			stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.04
			}
		},
		{
			duration_per_stack = 0.25,
			stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.05
			}
		}
	}
}
templates.weapon_trait_bespoke_bolter_p1_toughness_on_elite_kills = {
	weapon_trait_bespoke_bolter_p1_toughness_on_elite_kills = {
		{
			toughness_fixed_percentage = 0.04
		},
		{
			toughness_fixed_percentage = 0.06
		},
		{
			toughness_fixed_percentage = 0.08
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
templates.weapon_trait_bespoke_bolter_p1_toughness_on_continuous_fire = {
	weapon_trait_bespoke_bolter_p1_toughness_on_continuous_fire = {
		{
			toughness_fixed_percentage = 0.04
		}
	}
}

return templates
