-- chunkname: @scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_forcestaff_p2.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local templates = {}

table.make_unique(templates)

local stat_buffs = BuffSettings.stat_buffs
local proc_events = BuffSettings.proc_events

templates.weapon_trait_bespoke_forcestaff_p2_suppression_on_close_kill = {
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
		weapon_trait_bespoke_forcestaff_p2_suppression_on_close_kill = {
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
templates.weapon_trait_bespoke_forcestaff_p2_hipfire_while_sprinting = {
	format_values = {
		weapon_spread = {
			prefix = "",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_forcestaff_p2_hipfire_while_sprinting",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.spread_modifier
				}
			}
		},
		damage_near = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_forcestaff_p2_hipfire_while_sprinting",
				find_value_type = "trait_override",
				path = {
					"conditional_stat_buffs",
					stat_buffs.damage_near
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_forcestaff_p2_hipfire_while_sprinting = {
			{
				stat_buffs = {
					[stat_buffs.spread_modifier] = -0.3
				},
				conditional_stat_buffs = {
					[stat_buffs.damage_near] = 0.06
				}
			},
			{
				stat_buffs = {
					[stat_buffs.spread_modifier] = -0.3
				},
				conditional_stat_buffs = {
					[stat_buffs.damage_near] = 0.09
				}
			},
			{
				stat_buffs = {
					[stat_buffs.spread_modifier] = -0.3
				},
				conditional_stat_buffs = {
					[stat_buffs.damage_near] = 0.12
				}
			},
			{
				stat_buffs = {
					[stat_buffs.spread_modifier] = -0.3
				},
				conditional_stat_buffs = {
					[stat_buffs.damage_near] = 0.15
				}
			}
		}
	}
}
templates.weapon_trait_bespoke_forcestaff_p2_warp_charge_critical_strike_chance_bonus = {
	format_values = {
		crit_chance = {
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_forcestaff_p2_warp_charge_critical_strike_chance_bonus",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.critical_strike_chance
				}
			}
		},
		crit_chance_max = {
			suffix = "%",
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_forcestaff_p2_warp_charge_critical_strike_chance_bonus",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.critical_strike_chance
				}
			},
			value_manipulation = function (value)
				return math.abs(value * 100) * 4
			end
		}
	},
	buffs = {
		weapon_trait_bespoke_forcestaff_p2_warp_charge_critical_strike_chance_bonus = {
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
templates.weapon_trait_bespoke_forcestaff_p2_uninterruptable_while_charging = {
	format_values = {
		reduction = {
			num_decimals = 0,
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_forcestaff_p2_uninterruptable_while_charging",
				find_value_type = "trait_override",
				path = {
					"conditional_stat_buffs",
					stat_buffs.charge_movement_reduction_multiplier
				}
			},
			value_manipulation = function (value)
				return 100 - math.round(value * 100)
			end
		}
	},
	buffs = {
		weapon_trait_bespoke_forcestaff_p2_uninterruptable_while_charging = {
			{
				conditional_stat_buffs = {
					[stat_buffs.charge_movement_reduction_multiplier] = 0.8
				}
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.charge_movement_reduction_multiplier] = 0.7
				}
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.charge_movement_reduction_multiplier] = 0.6
				}
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.charge_movement_reduction_multiplier] = 0.5
				}
			}
		}
	}
}
templates.weapon_trait_bespoke_forcestaff_p2_faster_charge_on_chained_secondary_attacks = {
	format_values = {
		charge_time = {
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_forcestaff_p2_faster_charge_on_chained_secondary_attacks_parent",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.charge_up_time
				}
			}
		},
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_forcestaff_p2_faster_charge_on_chained_secondary_attacks_child",
				find_value_type = "buff_template",
				path = {
					"max_stacks"
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_forcestaff_p2_faster_charge_on_chained_secondary_attacks_parent = {
			{
				stat_buffs = {
					[stat_buffs.charge_up_time] = -0.055
				}
			},
			{
				stat_buffs = {
					[stat_buffs.charge_up_time] = -0.065
				}
			},
			{
				stat_buffs = {
					[stat_buffs.charge_up_time] = -0.075
				}
			},
			{
				stat_buffs = {
					[stat_buffs.charge_up_time] = -0.085
				}
			}
		}
	}
}
templates.weapon_trait_bespoke_forcestaff_p2_burned_targets_receive_rending_debuff = {
	format_values = {
		num_stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_forcestaff_p2_burned_targets_receive_rending_debuff",
				find_value_type = "trait_override",
				path = {
					"target_buff_data",
					"num_stacks_on_proc"
				}
			}
		},
		rending_percentage = {
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
		duration = {
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
		weapon_trait_bespoke_forcestaff_p2_burned_targets_receive_rending_debuff = {
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
templates.weapon_trait_bespoke_forcestaff_p2_chance_to_explode_elites_on_kill = {
	format_values = {
		proc_chance = {
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_forcestaff_p2_chance_to_explode_elites_on_kill",
				find_value_type = "trait_override",
				path = {
					"proc_events",
					proc_events.on_kill
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_forcestaff_p2_chance_to_explode_elites_on_kill = {
			{
				proc_events = {
					[proc_events.on_kill] = 0.14
				}
			},
			{
				proc_events = {
					[proc_events.on_kill] = 0.16
				}
			},
			{
				proc_events = {
					[proc_events.on_kill] = 0.18
				}
			},
			{
				proc_events = {
					[proc_events.on_kill] = 0.2
				}
			}
		}
	}
}
templates.weapon_trait_bespoke_forcestaff_p2_power_bonus_on_continuous_fire = {
	format_values = {
		power_level = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_forcestaff_p2_power_bonus_on_continuous_fire",
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
		weapon_trait_bespoke_forcestaff_p2_power_bonus_on_continuous_fire = {
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

return templates
