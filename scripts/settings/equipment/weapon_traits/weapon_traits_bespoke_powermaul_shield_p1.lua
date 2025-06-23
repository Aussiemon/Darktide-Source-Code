-- chunkname: @scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_powermaul_shield_p1.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local stat_buffs = BuffSettings.stat_buffs
local proc_events = BuffSettings.proc_events
local templates = {}

table.make_unique(templates)

templates.weapon_trait_bespoke_powermaul_shield_p1_toughness_recovery_on_chained_attacks = {
	format_values = {
		toughness = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powermaul_shield_p1_toughness_recovery_on_chained_attacks",
				find_value_type = "trait_override",
				path = {
					"toughness_fixed_percentage"
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_powermaul_shield_p1_toughness_recovery_on_chained_attacks = {
			{
				toughness_fixed_percentage = 0.05
			},
			{
				toughness_fixed_percentage = 0.06
			},
			{
				toughness_fixed_percentage = 0.07
			},
			{
				toughness_fixed_percentage = 0.08
			}
		}
	}
}
templates.weapon_trait_bespoke_powermaul_shield_p1_staggered_targets_receive_increased_damage_debuff = {
	format_values = {
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powermaul_shield_p1_staggered_targets_receive_increased_damage_debuff",
				find_value_type = "trait_override",
				path = {
					"target_buff_data",
					"num_stacks_on_proc"
				}
			}
		},
		damage = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "increase_damage_received_while_staggered",
				find_value_type = "buff_template",
				path = {
					"conditional_stat_buffs",
					stat_buffs.damage_vs_staggered
				}
			}
		},
		time = {
			format_type = "number",
			find_value = {
				buff_template_name = "increase_damage_received_while_staggered",
				find_value_type = "buff_template",
				path = {
					"duration"
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_powermaul_shield_p1_staggered_targets_receive_increased_damage_debuff = {
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
templates.weapon_trait_bespoke_powermaul_shield_p1_staggered_targets_receive_increased_stagger_debuff = {
	format_values = {
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powermaul_shield_p1_staggered_targets_receive_increased_stagger_debuff",
				find_value_type = "trait_override",
				path = {
					"target_buff_data",
					"num_stacks_on_proc"
				}
			}
		},
		impact = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "increase_impact_received_while_staggered",
				find_value_type = "buff_template",
				path = {
					"stat_buffs",
					stat_buffs.impact_modifier
				}
			}
		},
		time = {
			format_type = "number",
			find_value = {
				buff_template_name = "increase_impact_received_while_staggered",
				find_value_type = "buff_template",
				path = {
					"duration"
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_powermaul_shield_p1_staggered_targets_receive_increased_stagger_debuff = {
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
templates.weapon_trait_bespoke_powermaul_shield_p1_rending_vs_staggered = {
	format_values = {
		rending = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powermaul_shield_p1_rending_vs_staggered",
				find_value_type = "trait_override",
				path = {
					"conditional_stat_buffs",
					stat_buffs.rending_vs_staggered_multiplier
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_powermaul_shield_p1_rending_vs_staggered = {
			{
				conditional_stat_buffs = {
					[stat_buffs.rending_vs_staggered_multiplier] = 0.1
				}
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.rending_vs_staggered_multiplier] = 0.15
				}
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.rending_vs_staggered_multiplier] = 0.2
				}
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.rending_vs_staggered_multiplier] = 0.25
				}
			}
		}
	}
}
templates.weapon_trait_bespoke_powermaul_shield_p1_block_grants_power_bonus = {
	format_values = {
		power = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powermaul_shield_p1_block_grants_power_bonus_parent",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.melee_power_level_modifier
				}
			}
		},
		duration = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powermaul_shield_p1_block_grants_power_bonus_parent",
				find_value_type = "buff_template",
				path = {
					"child_duration"
				}
			}
		},
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powermaul_shield_p1_block_grants_power_bonus_child",
				find_value_type = "buff_template",
				path = {
					"max_stacks"
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_powermaul_shield_p1_block_grants_power_bonus_parent = {
			{
				stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.04
				}
			},
			{
				stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.06
				}
			},
			{
				stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.08
				}
			},
			{
				stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.1
				}
			}
		}
	}
}
templates.weapon_trait_bespoke_powermaul_shield_p1_block_break_pushes = {
	format_values = {
		block_cost = {
			prefix = "-",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powermaul_shield_p1_block_break_pushes",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.block_cost_multiplier
				}
			},
			value_manipulation = function (value)
				return 100 - value * 100
			end
		},
		cooldown = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powermaul_shield_p1_block_break_pushes",
				find_value_type = "trait_override",
				path = {
					"cooldown_duration"
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_powermaul_shield_p1_block_break_pushes = {
			{
				cooldown_duration = 18,
				stat_buffs = {
					[stat_buffs.block_cost_multiplier] = 0.85
				}
			},
			{
				cooldown_duration = 15,
				stat_buffs = {
					[stat_buffs.block_cost_multiplier] = 0.8
				}
			},
			{
				cooldown_duration = 12,
				stat_buffs = {
					[stat_buffs.block_cost_multiplier] = 0.75
				}
			},
			{
				cooldown_duration = 9,
				stat_buffs = {
					[stat_buffs.block_cost_multiplier] = 0.7
				}
			}
		}
	}
}
templates.weapon_trait_bespoke_powermaul_shield_p1_stacking_increase_impact_on_hit = {
	format_values = {
		impact = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powermaul_shield_p1_stacking_increase_impact_on_hit_parent",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.melee_impact_modifier
				}
			}
		},
		time = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powermaul_shield_p1_stacking_increase_impact_on_hit_parent",
				find_value_type = "trait_override",
				path = {
					"child_duration"
				}
			}
		},
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powermaul_shield_p1_stacking_increase_impact_on_hit_child",
				find_value_type = "buff_template",
				path = {
					"max_stacks"
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_powermaul_shield_p1_stacking_increase_impact_on_hit_parent = {
			{
				child_duration = 3.5,
				stat_buffs = {
					[stat_buffs.melee_impact_modifier] = 0.19
				}
			},
			{
				child_duration = 3.5,
				stat_buffs = {
					[stat_buffs.melee_impact_modifier] = 0.21
				}
			},
			{
				child_duration = 3.5,
				stat_buffs = {
					[stat_buffs.melee_impact_modifier] = 0.23
				}
			},
			{
				child_duration = 3.5,
				stat_buffs = {
					[stat_buffs.melee_impact_modifier] = 0.25
				}
			}
		}
	}
}
templates.weapon_trait_bespoke_powermaul_shield_p1_block_has_chance_to_stun = {
	format_values = {
		power_level = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powermaul_shield_p1_block_has_chance_to_stun",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.melee_power_level_modifier
				}
			}
		},
		duration = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powermaul_shield_p1_block_has_chance_to_stun",
				find_value_type = "buff_template",
				path = {
					"child_duration"
				}
			}
		},
		cooldown_duration = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powermaul_shield_p1_block_has_chance_to_stun",
				find_value_type = "buff_template",
				path = {
					"child_duration"
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_powermaul_shield_p1_block_has_chance_to_stun = {
			{
				proc_events = {
					[proc_events.on_perfect_block] = 1
				},
				stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.1
				}
			},
			{
				proc_events = {
					[proc_events.on_perfect_block] = 1
				},
				stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.15
				}
			},
			{
				proc_events = {
					[proc_events.on_perfect_block] = 1
				},
				stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.2
				}
			},
			{
				proc_events = {
					[proc_events.on_perfect_block] = 1
				},
				stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.25
				}
			}
		}
	}
}
templates.weapon_trait_bespoke_powermaul_shield_p1_power_bonus_scaled_on_stamina = {
	format_values = {
		power_level = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powermaul_shield_p1_power_bonus_scaled_on_stamina",
				find_value_type = "trait_override",
				path = {
					"conditional_stat_buffs",
					stat_buffs.melee_power_level_modifier
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_powermaul_shield_p1_power_bonus_scaled_on_stamina = {
			{
				conditional_stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.05
				}
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.06
				}
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.07
				}
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.08
				}
			}
		}
	}
}
templates.weapon_trait_bespoke_powermaul_shield_p1_attack_speed_on_perfect_block = {
	format_values = {
		attack_speed = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powermaul_shield_p1_attack_speed_on_perfect_block",
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
				buff_template_name = "weapon_trait_bespoke_powermaul_shield_p1_attack_speed_on_perfect_block",
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
		weapon_trait_bespoke_powermaul_shield_p1_attack_speed_on_perfect_block = {
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
templates.weapon_trait_bespoke_powermaul_shield_p1_damage_bonus_vs_electrocuted = {
	format_values = {
		damage = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powermaul_shield_p1_damage_bonus_vs_electrocuted",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.damage_vs_electrocuted
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_powermaul_shield_p1_damage_bonus_vs_electrocuted = {
			{
				stat_buffs = {
					[stat_buffs.damage_vs_electrocuted] = 0.1
				}
			},
			{
				stat_buffs = {
					[stat_buffs.damage_vs_electrocuted] = 0.15
				}
			},
			{
				stat_buffs = {
					[stat_buffs.damage_vs_electrocuted] = 0.2
				}
			},
			{
				stat_buffs = {
					[stat_buffs.damage_vs_electrocuted] = 0.25
				}
			}
		}
	}
}

return templates
