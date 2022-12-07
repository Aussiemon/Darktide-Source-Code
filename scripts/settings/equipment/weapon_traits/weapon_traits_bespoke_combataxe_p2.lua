local BuffSettings = require("scripts/settings/buff/buff_settings")
local templates = {}
local stat_buffs = BuffSettings.stat_buffs
templates.weapon_trait_bespoke_combataxe_p2_increase_power_on_hit = {
	weapon_trait_bespoke_combataxe_p2_increase_power_on_hit_parent = {
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
templates.weapon_trait_bespoke_combataxe_p2_chained_hits_increases_power = {
	weapon_trait_bespoke_combataxe_p2_chained_hits_increases_power_parent = {
		{
			max_stacks = 10,
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.02
			}
		},
		{
			max_stacks = 10,
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.03
			}
		},
		{
			max_stacks = 10,
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.04
			}
		},
		{
			max_stacks = 10,
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.05
			}
		}
	}
}
templates.weapon_trait_bespoke_combataxe_p2_chained_hits_increases_crit_chance = {
	weapon_trait_bespoke_combataxe_p2_chained_hits_increases_crit_chance_parent = {
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
templates.weapon_trait_bespoke_combataxe_p2_infinite_melee_cleave_on_weakspot_kill = {
	weapon_trait_bespoke_combataxe_p2_infinite_melee_cleave_on_weakspot_kill = {
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
templates.weapon_trait_bespoke_combataxe_p2_power_bonus_on_first_attack = {
	weapon_trait_bespoke_combataxe_p2_power_bonus_on_first_attack = {
		{
			conditional_stat_buffs = {
				{
					[stat_buffs.power_level_modifier] = 0.1
				},
				{
					[stat_buffs.power_level_modifier] = -0.1
				}
			}
		},
		{
			conditional_stat_buffs = {
				{
					[stat_buffs.power_level_modifier] = 0.15
				},
				{
					[stat_buffs.power_level_modifier] = -0.15
				}
			}
		},
		{
			conditional_stat_buffs = {
				{
					[stat_buffs.power_level_modifier] = 0.2
				},
				{
					[stat_buffs.power_level_modifier] = -0.2
				}
			}
		},
		{
			conditional_stat_buffs = {
				{
					[stat_buffs.power_level_modifier] = 0.25
				},
				{
					[stat_buffs.power_level_modifier] = -0.25
				}
			}
		}
	}
}
templates.weapon_trait_bespoke_combataxe_p2_power_bonus_scaled_on_stamina = {
	weapon_trait_bespoke_combataxe_p2_power_bonus_scaled_on_stamina = {
		{
			lerped_stat_buffs = {
				[stat_buffs.power_level_modifier] = {
					max = 0.02,
					min = 0
				}
			}
		},
		{
			lerped_stat_buffs = {
				[stat_buffs.power_level_modifier] = {
					max = 0.03,
					min = 0
				}
			}
		},
		{
			lerped_stat_buffs = {
				[stat_buffs.power_level_modifier] = {
					max = 0.04,
					min = 0
				}
			}
		},
		{
			lerped_stat_buffs = {
				[stat_buffs.power_level_modifier] = {
					max = 0.05,
					min = 0
				}
			}
		}
	}
}

return templates
