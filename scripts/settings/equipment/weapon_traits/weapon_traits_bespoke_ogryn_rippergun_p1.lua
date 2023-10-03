local BuffSettings = require("scripts/settings/buff/buff_settings")
local stat_buffs = BuffSettings.stat_buffs
local templates = {
	weapon_trait_bespoke_ogryn_rippergun_p1_suppression_on_close_kill = {
		weapon_trait_bespoke_ogryn_rippergun_p1_suppression_on_close_kill = {
			{
				suppression_settings = {
					suppression_falloff = false,
					instant_aggro = true,
					distance = 12,
					suppression_value = 15
				}
			},
			{
				suppression_settings = {
					suppression_falloff = false,
					instant_aggro = true,
					distance = 12,
					suppression_value = 20
				}
			},
			{
				suppression_settings = {
					suppression_falloff = false,
					instant_aggro = true,
					distance = 12,
					suppression_value = 25
				}
			},
			{
				suppression_settings = {
					suppression_falloff = false,
					instant_aggro = true,
					distance = 12,
					suppression_value = 30
				}
			}
		}
	},
	weapon_trait_bespoke_ogryn_rippergun_p1_increase_close_damage_on_close_kill = {
		weapon_trait_bespoke_ogryn_rippergun_p1_increase_close_damage_on_close_kill_parent = {
			{
				child_duration = 3.5,
				stat_buffs = {
					[stat_buffs.ranged_attack_speed] = 0.07
				}
			},
			{
				child_duration = 3.5,
				stat_buffs = {
					[stat_buffs.ranged_attack_speed] = 0.08
				}
			},
			{
				child_duration = 3.5,
				stat_buffs = {
					[stat_buffs.ranged_attack_speed] = 0.09
				}
			},
			{
				child_duration = 3.5,
				stat_buffs = {
					[stat_buffs.ranged_attack_speed] = 0.1
				}
			}
		}
	},
	weapon_trait_bespoke_ogryn_rippergun_p1_toughness_on_close_range_kills = {
		weapon_trait_bespoke_ogryn_rippergun_p1_toughness_on_close_range_kills = {
			{
				toughness_fixed_percentage = 0.045
			},
			{
				toughness_fixed_percentage = 0.05
			},
			{
				toughness_fixed_percentage = 0.055
			},
			{
				toughness_fixed_percentage = 0.06
			}
		}
	},
	weapon_trait_bespoke_ogryn_rippergun_p1_armor_rending_bayonette = {
		weapon_trait_bespoke_ogryn_rippergun_p1_armor_rending_bayonette = {
			{
				target_buff_data = {
					num_stacks_on_proc = 5
				}
			},
			{
				target_buff_data = {
					num_stacks_on_proc = 6
				}
			},
			{
				target_buff_data = {
					num_stacks_on_proc = 7
				}
			},
			{
				target_buff_data = {
					num_stacks_on_proc = 8
				}
			}
		}
	},
	weapon_trait_bespoke_ogryn_rippergun_p1_stacking_crit_bonus_on_continuous_fire = {
		weapon_trait_bespoke_ogryn_rippergun_p1_stacking_crit_bonus_on_continuous_fire = {
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
	},
	weapon_trait_bespoke_ogryn_rippergun_p1_toughness_on_continuous_fire = {
		weapon_trait_bespoke_ogryn_rippergun_p1_toughness_on_continuous_fire = {
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
	},
	weapon_trait_bespoke_ogryn_rippergun_p1_power_bonus_on_continuous_fire = {
		weapon_trait_bespoke_ogryn_rippergun_p1_power_bonus_on_continuous_fire = {
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
	},
	weapon_trait_bespoke_ogryn_rippergun_p1_bleed_on_crit = {
		weapon_trait_bespoke_ogryn_rippergun_p1_bleed_on_crit = {
			{
				target_buff_data = {
					num_stacks_on_proc = 8
				}
			}
		}
	}
}

return templates
