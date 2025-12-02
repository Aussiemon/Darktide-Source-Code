-- chunkname: @scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_needlepistol_p1.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local templates = {}

table.make_unique(templates)

local stat_buffs = BuffSettings.stat_buffs

templates.weapon_trait_bespoke_needlepistol_p1_hipfire_while_sprinting = {
	format_values = {
		weapon_spread = {
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_needlepistol_p1_hipfire_while_sprinting",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.spread_modifier,
				},
			},
		},
		damage_near = {
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_needlepistol_p1_hipfire_while_sprinting",
				find_value_type = "trait_override",
				path = {
					"conditional_stat_buffs",
					stat_buffs.damage_near,
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_needlepistol_p1_hipfire_while_sprinting = {
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
templates.weapon_trait_bespoke_needlepistol_p1_target_hit_mass_reduction_on_weakspot_hits = {
	format_values = {
		hit_mass_reduction = {
			format_type = "percentage",
			value_manipulation = function (value)
				return 100 - math.round(value * 100)
			end,
			find_value = {
				buff_template_name = "weapon_trait_bespoke_needlepistol_p1_target_hit_mass_reduction_on_weakspot_hits",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.consumed_hit_mass_modifier_on_weakspot_hit,
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_needlepistol_p1_target_hit_mass_reduction_on_weakspot_hits = {
			{
				stat_buffs = {
					[stat_buffs.consumed_hit_mass_modifier_on_weakspot_hit] = 0.8,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.consumed_hit_mass_modifier_on_weakspot_hit] = 0.7,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.consumed_hit_mass_modifier_on_weakspot_hit] = 0.6,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.consumed_hit_mass_modifier_on_weakspot_hit] = 0.5,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_needlepistol_p1_count_as_dodge_vs_ranged_on_weakspot = {
	format_values = {
		time = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_needlepistol_p1_count_as_dodge_vs_ranged_on_weakspot",
				find_value_type = "trait_override",
				path = {
					"active_duration",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_needlepistol_p1_count_as_dodge_vs_ranged_on_weakspot = {
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
templates.weapon_trait_bespoke_needlepistol_p1_reload_speed_on_slide = {
	format_values = {
		reload_speed = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_needlepistol_p1_reload_speed_on_slide_parent",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.reload_speed,
				},
			},
		},
		time = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_needlepistol_p1_reload_speed_on_slide_parent",
				find_value_type = "trait_override",
				path = {
					"child_duration",
				},
			},
		},
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_needlepistol_p1_reload_speed_on_slide_child",
				find_value_type = "buff_template",
				path = {
					"max_stacks",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_needlepistol_p1_reload_speed_on_slide_parent = {
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
templates.weapon_trait_bespoke_needlepistol_p1_allow_flanking_and_increased_damage_when_flanking = {
	format_values = {
		damage = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_needlepistol_p1_allow_flanking_and_increased_damage_when_flanking",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.flanking_damage,
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_needlepistol_p1_allow_flanking_and_increased_damage_when_flanking = {
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
templates.weapon_trait_bespoke_needlepistol_p1_suppression_negation_on_weakspot = {
	format_values = {
		time = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_needlepistol_p1_suppression_negation_on_weakspot",
				find_value_type = "trait_override",
				path = {
					"active_duration",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_needlepistol_p1_suppression_negation_on_weakspot = {
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
templates.weapon_trait_bespoke_needlepistol_p1_consecutive_hits_increases_close_damage = {
	format_values = {
		damage = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_needlepistol_p1_consecutive_hits_increases_close_damage_parent",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.damage_near,
				},
			},
		},
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_needlepistol_p1_consecutive_hits_increases_close_damage_child",
				find_value_type = "buff_template",
				path = {
					"max_stacks",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_needlepistol_p1_consecutive_hits_increases_close_damage_parent = {
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
templates.weapon_trait_bespoke_needlepistol_p1_toughness_on_crit_kills = {
	format_values = {
		toughness = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_needlepistol_p1_toughness_on_crit_kills",
				find_value_type = "trait_override",
				path = {
					"toughness_fixed_percentage",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_needlepistol_p1_toughness_on_crit_kills = {
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
templates.weapon_trait_bespoke_needlepistol_p1_chained_weakspot_hits_increases_crit_chance = {
	format_values = {
		crit_chance = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_needlepistol_p1_chained_weakspot_hits_increases_crit_chance_parent",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.critical_strike_chance,
				},
			},
		},
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_needlepistol_p1_chained_weakspot_hits_increases_crit_chance_child",
				find_value_type = "buff_template",
				path = {
					"max_stacks",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_needlepistol_p1_chained_weakspot_hits_increases_crit_chance_parent = {
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
templates.weapon_trait_bespoke_needlepistol_p1_dodge_grants_critical_strike_chance = {
	format_values = {
		crit_chance = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_needlepistol_p1_dodge_grants_critical_strike_chance",
				find_value_type = "trait_override",
				path = {
					"proc_stat_buffs",
					stat_buffs.critical_strike_chance,
				},
			},
		},
		time = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_needlepistol_p1_dodge_grants_critical_strike_chance",
				find_value_type = "buff_template",
				path = {
					"active_duration",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_needlepistol_p1_dodge_grants_critical_strike_chance = {
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
templates.weapon_trait_bespoke_needlepistol_p1_increased_sprint_speed = {
	format_values = {
		stamina = {
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_needlepistol_p1_increased_sprint_speed",
				find_value_type = "trait_override",
				path = {
					"conditional_threshold",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_needlepistol_p1_increased_sprint_speed = {
			{
				conditional_threshold = 0.8,
			},
			{
				conditional_threshold = 0.7,
			},
			{
				conditional_threshold = 0.6,
			},
			{
				conditional_threshold = 0.5,
			},
		},
	},
}
templates.weapon_trait_bespoke_needlepistol_p1_toughness_on_elite_kills = {
	format_values = {
		toughness = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_needlepistol_p1_toughness_on_elite_kills",
				find_value_type = "trait_override",
				path = {
					"toughness_fixed_percentage",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_needlepistol_p1_toughness_on_elite_kills = {
			{
				toughness_fixed_percentage = 0.175,
			},
			{
				toughness_fixed_percentage = 0.2,
			},
			{
				toughness_fixed_percentage = 0.225,
			},
			{
				toughness_fixed_percentage = 0.25,
			},
		},
	},
}
templates.weapon_trait_bespoke_needlepistol_p1_crit_chance_bonus_on_melee_kills = {
	format_values = {
		crit_chance = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_needlepistol_p1_crit_chance_bonus_on_melee_kills",
				find_value_type = "trait_override",
				path = {
					"proc_stat_buffs",
					stat_buffs.ranged_critical_strike_chance,
				},
			},
		},
		time = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_needlepistol_p1_crit_chance_bonus_on_melee_kills",
				find_value_type = "trait_override",
				path = {
					"active_duration",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_needlepistol_p1_crit_chance_bonus_on_melee_kills = {
			{
				active_duration = 3.5,
				proc_stat_buffs = {
					[stat_buffs.ranged_critical_strike_chance] = 0.14,
				},
			},
			{
				active_duration = 3.5,
				proc_stat_buffs = {
					[stat_buffs.ranged_critical_strike_chance] = 0.16,
				},
			},
			{
				active_duration = 3.5,
				proc_stat_buffs = {
					[stat_buffs.ranged_critical_strike_chance] = 0.18,
				},
			},
			{
				active_duration = 3.5,
				proc_stat_buffs = {
					[stat_buffs.ranged_critical_strike_chance] = 0.2,
				},
			},
		},
	},
}

return templates
