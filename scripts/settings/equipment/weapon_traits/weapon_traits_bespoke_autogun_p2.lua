local BuffSettings = require("scripts/settings/buff/buff_settings")
local templates = {}
local stat_buffs = BuffSettings.stat_buffs
local proc_events = BuffSettings.proc_events
templates.weapon_trait_bespoke_autogun_p2_increase_power_on_close_kill = {
	weapon_trait_bespoke_autogun_p2_increase_power_on_close_kill = {
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
templates.weapon_trait_bespoke_autogun_p2_count_as_dodge_vs_ranged_on_close_kill = {
	weapon_trait_bespoke_autogun_p2_count_as_dodge_vs_ranged_on_close_kill = {
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
templates.weapon_trait_bespoke_autogun_p2_suppression_on_close_kill = {
	weapon_trait_bespoke_autogun_p2_suppression_on_close_kill = {
		{
			suppression_settings = {
				suppression_falloff = true,
				instant_aggro = true,
				distance = 5,
				suppression_value = 10
			}
		},
		{
			suppression_settings = {
				suppression_falloff = true,
				instant_aggro = true,
				distance = 6,
				suppression_value = 15
			}
		},
		{
			suppression_settings = {
				suppression_falloff = true,
				instant_aggro = true,
				distance = 7,
				suppression_value = 20
			}
		},
		{
			suppression_settings = {
				suppression_falloff = true,
				instant_aggro = true,
				distance = 8,
				suppression_value = 25
			}
		}
	}
}
templates.weapon_trait_bespoke_autogun_p2_increase_close_damage_on_close_kill = {
	weapon_trait_bespoke_autogun_p2_increase_close_damage_on_close_kill = {
		{
			stat_buffs = {
				[stat_buffs.damage_near] = 0.04
			}
		},
		{
			stat_buffs = {
				[stat_buffs.damage_near] = 0.06
			}
		},
		{
			stat_buffs = {
				[stat_buffs.damage_near] = 0.08
			}
		},
		{
			stat_buffs = {
				[stat_buffs.damage_near] = 0.1
			}
		}
	}
}
templates.weapon_trait_bespoke_autogun_p2_reload_speed_on_slide = {
	weapon_trait_bespoke_autogun_p2_reload_speed_on_slide = {
		{
			active_duration = 2,
			stat_buffs = {
				[stat_buffs.reload_speed] = 0.14
			}
		},
		{
			active_duration = 2,
			stat_buffs = {
				[stat_buffs.reload_speed] = 0.16
			}
		},
		{
			active_duration = 2,
			stat_buffs = {
				[stat_buffs.reload_speed] = 0.18
			}
		},
		{
			active_duration = 2,
			stat_buffs = {
				[stat_buffs.reload_speed] = 0.2
			}
		}
	}
}
templates.weapon_trait_bespoke_autogun_p2_increased_sprint_speed = {
	weapon_trait_bespoke_autogun_p2_increased_sprint_speed = {
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

return templates
