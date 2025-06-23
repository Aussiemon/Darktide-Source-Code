-- chunkname: @scripts/settings/equipment/weapon_traits/weapon_traits_melee_activated.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local stat_buffs = BuffSettings.stat_buffs
local proc_events = BuffSettings.proc_events
local weapon_traits_melee_activated = {}

table.make_unique(weapon_traits_melee_activated)

weapon_traits_melee_activated.weapon_trait_melee_activated_wield_during_weapon_special_reduce_damage_taken = {
	format_values = {
		damage_taken = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_melee_activated_wield_during_weapon_special_reduce_damage_taken",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.damage_taken_multiplier
				}
			}
		}
	},
	buffs = {
		weapon_trait_melee_activated_wield_during_weapon_special_reduce_damage_taken = {
			{
				stat_buffs = {
					[stat_buffs.damage_taken_multiplier] = 0.85
				}
			},
			{
				stat_buffs = {
					[stat_buffs.damage_taken_multiplier] = 0.845
				}
			},
			{
				stat_buffs = {
					[stat_buffs.damage_taken_multiplier] = 0.835
				}
			},
			{
				stat_buffs = {
					[stat_buffs.damage_taken_multiplier] = 0.82
				}
			}
		}
	}
}
weapon_traits_melee_activated.weapon_trait_melee_activated_wield_during_weapon_special_increased_crit_chance = {
	format_values = {
		crit_chance = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_melee_activated_wield_during_weapon_special_increased_crit_chance",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.critical_strike_chance
				}
			}
		}
	},
	buffs = {
		weapon_trait_melee_activated_wield_during_weapon_special_increased_crit_chance = {
			{
				stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.1
				}
			},
			{
				stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.2
				}
			},
			{
				stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.3
				}
			},
			{
				stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.4
				}
			}
		}
	}
}
weapon_traits_melee_activated.weapon_trait_melee_activated_wield_during_weapon_special_increased_impact = {
	format_values = {
		impact = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_melee_activated_wield_during_weapon_special_increased_impact",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.melee_impact_modifier
				}
			}
		}
	},
	buffs = {
		weapon_trait_melee_activated_wield_during_weapon_special_increased_impact = {
			{
				stat_buffs = {
					[stat_buffs.melee_impact_modifier] = 0.1
				}
			},
			{
				stat_buffs = {
					[stat_buffs.melee_impact_modifier] = 0.2
				}
			},
			{
				stat_buffs = {
					[stat_buffs.melee_impact_modifier] = 0.3
				}
			},
			{
				stat_buffs = {
					[stat_buffs.melee_impact_modifier] = 0.4
				}
			}
		}
	}
}
weapon_traits_melee_activated.weapon_trait_melee_activated_wield_during_weapon_special_increased_attack = {
	format_values = {
		damage = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_melee_activated_wield_during_weapon_special_increased_attack",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.melee_damage
				}
			}
		}
	},
	buffs = {
		weapon_trait_melee_activated_wield_during_weapon_special_increased_attack = {
			{
				stat_buffs = {
					[stat_buffs.melee_damage] = 0.1
				}
			},
			{
				stat_buffs = {
					[stat_buffs.melee_damage] = 0.2
				}
			},
			{
				stat_buffs = {
					[stat_buffs.melee_damage] = 0.3
				}
			},
			{
				stat_buffs = {
					[stat_buffs.melee_damage] = 0.4
				}
			}
		}
	}
}
weapon_traits_melee_activated.weapon_trait_melee_activated_wield_during_weapon_special_increased_movement_speed = {
	format_values = {
		movement_speed = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_melee_activated_wield_during_weapon_special_increased_movement_speed",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.movement_speed
				}
			}
		}
	},
	buffs = {
		weapon_trait_melee_activated_wield_during_weapon_special_increased_movement_speed = {
			{
				stat_buffs = {
					[stat_buffs.movement_speed] = 0.1
				}
			},
			{
				stat_buffs = {
					[stat_buffs.movement_speed] = 0.2
				}
			},
			{
				stat_buffs = {
					[stat_buffs.movement_speed] = 0.3
				}
			},
			{
				stat_buffs = {
					[stat_buffs.movement_speed] = 0.4
				}
			}
		}
	}
}
weapon_traits_melee_activated.weapon_trait_melee_activated_wield_during_weapon_special_reduce_corruption_taken = {
	format_values = {
		damage_taken = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_melee_activated_wield_during_weapon_special_reduce_corruption_taken",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.corruption_taken_multiplier
				}
			}
		}
	},
	buffs = {
		weapon_trait_melee_activated_wield_during_weapon_special_reduce_corruption_taken = {
			{
				stat_buffs = {
					[stat_buffs.corruption_taken_multiplier] = 0.85
				}
			},
			{
				stat_buffs = {
					[stat_buffs.corruption_taken_multiplier] = 0.845
				}
			},
			{
				stat_buffs = {
					[stat_buffs.corruption_taken_multiplier] = 0.835
				}
			},
			{
				stat_buffs = {
					[stat_buffs.corruption_taken_multiplier] = 0.82
				}
			}
		}
	}
}
weapon_traits_melee_activated.weapon_trait_melee_activated_wield_during_weapon_special_reduce_toughness_taken = {
	format_values = {
		damage_taken = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_melee_activated_wield_during_weapon_special_reduce_toughness_taken",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.toughness_damage_taken_multiplier
				}
			}
		}
	},
	buffs = {
		weapon_trait_melee_activated_wield_during_weapon_special_reduce_toughness_taken = {
			{
				stat_buffs = {
					[stat_buffs.toughness_damage_taken_multiplier] = 0.85
				}
			},
			{
				stat_buffs = {
					[stat_buffs.toughness_damage_taken_multiplier] = 0.845
				}
			},
			{
				stat_buffs = {
					[stat_buffs.toughness_damage_taken_multiplier] = 0.835
				}
			},
			{
				stat_buffs = {
					[stat_buffs.toughness_damage_taken_multiplier] = 0.82
				}
			}
		}
	}
}
weapon_traits_melee_activated.weapon_trait_melee_activated_wield_during_weapon_special_finesse_bonus = {
	format_values = {
		finesse = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_melee_activated_wield_during_weapon_special_finesse_bonus",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.finesse_modifier_bonus
				}
			}
		}
	},
	buffs = {
		weapon_trait_melee_activated_wield_during_weapon_special_finesse_bonus = {
			{
				stat_buffs = {
					[stat_buffs.finesse_modifier_bonus] = 0.1
				}
			},
			{
				stat_buffs = {
					[stat_buffs.finesse_modifier_bonus] = 0.2
				}
			},
			{
				stat_buffs = {
					[stat_buffs.finesse_modifier_bonus] = 0.3
				}
			},
			{
				stat_buffs = {
					[stat_buffs.finesse_modifier_bonus] = 0.4
				}
			}
		}
	}
}
weapon_traits_melee_activated.weapon_trait_melee_activated_wield_during_weapon_special_increase_damage_vs_unarmored = {
	format_values = {
		damage = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_melee_activated_wield_during_weapon_special_increase_damage_vs_unarmored",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.unarmored_damage
				}
			}
		}
	},
	buffs = {
		weapon_trait_melee_activated_wield_during_weapon_special_increase_damage_vs_unarmored = {
			{
				stat_buffs = {
					[stat_buffs.unarmored_damage] = 0.1
				}
			},
			{
				stat_buffs = {
					[stat_buffs.unarmored_damage] = 0.2
				}
			},
			{
				stat_buffs = {
					[stat_buffs.unarmored_damage] = 0.3
				}
			},
			{
				stat_buffs = {
					[stat_buffs.unarmored_damage] = 0.4
				}
			}
		}
	}
}
weapon_traits_melee_activated.weapon_trait_melee_activated_wield_during_weapon_special_increase_damage_vs_armored = {
	format_values = {
		damage = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_melee_activated_wield_during_weapon_special_increase_damage_vs_armored",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.armored_damage
				}
			}
		}
	},
	buffs = {
		weapon_trait_melee_activated_wield_during_weapon_special_increase_damage_vs_armored = {
			{
				stat_buffs = {
					[stat_buffs.armored_damage] = 0.1
				}
			},
			{
				stat_buffs = {
					[stat_buffs.armored_damage] = 0.2
				}
			},
			{
				stat_buffs = {
					[stat_buffs.armored_damage] = 0.3
				}
			},
			{
				stat_buffs = {
					[stat_buffs.armored_damage] = 0.4
				}
			}
		}
	}
}
weapon_traits_melee_activated.weapon_trait_melee_activated_wield_during_weapon_special_increase_damage_vs_resistant = {
	format_values = {
		damage = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_melee_activated_wield_during_weapon_special_increase_damage_vs_resistant",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.resistant_damage
				}
			}
		}
	},
	buffs = {
		weapon_trait_melee_activated_wield_during_weapon_special_increase_damage_vs_resistant = {
			{
				stat_buffs = {
					[stat_buffs.resistant_damage] = 0.1
				}
			},
			{
				stat_buffs = {
					[stat_buffs.resistant_damage] = 0.2
				}
			},
			{
				stat_buffs = {
					[stat_buffs.resistant_damage] = 0.3
				}
			},
			{
				stat_buffs = {
					[stat_buffs.resistant_damage] = 0.4
				}
			}
		}
	}
}
weapon_traits_melee_activated.weapon_trait_melee_activated_wield_during_weapon_special_increase_damage_vs_berserker = {
	format_values = {
		damage = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_melee_activated_wield_during_weapon_special_increase_damage_vs_berserker",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.berserker_damage
				}
			}
		}
	},
	buffs = {
		weapon_trait_melee_activated_wield_during_weapon_special_increase_damage_vs_berserker = {
			{
				stat_buffs = {
					[stat_buffs.berserker_damage] = 0.1
				}
			},
			{
				stat_buffs = {
					[stat_buffs.berserker_damage] = 0.2
				}
			},
			{
				stat_buffs = {
					[stat_buffs.berserker_damage] = 0.3
				}
			},
			{
				stat_buffs = {
					[stat_buffs.berserker_damage] = 0.4
				}
			}
		}
	}
}
weapon_traits_melee_activated.weapon_trait_melee_activated_wield_during_weapon_special_increase_damage_vs_super_armor = {
	format_values = {
		damage = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_melee_activated_wield_during_weapon_special_increase_damage_vs_super_armor",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.super_armor_damage
				}
			}
		}
	},
	buffs = {
		weapon_trait_melee_activated_wield_during_weapon_special_increase_damage_vs_super_armor = {
			{
				stat_buffs = {
					[stat_buffs.super_armor_damage] = 0.1
				}
			},
			{
				stat_buffs = {
					[stat_buffs.super_armor_damage] = 0.2
				}
			},
			{
				stat_buffs = {
					[stat_buffs.super_armor_damage] = 0.3
				}
			},
			{
				stat_buffs = {
					[stat_buffs.super_armor_damage] = 0.4
				}
			}
		}
	}
}
weapon_traits_melee_activated.weapon_trait_melee_activated_wield_during_weapon_special_increase_damage_vs_disgustingly_resilient = {
	format_values = {
		damage = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_melee_activated_wield_during_weapon_special_increase_damage_vs_disgustingly_resilient",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.disgustingly_resilient_damage
				}
			}
		}
	},
	buffs = {
		weapon_trait_melee_activated_wield_during_weapon_special_increase_damage_vs_disgustingly_resilient = {
			{
				stat_buffs = {
					[stat_buffs.disgustingly_resilient_damage] = 0.1
				}
			},
			{
				stat_buffs = {
					[stat_buffs.disgustingly_resilient_damage] = 0.2
				}
			},
			{
				stat_buffs = {
					[stat_buffs.disgustingly_resilient_damage] = 0.3
				}
			},
			{
				stat_buffs = {
					[stat_buffs.disgustingly_resilient_damage] = 0.4
				}
			}
		}
	}
}
weapon_traits_melee_activated.weapon_trait_melee_activated_wield_on_weapon_special_increase_impact_of_next_attack = {
	buffs = {
		weapon_trait_melee_activated_wield_on_weapon_special_increase_impact_of_next_attack = {
			{},
			{},
			{},
			{}
		}
	}
}
weapon_traits_melee_activated.weapon_trait_melee_activated_wield_on_weapon_special_increase_attack_of_next_attack = {
	buffs = {
		weapon_trait_melee_activated_wield_on_weapon_special_increase_attack_of_next_attack = {
			{},
			{},
			{},
			{}
		}
	}
}
weapon_traits_melee_activated.weapon_trait_melee_activated_wield_on_weapon_special_kill_chance_to_increase_attack = {
	format_values = {
		chance = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_melee_activated_wield_on_weapon_special_kill_chance_to_increase_attack",
				find_value_type = "trait_override",
				path = {
					"proc_events",
					proc_events.on_kill
				}
			}
		},
		damage = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_melee_activated_wield_on_weapon_special_kill_chance_to_increase_attack",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.melee_damage
				}
			}
		},
		duration = {
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_melee_activated_wield_on_weapon_special_kill_chance_to_increase_attack",
				find_value_type = "trait_override",
				path = {
					"active_duration"
				}
			}
		},
		cooldown = {
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_melee_activated_wield_on_weapon_special_kill_chance_to_increase_attack",
				find_value_type = "trait_override",
				path = {
					"cooldown_duration"
				}
			}
		}
	},
	buffs = {
		weapon_trait_melee_activated_wield_on_weapon_special_kill_chance_to_increase_attack = {
			{
				cooldown_duration = 0,
				active_duration = 5,
				proc_events = {
					[proc_events.on_kill] = 0.33
				},
				stat_buffs = {
					[stat_buffs.melee_damage] = 0.1
				}
			},
			{
				cooldown_duration = 0,
				active_duration = 5,
				proc_events = {
					[proc_events.on_kill] = 0.33
				},
				stat_buffs = {
					[stat_buffs.melee_damage] = 0.2
				}
			},
			{
				cooldown_duration = 0,
				active_duration = 5,
				proc_events = {
					[proc_events.on_kill] = 0.33
				},
				stat_buffs = {
					[stat_buffs.melee_damage] = 0.3
				}
			},
			{
				cooldown_duration = 0,
				active_duration = 5,
				proc_events = {
					[proc_events.on_kill] = 0.33
				},
				stat_buffs = {
					[stat_buffs.melee_damage] = 0.4
				}
			}
		}
	}
}
weapon_traits_melee_activated.weapon_trait_melee_activated_wield_on_weapon_special_kill_chance_to_increase_impact = {
	format_values = {
		chance = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_melee_activated_wield_on_weapon_special_kill_chance_to_increase_impact",
				find_value_type = "trait_override",
				path = {
					"proc_events",
					proc_events.on_kill
				}
			}
		},
		impact = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_melee_activated_wield_on_weapon_special_kill_chance_to_increase_impact",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.melee_impact_modifier
				}
			}
		},
		duration = {
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_melee_activated_wield_on_weapon_special_kill_chance_to_increase_impact",
				find_value_type = "trait_override",
				path = {
					"active_duration"
				}
			}
		},
		cooldown = {
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_melee_activated_wield_on_weapon_special_kill_chance_to_increase_impact",
				find_value_type = "trait_override",
				path = {
					"cooldown_duration"
				}
			}
		}
	},
	buffs = {
		weapon_trait_melee_activated_wield_on_weapon_special_kill_chance_to_increase_impact = {
			{
				cooldown_duration = 0,
				active_duration = 5,
				proc_events = {
					[proc_events.on_kill] = 0.33
				},
				stat_buffs = {
					[stat_buffs.melee_impact_modifier] = 0.1
				}
			},
			{
				cooldown_duration = 0,
				active_duration = 5,
				proc_events = {
					[proc_events.on_kill] = 0.33
				},
				stat_buffs = {
					[stat_buffs.melee_impact_modifier] = 0.2
				}
			},
			{
				cooldown_duration = 0,
				active_duration = 5,
				proc_events = {
					[proc_events.on_kill] = 0.33
				},
				stat_buffs = {
					[stat_buffs.melee_impact_modifier] = 0.3
				}
			},
			{
				cooldown_duration = 0,
				active_duration = 5,
				proc_events = {
					[proc_events.on_kill] = 0.33
				},
				stat_buffs = {
					[stat_buffs.melee_impact_modifier] = 0.4
				}
			}
		}
	}
}
weapon_traits_melee_activated.weapon_trait_melee_activated_wield_on_weapon_special_kill_chance_to_increase_finesse_modifier_bonus = {
	format_values = {
		chance = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_melee_activated_wield_on_weapon_special_kill_chance_to_increase_finesse_modifier_bonus",
				find_value_type = "trait_override",
				path = {
					"proc_events",
					proc_events.on_kill
				}
			}
		},
		finesse = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_melee_activated_wield_on_weapon_special_kill_chance_to_increase_finesse_modifier_bonus",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.finesse_modifier_bonus
				}
			}
		},
		duration = {
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_melee_activated_wield_on_weapon_special_kill_chance_to_increase_finesse_modifier_bonus",
				find_value_type = "trait_override",
				path = {
					"active_duration"
				}
			}
		},
		cooldown = {
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_melee_activated_wield_on_weapon_special_kill_chance_to_increase_finesse_modifier_bonus",
				find_value_type = "trait_override",
				path = {
					"cooldown_duration"
				}
			}
		}
	},
	buffs = {
		weapon_trait_melee_activated_wield_on_weapon_special_kill_chance_to_increase_finesse_modifier_bonus = {
			{
				cooldown_duration = 0,
				active_duration = 5,
				proc_events = {
					[proc_events.on_kill] = 0.33
				},
				stat_buffs = {
					[stat_buffs.finesse_modifier_bonus] = 0.1
				}
			},
			{
				cooldown_duration = 0,
				active_duration = 5,
				proc_events = {
					[proc_events.on_kill] = 0.33
				},
				stat_buffs = {
					[stat_buffs.finesse_modifier_bonus] = 0.2
				}
			},
			{
				cooldown_duration = 0,
				active_duration = 5,
				proc_events = {
					[proc_events.on_kill] = 0.33
				},
				stat_buffs = {
					[stat_buffs.finesse_modifier_bonus] = 0.3
				}
			},
			{
				cooldown_duration = 0,
				active_duration = 5,
				proc_events = {
					[proc_events.on_kill] = 0.33
				},
				stat_buffs = {
					[stat_buffs.finesse_modifier_bonus] = 0.4
				}
			}
		}
	}
}
weapon_traits_melee_activated.weapon_trait_melee_activated_wield_on_weapon_special_kill_chance_to_replenish_toughness = {
	format_values = {
		chance = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_melee_activated_wield_on_weapon_special_kill_chance_to_replenish_toughness",
				find_value_type = "trait_override",
				path = {
					"proc_events",
					proc_events.on_kill
				}
			}
		},
		toughness = {
			value = "25",
			format_type = "string"
		}
	},
	buffs = {
		weapon_trait_melee_activated_wield_on_weapon_special_kill_chance_to_replenish_toughness = {
			{
				proc_events = {
					[proc_events.on_kill] = 0.175
				}
			},
			{
				proc_events = {
					[proc_events.on_kill] = 0.2
				}
			},
			{
				proc_events = {
					[proc_events.on_kill] = 0.225
				}
			},
			{
				proc_events = {
					[proc_events.on_kill] = 0.25
				}
			}
		}
	}
}
weapon_traits_melee_activated.weapon_trait_melee_activated_wield_on_weapon_special_kill_chance_to_remove_corruption = {
	format_values = {
		chance = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_melee_activated_wield_on_weapon_special_kill_chance_to_remove_corruption",
				find_value_type = "trait_override",
				path = {
					"proc_events",
					proc_events.on_kill
				}
			}
		},
		corruption = {
			value = "25",
			format_type = "string"
		}
	},
	buffs = {
		weapon_trait_melee_activated_wield_on_weapon_special_kill_chance_to_remove_corruption = {
			{
				proc_events = {
					[proc_events.on_kill] = 0.175
				}
			},
			{
				proc_events = {
					[proc_events.on_kill] = 0.2
				}
			},
			{
				proc_events = {
					[proc_events.on_kill] = 0.225
				}
			},
			{
				proc_events = {
					[proc_events.on_kill] = 0.25
				}
			}
		}
	}
}

return weapon_traits_melee_activated
