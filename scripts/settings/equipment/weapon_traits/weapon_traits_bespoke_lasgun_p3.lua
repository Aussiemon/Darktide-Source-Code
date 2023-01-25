local BuffSettings = require("scripts/settings/buff/buff_settings")
local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
local templates = {}
local stat_buffs = BuffSettings.stat_buffs
local proc_events = BuffSettings.proc_events
templates.weapon_trait_bespoke_lasgun_p3_increase_power_on_close_kill = {
	weapon_trait_bespoke_lasgun_p3_increase_power_on_close_kill = {
		{
			active_duration = 1,
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.05
			}
		},
		{
			active_duration = 1.2,
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.055
			}
		},
		{
			active_duration = 1.3,
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.06
			}
		},
		{
			active_duration = 1.375,
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.065
			}
		}
	}
}
templates.weapon_trait_bespoke_lasgun_p3_count_as_dodge_vs_ranged_on_close_kill = {
	weapon_trait_bespoke_lasgun_p3_count_as_dodge_vs_ranged_on_close_kill = {
		{
			active_duration = 0.4
		},
		{
			active_duration = 0.5
		},
		{
			active_duration = 0.6
		},
		{
			active_duration = 0.7
		}
	}
}
templates.weapon_trait_bespoke_lasgun_p3_reload_speed_on_slide = {
	weapon_trait_bespoke_lasgun_p3_reload_speed_on_slide = {
		{
			stat_buffs = {
				[stat_buffs.reload_speed] = 0.04
			}
		},
		{
			stat_buffs = {
				[stat_buffs.reload_speed] = 0.06
			}
		},
		{
			stat_buffs = {
				[stat_buffs.reload_speed] = 0.08
			}
		},
		{
			stat_buffs = {
				[stat_buffs.reload_speed] = 0.1
			}
		}
	}
}
templates.weapon_trait_bespoke_lasgun_p3_increased_sprint_speed = {
	weapon_trait_bespoke_lasgun_p3_increased_sprint_speed = {
		{
			stat_buffs = {
				[stat_buffs.sprint_movement_speed] = 1.03
			}
		},
		{
			stat_buffs = {
				[stat_buffs.sprint_movement_speed] = 1.05
			}
		},
		{
			stat_buffs = {
				[stat_buffs.sprint_movement_speed] = 1.07
			}
		},
		{
			stat_buffs = {
				[stat_buffs.sprint_movement_speed] = 1.09
			}
		}
	}
}
templates.weapon_trait_bespoke_lasgun_p3_followup_shots_ranged_damage = {
	weapon_trait_bespoke_lasgun_p3_followup_shots_ranged_damage = {
		{
			conditional_stat_buffs = {
				[stat_buffs.ranged_damage] = 0.06
			}
		},
		{
			conditional_stat_buffs = {
				[stat_buffs.ranged_damage] = 0.09
			}
		},
		{
			conditional_stat_buffs = {
				[stat_buffs.ranged_damage] = 0.12
			}
		},
		{
			conditional_stat_buffs = {
				[stat_buffs.ranged_damage] = 0.15
			}
		}
	}
}
templates.weapon_trait_bespoke_lasgun_p3_followup_shots_ranged_weakspot_damage = {
	weapon_trait_bespoke_lasgun_p3_followup_shots_ranged_weakspot_damage = {
		{
			conditional_stat_buffs = {
				[stat_buffs.ranged_weakspot_damage] = 0.05
			}
		},
		{
			conditional_stat_buffs = {
				[stat_buffs.ranged_weakspot_damage] = 0.1
			}
		},
		{
			conditional_stat_buffs = {
				[stat_buffs.ranged_weakspot_damage] = 0.15
			}
		},
		{
			conditional_stat_buffs = {
				[stat_buffs.ranged_weakspot_damage] = 0.2
			}
		}
	}
}
templates.weapon_trait_bespoke_lasgun_p3_consecutive_hits_increases_close_damage = {
	weapon_trait_bespoke_lasgun_p3_consecutive_hits_increases_close_damage_parent = {
		{
			stat_buffs = {
				[stat_buffs.damage_near] = 0.01
			}
		},
		{
			stat_buffs = {
				[stat_buffs.damage_near] = 0.015
			}
		},
		{
			stat_buffs = {
				[stat_buffs.damage_near] = 0.02
			}
		},
		{
			stat_buffs = {
				[stat_buffs.damage_near] = 0.025
			}
		}
	}
}
templates.weapon_trait_bespoke_lasgun_p3_stacking_crit_chance_on_weakspot = {
	weapon_trait_bespoke_lasgun_p3_stacking_crit_chance_on_weakspot_parent = {
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
templates.weapon_trait_bespoke_lasgun_p3_burninating_on_crit = {
	weapon_trait_bespoke_lasgun_p3_burninating_on_crit = {
		{
			dot_data = {
				max_stacks = 6,
				num_stacks_on_proc = 1
			}
		},
		[4] = {
			dot_data = {
				max_stacks = 9,
				num_stacks_on_proc = 2
			}
		}
	}
}

return templates
