local BuffSettings = require("scripts/settings/buff/buff_settings")
local templates = {}
local stat_buffs = BuffSettings.stat_buffs
templates.weapon_trait_bespoke_chainsword_2h_p1_guaranteed_melee_crit_on_activated_kill = {
	weapon_trait_bespoke_chainsword_2h_p1_guaranteed_melee_crit_on_activated_kill = {
		{}
	}
}
templates.weapon_trait_bespoke_chainsword_2h_p1_bleed_on_activated_hit = {
	weapon_trait_bespoke_chainsword_2h_p1_bleed_on_activated_hit = {
		{
			dot_data = {
				num_stacks_on_proc = 2
			}
		},
		{
			dot_data = {
				num_stacks_on_proc = 4
			}
		}
	}
}
templates.weapon_trait_bespoke_chainsword_2h_p1_movement_speed_on_activation = {
	weapon_trait_bespoke_chainsword_2h_p1_movement_speed_on_activation = {
		{
			stat_buffs = {
				[stat_buffs.movement_speed] = 1.05
			}
		},
		{
			stat_buffs = {
				[stat_buffs.movement_speed] = 1.1
			}
		},
		{
			stat_buffs = {
				[stat_buffs.movement_speed] = 1.125
			}
		},
		{
			stat_buffs = {
				[stat_buffs.movement_speed] = 1.15
			}
		}
	}
}
templates.weapon_trait_bespoke_chainsword_2h_p1_toughness_recovery_on_multiple_hits = {
	weapon_trait_bespoke_chainsword_2h_p1_toughness_recovery_on_multiple_hits = {
		{
			buff_data = {
				replenish_percentage = 0.1,
				required_num_hits = 3
			}
		},
		{
			buff_data = {
				replenish_percentage = 0.125,
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
templates.weapon_trait_bespoke_chainsword_2h_p1_increased_melee_damage_on_multiple_hits = {
	weapon_trait_bespoke_chainsword_2h_p1_increased_melee_damage_on_multiple_hits = {
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
templates.weapon_trait_bespoke_chainsword_2h_p1_increased_attack_cleave_on_multiple_hits = {
	weapon_trait_bespoke_chainsword_2h_p1_increased_attack_cleave_on_multiple_hits = {
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
templates.weapon_trait_bespoke_chainsword_2h_p1_chained_hits_increases_melee_cleave = {
	weapon_trait_bespoke_chainsword_2h_p1_chained_hits_increases_melee_cleave_parent = {
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
templates.weapon_trait_bespoke_chainsword_2h_p1_chained_hits_increases_crit_chance = {
	weapon_trait_bespoke_chainsword_2h_p1_chained_hits_increases_crit_chance_parent = {
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
templates.weapon_trait_bespoke_chainsword_2h_p1_pass_past_armor_on_crit = {
	weapon_trait_bespoke_chainsword_2h_p1_pass_past_armor_on_crit = {
		{}
	}
}

return templates
