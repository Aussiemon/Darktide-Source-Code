local BuffSettings = require("scripts/settings/buff/buff_settings")
local templates = {}

table.make_unique(templates)

local stat_buffs = BuffSettings.stat_buffs
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
				[stat_buffs.power_level_modifier] = 0.0425
			}
		},
		{
			max_stacks = 5,
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.045
			}
		},
		{
			max_stacks = 5,
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.0475
			}
		},
		{
			max_stacks = 5,
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.05
			}
		}
	}
}
templates.weapon_trait_bespoke_bolter_p1_crit_chance_based_on_aim_time = {
	weapon_trait_bespoke_bolter_p1_crit_chance_based_on_aim_time = {
		{
			duration_per_stack = 0.35,
			stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.1
			}
		},
		{
			duration_per_stack = 0.3,
			stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.1
			}
		},
		{
			duration_per_stack = 0.25,
			stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.1
			}
		},
		{
			duration_per_stack = 0.2,
			stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.1
			}
		}
	}
}
templates.weapon_trait_bespoke_bolter_p1_toughness_on_elite_kills = {
	weapon_trait_bespoke_bolter_p1_toughness_on_elite_kills = {
		{
			toughness_fixed_percentage = 0.1
		},
		{
			toughness_fixed_percentage = 0.12
		},
		{
			toughness_fixed_percentage = 0.14
		},
		{
			toughness_fixed_percentage = 0.16
		}
	}
}
templates.weapon_trait_bespoke_bolter_p1_stacking_crit_bonus_on_continuous_fire = {
	weapon_trait_bespoke_bolter_p1_stacking_crit_bonus_on_continuous_fire = {
		{
			stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.035
			}
		},
		{
			stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.04
			}
		},
		{
			stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.045
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
		},
		{
			toughness_fixed_percentage = 0.04
		},
		{
			toughness_fixed_percentage = 0.04
		},
		{
			toughness_fixed_percentage = 0.04
		}
	}
}

return templates
