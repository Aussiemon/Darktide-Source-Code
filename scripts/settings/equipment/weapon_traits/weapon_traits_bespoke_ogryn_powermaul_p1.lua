-- chunkname: @scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_ogryn_powermaul_p1.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local stat_buffs = BuffSettings.stat_buffs
local templates = {}

table.make_unique(templates)

templates.weapon_trait_bespoke_ogryn_powermaul_p1_toughness_recovery_on_chained_attacks = {
	format_values = {
		toughness = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_powermaul_p1_toughness_recovery_on_chained_attacks",
				find_value_type = "trait_override",
				path = {
					"toughness_fixed_percentage"
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_ogryn_powermaul_p1_toughness_recovery_on_chained_attacks = {
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
templates.weapon_trait_bespoke_ogryn_powermaul_p1_staggered_targets_receive_increased_damage_debuff = {
	format_values = {
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_powermaul_p1_staggered_targets_receive_increased_damage_debuff",
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
		weapon_trait_bespoke_ogryn_powermaul_p1_staggered_targets_receive_increased_damage_debuff = {
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
templates.weapon_trait_bespoke_ogryn_powermaul_p1_infinite_melee_cleave_on_weakspot_kill = {
	format_values = {
		weakspot_damage = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_powermaul_p1_infinite_melee_cleave_on_weakspot_kill",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.melee_weakspot_damage
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_ogryn_powermaul_p1_infinite_melee_cleave_on_weakspot_kill = {
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
templates.weapon_trait_bespoke_ogryn_powermaul_p1_staggered_targets_receive_increased_stagger_debuff = {
	format_values = {
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_powermaul_p1_staggered_targets_receive_increased_stagger_debuff",
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
		weapon_trait_bespoke_ogryn_powermaul_p1_staggered_targets_receive_increased_stagger_debuff = {
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
templates.weapon_trait_bespoke_ogryn_powermaul_p1_targets_receive_rending_debuff_on_weapon_special_attacks = {
	format_values = {
		rend = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_powermaul_p1_targets_receive_rending_debuff_on_weapon_special_attacks",
				find_value_type = "trait_override",
				path = {
					"target_buff_data",
					"num_stacks_on_proc"
				}
			}
		},
		rending = {
			prefix = "+",
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
		weapon_trait_bespoke_ogryn_powermaul_p1_targets_receive_rending_debuff_on_weapon_special_attacks = {
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
templates.weapon_trait_bespoke_ogryn_powermaul_p1_pass_past_armor_on_crit = {
	format_values = {
		crit_damage = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_powermaul_p1_pass_past_armor_on_crit",
				find_value_type = "trait_override",
				path = {
					"conditional_stat_buffs",
					stat_buffs.melee_critical_strike_damage
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_ogryn_powermaul_p1_pass_past_armor_on_crit = {
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
templates.weapon_trait_bespoke_ogryn_powermaul_p1_rending_vs_staggered = {
	format_values = {
		rending = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_powermaul_p1_rending_vs_staggered",
				find_value_type = "trait_override",
				path = {
					"conditional_stat_buffs",
					stat_buffs.rending_vs_staggered_multiplier
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_ogryn_powermaul_p1_rending_vs_staggered = {
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
templates.weapon_trait_bespoke_ogryn_powermaul_p1_extra_explosion_on_activated_attacks_on_armor = {
	format_values = {
		explosion_radius = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_powermaul_p1_extra_explosion_on_activated_attacks_on_armor",
				find_value_type = "trait_override",
				path = {
					"conditional_stat_buffs",
					stat_buffs.explosion_radius_modifier
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_ogryn_powermaul_p1_extra_explosion_on_activated_attacks_on_armor = {
			{
				conditional_stat_buffs = {
					[stat_buffs.weapon_special_max_activations] = 1,
					[stat_buffs.explosion_radius_modifier] = 0.1
				}
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.weapon_special_max_activations] = 1,
					[stat_buffs.explosion_radius_modifier] = 0.15
				}
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.weapon_special_max_activations] = 1,
					[stat_buffs.explosion_radius_modifier] = 0.2
				}
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.weapon_special_max_activations] = 1,
					[stat_buffs.explosion_radius_modifier] = 0.25
				}
			}
		}
	}
}

return templates
