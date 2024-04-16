local BuffSettings = require("scripts/settings/buff/buff_settings")
local templates = {}

table.make_unique(templates)

local stat_buffs = BuffSettings.stat_buffs
templates.weapon_trait_bespoke_thunderhammer_2h_p1_hit_mass_consumption_reduction_on_kill = {
	weapon_trait_bespoke_thunderhammer_2h_p1_hit_mass_consumption_reduction_on_kill = {
		{
			stat_buffs = {
				[stat_buffs.consumed_hit_mass_modifier] = 0.7
			}
		},
		{
			stat_buffs = {
				[stat_buffs.consumed_hit_mass_modifier] = 0.6
			}
		},
		{
			stat_buffs = {
				[stat_buffs.consumed_hit_mass_modifier] = 0.5
			}
		},
		{
			stat_buffs = {
				[stat_buffs.consumed_hit_mass_modifier] = 0.4
			}
		}
	}
}
templates.weapon_trait_bespoke_thunderhammer_2h_p1_stacking_increase_impact_on_hit = {
	weapon_trait_bespoke_thunderhammer_2h_p1_stacking_increase_impact_on_hit_parent = {
		{
			child_duration = 3.5,
			stat_buffs = {
				[stat_buffs.melee_impact_modifier] = 0.19
			}
		},
		{
			child_duration = 3.5,
			stat_buffs = {
				[stat_buffs.melee_impact_modifier] = 0.21
			}
		},
		{
			child_duration = 3.5,
			stat_buffs = {
				[stat_buffs.melee_impact_modifier] = 0.23
			}
		},
		{
			child_duration = 3.5,
			stat_buffs = {
				[stat_buffs.melee_impact_modifier] = 0.25
			}
		}
	}
}
templates.weapon_trait_bespoke_thunderhammer_2h_p1_staggered_targets_receive_increased_stagger_debuff = {
	weapon_trait_bespoke_thunderhammer_2h_p1_staggered_targets_receive_increased_stagger_debuff = {
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
templates.weapon_trait_bespoke_thunderhammer_2h_p1_staggered_targets_receive_increased_damage_debuff = {
	weapon_trait_bespoke_thunderhammer_2h_p1_staggered_targets_receive_increased_damage_debuff = {
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
templates.weapon_trait_bespoke_thunderhammer_2h_p1_toughness_recovery_on_multiple_hits = {
	weapon_trait_bespoke_thunderhammer_2h_p1_toughness_recovery_on_multiple_hits = {
		{
			buff_data = {
				replenish_percentage = 0.12,
				required_num_hits = 3
			}
		},
		{
			buff_data = {
				replenish_percentage = 0.13,
				required_num_hits = 3
			}
		},
		{
			buff_data = {
				replenish_percentage = 0.14,
				required_num_hits = 3
			}
		},
		{
			buff_data = {
				replenish_percentage = 0.15,
				required_num_hits = 3
			}
		}
	}
}
templates.weapon_trait_bespoke_thunderhammer_2h_p1_targets_receive_rending_debuff = {
	weapon_trait_bespoke_thunderhammer_2h_p1_targets_receive_rending_debuff = {
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
templates.weapon_trait_bespoke_thunderhammer_2h_p1_windup_increases_power = {
	weapon_trait_bespoke_thunderhammer_2h_p1_windup_increases_power_parent = {
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
templates.weapon_trait_bespoke_thunderhammer_2h_p1_increase_power_on_hit = {
	weapon_trait_bespoke_thunderhammer_2h_p1_increase_power_on_hit_parent = {
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
templates.weapon_trait_bespoke_thunderhammer_2h_p1_increase_power_on_kill = {
	weapon_trait_bespoke_thunderhammer_2h_p1_increase_power_on_kill_parent = {
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
templates.weapon_trait_bespoke_thunderhammer_2h_p1_consecutive_hits_increases_stagger = {
	weapon_trait_bespoke_thunderhammer_2h_p1_consecutive_hits_increases_stagger_parent = {
		{
			stat_buffs = {
				[stat_buffs.melee_impact_modifier] = 0.075
			}
		},
		{
			stat_buffs = {
				[stat_buffs.melee_impact_modifier] = 0.1
			}
		},
		{
			stat_buffs = {
				[stat_buffs.melee_impact_modifier] = 0.125
			}
		},
		{
			stat_buffs = {
				[stat_buffs.melee_impact_modifier] = 0.15
			}
		}
	}
}

return templates
