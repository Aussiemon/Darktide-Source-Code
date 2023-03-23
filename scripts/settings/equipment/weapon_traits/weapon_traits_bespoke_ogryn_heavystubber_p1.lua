local BuffSettings = require("scripts/settings/buff/buff_settings")
local stat_buffs = BuffSettings.stat_buffs
local templates = {
	weapon_trait_bespoke_ogryn_heavystubber_p1_toughness_on_continuous_fire = {
		weapon_trait_bespoke_ogryn_heavystubber_p1_toughness_on_continuous_fire = {
			{
				stat_buffs = {
					[stat_buffs.toughness_extra_regen_rate] = 0.1
				}
			}
		}
	},
	weapon_trait_bespoke_ogryn_heavystubber_p1_power_bonus_on_continuous_fire = {
		weapon_trait_bespoke_ogryn_heavystubber_p1_power_bonus_on_continuous_fire = {
			{
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.1
				}
			}
		}
	},
	weapon_trait_bespoke_ogryn_heavystubber_p1_increased_suppression_on_continuous_fire = {
		weapon_trait_bespoke_ogryn_heavystubber_p1_increased_suppression_on_continuous_fire = {
			{
				stat_buffs = {
					[stat_buffs.increased_suppression] = 0.02
				}
			}
		}
	},
	weapon_trait_bespoke_ogryn_heavystubber_p1_movement_speed_on_continous_fire = {
		weapon_trait_bespoke_ogryn_heavystubber_p1_movement_speed_on_continous_fire = {
			{
				stat_buffs = {
					[stat_buffs.movement_speed] = 1.025
				}
			},
			{
				stat_buffs = {
					[stat_buffs.movement_speed] = 1.05
				}
			},
			{
				stat_buffs = {
					[stat_buffs.movement_speed] = 1.075
				}
			},
			{
				stat_buffs = {
					[stat_buffs.movement_speed] = 1.1
				}
			}
		}
	},
	weapon_trait_bespoke_ogryn_heavystubber_p1_increase_power_on_close_kill = {
		weapon_trait_bespoke_ogryn_heavystubber_p1_increase_power_on_close_kill_parent = {
			{
				child_duration = 1.75,
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.05
				}
			},
			{
				child_duration = 1.75,
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.055
				}
			},
			{
				child_duration = 1.75,
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.06
				}
			},
			{
				child_duration = 1.75,
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.065
				}
			}
		}
	},
	weapon_trait_bespoke_ogryn_heavystubber_p1_consecutive_hits_increases_ranged_power = {
		weapon_trait_bespoke_ogryn_heavystubber_p1_consecutive_hits_increases_ranged_power_parent = {
			{
				stat_buffs = {
					[stat_buffs.ranged_power_level_modifier] = 0.01
				}
			},
			{
				stat_buffs = {
					[stat_buffs.ranged_power_level_modifier] = 0.015
				}
			},
			{
				stat_buffs = {
					[stat_buffs.ranged_power_level_modifier] = 0.02
				}
			},
			{
				stat_buffs = {
					[stat_buffs.ranged_power_level_modifier] = 0.025
				}
			}
		}
	},
	weapon_trait_bespoke_ogryn_heavystubber_p1_ammo_from_reserve_on_crit = {
		weapon_trait_bespoke_ogryn_heavystubber_p1_ammo_from_reserve_on_crit = {
			{
				number_of_ammmo_from_reserve = 4
			},
			{
				number_of_ammmo_from_reserve = 6
			},
			{
				number_of_ammmo_from_reserve = 8
			},
			{
				number_of_ammmo_from_reserve = 10
			}
		}
	}
}

return templates
