local BuffSettings = require("scripts/settings/buff/buff_settings")
local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
local buff_targets = WeaponTweakTemplateSettings.buff_targets
local weapon_traits_melee_common = {}
local buff_keywords = BuffSettings.keywords
local buff_stat_buffs = BuffSettings.stat_buffs
local buff_proc_events = BuffSettings.proc_events
weapon_traits_melee_common.weapon_trait_melee_common_wield_increased_attack = {
	weapon_trait_melee_common_wield_increased_attack_buff = {
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
		},
		{
			stat_buffs = {
				[buff_stat_buffs.damage] = 0.5
			}
		},
		{
			stat_buffs = {
				[buff_stat_buffs.damage] = 0.6
			}
		}
	}
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_increased_unarmored_damage = {
	weapon_trait_melee_common_wield_increased_unarmored_damage_buff = {
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
		},
		{
			stat_buffs = {
				[buff_stat_buffs.unarmored_damage] = 0.5
			}
		},
		{
			stat_buffs = {
				[buff_stat_buffs.unarmored_damage] = 0.6
			}
		}
	}
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_increased_armored_damage = {
	weapon_trait_melee_common_wield_increased_armored_damage_buff = {
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
		},
		{
			stat_buffs = {
				[buff_stat_buffs.armored_damage] = 0.5
			}
		},
		{
			stat_buffs = {
				[buff_stat_buffs.armored_damage] = 0.6
			}
		}
	}
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_increased_resistant_damage = {
	weapon_trait_melee_common_wield_increased_resistant_damage_buff = {
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
		},
		{
			stat_buffs = {
				[buff_stat_buffs.resistant_damage] = 0.5
			}
		},
		{
			stat_buffs = {
				[buff_stat_buffs.resistant_damage] = 0.6
			}
		}
	}
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_increased_berserker_damage = {
	weapon_trait_melee_common_wield_increased_berserker_damage_buff = {
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
		},
		{
			stat_buffs = {
				[buff_stat_buffs.berserker_damage] = 0.5
			}
		},
		{
			stat_buffs = {
				[buff_stat_buffs.berserker_damage] = 0.6
			}
		}
	}
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_increased_super_armor_damage = {
	weapon_trait_melee_common_wield_increased_super_armor_damage_buff = {
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
		},
		{
			stat_buffs = {
				[buff_stat_buffs.super_armor_damage] = 0.5
			}
		},
		{
			stat_buffs = {
				[buff_stat_buffs.super_armor_damage] = 0.6
			}
		}
	}
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_increased_disgustingly_resilient_damage = {
	weapon_trait_melee_common_wield_increased_disgustingly_resilient_damage_buff = {
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
		},
		{
			stat_buffs = {
				[buff_stat_buffs.disgustingly_resilient_damage] = 0.5
			}
		},
		{
			stat_buffs = {
				[buff_stat_buffs.disgustingly_resilient_damage] = 0.6
			}
		}
	}
}
weapon_traits_melee_common.weapon_trait_melee_common_equip_decrease_corruption_damage_taken = {
	weapon_trait_melee_common_equip_decrease_corruption_damage_taken_buff = {
		{
			stat_buffs = {
				[buff_stat_buffs.corruption_taken_multiplier] = 0.85
			}
		},
		{
			stat_buffs = {
				[buff_stat_buffs.corruption_taken_multiplier] = 0.845
			}
		},
		{
			stat_buffs = {
				[buff_stat_buffs.corruption_taken_multiplier] = 0.835
			}
		},
		{
			stat_buffs = {
				[buff_stat_buffs.corruption_taken_multiplier] = 0.82
			}
		},
		{
			stat_buffs = {
				[buff_stat_buffs.corruption_taken_multiplier] = 0.8
			}
		},
		{
			stat_buffs = {
				[buff_stat_buffs.corruption_taken_multiplier] = 0.75
			}
		}
	}
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_decrease_corruption_damage_taken = {
	weapon_trait_melee_common_wield_decrease_corruption_damage_taken_buff = {
		{
			stat_buffs = {
				[buff_stat_buffs.corruption_taken_multiplier] = 0.85
			}
		},
		{
			stat_buffs = {
				[buff_stat_buffs.corruption_taken_multiplier] = 0.845
			}
		},
		{
			stat_buffs = {
				[buff_stat_buffs.corruption_taken_multiplier] = 0.835
			}
		},
		{
			stat_buffs = {
				[buff_stat_buffs.corruption_taken_multiplier] = 0.82
			}
		},
		{
			stat_buffs = {
				[buff_stat_buffs.corruption_taken_multiplier] = 0.8
			}
		},
		{
			stat_buffs = {
				[buff_stat_buffs.corruption_taken_multiplier] = 0.75
			}
		}
	}
}
weapon_traits_melee_common.weapon_trait_melee_common_equip_decrease_toughness_damage_taken = {
	weapon_trait_melee_common_equip_decrease_toughness_damage_taken_buff = {
		{
			stat_buffs = {
				[buff_stat_buffs.toughness_damage_taken_multiplier] = 0.85
			}
		},
		{
			stat_buffs = {
				[buff_stat_buffs.toughness_damage_taken_multiplier] = 0.845
			}
		},
		{
			stat_buffs = {
				[buff_stat_buffs.toughness_damage_taken_multiplier] = 0.835
			}
		},
		{
			stat_buffs = {
				[buff_stat_buffs.toughness_damage_taken_multiplier] = 0.82
			}
		},
		{
			stat_buffs = {
				[buff_stat_buffs.toughness_damage_taken_multiplier] = 0.8
			}
		},
		{
			stat_buffs = {
				[buff_stat_buffs.toughness_damage_taken_multiplier] = 0.75
			}
		}
	}
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_decrease_toughness_damage_taken = {
	weapon_trait_melee_common_wield_decrease_toughness_damage_taken_buff = {
		{
			stat_buffs = {
				[buff_stat_buffs.toughness_damage_taken_multiplier] = 0.85
			}
		},
		{
			stat_buffs = {
				[buff_stat_buffs.toughness_damage_taken_multiplier] = 0.845
			}
		},
		{
			stat_buffs = {
				[buff_stat_buffs.toughness_damage_taken_multiplier] = 0.835
			}
		},
		{
			stat_buffs = {
				[buff_stat_buffs.toughness_damage_taken_multiplier] = 0.82
			}
		},
		{
			stat_buffs = {
				[buff_stat_buffs.toughness_damage_taken_multiplier] = 0.8
			}
		},
		{
			stat_buffs = {
				[buff_stat_buffs.toughness_damage_taken_multiplier] = 0.75
			}
		}
	}
}
weapon_traits_melee_common.weapon_trait_melee_common_equip_decrease_damage_taken = {
	weapon_trait_melee_common_equip_decrease_damage_taken_buff = {
		{
			stat_buffs = {
				[buff_stat_buffs.damage_taken_multiplier] = 0.85
			}
		},
		{
			stat_buffs = {
				[buff_stat_buffs.damage_taken_multiplier] = 0.845
			}
		},
		{
			stat_buffs = {
				[buff_stat_buffs.damage_taken_multiplier] = 0.835
			}
		},
		{
			stat_buffs = {
				[buff_stat_buffs.damage_taken_multiplier] = 0.82
			}
		},
		{
			stat_buffs = {
				[buff_stat_buffs.damage_taken_multiplier] = 0.8
			}
		},
		{
			stat_buffs = {
				[buff_stat_buffs.damage_taken_multiplier] = 0.75
			}
		}
	}
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_decrease_damage_taken = {
	weapon_trait_melee_common_wield_decrease_damage_taken_buff = {
		{
			stat_buffs = {
				[buff_stat_buffs.damage_taken_multiplier] = 0.85
			}
		},
		{
			stat_buffs = {
				[buff_stat_buffs.damage_taken_multiplier] = 0.845
			}
		},
		{
			stat_buffs = {
				[buff_stat_buffs.damage_taken_multiplier] = 0.835
			}
		},
		{
			stat_buffs = {
				[buff_stat_buffs.damage_taken_multiplier] = 0.82
			}
		},
		{
			stat_buffs = {
				[buff_stat_buffs.damage_taken_multiplier] = 0.8
			}
		},
		{
			stat_buffs = {
				[buff_stat_buffs.damage_taken_multiplier] = 0.75
			}
		}
	}
}
weapon_traits_melee_common.weapon_trait_melee_common_equip_increase_movement_speed = {
	weapon_trait_melee_common_equip_increase_movement_speed_buff = {
		{
			stat_buffs = {
				[buff_stat_buffs.movement_speed] = 1.1
			}
		},
		{
			stat_buffs = {
				[buff_stat_buffs.movement_speed] = 1.2
			}
		},
		{
			stat_buffs = {
				[buff_stat_buffs.movement_speed] = 1.3
			}
		},
		{
			stat_buffs = {
				[buff_stat_buffs.movement_speed] = 1.4
			}
		},
		{
			stat_buffs = {
				[buff_stat_buffs.movement_speed] = 1.5
			}
		},
		{
			stat_buffs = {
				[buff_stat_buffs.movement_speed] = 1.6
			}
		}
	}
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_increase_movement_speed = {
	weapon_trait_melee_common_wield_increase_movement_speed_buff = {
		{
			stat_buffs = {
				[buff_stat_buffs.movement_speed] = 1.1
			}
		},
		{
			stat_buffs = {
				[buff_stat_buffs.movement_speed] = 1.2
			}
		},
		{
			stat_buffs = {
				[buff_stat_buffs.movement_speed] = 1.3
			}
		},
		{
			stat_buffs = {
				[buff_stat_buffs.movement_speed] = 1.4
			}
		},
		{
			stat_buffs = {
				[buff_stat_buffs.movement_speed] = 1.5
			}
		},
		{
			stat_buffs = {
				[buff_stat_buffs.movement_speed] = 1.6
			}
		}
	}
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_increase_crit_chance = {
	weapon_trait_melee_common_wield_increase_crit_chance_buff = {
		{
			stat_buffs = {
				[buff_stat_buffs.critical_strike_chance] = 0.05
			}
		},
		{
			stat_buffs = {
				[buff_stat_buffs.critical_strike_chance] = 0.1
			}
		},
		{
			stat_buffs = {
				[buff_stat_buffs.critical_strike_chance] = 0.15
			}
		},
		{
			stat_buffs = {
				[buff_stat_buffs.critical_strike_chance] = 0.2
			}
		},
		{
			stat_buffs = {
				[buff_stat_buffs.critical_strike_chance] = 0.25
			}
		},
		{
			stat_buffs = {
				[buff_stat_buffs.critical_strike_chance] = 0.3
			}
		}
	}
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_increase_impact = {
	weapon_trait_melee_common_wield_increase_impact_buff = {
		{
			stat_buffs = {
				[buff_stat_buffs.melee_impact_modifier] = 0.1
			}
		},
		{
			stat_buffs = {
				[buff_stat_buffs.melee_impact_modifier] = 0.2
			}
		},
		{
			stat_buffs = {
				[buff_stat_buffs.melee_impact_modifier] = 0.3
			}
		},
		{
			stat_buffs = {
				[buff_stat_buffs.melee_impact_modifier] = 0.4
			}
		},
		{
			stat_buffs = {
				[buff_stat_buffs.melee_impact_modifier] = 0.5
			}
		},
		{
			stat_buffs = {
				[buff_stat_buffs.melee_impact_modifier] = 0.6
			}
		}
	}
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_power_modifier_bonus = {
	weapon_trait_melee_common_wield_power_modifier_bonus_buff = {
		{
			stat_buffs = {
				[buff_stat_buffs.power_level_modifier] = 0.1
			}
		},
		{
			stat_buffs = {
				[buff_stat_buffs.power_level_modifier] = 0.2
			}
		},
		{
			stat_buffs = {
				[buff_stat_buffs.power_level_modifier] = 0.3
			}
		},
		{
			stat_buffs = {
				[buff_stat_buffs.power_level_modifier] = 0.4
			}
		},
		{
			stat_buffs = {
				[buff_stat_buffs.power_level_modifier] = 0.5
			}
		},
		{
			stat_buffs = {
				[buff_stat_buffs.power_level_modifier] = 0.6
			}
		}
	}
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_finesse_modifier_bonus = {
	weapon_trait_melee_common_wield_finesse_modifier_bonus_buff = {
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
		},
		{
			stat_buffs = {
				[buff_stat_buffs.finesse_modifier_bonus] = 0.5
			}
		},
		{
			stat_buffs = {
				[buff_stat_buffs.finesse_modifier_bonus] = 0.6
			}
		}
	}
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_on_hit_damage_bonus = {
	weapon_trait_melee_common_wield_on_hit_damage_bonus_buff = {
		{
			cooldown_duration = 6.25,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.05
			},
			stat_buffs = {
				[buff_stat_buffs.damage] = 0.25
			}
		},
		{
			cooldown_duration = 6,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.075
			},
			stat_buffs = {
				[buff_stat_buffs.damage] = 0.5
			}
		},
		{
			cooldown_duration = 5.75,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.damage] = 0.75
			}
		},
		{
			cooldown_duration = 5.5,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.125
			},
			stat_buffs = {
				[buff_stat_buffs.damage] = 1
			}
		},
		{
			cooldown_duration = 5.25,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.15
			},
			stat_buffs = {
				[buff_stat_buffs.damage] = 1.25
			}
		},
		{
			cooldown_duration = 5,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.175
			},
			stat_buffs = {
				[buff_stat_buffs.damage] = 1.5
			}
		}
	}
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_on_hit_power_bonus = {
	weapon_trait_melee_common_wield_on_hit_power_bonus_buff = {
		{
			cooldown_duration = 6.25,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.05
			},
			stat_buffs = {
				[buff_stat_buffs.power_level_modifier] = 0.25
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
				[buff_stat_buffs.power_level_modifier] = 0.75
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
				[buff_stat_buffs.power_level_modifier] = 1.25
			}
		},
		{
			cooldown_duration = 5,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.175
			},
			stat_buffs = {
				[buff_stat_buffs.power_level_modifier] = 1.5
			}
		}
	}
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_on_hit_impact_bonus = {
	weapon_trait_melee_common_wield_on_hit_impact_bonus_buff = {
		{
			cooldown_duration = 6.25,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.05
			},
			stat_buffs = {
				[buff_stat_buffs.melee_impact_modifier] = 0.25
			}
		},
		{
			cooldown_duration = 6,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.075
			},
			stat_buffs = {
				[buff_stat_buffs.melee_impact_modifier] = 0.5
			}
		},
		{
			cooldown_duration = 5.75,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.melee_impact_modifier] = 0.75
			}
		},
		{
			cooldown_duration = 5.5,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.125
			},
			stat_buffs = {
				[buff_stat_buffs.melee_impact_modifier] = 1
			}
		},
		{
			cooldown_duration = 5.25,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.15
			},
			stat_buffs = {
				[buff_stat_buffs.melee_impact_modifier] = 1.25
			}
		},
		{
			cooldown_duration = 5,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.175
			},
			stat_buffs = {
				[buff_stat_buffs.melee_impact_modifier] = 1.5
			}
		}
	}
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_on_hit_increased_unarmored_damage = {
	weapon_trait_melee_common_wield_on_hit_increased_unarmored_damage_buff = {
		{
			cooldown_duration = 6.25,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.05
			},
			stat_buffs = {
				[buff_stat_buffs.unarmored_damage] = 0.25
			}
		},
		{
			cooldown_duration = 6,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.075
			},
			stat_buffs = {
				[buff_stat_buffs.unarmored_damage] = 0.5
			}
		},
		{
			cooldown_duration = 5.75,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.unarmored_damage] = 0.75
			}
		},
		{
			cooldown_duration = 5.5,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.125
			},
			stat_buffs = {
				[buff_stat_buffs.unarmored_damage] = 1
			}
		},
		{
			cooldown_duration = 5.25,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.15
			},
			stat_buffs = {
				[buff_stat_buffs.unarmored_damage] = 1.25
			}
		},
		{
			cooldown_duration = 5,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.175
			},
			stat_buffs = {
				[buff_stat_buffs.unarmored_damage] = 1.5
			}
		}
	}
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_on_hit_increased_armored_damage = {
	weapon_trait_melee_common_wield_on_hit_increased_armored_damage_buff = {
		{
			cooldown_duration = 6.25,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.05
			},
			stat_buffs = {
				[buff_stat_buffs.armored_damage] = 0.25
			}
		},
		{
			cooldown_duration = 6,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.075
			},
			stat_buffs = {
				[buff_stat_buffs.armored_damage] = 0.5
			}
		},
		{
			cooldown_duration = 5.75,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.armored_damage] = 0.75
			}
		},
		{
			cooldown_duration = 5.5,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.125
			},
			stat_buffs = {
				[buff_stat_buffs.armored_damage] = 1
			}
		},
		{
			cooldown_duration = 5.25,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.15
			},
			stat_buffs = {
				[buff_stat_buffs.armored_damage] = 1.25
			}
		},
		{
			cooldown_duration = 5,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.175
			},
			stat_buffs = {
				[buff_stat_buffs.armored_damage] = 1.5
			}
		}
	}
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_on_hit_increased_resistant_damage = {
	weapon_trait_melee_common_wield_on_hit_increased_resistant_damage_buff = {
		{
			cooldown_duration = 6.25,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.05
			},
			stat_buffs = {
				[buff_stat_buffs.resistant_damage] = 0.25
			}
		},
		{
			cooldown_duration = 6,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.075
			},
			stat_buffs = {
				[buff_stat_buffs.resistant_damage] = 0.5
			}
		},
		{
			cooldown_duration = 5.75,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.resistant_damage] = 0.75
			}
		},
		{
			cooldown_duration = 5.5,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.125
			},
			stat_buffs = {
				[buff_stat_buffs.resistant_damage] = 1
			}
		},
		{
			cooldown_duration = 5.25,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.15
			},
			stat_buffs = {
				[buff_stat_buffs.resistant_damage] = 1.25
			}
		},
		{
			cooldown_duration = 5,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.175
			},
			stat_buffs = {
				[buff_stat_buffs.resistant_damage] = 1.5
			}
		}
	}
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_on_hit_increased_berserker_damage = {
	weapon_trait_melee_common_wield_on_hit_increased_berserker_damage_buff = {
		{
			cooldown_duration = 6.25,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.05
			},
			stat_buffs = {
				[buff_stat_buffs.berserker_damage] = 0.25
			}
		},
		{
			cooldown_duration = 6,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.075
			},
			stat_buffs = {
				[buff_stat_buffs.berserker_damage] = 0.5
			}
		},
		{
			cooldown_duration = 5.75,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.berserker_damage] = 0.75
			}
		},
		{
			cooldown_duration = 5.5,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.125
			},
			stat_buffs = {
				[buff_stat_buffs.berserker_damage] = 1
			}
		},
		{
			cooldown_duration = 5.25,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.15
			},
			stat_buffs = {
				[buff_stat_buffs.berserker_damage] = 1.25
			}
		},
		{
			cooldown_duration = 5,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.175
			},
			stat_buffs = {
				[buff_stat_buffs.berserker_damage] = 1.5
			}
		}
	}
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_on_hit_increased_super_armor_damage = {
	weapon_trait_melee_common_wield_on_hit_increased_super_armor_damage_buff = {
		{
			cooldown_duration = 6.25,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.05
			},
			stat_buffs = {
				[buff_stat_buffs.super_armor_damage] = 0.25
			}
		},
		{
			cooldown_duration = 6,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.075
			},
			stat_buffs = {
				[buff_stat_buffs.super_armor_damage] = 0.5
			}
		},
		{
			cooldown_duration = 5.75,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.super_armor_damage] = 0.75
			}
		},
		{
			cooldown_duration = 5.5,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.125
			},
			stat_buffs = {
				[buff_stat_buffs.super_armor_damage] = 1
			}
		},
		{
			cooldown_duration = 5.25,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.15
			},
			stat_buffs = {
				[buff_stat_buffs.super_armor_damage] = 1.25
			}
		},
		{
			cooldown_duration = 5,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.175
			},
			stat_buffs = {
				[buff_stat_buffs.super_armor_damage] = 1.5
			}
		}
	}
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_on_hit_increased_disgustingly_resilient_damage = {
	weapon_trait_melee_common_wield_on_hit_increased_disgustingly_resilient_damage_buff = {
		{
			cooldown_duration = 6.25,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.05
			},
			stat_buffs = {
				[buff_stat_buffs.disgustingly_resilient_damage] = 0.25
			}
		},
		{
			cooldown_duration = 6,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.075
			},
			stat_buffs = {
				[buff_stat_buffs.disgustingly_resilient_damage] = 0.5
			}
		},
		{
			cooldown_duration = 5.75,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.disgustingly_resilient_damage] = 0.75
			}
		},
		{
			cooldown_duration = 5.5,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.125
			},
			stat_buffs = {
				[buff_stat_buffs.disgustingly_resilient_damage] = 1
			}
		},
		{
			cooldown_duration = 5.25,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.15
			},
			stat_buffs = {
				[buff_stat_buffs.disgustingly_resilient_damage] = 1.25
			}
		},
		{
			cooldown_duration = 5,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.175
			},
			stat_buffs = {
				[buff_stat_buffs.disgustingly_resilient_damage] = 1.5
			}
		}
	}
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_on_hit_bleed = {
	weapon_trait_melee_common_wield_on_hit_bleed_buff = {
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
		},
		{
			proc_events = {
				[buff_proc_events.on_hit] = 0.15
			}
		},
		{
			proc_events = {
				[buff_proc_events.on_hit] = 0.175
			}
		}
	}
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_on_hit_staggered_power_bonus = {
	weapon_trait_melee_common_wield_on_hit_staggered_power_bonus_buff = {
		{
			cooldown_duration = 6.25,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.05
			},
			stat_buffs = {
				[buff_stat_buffs.power_level_modifier] = 0.25
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
				[buff_stat_buffs.power_level_modifier] = 0.75
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
				[buff_stat_buffs.power_level_modifier] = 1.25
			}
		},
		{
			cooldown_duration = 5,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.175
			},
			stat_buffs = {
				[buff_stat_buffs.power_level_modifier] = 1.5
			}
		}
	}
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_on_heavy_attack_grant_power_bonus = {
	weapon_trait_melee_common_wield_on_heavy_attack_grant_power_bonus_buff = {
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
		},
		{
			proc_events = {
				[buff_proc_events.on_hit] = 0.15
			}
		},
		{
			proc_events = {
				[buff_proc_events.on_hit] = 0.175
			}
		}
	}
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_on_heavy_hit_damage_bonus = {
	weapon_trait_melee_common_wield_on_heavy_hit_damage_bonus_buff = {
		{
			cooldown_duration = 6.25,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.damage] = 0.25
			}
		},
		{
			cooldown_duration = 6,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.damage] = 0.5
			}
		},
		{
			cooldown_duration = 5.75,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.damage] = 0.75
			}
		},
		{
			cooldown_duration = 5.5,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.damage] = 1
			}
		},
		{
			cooldown_duration = 5.25,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.damage] = 1.25
			}
		},
		{
			cooldown_duration = 5,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.damage] = 1.5
			}
		}
	}
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_on_heavy_hit_power_bonus = {
	weapon_trait_melee_common_wield_on_heavy_hit_power_bonus_buff = {
		{
			cooldown_duration = 6.25,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.power_level_modifier] = 0.25
			}
		},
		{
			cooldown_duration = 6,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.1
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
				[buff_stat_buffs.power_level_modifier] = 0.75
			}
		},
		{
			cooldown_duration = 5.5,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.power_level_modifier] = 1
			}
		},
		{
			cooldown_duration = 5.25,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.power_level_modifier] = 1.25
			}
		},
		{
			cooldown_duration = 5,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.power_level_modifier] = 1.5
			}
		}
	}
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_on_heavy_hit_impact_bonus = {
	weapon_trait_melee_common_wield_on_heavy_hit_impact_bonus_buff = {
		{
			cooldown_duration = 6.25,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.melee_impact_modifier] = 0.25
			}
		},
		{
			cooldown_duration = 6,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.melee_impact_modifier] = 0.5
			}
		},
		{
			cooldown_duration = 5.75,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.melee_impact_modifier] = 0.75
			}
		},
		{
			cooldown_duration = 5.5,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.melee_impact_modifier] = 1
			}
		},
		{
			cooldown_duration = 5.25,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.melee_impact_modifier] = 1.25
			}
		},
		{
			cooldown_duration = 5,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.melee_impact_modifier] = 1.5
			}
		}
	}
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_on_heavy_hit_increased_unarmored_damage = {
	weapon_trait_melee_common_wield_on_heavy_hit_increased_unarmored_damage_buff = {
		{
			cooldown_duration = 6.25,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.unarmored_damage] = 0.25
			}
		},
		{
			cooldown_duration = 6,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.unarmored_damage] = 0.5
			}
		},
		{
			cooldown_duration = 5.75,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.unarmored_damage] = 0.75
			}
		},
		{
			cooldown_duration = 5.5,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.unarmored_damage] = 1
			}
		},
		{
			cooldown_duration = 5.25,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.unarmored_damage] = 1.25
			}
		},
		{
			cooldown_duration = 5,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.unarmored_damage] = 1.5
			}
		}
	}
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_on_heavy_hit_increased_armored_damage = {
	weapon_trait_melee_common_wield_on_heavy_hit_increased_unarmored_damage_buff = {
		{
			cooldown_duration = 6.25,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.armored_damage] = 0.25
			}
		},
		{
			cooldown_duration = 6,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.armored_damage] = 0.5
			}
		},
		{
			cooldown_duration = 5.75,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.armored_damage] = 0.75
			}
		},
		{
			cooldown_duration = 5.5,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.armored_damage] = 1
			}
		},
		{
			cooldown_duration = 5.25,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.armored_damage] = 1.25
			}
		},
		{
			cooldown_duration = 5,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.armored_damage] = 1.5
			}
		}
	}
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_on_heavy_hit_increased_resistant_damage = {
	weapon_trait_melee_common_wield_on_heavy_hit_increased_resistant_damage_buff = {
		{
			cooldown_duration = 6.25,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.resistant_damage] = 0.25
			}
		},
		{
			cooldown_duration = 6,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.resistant_damage] = 0.5
			}
		},
		{
			cooldown_duration = 5.75,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.resistant_damage] = 0.75
			}
		},
		{
			cooldown_duration = 5.5,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.resistant_damage] = 1
			}
		},
		{
			cooldown_duration = 5.25,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.resistant_damage] = 1.25
			}
		},
		{
			cooldown_duration = 5,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.resistant_damage] = 1.5
			}
		}
	}
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_on_heavy_hit_increased_berserker_damage = {
	weapon_trait_melee_common_wield_on_heavy_hit_increased_berserker_damage_buff = {
		{
			cooldown_duration = 6.25,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.berserker_damage] = 0.25
			}
		},
		{
			cooldown_duration = 6,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.berserker_damage] = 0.5
			}
		},
		{
			cooldown_duration = 5.75,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.berserker_damage] = 0.75
			}
		},
		{
			cooldown_duration = 5.5,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.berserker_damage] = 1
			}
		},
		{
			cooldown_duration = 5.25,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.berserker_damage] = 1.25
			}
		},
		{
			cooldown_duration = 5,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.berserker_damage] = 1.5
			}
		}
	}
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_on_heavy_hit_increased_super_armor_damage = {
	weapon_trait_melee_common_wield_on_heavy_hit_increased_super_armor_damage_buff = {
		{
			cooldown_duration = 6.25,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.super_armor_damage] = 0.25
			}
		},
		{
			cooldown_duration = 6,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.super_armor_damage] = 0.5
			}
		},
		{
			cooldown_duration = 5.75,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.super_armor_damage] = 0.75
			}
		},
		{
			cooldown_duration = 5.5,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.super_armor_damage] = 1
			}
		},
		{
			cooldown_duration = 5.25,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.super_armor_damage] = 1.25
			}
		},
		{
			cooldown_duration = 5,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.super_armor_damage] = 1.5
			}
		}
	}
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_on_heavy_hit_increased_disgustingly_resilient_damage = {
	weapon_trait_melee_common_wield_on_heavy_hit_increased_disgustingly_resilient_damage_buff = {
		{
			cooldown_duration = 6.25,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.disgustingly_resilient_damage] = 0.25
			}
		},
		{
			cooldown_duration = 6,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.disgustingly_resilient_damage] = 0.5
			}
		},
		{
			cooldown_duration = 5.75,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.disgustingly_resilient_damage] = 0.75
			}
		},
		{
			cooldown_duration = 5.5,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.disgustingly_resilient_damage] = 1
			}
		},
		{
			cooldown_duration = 5.25,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.disgustingly_resilient_damage] = 1.25
			}
		},
		{
			cooldown_duration = 5,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.disgustingly_resilient_damage] = 1.5
			}
		}
	}
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_power_modifier_bonus_on_full_toughness = {
	weapon_trait_melee_common_wield_power_modifier_bonus_on_full_toughness_buff = {
		{
			stat_buffs = {
				[buff_stat_buffs.power_level_modifier] = 0.1
			}
		},
		{
			stat_buffs = {
				[buff_stat_buffs.power_level_modifier] = 0.2
			}
		},
		{
			stat_buffs = {
				[buff_stat_buffs.power_level_modifier] = 0.3
			}
		},
		{
			stat_buffs = {
				[buff_stat_buffs.power_level_modifier] = 0.4
			}
		},
		{
			stat_buffs = {
				[buff_stat_buffs.power_level_modifier] = 0.5
			}
		},
		{
			stat_buffs = {
				[buff_stat_buffs.power_level_modifier] = 0.6
			}
		}
	}
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_surpression_immunity_on_full_toughness = {
	weapon_trait_melee_common_wield_surpression_immunity_on_full_toughness_buff = {
		[6] = {}
	}
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_on_player_toughness_broken_grant_power_level = {
	weapon_trait_melee_common_wield_on_player_toughness_broken_grant_power_level_buff = {
		{
			cooldown_duration = 3.75,
			active_duration = 2.5,
			proc_events = {
				[buff_proc_events.on_player_toughness_broken] = 1
			},
			stat_buffs = {
				[buff_stat_buffs.power_level_modifier] = 0.25
			}
		},
		{
			cooldown_duration = 3.5,
			active_duration = 2.5,
			proc_events = {
				[buff_proc_events.on_player_toughness_broken] = 1
			},
			stat_buffs = {
				[buff_stat_buffs.power_level_modifier] = 0.5
			}
		},
		{
			cooldown_duration = 3.25,
			active_duration = 2.5,
			proc_events = {
				[buff_proc_events.on_player_toughness_broken] = 1
			},
			stat_buffs = {
				[buff_stat_buffs.power_level_modifier] = 0.75
			}
		},
		{
			cooldown_duration = 3,
			active_duration = 2.5,
			proc_events = {
				[buff_proc_events.on_player_toughness_broken] = 1
			},
			stat_buffs = {
				[buff_stat_buffs.power_level_modifier] = 1
			}
		},
		{
			cooldown_duration = 2.75,
			active_duration = 2.5,
			proc_events = {
				[buff_proc_events.on_player_toughness_broken] = 1
			},
			stat_buffs = {
				[buff_stat_buffs.power_level_modifier] = 1.25
			}
		},
		{
			cooldown_duration = 2.5,
			active_duration = 2.5,
			proc_events = {
				[buff_proc_events.on_player_toughness_broken] = 1
			},
			stat_buffs = {
				[buff_stat_buffs.power_level_modifier] = 1.5
			}
		}
	}
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_on_successful_dodge_grant_finess_bonus = {
	weapon_trait_melee_common_wield_on_successful_dodge_grant_finess_bonus_buff = {
		{
			proc_events = {
				[buff_proc_events.on_successful_dodge] = 1
			}
		},
		{
			proc_events = {
				[buff_proc_events.on_successful_dodge] = 1
			}
		},
		{
			proc_events = {
				[buff_proc_events.on_successful_dodge] = 1
			}
		},
		{
			proc_events = {
				[buff_proc_events.on_successful_dodge] = 1
			}
		},
		{
			proc_events = {
				[buff_proc_events.on_successful_dodge] = 1
			}
		},
		{
			proc_events = {
				[buff_proc_events.on_successful_dodge] = 1
			}
		}
	}
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_on_successful_dodge_grant_crit_chance = {
	weapon_trait_melee_common_wield_on_successful_dodge_grant_crit_chance_buff = {
		{
			proc_events = {
				[buff_proc_events.on_successful_dodge] = 1
			}
		},
		{
			proc_events = {
				[buff_proc_events.on_successful_dodge] = 1
			}
		},
		{
			proc_events = {
				[buff_proc_events.on_successful_dodge] = 1
			}
		},
		{
			proc_events = {
				[buff_proc_events.on_successful_dodge] = 1
			}
		},
		{
			proc_events = {
				[buff_proc_events.on_successful_dodge] = 1
			}
		},
		{
			proc_events = {
				[buff_proc_events.on_successful_dodge] = 1
			}
		}
	}
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_on_successful_dodge_grant_bleed = {
	weapon_trait_melee_common_wield_on_successful_dodge_grant_bleed_buff = {
		{
			proc_events = {
				[buff_proc_events.on_successful_dodge] = 1
			}
		},
		{
			proc_events = {
				[buff_proc_events.on_successful_dodge] = 1
			}
		},
		{
			proc_events = {
				[buff_proc_events.on_successful_dodge] = 1
			}
		},
		{
			proc_events = {
				[buff_proc_events.on_successful_dodge] = 1
			}
		},
		{
			proc_events = {
				[buff_proc_events.on_successful_dodge] = 1
			}
		},
		{
			proc_events = {
				[buff_proc_events.on_successful_dodge] = 1
			}
		}
	}
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_low_health_grant_suppression_immunity = {
	weapon_trait_melee_common_wield_low_health_grant_suppression_immunity_buff = {
		[6] = {}
	}
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_low_health_grant_power_modifier = {
	weapon_trait_melee_common_wield_low_health_grant_power_modifier_buff = {
		[6] = {}
	}
}
weapon_traits_melee_common.weapon_trait_melee_common_equip_immunity_on_all_allies_down = {
	weapon_trait_melee_common_equip_immunity_on_all_allies_down_buff = {
		{
			proc_events = {
				[buff_proc_events.on_ally_knocked_down] = 1
			}
		},
		{
			proc_events = {
				[buff_proc_events.on_ally_knocked_down] = 1
			}
		},
		{
			proc_events = {
				[buff_proc_events.on_ally_knocked_down] = 1
			}
		},
		{
			proc_events = {
				[buff_proc_events.on_ally_knocked_down] = 1
			}
		},
		{
			proc_events = {
				[buff_proc_events.on_ally_knocked_down] = 1
			}
		},
		{
			proc_events = {
				[buff_proc_events.on_ally_knocked_down] = 1
			}
		}
	}
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_push_hit_grants_increased_attack = {
	weapon_trait_melee_common_wield_push_hit_grants_increased_attack_buff = {
		{
			proc_events = {
				[buff_proc_events.on_push] = 1
			}
		},
		{
			proc_events = {
				[buff_proc_events.on_push] = 1
			}
		},
		{
			proc_events = {
				[buff_proc_events.on_push] = 1
			}
		},
		{
			proc_events = {
				[buff_proc_events.on_push] = 1
			}
		},
		{
			proc_events = {
				[buff_proc_events.on_push] = 1
			}
		},
		{
			proc_events = {
				[buff_proc_events.on_push] = 1
			}
		}
	}
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_on_block_break_grant_power_bonus = {
	weapon_trait_melee_common_wield_on_block_break_grant_power_bonus_buff = {
		{
			cooldown_duration = 4.25,
			active_duration = 3,
			proc_events = {
				[buff_proc_events.on_block] = 0.05
			},
			stat_buffs = {
				[buff_stat_buffs.power_level_modifier] = 0.25
			}
		},
		{
			cooldown_duration = 4,
			active_duration = 3,
			proc_events = {
				[buff_proc_events.on_block] = 0.075
			},
			stat_buffs = {
				[buff_stat_buffs.power_level_modifier] = 0.5
			}
		},
		{
			cooldown_duration = 3.75,
			active_duration = 3,
			proc_events = {
				[buff_proc_events.on_block] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.power_level_modifier] = 0.75
			}
		},
		{
			cooldown_duration = 3.5,
			active_duration = 3,
			proc_events = {
				[buff_proc_events.on_block] = 0.125
			},
			stat_buffs = {
				[buff_stat_buffs.power_level_modifier] = 1
			}
		},
		{
			cooldown_duration = 3.25,
			active_duration = 3,
			proc_events = {
				[buff_proc_events.on_block] = 0.15
			},
			stat_buffs = {
				[buff_stat_buffs.power_level_modifier] = 1.25
			}
		},
		{
			cooldown_duration = 3,
			active_duration = 3,
			proc_events = {
				[buff_proc_events.on_block] = 0.175
			},
			stat_buffs = {
				[buff_stat_buffs.power_level_modifier] = 1.5
			}
		}
	}
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_on_block_damage_bonus = {
	weapon_trait_melee_common_wield_on_block_damage_bonus_buff = {
		{
			cooldown_duration = 6.25,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_block] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.damage] = 0.25
			}
		},
		{
			cooldown_duration = 6,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_block] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.damage] = 0.5
			}
		},
		{
			cooldown_duration = 5.75,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_block] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.damage] = 0.75
			}
		},
		{
			cooldown_duration = 5.5,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_block] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.damage] = 1
			}
		},
		{
			cooldown_duration = 5.25,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_block] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.damage] = 1.25
			}
		},
		{
			cooldown_duration = 5,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_block] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.damage] = 1.5
			}
		}
	}
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_on_block_power_bonus = {
	weapon_trait_melee_common_wield_on_block_power_bonus_buff = {
		{
			cooldown_duration = 6.25,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_block] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.power_level_modifier] = 0.25
			}
		},
		{
			cooldown_duration = 6,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_block] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.power_level_modifier] = 0.5
			}
		},
		{
			cooldown_duration = 5.75,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_block] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.power_level_modifier] = 0.75
			}
		},
		{
			cooldown_duration = 5.5,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_block] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.power_level_modifier] = 1
			}
		},
		{
			cooldown_duration = 5.25,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_block] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.power_level_modifier] = 1.25
			}
		},
		{
			cooldown_duration = 5,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_block] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.power_level_modifier] = 1.5
			}
		}
	}
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_on_block_impact_bonus = {
	weapon_trait_melee_common_wield_on_block_impact_bonus_buff = {
		{
			cooldown_duration = 6.25,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_block] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.melee_impact_modifier] = 0.25
			}
		},
		{
			cooldown_duration = 6,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_block] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.melee_impact_modifier] = 0.5
			}
		},
		{
			cooldown_duration = 5.75,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_block] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.melee_impact_modifier] = 0.75
			}
		},
		{
			cooldown_duration = 5.5,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_block] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.melee_impact_modifier] = 1
			}
		},
		{
			cooldown_duration = 5.25,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_block] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.melee_impact_modifier] = 1.25
			}
		},
		{
			cooldown_duration = 5,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_block] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.melee_impact_modifier] = 1.5
			}
		}
	}
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_on_block_increased_unarmored_damage = {
	weapon_trait_melee_common_wield_on_block_increased_unarmored_damage_buff = {
		{
			cooldown_duration = 6.25,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_block] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.unarmored_damage] = 0.25
			}
		},
		{
			cooldown_duration = 6,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_block] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.unarmored_damage] = 0.5
			}
		},
		{
			cooldown_duration = 5.75,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_block] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.unarmored_damage] = 0.75
			}
		},
		{
			cooldown_duration = 5.5,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_block] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.unarmored_damage] = 1
			}
		},
		{
			cooldown_duration = 5.25,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_block] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.unarmored_damage] = 1.25
			}
		},
		{
			cooldown_duration = 5,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_block] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.unarmored_damage] = 1.5
			}
		}
	}
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_on_block_increased_armored_damage = {
	weapon_trait_melee_common_wield_on_block_increased_unarmored_damage_buff = {
		{
			cooldown_duration = 6.25,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_block] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.armored_damage] = 0.25
			}
		},
		{
			cooldown_duration = 6,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_block] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.armored_damage] = 0.5
			}
		},
		{
			cooldown_duration = 5.75,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_block] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.armored_damage] = 0.75
			}
		},
		{
			cooldown_duration = 5.5,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_block] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.armored_damage] = 1
			}
		},
		{
			cooldown_duration = 5.25,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_block] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.armored_damage] = 1.25
			}
		},
		{
			cooldown_duration = 5,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_block] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.armored_damage] = 1.5
			}
		}
	}
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_on_block_increased_resistant_damage = {
	weapon_trait_melee_common_wield_on_block_increased_resistant_damage_buff = {
		{
			cooldown_duration = 6.25,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_block] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.resistant_damage] = 0.25
			}
		},
		{
			cooldown_duration = 6,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_block] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.resistant_damage] = 0.5
			}
		},
		{
			cooldown_duration = 5.75,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_block] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.resistant_damage] = 0.75
			}
		},
		{
			cooldown_duration = 5.5,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_block] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.resistant_damage] = 1
			}
		},
		{
			cooldown_duration = 5.25,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_block] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.resistant_damage] = 1.25
			}
		},
		{
			cooldown_duration = 5,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_block] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.resistant_damage] = 1.5
			}
		}
	}
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_on_block_increased_berserker_damage = {
	weapon_trait_melee_common_wield_on_block_increased_berserker_damage_buff = {
		{
			cooldown_duration = 6.25,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_block] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.berserker_damage] = 0.25
			}
		},
		{
			cooldown_duration = 6,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_block] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.berserker_damage] = 0.5
			}
		},
		{
			cooldown_duration = 5.75,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_block] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.berserker_damage] = 0.75
			}
		},
		{
			cooldown_duration = 5.5,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_block] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.berserker_damage] = 1
			}
		},
		{
			cooldown_duration = 5.25,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_block] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.berserker_damage] = 1.25
			}
		},
		{
			cooldown_duration = 5,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_block] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.berserker_damage] = 1.5
			}
		}
	}
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_on_block_increased_super_armor_damage = {
	weapon_trait_melee_common_wield_on_block_increased_super_armor_damage_buff = {
		{
			cooldown_duration = 6.25,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_block] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.super_armor_damage] = 0.25
			}
		},
		{
			cooldown_duration = 6,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_block] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.super_armor_damage] = 0.5
			}
		},
		{
			cooldown_duration = 5.75,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_block] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.super_armor_damage] = 0.75
			}
		},
		{
			cooldown_duration = 5.5,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_block] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.super_armor_damage] = 1
			}
		},
		{
			cooldown_duration = 5.25,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_block] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.super_armor_damage] = 1.25
			}
		},
		{
			cooldown_duration = 5,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_block] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.super_armor_damage] = 1.5
			}
		}
	}
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_on_block_increased_disgustingly_resilient_damage = {
	weapon_trait_melee_common_wield_on_block_increased_disgustingly_resilient_damage_buff = {
		{
			cooldown_duration = 6.25,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_block] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.disgustingly_resilient_damage] = 0.25
			}
		},
		{
			cooldown_duration = 6,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_block] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.disgustingly_resilient_damage] = 0.5
			}
		},
		{
			cooldown_duration = 5.75,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_block] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.disgustingly_resilient_damage] = 0.75
			}
		},
		{
			cooldown_duration = 5.5,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_block] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.disgustingly_resilient_damage] = 1
			}
		},
		{
			cooldown_duration = 5.25,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_block] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.disgustingly_resilient_damage] = 1.25
			}
		},
		{
			cooldown_duration = 5,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_block] = 0.1
			},
			stat_buffs = {
				[buff_stat_buffs.disgustingly_resilient_damage] = 1.5
			}
		}
	}
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_on_weakspot_grant_power_bonus = {
	weapon_trait_melee_common_wield_on_weakspot_grant_power_bonus_buff = {
		{
			proc_events = {
				[buff_proc_events.on_hit] = 0.05
			}
		},
		{
			proc_events = {
				[buff_proc_events.on_hit] = 0.1
			}
		},
		{
			proc_events = {
				[buff_proc_events.on_hit] = 0.15
			}
		},
		{
			proc_events = {
				[buff_proc_events.on_hit] = 0.2
			}
		},
		{
			proc_events = {
				[buff_proc_events.on_hit] = 0.25
			}
		},
		{
			proc_events = {
				[buff_proc_events.on_hit] = 0.3
			}
		}
	}
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_on_weakspot_grant_bleeding = {
	weapon_trait_melee_common_wield_on_weakspot_grant_bleeding_buff = {
		{
			cooldown_duration = 6.25,
			proc_events = {
				[buff_proc_events.on_hit] = 0.075
			}
		},
		{
			cooldown_duration = 6,
			proc_events = {
				[buff_proc_events.on_hit] = 0.1
			}
		},
		{
			cooldown_duration = 5.75,
			proc_events = {
				[buff_proc_events.on_hit] = 0.125
			}
		},
		{
			cooldown_duration = 5.5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.15
			}
		},
		{
			cooldown_duration = 5.25,
			proc_events = {
				[buff_proc_events.on_hit] = 0.175
			}
		},
		{
			cooldown_duration = 5,
			proc_events = {
				[buff_proc_events.on_hit] = 0.2
			}
		}
	}
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_on_heavy_attack_kill_increase_attack = {
	weapon_trait_melee_common_wield_on_heavy_attack_kill_increase_attack_buff = {
		{
			cooldown_duration = 6.25,
			active_duration = 2,
			proc_events = {
				[buff_proc_events.on_hit] = 1
			},
			stat_buffs = {
				[buff_stat_buffs.melee_damage] = 0.125
			}
		},
		{
			cooldown_duration = 6,
			active_duration = 2,
			proc_events = {
				[buff_proc_events.on_hit] = 1
			},
			stat_buffs = {
				[buff_stat_buffs.melee_damage] = 0.15
			}
		},
		{
			cooldown_duration = 5.75,
			active_duration = 2,
			proc_events = {
				[buff_proc_events.on_hit] = 1
			},
			stat_buffs = {
				[buff_stat_buffs.melee_damage] = 0.175
			}
		},
		{
			cooldown_duration = 5.5,
			active_duration = 2.5,
			proc_events = {
				[buff_proc_events.on_hit] = 1
			},
			stat_buffs = {
				[buff_stat_buffs.melee_damage] = 0.2
			}
		},
		{
			cooldown_duration = 5.25,
			active_duration = 2.5,
			proc_events = {
				[buff_proc_events.on_hit] = 1
			},
			stat_buffs = {
				[buff_stat_buffs.melee_damage] = 0.225
			}
		},
		{
			cooldown_duration = 5,
			active_duration = 3,
			proc_events = {
				[buff_proc_events.on_hit] = 1
			},
			stat_buffs = {
				[buff_stat_buffs.melee_damage] = 0.25
			}
		}
	}
}
weapon_traits_melee_common.weapon_trait_melee_common_wield_on_heavy_attack_kill_increase_attack_speed = {
	weapon_trait_melee_common_wield_on_heavy_attack_kill_increase_attack_speed_buff = {
		{
			cooldown_duration = 5,
			active_duration = 1.5,
			proc_events = {
				[buff_proc_events.on_hit] = 1
			},
			stat_buffs = {
				[buff_stat_buffs.melee_attack_speed] = 0.5
			}
		},
		{
			cooldown_duration = 5,
			active_duration = 2,
			proc_events = {
				[buff_proc_events.on_hit] = 1
			},
			stat_buffs = {
				[buff_stat_buffs.melee_attack_speed] = 0.5
			}
		},
		{
			cooldown_duration = 5,
			active_duration = 2.25,
			proc_events = {
				[buff_proc_events.on_hit] = 1
			},
			stat_buffs = {
				[buff_stat_buffs.melee_attack_speed] = 0.5
			}
		},
		{
			cooldown_duration = 5,
			active_duration = 2.5,
			proc_events = {
				[buff_proc_events.on_hit] = 1
			},
			stat_buffs = {
				[buff_stat_buffs.melee_attack_speed] = 0.5
			}
		},
		{
			cooldown_duration = 5,
			active_duration = 2.75,
			proc_events = {
				[buff_proc_events.on_hit] = 1
			},
			stat_buffs = {
				[buff_stat_buffs.melee_attack_speed] = 0.5
			}
		},
		{
			cooldown_duration = 5,
			active_duration = 3,
			proc_events = {
				[buff_proc_events.on_hit] = 1
			},
			stat_buffs = {
				[buff_stat_buffs.melee_attack_speed] = 0.5
			}
		}
	}
}

return weapon_traits_melee_common
