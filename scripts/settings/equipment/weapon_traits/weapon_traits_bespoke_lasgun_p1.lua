-- chunkname: @scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_lasgun_p1.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local templates = {}

table.make_unique(templates)

local stat_buffs = BuffSettings.stat_buffs
local proc_events = BuffSettings.proc_events

templates.weapon_trait_bespoke_lasgun_p1_increased_zoom = {
	format_values = {
		fov_multiplier = {
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_lasgun_p1_increased_zoom",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.fov_multiplier
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_lasgun_p1_increased_zoom = {
			{
				stat_buffs = {
					[stat_buffs.fov_multiplier] = 0.85
				}
			},
			{
				stat_buffs = {
					[stat_buffs.fov_multiplier] = 0.85
				}
			},
			{
				stat_buffs = {
					[stat_buffs.fov_multiplier] = 0.85
				}
			},
			{
				stat_buffs = {
					[stat_buffs.fov_multiplier] = 0.85
				}
			}
		}
	}
}
templates.weapon_trait_bespoke_lasgun_p1_first_shot_ammo_cost_reduction = {
	format_values = {
		time = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_lasgun_p1_first_shot_ammo_cost_reduction",
				find_value_type = "trait_override",
				path = {
					"cooldown_duration"
				}
			}
		},
		ammo = {
			value = "33%",
			format_type = "string"
		}
	},
	buffs = {
		weapon_trait_bespoke_lasgun_p1_first_shot_ammo_cost_reduction = {
			{
				cooldown_duration = 5.5,
				proc_events = {
					[proc_events.on_shoot] = 1
				}
			},
			{
				cooldown_duration = 5,
				proc_events = {
					[proc_events.on_shoot] = 1
				}
			},
			{
				cooldown_duration = 4.5,
				proc_events = {
					[proc_events.on_shoot] = 1
				}
			},
			{
				cooldown_duration = 4,
				proc_events = {
					[proc_events.on_shoot] = 1
				}
			}
		}
	}
}
templates.weapon_trait_bespoke_lasgun_p1_suppression_negation_on_weakspot = {
	format_values = {
		time = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_lasgun_p1_suppression_negation_on_weakspot",
				find_value_type = "trait_override",
				path = {
					"active_duration"
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_lasgun_p1_suppression_negation_on_weakspot = {
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
templates.weapon_trait_bespoke_lasgun_p1_stacking_crit_chance_on_weakspot = {
	format_values = {
		crit_chance = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_lasgun_p1_stacking_crit_chance_on_weakspot_parent",
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
				buff_template_name = "weapon_trait_bespoke_lasgun_p1_stacking_crit_chance_on_weakspot_parent",
				find_value_type = "trait_override",
				path = {
					"max_stacks"
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_lasgun_p1_stacking_crit_chance_on_weakspot_parent = {
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
templates.weapon_trait_bespoke_lasgun_p1_count_as_dodge_vs_ranged_on_weakspot = {
	format_values = {
		time = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_lasgun_p1_count_as_dodge_vs_ranged_on_weakspot",
				find_value_type = "trait_override",
				path = {
					"active_duration"
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_lasgun_p1_count_as_dodge_vs_ranged_on_weakspot = {
			{
				active_duration = 0.6
			},
			{
				active_duration = 0.8
			},
			{
				active_duration = 1
			},
			{
				active_duration = 1.2
			}
		}
	}
}
templates.weapon_trait_bespoke_lasgun_p1_negate_stagger_reduction_on_weakspot = {
	format_values = {
		stagger = {
			prefix = "+",
			num_decimals = 0,
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_lasgun_p1_negate_stagger_reduction_on_weakspot",
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
				buff_template_name = "weapon_trait_bespoke_lasgun_p1_negate_stagger_reduction_on_weakspot",
				find_value_type = "buff_template",
				path = {
					"conditional_stat_buffs",
					stat_buffs.ranged_impact_modifier
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_lasgun_p1_negate_stagger_reduction_on_weakspot = {
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
templates.weapon_trait_bespoke_lasgun_p1_stagger_count_bonus_damage = {
	format_values = {
		damage = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_lasgun_p1_stagger_count_bonus_damage",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.stagger_count_damage
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_lasgun_p1_stagger_count_bonus_damage = {
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
templates.weapon_trait_bespoke_lasgun_p1_burninating_on_crit = {
	format_values = {
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_lasgun_p1_burninating_on_crit",
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
				buff_template_name = "weapon_trait_bespoke_lasgun_p1_burninating_on_crit",
				find_value_type = "trait_override",
				path = {
					"target_buff_data",
					"max_stacks"
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_lasgun_p1_burninating_on_crit = {
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
templates.weapon_trait_bespoke_lasgun_p1_crit_weakspot_finesse = {
	format_values = {
		crit_weakspot_damage = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_lasgun_p1_crit_weakspot_finesse",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.critical_strike_weakspot_damage
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_lasgun_p1_crit_weakspot_finesse = {
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
templates.weapon_trait_bespoke_lasgun_p1_power_bonus_on_first_shot = {
	format_values = {
		power_level = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_autogun_p3_power_bonus_on_first_shot",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.ranged_power_level_modifier
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_autogun_p3_power_bonus_on_first_shot = {
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

return templates
