-- chunkname: @scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_powermaul_p2.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local stat_buffs = BuffSettings.stat_buffs
local proc_events = BuffSettings.proc_events
local templates = {}

table.make_unique(templates)

templates.weapon_trait_bespoke_powermaul_p2_toughness_recovery_on_chained_attacks = {
	format_values = {
		toughness = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powermaul_p2_toughness_recovery_on_chained_attacks",
				find_value_type = "trait_override",
				path = {
					"toughness_fixed_percentage",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_powermaul_p2_toughness_recovery_on_chained_attacks = {
			{
				toughness_fixed_percentage = 0.05,
			},
			{
				toughness_fixed_percentage = 0.06,
			},
			{
				toughness_fixed_percentage = 0.07,
			},
			{
				toughness_fixed_percentage = 0.08,
			},
		},
	},
}
templates.weapon_trait_bespoke_powermaul_p2_staggered_targets_receive_increased_damage_debuff = {
	format_values = {
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powermaul_p2_staggered_targets_receive_increased_damage_debuff",
				find_value_type = "trait_override",
				path = {
					"target_buff_data",
					"num_stacks_on_proc",
				},
			},
		},
		damage = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "increase_damage_received_while_staggered",
				find_value_type = "buff_template",
				path = {
					"conditional_stat_buffs",
					stat_buffs.damage_vs_staggered,
				},
			},
		},
		time = {
			format_type = "number",
			find_value = {
				buff_template_name = "increase_damage_received_while_staggered",
				find_value_type = "buff_template",
				path = {
					"duration",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_powermaul_p2_staggered_targets_receive_increased_damage_debuff = {
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
templates.weapon_trait_bespoke_powermaul_p2_staggered_targets_receive_increased_stagger_debuff = {
	format_values = {
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powermaul_p2_staggered_targets_receive_increased_stagger_debuff",
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
		weapon_trait_bespoke_powermaul_p2_staggered_targets_receive_increased_stagger_debuff = {
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
templates.weapon_trait_bespoke_powermaul_p2_extra_explosion_on_activated_attacks_on_armor = {
	format_values = {
		explosion_radius = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powermaul_p2_extra_explosion_on_activated_attacks_on_armor",
				find_value_type = "trait_override",
				path = {
					"conditional_stat_buffs",
					stat_buffs.explosion_radius_modifier,
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_powermaul_p2_extra_explosion_on_activated_attacks_on_armor = {
			{
				conditional_stat_buffs = {
					[stat_buffs.weapon_special_max_activations] = 1,
					[stat_buffs.explosion_radius_modifier] = 0.1,
				},
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.weapon_special_max_activations] = 1,
					[stat_buffs.explosion_radius_modifier] = 0.15,
				},
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.weapon_special_max_activations] = 1,
					[stat_buffs.explosion_radius_modifier] = 0.2,
				},
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.weapon_special_max_activations] = 1,
					[stat_buffs.explosion_radius_modifier] = 0.25,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_powermaul_p2_damage_bonus_vs_electrocuted = {
	format_values = {
		damage = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powermaul_p2_damage_bonus_vs_electrocuted",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.damage_vs_electrocuted,
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_powermaul_p2_damage_bonus_vs_electrocuted = {
			{
				stat_buffs = {
					[stat_buffs.damage_vs_electrocuted] = 0.1,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.damage_vs_electrocuted] = 0.15,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.damage_vs_electrocuted] = 0.2,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.damage_vs_electrocuted] = 0.25,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_powermaul_p2_stacking_increase_impact_on_hit = {
	format_values = {
		impact = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powermaul_p2_stacking_increase_impact_on_hit_parent",
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
				buff_template_name = "weapon_trait_bespoke_powermaul_p2_stacking_increase_impact_on_hit_parent",
				find_value_type = "trait_override",
				path = {
					"child_duration",
				},
			},
		},
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powermaul_p2_stacking_increase_impact_on_hit_child",
				find_value_type = "buff_template",
				path = {
					"max_stacks",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_powermaul_p2_stacking_increase_impact_on_hit_parent = {
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
templates.weapon_trait_bespoke_powermaul_p2_power_bonus_scaled_on_stamina = {
	format_values = {
		power_level = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powermaul_p2_power_bonus_scaled_on_stamina",
				find_value_type = "trait_override",
				path = {
					"conditional_stat_buffs",
					stat_buffs.melee_power_level_modifier,
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_powermaul_p2_power_bonus_scaled_on_stamina = {
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
templates.weapon_trait_bespoke_powermaul_p2_consecutive_melee_hits_same_target_increases_melee_power = {
	format_values = {
		power_level = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powermaul_p2_consecutive_melee_hits_same_target_increases_melee_power_parent",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.melee_power_level_modifier,
				},
			},
		},
		time = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powermaul_p2_consecutive_melee_hits_same_target_increases_melee_power_parent",
				find_value_type = "trait_override",
				path = {
					"child_duration",
				},
			},
		},
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powermaul_p2_consecutive_melee_hits_same_target_increases_melee_power_child",
				find_value_type = "buff_template",
				path = {
					"max_stacks",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_powermaul_p2_consecutive_melee_hits_same_target_increases_melee_power_parent = {
			{
				child_duration = 2,
				stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.04,
				},
			},
			{
				child_duration = 2,
				stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.06,
				},
			},
			{
				child_duration = 2,
				stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.08,
				},
			},
			{
				child_duration = 2,
				stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.1,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_powermaul_p2_targets_receive_rending_debuff = {
	format_values = {
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powermaul_p2_targets_receive_rending_debuff",
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
		weapon_trait_bespoke_powermaul_p2_targets_receive_rending_debuff = {
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
templates.weapon_trait_bespoke_powermaul_p2_negate_stagger_reduction_on_weakspot = {
	format_values = {
		stagger = {
			format_type = "percentage",
			num_decimals = 0,
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powermaul_p2_negate_stagger_reduction_on_weakspot",
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
				buff_template_name = "weapon_trait_bespoke_powermaul_p2_negate_stagger_reduction_on_weakspot",
				find_value_type = "buff_template",
				path = {
					"conditional_stat_buffs",
					stat_buffs.ranged_impact_modifier,
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_powermaul_p2_negate_stagger_reduction_on_weakspot = {
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
templates.weapon_trait_bespoke_powermaul_p2_block_has_chance_to_stun = {
	format_values = {
		power_level = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powermaul_p2_block_has_chance_to_stun",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.melee_power_level_modifier,
				},
			},
		},
		duration = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powermaul_p2_block_has_chance_to_stun",
				find_value_type = "buff_template",
				path = {
					"child_duration",
				},
			},
		},
		cooldown_duration = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powermaul_p2_block_has_chance_to_stun",
				find_value_type = "buff_template",
				path = {
					"child_duration",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_powermaul_p2_block_has_chance_to_stun = {
			{
				proc_events = {
					[proc_events.on_perfect_block] = 1,
				},
				stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.1,
				},
			},
			{
				proc_events = {
					[proc_events.on_perfect_block] = 1,
				},
				stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.15,
				},
			},
			{
				proc_events = {
					[proc_events.on_perfect_block] = 1,
				},
				stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.2,
				},
			},
			{
				proc_events = {
					[proc_events.on_perfect_block] = 1,
				},
				stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.25,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_powermaul_p2_stagger_bonus_damage = {
	format_values = {
		vs_stagger = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powermaul_p2_stagger_bonus_damage",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.damage_vs_staggered,
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_powermaul_p2_stagger_bonus_damage = {
			{
				stat_buffs = {
					[stat_buffs.damage_vs_staggered] = 0.05,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.damage_vs_staggered] = 0.1,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.damage_vs_staggered] = 0.15,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.damage_vs_staggered] = 0.2,
				},
			},
		},
	},
}

return templates
