-- chunkname: @scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_powersword_2h_p1.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local ExplosionTemplates = require("scripts/settings/damage/explosion_templates")
local templates = {}

table.make_unique(templates)

local stat_buffs = BuffSettings.stat_buffs

templates.weapon_trait_bespoke_powersword_2h_p1_power_bonus_scaled_on_heat = {
	format_values = {
		amount = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powersword_2h_p1_power_bonus_scaled_on_heat",
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
		weapon_trait_bespoke_powersword_2h_p1_power_bonus_scaled_on_heat = {
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
templates.weapon_trait_bespoke_powersword_2h_p1_reduce_fixed_overheat_amount_parent = {
	format_values = {
		amount = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powersword_2h_p1_reduce_fixed_overheat_amount_parent",
				find_value_type = "trait_override",
				path = {
					"overheat_reduction"
				}
			}
		},
		time = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powersword_2h_p1_reduce_fixed_overheat_amount_parent",
				find_value_type = "trait_override",
				path = {
					"duration"
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_powersword_2h_p1_reduce_fixed_overheat_amount_parent = {
			{
				duration = 3,
				overheat_reduction = 0.04
			},
			{
				duration = 3,
				overheat_reduction = 0.06
			},
			{
				duration = 3,
				overheat_reduction = 0.08
			},
			{
				duration = 3,
				overheat_reduction = 0.1
			}
		}
	}
}
templates.weapon_trait_bespoke_powersword_2h_p1_chained_weakspot_hits_increase_finesse_and_reduce_overheat = {
	format_values = {
		buildup_amount = {
			prefix = "-",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powersword_2h_p1_chained_weakspot_hits_increase_finesse_and_reduce_overheat_parent",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.overheat_amount
				}
			},
			value_manipulation = function (value)
				return 100 - value * 100
			end
		},
		damage = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powersword_2h_p1_chained_weakspot_hits_increase_finesse_and_reduce_overheat_parent",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.finesse_modifier_bonus
				}
			}
		},
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powersword_2h_p1_chained_weakspot_hits_increase_finesse_and_reduce_overheat_child",
				find_value_type = "buff_template",
				path = {
					"max_stacks"
				}
			}
		},
		duration = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powersword_2h_p1_chained_weakspot_hits_increase_finesse_and_reduce_overheat_parent",
				find_value_type = "buff_template",
				path = {
					"child_duration"
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_powersword_2h_p1_chained_weakspot_hits_increase_finesse_and_reduce_overheat_parent = {
			{
				stat_buffs = {
					finesse_modifier_bonus = 0.01,
					overheat_amount = 0.97
				}
			},
			{
				stat_buffs = {
					finesse_modifier_bonus = 0.02,
					overheat_amount = 0.96
				}
			},
			{
				stat_buffs = {
					finesse_modifier_bonus = 0.03,
					overheat_amount = 0.95
				}
			},
			{
				stat_buffs = {
					finesse_modifier_bonus = 0.04,
					overheat_amount = 0.94
				}
			}
		}
	}
}
templates.weapon_trait_bespoke_powersword_2h_p1_increased_melee_damage_on_multiple_hits = {
	format_values = {
		damage = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powersword_2h_p1_increased_melee_damage_on_multiple_hits",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.melee_power_level_modifier
				}
			}
		},
		multiple_hit = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powersword_2h_p1_increased_melee_damage_on_multiple_hits",
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
				buff_template_name = "weapon_trait_bespoke_powersword_2h_p1_increased_melee_damage_on_multiple_hits",
				find_value_type = "trait_override",
				path = {
					"active_duration"
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_powersword_2h_p1_increased_melee_damage_on_multiple_hits = {
			{
				active_duration = 3.5,
				stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.24
				}
			},
			{
				active_duration = 3.5,
				stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.28
				}
			},
			{
				active_duration = 3.5,
				stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.32
				}
			},
			{
				active_duration = 3.5,
				stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.36
				}
			}
		}
	}
}
templates.weapon_trait_bespoke_powersword_2h_p1_chained_hits_increases_melee_cleave = {
	format_values = {
		cleave = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powersword_2h_p1_chained_hits_increases_melee_cleave_parent",
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
				buff_template_name = "weapon_trait_bespoke_powersword_2h_p1_chained_hits_increases_melee_cleave_child",
				find_value_type = "buff_template",
				path = {
					"max_stacks"
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_powersword_2h_p1_chained_hits_increases_melee_cleave_parent = {
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
templates.weapon_trait_bespoke_powersword_2h_p1_windup_increases_power = {
	format_values = {
		power_level = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powersword_2h_p1_windup_increases_power_parent",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.melee_power_level_modifier
				}
			}
		},
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powersword_2h_p1_windup_increases_power_child",
				find_value_type = "buff_template",
				path = {
					"max_stacks"
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_powersword_2h_p1_windup_increases_power_parent = {
			{
				stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.05
				}
			},
			{
				stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.1
				}
			},
			{
				stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.15
				}
			},
			{
				stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.2
				}
			}
		}
	}
}
templates.weapon_trait_bespoke_powersword_2h_p1_infinite_melee_cleave_on_crit = {
	format_values = {
		hit_mass = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powersword_2h_p1_infinite_melee_cleave_on_crit",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.max_hit_mass_attack_modifier
				}
			}
		},
		time = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powersword_2h_p1_infinite_melee_cleave_on_crit",
				find_value_type = "buff_template",
				path = {
					"active_duration"
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_powersword_2h_p1_infinite_melee_cleave_on_crit = {
			{
				stat_buffs = {
					[stat_buffs.max_hit_mass_attack_modifier] = 0.65
				}
			},
			{
				stat_buffs = {
					[stat_buffs.max_hit_mass_attack_modifier] = 0.7
				}
			},
			{
				stat_buffs = {
					[stat_buffs.max_hit_mass_attack_modifier] = 0.75
				}
			},
			{
				stat_buffs = {
					[stat_buffs.max_hit_mass_attack_modifier] = 0.8
				}
			}
		}
	}
}
templates.weapon_trait_bespoke_bespoke_powersword_2h_p1_block_activate_weapon_special = {
	format_values = {
		cooldown = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_bespoke_powersword_2h_p1_block_activate_weapon_special",
				find_value_type = "trait_override",
				path = {
					"cooldown_duration"
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_bespoke_powersword_2h_p1_block_activate_weapon_special = {
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
templates.weapon_trait_bespoke_bespoke_powersword_2h_p1_regain_toughness_on_multiple_hits_by_weapon_special = {
	format_values = {
		toughness = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_bespoke_powersword_2h_p1_regain_toughness_on_multiple_hits_by_weapon_special",
				find_value_type = "trait_override",
				path = {
					"toughness_fixed_percentage"
				}
			}
		},
		num_hits = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_bespoke_powersword_2h_p1_regain_toughness_on_multiple_hits_by_weapon_special",
				find_value_type = "buff_template",
				path = {
					"buff_data",
					"required_num_hits"
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_bespoke_powersword_2h_p1_regain_toughness_on_multiple_hits_by_weapon_special = {
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
templates.weapon_trait_bespoke_bespoke_powersword_2h_p1_regain_stamina_on_weapon_special_hit = {
	format_values = {
		stamina = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_bespoke_powersword_2h_p1_regain_stamina_on_weapon_special_hit",
				find_value_type = "trait_override",
				path = {
					"stamina_fixed_percentage"
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_bespoke_powersword_2h_p1_regain_stamina_on_weapon_special_hit = {
			{
				stamina_fixed_percentage = 0.15
			},
			{
				stamina_fixed_percentage = 0.2
			},
			{
				stamina_fixed_percentage = 0.25
			},
			{
				stamina_fixed_percentage = 0.3
			}
		}
	}
}
templates.weapon_trait_bespoke_powersword_2h_p1_slower_heat_buildup_on_perfect_block = {
	format_values = {
		heat_reduction = {
			prefix = "-",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powersword_2h_p1_slower_heat_buildup_on_perfect_block",
				find_value_type = "trait_override",
				path = {
					"proc_stat_buffs",
					stat_buffs.overheat_over_time_amount
				}
			},
			value_manipulation = function (value)
				return 100 - value * 100
			end
		},
		heat_dissipation = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powersword_2h_p1_slower_heat_buildup_on_perfect_block",
				find_value_type = "trait_override",
				path = {
					"proc_stat_buffs",
					stat_buffs.overheat_dissipation_multiplier
				}
			},
			value_manipulation = function (value)
				return value * 100 - 100
			end
		},
		time = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powersword_2h_p1_slower_heat_buildup_on_perfect_block",
				find_value_type = "trait_override",
				path = {
					"active_duration"
				}
			}
		},
		interval = {
			value = 5,
			format_type = "number"
		}
	},
	buffs = {
		weapon_trait_bespoke_powersword_2h_p1_slower_heat_buildup_on_perfect_block = {
			{
				cooldown_duration = 0,
				active_duration = 5,
				proc_stat_buffs = {
					[stat_buffs.overheat_over_time_amount] = 0.84,
					[stat_buffs.overheat_dissipation_multiplier] = 1.03
				}
			},
			{
				cooldown_duration = 0,
				active_duration = 5,
				proc_stat_buffs = {
					[stat_buffs.overheat_over_time_amount] = 0.82,
					[stat_buffs.overheat_dissipation_multiplier] = 1.04
				}
			},
			{
				cooldown_duration = 0,
				active_duration = 5,
				proc_stat_buffs = {
					[stat_buffs.overheat_over_time_amount] = 0.8,
					[stat_buffs.overheat_dissipation_multiplier] = 1.05
				}
			},
			{
				cooldown_duration = 0,
				active_duration = 5,
				proc_stat_buffs = {
					[stat_buffs.overheat_over_time_amount] = 0.78,
					[stat_buffs.overheat_dissipation_multiplier] = 1.06
				}
			}
		}
	}
}
templates.weapon_trait_bespoke_powersword_2h_p1_attack_speed_on_perfect_block = {
	format_values = {
		attack_speed = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powersword_2h_p1_attack_speed_on_perfect_block",
				find_value_type = "trait_override",
				path = {
					"proc_stat_buffs",
					stat_buffs.melee_attack_speed
				}
			}
		},
		duration = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powersword_2h_p1_attack_speed_on_perfect_block",
				find_value_type = "trait_override",
				path = {
					"active_duration"
				}
			}
		},
		interval = {
			value = 5,
			format_type = "number"
		}
	},
	buffs = {
		weapon_trait_bespoke_powersword_2h_p1_attack_speed_on_perfect_block = {
			{
				cooldown_duration = 0,
				active_duration = 5,
				proc_stat_buffs = {
					[stat_buffs.melee_attack_speed] = 0.06
				}
			},
			{
				cooldown_duration = 0,
				active_duration = 5,
				proc_stat_buffs = {
					[stat_buffs.melee_attack_speed] = 0.08
				}
			},
			{
				cooldown_duration = 0,
				active_duration = 5,
				proc_stat_buffs = {
					[stat_buffs.melee_attack_speed] = 0.1
				}
			},
			{
				cooldown_duration = 0,
				active_duration = 5,
				proc_stat_buffs = {
					[stat_buffs.melee_attack_speed] = 0.12
				}
			}
		}
	}
}
templates.weapon_trait_bespoke_powersword_2h_p1_explosion_on_overheat_lockout = {
	format_values = {
		overheat_reduction = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powersword_2h_p1_explosion_on_overheat_lockout",
				find_value_type = "trait_override",
				path = {
					"overheat_reduction"
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_powersword_2h_p1_explosion_on_overheat_lockout = {
			{
				overheat_reduction = 0.1,
				proc_data = {
					explosion_template = ExplosionTemplates.trait_buff_powersword_2h_lockout_proc_explosion_1
				}
			},
			{
				overheat_reduction = 0.15,
				proc_data = {
					explosion_template = ExplosionTemplates.trait_buff_powersword_2h_lockout_proc_explosion_2
				}
			},
			{
				overheat_reduction = 0.2,
				proc_data = {
					explosion_template = ExplosionTemplates.trait_buff_powersword_2h_lockout_proc_explosion_3
				}
			},
			{
				overheat_reduction = 0.25,
				proc_data = {
					explosion_template = ExplosionTemplates.trait_buff_powersword_2h_lockout_proc_explosion_4
				}
			}
		}
	}
}
templates.weapon_trait_bespoke_powersword_2h_p1_trade_overheat_lockout_for_damage = {
	buffs = {
		weapon_trait_bespoke_powersword_2h_p1_trade_overheat_lockout_for_damage = {
			{
				interval = 0.2
			},
			{
				interval = 0.225
			},
			{
				interval = 0.25
			},
			{
				interval = 0.275
			}
		}
	}
}

return templates
