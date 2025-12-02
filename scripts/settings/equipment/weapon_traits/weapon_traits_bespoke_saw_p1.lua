-- chunkname: @scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_saw_p1.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local templates = {}

table.make_unique(templates)

local stat_buffs = BuffSettings.stat_buffs

templates.weapon_trait_bespoke_saw_p1_chained_hits_increases_power = {
	format_values = {
		power_level = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_saw_p1_chained_hits_increases_power_parent",
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
				buff_template_name = "weapon_trait_bespoke_saw_p1_chained_hits_increases_power_child",
				find_value_type = "buff_template",
				path = {
					"max_stacks",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_saw_p1_chained_hits_increases_power_parent = {
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
templates.weapon_trait_bespoke_saw_p1_chained_hits_increases_crit_chance = {
	format_values = {
		crit_chance = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_saw_p1_chained_hits_increases_crit_chance_parent",
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
				buff_template_name = "weapon_trait_bespoke_saw_p1_chained_hits_increases_crit_chance_child",
				find_value_type = "buff_template",
				path = {
					"max_stacks",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_saw_p1_chained_hits_increases_crit_chance_parent = {
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
templates.weapon_trait_bespoke_saw_p1_stacking_finesse_on_one_hit_kill = {
	format_values = {
		finesse = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_saw_p1_stacking_finesse_on_one_hit_kill_parent",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.melee_finesse_modifier_bonus,
				},
			},
		},
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_saw_p1_stacking_finesse_on_one_hit_kill_parent",
				find_value_type = "trait_override",
				path = {
					"max_stacks",
				},
			},
		},
		time = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_saw_p1_stacking_finesse_on_one_hit_kill_parent",
				find_value_type = "buff_template",
				path = {
					"child_duration",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_saw_p1_stacking_finesse_on_one_hit_kill_parent = {
			{
				max_stacks = 5,
				stat_buffs = {
					[stat_buffs.melee_finesse_modifier_bonus] = 0.18,
				},
			},
			{
				max_stacks = 5,
				stat_buffs = {
					[stat_buffs.melee_finesse_modifier_bonus] = 0.2,
				},
			},
			{
				max_stacks = 5,
				stat_buffs = {
					[stat_buffs.melee_finesse_modifier_bonus] = 0.22,
				},
			},
			{
				max_stacks = 5,
				stat_buffs = {
					[stat_buffs.melee_finesse_modifier_bonus] = 0.24,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_saw_p1_power_bonus_on_first_attack = {
	format_values = {
		power_level = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_saw_p1_power_bonus_on_first_attack",
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
				buff_template_name = "weapon_trait_bespoke_saw_p1_power_bonus_on_first_attack",
				find_value_type = "trait_override",
				path = {
					"no_power_duration",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_saw_p1_power_bonus_on_first_attack = {
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
templates.weapon_trait_bespoke_saw_p1_consecutive_melee_hits_same_target_increases_melee_power = {
	format_values = {
		power_level = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_saw_p1_consecutive_melee_hits_same_target_increases_melee_power_parent",
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
				buff_template_name = "weapon_trait_bespoke_saw_p1_consecutive_melee_hits_same_target_increases_melee_power_parent",
				find_value_type = "trait_override",
				path = {
					"child_duration",
				},
			},
		},
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_saw_p1_consecutive_melee_hits_same_target_increases_melee_power_child",
				find_value_type = "buff_template",
				path = {
					"max_stacks",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_saw_p1_consecutive_melee_hits_same_target_increases_melee_power_parent = {
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
templates.weapon_trait_bespoke_saw_p1_bleed_on_crit = {
	format_values = {
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_saw_p1_bleed_on_crit",
				find_value_type = "trait_override",
				path = {
					"target_buff_data",
					"num_stacks_on_proc",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_saw_p1_bleed_on_crit = {
			{
				target_buff_data = {
					num_stacks_on_proc = 5,
				},
			},
			{
				target_buff_data = {
					num_stacks_on_proc = 6,
				},
			},
			{
				target_buff_data = {
					num_stacks_on_proc = 7,
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
templates.weapon_trait_bespoke_saw_p1_bleed_on_non_weakspot_hit = {
	format_values = {
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_saw_p1_bleed_on_non_weakspot_hit",
				find_value_type = "trait_override",
				path = {
					"target_buff_data",
					"num_stacks_on_proc",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_saw_p1_bleed_on_non_weakspot_hit = {
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
templates.weapon_trait_bespoke_saw_p1_increased_weakspot_damage_against_toxin_status = {
	format_values = {
		damage = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_saw_p1_increased_weakspot_damage_against_toxin_status",
				find_value_type = "trait_override",
				path = {
					"conditional_stat_buffs",
					stat_buffs.melee_weakspot_damage_vs_toxin_status,
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_saw_p1_increased_weakspot_damage_against_toxin_status = {
			{
				conditional_stat_buffs = {
					[stat_buffs.melee_weakspot_damage_vs_toxin_status] = 0.525,
				},
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.melee_weakspot_damage_vs_toxin_status] = 0.55,
				},
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.melee_weakspot_damage_vs_toxin_status] = 0.575,
				},
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.melee_weakspot_damage_vs_toxin_status] = 0.6,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_saw_p1_hit_mass_consumption_reduction_on_kill = {
	format_values = {
		hit_mass = {
			format_type = "percentage",
			prefix = "-",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_saw_p1_hit_mass_consumption_reduction_on_kill",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.consumed_hit_mass_modifier,
				},
			},
			value_manipulation = function (value)
				return (1 - value) * 100
			end,
		},
		time = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_saw_p1_hit_mass_consumption_reduction_on_kill",
				find_value_type = "buff_template",
				path = {
					"active_duration",
				},
			},
		},
		stacks = {
			format_type = "string",
			value = "5",
		},
	},
	buffs = {
		weapon_trait_bespoke_saw_p1_hit_mass_consumption_reduction_on_kill = {
			{
				stat_buffs = {
					[stat_buffs.consumed_hit_mass_modifier] = 0.7,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.consumed_hit_mass_modifier] = 0.6,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.consumed_hit_mass_modifier] = 0.5,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.consumed_hit_mass_modifier] = 0.4,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_saw_p1_chained_hits_increases_melee_cleave = {
	format_values = {
		cleave = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_saw_p1_chained_hits_increases_melee_cleave_parent",
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
				buff_template_name = "weapon_trait_bespoke_saw_p1_chained_hits_increases_melee_cleave_child",
				find_value_type = "buff_template",
				path = {
					"max_stacks",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_saw_p1_chained_hits_increases_melee_cleave_parent = {
			{
				stat_buffs = {
					[stat_buffs.max_hit_mass_attack_modifier] = 0.1,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.max_hit_mass_attack_modifier] = 0.15,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.max_hit_mass_attack_modifier] = 0.2,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.max_hit_mass_attack_modifier] = 0.25,
				},
			},
		},
	},
}

return templates
