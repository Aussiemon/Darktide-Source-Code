-- chunkname: @scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_combatsword_p1.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local templates = {}

table.make_unique(templates)

local stat_buffs = BuffSettings.stat_buffs

templates.weapon_trait_bespoke_combatsword_p1_chained_hits_increases_melee_cleave = {
	format_values = {
		cleave = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_combatsword_p1_chained_hits_increases_melee_cleave_parent",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.max_hit_mass_attack_modifier,
				},
			},
		},
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_combatsword_p1_chained_hits_increases_melee_cleave_child",
				find_value_type = "buff_template",
				path = {
					"max_stacks",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_combatsword_p1_chained_hits_increases_melee_cleave_parent = {
			{
				stat_buffs = {
					[stat_buffs.max_hit_mass_attack_modifier] = 0.25,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.max_hit_mass_attack_modifier] = 0.3,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.max_hit_mass_attack_modifier] = 0.35,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.max_hit_mass_attack_modifier] = 0.4,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_combatsword_p1_chained_hits_increases_crit_chance = {
	format_values = {
		crit_chance = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_combatsword_p1_chained_hits_increases_crit_chance_parent",
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
				buff_template_name = "weapon_trait_bespoke_combatsword_p1_chained_hits_increases_crit_chance_child",
				find_value_type = "buff_template",
				path = {
					"max_stacks",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_combatsword_p1_chained_hits_increases_crit_chance_parent = {
			{
				stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.025,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.03,
				},
			},
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
		},
	},
}
templates.weapon_trait_bespoke_combatsword_p1_increased_attack_cleave_on_multiple_hits = {
	format_values = {
		cleave = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_combatsword_p1_increased_attack_cleave_on_multiple_hits",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.max_hit_mass_attack_modifier,
				},
			},
		},
		multiple_hit = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_combatsword_p1_increased_attack_cleave_on_multiple_hits",
				find_value_type = "buff_template",
				path = {
					"buff_data",
					"required_num_hits",
				},
			},
		},
		time = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_combatsword_p1_increased_attack_cleave_on_multiple_hits",
				find_value_type = "buff_template",
				path = {
					"active_duration",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_combatsword_p1_increased_attack_cleave_on_multiple_hits = {
			{
				stat_buffs = {
					[stat_buffs.max_hit_mass_attack_modifier] = 1.4,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.max_hit_mass_attack_modifier] = 1.6,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.max_hit_mass_attack_modifier] = 1.8,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.max_hit_mass_attack_modifier] = 2,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_combatsword_p1_increased_melee_damage_on_multiple_hits = {
	format_values = {
		damage = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_combatsword_p1_increased_melee_damage_on_multiple_hits",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.melee_power_level_modifier,
				},
			},
		},
		multiple_hit = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_combatsword_p1_increased_melee_damage_on_multiple_hits",
				find_value_type = "buff_template",
				path = {
					"buff_data",
					"required_num_hits",
				},
			},
		},
		time = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_combatsword_p1_increased_melee_damage_on_multiple_hits",
				find_value_type = "trait_override",
				path = {
					"active_duration",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_combatsword_p1_increased_melee_damage_on_multiple_hits = {
			{
				active_duration = 3.5,
				stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.24,
				},
			},
			{
				active_duration = 3.5,
				stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.28,
				},
			},
			{
				active_duration = 3.5,
				stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.32,
				},
			},
			{
				active_duration = 3.5,
				stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.36,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_combatsword_p1_infinite_melee_cleave_on_crit = {
	format_values = {
		hit_mass = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_combatsword_p1_infinite_melee_cleave_on_crit",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.max_hit_mass_attack_modifier,
				},
			},
		},
		time = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_combatsword_p1_infinite_melee_cleave_on_crit",
				find_value_type = "buff_template",
				path = {
					"active_duration",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_combatsword_p1_infinite_melee_cleave_on_crit = {
			{
				stat_buffs = {
					[stat_buffs.max_hit_mass_attack_modifier] = 0.65,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.max_hit_mass_attack_modifier] = 0.7,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.max_hit_mass_attack_modifier] = 0.75,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.max_hit_mass_attack_modifier] = 0.8,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_combatsword_p1_stacking_increase_impact_on_hit = {
	format_values = {
		impact = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_combatsword_p1_stacking_increase_impact_on_hit_parent",
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
				buff_template_name = "weapon_trait_bespoke_combatsword_p1_stacking_increase_impact_on_hit_parent",
				find_value_type = "trait_override",
				path = {
					"child_duration",
				},
			},
		},
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_combatsword_p1_stacking_increase_impact_on_hit_child",
				find_value_type = "buff_template",
				path = {
					"max_stacks",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_combatsword_p1_stacking_increase_impact_on_hit_parent = {
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
templates.weapon_trait_bespoke_combatsword_p1_staggered_targets_receive_increased_stagger_debuff = {
	format_values = {
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_combatsword_p1_staggered_targets_receive_increased_stagger_debuff",
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
		weapon_trait_bespoke_combatsword_p1_staggered_targets_receive_increased_stagger_debuff = {
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
templates.weapon_trait_bespoke_combatsword_p1_staggered_targets_receive_increased_damage_debuff = {
	format_values = {
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_combatsword_p1_staggered_targets_receive_increased_damage_debuff",
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
		weapon_trait_bespoke_combatsword_p1_staggered_targets_receive_increased_damage_debuff = {
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
templates.weapon_trait_bespoke_combatsword_p1_increase_stagger_per_hit_in_sweep = {
	format_values = {
		impact = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_combatsword_p1_increase_stagger_per_hit_in_sweep_parent",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.melee_impact_modifier,
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_combatsword_p1_increase_stagger_per_hit_in_sweep_parent = {
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
templates.weapon_trait_bespoke_combatsword_p1_consecutive_hits_increases_stagger = {
	format_values = {
		impact = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_combatsword_p1_consecutive_hits_increases_stagger_parent",
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
				buff_template_name = "weapon_trait_bespoke_combatsword_p1_consecutive_hits_increases_stagger_parent",
				find_value_type = "buff_template",
				path = {
					"child_duration",
				},
			},
		},
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_combatsword_p1_consecutive_hits_increases_stagger_child",
				find_value_type = "buff_template",
				path = {
					"max_stacks",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_combatsword_p1_consecutive_hits_increases_stagger_parent = {
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

return templates
