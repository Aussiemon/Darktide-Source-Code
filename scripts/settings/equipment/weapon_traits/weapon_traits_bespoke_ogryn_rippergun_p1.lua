local BuffSettings = require("scripts/settings/buff/buff_settings")
local stat_buffs = BuffSettings.stat_buffs
local templates = {
	weapon_trait_bespoke_ogryn_rippergun_p1_suppression_on_close_kill = {
		weapon_trait_bespoke_ogryn_rippergun_p1_suppression_on_close_kill = {
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
	weapon_trait_bespoke_ogryn_rippergun_p1_increase_close_damage_on_close_kill = {
		weapon_trait_bespoke_ogryn_rippergun_p1_increase_close_damage_on_close_kill = {
			{
				stat_buffs = {
					[stat_buffs.damage_near] = 0.04
				}
			},
			{
				stat_buffs = {
					[stat_buffs.damage_near] = 0.06
				}
			},
			{
				stat_buffs = {
					[stat_buffs.damage_near] = 0.8
				}
			},
			{
				stat_buffs = {
					[stat_buffs.damage_near] = 0.1
				}
			}
		}
	},
	weapon_trait_bespoke_ogryn_rippergun_p1_toughness_on_close_range_kills = {
		weapon_trait_bespoke_ogryn_rippergun_p1_toughness_on_close_range_kills = {
			{
				toughness_fixed_percentage = 0.015
			},
			{
				toughness_fixed_percentage = 0.02
			},
			{
				toughness_fixed_percentage = 0.025
			},
			{
				toughness_fixed_percentage = 0.03
			}
		}
	},
	weapon_trait_bespoke_ogryn_rippergun_p1_armor_rending_bayonette = {
		weapon_trait_bespoke_ogryn_rippergun_p1_armor_rending_bayonette = {
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
	weapon_trait_bespoke_ogryn_rippergun_p1_stacking_crit_bonus_on_continuous_fire = {
		weapon_trait_bespoke_ogryn_rippergun_p1_stacking_crit_bonus_on_continuous_fire = {
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
	},
	weapon_trait_bespoke_ogryn_rippergun_p1_toughness_on_continuous_fire = {
		weapon_trait_bespoke_ogryn_rippergun_p1_toughness_on_continuous_fire = {
			{
				stat_buffs = {
					[stat_buffs.toughness_extra_regen_rate] = 0.1
				}
			}
		}
	},
	weapon_trait_bespoke_ogryn_rippergun_p1_power_bonus_on_continuous_fire = {
		weapon_trait_bespoke_ogryn_rippergun_p1_power_bonus_on_continuous_fire = {
			{
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.1
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
