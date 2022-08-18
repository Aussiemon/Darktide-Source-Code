local BuffSettings = require("scripts/settings/buff/buff_settings")
local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
local buff_targets = WeaponTweakTemplateSettings.buff_targets
local buff_keywords = BuffSettings.keywords
local buff_stat_buffs = BuffSettings.stat_buffs
local buff_proc_events = BuffSettings.proc_events
local weapon_traits_ranged_overheat = {
	weapon_trait_ranged_overheat_wield_increased_vent_speed = {
		weapon_trait_ranged_overheat_wield_increased_vent_speed = {
			{
				stat_buffs = {
					[buff_stat_buffs.vent_overheat_speed] = 0.9
				}
			},
			{
				stat_buffs = {
					[buff_stat_buffs.vent_overheat_speed] = 0.88
				}
			},
			{
				stat_buffs = {
					[buff_stat_buffs.vent_overheat_speed] = 0.86
				}
			},
			{
				stat_buffs = {
					[buff_stat_buffs.vent_overheat_speed] = 0.84
				}
			},
			{
				stat_buffs = {
					[buff_stat_buffs.vent_overheat_speed] = 0.82
				}
			},
			{
				stat_buffs = {
					[buff_stat_buffs.vent_overheat_speed] = 0.8
				}
			}
		}
	},
	weapon_trait_ranged_overheat_wield_reduced_vent_damage_taken = {
		weapon_trait_ranged_overheat_wield_reduced_vent_damage_taken = {
			{
				stat_buffs = {
					[buff_stat_buffs.vent_overheat_damage_multiplier] = 0.9
				}
			},
			{
				stat_buffs = {
					[buff_stat_buffs.vent_overheat_damage_multiplier] = 0.88
				}
			},
			{
				stat_buffs = {
					[buff_stat_buffs.vent_overheat_damage_multiplier] = 0.86
				}
			},
			{
				stat_buffs = {
					[buff_stat_buffs.vent_overheat_damage_multiplier] = 0.84
				}
			},
			{
				stat_buffs = {
					[buff_stat_buffs.vent_overheat_damage_multiplier] = 0.82
				}
			},
			{
				stat_buffs = {
					[buff_stat_buffs.vent_overheat_damage_multiplier] = 0.8
				}
			}
		}
	},
	weapon_trait_ranged_overheat_wield_reduced_overheat_generation_firing = {
		weapon_trait_ranged_overheat_wield_reduced_overheat_generation_firing = {
			{
				stat_buffs = {
					[buff_stat_buffs.overheat_immediate_amount] = 0.9
				}
			},
			{
				stat_buffs = {
					[buff_stat_buffs.overheat_immediate_amount] = 0.88
				}
			},
			{
				stat_buffs = {
					[buff_stat_buffs.overheat_immediate_amount] = 0.86
				}
			},
			{
				stat_buffs = {
					[buff_stat_buffs.overheat_immediate_amount] = 0.84
				}
			},
			{
				stat_buffs = {
					[buff_stat_buffs.overheat_immediate_amount] = 0.82
				}
			},
			{
				stat_buffs = {
					[buff_stat_buffs.overheat_immediate_amount] = 0.8
				}
			}
		}
	},
	weapon_trait_ranged_overheat_wield_reduced_overheat_generation_charging = {
		weapon_trait_ranged_overheat_wield_reduced_overheat_generation_charging = {
			{
				stat_buffs = {
					[buff_stat_buffs.overheat_over_time_amount] = 0.9
				}
			},
			{
				stat_buffs = {
					[buff_stat_buffs.overheat_over_time_amount] = 0.88
				}
			},
			{
				stat_buffs = {
					[buff_stat_buffs.overheat_over_time_amount] = 0.86
				}
			},
			{
				stat_buffs = {
					[buff_stat_buffs.overheat_over_time_amount] = 0.84
				}
			},
			{
				stat_buffs = {
					[buff_stat_buffs.overheat_over_time_amount] = 0.82
				}
			},
			{
				stat_buffs = {
					[buff_stat_buffs.overheat_over_time_amount] = 0.8
				}
			}
		}
	},
	weapon_trait_ranged_overheat_wield_increased_charge_speed = {
		weapon_trait_ranged_overheat_wield_increased_charge_speed = {
			{
				stat_buffs = {
					[buff_stat_buffs.charge_up_time] = -0.1
				}
			},
			{
				stat_buffs = {
					[buff_stat_buffs.charge_up_time] = -0.12
				}
			},
			{
				stat_buffs = {
					[buff_stat_buffs.charge_up_time] = -0.14
				}
			},
			{
				stat_buffs = {
					[buff_stat_buffs.charge_up_time] = -0.16
				}
			},
			{
				stat_buffs = {
					[buff_stat_buffs.charge_up_time] = -0.18
				}
			},
			{
				stat_buffs = {
					[buff_stat_buffs.charge_up_time] = -0.2
				}
			}
		}
	},
	weapon_trait_ranged_overheat_wield_increased_damage_on_full_charge = {
		weapon_trait_ranged_overheat_wield_increased_damage_on_full_charge = {
			{
				stat_buffs = {
					[buff_stat_buffs.fully_charged_damage] = 0.1
				}
			},
			{
				stat_buffs = {
					[buff_stat_buffs.fully_charged_damage] = 0.12
				}
			},
			{
				stat_buffs = {
					[buff_stat_buffs.fully_charged_damage] = 0.14
				}
			},
			{
				stat_buffs = {
					[buff_stat_buffs.fully_charged_damage] = 0.16
				}
			},
			{
				stat_buffs = {
					[buff_stat_buffs.fully_charged_damage] = 0.18
				}
			},
			{
				stat_buffs = {
					[buff_stat_buffs.fully_charged_damage] = 0.2
				}
			}
		}
	},
	weapon_trait_ranged_overheat_wield_high_overheat_increased_charge_speed = {
		weapon_trait_ranged_overheat_wield_high_overheat_increased_charge_speed = {
			{
				stat_buffs = {
					[buff_stat_buffs.charge_up_time] = -0.2
				}
			},
			{
				stat_buffs = {
					[buff_stat_buffs.charge_up_time] = -0.24
				}
			},
			{
				stat_buffs = {
					[buff_stat_buffs.charge_up_time] = -0.28
				}
			},
			{
				stat_buffs = {
					[buff_stat_buffs.charge_up_time] = -0.32
				}
			},
			{
				stat_buffs = {
					[buff_stat_buffs.charge_up_time] = -0.36
				}
			},
			{
				stat_buffs = {
					[buff_stat_buffs.charge_up_time] = -0.4
				}
			}
		}
	},
	weapon_trait_ranged_overheat_wield_high_overheat_increased_damage_on_full_charge = {
		weapon_trait_ranged_overheat_wield_high_overheat_increased_damage_on_full_charge = {
			{
				stat_buffs = {
					[buff_stat_buffs.fully_charged_damage] = 0.2
				}
			},
			{
				stat_buffs = {
					[buff_stat_buffs.fully_charged_damage] = 0.24
				}
			},
			{
				stat_buffs = {
					[buff_stat_buffs.fully_charged_damage] = 0.28
				}
			},
			{
				stat_buffs = {
					[buff_stat_buffs.fully_charged_damage] = 0.32
				}
			},
			{
				stat_buffs = {
					[buff_stat_buffs.fully_charged_damage] = 0.36
				}
			},
			{
				stat_buffs = {
					[buff_stat_buffs.fully_charged_damage] = 0.4
				}
			}
		}
	}
}

return weapon_traits_ranged_overheat
