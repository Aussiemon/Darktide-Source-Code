-- chunkname: @scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_shotpistol_shield_p1.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local templates = {}

table.make_unique(templates)

local stat_buffs = BuffSettings.stat_buffs

templates.weapon_trait_bespoke_shotpistol_shield_p1_hipfire_while_sprinting = {
	format_values = {
		weapon_spread = {
			prefix = "",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_shotpistol_shield_p1_hipfire_while_sprinting",
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
				buff_template_name = "weapon_trait_bespoke_shotpistol_shield_p1_hipfire_while_sprinting",
				find_value_type = "trait_override",
				path = {
					"conditional_stat_buffs",
					stat_buffs.damage_near
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_shotpistol_shield_p1_hipfire_while_sprinting = {
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
templates.weapon_trait_bespoke_shotpistol_shield_p1_reload_speed_on_slide = {
	format_values = {
		reload_speed = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_shotpistol_shield_p1_reload_speed_on_slide_parent",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.reload_speed
				}
			}
		},
		time = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_shotpistol_shield_p1_reload_speed_on_slide_parent",
				find_value_type = "trait_override",
				path = {
					"child_duration"
				}
			}
		},
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_shotpistol_shield_p1_reload_speed_on_slide_child",
				find_value_type = "buff_template",
				path = {
					"max_stacks"
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_shotpistol_shield_p1_reload_speed_on_slide_parent = {
			{
				child_duration = 4,
				stat_buffs = {
					[stat_buffs.reload_speed] = 0.07
				}
			},
			{
				child_duration = 4,
				stat_buffs = {
					[stat_buffs.reload_speed] = 0.08
				}
			},
			{
				child_duration = 4,
				stat_buffs = {
					[stat_buffs.reload_speed] = 0.09
				}
			},
			{
				child_duration = 4,
				stat_buffs = {
					[stat_buffs.reload_speed] = 0.1
				}
			}
		}
	}
}
templates.weapon_trait_bespoke_shotpistol_shield_p1_suppression_on_close_kill = {
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
		weapon_trait_bespoke_shotpistol_shield_p1_suppression_on_close_kill = {
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
templates.weapon_trait_bespoke_shotpistol_shield_p1_crit_chance_based_on_aim_time = {
	format_values = {
		time = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_shotpistol_shield_p1_crit_chance_based_on_aim_time",
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
				buff_template_name = "weapon_trait_bespoke_shotpistol_shield_p1_crit_chance_based_on_aim_time",
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
		weapon_trait_bespoke_shotpistol_shield_p1_crit_chance_based_on_aim_time = {
			{
				duration_per_stack = 0.45,
				stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.1
				}
			},
			{
				duration_per_stack = 0.4,
				stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.1
				}
			},
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
			}
		}
	}
}
templates.weapon_trait_bespoke_shotpistol_shield_p1_crit_chance_based_on_ammo_left = {
	format_values = {
		crit_chance = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_shotpistol_shield_p1_crit_chance_based_on_ammo_left",
				find_value_type = "trait_override",
				path = {
					"conditional_stat_buffs",
					stat_buffs.critical_strike_chance
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_shotpistol_shield_p1_crit_chance_based_on_ammo_left = {
			{
				conditional_stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.045
				}
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.05
				}
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.055
				}
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.06
				}
			}
		}
	}
}
templates.weapon_trait_bespoke_shotpistol_shield_p1_chained_weakspot_hits_increases_power = {
	format_values = {
		power_level = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_shotpistol_shield_p1_chained_weakspot_hits_increases_power_parent",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.ranged_power_level_modifier
				}
			}
		},
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_shotpistol_shield_p1_chained_weakspot_hits_increases_power_child",
				find_value_type = "buff_template",
				path = {
					"max_stacks"
				}
			}
		},
		time = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_shotpistol_shield_p1_chained_weakspot_hits_increases_power_parent",
				find_value_type = "trait_override",
				path = {
					"child_duration"
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_shotpistol_shield_p1_chained_weakspot_hits_increases_power_parent = {
			{
				max_stacks = 5,
				child_duration = 3.5,
				stat_buffs = {
					[stat_buffs.ranged_power_level_modifier] = 0.045
				}
			},
			{
				max_stacks = 5,
				child_duration = 3.5,
				stat_buffs = {
					[stat_buffs.ranged_power_level_modifier] = 0.05
				}
			},
			{
				max_stacks = 5,
				child_duration = 3.5,
				stat_buffs = {
					[stat_buffs.ranged_power_level_modifier] = 0.055
				}
			},
			{
				max_stacks = 5,
				child_duration = 3.5,
				stat_buffs = {
					[stat_buffs.ranged_power_level_modifier] = 0.06
				}
			}
		}
	}
}
templates.weapon_trait_bespoke_shotpistol_shield_p1_crit_chance_bonus_on_melee_kills = {
	format_values = {
		crit_chance = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_shotpistol_shield_p1_crit_chance_bonus_on_melee_kills",
				find_value_type = "trait_override",
				path = {
					"proc_stat_buffs",
					stat_buffs.ranged_critical_strike_chance
				}
			}
		},
		time = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_shotpistol_shield_p1_crit_chance_bonus_on_melee_kills",
				find_value_type = "trait_override",
				path = {
					"active_duration"
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_shotpistol_shield_p1_crit_chance_bonus_on_melee_kills = {
			{
				active_duration = 2.5,
				proc_stat_buffs = {
					[stat_buffs.ranged_critical_strike_chance] = 0.14
				}
			},
			{
				active_duration = 2.5,
				proc_stat_buffs = {
					[stat_buffs.ranged_critical_strike_chance] = 0.16
				}
			},
			{
				active_duration = 2.5,
				proc_stat_buffs = {
					[stat_buffs.ranged_critical_strike_chance] = 0.18
				}
			},
			{
				active_duration = 2.5,
				proc_stat_buffs = {
					[stat_buffs.ranged_critical_strike_chance] = 0.2
				}
			}
		}
	}
}
templates.weapon_trait_bespoke_shotpistol_shield_p1_toughness_on_elite_kills = {
	format_values = {
		toughness = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_shotpistol_shield_p1_toughness_on_elite_kills",
				find_value_type = "trait_override",
				path = {
					"toughness_fixed_percentage"
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_shotpistol_shield_p1_toughness_on_elite_kills = {
			{
				toughness_fixed_percentage = 0.18
			},
			{
				toughness_fixed_percentage = 0.22
			},
			{
				toughness_fixed_percentage = 0.26
			},
			{
				toughness_fixed_percentage = 0.3
			}
		}
	}
}
templates.weapon_trait_bespoke_shotpistol_shield_p1_followup_shots_ranged_damage = {
	format_values = {
		damage = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_shotpistol_shield_p1_followup_shots_ranged_damage",
				find_value_type = "trait_override",
				path = {
					"conditional_stat_buffs",
					stat_buffs.ranged_damage
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_shotpistol_shield_p1_followup_shots_ranged_damage = {
			{
				conditional_stat_buffs = {
					[stat_buffs.ranged_damage] = 0.14
				}
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.ranged_damage] = 0.16
				}
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.ranged_damage] = 0.18
				}
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.ranged_damage] = 0.2
				}
			}
		}
	}
}
templates.weapon_trait_bespoke_shotpistol_shield_p1_rending_on_crit = {
	format_values = {
		rend = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_shotpistol_shield_p1_rending_on_crit",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.critical_strike_rending_multiplier
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_shotpistol_shield_p1_rending_on_crit = {
			{
				stat_buffs = {
					[stat_buffs.critical_strike_rending_multiplier] = 0.3
				}
			},
			{
				stat_buffs = {
					[stat_buffs.critical_strike_rending_multiplier] = 0.4
				}
			},
			{
				stat_buffs = {
					[stat_buffs.critical_strike_rending_multiplier] = 0.5
				}
			},
			{
				stat_buffs = {
					[stat_buffs.critical_strike_rending_multiplier] = 0.6
				}
			}
		}
	}
}
templates.weapon_trait_bespoke_shotpistol_shield_p1_windup_increases_power = {
	format_values = {
		power_level = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_shotpistol_shield_p1_windup_increases_power",
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
				buff_template_name = "weapon_trait_bespoke_shotpistol_shield_p1_windup_increases_power",
				find_value_type = "trait_override",
				path = {
					"duration_per_stack"
				}
			}
		},
		stacks = {
			value = "5",
			format_type = "string"
		}
	},
	buffs = {
		weapon_trait_bespoke_shotpistol_shield_p1_windup_increases_power = {
			{
				duration_per_stack = 0.4,
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.05
				}
			},
			{
				duration_per_stack = 0.4,
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.06
				}
			},
			{
				duration_per_stack = 0.4,
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.07
				}
			},
			{
				duration_per_stack = 0.4,
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.08
				}
			}
		}
	}
}
templates.weapon_trait_bespoke_shotpistol_shield_p1_increase_power_on_close_kill = {
	format_values = {
		power_level = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_shotpistol_shield_p1_increase_power_on_close_kill_parent",
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
				buff_template_name = "weapon_trait_bespoke_shotpistol_shield_p1_increase_power_on_close_kill_parent",
				find_value_type = "trait_override",
				path = {
					"child_duration"
				}
			}
		},
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_shotpistol_shield_p1_increase_power_on_close_kill_child",
				find_value_type = "buff_template",
				path = {
					"max_stacks"
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_shotpistol_shield_p1_increase_power_on_close_kill_parent = {
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
templates.weapon_trait_bespoke_shotpistol_shield_p1_increase_close_damage_on_close_kill = {
	format_values = {
		close_damage = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_shotpistol_shield_p1_increase_close_damage_on_close_kill_parent",
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
				buff_template_name = "weapon_trait_bespoke_shotpistol_shield_p1_increase_close_damage_on_close_kill_parent",
				find_value_type = "trait_override",
				path = {
					"child_duration"
				}
			}
		},
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_shotpistol_shield_p1_increase_close_damage_on_close_kill_child",
				find_value_type = "buff_template",
				path = {
					"max_stacks"
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_shotpistol_shield_p1_increase_close_damage_on_close_kill_parent = {
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
templates.weapon_trait_bespoke_shotpistol_shield_p1_power_bonus_on_hitting_single_enemy_with_all = {
	format_values = {
		power_level = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_shotpistol_shield_p1_power_bonus_on_hitting_single_enemy_with_all",
				find_value_type = "trait_override",
				path = {
					"proc_stat_buffs",
					stat_buffs.power_level_modifier
				}
			}
		},
		time = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_shotpistol_shield_p1_power_bonus_on_hitting_single_enemy_with_all",
				find_value_type = "buff_template",
				path = {
					"active_duration"
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_shotpistol_shield_p1_power_bonus_on_hitting_single_enemy_with_all = {
			{
				proc_stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.14
				}
			},
			{
				proc_stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.16
				}
			},
			{
				proc_stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.18
				}
			},
			{
				proc_stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.2
				}
			}
		}
	}
}
templates.weapon_trait_bespoke_shotpistol_shield_p1_bleed_on_crit = {
	format_values = {
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_shotpistol_shield_p1_bleed_on_crit",
				find_value_type = "trait_override",
				path = {
					"target_buff_data",
					"num_stacks_on_proc"
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_shotpistol_shield_p1_bleed_on_crit = {
			{
				target_buff_data = {
					num_stacks_on_proc = 3
				}
			},
			{
				target_buff_data = {
					num_stacks_on_proc = 4
				}
			},
			{
				target_buff_data = {
					num_stacks_on_proc = 5
				}
			},
			{
				target_buff_data = {
					num_stacks_on_proc = 6
				}
			}
		}
	}
}
templates.weapon_trait_bespoke_shotpistol_shield_p1_crit_chance_on_hitting_multiple_with_one_shot = {
	format_values = {
		crit_chance = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_shotpistol_shield_p1_crit_chance_on_hitting_multiple_with_one_shot_parent",
				find_value_type = "trait_override",
				path = {
					"conditional_stat_buffs",
					stat_buffs.ranged_critical_strike_chance
				}
			}
		},
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_shotpistol_shield_p1_crit_chance_on_hitting_multiple_with_one_shot_child",
				find_value_type = "buff_template",
				path = {
					"max_stacks"
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_shotpistol_shield_p1_crit_chance_on_hitting_multiple_with_one_shot_parent = {
			{
				conditional_stat_buffs = {
					[stat_buffs.ranged_critical_strike_chance] = 0.06
				}
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.ranged_critical_strike_chance] = 0.08
				}
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.ranged_critical_strike_chance] = 0.1
				}
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.ranged_critical_strike_chance] = 0.12
				}
			}
		}
	}
}
templates.weapon_trait_bespoke_shotpistol_shield_p1_stagger_count_bonus_damage = {
	format_values = {
		damage = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_shotpistol_shield_p1_stagger_count_bonus_damage",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.stagger_count_damage
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_shotpistol_shield_p1_stagger_count_bonus_damage = {
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
templates.weapon_trait_bespoke_shotpistol_shield_p1_cleave_on_crit = {
	format_values = {
		stagger = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_shotpistol_shield_p1_cleave_on_crit",
				find_value_type = "trait_override",
				path = {
					"conditional_stat_buffs",
					stat_buffs.ranged_impact_modifier
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_shotpistol_shield_p1_cleave_on_crit = {
			{
				conditional_stat_buffs = {
					[stat_buffs.ranged_impact_modifier] = 0.1
				}
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.ranged_impact_modifier] = 0.15
				}
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.ranged_impact_modifier] = 0.2
				}
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.ranged_impact_modifier] = 0.25
				}
			}
		}
	}
}
templates.weapon_trait_bespoke_shotpistol_shield_p1_damage_bonus_vs_electrocuted = {
	format_values = {
		damage = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_shotpistol_shield_p1_damage_bonus_vs_electrocuted",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.damage_vs_electrocuted
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_shotpistol_shield_p1_damage_bonus_vs_electrocuted = {
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
