-- chunkname: @scripts/settings/equipment/weapon_traits/weapon_traits_ranged_aimed.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local weapon_traits_ranged_aimed = {}
local buff_stat_buffs = BuffSettings.stat_buffs
local buff_proc_events = BuffSettings.proc_events

weapon_traits_ranged_aimed.weapon_trait_ranged_aimed_wield_on_weakspot_hit_increase_damage = {
	weapon_trait_ranged_aimed_wield_on_weakspot_hit_increase_damage_buff = {
		{
			cooldown_duration = 5,
			active_duration = 3,
			proc_events = {
				[buff_proc_events.on_hit] = 0.05
			},
			stat_buffs = {
				[buff_stat_buffs.damage] = 0.1
			}
		},
		{
			cooldown_duration = 5,
			active_duration = 3,
			proc_events = {
				[buff_proc_events.on_hit] = 0.05
			},
			stat_buffs = {
				[buff_stat_buffs.damage] = 0.2
			}
		},
		{
			cooldown_duration = 5,
			active_duration = 3,
			proc_events = {
				[buff_proc_events.on_hit] = 0.05
			},
			stat_buffs = {
				[buff_stat_buffs.damage] = 0.3
			}
		},
		{
			cooldown_duration = 5,
			active_duration = 3,
			proc_events = {
				[buff_proc_events.on_hit] = 0.05
			},
			stat_buffs = {
				[buff_stat_buffs.damage] = 0.4
			}
		}
	}
}
weapon_traits_ranged_aimed.weapon_trait_ranged_aimed_wield_on_weakspot_hit_increase_impact = {
	weapon_trait_ranged_aimed_wield_on_weakspot_hit_increase_impact_buff = {
		{
			cooldown_duration = 5,
			active_duration = 3,
			proc_events = {
				[buff_proc_events.on_hit] = 0.05
			},
			stat_buffs = {
				[buff_stat_buffs.ranged_impact_modifier] = 0.1
			}
		},
		{
			cooldown_duration = 5,
			active_duration = 3,
			proc_events = {
				[buff_proc_events.on_hit] = 0.05
			},
			stat_buffs = {
				[buff_stat_buffs.ranged_impact_modifier] = 0.2
			}
		},
		{
			cooldown_duration = 5,
			active_duration = 3,
			proc_events = {
				[buff_proc_events.on_hit] = 0.05
			},
			stat_buffs = {
				[buff_stat_buffs.ranged_impact_modifier] = 0.3
			}
		},
		{
			cooldown_duration = 5,
			active_duration = 3,
			proc_events = {
				[buff_proc_events.on_hit] = 0.05
			},
			stat_buffs = {
				[buff_stat_buffs.ranged_impact_modifier] = 0.4
			}
		}
	}
}
weapon_traits_ranged_aimed.weapon_trait_ranged_aimed_wield_on_weakspot_hit_apply_bleeding = {
	weapon_trait_ranged_aimed_wield_on_weakspot_hit_apply_bleeding_buff = {
		{
			cooldown_duration = 6.25,
			proc_events = {
				[buff_proc_events.on_hit] = 1
			}
		},
		{
			cooldown_duration = 6,
			proc_events = {
				[buff_proc_events.on_hit] = 1
			}
		},
		{
			cooldown_duration = 5.75,
			proc_events = {
				[buff_proc_events.on_hit] = 1
			}
		},
		{
			cooldown_duration = 5.5,
			proc_events = {
				[buff_proc_events.on_hit] = 1
			}
		},
		{
			cooldown_duration = 5.25,
			proc_events = {
				[buff_proc_events.on_hit] = 1
			}
		},
		{
			cooldown_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 1
			}
		}
	}
}
weapon_traits_ranged_aimed.weapon_trait_ranged_aimed_wield_on_weakspot_kill_restore_toughness = {
	weapon_trait_ranged_aimed_wield_on_weakspot_kill_restore_toughness_buff = {
		{
			proc_events = {
				[buff_proc_events.on_hit] = 1
			}
		},
		{
			proc_events = {
				[buff_proc_events.on_hit] = 1
			}
		},
		{
			proc_events = {
				[buff_proc_events.on_hit] = 1
			}
		},
		{
			proc_events = {
				[buff_proc_events.on_hit] = 1
			}
		},
		{
			proc_events = {
				[buff_proc_events.on_hit] = 1
			}
		},
		{
			proc_events = {
				[buff_proc_events.on_hit] = 1
			}
		}
	}
}
weapon_traits_ranged_aimed.weapon_trait_ranged_aimed_wield_on_weakspot_kill_heal_corruption = {
	weapon_trait_ranged_aimed_wield_on_weakspot_kill_heal_corruption_buff = {
		{
			proc_events = {
				[buff_proc_events.on_hit] = 1
			}
		},
		{
			proc_events = {
				[buff_proc_events.on_hit] = 1
			}
		},
		{
			proc_events = {
				[buff_proc_events.on_hit] = 1
			}
		},
		{
			proc_events = {
				[buff_proc_events.on_hit] = 1
			}
		},
		{
			proc_events = {
				[buff_proc_events.on_hit] = 1
			}
		},
		{
			proc_events = {
				[buff_proc_events.on_hit] = 1
			}
		}
	}
}
weapon_traits_ranged_aimed.weapon_trait_ranged_aimed_wield_while_aiming_increased_attack = {
	weapon_trait_ranged_aimed_wield_while_aiming_increased_attack_buff = {
		{
			stat_buffs = {
				[buff_stat_buffs.damage] = 0.1
			}
		},
		{
			stat_buffs = {
				[buff_stat_buffs.damage] = 0.2
			}
		},
		{
			stat_buffs = {
				[buff_stat_buffs.damage] = 0.3
			}
		},
		{
			stat_buffs = {
				[buff_stat_buffs.damage] = 0.4
			}
		}
	}
}
weapon_traits_ranged_aimed.weapon_trait_ranged_aimed_wield_while_aiming_increased_impact = {
	weapon_trait_ranged_aimed_wield_while_aiming_increased_impact_buff = {
		{
			stat_buffs = {
				[buff_stat_buffs.ranged_impact_modifier] = 0.1
			}
		},
		{
			stat_buffs = {
				[buff_stat_buffs.ranged_impact_modifier] = 0.2
			}
		},
		{
			stat_buffs = {
				[buff_stat_buffs.ranged_impact_modifier] = 0.3
			}
		},
		{
			stat_buffs = {
				[buff_stat_buffs.ranged_impact_modifier] = 0.4
			}
		}
	}
}
weapon_traits_ranged_aimed.weapon_trait_ranged_aimed_wield_while_aiming_finesse_bonus = {
	weapon_trait_ranged_aimed_wield_while_aiming_finesse_bonus_buff = {
		{
			stat_buffs = {
				[buff_stat_buffs.finesse_modifier_bonus] = 0.1
			}
		},
		{
			stat_buffs = {
				[buff_stat_buffs.finesse_modifier_bonus] = 0.2
			}
		},
		{
			stat_buffs = {
				[buff_stat_buffs.finesse_modifier_bonus] = 0.3
			}
		},
		{
			stat_buffs = {
				[buff_stat_buffs.finesse_modifier_bonus] = 0.4
			}
		}
	}
}
weapon_traits_ranged_aimed.weapon_trait_ranged_aimed_wield_while_aiming_increased_crit_chance = {
	weapon_trait_ranged_aimed_wield_while_aiming_increased_crit_chance_buff = {
		{
			stat_buffs = {
				[buff_stat_buffs.critical_strike_chance] = 0.1
			}
		},
		{
			stat_buffs = {
				[buff_stat_buffs.critical_strike_chance] = 0.2
			}
		},
		{
			stat_buffs = {
				[buff_stat_buffs.critical_strike_chance] = 0.3
			}
		},
		{
			stat_buffs = {
				[buff_stat_buffs.critical_strike_chance] = 0.4
			}
		}
	}
}
weapon_traits_ranged_aimed.weapon_trait_ranged_aimed_wield_while_aiming_increased_unarmored_damage = {
	weapon_trait_ranged_aimed_wield_while_aiming_increased_unarmored_damage_buff = {
		{
			stat_buffs = {
				[buff_stat_buffs.unarmored_damage] = 0.1
			}
		},
		{
			stat_buffs = {
				[buff_stat_buffs.unarmored_damage] = 0.2
			}
		},
		{
			stat_buffs = {
				[buff_stat_buffs.unarmored_damage] = 0.3
			}
		},
		{
			stat_buffs = {
				[buff_stat_buffs.unarmored_damage] = 0.4
			}
		}
	}
}
weapon_traits_ranged_aimed.weapon_trait_ranged_aimed_wield_while_aiming_increased_armored_damage = {
	weapon_trait_ranged_aimed_wield_while_aiming_increased_armored_damage_buff = {
		{
			stat_buffs = {
				[buff_stat_buffs.armored_damage] = 0.1
			}
		},
		{
			stat_buffs = {
				[buff_stat_buffs.armored_damage] = 0.2
			}
		},
		{
			stat_buffs = {
				[buff_stat_buffs.armored_damage] = 0.3
			}
		},
		{
			stat_buffs = {
				[buff_stat_buffs.armored_damage] = 0.4
			}
		}
	}
}
weapon_traits_ranged_aimed.weapon_trait_ranged_aimed_wield_while_aiming_increased_resistant_damage = {
	weapon_trait_ranged_aimed_wield_while_aiming_increased_resistant_damage_buff = {
		{
			stat_buffs = {
				[buff_stat_buffs.resistant_damage] = 0.1
			}
		},
		{
			stat_buffs = {
				[buff_stat_buffs.resistant_damage] = 0.2
			}
		},
		{
			stat_buffs = {
				[buff_stat_buffs.resistant_damage] = 0.3
			}
		},
		{
			stat_buffs = {
				[buff_stat_buffs.resistant_damage] = 0.4
			}
		}
	}
}
weapon_traits_ranged_aimed.weapon_trait_ranged_aimed_wield_while_aiming_increased_berserker_damage = {
	weapon_trait_ranged_aimed_wield_while_aiming_increased_berserker_damage_buff = {
		{
			stat_buffs = {
				[buff_stat_buffs.berserker_damage] = 0.1
			}
		},
		{
			stat_buffs = {
				[buff_stat_buffs.berserker_damage] = 0.2
			}
		},
		{
			stat_buffs = {
				[buff_stat_buffs.berserker_damage] = 0.3
			}
		},
		{
			stat_buffs = {
				[buff_stat_buffs.berserker_damage] = 0.4
			}
		}
	}
}
weapon_traits_ranged_aimed.weapon_trait_ranged_aimed_wield_while_aiming_increased_super_armor_damage = {
	weapon_trait_ranged_aimed_wield_while_aiming_increased_super_armor_damage_buff = {
		{
			stat_buffs = {
				[buff_stat_buffs.super_armor_damage] = 0.1
			}
		},
		{
			stat_buffs = {
				[buff_stat_buffs.super_armor_damage] = 0.2
			}
		},
		{
			stat_buffs = {
				[buff_stat_buffs.super_armor_damage] = 0.3
			}
		},
		{
			stat_buffs = {
				[buff_stat_buffs.super_armor_damage] = 0.4
			}
		}
	}
}
weapon_traits_ranged_aimed.weapon_trait_ranged_aimed_wield_while_aiming_increased_disgustingly_resilient_damage = {
	weapon_trait_ranged_aimed_wield_while_aiming_increased_disgustingly_resilient_damage_buff = {
		{
			stat_buffs = {
				[buff_stat_buffs.disgustingly_resilient_damage] = 0.1
			}
		},
		{
			stat_buffs = {
				[buff_stat_buffs.disgustingly_resilient_damage] = 0.2
			}
		},
		{
			stat_buffs = {
				[buff_stat_buffs.disgustingly_resilient_damage] = 0.3
			}
		},
		{
			stat_buffs = {
				[buff_stat_buffs.disgustingly_resilient_damage] = 0.4
			}
		}
	}
}
weapon_traits_ranged_aimed.weapon_trait_ranged_aimed_wield_on_enter_ads_increase_damage = {
	weapon_trait_ranged_aimed_wield_on_enter_ads_increase_damage_buff = {
		{
			cooldown_duration = 5,
			active_duration = 3,
			proc_events = {
				[buff_proc_events.on_alternative_fire_start] = 0.05
			},
			stat_buffs = {
				[buff_stat_buffs.damage] = 0.1
			}
		},
		{
			cooldown_duration = 5,
			active_duration = 3,
			proc_events = {
				[buff_proc_events.on_alternative_fire_start] = 0.05
			},
			stat_buffs = {
				[buff_stat_buffs.damage] = 0.2
			}
		},
		{
			cooldown_duration = 5,
			active_duration = 3,
			proc_events = {
				[buff_proc_events.on_alternative_fire_start] = 0.05
			},
			stat_buffs = {
				[buff_stat_buffs.damage] = 0.3
			}
		},
		{
			cooldown_duration = 5,
			active_duration = 3,
			proc_events = {
				[buff_proc_events.on_alternative_fire_start] = 0.05
			},
			stat_buffs = {
				[buff_stat_buffs.damage] = 0.4
			}
		}
	}
}
weapon_traits_ranged_aimed.weapon_trait_ranged_aimed_wield_on_enter_ads_increase_impact = {
	weapon_trait_ranged_aimed_wield_on_enter_ads_increase_impact_buff = {
		{
			cooldown_duration = 5,
			active_duration = 3,
			proc_events = {
				[buff_proc_events.on_alternative_fire_start] = 0.05
			},
			stat_buffs = {
				[buff_stat_buffs.ranged_impact_modifier] = 0.1
			}
		},
		{
			cooldown_duration = 5,
			active_duration = 3,
			proc_events = {
				[buff_proc_events.on_alternative_fire_start] = 0.05
			},
			stat_buffs = {
				[buff_stat_buffs.ranged_impact_modifier] = 0.2
			}
		},
		{
			cooldown_duration = 5,
			active_duration = 3,
			proc_events = {
				[buff_proc_events.on_alternative_fire_start] = 0.05
			},
			stat_buffs = {
				[buff_stat_buffs.ranged_impact_modifier] = 0.3
			}
		},
		{
			cooldown_duration = 5,
			active_duration = 3,
			proc_events = {
				[buff_proc_events.on_alternative_fire_start] = 0.05
			},
			stat_buffs = {
				[buff_stat_buffs.ranged_impact_modifier] = 0.4
			}
		}
	}
}
weapon_traits_ranged_aimed.weapon_trait_ranged_aimed_wield_on_enter_ads_apply_bleeding = {
	weapon_trait_ranged_aimed_wield_on_enter_ads_apply_bleeding_buff = {
		{
			cooldown_duration = 5,
			active_duration = 3,
			proc_events = {
				[buff_proc_events.on_alternative_fire_start] = 0.05
			}
		},
		{
			cooldown_duration = 5,
			active_duration = 3,
			proc_events = {
				[buff_proc_events.on_alternative_fire_start] = 0.05
			}
		},
		{
			cooldown_duration = 5,
			active_duration = 3,
			proc_events = {
				[buff_proc_events.on_alternative_fire_start] = 0.05
			}
		},
		{
			cooldown_duration = 5,
			active_duration = 3,
			proc_events = {
				[buff_proc_events.on_alternative_fire_start] = 0.05
			}
		}
	}
}
weapon_traits_ranged_aimed.weapon_trait_ranged_aimed_wield_on_enter_ads_finesse_bonus = {
	weapon_trait_ranged_aimed_wield_on_enter_ads_finesse_bonus_buff = {
		{
			cooldown_duration = 5,
			active_duration = 3,
			proc_events = {
				[buff_proc_events.on_alternative_fire_start] = 0.05
			},
			stat_buffs = {
				[buff_stat_buffs.finesse_modifier_bonus] = 0.1
			}
		},
		{
			cooldown_duration = 5,
			active_duration = 3,
			proc_events = {
				[buff_proc_events.on_alternative_fire_start] = 0.05
			},
			stat_buffs = {
				[buff_stat_buffs.finesse_modifier_bonus] = 0.2
			}
		},
		{
			cooldown_duration = 5,
			active_duration = 3,
			proc_events = {
				[buff_proc_events.on_alternative_fire_start] = 0.05
			},
			stat_buffs = {
				[buff_stat_buffs.finesse_modifier_bonus] = 0.3
			}
		},
		{
			cooldown_duration = 5,
			active_duration = 3,
			proc_events = {
				[buff_proc_events.on_alternative_fire_start] = 0.05
			},
			stat_buffs = {
				[buff_stat_buffs.finesse_modifier_bonus] = 0.4
			}
		}
	}
}
weapon_traits_ranged_aimed.weapon_trait_ranged_aimed_wield_on_enter_ads_increased_unarmored_damage = {
	weapon_trait_ranged_aimed_wield_on_enter_ads_increased_unarmored_damage_buff = {
		{
			cooldown_duration = 5,
			active_duration = 3,
			proc_events = {
				[buff_proc_events.on_alternative_fire_start] = 0.05
			},
			stat_buffs = {
				[buff_stat_buffs.unarmored_damage] = 0.1
			}
		},
		{
			cooldown_duration = 5,
			active_duration = 3,
			proc_events = {
				[buff_proc_events.on_alternative_fire_start] = 0.05
			},
			stat_buffs = {
				[buff_stat_buffs.unarmored_damage] = 0.2
			}
		},
		{
			cooldown_duration = 5,
			active_duration = 3,
			proc_events = {
				[buff_proc_events.on_alternative_fire_start] = 0.05
			},
			stat_buffs = {
				[buff_stat_buffs.unarmored_damage] = 0.3
			}
		},
		{
			cooldown_duration = 5,
			active_duration = 3,
			proc_events = {
				[buff_proc_events.on_alternative_fire_start] = 0.05
			},
			stat_buffs = {
				[buff_stat_buffs.unarmored_damage] = 0.4
			}
		}
	}
}
weapon_traits_ranged_aimed.weapon_trait_ranged_aimed_wield_on_enter_ads_increased_armored_damage = {
	weapon_trait_ranged_aimed_wield_on_enter_ads_increased_armored_damage_buff = {
		{
			cooldown_duration = 5,
			active_duration = 3,
			proc_events = {
				[buff_proc_events.on_alternative_fire_start] = 0.05
			},
			stat_buffs = {
				[buff_stat_buffs.armored_damage] = 0.1
			}
		},
		{
			cooldown_duration = 5,
			active_duration = 3,
			proc_events = {
				[buff_proc_events.on_alternative_fire_start] = 0.05
			},
			stat_buffs = {
				[buff_stat_buffs.armored_damage] = 0.2
			}
		},
		{
			cooldown_duration = 5,
			active_duration = 3,
			proc_events = {
				[buff_proc_events.on_alternative_fire_start] = 0.05
			},
			stat_buffs = {
				[buff_stat_buffs.armored_damage] = 0.3
			}
		},
		{
			cooldown_duration = 5,
			active_duration = 3,
			proc_events = {
				[buff_proc_events.on_alternative_fire_start] = 0.05
			},
			stat_buffs = {
				[buff_stat_buffs.armored_damage] = 0.4
			}
		}
	}
}
weapon_traits_ranged_aimed.weapon_trait_ranged_aimed_wield_on_enter_ads_increased_resistant_damage = {
	weapon_trait_ranged_aimed_wield_on_enter_ads_increased_resistant_damage_buff = {
		{
			cooldown_duration = 5,
			active_duration = 3,
			proc_events = {
				[buff_proc_events.on_alternative_fire_start] = 0.05
			},
			stat_buffs = {
				[buff_stat_buffs.resistant_damage] = 0.1
			}
		},
		{
			cooldown_duration = 5,
			active_duration = 3,
			proc_events = {
				[buff_proc_events.on_alternative_fire_start] = 0.05
			},
			stat_buffs = {
				[buff_stat_buffs.resistant_damage] = 0.2
			}
		},
		{
			cooldown_duration = 5,
			active_duration = 3,
			proc_events = {
				[buff_proc_events.on_alternative_fire_start] = 0.05
			},
			stat_buffs = {
				[buff_stat_buffs.resistant_damage] = 0.3
			}
		},
		{
			cooldown_duration = 5,
			active_duration = 3,
			proc_events = {
				[buff_proc_events.on_alternative_fire_start] = 0.05
			},
			stat_buffs = {
				[buff_stat_buffs.resistant_damage] = 0.4
			}
		}
	}
}
weapon_traits_ranged_aimed.weapon_trait_ranged_aimed_wield_on_enter_ads_increased_berserker_damage = {
	weapon_trait_ranged_aimed_wield_on_enter_ads_increased_berserker_damage_buff = {
		{
			cooldown_duration = 5,
			active_duration = 3,
			proc_events = {
				[buff_proc_events.on_alternative_fire_start] = 0.05
			},
			stat_buffs = {
				[buff_stat_buffs.berserker_damage] = 0.1
			}
		},
		{
			cooldown_duration = 5,
			active_duration = 3,
			proc_events = {
				[buff_proc_events.on_alternative_fire_start] = 0.05
			},
			stat_buffs = {
				[buff_stat_buffs.berserker_damage] = 0.2
			}
		},
		{
			cooldown_duration = 5,
			active_duration = 3,
			proc_events = {
				[buff_proc_events.on_alternative_fire_start] = 0.05
			},
			stat_buffs = {
				[buff_stat_buffs.berserker_damage] = 0.3
			}
		},
		{
			cooldown_duration = 5,
			active_duration = 3,
			proc_events = {
				[buff_proc_events.on_alternative_fire_start] = 0.05
			},
			stat_buffs = {
				[buff_stat_buffs.berserker_damage] = 0.4
			}
		}
	}
}
weapon_traits_ranged_aimed.weapon_trait_ranged_aimed_wield_on_enter_ads_increased_super_armor_damage = {
	weapon_trait_ranged_aimed_wield_on_enter_ads_increased_super_armor_damage_buff = {
		{
			cooldown_duration = 5,
			active_duration = 3,
			proc_events = {
				[buff_proc_events.on_alternative_fire_start] = 0.05
			},
			stat_buffs = {
				[buff_stat_buffs.super_armor_damage] = 0.1
			}
		},
		{
			cooldown_duration = 5,
			active_duration = 3,
			proc_events = {
				[buff_proc_events.on_alternative_fire_start] = 0.05
			},
			stat_buffs = {
				[buff_stat_buffs.super_armor_damage] = 0.2
			}
		},
		{
			cooldown_duration = 5,
			active_duration = 3,
			proc_events = {
				[buff_proc_events.on_alternative_fire_start] = 0.05
			},
			stat_buffs = {
				[buff_stat_buffs.super_armor_damage] = 0.3
			}
		},
		{
			cooldown_duration = 5,
			active_duration = 3,
			proc_events = {
				[buff_proc_events.on_alternative_fire_start] = 0.05
			},
			stat_buffs = {
				[buff_stat_buffs.super_armor_damage] = 0.4
			}
		}
	}
}
weapon_traits_ranged_aimed.weapon_trait_ranged_aimed_wield_on_enter_ads_increased_disgustingly_resilient_damage = {
	weapon_trait_ranged_aimed_wield_on_enter_ads_increased_disgustingly_resilient_damage_buff = {
		{
			cooldown_duration = 5,
			active_duration = 3,
			proc_events = {
				[buff_proc_events.on_alternative_fire_start] = 0.05
			},
			stat_buffs = {
				[buff_stat_buffs.disgustingly_resilient_damage] = 0.1
			}
		},
		{
			cooldown_duration = 5,
			active_duration = 3,
			proc_events = {
				[buff_proc_events.on_alternative_fire_start] = 0.05
			},
			stat_buffs = {
				[buff_stat_buffs.disgustingly_resilient_damage] = 0.2
			}
		},
		{
			cooldown_duration = 5,
			active_duration = 3,
			proc_events = {
				[buff_proc_events.on_alternative_fire_start] = 0.05
			},
			stat_buffs = {
				[buff_stat_buffs.disgustingly_resilient_damage] = 0.3
			}
		},
		{
			cooldown_duration = 5,
			active_duration = 3,
			proc_events = {
				[buff_proc_events.on_alternative_fire_start] = 0.05
			},
			stat_buffs = {
				[buff_stat_buffs.disgustingly_resilient_damage] = 0.4
			}
		}
	}
}

return weapon_traits_ranged_aimed
