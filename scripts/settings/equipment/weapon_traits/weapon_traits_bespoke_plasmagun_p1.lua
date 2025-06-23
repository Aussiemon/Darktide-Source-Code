-- chunkname: @scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_plasmagun_p1.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local templates = {}

table.make_unique(templates)

local stat_buffs = BuffSettings.stat_buffs

templates.weapon_trait_bespoke_plasmagun_p1_toughness_on_elite_kills = {
	format_values = {
		toughness = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_plasmagun_p1_toughness_on_elite_kills",
				find_value_type = "trait_override",
				path = {
					"toughness_fixed_percentage"
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_plasmagun_p1_toughness_on_elite_kills = {
			{
				toughness_fixed_percentage = 0.175
			},
			{
				toughness_fixed_percentage = 0.2
			},
			{
				toughness_fixed_percentage = 0.225
			},
			{
				toughness_fixed_percentage = 0.25
			}
		}
	}
}
templates.weapon_trait_bespoke_plasmagun_p1_targets_receive_rending_debuff = {
	format_values = {
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_plasmagun_p1_targets_receive_rending_debuff",
				find_value_type = "trait_override",
				path = {
					"target_buff_data",
					"num_stacks_on_proc"
				}
			}
		},
		rending = {
			format_type = "percentage",
			find_value = {
				buff_template_name = "rending_debuff",
				find_value_type = "buff_template",
				path = {
					"stat_buffs",
					stat_buffs.rending_multiplier
				}
			}
		},
		time = {
			format_type = "number",
			find_value = {
				buff_template_name = "rending_debuff",
				find_value_type = "buff_template",
				path = {
					"duration"
				}
			}
		},
		max_stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "rending_debuff",
				find_value_type = "buff_template",
				path = {
					"max_stacks"
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_plasmagun_p1_targets_receive_rending_debuff = {
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
	}
}
templates.weapon_trait_bespoke_plasmagun_p1_power_bonus_on_continuous_fire = {
	format_values = {
		power_level = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_plasmagun_p1_power_bonus_on_continuous_fire",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.power_level_modifier
				}
			}
		},
		stacks = {
			value = "5",
			format_type = "string"
		}
	},
	buffs = {
		weapon_trait_bespoke_plasmagun_p1_power_bonus_on_continuous_fire = {
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
templates.weapon_trait_bespoke_plasmagun_p1_lower_overheat_gives_faster_charge = {
	format_values = {
		charge_speed = {
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_plasmagun_p1_lower_overheat_gives_faster_charge",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.charge_up_time
				}
			},
			value_manipulation = function (value)
				return math.abs(value * 100)
			end
		},
		stacks = {
			value = "5",
			format_type = "string"
		}
	},
	buffs = {
		weapon_trait_bespoke_plasmagun_p1_lower_overheat_gives_faster_charge = {
			{
				stat_buffs = {
					[stat_buffs.charge_up_time] = -0.025
				}
			},
			{
				stat_buffs = {
					[stat_buffs.charge_up_time] = -0.03
				}
			},
			{
				stat_buffs = {
					[stat_buffs.charge_up_time] = -0.035
				}
			},
			{
				stat_buffs = {
					[stat_buffs.charge_up_time] = -0.04
				}
			}
		}
	}
}
templates.weapon_trait_bespoke_plasmagun_p1_crit_chance_scaled_on_heat = {
	format_values = {
		crit_chance = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_plasmagun_p1_crit_chance_scaled_on_heat",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.critical_strike_chance
				}
			}
		},
		ranged_crit_damage = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_plasmagun_p1_crit_chance_scaled_on_heat",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.ranged_critical_strike_damage
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_plasmagun_p1_crit_chance_scaled_on_heat = {
			{
				stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.055,
					[stat_buffs.ranged_critical_strike_damage] = 0.04
				}
			},
			{
				stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.07,
					[stat_buffs.ranged_critical_strike_damage] = 0.06
				}
			},
			{
				stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.085,
					[stat_buffs.ranged_critical_strike_damage] = 0.08
				}
			},
			{
				stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.1,
					[stat_buffs.ranged_critical_strike_damage] = 0.1
				}
			}
		}
	}
}
templates.weapon_trait_bespoke_plasmagun_p1_power_bonus_scaled_on_heat = {
	format_values = {
		damage = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_plasmagun_p1_power_bonus_scaled_on_heat",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.power_level_modifier
				}
			},
			value_manipulation = function (value)
				return value * 5 * 100
			end
		}
	},
	buffs = {
		weapon_trait_bespoke_plasmagun_p1_power_bonus_scaled_on_heat = {
			{
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.015
				}
			},
			{
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.02
				}
			},
			{
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.03
				}
			},
			{
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.04
				}
			}
		}
	}
}
templates.weapon_trait_bespoke_plasmagun_p1_reduced_overheat_on_critical_strike = {
	format_values = {
		heat_percentage = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_plasmagun_p1_reduced_overheat_on_critical_strike",
				find_value_type = "trait_override",
				path = {
					"conditional_stat_buffs",
					stat_buffs.overheat_immediate_amount_critical_strike
				}
			},
			value_manipulation = function (value)
				return 100 - math.round(value * 100)
			end
		}
	},
	buffs = {
		weapon_trait_bespoke_plasmagun_p1_reduced_overheat_on_critical_strike = {
			{
				conditional_stat_buffs = {
					[stat_buffs.overheat_immediate_amount_critical_strike] = 0.7
				}
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.overheat_immediate_amount_critical_strike] = 0.6
				}
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.overheat_immediate_amount_critical_strike] = 0.5
				}
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.overheat_immediate_amount_critical_strike] = 0.4
				}
			}
		}
	}
}
templates.weapon_trait_bespoke_plasmagun_p1_reduced_overheat_on_continuous_fire = {
	format_values = {
		overheat_reduction = {
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_plasmagun_p1_reduced_overheat_on_continuous_fire",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.overheat_amount
				}
			}
		},
		stacks = {
			value = "5",
			format_type = "string"
		}
	},
	buffs = {
		weapon_trait_bespoke_plasmagun_p1_reduced_overheat_on_continuous_fire = {
			{
				stat_buffs = {
					[stat_buffs.overheat_amount] = 0.96
				}
			},
			{
				stat_buffs = {
					[stat_buffs.overheat_amount] = 0.94
				}
			},
			{
				stat_buffs = {
					[stat_buffs.overheat_amount] = 0.92
				}
			},
			{
				stat_buffs = {
					[stat_buffs.overheat_amount] = 0.9
				}
			}
		}
	}
}
templates.weapon_trait_bespoke_plasmagun_p1_charge_level_increases_critical_strike_chance = {
	format_values = {
		crit_chance_min = {
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_plasmagun_p1_charge_level_increases_critical_strike_chance",
				find_value_type = "trait_override",
				path = {
					"conditional_stat_buffs",
					stat_buffs.critical_strike_chance
				}
			}
		},
		crit_chance_max = {
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_plasmagun_p1_charge_level_increases_critical_strike_chance",
				find_value_type = "trait_override",
				path = {
					"conditional_stat_buffs",
					stat_buffs.critical_strike_chance
				}
			},
			value_manipulation = function (value)
				return value * 5 * 100
			end
		}
	},
	buffs = {
		weapon_trait_bespoke_plasmagun_p1_charge_level_increases_critical_strike_chance = {
			{
				conditional_stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.02
				}
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.03
				}
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.04
				}
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.05
				}
			}
		}
	}
}

return templates
