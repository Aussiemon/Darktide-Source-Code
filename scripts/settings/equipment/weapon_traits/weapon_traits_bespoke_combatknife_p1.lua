local BuffSettings = require("scripts/settings/buff/buff_settings")
local templates = {}
local stat_buffs = BuffSettings.stat_buffs
templates.weapon_trait_bespoke_combatknife_p1_stacking_rending_on_weakspot = {
	weapon_trait_bespoke_combatknife_p1_stacking_rending_on_weakspot_parent = {
		{
			max_stacks = 5,
			stat_buffs = {
				[stat_buffs.rending_multiplier] = 0.05
			}
		},
		{
			max_stacks = 5,
			stat_buffs = {
				[stat_buffs.rending_multiplier] = 0.1
			}
		},
		{
			max_stacks = 5,
			stat_buffs = {
				[stat_buffs.rending_multiplier] = 0.15
			}
		},
		{
			max_stacks = 5,
			stat_buffs = {
				[stat_buffs.rending_multiplier] = 0.2
			}
		}
	}
}
templates.weapon_trait_bespoke_combatknife_p1_chained_weakspot_hits_increases_power = {
	weapon_trait_bespoke_combatknife_p1_chained_weakspot_hits_increases_power_parent = {
		{
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.02
			}
		},
		{
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.03
			}
		},
		{
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.04
			}
		},
		{
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.05
			}
		}
	}
}
templates.weapon_trait_bespoke_combatknife_p1_heavy_chained_hits_increases_killing_blow_chance = {
	weapon_trait_bespoke_combatknife_p1_heavy_chained_hits_increases_killing_blow_chance_parent = {
		{
			target_buff_data = {
				killing_blow_chance = 0.01
			}
		},
		{
			target_buff_data = {
				killing_blow_chance = 0.02
			}
		},
		{
			target_buff_data = {
				killing_blow_chance = 0.03
			}
		},
		{
			target_buff_data = {
				killing_blow_chance = 0.04
			}
		}
	}
}
templates.weapon_trait_bespoke_combatknife_p1_dodge_grants_finesse_bonus = {
	weapon_trait_bespoke_combatknife_p1_dodge_grants_finesse_bonus = {
		{
			proc_stat_buffs = {
				[stat_buffs.finesse_modifier_bonus] = 0.02
			}
		},
		{
			proc_stat_buffs = {
				[stat_buffs.finesse_modifier_bonus] = 0.03
			}
		},
		{
			proc_stat_buffs = {
				[stat_buffs.finesse_modifier_bonus] = 0.04
			}
		},
		{
			proc_stat_buffs = {
				[stat_buffs.finesse_modifier_bonus] = 0.05
			}
		}
	}
}
templates.weapon_trait_bespoke_combatknife_p1_dodge_grants_critical_strike_chance = {
	weapon_trait_bespoke_combatknife_p1_dodge_grants_critical_strike_chance = {
		{
			proc_stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.02
			}
		},
		{
			proc_stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.03
			}
		},
		{
			proc_stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.04
			}
		},
		{
			proc_stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.05
			}
		}
	}
}
templates.weapon_trait_bespoke_combatknife_p1_bleed_on_non_weakspot_hit = {
	weapon_trait_bespoke_combatknife_p1_bleed_on_non_weakspot_hit = {
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
templates.weapon_trait_bespoke_combatknife_p1_bleed_on_crit = {
	weapon_trait_bespoke_combatknife_p1_bleed_on_crit = {
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
templates.weapon_trait_bespoke_combatknife_p1_rending_on_backstab = {
	weapon_trait_bespoke_combatknife_p1_rending_on_backstab = {
		{
			conditional_stat_buffs = {
				[stat_buffs.backstab_rending_multiplier] = 0.2
			}
		},
		{
			conditional_stat_buffs = {
				[stat_buffs.backstab_rending_multiplier] = 0.3
			}
		},
		{
			conditional_stat_buffs = {
				[stat_buffs.backstab_rending_multiplier] = 0.4
			}
		},
		{
			conditional_stat_buffs = {
				[stat_buffs.backstab_rending_multiplier] = 0.5
			}
		}
	}
}
templates.weapon_trait_bespoke_combatknife_p1_increased_weakspot_damage_against_bleeding = {
	weapon_trait_bespoke_combatknife_p1_increased_weakspot_damage_against_bleeding = {
		{
			conditional_stat_buffs = {
				[stat_buffs.melee_weakspot_damage_vs_bleeding] = 0.2
			}
		},
		{
			conditional_stat_buffs = {
				[stat_buffs.melee_weakspot_damage_vs_bleeding] = 0.3
			}
		},
		{
			conditional_stat_buffs = {
				[stat_buffs.melee_weakspot_damage_vs_bleeding] = 0.4
			}
		},
		{
			conditional_stat_buffs = {
				[stat_buffs.melee_weakspot_damage_vs_bleeding] = 0.5
			}
		}
	}
}
templates.weapon_trait_bespoke_combatknife_p1_increased_crit_chance_on_staggered_weapon_special_hit = {
	weapon_trait_bespoke_combatknife_p1_increased_crit_chance_on_staggered_weapon_special_hit_parent = {
		{
			stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.04
			}
		},
		{
			stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.06
			}
		},
		{
			stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.08
			}
		},
		{
			stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.1
			}
		}
	}
}

return templates
