-- chunkname: @scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_forcestaff_p1.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local templates = {}

table.make_unique(templates)

local stat_buffs = BuffSettings.stat_buffs

templates.weapon_trait_bespoke_forcestaff_p1_vents_warpcharge_on_weakspot_hits = {
	format_values = {
		warp_charge = {
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_forcestaff_p1_vents_warpcharge_on_weakspot_hits",
				find_value_type = "trait_override",
				path = {
					"vent_percentage",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_forcestaff_p1_vents_warpcharge_on_weakspot_hits = {
			{
				vent_percentage = 0.07,
			},
			{
				vent_percentage = 0.08,
			},
			{
				vent_percentage = 0.09,
			},
			{
				vent_percentage = 0.1,
			},
		},
	},
}
templates.weapon_trait_bespoke_forcestaff_p1_suppression_on_close_kill = {
	format_values = {
		range = {
			format_type = "string",
			find_value = {
				find_value_type = "rarity_value",
				trait_value = {
					"5m",
					"6m",
					"7m",
					"8m",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_forcestaff_p1_suppression_on_close_kill = {
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
	},
}
templates.weapon_trait_bespoke_forcestaff_p1_hipfire_while_sprinting = {
	format_values = {
		weapon_spread = {
			format_type = "percentage",
			prefix = "",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_forcestaff_p1_hipfire_while_sprinting",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.spread_modifier,
				},
			},
		},
		damage_near = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_forcestaff_p1_hipfire_while_sprinting",
				find_value_type = "trait_override",
				path = {
					"conditional_stat_buffs",
					stat_buffs.damage_near,
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_forcestaff_p1_hipfire_while_sprinting = {
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
templates.weapon_trait_bespoke_forcestaff_p1_followup_shots_ranged_damage = {
	format_values = {
		damage = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_forcestaff_p1_followup_shots_ranged_damage",
				find_value_type = "trait_override",
				path = {
					"conditional_stat_buffs",
					stat_buffs.ranged_damage,
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_forcestaff_p1_followup_shots_ranged_damage = {
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
	},
}
templates.weapon_trait_bespoke_forcestaff_p1_warp_burninating_on_crits = {
	format_values = {
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_forcestaff_p1_warp_burninating_on_crits",
				find_value_type = "trait_override",
				path = {
					"target_buff_data",
					"num_stacks_on_proc",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_forcestaff_p1_warp_burninating_on_crits = {
			{
				target_buff_data = {
					num_stacks_on_proc = 1,
				},
			},
			{
				target_buff_data = {
					num_stacks_on_proc = 2,
				},
			},
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
		},
	},
}
templates.weapon_trait_bespoke_forcestaff_p1_warp_charge_critical_strike_chance_bonus = {
	format_values = {
		crit_chance = {
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_forcestaff_p1_warp_charge_critical_strike_chance_bonus",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.critical_strike_chance,
				},
			},
		},
		crit_chance_max = {
			format_type = "number",
			suffix = "%",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_forcestaff_p1_warp_charge_critical_strike_chance_bonus",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.critical_strike_chance,
				},
			},
			value_manipulation = function (value)
				return math.abs(value * 100) * 4
			end,
		},
	},
	buffs = {
		weapon_trait_bespoke_forcestaff_p1_warp_charge_critical_strike_chance_bonus = {
			{
				stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.035,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.04,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.045,
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
templates.weapon_trait_bespoke_forcestaff_p1_rend_armor_on_aoe_charge = {
	format_values = {
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_forcestaff_p1_rend_armor_on_aoe_charge",
				find_value_type = "trait_override",
				path = {
					"target_buff_data",
					"num_stacks_on_proc",
				},
			},
		},
		rending = {
			format_type = "percentage",
			find_value = {
				buff_template_name = "rending_debuff",
				find_value_type = "buff_template",
				path = {
					"stat_buffs",
					stat_buffs.rending_multiplier,
				},
			},
		},
		time = {
			format_type = "number",
			find_value = {
				buff_template_name = "rending_debuff",
				find_value_type = "buff_template",
				path = {
					"duration",
				},
			},
		},
		max_stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "rending_debuff",
				find_value_type = "buff_template",
				path = {
					"max_stacks",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_forcestaff_p1_rend_armor_on_aoe_charge = {
			{
				target_buff_data = {
					num_stacks_on_proc = 2,
				},
			},
			{
				target_buff_data = {
					num_stacks_on_proc = 4,
				},
			},
			{
				target_buff_data = {
					num_stacks_on_proc = 6,
				},
			},
			{
				target_buff_data = {
					num_stacks_on_proc = 8,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_forcestaff_p1_uninterruptable_while_charging = {
	format_values = {
		reduction = {
			format_type = "percentage",
			num_decimals = 0,
			find_value = {
				buff_template_name = "weapon_trait_bespoke_forcestaff_p1_uninterruptable_while_charging",
				find_value_type = "trait_override",
				path = {
					"conditional_stat_buffs",
					stat_buffs.charge_movement_reduction_multiplier,
				},
			},
			value_manipulation = function (value)
				return 100 - math.round(value * 100)
			end,
		},
	},
	buffs = {
		weapon_trait_bespoke_forcestaff_p1_uninterruptable_while_charging = {
			{
				conditional_stat_buffs = {
					[stat_buffs.charge_movement_reduction_multiplier] = 0.8,
				},
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.charge_movement_reduction_multiplier] = 0.7,
				},
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.charge_movement_reduction_multiplier] = 0.6,
				},
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.charge_movement_reduction_multiplier] = 0.5,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_forcestaff_p1_faster_charge_on_chained_secondary_attacks = {
	format_values = {
		charge_time = {
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_forcestaff_p1_faster_charge_on_chained_secondary_attacks_parent",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.charge_up_time,
				},
			},
		},
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_forcestaff_p1_faster_charge_on_chained_secondary_attacks_child",
				find_value_type = "buff_template",
				path = {
					"max_stacks",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_forcestaff_p1_faster_charge_on_chained_secondary_attacks_parent = {
			{
				stat_buffs = {
					[stat_buffs.charge_up_time] = -0.055,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.charge_up_time] = -0.065,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.charge_up_time] = -0.075,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.charge_up_time] = -0.085,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_forcestaff_p1_double_shot_on_crit = {
	format_values = {
		crit_chance = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_forcestaff_p1_double_shot_on_crit",
				find_value_type = "trait_override",
				path = {
					"conditional_stat_buffs",
					stat_buffs.ranged_critical_strike_chance,
				},
			},
		},
		value = {
			format_type = "string",
			value = "2",
		},
	},
	buffs = {
		weapon_trait_bespoke_forcestaff_p1_double_shot_on_crit = {
			{
				conditional_stat_buffs = {
					[stat_buffs.ranged_critical_strike_chance] = 0.02,
				},
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.ranged_critical_strike_chance] = 0.03,
				},
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.ranged_critical_strike_chance] = 0.04,
				},
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.ranged_critical_strike_chance] = 0.05,
				},
			},
		},
	},
}

return templates
