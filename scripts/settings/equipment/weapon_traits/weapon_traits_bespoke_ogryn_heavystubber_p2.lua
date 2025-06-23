-- chunkname: @scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_ogryn_heavystubber_p2.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local stat_buffs = BuffSettings.stat_buffs
local templates = {}

table.make_unique(templates)

templates.weapon_trait_bespoke_ogryn_heavystubber_p2_consecutive_hits_increases_ranged_power = {
	format_values = {
		power = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_heavystubber_p2_consecutive_hits_increases_ranged_power_parent",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.ranged_power_level_modifier
				}
			}
		},
		hit = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_heavystubber_p2_consecutive_hits_increases_ranged_power_parent",
				find_value_type = "trait_override",
				path = {
					"number_of_hits_per_stack"
				}
			}
		},
		time = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_heavystubber_p2_consecutive_hits_increases_ranged_power_parent",
				find_value_type = "trait_override",
				path = {
					"child_duration"
				}
			}
		},
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_heavystubber_p2_consecutive_hits_increases_ranged_power_parent",
				find_value_type = "trait_override",
				path = {
					"child_max_stacks"
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_ogryn_heavystubber_p2_consecutive_hits_increases_ranged_power_parent = {
			{
				child_max_stacks = 5,
				number_of_hits_per_stack = 1,
				child_duration = 2,
				stat_buffs = {
					[stat_buffs.ranged_power_level_modifier] = 0.07
				}
			},
			{
				child_max_stacks = 5,
				number_of_hits_per_stack = 1,
				child_duration = 2,
				stat_buffs = {
					[stat_buffs.ranged_power_level_modifier] = 0.08
				}
			},
			{
				child_max_stacks = 5,
				number_of_hits_per_stack = 1,
				child_duration = 2,
				stat_buffs = {
					[stat_buffs.ranged_power_level_modifier] = 0.09
				}
			},
			{
				child_max_stacks = 5,
				number_of_hits_per_stack = 1,
				child_duration = 2,
				stat_buffs = {
					[stat_buffs.ranged_power_level_modifier] = 0.1
				}
			}
		}
	}
}
templates.weapon_trait_bespoke_ogryn_heavystubber_p2_toughness_on_continuous_fire = {
	format_values = {
		toughness = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_heavystubber_p2_toughness_on_continuous_fire",
				find_value_type = "trait_override",
				path = {
					"toughness_fixed_percentage"
				}
			}
		},
		ammo = {
			value = "10%",
			format_type = "string"
		},
		stacks = {
			value = "5",
			format_type = "string"
		}
	},
	buffs = {
		weapon_trait_bespoke_ogryn_heavystubber_p2_toughness_on_continuous_fire = {
			{
				toughness_fixed_percentage = 0.01
			},
			{
				toughness_fixed_percentage = 0.02
			},
			{
				toughness_fixed_percentage = 0.03
			},
			{
				toughness_fixed_percentage = 0.04
			}
		}
	}
}
templates.weapon_trait_bespoke_ogryn_heavystubber_p2_movement_speed_on_continous_fire = {
	format_values = {
		movement_speed = {
			prefix = "-",
			num_decimals = 0,
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_heavystubber_p2_movement_speed_on_continous_fire",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.alternate_fire_movement_speed_reduction_modifier
				}
			},
			value_manipulation = function (value)
				return 100 - math.round(value * 100)
			end
		},
		ammo = {
			value = "5%",
			format_type = "string"
		},
		stacks = {
			value = "5",
			format_type = "string"
		}
	},
	buffs = {
		weapon_trait_bespoke_ogryn_heavystubber_p2_movement_speed_on_continous_fire = {
			{
				stat_buffs = {
					[stat_buffs.alternate_fire_movement_speed_reduction_modifier] = 0.93,
					[stat_buffs.weapon_action_movespeed_reduction_multiplier] = 0.93
				}
			},
			{
				stat_buffs = {
					[stat_buffs.alternate_fire_movement_speed_reduction_modifier] = 0.92,
					[stat_buffs.weapon_action_movespeed_reduction_multiplier] = 0.92
				}
			},
			{
				stat_buffs = {
					[stat_buffs.alternate_fire_movement_speed_reduction_modifier] = 0.91,
					[stat_buffs.weapon_action_movespeed_reduction_multiplier] = 0.91
				}
			},
			{
				stat_buffs = {
					[stat_buffs.alternate_fire_movement_speed_reduction_modifier] = 0.9,
					[stat_buffs.weapon_action_movespeed_reduction_multiplier] = 0.9
				}
			}
		}
	}
}
templates.weapon_trait_bespoke_ogryn_heavystubber_p2_suppression_on_close_kill = {
	format_values = {
		range = {
			format_type = "string",
			find_value = {
				find_value_type = "rarity_value",
				trait_value = {
					"5m",
					"6m",
					"7m",
					"8m"
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_ogryn_heavystubber_p2_suppression_on_close_kill = {
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
	}
}
templates.weapon_trait_bespoke_ogryn_heavystubber_p2_increase_power_on_close_kill = {
	format_values = {
		power_level = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_heavystubber_p2_increase_power_on_close_kill_parent",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.power_level_modifier
				}
			}
		},
		time = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_heavystubber_p2_increase_power_on_close_kill_parent",
				find_value_type = "trait_override",
				path = {
					"child_duration"
				}
			}
		},
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_heavystubber_p2_increase_power_on_close_kill_child",
				find_value_type = "buff_template",
				path = {
					"max_stacks"
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_ogryn_heavystubber_p2_increase_power_on_close_kill_parent = {
			{
				child_duration = 3.5,
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.05
				}
			},
			{
				child_duration = 3.5,
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.055
				}
			},
			{
				child_duration = 3.5,
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.06
				}
			},
			{
				child_duration = 3.5,
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.065
				}
			}
		}
	}
}
templates.weapon_trait_bespoke_ogryn_heavystubber_p2_increased_suppression_on_continuous_fire = {
	format_values = {
		suppression = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_heavystubber_p2_increased_suppression_on_continuous_fire",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.suppression_dealt
				}
			}
		},
		damage_vs_suppressed = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_heavystubber_p2_increased_suppression_on_continuous_fire",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.damage_vs_suppressed
				}
			}
		},
		ammo = {
			value = "2.5%",
			format_type = "string"
		},
		stacks = {
			value = "5",
			format_type = "string"
		}
	},
	buffs = {
		weapon_trait_bespoke_ogryn_heavystubber_p2_increased_suppression_on_continuous_fire = {
			{
				stat_buffs = {
					[stat_buffs.suppression_dealt] = 0.2,
					[stat_buffs.damage_vs_suppressed] = 0.06
				}
			},
			{
				stat_buffs = {
					[stat_buffs.suppression_dealt] = 0.2,
					[stat_buffs.damage_vs_suppressed] = 0.06
				}
			},
			{
				stat_buffs = {
					[stat_buffs.suppression_dealt] = 0.2,
					[stat_buffs.damage_vs_suppressed] = 0.06
				}
			},
			{
				stat_buffs = {
					[stat_buffs.suppression_dealt] = 0.2,
					[stat_buffs.damage_vs_suppressed] = 0.06
				}
			}
		}
	}
}
templates.weapon_trait_bespoke_ogryn_heavystubber_p2_ammo_from_reserve_on_crit = {
	format_values = {
		bullet_amount = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_heavystubber_p2_ammo_from_reserve_on_crit",
				find_value_type = "trait_override",
				path = {
					"num_ammmo_to_move"
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_ogryn_heavystubber_p2_ammo_from_reserve_on_crit = {
			{
				num_ammmo_to_move = 1,
				reload_speed = 0.06
			},
			{
				num_ammmo_to_move = 1,
				reload_speed = 0.09
			},
			{
				num_ammmo_to_move = 1,
				reload_speed = 0.12
			},
			{
				num_ammmo_to_move = 1,
				reload_speed = 0.15
			}
		}
	}
}
templates.weapon_trait_bespoke_ogryn_heavystubber_p2_increase_close_damage_on_close_kill = {
	format_values = {
		close_damage = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_heavystubber_p2_increase_close_damage_on_close_kill_parent",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.damage_near
				}
			}
		},
		time = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_heavystubber_p2_increase_close_damage_on_close_kill_parent",
				find_value_type = "trait_override",
				path = {
					"child_duration"
				}
			}
		},
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_heavystubber_p2_increase_close_damage_on_close_kill_child",
				find_value_type = "buff_template",
				path = {
					"max_stacks"
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_ogryn_heavystubber_p2_increase_close_damage_on_close_kill_parent = {
			{
				child_duration = 3.5,
				stat_buffs = {
					[stat_buffs.damage_near] = 0.07
				}
			},
			{
				child_duration = 3.5,
				stat_buffs = {
					[stat_buffs.damage_near] = 0.08
				}
			},
			{
				child_duration = 3.5,
				stat_buffs = {
					[stat_buffs.damage_near] = 0.09
				}
			},
			{
				child_duration = 3.5,
				stat_buffs = {
					[stat_buffs.damage_near] = 0.1
				}
			}
		}
	}
}
templates.weapon_trait_bespoke_ogryn_heavystubber_p2_recoil_reduction_and_suppression_increase_on_close_kills = {
	format_values = {
		recoil_reduction = {
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_heavystubber_p2_recoil_reduction_and_suppression_increase_on_close_kills",
				find_value_type = "trait_override",
				path = {
					"proc_stat_buffs",
					stat_buffs.recoil_modifier
				}
			}
		},
		suppression = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_heavystubber_p2_recoil_reduction_and_suppression_increase_on_close_kills",
				find_value_type = "trait_override",
				path = {
					"proc_stat_buffs",
					stat_buffs.suppression_dealt
				}
			}
		},
		damage = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_heavystubber_p2_recoil_reduction_and_suppression_increase_on_close_kills",
				find_value_type = "trait_override",
				path = {
					"proc_stat_buffs",
					stat_buffs.damage_vs_suppressed
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_ogryn_heavystubber_p2_recoil_reduction_and_suppression_increase_on_close_kills = {
			{
				proc_stat_buffs = {
					[stat_buffs.recoil_modifier] = -0.28,
					[stat_buffs.suppression_dealt] = 0.28,
					[stat_buffs.damage_vs_suppressed] = 0.14
				}
			},
			{
				proc_stat_buffs = {
					[stat_buffs.recoil_modifier] = -0.32,
					[stat_buffs.suppression_dealt] = 0.32,
					[stat_buffs.damage_vs_suppressed] = 0.16
				}
			},
			{
				proc_stat_buffs = {
					[stat_buffs.recoil_modifier] = -0.36,
					[stat_buffs.suppression_dealt] = 0.36,
					[stat_buffs.damage_vs_suppressed] = 0.18
				}
			},
			{
				proc_stat_buffs = {
					[stat_buffs.recoil_modifier] = -0.4,
					[stat_buffs.suppression_dealt] = 0.4,
					[stat_buffs.damage_vs_suppressed] = 0.2
				}
			}
		}
	}
}
templates.weapon_trait_bespoke_ogryn_heavystubber_p2_suppression_negation_on_weakspot = {
	format_values = {
		time = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_heavystubber_p2_suppression_negation_on_weakspot",
				find_value_type = "trait_override",
				path = {
					"active_duration"
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_ogryn_heavystubber_p2_suppression_negation_on_weakspot = {
			{
				active_duration = 2.4
			},
			{
				active_duration = 2.8
			},
			{
				active_duration = 3.2
			},
			{
				active_duration = 3.6
			}
		}
	}
}
templates.weapon_trait_bespoke_ogryn_heavystubber_p2_crit_chance_based_on_aim_time = {
	format_values = {
		time = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_heavystubber_p2_crit_chance_based_on_aim_time",
				find_value_type = "trait_override",
				path = {
					"duration_per_stack"
				}
			}
		},
		crit_chance = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_heavystubber_p2_crit_chance_based_on_aim_time",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.critical_strike_chance
				}
			}
		},
		stacks = {
			value = "10",
			format_type = "string"
		}
	},
	buffs = {
		weapon_trait_bespoke_ogryn_heavystubber_p2_crit_chance_based_on_aim_time = {
			{
				duration_per_stack = 0.35,
				stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.1
				}
			},
			{
				duration_per_stack = 0.3,
				stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.1
				}
			},
			{
				duration_per_stack = 0.25,
				stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.1
				}
			},
			{
				duration_per_stack = 0.2,
				stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.1
				}
			}
		}
	}
}
templates.weapon_trait_bespoke_ogryn_heavystubber_p2_stacking_crit_chance_on_weakspot = {
	format_values = {
		crit_chance = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_heavystubber_p2_stacking_crit_chance_on_weakspot_parent",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.critical_strike_chance
				}
			}
		},
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_heavystubber_p2_stacking_crit_chance_on_weakspot_parent",
				find_value_type = "trait_override",
				path = {
					"max_stacks"
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_ogryn_heavystubber_p2_stacking_crit_chance_on_weakspot_parent = {
			{
				max_stacks = 5,
				stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.14
				}
			},
			{
				max_stacks = 5,
				stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.16
				}
			},
			{
				max_stacks = 5,
				stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.18
				}
			},
			{
				max_stacks = 5,
				stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.2
				}
			}
		}
	}
}
templates.weapon_trait_bespoke_ogryn_heavystubber_p2_stagger_count_bonus_damage = {
	format_values = {
		damage = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_heavystubber_p2_stagger_count_bonus_damage",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.stagger_count_damage
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_ogryn_heavystubber_p2_stagger_count_bonus_damage = {
			{
				stat_buffs = {
					[stat_buffs.stagger_count_damage] = 0.14
				}
			},
			{
				stat_buffs = {
					[stat_buffs.stagger_count_damage] = 0.16
				}
			},
			{
				stat_buffs = {
					[stat_buffs.stagger_count_damage] = 0.18
				}
			},
			{
				stat_buffs = {
					[stat_buffs.stagger_count_damage] = 0.2
				}
			}
		}
	}
}
templates.weapon_trait_bespoke_ogryn_heavystubber_p2_burninating_on_crit = {
	format_values = {
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_heavystubber_p2_burninating_on_crit",
				find_value_type = "trait_override",
				path = {
					"target_buff_data",
					"num_stacks_on_proc"
				}
			}
		},
		max_stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_heavystubber_p2_burninating_on_crit",
				find_value_type = "trait_override",
				path = {
					"target_buff_data",
					"max_stacks"
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_ogryn_heavystubber_p2_burninating_on_crit = {
			{
				target_buff_data = {
					max_stacks = 3,
					num_stacks_on_proc = 1
				}
			},
			{
				target_buff_data = {
					max_stacks = 6,
					num_stacks_on_proc = 2
				}
			},
			{
				target_buff_data = {
					max_stacks = 9,
					num_stacks_on_proc = 3
				}
			},
			{
				target_buff_data = {
					max_stacks = 12,
					num_stacks_on_proc = 4
				}
			}
		}
	}
}
templates.weapon_trait_bespoke_ogryn_heavystubber_p2_crit_weakspot_finesse = {
	format_values = {
		crit_weakspot_damage = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_heavystubber_p2_crit_weakspot_finesse",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.critical_strike_weakspot_damage
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_ogryn_heavystubber_p2_crit_weakspot_finesse = {
			{
				stat_buffs = {
					[stat_buffs.critical_strike_weakspot_damage] = 0.7
				}
			},
			{
				stat_buffs = {
					[stat_buffs.critical_strike_weakspot_damage] = 0.8
				}
			},
			{
				stat_buffs = {
					[stat_buffs.critical_strike_weakspot_damage] = 0.9
				}
			},
			{
				stat_buffs = {
					[stat_buffs.critical_strike_weakspot_damage] = 1
				}
			}
		}
	}
}
templates.weapon_trait_bespoke_ogryn_heavystubber_p2_power_bonus_on_continuous_fire = {
	format_values = {
		power_level = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_heavystubber_p2_power_bonus_on_continuous_fire",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.power_level_modifier
				}
			}
		},
		ammo = {
			value = "10%",
			format_type = "string"
		},
		stacks = {
			value = "5",
			format_type = "string"
		}
	},
	buffs = {
		weapon_trait_bespoke_ogryn_heavystubber_p2_power_bonus_on_continuous_fire = {
			{
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.05
				}
			},
			{
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.06
				}
			},
			{
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.07
				}
			},
			{
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.08
				}
			}
		}
	}
}
templates.weapon_trait_bespoke_ogryn_heavystubber_p2_stacking_power_bonus_on_staggering_enemies = {
	format_values = {
		power_level = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_heavystubber_p2_stacking_power_bonus_on_staggering_enemies_parent",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.power_level_modifier
				}
			}
		},
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_heavystubber_p2_stacking_power_bonus_on_staggering_enemies_parent",
				find_value_type = "trait_override",
				path = {
					"max_stacks"
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_ogryn_heavystubber_p2_stacking_power_bonus_on_staggering_enemies_parent = {
			{
				max_stacks = 5,
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.0425
				}
			},
			{
				max_stacks = 5,
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.045
				}
			},
			{
				max_stacks = 5,
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.0475
				}
			},
			{
				max_stacks = 5,
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.05
				}
			}
		}
	}
}
templates.weapon_trait_bespoke_ogryn_heavystubber_p2_power_bonus_on_first_shot = {
	format_values = {
		power_level = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_heavystubber_p2_power_bonus_on_first_shot",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.ranged_power_level_modifier
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_ogryn_heavystubber_p2_power_bonus_on_first_shot = {
			{
				stat_buffs = {
					[stat_buffs.ranged_power_level_modifier] = 0.14
				}
			},
			{
				stat_buffs = {
					[stat_buffs.ranged_power_level_modifier] = 0.16
				}
			},
			{
				stat_buffs = {
					[stat_buffs.ranged_power_level_modifier] = 0.18
				}
			},
			{
				stat_buffs = {
					[stat_buffs.ranged_power_level_modifier] = 0.2
				}
			}
		}
	}
}
templates.weapon_trait_bespoke_ogryn_heavystubber_p2_toughness_on_elite_kills = {
	format_values = {
		toughness = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_heavystubber_p2_toughness_on_elite_kills",
				find_value_type = "trait_override",
				path = {
					"toughness_fixed_percentage"
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_ogryn_heavystubber_p2_toughness_on_elite_kills = {
			{
				toughness_fixed_percentage = 0.1
			},
			{
				toughness_fixed_percentage = 0.12
			},
			{
				toughness_fixed_percentage = 0.14
			},
			{
				toughness_fixed_percentage = 0.16
			}
		}
	}
}
templates.weapon_trait_bespoke_ogryn_heavystubber_p2_stacking_crit_bonus_on_continuous_fire = {
	format_values = {
		crit_chance = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_heavystubber_p2_stacking_crit_bonus_on_continuous_fire",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.critical_strike_chance
				}
			}
		},
		ammo = {
			value = "10%",
			format_type = "string"
		},
		stacks = {
			value = "5",
			format_type = "string"
		}
	},
	buffs = {
		weapon_trait_bespoke_ogryn_heavystubber_p2_stacking_crit_bonus_on_continuous_fire = {
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
	}
}

return templates
