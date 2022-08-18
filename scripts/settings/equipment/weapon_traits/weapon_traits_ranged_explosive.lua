local BuffSettings = require("scripts/settings/buff/buff_settings")
local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
local buff_targets = WeaponTweakTemplateSettings.buff_targets
local buff_keywords = BuffSettings.keywords
local buff_stat_buffs = BuffSettings.stat_buffs
local buff_proc_events = BuffSettings.proc_events
local weapon_traits_ranged_explosive = {
	weapon_traits_ranged_explosive_wield_explosion_resore_toughness = {
		weapon_traits_ranged_explosive_wield_explosion_resore_toughness_buff = {
			{
				cooldown_duration = 10,
				proc_events = {
					[buff_proc_events.on_explosion_hit] = 1
				}
			},
			{
				cooldown_duration = 9,
				proc_events = {
					[buff_proc_events.on_explosion_hit] = 1
				}
			},
			{
				cooldown_duration = 8,
				proc_events = {
					[buff_proc_events.on_explosion_hit] = 1
				}
			},
			{
				cooldown_duration = 7,
				proc_events = {
					[buff_proc_events.on_explosion_hit] = 1
				}
			},
			{
				cooldown_duration = 6,
				proc_events = {
					[buff_proc_events.on_explosion_hit] = 1
				}
			},
			{
				cooldown_duration = 5,
				proc_events = {
					[buff_proc_events.on_explosion_hit] = 1
				}
			}
		}
	},
	weapon_traits_ranged_explosive_wield_explosion_heal_coruption = {
		weapon_traits_ranged_explosive_wield_explosion_heal_coruption_buff = {
			{
				cooldown_duration = 10,
				proc_events = {
					[buff_proc_events.on_explosion_hit] = 1
				}
			},
			{
				cooldown_duration = 9,
				proc_events = {
					[buff_proc_events.on_explosion_hit] = 1
				}
			},
			{
				cooldown_duration = 8,
				proc_events = {
					[buff_proc_events.on_explosion_hit] = 1
				}
			},
			{
				cooldown_duration = 7,
				proc_events = {
					[buff_proc_events.on_explosion_hit] = 1
				}
			},
			{
				cooldown_duration = 6,
				proc_events = {
					[buff_proc_events.on_explosion_hit] = 1
				}
			},
			{
				cooldown_duration = 5,
				proc_events = {
					[buff_proc_events.on_explosion_hit] = 1
				}
			}
		}
	},
	weapon_traits_ranged_explosive_wield_explosion_increase_damage = {
		weapon_traits_ranged_explosive_wield_explosion_increase_damage_buff = {
			{
				active_duration = 5,
				proc_events = {
					[buff_proc_events.on_explosion_hit] = 0.1
				},
				stat_buffs = {
					[buff_stat_buffs.damage] = 0.1
				}
			},
			{
				active_duration = 5,
				proc_events = {
					[buff_proc_events.on_explosion_hit] = 0.1
				},
				stat_buffs = {
					[buff_stat_buffs.damage] = 0.2
				}
			},
			{
				active_duration = 5,
				proc_events = {
					[buff_proc_events.on_explosion_hit] = 0.1
				},
				stat_buffs = {
					[buff_stat_buffs.damage] = 0.3
				}
			},
			{
				active_duration = 5,
				proc_events = {
					[buff_proc_events.on_explosion_hit] = 0.1
				},
				stat_buffs = {
					[buff_stat_buffs.damage] = 0.4
				}
			},
			{
				active_duration = 5,
				proc_events = {
					[buff_proc_events.on_explosion_hit] = 0.1
				},
				stat_buffs = {
					[buff_stat_buffs.damage] = 0.5
				}
			},
			{
				active_duration = 5,
				proc_events = {
					[buff_proc_events.on_explosion_hit] = 0.1
				},
				stat_buffs = {
					[buff_stat_buffs.damage] = 0.6
				}
			}
		}
	},
	weapon_traits_ranged_explosive_wield_explosion_increase_impact = {
		weapon_traits_ranged_explosive_wield_explosion_increase_impact_buff = {
			{
				active_duration = 5,
				proc_events = {
					[buff_proc_events.on_explosion_hit] = 0.1
				},
				stat_buffs = {
					[buff_stat_buffs.explosion_impact_modifier] = 0.1
				}
			},
			{
				active_duration = 5,
				proc_events = {
					[buff_proc_events.on_explosion_hit] = 0.1
				},
				stat_buffs = {
					[buff_stat_buffs.explosion_impact_modifier] = 0.2
				}
			},
			{
				active_duration = 5,
				proc_events = {
					[buff_proc_events.on_explosion_hit] = 0.1
				},
				stat_buffs = {
					[buff_stat_buffs.explosion_impact_modifier] = 0.3
				}
			},
			{
				active_duration = 5,
				proc_events = {
					[buff_proc_events.on_explosion_hit] = 0.1
				},
				stat_buffs = {
					[buff_stat_buffs.explosion_impact_modifier] = 0.4
				}
			},
			{
				active_duration = 5,
				proc_events = {
					[buff_proc_events.on_explosion_hit] = 0.1
				},
				stat_buffs = {
					[buff_stat_buffs.explosion_impact_modifier] = 0.5
				}
			},
			{
				active_duration = 5,
				proc_events = {
					[buff_proc_events.on_explosion_hit] = 0.1
				},
				stat_buffs = {
					[buff_stat_buffs.explosion_impact_modifier] = 0.6
				}
			}
		}
	},
	weapon_traits_ranged_explosive_wield_explosion_increased_crit_chance = {
		weapon_traits_ranged_explosive_wield_explosion_increased_crit_chance_buff = {
			{
				active_duration = 5,
				proc_events = {
					[buff_proc_events.on_explosion_hit] = 0.1
				},
				stat_buffs = {
					[buff_stat_buffs.critical_strike_chance] = 0.1
				}
			},
			{
				active_duration = 5,
				proc_events = {
					[buff_proc_events.on_explosion_hit] = 0.1
				},
				stat_buffs = {
					[buff_stat_buffs.critical_strike_chance] = 0.2
				}
			},
			{
				active_duration = 5,
				proc_events = {
					[buff_proc_events.on_explosion_hit] = 0.1
				},
				stat_buffs = {
					[buff_stat_buffs.critical_strike_chance] = 0.3
				}
			},
			{
				active_duration = 5,
				proc_events = {
					[buff_proc_events.on_explosion_hit] = 0.1
				},
				stat_buffs = {
					[buff_stat_buffs.critical_strike_chance] = 0.4
				}
			},
			{
				active_duration = 5,
				proc_events = {
					[buff_proc_events.on_explosion_hit] = 0.1
				},
				stat_buffs = {
					[buff_stat_buffs.critical_strike_chance] = 0.5
				}
			},
			{
				active_duration = 5,
				proc_events = {
					[buff_proc_events.on_explosion_hit] = 0.1
				},
				stat_buffs = {
					[buff_stat_buffs.critical_strike_chance] = 0.6
				}
			}
		}
	},
	weapon_traits_ranged_explosive_wield_explosion_increased_unarmored_damage = {
		weapon_traits_ranged_explosive_wield_explosion_increased_unarmored_damage_buff = {
			{
				active_duration = 5,
				proc_events = {
					[buff_proc_events.on_explosion_hit] = 0.1
				},
				stat_buffs = {
					[buff_stat_buffs.unarmored_damage] = 0.1
				}
			},
			{
				active_duration = 5,
				proc_events = {
					[buff_proc_events.on_explosion_hit] = 0.1
				},
				stat_buffs = {
					[buff_stat_buffs.unarmored_damage] = 0.2
				}
			},
			{
				active_duration = 5,
				proc_events = {
					[buff_proc_events.on_explosion_hit] = 0.1
				},
				stat_buffs = {
					[buff_stat_buffs.unarmored_damage] = 0.3
				}
			},
			{
				active_duration = 5,
				proc_events = {
					[buff_proc_events.on_explosion_hit] = 0.1
				},
				stat_buffs = {
					[buff_stat_buffs.unarmored_damage] = 0.4
				}
			},
			{
				active_duration = 5,
				proc_events = {
					[buff_proc_events.on_explosion_hit] = 0.1
				},
				stat_buffs = {
					[buff_stat_buffs.unarmored_damage] = 0.5
				}
			},
			{
				active_duration = 5,
				proc_events = {
					[buff_proc_events.on_explosion_hit] = 0.1
				},
				stat_buffs = {
					[buff_stat_buffs.unarmored_damage] = 0.6
				}
			}
		}
	},
	weapon_traits_ranged_explosive_wield_explosion_increased_armored_damage = {
		weapon_traits_ranged_explosive_wield_explosion_increased_armored_damage_buff = {
			{
				active_duration = 5,
				proc_events = {
					[buff_proc_events.on_explosion_hit] = 0.1
				},
				stat_buffs = {
					[buff_stat_buffs.armored_damage] = 0.1
				}
			},
			{
				active_duration = 5,
				proc_events = {
					[buff_proc_events.on_explosion_hit] = 0.1
				},
				stat_buffs = {
					[buff_stat_buffs.armored_damage] = 0.2
				}
			},
			{
				active_duration = 5,
				proc_events = {
					[buff_proc_events.on_explosion_hit] = 0.1
				},
				stat_buffs = {
					[buff_stat_buffs.armored_damage] = 0.3
				}
			},
			{
				active_duration = 5,
				proc_events = {
					[buff_proc_events.on_explosion_hit] = 0.1
				},
				stat_buffs = {
					[buff_stat_buffs.armored_damage] = 0.4
				}
			},
			{
				active_duration = 5,
				proc_events = {
					[buff_proc_events.on_explosion_hit] = 0.1
				},
				stat_buffs = {
					[buff_stat_buffs.armored_damage] = 0.5
				}
			},
			{
				active_duration = 5,
				proc_events = {
					[buff_proc_events.on_explosion_hit] = 0.1
				},
				stat_buffs = {
					[buff_stat_buffs.armored_damage] = 0.6
				}
			}
		}
	},
	weapon_traits_ranged_explosive_wield_explosion_increased_resistant_damage = {
		weapon_traits_ranged_explosive_wield_explosion_increased_resistant_damage_buff = {
			{
				active_duration = 5,
				proc_events = {
					[buff_proc_events.on_explosion_hit] = 0.1
				},
				stat_buffs = {
					[buff_stat_buffs.resistant_damage] = 0.1
				}
			},
			{
				active_duration = 5,
				proc_events = {
					[buff_proc_events.on_explosion_hit] = 0.1
				},
				stat_buffs = {
					[buff_stat_buffs.resistant_damage] = 0.2
				}
			},
			{
				active_duration = 5,
				proc_events = {
					[buff_proc_events.on_explosion_hit] = 0.1
				},
				stat_buffs = {
					[buff_stat_buffs.resistant_damage] = 0.3
				}
			},
			{
				active_duration = 5,
				proc_events = {
					[buff_proc_events.on_explosion_hit] = 0.1
				},
				stat_buffs = {
					[buff_stat_buffs.resistant_damage] = 0.4
				}
			},
			{
				active_duration = 5,
				proc_events = {
					[buff_proc_events.on_explosion_hit] = 0.1
				},
				stat_buffs = {
					[buff_stat_buffs.resistant_damage] = 0.5
				}
			},
			{
				active_duration = 5,
				proc_events = {
					[buff_proc_events.on_explosion_hit] = 0.1
				},
				stat_buffs = {
					[buff_stat_buffs.resistant_damage] = 0.6
				}
			}
		}
	},
	weapon_traits_ranged_explosive_wield_explosion_increased_berserker_damage = {
		weapon_traits_ranged_explosive_wield_explosion_increased_berserker_damage_buff = {
			{
				active_duration = 5,
				proc_events = {
					[buff_proc_events.on_explosion_hit] = 0.1
				},
				stat_buffs = {
					[buff_stat_buffs.berserker_damage] = 0.1
				}
			},
			{
				active_duration = 5,
				proc_events = {
					[buff_proc_events.on_explosion_hit] = 0.1
				},
				stat_buffs = {
					[buff_stat_buffs.berserker_damage] = 0.2
				}
			},
			{
				active_duration = 5,
				proc_events = {
					[buff_proc_events.on_explosion_hit] = 0.1
				},
				stat_buffs = {
					[buff_stat_buffs.berserker_damage] = 0.3
				}
			},
			{
				active_duration = 5,
				proc_events = {
					[buff_proc_events.on_explosion_hit] = 0.1
				},
				stat_buffs = {
					[buff_stat_buffs.berserker_damage] = 0.4
				}
			},
			{
				active_duration = 5,
				proc_events = {
					[buff_proc_events.on_explosion_hit] = 0.1
				},
				stat_buffs = {
					[buff_stat_buffs.berserker_damage] = 0.5
				}
			},
			{
				active_duration = 5,
				proc_events = {
					[buff_proc_events.on_explosion_hit] = 0.1
				},
				stat_buffs = {
					[buff_stat_buffs.berserker_damage] = 0.6
				}
			}
		}
	},
	weapon_traits_ranged_explosive_wield_explosion_increased_super_armor_damage = {
		weapon_traits_ranged_explosive_wield_explosion_increased_super_armor_damage_buff = {
			{
				active_duration = 5,
				proc_events = {
					[buff_proc_events.on_explosion_hit] = 0.1
				},
				stat_buffs = {
					[buff_stat_buffs.super_armor_damage] = 0.1
				}
			},
			{
				active_duration = 5,
				proc_events = {
					[buff_proc_events.on_explosion_hit] = 0.1
				},
				stat_buffs = {
					[buff_stat_buffs.super_armor_damage] = 0.2
				}
			},
			{
				active_duration = 5,
				proc_events = {
					[buff_proc_events.on_explosion_hit] = 0.1
				},
				stat_buffs = {
					[buff_stat_buffs.super_armor_damage] = 0.3
				}
			},
			{
				active_duration = 5,
				proc_events = {
					[buff_proc_events.on_explosion_hit] = 0.1
				},
				stat_buffs = {
					[buff_stat_buffs.super_armor_damage] = 0.4
				}
			},
			{
				active_duration = 5,
				proc_events = {
					[buff_proc_events.on_explosion_hit] = 0.1
				},
				stat_buffs = {
					[buff_stat_buffs.super_armor_damage] = 0.5
				}
			},
			{
				active_duration = 5,
				proc_events = {
					[buff_proc_events.on_explosion_hit] = 0.1
				},
				stat_buffs = {
					[buff_stat_buffs.super_armor_damage] = 0.6
				}
			}
		}
	},
	weapon_traits_ranged_explosive_wield_explosion_increased_disgustingly_resilient_damage = {
		weapon_traits_ranged_explosive_wield_explosion_increased_disgustingly_resilient_damage_buff = {
			{
				active_duration = 5,
				proc_events = {
					[buff_proc_events.on_explosion_hit] = 0.1
				},
				stat_buffs = {
					[buff_stat_buffs.disgustingly_resilient_damage] = 0.1
				}
			},
			{
				active_duration = 5,
				proc_events = {
					[buff_proc_events.on_explosion_hit] = 0.1
				},
				stat_buffs = {
					[buff_stat_buffs.disgustingly_resilient_damage] = 0.2
				}
			},
			{
				active_duration = 5,
				proc_events = {
					[buff_proc_events.on_explosion_hit] = 0.1
				},
				stat_buffs = {
					[buff_stat_buffs.disgustingly_resilient_damage] = 0.3
				}
			},
			{
				active_duration = 5,
				proc_events = {
					[buff_proc_events.on_explosion_hit] = 0.1
				},
				stat_buffs = {
					[buff_stat_buffs.disgustingly_resilient_damage] = 0.4
				}
			},
			{
				active_duration = 5,
				proc_events = {
					[buff_proc_events.on_explosion_hit] = 0.1
				},
				stat_buffs = {
					[buff_stat_buffs.disgustingly_resilient_damage] = 0.5
				}
			},
			{
				active_duration = 5,
				proc_events = {
					[buff_proc_events.on_explosion_hit] = 0.1
				},
				stat_buffs = {
					[buff_stat_buffs.disgustingly_resilient_damage] = 0.6
				}
			}
		}
	},
	weapon_traits_ranged_explosive_wield_bleed_on_hit = {
		weapon_traits_ranged_explosive_wield_bleed_on_hit_buff = {
			{},
			{},
			{},
			{},
			{},
			{}
		}
	}
}

return weapon_traits_ranged_explosive
