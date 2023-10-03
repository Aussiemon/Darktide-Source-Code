local BuffSettings = require("scripts/settings/buff/buff_settings")
local templates = {}
local stat_buffs = BuffSettings.stat_buffs
templates.weapon_trait_bespoke_ogryn_gauntlet_p1_power_bonus_on_continuous_fire = {
	weapon_trait_bespoke_ogryn_gauntlet_p1_power_bonus_on_continuous_fire = {
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
templates.weapon_trait_bespoke_ogryn_gauntlet_p1_toughness_on_elite_kills = {
	weapon_trait_bespoke_ogryn_gauntlet_p1_toughness_on_elite_kills = {
		{
			toughness_fixed_percentage = 0.2
		},
		{
			toughness_fixed_percentage = 0.25
		},
		{
			toughness_fixed_percentage = 0.3
		},
		{
			toughness_fixed_percentage = 0.35
		}
	}
}
templates.weapon_trait_bespoke_ogryn_gauntlet_p1_toughness_on_crit_kills = {
	weapon_trait_bespoke_ogryn_gauntlet_p1_toughness_on_crit_kills = {
		{
			toughness_fixed_percentage = 0.24
		},
		{
			toughness_fixed_percentage = 0.28
		},
		{
			toughness_fixed_percentage = 0.32
		},
		{
			toughness_fixed_percentage = 0.36
		}
	}
}
templates.weapon_trait_bespoke_ogryn_gauntlet_p1_windup_increases_power = {
	weapon_trait_bespoke_ogryn_gauntlet_p1_windup_increases_power_parent = {
		{
			stat_buffs = {
				[stat_buffs.melee_power_level_modifier] = 0.05
			}
		},
		{
			stat_buffs = {
				[stat_buffs.melee_power_level_modifier] = 0.1
			}
		},
		{
			stat_buffs = {
				[stat_buffs.melee_power_level_modifier] = 0.15
			}
		},
		{
			stat_buffs = {
				[stat_buffs.melee_power_level_modifier] = 0.2
			}
		}
	}
}
templates.weapon_trait_bespoke_ogryn_gauntlet_p1_targets_receive_rending_debuff = {
	weapon_trait_bespoke_ogryn_gauntlet_p1_targets_receive_rending_debuff = {
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
templates.weapon_trait_bespoke_ogryn_gauntlet_p1_windup_increases_power = {
	weapon_trait_bespoke_ogryn_gauntlet_p1_windup_increases_power = {
		{
			duration_per_stack = 0.4,
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.05
			}
		},
		{
			duration_per_stack = 0.4,
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.06
			}
		},
		{
			duration_per_stack = 0.4,
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.07
			}
		},
		{
			duration_per_stack = 0.4,
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.08
			}
		}
	}
}
templates.weapon_trait_bespoke_ogryn_gauntlet_p1_crit_chance_bonus_on_melee_kills = {
	weapon_trait_bespoke_ogryn_gauntlet_p1_crit_chance_bonus_on_melee_kills = {
		{
			active_duration = 3,
			proc_stat_buffs = {
				[stat_buffs.ranged_critical_strike_chance] = 0.1
			}
		},
		{
			active_duration = 3,
			proc_stat_buffs = {
				[stat_buffs.ranged_critical_strike_chance] = 0.15
			}
		},
		{
			active_duration = 3,
			proc_stat_buffs = {
				[stat_buffs.ranged_critical_strike_chance] = 0.2
			}
		},
		{
			active_duration = 3,
			proc_stat_buffs = {
				[stat_buffs.ranged_critical_strike_chance] = 0.25
			}
		}
	}
}
templates.weapon_trait_bespoke_ogryn_gauntlet_p1_chained_melee_hits_increases_power = {
	weapon_trait_bespoke_ogryn_gauntlet_p1_chained_melee_hits_increases_power_parent = {
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
		},
		{
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.05
			}
		}
	}
}

return templates
