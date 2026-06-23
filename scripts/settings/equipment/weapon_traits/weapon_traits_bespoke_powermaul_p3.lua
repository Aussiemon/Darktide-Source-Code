-- chunkname: @scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_powermaul_p3.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local templates = {}

table.make_unique(templates)

local stat_buffs = BuffSettings.stat_buffs
local proc_events = BuffSettings.proc_events

templates.weapon_trait_bespoke_powermaul_p3_block_has_chance_to_stun = {
	format_values = {
		power_level = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powermaul_p3_block_has_chance_to_stun",
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
				buff_template_name = "weapon_trait_bespoke_powermaul_p3_block_has_chance_to_stun",
				find_value_type = "buff_template",
				path = {
					"child_duration",
				},
			},
		},
		cooldown_duration = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powermaul_p3_block_has_chance_to_stun",
				find_value_type = "buff_template",
				path = {
					"child_duration",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_powermaul_p3_block_has_chance_to_stun = {
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
templates.weapon_trait_bespoke_powermaul_p3_stagger_bonus_damage = {
	format_values = {
		vs_stagger = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powermaul_p3_stagger_bonus_damage",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.damage_vs_staggered,
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_powermaul_p3_stagger_bonus_damage = {
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
templates.weapon_trait_bespoke_powermaul_p3_power_bonus_scaled_on_stamina = {
	format_values = {
		power_level = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powermaul_p3_power_bonus_scaled_on_stamina",
				find_value_type = "trait_override",
				path = {
					"conditional_stat_buffs",
					stat_buffs.melee_power_level_modifier,
				},
			},
			value_manipulation = function (value)
				return value * 5 * 100
			end,
		},
	},
	buffs = {
		weapon_trait_bespoke_powermaul_p3_power_bonus_scaled_on_stamina = {
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
templates.weapon_trait_bespoke_powermaul_p3_stacking_increase_impact_on_hit = {
	format_values = {
		impact = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powermaul_p3_stacking_increase_impact_on_hit_parent",
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
				buff_template_name = "weapon_trait_bespoke_powermaul_p3_stacking_increase_impact_on_hit_parent",
				find_value_type = "trait_override",
				path = {
					"child_duration",
				},
			},
		},
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powermaul_p3_stacking_increase_impact_on_hit_child",
				find_value_type = "buff_template",
				path = {
					"max_stacks",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_powermaul_p3_stacking_increase_impact_on_hit_parent = {
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
templates.weapon_trait_bespoke_powermaul_p3_staggering_hits_has_chance_to_stun = {
	format_values = {
		chance = {
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powermaul_p3_staggering_hits_has_chance_to_stun",
				find_value_type = "trait_override",
				path = {
					"proc_events",
					proc_events.on_hit,
				},
			},
		},
		cooldown = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powermaul_p3_staggering_hits_has_chance_to_stun",
				find_value_type = "trait_override",
				path = {
					"cooldown_duration",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_powermaul_p3_staggering_hits_has_chance_to_stun = {
			{
				cooldown_duration = 5,
				proc_events = {
					[proc_events.on_hit] = 0.1,
				},
			},
			{
				cooldown_duration = 4.5,
				proc_events = {
					[proc_events.on_hit] = 0.15,
				},
			},
			{
				cooldown_duration = 4,
				proc_events = {
					[proc_events.on_hit] = 0.2,
				},
			},
			{
				cooldown_duration = 3.5,
				proc_events = {
					[proc_events.on_hit] = 0.25,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_powermaul_p3_targets_receive_rending_debuff = {
	format_values = {
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powermaul_p3_targets_receive_rending_debuff",
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
		weapon_trait_bespoke_powermaul_p3_targets_receive_rending_debuff = {
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
templates.weapon_trait_bespoke_powermaul_p3_toughness_recovery_on_chained_attacks = {
	format_values = {
		toughness = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powermaul_p3_toughness_recovery_on_chained_attacks",
				find_value_type = "trait_override",
				path = {
					"toughness_fixed_percentage",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_powermaul_p3_toughness_recovery_on_chained_attacks = {
			{
				toughness_fixed_percentage = 0.04,
			},
			{
				toughness_fixed_percentage = 0.05,
			},
			{
				toughness_fixed_percentage = 0.06,
			},
			{
				toughness_fixed_percentage = 0.07,
			},
		},
	},
}
templates.weapon_trait_bespoke_powermaul_p3_enhanced_arc_jumps_angle = {
	format_values = {
		angle = {
			format_type = "number",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powermaul_p3_enhanced_arc_jumps_angle",
				find_value_type = "trait_override",
				path = {
					"conditional_stat_buffs",
					"chain_lightning_powermaul_max_angle",
				},
			},
			value_manipulation = function (value)
				return math.floor(math.radians_to_degrees(value))
			end,
		},
		jumps = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powermaul_p3_enhanced_arc_jumps_angle",
				find_value_type = "trait_override",
				path = {
					"conditional_stat_buffs",
					"chain_lightning_powermaul_max_jumps",
				},
			},
		},
		radius = {
			format_type = "number",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powermaul_p3_enhanced_arc_jumps_angle",
				find_value_type = "trait_override",
				path = {
					"conditional_stat_buffs",
					"chain_lightning_powermaul_max_radius",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_powermaul_p3_enhanced_arc_jumps_angle = {
			{
				conditional_stat_buffs = {
					[stat_buffs.chain_lightning_powermaul_max_angle] = math.degrees_to_radians(5),
					[stat_buffs.chain_lightning_powermaul_max_jumps] = 1,
					[stat_buffs.chain_lightning_powermaul_max_radius] = 0.5,
				},
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.chain_lightning_powermaul_max_angle] = math.degrees_to_radians(7.5),
					[stat_buffs.chain_lightning_powermaul_max_jumps] = 1,
					[stat_buffs.chain_lightning_powermaul_max_radius] = 1,
				},
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.chain_lightning_powermaul_max_angle] = math.degrees_to_radians(10),
					[stat_buffs.chain_lightning_powermaul_max_jumps] = 2,
					[stat_buffs.chain_lightning_powermaul_max_radius] = 1.5,
				},
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.chain_lightning_powermaul_max_angle] = math.degrees_to_radians(12.5),
					[stat_buffs.chain_lightning_powermaul_max_jumps] = 2,
					[stat_buffs.chain_lightning_powermaul_max_radius] = 2,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_powermaul_p3_arc_has_killing_blow_chance = {
	format_values = {
		proc_chance = {
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powermaul_p3_arc_has_killing_blow_chance",
				find_value_type = "trait_override",
				path = {
					"target_buff_data",
					"killing_blow_chance",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_powermaul_p3_arc_has_killing_blow_chance = {
			{
				target_buff_data = {
					killing_blow_chance = 0.05,
				},
			},
			{
				target_buff_data = {
					killing_blow_chance = 0.075,
				},
			},
			{
				target_buff_data = {
					killing_blow_chance = 0.1,
				},
			},
			{
				target_buff_data = {
					killing_blow_chance = 0.125,
				},
			},
		},
	},
}

return templates
