-- chunkname: @scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_stubrevolver_p1.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local templates = {}

table.make_unique(templates)

local stat_buffs = BuffSettings.stat_buffs

templates.weapon_trait_bespoke_stubrevolver_p1_hipfire_while_sprinting = {
	weapon_trait_bespoke_stubrevolver_p1_hipfire_while_sprinting = {
		{},
	},
}
templates.weapon_trait_bespoke_stubrevolver_p1_reload_speed_on_slide = {
	weapon_trait_bespoke_stubrevolver_p1_reload_speed_on_slide_parent = {
		{
			child_duration = 4,
			stat_buffs = {
				[stat_buffs.reload_speed] = 0.07,
			},
		},
		{
			child_duration = 4,
			stat_buffs = {
				[stat_buffs.reload_speed] = 0.08,
			},
		},
		{
			child_duration = 4,
			stat_buffs = {
				[stat_buffs.reload_speed] = 0.09,
			},
		},
		{
			child_duration = 4,
			stat_buffs = {
				[stat_buffs.reload_speed] = 0.1,
			},
		},
	},
}
templates.weapon_trait_bespoke_stubrevolver_p1_suppression_on_close_kill = {
	weapon_trait_bespoke_stubrevolver_p1_suppression_on_close_kill = {
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
templates.weapon_trait_bespoke_stubrevolver_p1_crit_chance_based_on_aim_time = {
	weapon_trait_bespoke_stubrevolver_p1_crit_chance_based_on_aim_time = {
		{
			duration_per_stack = 0.45,
			stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.1,
			},
		},
		{
			duration_per_stack = 0.4,
			stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.1,
			},
		},
		{
			duration_per_stack = 0.35,
			stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.1,
			},
		},
		{
			duration_per_stack = 0.3,
			stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.1,
			},
		},
	},
}
templates.weapon_trait_bespoke_stubrevolver_p1_crit_chance_based_on_ammo_left = {
	weapon_trait_bespoke_stubrevolver_p1_crit_chance_based_on_ammo_left = {
		{
			conditional_stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.045,
			},
		},
		{
			conditional_stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.05,
			},
		},
		{
			conditional_stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.055,
			},
		},
		{
			conditional_stat_buffs = {
				[stat_buffs.critical_strike_chance] = 0.06,
			},
		},
	},
}
templates.weapon_trait_bespoke_stubrevolver_p1_chained_weakspot_hits_increases_power = {
	weapon_trait_bespoke_stubrevolver_p1_chained_weakspot_hits_increases_power_parent = {
		{
			child_duration = 3.5,
			max_stacks = 5,
			stat_buffs = {
				[stat_buffs.ranged_power_level_modifier] = 0.045,
			},
		},
		{
			child_duration = 3.5,
			max_stacks = 5,
			stat_buffs = {
				[stat_buffs.ranged_power_level_modifier] = 0.05,
			},
		},
		{
			child_duration = 3.5,
			max_stacks = 5,
			stat_buffs = {
				[stat_buffs.ranged_power_level_modifier] = 0.055,
			},
		},
		{
			child_duration = 3.5,
			max_stacks = 5,
			stat_buffs = {
				[stat_buffs.ranged_power_level_modifier] = 0.06,
			},
		},
	},
}
templates.weapon_trait_bespoke_stubrevolver_p1_crit_chance_bonus_on_melee_kills = {
	weapon_trait_bespoke_stubrevolver_p1_crit_chance_bonus_on_melee_kills = {
		{
			active_duration = 2.5,
			proc_stat_buffs = {
				[stat_buffs.ranged_critical_strike_chance] = 0.14,
			},
		},
		{
			active_duration = 2.5,
			proc_stat_buffs = {
				[stat_buffs.ranged_critical_strike_chance] = 0.16,
			},
		},
		{
			active_duration = 2.5,
			proc_stat_buffs = {
				[stat_buffs.ranged_critical_strike_chance] = 0.18,
			},
		},
		{
			active_duration = 2.5,
			proc_stat_buffs = {
				[stat_buffs.ranged_critical_strike_chance] = 0.2,
			},
		},
	},
}
templates.weapon_trait_bespoke_stubrevolver_p1_toughness_on_elite_kills = {
	weapon_trait_bespoke_stubrevolver_p1_toughness_on_elite_kills = {
		{
			toughness_fixed_percentage = 0.18,
		},
		{
			toughness_fixed_percentage = 0.22,
		},
		{
			toughness_fixed_percentage = 0.26,
		},
		{
			toughness_fixed_percentage = 0.3,
		},
	},
}
templates.weapon_trait_bespoke_stubrevolver_p1_followup_shots_ranged_damage = {
	weapon_trait_bespoke_stubrevolver_p1_followup_shots_ranged_damage = {
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
templates.weapon_trait_bespoke_stubrevolver_p1_rending_on_crit = {
	weapon_trait_bespoke_stubrevolver_p1_rending_on_crit = {
		{
			stat_buffs = {
				[stat_buffs.critical_strike_rending_multiplier] = 0.3,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.critical_strike_rending_multiplier] = 0.4,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.critical_strike_rending_multiplier] = 0.5,
			},
		},
		{
			stat_buffs = {
				[stat_buffs.critical_strike_rending_multiplier] = 0.6,
			},
		},
	},
}

return templates
