-- chunkname: @scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_galvanic_rifle_p1.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local stat_buffs = BuffSettings.stat_buffs
local templates = {}

table.make_unique(templates)

templates.weapon_trait_bespoke_galvanic_rifle_p1_suppression_negation_on_weakspot = {
	format_values = {
		time = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_galvanic_rifle_p1_suppression_negation_on_weakspot",
				find_value_type = "trait_override",
				path = {
					"active_duration",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_galvanic_rifle_p1_suppression_negation_on_weakspot = {
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
templates.weapon_trait_bespoke_galvanic_rifle_p1_crit_weakspot_finesse = {
	format_values = {
		crit_weakspot_damage = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_galvanic_rifle_p1_crit_weakspot_finesse",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.critical_strike_weakspot_damage,
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_galvanic_rifle_p1_crit_weakspot_finesse = {
			{
				stat_buffs = {
					[stat_buffs.critical_strike_weakspot_damage] = 0.3,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.critical_strike_weakspot_damage] = 0.4,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.critical_strike_weakspot_damage] = 0.5,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.critical_strike_weakspot_damage] = 0.6,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_galvanic_rifle_p1_count_as_dodge_vs_ranged_on_weakspot = {
	format_values = {
		time = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_galvanic_rifle_p1_count_as_dodge_vs_ranged_on_weakspot",
				find_value_type = "trait_override",
				path = {
					"active_duration",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_galvanic_rifle_p1_count_as_dodge_vs_ranged_on_weakspot = {
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
templates.weapon_trait_bespoke_galvanic_rifle_p1_stacking_crit_chance_on_weakspot = {
	format_values = {
		crit_chance = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_galvanic_rifle_p1_stacking_crit_chance_on_weakspot_parent",
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
				buff_template_name = "weapon_trait_bespoke_galvanic_rifle_p1_stacking_crit_chance_on_weakspot_parent",
				find_value_type = "trait_override",
				path = {
					"max_stacks",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_galvanic_rifle_p1_stacking_crit_chance_on_weakspot_parent = {
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
templates.weapon_trait_bespoke_galvanic_rifle_p1_target_hit_mass_reduction_on_weakspot_hits = {
	format_values = {
		hit_mass_reduction = {
			format_type = "percentage",
			value_manipulation = function (value)
				return 100 - math.round(value * 100)
			end,
			find_value = {
				buff_template_name = "weapon_trait_bespoke_galvanic_rifle_p1_target_hit_mass_reduction_on_weakspot_hits",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.consumed_hit_mass_modifier_on_weakspot_hit,
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_galvanic_rifle_p1_target_hit_mass_reduction_on_weakspot_hits = {
			{
				stat_buffs = {
					[stat_buffs.consumed_hit_mass_modifier_on_weakspot_hit] = 0.8,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.consumed_hit_mass_modifier_on_weakspot_hit] = 0.75,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.consumed_hit_mass_modifier_on_weakspot_hit] = 0.7,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.consumed_hit_mass_modifier_on_weakspot_hit] = 0.65,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_galvanic_rifle_p1_cleave_on_crit = {
	format_values = {
		stagger = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_galvanic_rifle_p1_cleave_on_crit",
				find_value_type = "trait_override",
				path = {
					"conditional_stat_buffs",
					stat_buffs.ranged_impact_modifier,
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_galvanic_rifle_p1_cleave_on_crit = {
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
	},
}
templates.weapon_trait_bespoke_galvanic_rifle_p1_power_bonus_on_first_shot = {
	format_values = {
		power_level = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_galvanic_rifle_p1_power_bonus_on_first_shot",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.ranged_power_level_modifier,
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_galvanic_rifle_p1_power_bonus_on_first_shot = {
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

local windup_increases_power_trait_num_steps = 5

templates.weapon_trait_bespoke_galvanic_rifle_p1_increases_power_while_aiming = {
	format_values = {
		power_level = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_galvanic_rifle_p1_increases_power_while_aiming",
				find_value_type = "trait_override",
				path = {
					"lerped_stat_buffs",
					stat_buffs.power_level_modifier,
					"max",
				},
			},
			value_manipulation = function (value)
				local value_per_stack = value / windup_increases_power_trait_num_steps

				return math.round_with_precision(value_per_stack * 100, 1)
			end,
		},
		time = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_galvanic_rifle_p1_increases_power_while_aiming",
				find_value_type = "trait_override",
				path = {
					"duration_per_step",
				},
			},
		},
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_galvanic_rifle_p1_increases_power_while_aiming",
				find_value_type = "trait_override",
				path = {
					"num_steps_for_max_stat",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_galvanic_rifle_p1_increases_power_while_aiming = {
			{
				duration_per_step = 0.4,
				num_steps_for_max_stat = windup_increases_power_trait_num_steps,
				lerped_stat_buffs = {
					[stat_buffs.power_level_modifier] = {
						max = 0.05,
						min = 0,
					},
				},
			},
			{
				duration_per_step = 0.4,
				num_steps_for_max_stat = windup_increases_power_trait_num_steps,
				lerped_stat_buffs = {
					[stat_buffs.power_level_modifier] = {
						max = 0.075,
						min = 0,
					},
				},
			},
			{
				duration_per_step = 0.4,
				num_steps_for_max_stat = windup_increases_power_trait_num_steps,
				lerped_stat_buffs = {
					[stat_buffs.power_level_modifier] = {
						max = 0.1,
						min = 0,
					},
				},
			},
			{
				duration_per_step = 0.4,
				num_steps_for_max_stat = windup_increases_power_trait_num_steps,
				lerped_stat_buffs = {
					[stat_buffs.power_level_modifier] = {
						max = 0.125,
						min = 0,
					},
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_galvanic_rifle_p1_chained_weakspot_hits_increases_power = {
	format_values = {
		power_level = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_galvanic_rifle_p1_chained_weakspot_hits_increases_power_parent",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.ranged_power_level_modifier,
				},
			},
		},
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_galvanic_rifle_p1_chained_weakspot_hits_increases_power_child",
				find_value_type = "buff_template",
				path = {
					"max_stacks",
				},
			},
		},
		time = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_galvanic_rifle_p1_chained_weakspot_hits_increases_power_parent",
				find_value_type = "trait_override",
				path = {
					"child_duration",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_galvanic_rifle_p1_chained_weakspot_hits_increases_power_parent = {
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
	},
}
templates.weapon_trait_bespoke_galvanic_rifle_p1_toughness_on_elite_kills = {
	format_values = {
		toughness = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_galvanic_rifle_p1_toughness_on_elite_kills",
				find_value_type = "trait_override",
				path = {
					"toughness_fixed_percentage",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_galvanic_rifle_p1_toughness_on_elite_kills = {
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

return templates
