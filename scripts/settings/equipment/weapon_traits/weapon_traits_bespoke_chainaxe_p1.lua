-- chunkname: @scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_chainaxe_p1.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local templates = {}

table.make_unique(templates)

local stat_buffs = BuffSettings.stat_buffs

templates.weapon_trait_bespoke_chainaxe_p1_guaranteed_melee_crit_on_activated_kill = {
	format_values = {
		crit_chance = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_chainaxe_p1_guaranteed_melee_crit_on_activated_kill",
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
		weapon_trait_bespoke_chainaxe_p1_guaranteed_melee_crit_on_activated_kill = {
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
templates.weapon_trait_bespoke_chainaxe_p1_bleed_on_activated_hit = {
	format_values = {
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_chainaxe_p1_bleed_on_activated_hit",
				find_value_type = "trait_override",
				path = {
					"target_buff_data",
					"num_stacks_on_proc"
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_chainaxe_p1_bleed_on_activated_hit = {
			{
				target_buff_data = {
					num_stacks_on_proc = 10
				}
			},
			{
				target_buff_data = {
					num_stacks_on_proc = 12
				}
			},
			{
				target_buff_data = {
					num_stacks_on_proc = 14
				}
			},
			{
				target_buff_data = {
					num_stacks_on_proc = 16
				}
			}
		}
	}
}
templates.weapon_trait_bespoke_chainaxe_p1_movement_speed_on_activation = {
	format_values = {
		movement_speed = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_chainaxe_p1_movement_speed_on_activation",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.movement_speed
				}
			}
		},
		time = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_chainaxe_p1_movement_speed_on_activation",
				find_value_type = "buff_template",
				path = {
					"active_duration"
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_chainaxe_p1_movement_speed_on_activation = {
			{
				active_duration = 2,
				stat_buffs = {
					[stat_buffs.movement_speed] = 0.17
				}
			},
			{
				active_duration = 2,
				stat_buffs = {
					[stat_buffs.movement_speed] = 0.18
				}
			},
			{
				active_duration = 2,
				stat_buffs = {
					[stat_buffs.movement_speed] = 0.19
				}
			},
			{
				active_duration = 2,
				stat_buffs = {
					[stat_buffs.movement_speed] = 0.2
				}
			}
		}
	}
}
templates.weapon_trait_bespoke_chainaxe_p1_increase_power_on_hit = {
	format_values = {
		power_level = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_chainaxe_p1_increase_power_on_hit_parent",
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
				buff_template_name = "weapon_trait_bespoke_chainaxe_p1_increase_power_on_hit_parent",
				find_value_type = "buff_template",
				path = {
					"child_duration"
				}
			}
		},
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_chainaxe_p1_increase_power_on_hit_child",
				find_value_type = "buff_template",
				path = {
					"max_stacks"
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_chainaxe_p1_increase_power_on_hit_parent = {
			{
				stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.035
				}
			},
			{
				stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.04
				}
			},
			{
				stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.045
				}
			},
			{
				stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.05
				}
			}
		}
	}
}
templates.weapon_trait_bespoke_chainaxe_p1_increase_power_on_kill = {
	format_values = {
		power_level = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_chainaxe_p1_increase_power_on_kill_parent",
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
				buff_template_name = "weapon_trait_bespoke_chainaxe_p1_increase_power_on_kill_parent",
				find_value_type = "buff_template",
				path = {
					"child_duration"
				}
			}
		},
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_chainaxe_p1_increase_power_on_kill_child",
				find_value_type = "buff_template",
				path = {
					"max_stacks"
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_chainaxe_p1_increase_power_on_kill_parent = {
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
templates.weapon_trait_bespoke_chainaxe_p1_windup_increases_power = {
	format_values = {
		power_level = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_chainaxe_p1_windup_increases_power_parent",
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
				buff_template_name = "weapon_trait_bespoke_chainaxe_p1_windup_increases_power_child",
				find_value_type = "buff_template",
				path = {
					"max_stacks"
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_chainaxe_p1_windup_increases_power_parent = {
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
templates.weapon_trait_bespoke_chainaxe_p1_targets_receive_rending_debuff = {
	format_values = {
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_chainaxe_p1_targets_receive_rending_debuff",
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
		weapon_trait_bespoke_chainaxe_p1_targets_receive_rending_debuff = {
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
templates.weapon_trait_bespoke_chainaxe_p1_rending_vs_staggered = {
	format_values = {
		rending = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_chainaxe_p1_rending_vs_staggered",
				find_value_type = "trait_override",
				path = {
					"conditional_stat_buffs",
					stat_buffs.rending_vs_staggered_multiplier
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_chainaxe_p1_rending_vs_staggered = {
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

return templates
