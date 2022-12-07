local BuffSettings = require("scripts/settings/buff/buff_settings")
local stat_buffs = BuffSettings.stat_buffs
local templates = {
	weapon_trait_bespoke_ogryn_thumper_p1_hipfire_while_sprinting = {
		weapon_trait_bespoke_ogryn_thumper_p1_hipfire_while_sprinting = {
			{}
		}
	},
	weapon_trait_bespoke_ogryn_thumper_p1_suppression_on_close_kill = {
		weapon_trait_bespoke_ogryn_thumper_p1_suppression_on_close_kill = {
			{
				suppression_settings = {
					suppression_falloff = true,
					instant_aggro = true,
					distance = 5,
					suppression_value = 10
				}
			},
			{
				suppression_settings = {
					suppression_falloff = true,
					instant_aggro = true,
					distance = 6,
					suppression_value = 15
				}
			},
			{
				suppression_settings = {
					suppression_falloff = true,
					instant_aggro = true,
					distance = 7,
					suppression_value = 20
				}
			},
			{
				suppression_settings = {
					suppression_falloff = true,
					instant_aggro = true,
					distance = 8,
					suppression_value = 25
				}
			}
		}
	},
	weapon_trait_bespoke_ogryn_thumper_p1_toughness_on_continuous_fire = {
		weapon_trait_bespoke_ogryn_thumper_p1_toughness_on_continuous_fire = {
			{
				stat_buffs = {
					[stat_buffs.toughness_extra_regen_rate] = 0.1
				}
			}
		}
	},
	weapon_trait_bespoke_ogryn_thumper_p1_power_bonus_on_continuous_fire = {
		weapon_trait_bespoke_ogryn_thumper_p1_power_bonus_on_continuous_fire = {
			{
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.02
				}
			}
		}
	},
	weapon_trait_bespoke_ogryn_thumper_p1_crit_chance_based_on_aim_time = {
		weapon_trait_bespoke_ogryn_thumper_p1_crit_chance_based_on_aim_time = {
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
	},
	weapon_trait_bespoke_ogryn_thumper_p1_weapon_special_power_bonus_after_one_shots = {
		weapon_trait_bespoke_ogryn_thumper_p1_weapon_special_power_bonus_after_one_shots = {
			{
				proc_stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.02
				}
			},
			{
				proc_stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.03
				}
			},
			{
				proc_stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.04
				}
			},
			{
				proc_stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.05
				}
			}
		}
	},
	weapon_trait_bespoke_ogryn_thumper_p1_power_bonus_on_hitting_single_enemy_with_all = {
		weapon_trait_bespoke_ogryn_thumper_p1_power_bonus_on_hitting_single_enemy_with_all = {
			{
				proc_stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.02
				}
			},
			{
				proc_stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.03
				}
			},
			{
				proc_stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.04
				}
			},
			{
				proc_stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.05
				}
			}
		}
	},
	weapon_trait_bespoke_ogryn_thumper_p1_shot_power_bonus_after_weapon_special_cleave = {
		weapon_trait_bespoke_ogryn_thumper_p1_shot_power_bonus_after_weapon_special_cleave = {
			{
				proc_stat_buffs = {
					[stat_buffs.ranged_power_level_modifier] = 0.02
				},
				buff_data = {
					required_num_hits = 3
				}
			},
			{
				proc_stat_buffs = {
					[stat_buffs.ranged_power_level_modifier] = 0.04
				},
				buff_data = {
					required_num_hits = 3
				}
			},
			{
				proc_stat_buffs = {
					[stat_buffs.ranged_power_level_modifier] = 0.06
				},
				buff_data = {
					required_num_hits = 3
				}
			},
			{
				proc_stat_buffs = {
					[stat_buffs.ranged_power_level_modifier] = 0.08
				},
				buff_data = {
					required_num_hits = 3
				}
			}
		}
	},
	weapon_trait_bespoke_ogryn_thumper_p1_pass_trough_armor_on_weapon_special = {
		weapon_trait_bespoke_ogryn_thumper_p1_pass_trough_armor_on_weapon_special = {
			{}
		}
	}
}

return templates
