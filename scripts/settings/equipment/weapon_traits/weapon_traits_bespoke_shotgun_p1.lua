-- chunkname: @scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_shotgun_p1.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local templates = {}

table.make_unique(templates)

local stat_buffs = BuffSettings.stat_buffs

templates.weapon_trait_bespoke_shotgun_p1_increase_power_on_close_kill = {
	format_values = {
		power_level = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_shotgun_p1_increase_power_on_close_kill_parent",
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
				buff_template_name = "weapon_trait_bespoke_shotgun_p1_increase_power_on_close_kill_parent",
				find_value_type = "trait_override",
				path = {
					"child_duration"
				}
			}
		},
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_shotgun_p1_increase_power_on_close_kill_child",
				find_value_type = "buff_template",
				path = {
					"max_stacks"
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_shotgun_p1_increase_power_on_close_kill_parent = {
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
templates.weapon_trait_bespoke_shotgun_p1_increase_close_damage_on_close_kill = {
	format_values = {
		close_damage = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_shotgun_p1_increase_close_damage_on_close_kill_parent",
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
				buff_template_name = "weapon_trait_bespoke_shotgun_p1_increase_close_damage_on_close_kill_parent",
				find_value_type = "trait_override",
				path = {
					"child_duration"
				}
			}
		},
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_shotgun_p1_increase_close_damage_on_close_kill_child",
				find_value_type = "buff_template",
				path = {
					"max_stacks"
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_shotgun_p1_increase_close_damage_on_close_kill_parent = {
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
templates.weapon_trait_bespoke_shotgun_p1_count_as_dodge_vs_ranged_on_close_kill = {
	format_values = {
		time = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_shotgun_p1_count_as_dodge_vs_ranged_on_close_kill",
				find_value_type = "trait_override",
				path = {
					"active_duration"
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_shotgun_p1_count_as_dodge_vs_ranged_on_close_kill = {
			{
				active_duration = 0.7
			},
			{
				active_duration = 0.8
			},
			{
				active_duration = 0.9
			},
			{
				active_duration = 1
			}
		}
	}
}
templates.weapon_trait_bespoke_shotgun_p1_suppression_on_close_kill = {
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
		weapon_trait_bespoke_shotgun_p1_suppression_on_close_kill = {
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
templates.weapon_trait_bespoke_shotgun_p1_power_bonus_on_hitting_single_enemy_with_all = {
	format_values = {
		power_level = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_shotgun_p1_power_bonus_on_hitting_single_enemy_with_all",
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
				buff_template_name = "weapon_trait_bespoke_shotgun_p1_power_bonus_on_hitting_single_enemy_with_all",
				find_value_type = "buff_template",
				path = {
					"active_duration"
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_shotgun_p1_power_bonus_on_hitting_single_enemy_with_all = {
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
templates.weapon_trait_bespoke_shotgun_p1_bleed_on_crit = {
	format_values = {
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_shotgun_p1_bleed_on_crit",
				find_value_type = "trait_override",
				path = {
					"target_buff_data",
					"num_stacks_on_proc"
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_shotgun_p1_bleed_on_crit = {
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
templates.weapon_trait_bespoke_shotgun_p1_crit_chance_on_hitting_multiple_with_one_shot = {
	format_values = {
		crit_chance = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_shotgun_p1_crit_chance_on_hitting_multiple_with_one_shot_parent",
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
				buff_template_name = "weapon_trait_bespoke_shotgun_p1_crit_chance_on_hitting_multiple_with_one_shot_child",
				find_value_type = "buff_template",
				path = {
					"max_stacks"
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_shotgun_p1_crit_chance_on_hitting_multiple_with_one_shot_parent = {
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
templates.weapon_trait_bespoke_shotgun_p1_stagger_count_bonus_damage = {
	format_values = {
		damage = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_shotgun_p1_stagger_count_bonus_damage",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.stagger_count_damage
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_shotgun_p1_stagger_count_bonus_damage = {
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
templates.weapon_trait_bespoke_shotgun_p1_cleave_on_crit = {
	format_values = {
		stagger = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_shotgun_p1_cleave_on_crit",
				find_value_type = "trait_override",
				path = {
					"conditional_stat_buffs",
					stat_buffs.ranged_impact_modifier
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_shotgun_p1_cleave_on_crit = {
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

return templates
