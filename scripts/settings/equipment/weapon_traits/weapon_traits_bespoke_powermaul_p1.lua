-- chunkname: @scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_powermaul_p1.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local templates = {}

table.make_unique(templates)

local stat_buffs = BuffSettings.stat_buffs
local proc_events = BuffSettings.proc_events

templates.weapon_trait_bespoke_powermaul_p1_stacking_increase_impact_on_hit = {
	format_values = {
		impact = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powermaul_p1_stacking_increase_impact_on_hit_parent",
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
				buff_template_name = "weapon_trait_bespoke_powermaul_p1_stacking_increase_impact_on_hit_parent",
				find_value_type = "trait_override",
				path = {
					"child_duration"
				}
			}
		},
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powermaul_p1_stacking_increase_impact_on_hit_child",
				find_value_type = "buff_template",
				path = {
					"max_stacks"
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_powermaul_p1_stacking_increase_impact_on_hit_parent = {
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
templates.weapon_trait_bespoke_powermaul_p1_consecutive_hits_increases_stagger = {
	format_values = {
		impact = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powermaul_p1_consecutive_hits_increases_stagger_parent",
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
				buff_template_name = "weapon_trait_bespoke_powermaul_p1_consecutive_hits_increases_stagger_parent",
				find_value_type = "buff_template",
				path = {
					"child_duration"
				}
			}
		},
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powermaul_p1_consecutive_hits_increases_stagger_child",
				find_value_type = "buff_template",
				path = {
					"max_stacks"
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_powermaul_p1_consecutive_hits_increases_stagger_parent = {
			{
				stat_buffs = {
					[stat_buffs.melee_impact_modifier] = 0.14
				}
			},
			{
				stat_buffs = {
					[stat_buffs.melee_impact_modifier] = 0.16
				}
			},
			{
				stat_buffs = {
					[stat_buffs.melee_impact_modifier] = 0.18
				}
			},
			{
				stat_buffs = {
					[stat_buffs.melee_impact_modifier] = 0.2
				}
			}
		}
	}
}
templates.weapon_trait_bespoke_powermaul_p1_staggered_targets_receive_increased_damage_debuff = {
	format_values = {
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powermaul_p1_staggered_targets_receive_increased_damage_debuff",
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
		weapon_trait_bespoke_powermaul_p1_staggered_targets_receive_increased_damage_debuff = {
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
templates.weapon_trait_bespoke_powermaul_p1_staggered_targets_receive_increased_stagger_debuff = {
	format_values = {
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powermaul_p1_staggered_targets_receive_increased_stagger_debuff",
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
		weapon_trait_bespoke_powermaul_p1_staggered_targets_receive_increased_stagger_debuff = {
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
templates.weapon_trait_bespoke_powermaul_p1_rending_vs_staggered = {
	format_values = {
		rending = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powermaul_p1_rending_vs_staggered",
				find_value_type = "trait_override",
				path = {
					"conditional_stat_buffs",
					stat_buffs.rending_vs_staggered_multiplier
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_powermaul_p1_rending_vs_staggered = {
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
templates.weapon_trait_bespoke_powermaul_p1_negate_stagger_reduction_on_weakspot = {
	format_values = {
		stagger = {
			prefix = "+",
			num_decimals = 0,
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powermaul_p1_negate_stagger_reduction_on_weakspot",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.stagger_weakspot_reduction_modifier
				}
			},
			value_manipulation = function (value)
				return 100 - math.round(value * 100)
			end
		},
		ranged_stagger = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powermaul_p1_negate_stagger_reduction_on_weakspot",
				find_value_type = "buff_template",
				path = {
					"conditional_stat_buffs",
					stat_buffs.ranged_impact_modifier
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_powermaul_p1_negate_stagger_reduction_on_weakspot = {
			{
				stat_buffs = {
					[stat_buffs.stagger_weakspot_reduction_modifier] = 0.4
				}
			},
			{
				stat_buffs = {
					[stat_buffs.stagger_weakspot_reduction_modifier] = 0.3
				}
			},
			{
				stat_buffs = {
					[stat_buffs.stagger_weakspot_reduction_modifier] = 0.2
				}
			},
			{
				stat_buffs = {
					[stat_buffs.stagger_weakspot_reduction_modifier] = 0.1
				}
			}
		}
	}
}
templates.weapon_trait_bespoke_powermaul_p1_windup_increases_power = {
	format_values = {
		power_level = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powermaul_p1_windup_increases_power_parent",
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
				buff_template_name = "weapon_trait_bespoke_powermaul_p1_windup_increases_power_child",
				find_value_type = "buff_template",
				path = {
					"max_stacks"
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_powermaul_p1_windup_increases_power_parent = {
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
templates.weapon_trait_bespoke_powermaul_p1_block_has_chance_to_stun = {
	format_values = {
		power_level = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powermaul_p1_block_has_chance_to_stun",
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
				buff_template_name = "weapon_trait_bespoke_powermaul_p1_block_has_chance_to_stun",
				find_value_type = "buff_template",
				path = {
					"child_duration"
				}
			}
		},
		cooldown_duration = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powermaul_p1_block_has_chance_to_stun",
				find_value_type = "buff_template",
				path = {
					"child_duration"
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_powermaul_p1_block_has_chance_to_stun = {
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
templates.weapon_trait_bespoke_powermaul_p1_hitting_electrocuted_spreads = {
	format_values = {
		light = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powermaul_p1_hitting_electrocuted_spreads",
				find_value_type = "trait_override",
				path = {
					"light_proc"
				}
			}
		},
		heavy = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powermaul_p1_hitting_electrocuted_spreads",
				find_value_type = "trait_override",
				path = {
					"heavy_proc"
				}
			}
		},
		special = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powermaul_p1_hitting_electrocuted_spreads",
				find_value_type = "trait_override",
				path = {
					"special_proc"
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_powermaul_p1_hitting_electrocuted_spreads = {
			{
				light_proc = 1,
				special_proc = 1,
				heavy_proc = 2
			},
			{
				light_proc = 1,
				special_proc = 2,
				heavy_proc = 2
			},
			{
				light_proc = 1,
				special_proc = 3,
				heavy_proc = 3
			},
			{
				light_proc = 2,
				special_proc = 4,
				heavy_proc = 3
			}
		}
	}
}
templates.weapon_trait_bespoke_powermaul_p1_staggering_hits_has_chance_to_stun = {
	format_values = {
		chance = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powermaul_p1_staggering_hits_has_chance_to_stun",
				find_value_type = "trait_override",
				path = {
					"proc_events",
					proc_events.on_hit
				}
			}
		},
		cooldown = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powermaul_p1_staggering_hits_has_chance_to_stun",
				find_value_type = "trait_override",
				path = {
					"cooldown_duration"
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_powermaul_p1_staggering_hits_has_chance_to_stun = {
			{
				cooldown_duration = 5,
				proc_events = {
					[proc_events.on_hit] = 0.1
				}
			},
			{
				cooldown_duration = 4.5,
				proc_events = {
					[proc_events.on_hit] = 0.15
				}
			},
			{
				cooldown_duration = 4,
				proc_events = {
					[proc_events.on_hit] = 0.2
				}
			},
			{
				cooldown_duration = 3.5,
				proc_events = {
					[proc_events.on_hit] = 0.25
				}
			}
		}
	}
}
templates.weapon_trait_bespoke_powermaul_p1_damage_bonus_vs_electrocuted = {
	format_values = {
		damage = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powermaul_p1_damage_bonus_vs_electrocuted",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.damage_vs_electrocuted
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_powermaul_p1_damage_bonus_vs_electrocuted = {
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
