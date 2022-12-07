local BuffSettings = require("scripts/settings/buff/buff_settings")
local templates = {}
local stat_buffs = BuffSettings.stat_buffs
templates.weapon_trait_bespoke_ogryn_combatblade_p1_crit_chance_on_push = {
	weapon_trait_bespoke_ogryn_combatblade_p1_crit_chance_on_push = {
		{
			proc_stat_buffs = {
				[stat_buffs.melee_critical_strike_chance] = 0.01
			}
		},
		{
			proc_stat_buffs = {
				[stat_buffs.melee_critical_strike_chance] = 0.02
			}
		},
		{
			proc_stat_buffs = {
				[stat_buffs.melee_critical_strike_chance] = 0.03
			}
		},
		{
			proc_stat_buffs = {
				[stat_buffs.melee_critical_strike_chance] = 0.04
			}
		}
	}
}
templates.weapon_trait_bespoke_ogryn_combatblade_p1_increase_power_on_kill = {
	weapon_trait_bespoke_ogryn_combatblade_p1_increase_power_on_kill_parent = {
		{
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.075
			}
		},
		{
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.1
			}
		},
		{
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.125
			}
		},
		{
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.15
			}
		}
	}
}
templates.weapon_trait_bespoke_ogryn_combatblade_p1_increased_attack_cleave_on_multiple_hits = {
	weapon_trait_bespoke_ogryn_combatblade_p1_increased_attack_cleave_on_multiple_hits = {
		{
			buff_data = {
				required_num_hits = 3
			},
			stat_buffs = {
				[stat_buffs.max_hit_mass_attack_modifier] = 1
			}
		},
		{
			buff_data = {
				required_num_hits = 3
			},
			stat_buffs = {
				[stat_buffs.max_hit_mass_attack_modifier] = 1.5
			}
		},
		{
			buff_data = {
				required_num_hits = 3
			},
			stat_buffs = {
				[stat_buffs.max_hit_mass_attack_modifier] = 1.75
			}
		},
		{
			buff_data = {
				required_num_hits = 3
			},
			stat_buffs = {
				[stat_buffs.max_hit_mass_attack_modifier] = 2
			}
		}
	}
}
templates.weapon_trait_bespoke_ogryn_combatblade_p1_increased_power_on_weapon_special_follow_up_hits = {
	weapon_trait_bespoke_ogryn_combatblade_p1_increased_power_on_weapon_special_follow_up_hits = {
		{
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.075
			}
		},
		{
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.1
			}
		},
		{
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.125
			}
		},
		{
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.15
			}
		}
	}
}
templates.weapon_trait_bespoke_ogryn_combatblade_p1_pass_past_armor_on_heavy_attack = {
	weapon_trait_bespoke_ogryn_combatblade_p1_pass_past_armor_on_heavy_attack = {
		{}
	}
}
templates.weapon_trait_bespoke_ogryn_combatblade_p1_infinite_melee_cleave_on_crit = {
	weapon_trait_bespoke_ogryn_combatblade_p1_infinite_melee_cleave_on_crit = {
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
}
templates.weapon_trait_bespoke_ogryn_combatblade_p1_toughness_recovery_on_chained_attacks = {
	weapon_trait_bespoke_ogryn_combatblade_p1_toughness_recovery_on_chained_attacks = {
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
}
templates.weapon_trait_bespoke_ogryn_combatblade_p1_toughness_recovery_on_multiple_hits = {
	weapon_trait_bespoke_ogryn_combatblade_p1_toughness_recovery_on_multiple_hits = {
		{
			buff_data = {
				replenish_percentage = 0.075,
				required_num_hits = 3
			}
		},
		{
			buff_data = {
				replenish_percentage = 0.1,
				required_num_hits = 3
			}
		},
		{
			buff_data = {
				replenish_percentage = 0.125,
				required_num_hits = 3
			}
		},
		{
			buff_data = {
				replenish_percentage = 0.15,
				required_num_hits = 3
			}
		}
	}
}
templates.weapon_trait_bespoke_ogryn_combatblade_p1_windup_increases_power = {
	weapon_trait_bespoke_ogryn_combatblade_p1_windup_increases_power_parent = {
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
}

return templates
