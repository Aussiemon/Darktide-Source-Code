local BuffSettings = require("scripts/settings/buff/buff_settings")
local templates = {}

table.make_unique(templates)

local stat_buffs = BuffSettings.stat_buffs
templates.weapon_trait_bespoke_lasgun_p3_increase_power_on_close_kill = {
	weapon_trait_bespoke_lasgun_p3_increase_power_on_close_kill_parent = {
		{
			child_duration = 3.5,
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.05
			}
		},
		{
			child_duration = 3.5,
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.055
			}
		},
		{
			child_duration = 3.5,
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.06
			}
		},
		{
			child_duration = 3.5,
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.065
			}
		}
	}
}
templates.weapon_trait_bespoke_lasgun_p3_count_as_dodge_vs_ranged_on_close_kill = {
	weapon_trait_bespoke_lasgun_p3_count_as_dodge_vs_ranged_on_close_kill = {
		{
			active_duration = 0.7
		},
		{
			active_duration = 0.8
		},
		{
			active_duration = 0.9
		},
		{
			active_duration = 1
		}
	}
}
templates.weapon_trait_bespoke_lasgun_p3_reload_speed_on_slide = {
	weapon_trait_bespoke_lasgun_p3_reload_speed_on_slide_parent = {
		{
			child_duration = 3,
			stat_buffs = {
				[stat_buffs.reload_speed] = 0.07
			}
		},
		{
			child_duration = 3,
			stat_buffs = {
				[stat_buffs.reload_speed] = 0.08
			}
		},
		{
			child_duration = 3,
			stat_buffs = {
				[stat_buffs.reload_speed] = 0.09
			}
		},
		{
			child_duration = 3,
			stat_buffs = {
				[stat_buffs.reload_speed] = 0.1
			}
		}
	}
}
templates.weapon_trait_bespoke_lasgun_p3_increased_sprint_speed = {
	weapon_trait_bespoke_lasgun_p3_increased_sprint_speed = {
		{
			condtional_threshold = 0.8
		},
		{
			condtional_threshold = 0.7
		},
		{
			condtional_threshold = 0.6
		},
		{
			condtional_threshold = 0.5
		}
	}
}
templates.weapon_trait_bespoke_lasgun_p3_followup_shots_ranged_damage = {
	weapon_trait_bespoke_lasgun_p3_followup_shots_ranged_damage = {
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
templates.weapon_trait_bespoke_lasgun_p3_followup_shots_ranged_weakspot_damage = {
	weapon_trait_bespoke_lasgun_p3_followup_shots_ranged_weakspot_damage = {
		{
			conditional_stat_buffs = {
				[stat_buffs.ranged_weakspot_damage] = 0.35
			}
		},
		{
			conditional_stat_buffs = {
				[stat_buffs.ranged_weakspot_damage] = 0.4
			}
		},
		{
			conditional_stat_buffs = {
				[stat_buffs.ranged_weakspot_damage] = 0.45
			}
		},
		{
			conditional_stat_buffs = {
				[stat_buffs.ranged_weakspot_damage] = 0.5
			}
		}
	}
}
templates.weapon_trait_bespoke_lasgun_p3_consecutive_hits_increases_close_damage = {
	weapon_trait_bespoke_lasgun_p3_consecutive_hits_increases_close_damage_parent = {
		{
			stat_buffs = {
				[stat_buffs.damage_near] = 0.045
			}
		},
		{
			stat_buffs = {
				[stat_buffs.damage_near] = 0.05
			}
		},
		{
			stat_buffs = {
				[stat_buffs.damage_near] = 0.055
			}
		},
		{
			stat_buffs = {
				[stat_buffs.damage_near] = 0.06
			}
		}
	}
}
templates.weapon_trait_bespoke_lasgun_p3_stacking_crit_chance_on_weakspot = {
	weapon_trait_bespoke_lasgun_p3_stacking_crit_chance_on_weakspot_parent = {
		{
			max_stacks = 5,
			stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.035
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
				[stat_buffs.critical_strike_chance] = 0.045
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
templates.weapon_trait_bespoke_lasgun_p3_burninating_on_crit = {
	weapon_trait_bespoke_lasgun_p3_burninating_on_crit = {
		{
			target_buff_data = {
				max_stacks = 10,
				num_stacks_on_proc = 2
			}
		},
		[4] = {
			target_buff_data = {
				max_stacks = 12,
				num_stacks_on_proc = 3
			}
		}
	}
}

return templates
