-- chunkname: @scripts/settings/equipment/weapon_traits/weapon_traits_melee_activated.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
local buff_targets = WeaponTweakTemplateSettings.buff_targets
local buff_keywords = BuffSettings.keywords
local buff_stat_buffs = BuffSettings.stat_buffs
local buff_proc_events = BuffSettings.proc_events
local weapon_traits_melee_activated = {}

weapon_traits_melee_activated.weapon_trait_melee_activated_wield_during_weapon_special_reduce_damage_taken = {
	weapon_trait_melee_activated_wield_during_weapon_special_reduce_damage_taken = {
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
		}
	}
}
weapon_traits_melee_activated.weapon_trait_melee_activated_wield_during_weapon_special_increased_crit_chance = {
	weapon_trait_melee_activated_wield_during_weapon_special_increased_crit_chance = {
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
weapon_traits_melee_activated.weapon_trait_melee_activated_wield_during_weapon_special_increased_impact = {
	weapon_trait_melee_activated_wield_during_weapon_special_increased_impact = {
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
		}
	}
}
weapon_traits_melee_activated.weapon_trait_melee_activated_wield_during_weapon_special_increased_attack = {
	weapon_trait_melee_activated_wield_during_weapon_special_increased_attack = {
		{
			stat_buffs = {
				[buff_stat_buffs.melee_damage] = 0.1
			}
		},
		{
			stat_buffs = {
				[buff_stat_buffs.melee_damage] = 0.2
			}
		},
		{
			stat_buffs = {
				[buff_stat_buffs.melee_damage] = 0.3
			}
		},
		{
			stat_buffs = {
				[buff_stat_buffs.melee_damage] = 0.4
			}
		}
	}
}
weapon_traits_melee_activated.weapon_trait_melee_activated_wield_during_weapon_special_increased_movement_speed = {
	weapon_trait_melee_activated_wield_during_weapon_special_increased_movement_speed = {
		{
			stat_buffs = {
				[buff_stat_buffs.movement_speed] = 0.1
			}
		},
		{
			stat_buffs = {
				[buff_stat_buffs.movement_speed] = 0.2
			}
		},
		{
			stat_buffs = {
				[buff_stat_buffs.movement_speed] = 0.3
			}
		},
		{
			stat_buffs = {
				[buff_stat_buffs.movement_speed] = 0.4
			}
		}
	}
}
weapon_traits_melee_activated.weapon_trait_melee_activated_wield_during_weapon_special_reduce_corruption_taken = {
	weapon_trait_melee_activated_wield_during_weapon_special_reduce_corruption_taken = {
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
		}
	}
}
weapon_traits_melee_activated.weapon_trait_melee_activated_wield_during_weapon_special_reduce_toughness_taken = {
	weapon_trait_melee_activated_wield_during_weapon_special_reduce_toughness_taken = {
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
		}
	}
}
weapon_traits_melee_activated.weapon_trait_melee_activated_wield_during_weapon_special_finesse_bonus = {
	weapon_trait_melee_activated_wield_during_weapon_special_finesse_bonus = {
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
weapon_traits_melee_activated.weapon_trait_melee_activated_wield_during_weapon_special_increase_damage_vs_unarmored = {
	weapon_trait_melee_activated_wield_during_weapon_special_increase_damage_vs_unarmored = {
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
weapon_traits_melee_activated.weapon_trait_melee_activated_wield_during_weapon_special_increase_damage_vs_armored = {
	weapon_trait_melee_activated_wield_during_weapon_special_increase_damage_vs_armored = {
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
weapon_traits_melee_activated.weapon_trait_melee_activated_wield_during_weapon_special_increase_damage_vs_resistant = {
	weapon_trait_melee_activated_wield_during_weapon_special_increase_damage_vs_resistant = {
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
weapon_traits_melee_activated.weapon_trait_melee_activated_wield_during_weapon_special_increase_damage_vs_berserker = {
	weapon_trait_melee_activated_wield_during_weapon_special_increase_damage_vs_berserker = {
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
weapon_traits_melee_activated.weapon_trait_melee_activated_wield_during_weapon_special_increase_damage_vs_super_armor = {
	weapon_trait_melee_activated_wield_during_weapon_special_increase_damage_vs_super_armor = {
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
weapon_traits_melee_activated.weapon_trait_melee_activated_wield_during_weapon_special_increase_damage_vs_disgustingly_resilient_damage = {
	weapon_trait_melee_activated_wield_during_weapon_special_increase_damage_vs_disgustingly_resilient_damage = {
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
weapon_traits_melee_activated.weapon_trait_melee_activated_wield_on_weapon_special_increase_impact_of_next_attack = {
	weapon_trait_melee_activated_wield_on_weapon_special_increase_impact_of_next_attack = {
		{},
		{},
		{},
		{}
	}
}
weapon_traits_melee_activated.weapon_trait_melee_activated_wield_on_weapon_special_increase_attack_of_next_attack = {
	weapon_trait_melee_activated_wield_on_weapon_special_increase_attack_of_next_attack = {
		{},
		{},
		{},
		{}
	}
}
weapon_traits_melee_activated.weapon_trait_melee_activated_wield_on_weapon_special_kill_chance_to_increase_attack = {
	weapon_trait_melee_activated_wield_on_weapon_special_kill_chance_to_increase_attack = {
		{
			cooldown_duration = 0,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_kill] = 0.33
			},
			stat_buffs = {
				[buff_stat_buffs.melee_damage] = 0.1
			}
		},
		{
			cooldown_duration = 0,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_kill] = 0.33
			},
			stat_buffs = {
				[buff_stat_buffs.melee_damage] = 0.2
			}
		},
		{
			cooldown_duration = 0,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_kill] = 0.33
			},
			stat_buffs = {
				[buff_stat_buffs.melee_damage] = 0.3
			}
		},
		{
			cooldown_duration = 0,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_kill] = 0.33
			},
			stat_buffs = {
				[buff_stat_buffs.melee_damage] = 0.4
			}
		}
	}
}
weapon_traits_melee_activated.weapon_trait_melee_activated_wield_on_weapon_special_kill_chance_to_increase_impact = {
	weapon_trait_melee_activated_wield_on_weapon_special_kill_chance_to_increase_impact = {
		{
			cooldown_duration = 0,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_kill] = 0.33
			},
			stat_buffs = {
				[buff_stat_buffs.melee_impact_modifier] = 0.1
			}
		},
		{
			cooldown_duration = 0,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_kill] = 0.33
			},
			stat_buffs = {
				[buff_stat_buffs.melee_impact_modifier] = 0.2
			}
		},
		{
			cooldown_duration = 0,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_kill] = 0.33
			},
			stat_buffs = {
				[buff_stat_buffs.melee_impact_modifier] = 0.3
			}
		},
		{
			cooldown_duration = 0,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_kill] = 0.33
			},
			stat_buffs = {
				[buff_stat_buffs.melee_impact_modifier] = 0.4
			}
		}
	}
}
weapon_traits_melee_activated.weapon_trait_melee_activated_wield_on_weapon_special_kill_chance_to_increase_finesse_modifier_bonus = {
	weapon_trait_melee_activated_wield_on_weapon_special_kill_chance_to_increase_finesse_modifier_bonus = {
		{
			cooldown_duration = 0,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_kill] = 0.33
			},
			stat_buffs = {
				[buff_stat_buffs.finesse_modifier_bonus] = 0.1
			}
		},
		{
			cooldown_duration = 0,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_kill] = 0.33
			},
			stat_buffs = {
				[buff_stat_buffs.finesse_modifier_bonus] = 0.2
			}
		},
		{
			cooldown_duration = 0,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_kill] = 0.33
			},
			stat_buffs = {
				[buff_stat_buffs.finesse_modifier_bonus] = 0.3
			}
		},
		{
			cooldown_duration = 0,
			active_duration = 5,
			proc_events = {
				[buff_proc_events.on_kill] = 0.33
			},
			stat_buffs = {
				[buff_stat_buffs.finesse_modifier_bonus] = 0.4
			}
		}
	}
}
weapon_traits_melee_activated.weapon_trait_melee_activated_wield_on_weapon_special_kill_chance_to_replenish_toughness = {
	weapon_trait_melee_activated_wield_on_weapon_special_kill_chance_to_replenish_toughness = {
		{
			proc_events = {
				[buff_proc_events.on_kill] = 0.175
			}
		},
		{
			proc_events = {
				[buff_proc_events.on_kill] = 0.2
			}
		},
		{
			proc_events = {
				[buff_proc_events.on_kill] = 0.225
			}
		},
		{
			proc_events = {
				[buff_proc_events.on_kill] = 0.25
			}
		}
	}
}
weapon_traits_melee_activated.weapon_trait_melee_activated_wield_on_weapon_special_kill_chance_to_remove_corruption = {
	weapon_trait_melee_activated_wield_on_weapon_special_kill_chance_to_remove_corruption = {
		{
			proc_events = {
				[buff_proc_events.on_kill] = 0.175
			}
		},
		{
			proc_events = {
				[buff_proc_events.on_kill] = 0.2
			}
		},
		{
			proc_events = {
				[buff_proc_events.on_kill] = 0.225
			}
		},
		{
			proc_events = {
				[buff_proc_events.on_kill] = 0.25
			}
		}
	}
}

return weapon_traits_melee_activated
