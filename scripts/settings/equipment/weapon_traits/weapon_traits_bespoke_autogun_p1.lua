-- chunkname: @scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_autogun_p1.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local templates = {}

table.make_unique(templates)

function _degrees_to_radians(degrees)
	return degrees * 0.0174532925
end

local stat_buffs = BuffSettings.stat_buffs

templates.weapon_trait_bespoke_autogun_p1_consecutive_hits_increases_close_damage = {
	weapon_trait_bespoke_autogun_p1_consecutive_hits_increases_close_damage_parent = {
		{
			stat_buffs = {
				[stat_buffs.damage_near] = 0.045,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.damage_near] = 0.05,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.damage_near] = 0.055,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.damage_near] = 0.06,
			},
		},
	},
}
templates.weapon_trait_bespoke_autogun_p1_hipfire_while_sprinting = {
	weapon_trait_bespoke_autogun_p1_hipfire_while_sprinting = {
		{},
	},
}
templates.weapon_trait_bespoke_autogun_p1_increase_power_on_close_kill = {
	weapon_trait_bespoke_autogun_p1_increase_power_on_close_kill_parent = {
		{
			child_duration = 3.5,
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.05,
			},
		},
		{
			child_duration = 3.5,
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.055,
			},
		},
		{
			child_duration = 3.5,
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.06,
			},
		},
		{
			child_duration = 3.5,
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.065,
			},
		},
	},
}
templates.weapon_trait_bespoke_autogun_p1_increase_close_damage_on_close_kill = {
	weapon_trait_bespoke_autogun_p1_increase_close_damage_on_close_kill_parent = {
		{
			child_duration = 3.5,
			stat_buffs = {
				[stat_buffs.damage_near] = 0.07,
			},
		},
		{
			child_duration = 3.5,
			stat_buffs = {
				[stat_buffs.damage_near] = 0.08,
			},
		},
		{
			child_duration = 3.5,
			stat_buffs = {
				[stat_buffs.damage_near] = 0.09,
			},
		},
		{
			child_duration = 3.5,
			stat_buffs = {
				[stat_buffs.damage_near] = 0.1,
			},
		},
	},
}
templates.weapon_trait_bespoke_autogun_p1_increase_damage_on_close_kill = {
	weapon_trait_bespoke_autogun_p1_increase_damage_on_close_kill_parent = {
		{
			child_duration = 1.75,
			stat_buffs = {
				[stat_buffs.damage] = 0.02,
			},
		},
		{
			child_duration = 1.75,
			stat_buffs = {
				[stat_buffs.damage] = 0.03,
			},
		},
		{
			child_duration = 1.75,
			stat_buffs = {
				[stat_buffs.damage] = 0.04,
			},
		},
		{
			child_duration = 1.75,
			stat_buffs = {
				[stat_buffs.damage] = 0.05,
			},
		},
	},
}
templates.weapon_trait_bespoke_autogun_p1_suppression_on_close_kill = {
	weapon_trait_bespoke_autogun_p1_suppression_on_close_kill = {
		{
			suppression_settings = {
				distance = 12,
				instant_aggro = true,
				suppression_falloff = false,
				suppression_value = 15,
			},
		},
		{
			suppression_settings = {
				distance = 12,
				instant_aggro = true,
				suppression_falloff = false,
				suppression_value = 20,
			},
		},
		{
			suppression_settings = {
				distance = 12,
				instant_aggro = true,
				suppression_falloff = false,
				suppression_value = 25,
			},
		},
		{
			suppression_settings = {
				distance = 12,
				instant_aggro = true,
				suppression_falloff = false,
				suppression_value = 30,
			},
		},
	},
}
templates.weapon_trait_bespoke_autogun_p1_count_as_dodge_vs_ranged_on_close_kill = {
	weapon_trait_bespoke_autogun_p1_count_as_dodge_vs_ranged_on_close_kill = {
		{
			active_duration = 0.7,
		},
		{
			active_duration = 0.8,
		},
		{
			active_duration = 0.9,
		},
		{
			active_duration = 1,
		},
	},
}
templates.weapon_trait_bespoke_autogun_p1_reload_speed_on_dodge = {
	weapon_trait_bespoke_autogun_p1_reload_speed_on_dodge = {
		{
			stat_buffs = {
				[stat_buffs.reload_speed] = 0.1,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.reload_speed] = 0.125,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.reload_speed] = 0.15,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.reload_speed] = 0.2,
			},
		},
	},
}
templates.weapon_trait_bespoke_autogun_p1_reload_speed_on_slide = {
	weapon_trait_bespoke_autogun_p1_reload_speed_on_slide_parent = {
		{
			child_duration = 2.5,
			stat_buffs = {
				[stat_buffs.reload_speed] = 0.07,
			},
		},
		{
			child_duration = 2.5,
			stat_buffs = {
				[stat_buffs.reload_speed] = 0.08,
			},
		},
		{
			child_duration = 2.5,
			stat_buffs = {
				[stat_buffs.reload_speed] = 0.09,
			},
		},
		{
			child_duration = 2.5,
			stat_buffs = {
				[stat_buffs.reload_speed] = 0.1,
			},
		},
	},
}
templates.weapon_trait_bespoke_autogun_p1_allow_flanking_and_increased_damage_when_flanking = {
	weapon_trait_bespoke_autogun_p1_allow_flanking_and_increased_damage_when_flanking = {
		{
			stat_buffs = {
				[stat_buffs.flanking_damage] = 0.325,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.flanking_damage] = 0.35,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.flanking_damage] = 0.375,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.flanking_damage] = 0.4,
			},
		},
	},
}
templates.weapon_trait_bespoke_autogun_p1_increased_sprint_speed = {
	weapon_trait_bespoke_autogun_p1_increased_sprint_speed = {
		{
			condtional_threshold = 0.8,
		},
		{
			condtional_threshold = 0.7,
		},
		{
			condtional_threshold = 0.6,
		},
		{
			condtional_threshold = 0.5,
		},
	},
}
templates.weapon_trait_bespoke_autogun_p1_followup_shots_ranged_damage = {
	weapon_trait_bespoke_autogun_p1_followup_shots_ranged_damage = {
		{
			conditional_stat_buffs = {
				[stat_buffs.ranged_damage] = 0.14,
			},
		},
		{
			conditional_stat_buffs = {
				[stat_buffs.ranged_damage] = 0.16,
			},
		},
		{
			conditional_stat_buffs = {
				[stat_buffs.ranged_damage] = 0.18,
			},
		},
		{
			conditional_stat_buffs = {
				[stat_buffs.ranged_damage] = 0.2,
			},
		},
	},
}
templates.weapon_trait_bespoke_autogun_p1_followup_shots_ranged_weakspot_damage = {
	weapon_trait_bespoke_autogun_p1_followup_shots_ranged_weakspot_damage = {
		{
			conditional_stat_buffs = {
				[stat_buffs.ranged_weakspot_damage] = 0.35,
			},
		},
		{
			conditional_stat_buffs = {
				[stat_buffs.ranged_weakspot_damage] = 0.4,
			},
		},
		{
			conditional_stat_buffs = {
				[stat_buffs.ranged_weakspot_damage] = 0.45,
			},
		},
		{
			conditional_stat_buffs = {
				[stat_buffs.ranged_weakspot_damage] = 0.5,
			},
		},
	},
}
templates.weapon_trait_bespoke_autogun_p1_improved_sprint_dodge = {
	weapon_trait_bespoke_autogun_p1_improved_sprint_dodge = {
		{
			proc_stat_buffs = {
				[stat_buffs.sprint_movement_speed] = 0.1,
			},
		},
		{
			proc_stat_buffs = {
				[stat_buffs.sprint_movement_speed] = 0.125,
			},
		},
		{
			proc_stat_buffs = {
				[stat_buffs.sprint_movement_speed] = 0.15,
			},
			conditional_stat_buffs = {
				[stat_buffs.sprint_dodge_reduce_angle_threshold_rad] = _degrees_to_radians(10),
			},
		},
		{
			proc_stat_buffs = {
				[stat_buffs.sprint_movement_speed] = 0.15,
			},
			conditional_stat_buffs = {
				[stat_buffs.sprint_dodge_reduce_angle_threshold_rad] = _degrees_to_radians(10),
			},
		},
	},
}

return templates
