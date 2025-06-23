-- chunkname: @scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_lasgun_p2.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local templates = {}

table.make_unique(templates)

local stat_buffs = BuffSettings.stat_buffs

templates.weapon_trait_bespoke_lasgun_p2_burninating_on_crit = {
	format_values = {
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_lasgun_p2_burninating_on_crit",
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
				buff_template_name = "weapon_trait_bespoke_lasgun_p2_burninating_on_crit",
				find_value_type = "trait_override",
				path = {
					"target_buff_data",
					"max_stacks"
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_lasgun_p2_burninating_on_crit = {
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
templates.weapon_trait_bespoke_lasgun_p2_negate_stagger_reduction_on_weakspot = {
	format_values = {
		stagger = {
			prefix = "+",
			num_decimals = 0,
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_lasgun_p2_negate_stagger_reduction_on_weakspot",
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
				buff_template_name = "weapon_trait_bespoke_lasgun_p2_negate_stagger_reduction_on_weakspot",
				find_value_type = "buff_template",
				path = {
					"conditional_stat_buffs",
					stat_buffs.ranged_impact_modifier
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_lasgun_p2_negate_stagger_reduction_on_weakspot = {
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
templates.weapon_trait_bespoke_lasgun_p2_crit_chance_based_on_aim_time = {
	format_values = {
		time = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_lasgun_p2_crit_chance_based_on_aim_time",
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
				buff_template_name = "weapon_trait_bespoke_lasgun_p2_crit_chance_based_on_aim_time",
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
		weapon_trait_bespoke_lasgun_p2_crit_chance_based_on_aim_time = {
			{
				duration_per_stack = 0.45,
				stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.1
				}
			},
			{
				duration_per_stack = 0.4,
				stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.1
				}
			},
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
			}
		}
	}
}
templates.weapon_trait_bespoke_lasgun_p2_followup_shots_ranged_damage = {
	format_values = {
		damage = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_lasgun_p2_followup_shots_ranged_damage",
				find_value_type = "trait_override",
				path = {
					"conditional_stat_buffs",
					stat_buffs.ranged_damage
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_lasgun_p2_followup_shots_ranged_damage = {
			{
				conditional_stat_buffs = {
					[stat_buffs.ranged_damage] = 0.14
				}
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.ranged_damage] = 0.16
				}
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.ranged_damage] = 0.18
				}
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.ranged_damage] = 0.2
				}
			}
		}
	}
}
templates.weapon_trait_bespoke_lasgun_p2_stagger_count_bonus_damage = {
	format_values = {
		damage = {
			prefix = "+",
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_lasgun_p2_stagger_count_bonus_damage",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.stagger_count_damage
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_lasgun_p2_stagger_count_bonus_damage = {
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
templates.weapon_trait_bespoke_lasgun_p2_faster_charge_on_chained_secondary_attacks = {
	format_values = {
		charge_time = {
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_lasgun_p2_faster_charge_on_chained_secondary_attacks",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.charge_up_time
				}
			}
		},
		stacks = {
			value = "5",
			format_type = "string"
		}
	},
	buffs = {
		weapon_trait_bespoke_lasgun_p2_faster_charge_on_chained_secondary_attacks = {
			{
				stat_buffs = {
					[stat_buffs.charge_up_time] = -0.06
				}
			},
			{
				stat_buffs = {
					[stat_buffs.charge_up_time] = -0.08
				}
			},
			{
				stat_buffs = {
					[stat_buffs.charge_up_time] = -0.1
				}
			},
			{
				stat_buffs = {
					[stat_buffs.charge_up_time] = -0.12
				}
			}
		}
	}
}
templates.weapon_trait_bespoke_lasgun_p2_targets_receive_rending_debuff_on_charged_shots = {
	format_values = {
		min_stack_count = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_lasgun_p2_targets_receive_rending_debuff_on_charged_shots",
				find_value_type = "trait_override",
				path = {
					"target_buff_data",
					"threshold_num_stacks_on_proc",
					1,
					"num_stacks"
				}
			}
		},
		max_stack_count = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_lasgun_p2_targets_receive_rending_debuff_on_charged_shots",
				find_value_type = "trait_override",
				path = {
					"target_buff_data",
					"threshold_num_stacks_on_proc",
					2,
					"num_stacks"
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
		weapon_trait_bespoke_lasgun_p2_targets_receive_rending_debuff_on_charged_shots = {
			{
				target_buff_data = {
					threshold_num_stacks_on_proc = {
						{
							threshold = 0.25,
							num_stacks = 2
						},
						{
							threshold = 0.75,
							num_stacks = 6
						}
					}
				}
			},
			{
				target_buff_data = {
					threshold_num_stacks_on_proc = {
						{
							threshold = 0.25,
							num_stacks = 4
						},
						{
							threshold = 0.75,
							num_stacks = 8
						}
					}
				}
			},
			{
				target_buff_data = {
					threshold_num_stacks_on_proc = {
						{
							threshold = 0.25,
							num_stacks = 6
						},
						{
							threshold = 0.75,
							num_stacks = 10
						}
					}
				}
			},
			{
				target_buff_data = {
					threshold_num_stacks_on_proc = {
						{
							threshold = 0.25,
							num_stacks = 8
						},
						{
							threshold = 0.75,
							num_stacks = 12
						}
					}
				}
			}
		}
	}
}
templates.weapon_trait_bespoke_lasgun_p2_target_hit_mass_reduction_on_weakspot_hits = {
	format_values = {
		hit_mass_reduction = {
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_lasgun_p2_target_hit_mass_reduction_on_weakspot_hits",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.consumed_hit_mass_modifier_on_weakspot_hit
				}
			}
		}
	},
	buffs = {
		weapon_trait_bespoke_lasgun_p2_target_hit_mass_reduction_on_weakspot_hits = {
			{
				stat_buffs = {
					[stat_buffs.consumed_hit_mass_modifier_on_weakspot_hit] = 0.2
				}
			},
			{
				stat_buffs = {
					[stat_buffs.consumed_hit_mass_modifier_on_weakspot_hit] = 0.3
				}
			},
			{
				stat_buffs = {
					[stat_buffs.consumed_hit_mass_modifier_on_weakspot_hit] = 0.4
				}
			},
			{
				stat_buffs = {
					[stat_buffs.consumed_hit_mass_modifier_on_weakspot_hit] = 0.5
				}
			}
		}
	}
}

return templates
