local BuffSettings = require("scripts/settings/buff/buff_settings")
local templates = {}
local stat_buffs = BuffSettings.stat_buffs
local proc_events = BuffSettings.proc_events
templates.weapon_trait_bespoke_autogun_p3_crit_chance_based_on_ammo_left = {
	weapon_trait_bespoke_autogun_p3_crit_chance_based_on_ammo_left = {
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
templates.weapon_trait_bespoke_autogun_p3_stacking_crit_chance_on_weakspot = {
	weapon_trait_bespoke_autogun_p3_stacking_crit_chance_on_weakspot_parent = {
		{
			max_stacks = 5,
			stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.02
			}
		},
		{
			max_stacks = 5,
			stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.03
			}
		},
		{
			max_stacks = 5,
			stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.04
			}
		},
		{
			max_stacks = 5,
			stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.05
			}
		}
	}
}
templates.weapon_trait_bespoke_autogun_p3_suppression_negation_on_weakspot = {
	weapon_trait_bespoke_autogun_p3_suppression_negation_on_weakspot = {
		{
			active_duration = 0.6
		},
		{
			active_duration = 0.7
		},
		{
			active_duration = 0.8
		},
		{
			active_duration = 0.9
		}
	}
}
templates.weapon_trait_bespoke_autogun_p3_count_as_dodge_vs_ranged_on_weakspot = {
	weapon_trait_bespoke_autogun_p3_count_as_dodge_vs_ranged_on_weakspot = {
		{
			active_duration = 0.4
		},
		{
			active_duration = 0.6
		},
		{
			active_duration = 0.8
		},
		{
			active_duration = 1
		}
	}
}
templates.weapon_trait_bespoke_autogun_p3_negate_stagger_reduction_on_weakspot = {
	weapon_trait_bespoke_autogun_p3_negate_stagger_reduction_on_weakspot = {
		{
			stat_buffs = {
				[stat_buffs.stagger_weakspot_reduction_modifier] = 0.7
			}
		},
		{
			stat_buffs = {
				[stat_buffs.stagger_weakspot_reduction_modifier] = 0.6
			}
		},
		{
			stat_buffs = {
				[stat_buffs.stagger_weakspot_reduction_modifier] = 0.5
			}
		},
		{
			stat_buffs = {
				[stat_buffs.stagger_weakspot_reduction_modifier] = 0.4
			}
		}
	}
}
templates.weapon_trait_bespoke_autogun_p3_stagger_count_bonus_damage = {
	weapon_trait_bespoke_autogun_p3_stagger_count_bonus_damage = {
		{
			stat_buffs = {
				[stat_buffs.stagger_count_damage] = 0.125
			}
		},
		{
			stat_buffs = {
				[stat_buffs.stagger_count_damage] = 0.15
			}
		},
		{
			stat_buffs = {
				[stat_buffs.stagger_count_damage] = 0.175
			}
		},
		{
			stat_buffs = {
				[stat_buffs.stagger_count_damage] = 0.2
			}
		}
	}
}
templates.weapon_trait_bespoke_autogun_p3_crit_chance_based_on_aim_time = {
	weapon_trait_bespoke_autogun_p3_crit_chance_based_on_aim_time = {
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
templates.weapon_trait_bespoke_autogun_p3_crit_weakspot_finesse = {
	weapon_trait_bespoke_autogun_p3_crit_weakspot_finesse = {
		{
			stat_buffs = {
				[stat_buffs.critical_strike_weakspot_damage] = 0.275
			}
		},
		{
			stat_buffs = {
				[stat_buffs.critical_strike_weakspot_damage] = 0.35
			}
		},
		{
			stat_buffs = {
				[stat_buffs.critical_strike_weakspot_damage] = 0.425
			}
		},
		{
			stat_buffs = {
				[stat_buffs.critical_strike_weakspot_damage] = 0.5
			}
		}
	}
}
templates.weapon_trait_bespoke_autogun_p3_power_bonus_on_first_shot = {
	weapon_trait_bespoke_autogun_p3_power_bonus_on_first_shot = {
		{
			stat_buffs = {
				[stat_buffs.ranged_power_level_modifier] = 0.075
			}
		},
		{
			stat_buffs = {
				[stat_buffs.ranged_power_level_modifier] = 0.1
			}
		},
		{
			stat_buffs = {
				[stat_buffs.ranged_power_level_modifier] = 0.125
			}
		},
		{
			stat_buffs = {
				[stat_buffs.ranged_power_level_modifier] = 0.15
			}
		}
	}
}

return templates
