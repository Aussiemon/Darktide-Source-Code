-- chunkname: @scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_shotgun_p2.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local stat_buffs = BuffSettings.stat_buffs
local templates = {}

table.make_unique(templates)

templates.weapon_trait_bespoke_shotgun_p2_count_as_dodge_vs_ranged_on_close_kill = {
	weapon_trait_bespoke_shotgun_p2_count_as_dodge_vs_ranged_on_close_kill = {
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
templates.weapon_trait_bespoke_shotgun_p2_increase_power_on_close_kill = {
	weapon_trait_bespoke_shotgun_p2_increase_power_on_close_kill_parent = {
		{
			child_duration = 5,
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.05,
			},
		},
		{
			child_duration = 5,
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.055,
			},
		},
		{
			child_duration = 5,
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.06,
			},
		},
		{
			child_duration = 5,
			stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.065,
			},
		},
	},
}
templates.weapon_trait_bespoke_shotgun_p2_increase_close_damage_on_close_kill = {
	weapon_trait_bespoke_shotgun_p2_increase_close_damage_on_close_kill_parent = {
		{
			child_duration = 5,
			stat_buffs = {
				[stat_buffs.damage_near] = 0.07,
			},
		},
		{
			child_duration = 5,
			stat_buffs = {
				[stat_buffs.damage_near] = 0.08,
			},
		},
		{
			child_duration = 5,
			stat_buffs = {
				[stat_buffs.damage_near] = 0.09,
			},
		},
		{
			child_duration = 5,
			stat_buffs = {
				[stat_buffs.damage_near] = 0.1,
			},
		},
	},
}
templates.weapon_trait_bespoke_shotgun_p2_suppression_on_close_kill = {
	weapon_trait_bespoke_shotgun_p2_suppression_on_close_kill = {
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
templates.weapon_trait_bespoke_shotgun_p2_bleed_on_crit = {
	weapon_trait_bespoke_shotgun_p2_bleed_on_crit = {
		{
			target_buff_data = {
				num_stacks_on_proc = 3,
			},
		},
		{
			target_buff_data = {
				num_stacks_on_proc = 4,
			},
		},
		{
			target_buff_data = {
				num_stacks_on_proc = 5,
			},
		},
		{
			target_buff_data = {
				num_stacks_on_proc = 6,
			},
		},
	},
}
templates.weapon_trait_bespoke_shotgun_p2_cleave_on_crit = {
	weapon_trait_bespoke_shotgun_p2_cleave_on_crit = {
		{
			conditional_stat_buffs = {
				[stat_buffs.ranged_impact_modifier] = 0.1,
			},
		},
		{
			conditional_stat_buffs = {
				[stat_buffs.ranged_impact_modifier] = 0.15,
			},
		},
		{
			conditional_stat_buffs = {
				[stat_buffs.ranged_impact_modifier] = 0.2,
			},
		},
		{
			conditional_stat_buffs = {
				[stat_buffs.ranged_impact_modifier] = 0.25,
			},
		},
	},
}
templates.weapon_trait_bespoke_shotgun_p2_power_bonus_on_hitting_single_enemy_with_all = {
	weapon_trait_bespoke_shotgun_p2_power_bonus_on_hitting_single_enemy_with_all = {
		{
			proc_stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.14,
			},
		},
		{
			proc_stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.16,
			},
		},
		{
			proc_stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.18,
			},
		},
		{
			proc_stat_buffs = {
				[stat_buffs.power_level_modifier] = 0.2,
			},
		},
	},
}
templates.weapon_trait_bespoke_shotgun_p2_crit_chance_on_hitting_multiple_with_one_shot = {
	weapon_trait_bespoke_shotgun_p2_crit_chance_on_hitting_multiple_with_one_shot_parent = {
		{
			conditional_stat_buffs = {
				[stat_buffs.ranged_critical_strike_chance] = 0.06,
			},
		},
		{
			conditional_stat_buffs = {
				[stat_buffs.ranged_critical_strike_chance] = 0.08,
			},
		},
		{
			conditional_stat_buffs = {
				[stat_buffs.ranged_critical_strike_chance] = 0.1,
			},
		},
		{
			conditional_stat_buffs = {
				[stat_buffs.ranged_critical_strike_chance] = 0.12,
			},
		},
	},
}
templates.weapon_trait_bespoke_shotgun_p2_reload_speed_on_slide = {
	weapon_trait_bespoke_shotgun_p2_reload_speed_on_slide_parent = {
		{
			child_duration = 3,
			stat_buffs = {
				[stat_buffs.reload_speed] = 0.07,
			},
		},
		{
			child_duration = 3,
			stat_buffs = {
				[stat_buffs.reload_speed] = 0.08,
			},
		},
		{
			child_duration = 3,
			stat_buffs = {
				[stat_buffs.reload_speed] = 0.09,
			},
		},
		{
			child_duration = 3,
			stat_buffs = {
				[stat_buffs.reload_speed] = 0.1,
			},
		},
	},
}
templates.weapon_trait_bespoke_shotgun_p2_crit_chance_on_reload = {
	weapon_trait_bespoke_shotgun_p2_crit_chance_on_reload = {
		{
			proc_stat_buffs = {
				[stat_buffs.ranged_critical_strike_chance] = 0.075,
			},
		},
		{
			proc_stat_buffs = {
				[stat_buffs.ranged_critical_strike_chance] = 0.1,
			},
		},
		{
			proc_stat_buffs = {
				[stat_buffs.ranged_critical_strike_chance] = 0.125,
			},
		},
		{
			proc_stat_buffs = {
				[stat_buffs.ranged_critical_strike_chance] = 0.15,
			},
		},
	},
}
templates.weapon_trait_bespoke_shotgun_p2_hipfire_while_sprinting = {
	weapon_trait_bespoke_shotgun_p2_hipfire_while_sprinting = {
		{
			stat_buffs = {
				[stat_buffs.spread_modifier] = -0.3,
			},
			conditional_stat_buffs = {
				[stat_buffs.damage_near] = 0.06,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.spread_modifier] = -0.3,
			},
			conditional_stat_buffs = {
				[stat_buffs.damage_near] = 0.09,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.spread_modifier] = -0.3,
			},
			conditional_stat_buffs = {
				[stat_buffs.damage_near] = 0.12,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.spread_modifier] = -0.3,
			},
			conditional_stat_buffs = {
				[stat_buffs.damage_near] = 0.15,
			},
		},
	},
}
templates.weapon_trait_bespoke_shotgun_p2_reload_speed_on_ranged_weapon_special_kill = {
	weapon_trait_bespoke_shotgun_p2_reload_speed_on_ranged_weapon_special_kill = {
		{
			conditional_stat_buffs = {
				[stat_buffs.reload_speed] = 0.4,
			},
		},
		{
			conditional_stat_buffs = {
				[stat_buffs.reload_speed] = 0.5,
			},
		},
		{
			conditional_stat_buffs = {
				[stat_buffs.reload_speed] = 0.6,
			},
		},
		{
			conditional_stat_buffs = {
				[stat_buffs.reload_speed] = 0.7,
			},
		},
	},
}

return templates
