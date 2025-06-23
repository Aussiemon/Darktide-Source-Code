-- chunkname: @scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_ogryn_thumper_p1.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local stat_buffs = BuffSettings.stat_buffs
local templates = {}

table.make_unique(templates)

templates.weapon_trait_bespoke_ogryn_thumper_p1_hipfire_while_sprinting = {
	format_values = {
		weapon_spread = {
			prefix = "",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_thumper_p1_hipfire_while_sprinting",
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
				buff_template_name = "weapon_trait_bespoke_ogryn_thumper_p1_hipfire_while_sprinting",
				find_value_type = "trait_override",
				path = {
					"conditional_stat_buffs",
					stat_buffs.damage_near
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_ogryn_thumper_p1_hipfire_while_sprinting = {
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
templates.weapon_trait_bespoke_ogryn_thumper_p1_suppression_on_close_kill = {
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
		weapon_trait_bespoke_ogryn_thumper_p1_suppression_on_close_kill = {
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
templates.weapon_trait_bespoke_ogryn_thumper_p1_toughness_on_continuous_fire = {
	format_values = {
		toughness = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_thumper_p1_toughness_on_continuous_fire",
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
		weapon_trait_bespoke_ogryn_thumper_p1_toughness_on_continuous_fire = {
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
templates.weapon_trait_bespoke_ogryn_thumper_p1_power_bonus_on_continuous_fire = {
	format_values = {
		power_level = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_thumper_p1_power_bonus_on_continuous_fire",
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
		weapon_trait_bespoke_ogryn_thumper_p1_power_bonus_on_continuous_fire = {
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
			},
			{
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.09
				}
			}
		}
	}
}
templates.weapon_trait_bespoke_ogryn_thumper_p1_crit_chance_based_on_aim_time = {
	format_values = {
		time = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_thumper_p1_crit_chance_based_on_aim_time",
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
				buff_template_name = "weapon_trait_bespoke_ogryn_thumper_p1_crit_chance_based_on_aim_time",
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
		weapon_trait_bespoke_ogryn_thumper_p1_crit_chance_based_on_aim_time = {
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
			},
			{
				duration_per_stack = 0.25,
				stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.1
				}
			},
			{
				duration_per_stack = 0.2,
				stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.1
				}
			}
		}
	}
}
templates.weapon_trait_bespoke_ogryn_thumper_p1_weapon_special_power_bonus_after_one_shots = {
	format_values = {
		power_level = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_thumper_p1_weapon_special_power_bonus_after_one_shots",
				find_value_type = "trait_override",
				path = {
					"proc_stat_buffs",
					stat_buffs.melee_power_level_modifier
				}
			}
		},
		time = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_thumper_p1_weapon_special_power_bonus_after_one_shots",
				find_value_type = "trait_override",
				path = {
					"active_duration"
				}
			}
		},
		num_hits = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_thumper_p1_weapon_special_power_bonus_after_one_shots",
				find_value_type = "buff_template",
				path = {
					"buff_data",
					"required_num_hits"
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_ogryn_thumper_p1_weapon_special_power_bonus_after_one_shots = {
			{
				active_duration = 3.5,
				proc_stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.3
				}
			},
			{
				active_duration = 3.5,
				proc_stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.34
				}
			},
			{
				active_duration = 3.5,
				proc_stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.38
				}
			},
			{
				active_duration = 3.5,
				proc_stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.42
				}
			}
		}
	}
}
templates.weapon_trait_bespoke_ogryn_thumper_p1_power_bonus_on_hitting_single_enemy_with_all = {
	format_values = {
		power_level = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_thumper_p1_power_bonus_on_hitting_single_enemy_with_all",
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
				buff_template_name = "weapon_trait_bespoke_ogryn_thumper_p1_power_bonus_on_hitting_single_enemy_with_all",
				find_value_type = "buff_template",
				path = {
					"active_duration"
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_ogryn_thumper_p1_power_bonus_on_hitting_single_enemy_with_all = {
			{
				proc_stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.18
				}
			},
			{
				proc_stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.22
				}
			},
			{
				proc_stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.26
				}
			},
			{
				proc_stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.3
				}
			}
		}
	}
}
templates.weapon_trait_bespoke_ogryn_thumper_p1_shot_power_bonus_after_weapon_special_cleave = {
	format_values = {
		power_level = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_thumper_p1_shot_power_bonus_after_weapon_special_cleave",
				find_value_type = "trait_override",
				path = {
					"proc_stat_buffs",
					stat_buffs.ranged_power_level_modifier
				}
			}
		},
		time = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_thumper_p1_shot_power_bonus_after_weapon_special_cleave",
				find_value_type = "buff_template",
				path = {
					"active_duration"
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_ogryn_thumper_p1_shot_power_bonus_after_weapon_special_cleave = {
			{
				proc_stat_buffs = {
					[stat_buffs.ranged_power_level_modifier] = 0.06
				},
				buff_data = {
					required_num_hits = 3
				}
			},
			{
				proc_stat_buffs = {
					[stat_buffs.ranged_power_level_modifier] = 0.09
				},
				buff_data = {
					required_num_hits = 3
				}
			},
			{
				proc_stat_buffs = {
					[stat_buffs.ranged_power_level_modifier] = 0.12
				},
				buff_data = {
					required_num_hits = 3
				}
			},
			{
				proc_stat_buffs = {
					[stat_buffs.ranged_power_level_modifier] = 0.15
				},
				buff_data = {
					required_num_hits = 3
				}
			}
		}
	}
}
templates.weapon_trait_bespoke_ogryn_thumper_p1_pass_past_armor_on_weapon_special = {
	format_values = {
		stagger = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_thumper_p1_pass_past_armor_on_weapon_special",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.melee_impact_modifier
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_ogryn_thumper_p1_pass_past_armor_on_weapon_special = {
			{
				stat_buffs = {
					[stat_buffs.melee_impact_modifier] = 0.1
				}
			},
			{
				stat_buffs = {
					[stat_buffs.melee_impact_modifier] = 0.15
				}
			},
			{
				stat_buffs = {
					[stat_buffs.melee_impact_modifier] = 0.2
				}
			},
			{
				stat_buffs = {
					[stat_buffs.melee_impact_modifier] = 0.25
				}
			}
		}
	}
}

return templates
