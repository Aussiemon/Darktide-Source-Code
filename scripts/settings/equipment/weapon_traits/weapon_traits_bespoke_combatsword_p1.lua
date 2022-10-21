local BuffSettings = require("scripts/settings/buff/buff_settings")
local templates = {}
local stat_buffs = BuffSettings.stat_buffs
templates.weapon_trait_bespoke_combatsword_p1_chained_hits_increases_melee_cleave = {
	weapon_trait_bespoke_combatsword_p1_chained_hits_increases_melee_cleave_parent = {
		{
			stat_buffs = {
				[stat_buffs.max_hit_mass_attack_modifier] = 0.1
			}
		},
		{
			stat_buffs = {
				[stat_buffs.max_hit_mass_attack_modifier] = 0.15
			}
		},
		{
			stat_buffs = {
				[stat_buffs.max_hit_mass_attack_modifier] = 0.175
			}
		},
		{
			stat_buffs = {
				[stat_buffs.max_hit_mass_attack_modifier] = 0.2
			}
		}
	}
}
templates.weapon_trait_bespoke_combatsword_p1_chained_hits_increases_crit_chance = {
	weapon_trait_bespoke_combatsword_p1_chained_hits_increases_crit_chance_parent = {
		{
			stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.02
			}
		},
		{
			stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.035
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
templates.weapon_trait_bespoke_combatsword_p1_increased_attack_cleave_on_multiple_hits = {
	weapon_trait_bespoke_combatsword_p1_increased_attack_cleave_on_multiple_hits = {
		{
			buff_data = {
				required_num_hits = 3
			},
			stat_buffs = {
				[stat_buffs.max_hit_mass_attack_modifier] = 1
			}
		},
		{
			buff_data = {
				required_num_hits = 3
			},
			stat_buffs = {
				[stat_buffs.max_hit_mass_attack_modifier] = 1.5
			}
		},
		{
			buff_data = {
				required_num_hits = 3
			},
			stat_buffs = {
				[stat_buffs.max_hit_mass_attack_modifier] = 1.75
			}
		},
		{
			buff_data = {
				required_num_hits = 3
			},
			stat_buffs = {
				[stat_buffs.max_hit_mass_attack_modifier] = 2
			}
		}
	}
}
templates.weapon_trait_bespoke_combatsword_p1_increased_melee_damage_on_multiple_hits = {
	weapon_trait_bespoke_combatsword_p1_increased_melee_damage_on_multiple_hits = {
		{
			buff_data = {
				required_num_hits = 3
			},
			stat_buffs = {
				[stat_buffs.melee_damage] = 0.1
			}
		},
		{
			buff_data = {
				required_num_hits = 3
			},
			stat_buffs = {
				[stat_buffs.melee_damage] = 0.15
			}
		},
		{
			buff_data = {
				required_num_hits = 3
			},
			stat_buffs = {
				[stat_buffs.melee_damage] = 0.175
			}
		},
		{
			buff_data = {
				required_num_hits = 3
			},
			stat_buffs = {
				[stat_buffs.melee_damage] = 0.2
			}
		}
	}
}
templates.weapon_trait_bespoke_combatsword_p1_infinite_melee_cleave_on_crit = {
	weapon_trait_bespoke_combatsword_p1_infinite_melee_cleave_on_crit = {
		{
			active_duration = 2
		},
		{
			active_duration = 3
		},
		{
			active_duration = 3.5
		},
		{
			active_duration = 4
		}
	}
}
templates.weapon_trait_bespoke_combatsword_p1_stacking_increase_impact_on_hit = {
	weapon_trait_bespoke_combatsword_p1_stacking_increase_impact_on_hit_parent = {
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
templates.weapon_trait_bespoke_combatsword_p1_staggered_targets_receive_increased_stagger_debuff = {
	weapon_trait_bespoke_combatsword_p1_staggered_targets_receive_increased_stagger_debuff = {
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
templates.weapon_trait_bespoke_combatsword_p1_staggered_targets_receive_increased_damage_debuff = {
	weapon_trait_bespoke_combatsword_p1_staggered_targets_receive_increased_damage_debuff = {
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
templates.weapon_trait_bespoke_combatsword_p1_increase_stagger_per_hit_in_sweep = {
	weapon_trait_bespoke_combatsword_p1_increase_stagger_per_hit_in_sweep_parent = {
		{
			stat_buffs = {
				[stat_buffs.melee_impact_modifier] = 0.02
			}
		},
		{
			stat_buffs = {
				[stat_buffs.melee_impact_modifier] = 0.03
			}
		},
		{
			stat_buffs = {
				[stat_buffs.melee_impact_modifier] = 0.04
			}
		},
		{
			stat_buffs = {
				[stat_buffs.melee_impact_modifier] = 0.05
			}
		}
	}
}
templates.weapon_trait_bespoke_combatsword_p1_consecutive_hits_increases_stagger = {
	weapon_trait_bespoke_combatsword_p1_consecutive_hits_increases_stagger = {
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
				[stat_buffs.melee_impact_modifier] = 0.14
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
