-- chunkname: @scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_combatsword_p2.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local templates = {}

table.make_unique(templates)

local stat_buffs = BuffSettings.stat_buffs

templates.weapon_trait_bespoke_combatsword_p2_increased_attack_cleave_on_multiple_hits = {
	format_values = {
		cleave = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_combatsword_p2_increased_attack_cleave_on_multiple_hits",
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
				buff_template_name = "weapon_trait_bespoke_combatsword_p2_increased_attack_cleave_on_multiple_hits",
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
				buff_template_name = "weapon_trait_bespoke_combatsword_p2_increased_attack_cleave_on_multiple_hits",
				find_value_type = "buff_template",
				path = {
					"active_duration"
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_combatsword_p2_increased_attack_cleave_on_multiple_hits = {
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
templates.weapon_trait_bespoke_combatsword_p2_increased_melee_damage_on_multiple_hits = {
	format_values = {
		damage = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_combatsword_p2_increased_melee_damage_on_multiple_hits",
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
				buff_template_name = "weapon_trait_bespoke_combatsword_p2_increased_melee_damage_on_multiple_hits",
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
				buff_template_name = "weapon_trait_bespoke_combatsword_p2_increased_melee_damage_on_multiple_hits",
				find_value_type = "trait_override",
				path = {
					"active_duration"
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_combatsword_p2_increased_melee_damage_on_multiple_hits = {
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
templates.weapon_trait_bespoke_combatsword_p2_chained_hits_increases_melee_cleave = {
	format_values = {
		cleave = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_combatsword_p2_chained_hits_increases_melee_cleave_parent",
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
				buff_template_name = "weapon_trait_bespoke_combatsword_p2_chained_hits_increases_melee_cleave_child",
				find_value_type = "buff_template",
				path = {
					"max_stacks"
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_combatsword_p2_chained_hits_increases_melee_cleave_parent = {
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
templates.weapon_trait_bespoke_combatsword_p2_increase_power_on_hit = {
	format_values = {
		power_level = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_combatsword_p2_increase_power_on_hit_parent",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.melee_power_level_modifier
				}
			}
		},
		time = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_combatsword_p2_increase_power_on_hit_parent",
				find_value_type = "buff_template",
				path = {
					"child_duration"
				}
			}
		},
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_combatsword_p2_increase_power_on_hit_child",
				find_value_type = "buff_template",
				path = {
					"max_stacks"
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_combatsword_p2_increase_power_on_hit_parent = {
			{
				stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.065
				}
			},
			{
				stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.07
				}
			},
			{
				stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.075
				}
			},
			{
				stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.08
				}
			}
		}
	}
}
templates.weapon_trait_bespoke_combatsword_p2_infinite_melee_cleave_on_weakspot_kill = {
	format_values = {
		weakspot_damage = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_combatsword_p2_infinite_melee_cleave_on_weakspot_kill",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.melee_weakspot_damage
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_combatsword_p2_infinite_melee_cleave_on_weakspot_kill = {
			{
				stat_buffs = {
					[stat_buffs.melee_weakspot_damage] = 0.075
				}
			},
			{
				stat_buffs = {
					[stat_buffs.melee_weakspot_damage] = 0.1
				}
			},
			{
				stat_buffs = {
					[stat_buffs.melee_weakspot_damage] = 0.125
				}
			},
			{
				stat_buffs = {
					[stat_buffs.melee_weakspot_damage] = 0.15
				}
			}
		}
	}
}
templates.weapon_trait_bespoke_combatsword_p2_pass_past_armor_on_crit = {
	format_values = {
		crit_damage = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_combatsword_p2_pass_past_armor_on_crit",
				find_value_type = "trait_override",
				path = {
					"conditional_stat_buffs",
					stat_buffs.melee_critical_strike_damage
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_combatsword_p2_pass_past_armor_on_crit = {
			{
				conditional_stat_buffs = {
					[stat_buffs.melee_critical_strike_damage] = 0.025
				}
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.melee_critical_strike_damage] = 0.05
				}
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.melee_critical_strike_damage] = 0.075
				}
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.melee_critical_strike_damage] = 0.1
				}
			}
		}
	}
}
templates.weapon_trait_bespoke_combatsword_p2_rending_on_multiple_hits = {
	format_values = {
		rending = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_combatsword_p2_rending_on_multiple_hits_parent",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.rending_multiplier
				}
			}
		},
		time = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_combatsword_p2_rending_on_multiple_hits_parent",
				find_value_type = "trait_override",
				path = {
					"child_duration"
				}
			}
		},
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_combatsword_p2_rending_on_multiple_hits_child",
				find_value_type = "buff_template",
				path = {
					"max_stacks"
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_combatsword_p2_rending_on_multiple_hits_parent = {
			{
				child_duration = 2.5,
				buff_data = {
					required_num_hits = 2
				},
				stat_buffs = {
					[stat_buffs.rending_multiplier] = 0.04
				}
			},
			{
				child_duration = 2.5,
				buff_data = {
					required_num_hits = 2
				},
				stat_buffs = {
					[stat_buffs.rending_multiplier] = 0.06
				}
			},
			{
				child_duration = 2.5,
				buff_data = {
					required_num_hits = 2
				},
				stat_buffs = {
					[stat_buffs.rending_multiplier] = 0.08
				}
			},
			{
				child_duration = 2.5,
				buff_data = {
					required_num_hits = 2
				},
				stat_buffs = {
					[stat_buffs.rending_multiplier] = 0.1
				}
			}
		}
	}
}
templates.weapon_trait_bespoke_combatsword_p2_windup_increases_power = {
	format_values = {
		power_level = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_combatsword_p2_windup_increases_power_parent",
				find_value_type = "trait_override",
				path = {
					"conditional_stat_buffs",
					stat_buffs.melee_power_level_modifier
				}
			}
		},
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_combatsword_p2_windup_increases_power_child",
				find_value_type = "buff_template",
				path = {
					"max_stacks"
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_combatsword_p2_windup_increases_power_parent = {
			{
				conditional_stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.05
				}
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.1
				}
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.15
				}
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.2
				}
			}
		}
	}
}
templates.weapon_trait_bespoke_combatsword_p2_increased_crit_chance_on_weakspot_kill = {
	format_values = {
		crit_chance = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_combatsword_p2_increased_crit_chance_on_weakspot_kill",
				find_value_type = "trait_override",
				path = {
					"conditional_stat_buffs",
					stat_buffs.melee_critical_strike_chance
				}
			}
		},
		time = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_combatsword_p2_increased_crit_chance_on_weakspot_kill",
				find_value_type = "buff_template",
				path = {
					"active_duration"
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_combatsword_p2_increased_crit_chance_on_weakspot_kill = {
			{
				conditional_stat_buffs = {
					[stat_buffs.melee_critical_strike_chance] = 0.05
				}
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.melee_critical_strike_chance] = 0.1
				}
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.melee_critical_strike_chance] = 0.15
				}
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.melee_critical_strike_chance] = 0.2
				}
			}
		}
	}
}

return templates
