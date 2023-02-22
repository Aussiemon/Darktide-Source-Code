local BuffSettings = require("scripts/settings/buff/buff_settings")
local templates = {}
local stat_buffs = BuffSettings.stat_buffs
templates.weapon_trait_bespoke_chainsword_p1_increased_attack_cleave_on_multiple_hits = {
	weapon_trait_bespoke_chainsword_p1_increased_attack_cleave_on_multiple_hits = {
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
templates.weapon_trait_bespoke_chainsword_p1_increased_melee_damage_on_multiple_hits = {
	weapon_trait_bespoke_chainsword_p1_increased_melee_damage_on_multiple_hits = {
		{
			buff_data = {
				required_num_hits = 3
			},
			stat_buffs = {
				[stat_buffs.melee_damage] = 0.125
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
templates.weapon_trait_bespoke_chainsword_p1_infinite_melee_cleave_on_crit = {
	weapon_trait_bespoke_chainsword_p1_infinite_melee_cleave_on_crit = {
		{
			active_duration = 1.5
		},
		{
			active_duration = 2.5
		},
		{
			active_duration = 3.5
		},
		{
			active_duration = 4.5
		}
	}
}
templates.weapon_trait_bespoke_chainsword_p1_chained_hits_increases_melee_cleave = {
	weapon_trait_bespoke_chainsword_p1_chained_hits_increases_melee_cleave_parent = {
		{
			stat_buffs = {
				[stat_buffs.max_hit_mass_attack_modifier] = 0.05
			}
		},
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
				[stat_buffs.max_hit_mass_attack_modifier] = 0.2
			}
		}
	}
}
templates.weapon_trait_bespoke_chainsword_p1_chained_hits_increases_crit_chance = {
	weapon_trait_bespoke_chainsword_p1_chained_hits_increases_crit_chance_parent = {
		{
			stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.02
			}
		},
		{
			stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.03
			}
		},
		{
			stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.04
			}
		},
		{
			stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.05
			}
		}
	}
}
templates.weapon_trait_bespoke_chainsword_p1_guaranteed_melee_crit_on_activated_kill = {
	weapon_trait_bespoke_chainsword_p1_guaranteed_melee_crit_on_activated_kill = {
		{}
	}
}
templates.weapon_trait_bespoke_chainsword_p1_bleed_on_activated_hit = {
	weapon_trait_bespoke_chainsword_p1_bleed_on_activated_hit = {
		{
			target_buff_data = {
				num_stacks_on_proc = 8
			}
		},
		[4] = {
			target_buff_data = {
				num_stacks_on_proc = 10
			}
		}
	}
}
templates.weapon_trait_bespoke_chainsword_p1_movement_speed_on_activation = {
	weapon_trait_bespoke_chainsword_p1_movement_speed_on_activation = {
		{
			stat_buffs = {
				[stat_buffs.movement_speed] = 1.075
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
templates.weapon_trait_bespoke_chainsword_p1_movement_speed_on_activated_hit = {
	weapon_trait_bespoke_chainsword_p1_movement_speed_on_activated_hit = {
		{
			stat_buffs = {
				[stat_buffs.movement_speed] = 1.125
			}
		},
		{
			stat_buffs = {
				[stat_buffs.movement_speed] = 1.15
			}
		},
		{
			stat_buffs = {
				[stat_buffs.movement_speed] = 1.175
			}
		},
		{
			stat_buffs = {
				[stat_buffs.movement_speed] = 1.2
			}
		}
	}
}

return templates
