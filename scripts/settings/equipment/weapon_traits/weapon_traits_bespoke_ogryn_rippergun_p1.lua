-- chunkname: @scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_ogryn_rippergun_p1.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local stat_buffs = BuffSettings.stat_buffs
local templates = {}

table.make_unique(templates)

templates.weapon_trait_bespoke_ogryn_rippergun_p1_suppression_on_close_kill = {
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
		weapon_trait_bespoke_ogryn_rippergun_p1_suppression_on_close_kill = {
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
templates.weapon_trait_bespoke_ogryn_rippergun_p1_increase_close_damage_on_close_kill = {
	format_values = {
		close_damage = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_rippergun_p1_increase_close_damage_on_close_kill_parent",
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
				buff_template_name = "weapon_trait_bespoke_ogryn_rippergun_p1_increase_close_damage_on_close_kill_parent",
				find_value_type = "trait_override",
				path = {
					"child_duration"
				}
			}
		},
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_rippergun_p1_increase_close_damage_on_close_kill_child",
				find_value_type = "buff_template",
				path = {
					"max_stacks"
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_ogryn_rippergun_p1_increase_close_damage_on_close_kill_parent = {
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
templates.weapon_trait_bespoke_ogryn_rippergun_p1_toughness_on_close_range_kills = {
	format_values = {
		toughness = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_rippergun_p1_toughness_on_close_range_kills",
				find_value_type = "trait_override",
				path = {
					"toughness_fixed_percentage"
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_ogryn_rippergun_p1_toughness_on_close_range_kills = {
			{
				toughness_fixed_percentage = 0.045
			},
			{
				toughness_fixed_percentage = 0.05
			},
			{
				toughness_fixed_percentage = 0.055
			},
			{
				toughness_fixed_percentage = 0.06
			}
		}
	}
}
templates.weapon_trait_bespoke_ogryn_rippergun_p1_targets_receive_rending_debuff_on_weapon_special = {
	format_values = {
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_rippergun_p1_targets_receive_rending_debuff_on_weapon_special",
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
		weapon_trait_bespoke_ogryn_rippergun_p1_targets_receive_rending_debuff_on_weapon_special = {
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
templates.weapon_trait_bespoke_ogryn_rippergun_p1_stacking_crit_bonus_on_continuous_fire = {
	format_values = {
		crit_chance = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_rippergun_p1_stacking_crit_bonus_on_continuous_fire",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.critical_strike_chance
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
		weapon_trait_bespoke_ogryn_rippergun_p1_stacking_crit_bonus_on_continuous_fire = {
			{
				stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.035
				}
			},
			{
				stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.04
				}
			},
			{
				stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.045
				}
			},
			{
				stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.05
				}
			}
		}
	}
}
templates.weapon_trait_bespoke_ogryn_rippergun_p1_toughness_on_continuous_fire = {
	format_values = {
		toughness = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_rippergun_p1_toughness_on_continuous_fire",
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
		weapon_trait_bespoke_ogryn_rippergun_p1_toughness_on_continuous_fire = {
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
templates.weapon_trait_bespoke_ogryn_rippergun_p1_power_bonus_on_continuous_fire = {
	format_values = {
		power_level = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_rippergun_p1_power_bonus_on_continuous_fire",
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
		weapon_trait_bespoke_ogryn_rippergun_p1_power_bonus_on_continuous_fire = {
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
templates.weapon_trait_bespoke_ogryn_rippergun_p1_bleed_on_crit = {
	format_values = {
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_rippergun_p1_bleed_on_crit",
				find_value_type = "trait_override",
				path = {
					"target_buff_data",
					"num_stacks_on_proc"
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_ogryn_rippergun_p1_bleed_on_crit = {
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

return templates
