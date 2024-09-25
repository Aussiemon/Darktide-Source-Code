﻿-- chunkname: @scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_laspistol_p1.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local templates = {}

table.make_unique(templates)

local stat_buffs = BuffSettings.stat_buffs

templates.weapon_trait_bespoke_laspistol_p1_hipfire_while_sprinting = {
	buffs = {
		weapon_trait_bespoke_laspistol_p1_hipfire_while_sprinting = {
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
	},
}
templates.weapon_trait_bespoke_laspistol_p1_reload_speed_on_slide = {
	buffs = {
		weapon_trait_bespoke_laspistol_p1_reload_speed_on_slide_parent = {
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
	},
}
templates.weapon_trait_bespoke_laspistol_p1_burninating_on_crit = {
	buffs = {
		weapon_trait_bespoke_laspistol_p1_burninating_on_crit = {
			{
				target_buff_data = {
					max_stacks = 3,
					num_stacks_on_proc = 1,
				},
			},
			{
				target_buff_data = {
					max_stacks = 6,
					num_stacks_on_proc = 2,
				},
			},
			{
				target_buff_data = {
					max_stacks = 9,
					num_stacks_on_proc = 3,
				},
			},
			{
				target_buff_data = {
					max_stacks = 12,
					num_stacks_on_proc = 4,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_laspistol_p1_allow_flanking_and_increased_damage_when_flanking = {
	buffs = {
		weapon_trait_bespoke_laspistol_p1_allow_flanking_and_increased_damage_when_flanking = {
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
	},
}
templates.weapon_trait_bespoke_laspistol_p1_suppression_negation_on_weakspot = {
	buffs = {
		weapon_trait_bespoke_laspistol_p1_suppression_negation_on_weakspot = {
			{
				active_duration = 2.4,
			},
			{
				active_duration = 2.8,
			},
			{
				active_duration = 3.2,
			},
			{
				active_duration = 3.6,
			},
		},
	},
}
templates.weapon_trait_bespoke_laspistol_p1_count_as_dodge_vs_ranged_on_weakspot = {
	buffs = {
		weapon_trait_bespoke_laspistol_p1_count_as_dodge_vs_ranged_on_weakspot = {
			{
				active_duration = 0.6,
			},
			{
				active_duration = 0.8,
			},
			{
				active_duration = 1,
			},
			{
				active_duration = 1.2,
			},
		},
	},
}
templates.weapon_trait_bespoke_laspistol_p1_consecutive_hits_increases_close_damage = {
	buffs = {
		weapon_trait_bespoke_laspistol_p1_consecutive_hits_increases_close_damage_parent = {
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
	},
}
templates.weapon_trait_bespoke_laspistol_p1_toughness_on_crit_kills = {
	buffs = {
		weapon_trait_bespoke_laspistol_p1_toughness_on_crit_kills = {
			{
				toughness_fixed_percentage = 0.1,
			},
			{
				toughness_fixed_percentage = 0.12,
			},
			{
				toughness_fixed_percentage = 0.14,
			},
			{
				toughness_fixed_percentage = 0.16,
			},
		},
	},
}
templates.weapon_trait_bespoke_laspistol_p1_dodge_grants_critical_strike_chance = {
	buffs = {
		weapon_trait_bespoke_laspistol_p1_dodge_grants_critical_strike_chance = {
			{
				proc_stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.125,
				},
			},
			{
				proc_stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.15,
				},
			},
			{
				proc_stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.175,
				},
			},
			{
				proc_stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.2,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_laspistol_p1_chained_weakspot_hits_increases_crit_chance = {
	buffs = {
		weapon_trait_bespoke_laspistol_p1_chained_weakspot_hits_increases_crit_chance_parent = {
			{
				stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.02,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.03,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.04,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.05,
				},
			},
		},
	},
}

return templates
