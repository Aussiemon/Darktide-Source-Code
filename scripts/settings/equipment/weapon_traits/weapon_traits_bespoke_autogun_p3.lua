-- chunkname: @scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_autogun_p3.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local templates = {}

table.make_unique(templates)

local stat_buffs = BuffSettings.stat_buffs

templates.weapon_trait_bespoke_autogun_p3_crit_chance_based_on_ammo_left = {
	format_values = {
		crit_chance = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_autogun_p3_crit_chance_based_on_ammo_left",
				find_value_type = "trait_override",
				path = {
					"conditional_stat_buffs",
					stat_buffs.critical_strike_chance,
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_autogun_p3_crit_chance_based_on_ammo_left = {
			{
				conditional_stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.0045,
				},
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.005,
				},
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.0055,
				},
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.006,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_autogun_p3_stacking_crit_chance_on_weakspot = {
	format_values = {
		crit_chance = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_autogun_p3_stacking_crit_chance_on_weakspot_parent",
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
				buff_template_name = "weapon_trait_bespoke_autogun_p3_stacking_crit_chance_on_weakspot_parent",
				find_value_type = "trait_override",
				path = {
					"max_stacks",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_autogun_p3_stacking_crit_chance_on_weakspot_parent = {
			{
				max_stacks = 5,
				stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.14,
				},
			},
			{
				max_stacks = 5,
				stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.16,
				},
			},
			{
				max_stacks = 5,
				stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.18,
				},
			},
			{
				max_stacks = 5,
				stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.2,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_autogun_p3_suppression_negation_on_weakspot = {
	format_values = {
		time = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_autogun_p3_suppression_negation_on_weakspot",
				find_value_type = "trait_override",
				path = {
					"active_duration",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_autogun_p3_suppression_negation_on_weakspot = {
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
templates.weapon_trait_bespoke_autogun_p3_count_as_dodge_vs_ranged_on_weakspot = {
	format_values = {
		time = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_autogun_p3_count_as_dodge_vs_ranged_on_weakspot",
				find_value_type = "trait_override",
				path = {
					"active_duration",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_autogun_p3_count_as_dodge_vs_ranged_on_weakspot = {
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
templates.weapon_trait_bespoke_autogun_p3_negate_stagger_reduction_on_weakspot = {
	format_values = {
		stagger = {
			format_type = "percentage",
			num_decimals = 0,
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_autogun_p3_negate_stagger_reduction_on_weakspot",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.stagger_weakspot_reduction_modifier,
				},
			},
			value_manipulation = function (value)
				return 100 - math.round(value * 100)
			end,
		},
		ranged_stagger = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_autogun_p3_negate_stagger_reduction_on_weakspot",
				find_value_type = "buff_template",
				path = {
					"conditional_stat_buffs",
					stat_buffs.ranged_impact_modifier,
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_autogun_p3_negate_stagger_reduction_on_weakspot = {
			{
				stat_buffs = {
					[stat_buffs.stagger_weakspot_reduction_modifier] = 0.4,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.stagger_weakspot_reduction_modifier] = 0.3,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.stagger_weakspot_reduction_modifier] = 0.2,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.stagger_weakspot_reduction_modifier] = 0.1,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_autogun_p3_stagger_count_bonus_damage = {
	format_values = {
		damage = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_autogun_p3_stagger_count_bonus_damage",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.stagger_count_damage,
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_autogun_p3_stagger_count_bonus_damage = {
			{
				stat_buffs = {
					[stat_buffs.stagger_count_damage] = 0.14,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.stagger_count_damage] = 0.16,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.stagger_count_damage] = 0.18,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.stagger_count_damage] = 0.2,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_autogun_p3_crit_chance_based_on_aim_time = {
	format_values = {
		time = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_autogun_p3_crit_chance_based_on_aim_time",
				find_value_type = "trait_override",
				path = {
					"duration_per_stack",
				},
			},
		},
		crit_chance = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_autogun_p3_crit_chance_based_on_aim_time",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.critical_strike_chance,
				},
			},
		},
		stacks = {
			format_type = "string",
			value = "10",
		},
	},
	buffs = {
		weapon_trait_bespoke_autogun_p3_crit_chance_based_on_aim_time = {
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
			{
				duration_per_stack = 0.25,
				stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.1,
				},
			},
			{
				duration_per_stack = 0.2,
				stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.1,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_autogun_p3_crit_weakspot_finesse = {
	format_values = {
		crit_weakspot_damage = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_autogun_p3_crit_weakspot_finesse",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.critical_strike_weakspot_damage,
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_autogun_p3_crit_weakspot_finesse = {
			{
				stat_buffs = {
					[stat_buffs.critical_strike_weakspot_damage] = 0.7,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.critical_strike_weakspot_damage] = 0.8,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.critical_strike_weakspot_damage] = 0.9,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.critical_strike_weakspot_damage] = 1,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_autogun_p3_power_bonus_on_first_shot = {
	format_values = {
		power_level = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_autogun_p3_power_bonus_on_first_shot",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.ranged_power_level_modifier,
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_autogun_p3_power_bonus_on_first_shot = {
			{
				stat_buffs = {
					[stat_buffs.ranged_power_level_modifier] = 0.14,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.ranged_power_level_modifier] = 0.16,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.ranged_power_level_modifier] = 0.18,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.ranged_power_level_modifier] = 0.2,
				},
			},
		},
	},
}

return templates
