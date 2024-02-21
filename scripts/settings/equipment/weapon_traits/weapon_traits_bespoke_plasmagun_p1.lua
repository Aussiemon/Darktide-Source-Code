local BuffSettings = require("scripts/settings/buff/buff_settings")
local templates = {}

table.make_unique(templates)

local stat_buffs = BuffSettings.stat_buffs
templates.weapon_trait_bespoke_plasmagun_p1_toughness_on_elite_kills = {
	weapon_trait_bespoke_plasmagun_p1_toughness_on_elite_kills = {
		{
			toughness_fixed_percentage = 0.175
		},
		{
			toughness_fixed_percentage = 0.2
		},
		{
			toughness_fixed_percentage = 0.225
		},
		{
			toughness_fixed_percentage = 0.25
		}
	}
}
templates.weapon_trait_bespoke_plasmagun_p1_targets_receive_rending_debuff = {
	weapon_trait_bespoke_plasmagun_p1_targets_receive_rending_debuff = {
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
templates.weapon_trait_bespoke_plasmagun_p1_power_bonus_on_continuous_fire = {
	weapon_trait_bespoke_plasmagun_p1_power_bonus_on_continuous_fire = {
		{
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.08
			}
		},
		{
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.08
			}
		},
		{
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.08
			}
		},
		{
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.08
			}
		}
	}
}
templates.weapon_trait_bespoke_plasmagun_p1_lower_overheat_gives_faster_charge = {
	weapon_trait_bespoke_plasmagun_p1_lower_overheat_gives_faster_charge = {
		{
			stat_buffs = {
				[stat_buffs.charge_up_time] = -0.025
			}
		},
		{
			stat_buffs = {
				[stat_buffs.charge_up_time] = -0.03
			}
		},
		{
			stat_buffs = {
				[stat_buffs.charge_up_time] = -0.035
			}
		},
		{
			stat_buffs = {
				[stat_buffs.charge_up_time] = -0.04
			}
		}
	}
}
templates.weapon_trait_bespoke_plasmagun_p1_crit_chance_scaled_on_heat = {
	weapon_trait_bespoke_plasmagun_p1_crit_chance_scaled_on_heat = {
		{
			stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.055,
				[stat_buffs.ranged_critical_strike_damage] = 0.04
			}
		},
		{
			stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.07,
				[stat_buffs.ranged_critical_strike_damage] = 0.06
			}
		},
		{
			stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.085,
				[stat_buffs.ranged_critical_strike_damage] = 0.08
			}
		},
		{
			stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.1,
				[stat_buffs.ranged_critical_strike_damage] = 0.1
			}
		}
	}
}
templates.weapon_trait_bespoke_plasmagun_p1_power_bonus_scaled_on_heat = {
	weapon_trait_bespoke_plasmagun_p1_power_bonus_scaled_on_heat = {
		{
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.015
			}
		},
		{
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.02
			}
		},
		{
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.03
			}
		},
		{
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.04
			}
		}
	}
}
templates.weapon_trait_bespoke_plasmagun_p1_reduced_overheat_on_critical_strike = {
	weapon_trait_bespoke_plasmagun_p1_reduced_overheat_on_critical_strike = {
		{
			conditional_stat_buffs = {
				[stat_buffs.overheat_immediate_amount_critical_strike] = 0.7
			}
		},
		{
			conditional_stat_buffs = {
				[stat_buffs.overheat_immediate_amount_critical_strike] = 0.6
			}
		},
		{
			conditional_stat_buffs = {
				[stat_buffs.overheat_immediate_amount_critical_strike] = 0.5
			}
		},
		{
			conditional_stat_buffs = {
				[stat_buffs.overheat_immediate_amount_critical_strike] = 0.4
			}
		}
	}
}
templates.weapon_trait_bespoke_plasmagun_p1_reduced_overheat_on_continuous_fire = {
	weapon_trait_bespoke_plasmagun_p1_reduced_overheat_on_continuous_fire = {
		{
			stat_buffs = {
				[stat_buffs.overheat_amount] = 0.9
			}
		}
	}
}
templates.weapon_trait_bespoke_plasmagun_p1_charge_level_increases_critical_strike_chance = {
	weapon_trait_bespoke_plasmagun_p1_charge_level_increases_critical_strike_chance = {
		{
			conditional_stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.02
			}
		},
		{
			conditional_stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.03
			}
		},
		{
			conditional_stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.04
			}
		},
		{
			conditional_stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.05
			}
		}
	}
}

return templates
