-- chunkname: @scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_forcesword_2h_p1.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local templates = {}

table.make_unique(templates)

local stat_buffs = BuffSettings.stat_buffs

templates.weapon_trait_bespoke_forcesword_2h_p1_guaranteed_melee_crit_on_activated_kill = {
	format_values = {
		crit_chance = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_forcesword_2h_p1_guaranteed_melee_crit_on_activated_kill",
				find_value_type = "trait_override",
				path = {
					"buff_data",
					"num_stacks_on_proc"
				}
			},
			value_manipulation = function (value)
				return math.abs(value) * 10
			end
		}
	},
	buffs = {
		weapon_trait_bespoke_forcesword_2h_p1_guaranteed_melee_crit_on_activated_kill = {
			{
				buff_data = {
					num_stacks_on_proc = 4
				}
			},
			{
				buff_data = {
					num_stacks_on_proc = 6
				}
			},
			{
				buff_data = {
					num_stacks_on_proc = 8
				}
			},
			{
				buff_data = {
					num_stacks_on_proc = 10
				}
			}
		}
	}
}
templates.weapon_trait_bespoke_forcesword_2h_p1_warp_charge_power_bonus = {
	format_values = {
		power_level = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_forcesword_2h_p1_warp_charge_power_bonus",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.power_level_modifier
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_forcesword_2h_p1_warp_charge_power_bonus = {
			{
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.035
				}
			},
			{
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.04
				}
			},
			{
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.045
				}
			},
			{
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.05
				}
			}
		}
	}
}
templates.weapon_trait_bespoke_forcesword_2h_p1_can_block_ranged = {
	format_values = {
		block_cost = {
			prefix = "-",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_forcesword_2h_p1_can_block_ranged",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.block_cost_multiplier
				}
			},
			value_manipulation = function (value)
				return 100 - value * 100
			end
		}
	},
	buffs = {
		weapon_trait_bespoke_forcesword_2h_p1_can_block_ranged = {
			{
				stat_buffs = {
					[stat_buffs.block_cost_multiplier] = 0.775
				}
			},
			{
				stat_buffs = {
					[stat_buffs.block_cost_multiplier] = 0.75
				}
			},
			{
				stat_buffs = {
					[stat_buffs.block_cost_multiplier] = 0.725
				}
			},
			{
				stat_buffs = {
					[stat_buffs.block_cost_multiplier] = 0.7
				}
			}
		}
	}
}
templates.weapon_trait_bespoke_forcesword_2h_p1_warp_burninating_on_crit = {
	format_values = {
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_forcesword_2h_p1_warp_burninating_on_crit",
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
				buff_template_name = "weapon_trait_bespoke_forcesword_2h_p1_warp_burninating_on_crit",
				find_value_type = "trait_override",
				path = {
					"target_buff_data",
					"max_stacks"
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_forcesword_2h_p1_warp_burninating_on_crit = {
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
templates.weapon_trait_bespoke_forcesword_2h_p1_wind_slash_crits = {
	format_values = {
		cooldown = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_forcesword_2h_p1_wind_slash_crits",
				find_value_type = "trait_override",
				path = {
					"cooldown_duration"
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_forcesword_2h_p1_wind_slash_crits = {
			{
				cooldown_duration = 30
			},
			{
				cooldown_duration = 25
			},
			{
				cooldown_duration = 20
			},
			{
				cooldown_duration = 15
			}
		}
	}
}
templates.weapon_trait_bespoke_forcesword_2h_p1_increased_attack_cleave_on_multiple_hits = {
	format_values = {
		cleave = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_forcesword_2h_p1_increased_attack_cleave_on_multiple_hits",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.max_hit_mass_attack_modifier
				}
			}
		},
		multiple_hit = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_forcesword_2h_p1_increased_attack_cleave_on_multiple_hits",
				find_value_type = "buff_template",
				path = {
					"buff_data",
					"required_num_hits"
				}
			}
		},
		time = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_forcesword_2h_p1_increased_attack_cleave_on_multiple_hits",
				find_value_type = "buff_template",
				path = {
					"active_duration"
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_forcesword_2h_p1_increased_attack_cleave_on_multiple_hits = {
			{
				stat_buffs = {
					[stat_buffs.max_hit_mass_attack_modifier] = 1.4
				}
			},
			{
				stat_buffs = {
					[stat_buffs.max_hit_mass_attack_modifier] = 1.6
				}
			},
			{
				stat_buffs = {
					[stat_buffs.max_hit_mass_attack_modifier] = 1.8
				}
			},
			{
				stat_buffs = {
					[stat_buffs.max_hit_mass_attack_modifier] = 2
				}
			}
		}
	}
}
templates.weapon_trait_bespoke_forcesword_2h_p1_chained_hits_increases_melee_cleave = {
	format_values = {
		cleave = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_forcesword_2h_p1_chained_hits_increases_melee_cleave_parent",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.max_hit_mass_attack_modifier
				}
			}
		},
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_forcesword_2h_p1_chained_hits_increases_melee_cleave_child",
				find_value_type = "buff_template",
				path = {
					"max_stacks"
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_forcesword_2h_p1_chained_hits_increases_melee_cleave_parent = {
			{
				stat_buffs = {
					[stat_buffs.max_hit_mass_attack_modifier] = 0.25
				}
			},
			{
				stat_buffs = {
					[stat_buffs.max_hit_mass_attack_modifier] = 0.3
				}
			},
			{
				stat_buffs = {
					[stat_buffs.max_hit_mass_attack_modifier] = 0.35
				}
			},
			{
				stat_buffs = {
					[stat_buffs.max_hit_mass_attack_modifier] = 0.4
				}
			}
		}
	}
}
templates.weapon_trait_bespoke_forcesword_2h_p1_dodge_grants_finesse_bonus = {
	format_values = {
		damage = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_forcesword_2h_p1_dodge_grants_finesse_bonus",
				find_value_type = "trait_override",
				path = {
					"proc_stat_buffs",
					stat_buffs.finesse_modifier_bonus
				}
			}
		},
		time = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_forcesword_2h_p1_dodge_grants_finesse_bonus",
				find_value_type = "trait_override",
				path = {
					"active_duration"
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_forcesword_2h_p1_dodge_grants_finesse_bonus = {
			{
				active_duration = 2,
				proc_stat_buffs = {
					[stat_buffs.finesse_modifier_bonus] = 0.45
				}
			},
			{
				active_duration = 2,
				proc_stat_buffs = {
					[stat_buffs.finesse_modifier_bonus] = 0.5
				}
			},
			{
				active_duration = 2,
				proc_stat_buffs = {
					[stat_buffs.finesse_modifier_bonus] = 0.55
				}
			},
			{
				active_duration = 2,
				proc_stat_buffs = {
					[stat_buffs.finesse_modifier_bonus] = 0.6
				}
			}
		}
	}
}
templates.weapon_trait_bespoke_forcesword_2h_p1_dodge_grants_critical_strike_chance = {
	format_values = {
		crit_chance = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_forcesword_2h_p1_dodge_grants_critical_strike_chance",
				find_value_type = "trait_override",
				path = {
					"proc_stat_buffs",
					stat_buffs.critical_strike_chance
				}
			}
		},
		time = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_forcesword_2h_p1_dodge_grants_critical_strike_chance",
				find_value_type = "buff_template",
				path = {
					"active_duration"
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_forcesword_2h_p1_dodge_grants_critical_strike_chance = {
			{
				proc_stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.125
				}
			},
			{
				proc_stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.15
				}
			},
			{
				proc_stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.175
				}
			},
			{
				proc_stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.2
				}
			}
		}
	}
}
templates.weapon_trait_bespoke_forcesword_2h_p1_vent_warp_charge_on_multiple_hits = {
	format_values = {
		warp_charge = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_forcesword_2h_p1_vent_warp_charge_on_multiple_hits",
				find_value_type = "trait_override",
				path = {
					"vent_percentage"
				}
			}
		},
		multiple_hit = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_forcesword_2h_p1_vent_warp_charge_on_multiple_hits",
				find_value_type = "buff_template",
				path = {
					"buff_data",
					"required_num_hits"
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_forcesword_2h_p1_vent_warp_charge_on_multiple_hits = {
			{
				vent_percentage = 0.02
			},
			{
				vent_percentage = 0.03
			},
			{
				vent_percentage = 0.04
			},
			{
				vent_percentage = 0.05
			}
		}
	}
}
templates.weapon_trait_bespoke_forcesword_2h_p1_toughness_recovery_on_multiple_hits = {
	format_values = {
		toughness = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_forcesword_2h_p1_toughness_recovery_on_multiple_hits",
				find_value_type = "trait_override",
				path = {
					"buff_data",
					"replenish_percentage"
				}
			}
		},
		multiple_hit = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_forcesword_2h_p1_toughness_recovery_on_multiple_hits",
				find_value_type = "trait_override",
				path = {
					"buff_data",
					"required_num_hits"
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_forcesword_2h_p1_toughness_recovery_on_multiple_hits = {
			{
				buff_data = {
					replenish_percentage = 0.12,
					required_num_hits = 3
				}
			},
			{
				buff_data = {
					replenish_percentage = 0.13,
					required_num_hits = 3
				}
			},
			{
				buff_data = {
					replenish_percentage = 0.14,
					required_num_hits = 3
				}
			},
			{
				buff_data = {
					replenish_percentage = 0.15,
					required_num_hits = 3
				}
			}
		}
	}
}
templates.weapon_trait_bespoke_forcesword_2h_p1_chained_hits_increases_crit_chance = {
	format_values = {
		crit_chance = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_forcesword_2h_p1_chained_hits_increases_crit_chance_parent",
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
				buff_template_name = "weapon_trait_bespoke_forcesword_2h_p1_chained_hits_increases_crit_chance_child",
				find_value_type = "buff_template",
				path = {
					"max_stacks"
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_forcesword_2h_p1_chained_hits_increases_crit_chance_parent = {
			{
				stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.025
				}
			},
			{
				stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.03
				}
			},
			{
				stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.035
				}
			},
			{
				stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.04
				}
			}
		}
	}
}

return templates
