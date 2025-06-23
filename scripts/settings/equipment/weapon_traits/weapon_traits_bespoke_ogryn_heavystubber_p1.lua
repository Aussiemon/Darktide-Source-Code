-- chunkname: @scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_ogryn_heavystubber_p1.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local stat_buffs = BuffSettings.stat_buffs
local templates = {}

table.make_unique(templates)

templates.weapon_trait_bespoke_ogryn_heavystubber_p1_toughness_on_continuous_fire = {
	format_values = {
		toughness = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_heavystubber_p1_toughness_on_continuous_fire",
				find_value_type = "trait_override",
				path = {
					"toughness_fixed_percentage"
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
		weapon_trait_bespoke_ogryn_heavystubber_p1_toughness_on_continuous_fire = {
			{
				toughness_fixed_percentage = 0.01
			},
			{
				toughness_fixed_percentage = 0.02
			},
			{
				toughness_fixed_percentage = 0.03
			},
			{
				toughness_fixed_percentage = 0.04
			}
		}
	}
}
templates.weapon_trait_bespoke_ogryn_heavystubber_p1_power_bonus_on_continuous_fire = {
	format_values = {
		power_level = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_heavystubber_p1_power_bonus_on_continuous_fire",
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
		weapon_trait_bespoke_ogryn_heavystubber_p1_power_bonus_on_continuous_fire = {
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
templates.weapon_trait_bespoke_ogryn_heavystubber_p1_increased_suppression_on_continuous_fire = {
	format_values = {
		suppression = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_heavystubber_p1_increased_suppression_on_continuous_fire",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.suppression_dealt
				}
			}
		},
		damage_vs_suppressed = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_heavystubber_p1_increased_suppression_on_continuous_fire",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.damage_vs_suppressed
				}
			}
		},
		ammo = {
			value = "2.5%",
			format_type = "string"
		},
		stacks = {
			value = "5",
			format_type = "string"
		}
	},
	buffs = {
		weapon_trait_bespoke_ogryn_heavystubber_p1_increased_suppression_on_continuous_fire = {
			{
				stat_buffs = {
					[stat_buffs.suppression_dealt] = 0.2,
					[stat_buffs.damage_vs_suppressed] = 0.06
				}
			},
			{
				stat_buffs = {
					[stat_buffs.suppression_dealt] = 0.2,
					[stat_buffs.damage_vs_suppressed] = 0.06
				}
			},
			{
				stat_buffs = {
					[stat_buffs.suppression_dealt] = 0.2,
					[stat_buffs.damage_vs_suppressed] = 0.06
				}
			},
			{
				stat_buffs = {
					[stat_buffs.suppression_dealt] = 0.2,
					[stat_buffs.damage_vs_suppressed] = 0.06
				}
			}
		}
	}
}
templates.weapon_trait_bespoke_ogryn_heavystubber_p1_movement_speed_on_continous_fire = {
	format_values = {
		movement_speed = {
			prefix = "-",
			num_decimals = 0,
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_heavystubber_p1_movement_speed_on_continous_fire",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.alternate_fire_movement_speed_reduction_modifier
				}
			},
			value_manipulation = function (value)
				return 100 - math.round(value * 100)
			end
		},
		ammo = {
			value = "5%",
			format_type = "string"
		},
		stacks = {
			value = "5",
			format_type = "string"
		}
	},
	buffs = {
		weapon_trait_bespoke_ogryn_heavystubber_p1_movement_speed_on_continous_fire = {
			{
				stat_buffs = {
					[stat_buffs.alternate_fire_movement_speed_reduction_modifier] = 0.93,
					[stat_buffs.weapon_action_movespeed_reduction_multiplier] = 0.93
				}
			},
			{
				stat_buffs = {
					[stat_buffs.alternate_fire_movement_speed_reduction_modifier] = 0.92,
					[stat_buffs.weapon_action_movespeed_reduction_multiplier] = 0.92
				}
			},
			{
				stat_buffs = {
					[stat_buffs.alternate_fire_movement_speed_reduction_modifier] = 0.91,
					[stat_buffs.weapon_action_movespeed_reduction_multiplier] = 0.91
				}
			},
			{
				stat_buffs = {
					[stat_buffs.alternate_fire_movement_speed_reduction_modifier] = 0.9,
					[stat_buffs.weapon_action_movespeed_reduction_multiplier] = 0.9
				}
			}
		}
	}
}
templates.weapon_trait_bespoke_ogryn_heavystubber_p1_increase_power_on_close_kill = {
	format_values = {
		power_level = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_heavystubber_p1_increase_power_on_close_kill_parent",
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
				buff_template_name = "weapon_trait_bespoke_ogryn_heavystubber_p1_increase_power_on_close_kill_parent",
				find_value_type = "trait_override",
				path = {
					"child_duration"
				}
			}
		},
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_heavystubber_p1_increase_power_on_close_kill_child",
				find_value_type = "buff_template",
				path = {
					"max_stacks"
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_ogryn_heavystubber_p1_increase_power_on_close_kill_parent = {
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
templates.weapon_trait_bespoke_ogryn_heavystubber_p1_consecutive_hits_increases_ranged_power = {
	format_values = {
		power = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_heavystubber_p1_consecutive_hits_increases_ranged_power_parent",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.ranged_power_level_modifier
				}
			}
		},
		hit = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_heavystubber_p1_consecutive_hits_increases_ranged_power_parent",
				find_value_type = "trait_override",
				path = {
					"number_of_hits_per_stack"
				}
			}
		},
		time = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_heavystubber_p1_consecutive_hits_increases_ranged_power_parent",
				find_value_type = "trait_override",
				path = {
					"child_duration"
				}
			}
		},
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_heavystubber_p1_consecutive_hits_increases_ranged_power_parent",
				find_value_type = "trait_override",
				path = {
					"child_max_stacks"
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_ogryn_heavystubber_p1_consecutive_hits_increases_ranged_power_parent = {
			{
				child_max_stacks = 5,
				number_of_hits_per_stack = 4,
				child_duration = 2,
				stat_buffs = {
					[stat_buffs.ranged_power_level_modifier] = 0.07
				}
			},
			{
				child_max_stacks = 5,
				number_of_hits_per_stack = 4,
				child_duration = 2,
				stat_buffs = {
					[stat_buffs.ranged_power_level_modifier] = 0.08
				}
			},
			{
				child_max_stacks = 5,
				number_of_hits_per_stack = 4,
				child_duration = 2,
				stat_buffs = {
					[stat_buffs.ranged_power_level_modifier] = 0.09
				}
			},
			{
				child_max_stacks = 5,
				number_of_hits_per_stack = 4,
				child_duration = 2,
				stat_buffs = {
					[stat_buffs.ranged_power_level_modifier] = 0.1
				}
			}
		}
	}
}
templates.weapon_trait_bespoke_ogryn_heavystubber_p1_ammo_from_reserve_on_crit = {
	format_values = {
		bullet_amount = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_heavystubber_p1_ammo_from_reserve_on_crit",
				find_value_type = "trait_override",
				path = {
					"num_ammmo_to_move"
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_ogryn_heavystubber_p1_ammo_from_reserve_on_crit = {
			{
				num_ammmo_to_move = 2
			},
			{
				num_ammmo_to_move = 3
			},
			{
				num_ammmo_to_move = 4
			},
			{
				num_ammmo_to_move = 5
			}
		}
	}
}
templates.weapon_trait_bespoke_heavystubber_p1_suppression_on_close_kill = {
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
		weapon_trait_bespoke_heavystubber_p1_suppression_on_close_kill = {
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
templates.weapon_trait_bespoke_heavystubber_p1_increase_close_damage_on_close_kill = {
	format_values = {
		close_damage = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_heavystubber_p1_increase_close_damage_on_close_kill_parent",
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
				buff_template_name = "weapon_trait_bespoke_heavystubber_p1_increase_close_damage_on_close_kill_parent",
				find_value_type = "trait_override",
				path = {
					"child_duration"
				}
			}
		},
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_heavystubber_p1_increase_close_damage_on_close_kill_child",
				find_value_type = "buff_template",
				path = {
					"max_stacks"
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_heavystubber_p1_increase_close_damage_on_close_kill_parent = {
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

return templates
