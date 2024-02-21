local BuffSettings = require("scripts/settings/buff/buff_settings")
local templates = {}

table.make_unique(templates)

local stat_buffs = BuffSettings.stat_buffs
templates.weapon_trait_bespoke_combatsword_p2_increased_attack_cleave_on_multiple_hits = {
	weapon_trait_bespoke_combatsword_p2_increased_attack_cleave_on_multiple_hits = {
		{
			stat_buffs = {
				[stat_buffs.max_hit_mass_attack_modifier] = 1.4
			}
		},
		{
			stat_buffs = {
				[stat_buffs.max_hit_mass_attack_modifier] = 1.6
			}
		},
		{
			stat_buffs = {
				[stat_buffs.max_hit_mass_attack_modifier] = 1.8
			}
		},
		{
			stat_buffs = {
				[stat_buffs.max_hit_mass_attack_modifier] = 2
			}
		}
	}
}
templates.weapon_trait_bespoke_combatsword_p2_increased_melee_damage_on_multiple_hits = {
	weapon_trait_bespoke_combatsword_p2_increased_melee_damage_on_multiple_hits = {
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
templates.weapon_trait_bespoke_combatsword_p2_chained_hits_increases_melee_cleave = {
	weapon_trait_bespoke_combatsword_p2_chained_hits_increases_melee_cleave_parent = {
		{
			stat_buffs = {
				[stat_buffs.max_hit_mass_attack_modifier] = 0.25
			}
		},
		{
			stat_buffs = {
				[stat_buffs.max_hit_mass_attack_modifier] = 0.3
			}
		},
		{
			stat_buffs = {
				[stat_buffs.max_hit_mass_attack_modifier] = 0.35
			}
		},
		{
			stat_buffs = {
				[stat_buffs.max_hit_mass_attack_modifier] = 0.4
			}
		}
	}
}
templates.weapon_trait_bespoke_combatsword_p2_increase_power_on_hit = {
	weapon_trait_bespoke_combatsword_p2_increase_power_on_hit_parent = {
		{
			stat_buffs = {
				[stat_buffs.melee_power_level_modifier] = 0.065
			}
		},
		{
			stat_buffs = {
				[stat_buffs.melee_power_level_modifier] = 0.07
			}
		},
		{
			stat_buffs = {
				[stat_buffs.melee_power_level_modifier] = 0.075
			}
		},
		{
			stat_buffs = {
				[stat_buffs.melee_power_level_modifier] = 0.08
			}
		}
	}
}
templates.weapon_trait_bespoke_combatsword_p2_infinite_melee_cleave_on_weakspot_kill = {
	weapon_trait_bespoke_combatsword_p2_infinite_melee_cleave_on_weakspot_kill = {
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
templates.weapon_trait_bespoke_combatsword_p2_pass_past_armor_on_crit = {
	weapon_trait_bespoke_combatsword_p2_pass_past_armor_on_crit = {
		{}
	}
}
templates.weapon_trait_bespoke_combatsword_p2_rending_on_multiple_hits = {
	weapon_trait_bespoke_combatsword_p2_rending_on_multiple_hits_parent = {
		{
			child_duration = 2.5,
			buff_data = {
				required_num_hits = 2
			},
			stat_buffs = {
				[stat_buffs.rending_multiplier] = 0.04
			}
		},
		{
			child_duration = 2.5,
			buff_data = {
				required_num_hits = 2
			},
			stat_buffs = {
				[stat_buffs.rending_multiplier] = 0.06
			}
		},
		{
			child_duration = 2.5,
			buff_data = {
				required_num_hits = 2
			},
			stat_buffs = {
				[stat_buffs.rending_multiplier] = 0.08
			}
		},
		{
			child_duration = 2.5,
			buff_data = {
				required_num_hits = 2
			},
			stat_buffs = {
				[stat_buffs.rending_multiplier] = 0.1
			}
		}
	}
}
templates.weapon_trait_bespoke_combatsword_p2_windup_increases_power = {
	weapon_trait_bespoke_combatsword_p2_windup_increases_power_parent = {
		{
			conditional_stat_buffs = {
				[stat_buffs.melee_power_level_modifier] = 0.05
			}
		},
		{
			conditional_stat_buffs = {
				[stat_buffs.melee_power_level_modifier] = 0.1
			}
		},
		{
			conditional_stat_buffs = {
				[stat_buffs.melee_power_level_modifier] = 0.15
			}
		},
		{
			conditional_stat_buffs = {
				[stat_buffs.melee_power_level_modifier] = 0.2
			}
		}
	}
}
templates.weapon_trait_bespoke_combatsword_p2_increased_crit_chance_on_weakspot_kill = {
	weapon_trait_bespoke_combatsword_p2_increased_crit_chance_on_weakspot_kill = {
		{
			conditional_stat_buffs = {
				[stat_buffs.melee_critical_strike_chance] = 0.05
			}
		},
		{
			conditional_stat_buffs = {
				[stat_buffs.melee_critical_strike_chance] = 0.1
			}
		},
		{
			conditional_stat_buffs = {
				[stat_buffs.melee_critical_strike_chance] = 0.15
			}
		},
		{
			conditional_stat_buffs = {
				[stat_buffs.melee_critical_strike_chance] = 0.2
			}
		}
	}
}

return templates
