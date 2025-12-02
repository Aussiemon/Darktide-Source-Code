-- chunkname: @scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_crowbar_p1.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local templates = {}

table.make_unique(templates)

local stat_buffs = BuffSettings.stat_buffs

templates.weapon_trait_bespoke_crowbar_p1_chained_hits_increases_power = {
	format_values = {
		power_level = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_crowbar_p1_chained_hits_increases_power_parent",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.melee_power_level_modifier,
				},
			},
		},
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_crowbar_p1_chained_hits_increases_power_parent",
				find_value_type = "trait_override",
				path = {
					"max_stacks",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_crowbar_p1_chained_hits_increases_power_parent = {
			{
				max_stacks = 10,
				stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.02,
				},
			},
			{
				max_stacks = 10,
				stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.03,
				},
			},
			{
				max_stacks = 10,
				stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.04,
				},
			},
			{
				max_stacks = 10,
				stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.05,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_crowbar_p1_consecutive_hits_increases_stagger = {
	format_values = {
		impact = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_crowbar_p1_consecutive_hits_increases_stagger_parent",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.melee_impact_modifier,
				},
			},
		},
		time = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_crowbar_p1_consecutive_hits_increases_stagger_parent",
				find_value_type = "buff_template",
				path = {
					"child_duration",
				},
			},
		},
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_crowbar_p1_consecutive_hits_increases_stagger_child",
				find_value_type = "buff_template",
				path = {
					"max_stacks",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_crowbar_p1_consecutive_hits_increases_stagger_parent = {
			{
				stat_buffs = {
					[stat_buffs.melee_impact_modifier] = 0.14,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.melee_impact_modifier] = 0.16,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.melee_impact_modifier] = 0.18,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.melee_impact_modifier] = 0.2,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_crowbar_p1_power_bonus_on_first_attack = {
	format_values = {
		power_level = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_crowbar_p1_power_bonus_on_first_attack",
				find_value_type = "trait_override",
				path = {
					"conditional_switch_stat_buffs",
					1,
					stat_buffs.melee_power_level_modifier,
				},
			},
		},
		cooldown = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_crowbar_p1_power_bonus_on_first_attack",
				find_value_type = "trait_override",
				path = {
					"no_power_duration",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_crowbar_p1_power_bonus_on_first_attack = {
			{
				no_power_duration = 5,
				conditional_switch_stat_buffs = {
					{
						[stat_buffs.melee_power_level_modifier] = 0.6,
					},
				},
			},
			{
				no_power_duration = 4.5,
				conditional_switch_stat_buffs = {
					{
						[stat_buffs.melee_power_level_modifier] = 0.6,
					},
				},
			},
			{
				no_power_duration = 4,
				conditional_switch_stat_buffs = {
					{
						[stat_buffs.melee_power_level_modifier] = 0.6,
					},
				},
			},
			{
				no_power_duration = 3.5,
				conditional_switch_stat_buffs = {
					{
						[stat_buffs.melee_power_level_modifier] = 0.6,
					},
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_crowbar_p1_power_bonus_scaled_on_stamina = {
	format_values = {
		power_level = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_crowbar_p1_power_bonus_scaled_on_stamina",
				find_value_type = "trait_override",
				path = {
					"conditional_stat_buffs",
					stat_buffs.melee_power_level_modifier,
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_crowbar_p1_power_bonus_scaled_on_stamina = {
			{
				conditional_stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.05,
				},
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.06,
				},
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.07,
				},
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.08,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_crowbar_p1_stacking_increase_impact_on_hit = {
	format_values = {
		impact = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_crowbar_p1_stacking_increase_impact_on_hit_parent",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.melee_impact_modifier,
				},
			},
		},
		time = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_crowbar_p1_stacking_increase_impact_on_hit_parent",
				find_value_type = "trait_override",
				path = {
					"child_duration",
				},
			},
		},
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_crowbar_p1_stacking_increase_impact_on_hit_child",
				find_value_type = "buff_template",
				path = {
					"max_stacks",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_crowbar_p1_stacking_increase_impact_on_hit_parent = {
			{
				child_duration = 3.5,
				stat_buffs = {
					[stat_buffs.melee_impact_modifier] = 0.19,
				},
			},
			{
				child_duration = 3.5,
				stat_buffs = {
					[stat_buffs.melee_impact_modifier] = 0.21,
				},
			},
			{
				child_duration = 3.5,
				stat_buffs = {
					[stat_buffs.melee_impact_modifier] = 0.23,
				},
			},
			{
				child_duration = 3.5,
				stat_buffs = {
					[stat_buffs.melee_impact_modifier] = 0.25,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_crowbar_p1_increased_weakspot_damage_on_push = {
	format_values = {
		damage = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_crowbar_p1_increased_weakspot_damage_on_push",
				find_value_type = "trait_override",
				path = {
					"proc_stat_buffs",
					stat_buffs.weakspot_damage,
				},
			},
		},
		time = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_crowbar_p1_increased_weakspot_damage_on_push",
				find_value_type = "buff_template",
				path = {
					"active_duration",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_crowbar_p1_increased_weakspot_damage_on_push = {
			{
				proc_stat_buffs = {
					[stat_buffs.weakspot_damage] = 0.45,
				},
			},
			{
				proc_stat_buffs = {
					[stat_buffs.weakspot_damage] = 0.5,
				},
			},
			{
				proc_stat_buffs = {
					[stat_buffs.weakspot_damage] = 0.55,
				},
			},
			{
				proc_stat_buffs = {
					[stat_buffs.weakspot_damage] = 0.6,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_crowbar_p1_staggered_targets_receive_increased_stagger_debuff = {
	format_values = {
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_crowbar_p1_staggered_targets_receive_increased_stagger_debuff",
				find_value_type = "trait_override",
				path = {
					"target_buff_data",
					"num_stacks_on_proc",
				},
			},
		},
		impact = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "increase_impact_received_while_staggered",
				find_value_type = "buff_template",
				path = {
					"stat_buffs",
					stat_buffs.impact_modifier,
				},
			},
		},
		time = {
			format_type = "number",
			find_value = {
				buff_template_name = "increase_impact_received_while_staggered",
				find_value_type = "buff_template",
				path = {
					"duration",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_crowbar_p1_staggered_targets_receive_increased_stagger_debuff = {
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
templates.weapon_trait_bespoke_crowbar_p1_rending_vs_staggered = {
	format_values = {
		rending = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_crowbar_p1_rending_vs_staggered",
				find_value_type = "trait_override",
				path = {
					"conditional_stat_buffs",
					stat_buffs.rending_vs_staggered_multiplier,
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_crowbar_p1_rending_vs_staggered = {
			{
				conditional_stat_buffs = {
					[stat_buffs.rending_vs_staggered_multiplier] = 0.1,
				},
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.rending_vs_staggered_multiplier] = 0.15,
				},
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.rending_vs_staggered_multiplier] = 0.2,
				},
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.rending_vs_staggered_multiplier] = 0.25,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_crowbar_p1_pass_past_armor_on_heavy_attack = {
	format_values = {
		damage = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_crowbar_p1_pass_past_armor_on_heavy_attack",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.melee_fully_charged_damage,
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_crowbar_p1_pass_past_armor_on_heavy_attack = {
			{
				stat_buffs = {
					[stat_buffs.melee_fully_charged_damage] = 0.025,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.melee_fully_charged_damage] = 0.05,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.melee_fully_charged_damage] = 0.075,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.melee_fully_charged_damage] = 0.1,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_crowbar_p1_elite_kills_grants_stackable_power = {
	format_values = {
		power_level = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_crowbar_p1_elite_kills_grants_stackable_power_parent",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.power_level_modifier,
				},
			},
		},
		time = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_crowbar_p1_elite_kills_grants_stackable_power_parent",
				find_value_type = "buff_template",
				path = {
					"child_duration",
				},
			},
		},
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_crowbar_p1_elite_kills_grants_stackable_power_child",
				find_value_type = "buff_template",
				path = {
					"max_stacks",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_crowbar_p1_elite_kills_grants_stackable_power_parent = {
			{
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.05,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.075,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.1,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.125,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_crowbar_p1_targets_receive_rending_debuff_on_weapon_special = {
	format_values = {
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_crowbar_p1_targets_receive_rending_debuff_on_weapon_special",
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
		weapon_trait_bespoke_crowbar_p1_targets_receive_rending_debuff_on_weapon_special = {
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
templates.weapon_trait_bespoke_crowbar_p1_crit_chance_on_push = {
	format_values = {
		crit_chance = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_crowbar_p1_crit_chance_on_push",
				find_value_type = "trait_override",
				path = {
					"proc_stat_buffs",
					stat_buffs.melee_critical_strike_chance,
				},
			},
		},
		time = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_crowbar_p1_crit_chance_on_push",
				find_value_type = "buff_template",
				path = {
					"active_duration",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_crowbar_p1_crit_chance_on_push = {
			{
				proc_stat_buffs = {
					[stat_buffs.melee_critical_strike_chance] = 0.05,
				},
			},
			{
				proc_stat_buffs = {
					[stat_buffs.melee_critical_strike_chance] = 0.075,
				},
			},
			{
				proc_stat_buffs = {
					[stat_buffs.melee_critical_strike_chance] = 0.1,
				},
			},
			{
				proc_stat_buffs = {
					[stat_buffs.melee_critical_strike_chance] = 0.125,
				},
			},
		},
	},
}

return templates
