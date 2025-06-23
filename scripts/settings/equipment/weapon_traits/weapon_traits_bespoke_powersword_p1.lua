-- chunkname: @scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_powersword_p1.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local templates = {}

table.make_unique(templates)

local stat_buffs = BuffSettings.stat_buffs

templates.weapon_trait_bespoke_powersword_p1_chained_hits_increases_melee_cleave = {
	format_values = {
		cleave = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powersword_p1_chained_hits_increases_melee_cleave_parent",
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
				buff_template_name = "weapon_trait_bespoke_powersword_p1_chained_hits_increases_melee_cleave_child",
				find_value_type = "buff_template",
				path = {
					"max_stacks"
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_powersword_p1_chained_hits_increases_melee_cleave_parent = {
			{
				stat_buffs = {
					[stat_buffs.max_hit_mass_attack_modifier] = 0.35
				}
			},
			{
				stat_buffs = {
					[stat_buffs.max_hit_mass_attack_modifier] = 0.4
				}
			},
			{
				stat_buffs = {
					[stat_buffs.max_hit_mass_attack_modifier] = 0.45
				}
			},
			{
				stat_buffs = {
					[stat_buffs.max_hit_mass_attack_modifier] = 0.5
				}
			}
		}
	}
}
templates.weapon_trait_bespoke_powersword_p1_increased_melee_damage_on_multiple_hits = {
	format_values = {
		damage = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powersword_p1_increased_melee_damage_on_multiple_hits",
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
				buff_template_name = "weapon_trait_bespoke_powersword_p1_increased_melee_damage_on_multiple_hits",
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
				buff_template_name = "weapon_trait_bespoke_powersword_p1_increased_melee_damage_on_multiple_hits",
				find_value_type = "trait_override",
				path = {
					"active_duration"
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_powersword_p1_increased_melee_damage_on_multiple_hits = {
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
templates.weapon_trait_bespoke_powersword_p1_infinite_melee_cleave_on_weakspot_kill = {
	format_values = {
		weakspot_damage = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powersword_p1_infinite_melee_cleave_on_weakspot_kill",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.melee_weakspot_damage
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_powersword_p1_infinite_melee_cleave_on_weakspot_kill = {
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
templates.weapon_trait_bespoke_powersword_p1_increase_power_on_kill = {
	format_values = {
		power_level = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powersword_p1_increase_power_on_kill_parent",
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
				buff_template_name = "weapon_trait_bespoke_powersword_p1_increase_power_on_kill_parent",
				find_value_type = "buff_template",
				path = {
					"child_duration"
				}
			}
		},
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powersword_p1_increase_power_on_kill_child",
				find_value_type = "buff_template",
				path = {
					"max_stacks"
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_powersword_p1_increase_power_on_kill_parent = {
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
templates.weapon_trait_bespoke_powersword_p1_targets_receive_rending_debuff_on_weapon_special_attacks = {
	format_values = {
		rend = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powersword_p1_targets_receive_rending_debuff_on_weapon_special_attacks",
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
		weapon_trait_bespoke_powersword_p1_targets_receive_rending_debuff_on_weapon_special_attacks = {
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
templates.weapon_trait_bespoke_powersword_p1_pass_past_armor_on_weapon_special = {
	format_values = {
		heavy_damage = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powersword_p1_pass_past_armor_on_weapon_special",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.melee_heavy_damage
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_powersword_p1_pass_past_armor_on_weapon_special = {
			{
				stat_buffs = {
					[stat_buffs.melee_heavy_damage] = 0.05
				}
			},
			{
				stat_buffs = {
					[stat_buffs.melee_heavy_damage] = 0.1
				}
			},
			{
				stat_buffs = {
					[stat_buffs.melee_heavy_damage] = 0.15
				}
			},
			{
				stat_buffs = {
					[stat_buffs.melee_heavy_damage] = 0.2
				}
			}
		}
	}
}
templates.weapon_trait_bespoke_powersword_p1_extended_activation_duration_on_chained_attacks = {
	format_values = {
		extra_hits = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powersword_p1_extended_activation_duration_on_chained_attacks",
				find_value_type = "trait_override",
				path = {
					"buff_data",
					"extra_hits_max"
				}
			}
		},
		stagger = {
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powersword_p1_extended_activation_duration_on_chained_attacks",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.melee_impact_modifier
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_powersword_p1_extended_activation_duration_on_chained_attacks = {
			{
				stat_buffs = {
					[stat_buffs.melee_impact_modifier] = 0.025
				},
				buff_data = {
					extra_hits_max = 1
				}
			},
			{
				stat_buffs = {
					[stat_buffs.melee_impact_modifier] = 0.05
				},
				buff_data = {
					extra_hits_max = 1
				}
			},
			{
				stat_buffs = {
					[stat_buffs.melee_impact_modifier] = 0.075
				},
				buff_data = {
					extra_hits_max = 2
				}
			},
			{
				stat_buffs = {
					[stat_buffs.melee_impact_modifier] = 0.1
				},
				buff_data = {
					extra_hits_max = 2
				}
			}
		}
	}
}
templates.weapon_trait_bespoke_powersword_p1_windup_increases_power = {
	format_values = {
		power_level = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powersword_p1_windup_increases_power_parent",
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
				buff_template_name = "weapon_trait_bespoke_powersword_p1_windup_increases_power_child",
				find_value_type = "buff_template",
				path = {
					"max_stacks"
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_powersword_p1_windup_increases_power_parent = {
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

return templates
