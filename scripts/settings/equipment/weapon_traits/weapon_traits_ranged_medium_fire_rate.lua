local BuffSettings = require("scripts/settings/buff/buff_settings")
local weapon_traits_ranged_medium_fire_rate = {}
local buff_stat_buffs = BuffSettings.stat_buffs
local buff_proc_events = BuffSettings.proc_events
weapon_traits_ranged_medium_fire_rate.weapon_trait_ranged_medium_fire_rate_wield_on_flanking_shot_grant_power_level = {
	weapon_trait_ranged_common_wield_on_flanking_shot_grant_power_level_buff = {
		{
			cooldown_duration = 3.75,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.05
			},
			stat_buffs = {
				[buff_stat_buffs.power_level_modifier] = 0.1
			}
		},
		{
			cooldown_duration = 3.5,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.075
			},
			stat_buffs = {
				[buff_stat_buffs.power_level_modifier] = 0.2
			}
		},
		{
			cooldown_duration = 3.25,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.power_level_modifier] = 0.3
			}
		},
		{
			cooldown_duration = 3,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.125
			},
			stat_buffs = {
				[buff_stat_buffs.power_level_modifier] = 0.4
			}
		},
		{
			cooldown_duration = 2.75,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.15
			},
			stat_buffs = {
				[buff_stat_buffs.power_level_modifier] = 0.5
			}
		},
		{
			cooldown_duration = 2.5,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.175
			},
			stat_buffs = {
				[buff_stat_buffs.power_level_modifier] = 0.6
			}
		}
	}
}
weapon_traits_ranged_medium_fire_rate.weapon_trait_ranged_medium_fire_rate_wield_on_hit_restore_toughness = {
	weapon_trait_ranged_common_wield_on_hit_restore_toughness_buff = {
		{
			cooldown_duration = 5.25,
			proc_events = {
				[buff_proc_events.on_hit] = 0.05
			}
		},
		{
			cooldown_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.075
			}
		},
		{
			cooldown_duration = 4.75,
			proc_events = {
				[buff_proc_events.on_hit] = 0.1
			}
		},
		{
			cooldown_duration = 4.5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.125
			}
		},
		{
			cooldown_duration = 4.25,
			proc_events = {
				[buff_proc_events.on_hit] = 0.15
			}
		},
		{
			cooldown_duration = 4,
			proc_events = {
				[buff_proc_events.on_hit] = 0.175
			}
		}
	}
}
weapon_traits_ranged_medium_fire_rate.weapon_trait_ranged_medium_fire_rate_wield_on_hit_damage_bonus = {
	weapon_trait_ranged_common_wield_on_hit_damage_bonus_buff = {
		{
			cooldown_duration = 6.25,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.05
			},
			stat_buffs = {
				[buff_stat_buffs.damage] = 0.1
			}
		},
		{
			cooldown_duration = 6,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.075
			},
			stat_buffs = {
				[buff_stat_buffs.damage] = 0.2
			}
		},
		{
			cooldown_duration = 5.75,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.damage] = 0.3
			}
		},
		{
			cooldown_duration = 5.5,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.125
			},
			stat_buffs = {
				[buff_stat_buffs.damage] = 0.4
			}
		},
		{
			cooldown_duration = 5.25,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.15
			},
			stat_buffs = {
				[buff_stat_buffs.damage] = 0.5
			}
		},
		{
			cooldown_duration = 5,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.175
			},
			stat_buffs = {
				[buff_stat_buffs.damage] = 0.6
			}
		}
	}
}
weapon_traits_ranged_medium_fire_rate.weapon_trait_ranged_medium_fire_rate_wield_on_hit_power_bonus = {
	weapon_trait_ranged_common_wield_on_hit_power_bonus_buff = {
		{
			cooldown_duration = 6.25,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.05
			},
			stat_buffs = {
				[buff_stat_buffs.power_level_modifier] = 0.1
			}
		},
		{
			cooldown_duration = 6,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.075
			},
			stat_buffs = {
				[buff_stat_buffs.power_level_modifier] = 0.5
			}
		},
		{
			cooldown_duration = 5.75,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.power_level_modifier] = 0.15
			}
		},
		{
			cooldown_duration = 5.5,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.125
			},
			stat_buffs = {
				[buff_stat_buffs.power_level_modifier] = 1
			}
		},
		{
			cooldown_duration = 5.25,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.15
			},
			stat_buffs = {
				[buff_stat_buffs.power_level_modifier] = 0.2
			}
		},
		{
			cooldown_duration = 5,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.175
			},
			stat_buffs = {
				[buff_stat_buffs.power_level_modifier] = 0.25
			}
		}
	}
}
weapon_traits_ranged_medium_fire_rate.weapon_trait_ranged_medium_fire_rate_wield_on_hit_impact_bonus = {
	weapon_trait_ranged_common_wield_on_hit_impact_bonus_buff = {
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
weapon_traits_ranged_medium_fire_rate.weapon_trait_ranged_medium_fire_rate_wield_on_hit_increased_unarmored_damage = {
	weapon_trait_ranged_common_wield_on_hit_increased_unarmored_damage_buff = {
		{
			cooldown_duration = 5,
			active_duration = 3,
			proc_events = {
				[buff_proc_events.on_hit] = 0.05
			},
			stat_buffs = {
				[buff_stat_buffs.unarmored_damage] = 0.1
			}
		},
		{
			cooldown_duration = 5,
			active_duration = 3,
			proc_events = {
				[buff_proc_events.on_hit] = 0.05
			},
			stat_buffs = {
				[buff_stat_buffs.unarmored_damage] = 0.2
			}
		},
		{
			cooldown_duration = 5,
			active_duration = 3,
			proc_events = {
				[buff_proc_events.on_hit] = 0.05
			},
			stat_buffs = {
				[buff_stat_buffs.unarmored_damage] = 0.3
			}
		},
		{
			cooldown_duration = 5,
			active_duration = 3,
			proc_events = {
				[buff_proc_events.on_hit] = 0.05
			},
			stat_buffs = {
				[buff_stat_buffs.unarmored_damage] = 0.4
			}
		}
	}
}
weapon_traits_ranged_medium_fire_rate.weapon_trait_ranged_medium_fire_rate_wield_on_hit_increased_armored_damage = {
	weapon_trait_ranged_common_wield_on_hit_increased_armored_damage_buff = {
		{
			cooldown_duration = 5,
			active_duration = 3,
			proc_events = {
				[buff_proc_events.on_hit] = 0.05
			},
			stat_buffs = {
				[buff_stat_buffs.armored_damage] = 0.1
			}
		},
		{
			cooldown_duration = 5,
			active_duration = 3,
			proc_events = {
				[buff_proc_events.on_hit] = 0.05
			},
			stat_buffs = {
				[buff_stat_buffs.armored_damage] = 0.2
			}
		},
		{
			cooldown_duration = 5,
			active_duration = 3,
			proc_events = {
				[buff_proc_events.on_hit] = 0.05
			},
			stat_buffs = {
				[buff_stat_buffs.armored_damage] = 0.3
			}
		},
		{
			cooldown_duration = 5,
			active_duration = 3,
			proc_events = {
				[buff_proc_events.on_hit] = 0.05
			},
			stat_buffs = {
				[buff_stat_buffs.armored_damage] = 0.4
			}
		}
	}
}
weapon_traits_ranged_medium_fire_rate.weapon_trait_ranged_medium_fire_rate_wield_on_hit_increased_resistant_damage = {
	weapon_trait_ranged_common_wield_on_hit_increased_resistant_damage_buff = {
		{
			cooldown_duration = 5,
			active_duration = 3,
			proc_events = {
				[buff_proc_events.on_hit] = 0.05
			},
			stat_buffs = {
				[buff_stat_buffs.resistant_damage] = 0.1
			}
		},
		{
			cooldown_duration = 5,
			active_duration = 3,
			proc_events = {
				[buff_proc_events.on_hit] = 0.05
			},
			stat_buffs = {
				[buff_stat_buffs.resistant_damage] = 0.2
			}
		},
		{
			cooldown_duration = 5,
			active_duration = 3,
			proc_events = {
				[buff_proc_events.on_hit] = 0.05
			},
			stat_buffs = {
				[buff_stat_buffs.resistant_damage] = 0.3
			}
		},
		{
			cooldown_duration = 5,
			active_duration = 3,
			proc_events = {
				[buff_proc_events.on_hit] = 0.05
			},
			stat_buffs = {
				[buff_stat_buffs.resistant_damage] = 0.4
			}
		}
	}
}
weapon_traits_ranged_medium_fire_rate.weapon_trait_ranged_medium_fire_rate_wield_on_hit_increased_berserker_damage = {
	weapon_trait_ranged_common_wield_on_hit_increased_berserker_damage_buff = {
		{
			cooldown_duration = 5,
			active_duration = 3,
			proc_events = {
				[buff_proc_events.on_hit] = 0.05
			},
			stat_buffs = {
				[buff_stat_buffs.berserker_damage] = 0.1
			}
		},
		{
			cooldown_duration = 5,
			active_duration = 3,
			proc_events = {
				[buff_proc_events.on_hit] = 0.05
			},
			stat_buffs = {
				[buff_stat_buffs.berserker_damage] = 0.2
			}
		},
		{
			cooldown_duration = 5,
			active_duration = 3,
			proc_events = {
				[buff_proc_events.on_hit] = 0.05
			},
			stat_buffs = {
				[buff_stat_buffs.berserker_damage] = 0.3
			}
		},
		{
			cooldown_duration = 5,
			active_duration = 3,
			proc_events = {
				[buff_proc_events.on_hit] = 0.05
			},
			stat_buffs = {
				[buff_stat_buffs.berserker_damage] = 0.4
			}
		}
	}
}
weapon_traits_ranged_medium_fire_rate.weapon_trait_ranged_medium_fire_rate_wield_on_hit_increased_super_armor_damage = {
	weapon_trait_ranged_common_wield_on_hit_increased_super_armor_damage_buff = {
		{
			cooldown_duration = 5,
			active_duration = 3,
			proc_events = {
				[buff_proc_events.on_hit] = 0.05
			},
			stat_buffs = {
				[buff_stat_buffs.super_armor_damage] = 0.1
			}
		},
		{
			cooldown_duration = 5,
			active_duration = 3,
			proc_events = {
				[buff_proc_events.on_hit] = 0.05
			},
			stat_buffs = {
				[buff_stat_buffs.super_armor_damage] = 0.2
			}
		},
		{
			cooldown_duration = 5,
			active_duration = 3,
			proc_events = {
				[buff_proc_events.on_hit] = 0.05
			},
			stat_buffs = {
				[buff_stat_buffs.super_armor_damage] = 0.3
			}
		},
		{
			cooldown_duration = 5,
			active_duration = 3,
			proc_events = {
				[buff_proc_events.on_hit] = 0.05
			},
			stat_buffs = {
				[buff_stat_buffs.super_armor_damage] = 0.4
			}
		}
	}
}
weapon_traits_ranged_medium_fire_rate.weapon_trait_ranged_medium_fire_rate_wield_on_hit_increased_disgustingly_resilient_damage = {
	weapon_trait_ranged_common_wield_on_hit_increased_disgustingly_resilient_damage_buff = {
		{
			cooldown_duration = 5,
			active_duration = 3,
			proc_events = {
				[buff_proc_events.on_hit] = 0.05
			},
			stat_buffs = {
				[buff_stat_buffs.disgustingly_resilient_damage] = 0.1
			}
		},
		{
			cooldown_duration = 5,
			active_duration = 3,
			proc_events = {
				[buff_proc_events.on_hit] = 0.05
			},
			stat_buffs = {
				[buff_stat_buffs.disgustingly_resilient_damage] = 0.2
			}
		},
		{
			cooldown_duration = 5,
			active_duration = 3,
			proc_events = {
				[buff_proc_events.on_hit] = 0.05
			},
			stat_buffs = {
				[buff_stat_buffs.disgustingly_resilient_damage] = 0.3
			}
		},
		{
			cooldown_duration = 5,
			active_duration = 3,
			proc_events = {
				[buff_proc_events.on_hit] = 0.05
			},
			stat_buffs = {
				[buff_stat_buffs.disgustingly_resilient_damage] = 0.4
			}
		}
	}
}
weapon_traits_ranged_medium_fire_rate.weapon_trait_ranged_medium_fire_rate_wield_on_hit_bleed = {
	weapon_trait_ranged_common_wield_on_hit_bleed_buff = {
		{
			proc_events = {
				[buff_proc_events.on_hit] = 0.05
			}
		},
		{
			proc_events = {
				[buff_proc_events.on_hit] = 0.075
			}
		},
		{
			proc_events = {
				[buff_proc_events.on_hit] = 0.1
			}
		},
		{
			proc_events = {
				[buff_proc_events.on_hit] = 0.125
			}
		}
	}
}
weapon_traits_ranged_medium_fire_rate.weapon_trait_ranged_medium_fire_rate_wield_on_hit_staggered_power_bonus = {
	weapon_trait_ranged_common_wield_on_hit_staggered_power_bonus_buff = {
		{
			cooldown_duration = 5,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.power_level_modifier] = 0.1
			}
		},
		{
			cooldown_duration = 5,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.power_level_modifier] = 0.2
			}
		},
		{
			cooldown_duration = 5,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.power_level_modifier] = 0.3
			}
		},
		{
			cooldown_duration = 5,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.power_level_modifier] = 0.4
			}
		}
	}
}

return weapon_traits_ranged_medium_fire_rate
