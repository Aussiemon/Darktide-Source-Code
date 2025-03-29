-- chunkname: @scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_ogryn_pickaxe_2h_p1.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local stat_buffs = BuffSettings.stat_buffs
local templates = {}

table.make_unique(templates)

templates.weapon_trait_bespoke_ogryn_pickaxe_2h_p1_windup_increases_power = {
	format_values = {
		power_level = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_pickaxe_2h_p1_windup_increases_power_parent",
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
				buff_template_name = "weapon_trait_bespoke_ogryn_pickaxe_2h_p1_windup_increases_power_child",
				find_value_type = "buff_template",
				path = {
					"max_stacks",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_ogryn_pickaxe_2h_p1_windup_increases_power_parent = {
			{
				stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.05,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.1,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.15,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.2,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_ogryn_pickaxe_2h_p1_power_bonus_on_first_attack = {
	format_values = {
		power_level = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_pickaxe_2h_p1_power_bonus_on_first_attack",
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
				buff_template_name = "weapon_trait_bespoke_ogryn_pickaxe_2h_p1_power_bonus_on_first_attack",
				find_value_type = "trait_override",
				path = {
					"no_power_duration",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_ogryn_pickaxe_2h_p1_power_bonus_on_first_attack = {
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
templates.weapon_trait_bespoke_ogryn_pickaxe_2h_p1_toughness_recovery_on_chained_attacks = {
	format_values = {
		toughness = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_pickaxe_2h_p1_toughness_recovery_on_chained_attacks",
				find_value_type = "trait_override",
				path = {
					"toughness_fixed_percentage",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_ogryn_pickaxe_2h_p1_toughness_recovery_on_chained_attacks = {
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
templates.weapon_trait_bespoke_ogryn_pickaxe_2h_p1_power_bonus_scaled_on_stamina = {
	format_values = {
		power_level = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_pickaxe_2h_p1_power_bonus_scaled_on_stamina",
				find_value_type = "trait_override",
				path = {
					"conditional_stat_buffs",
					stat_buffs.melee_power_level_modifier,
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_ogryn_pickaxe_2h_p1_power_bonus_scaled_on_stamina = {
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
templates.weapon_trait_bespoke_ogryn_pickaxe_2h_p1_increase_power_on_kill = {
	format_values = {
		power_level = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_pickaxe_2h_p1_increase_power_on_kill_parent",
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
				buff_template_name = "weapon_trait_bespoke_ogryn_pickaxe_2h_p1_increase_power_on_kill_parent",
				find_value_type = "buff_template",
				path = {
					"child_duration",
				},
			},
		},
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_pickaxe_2h_p1_increase_power_on_kill_child",
				find_value_type = "buff_template",
				path = {
					"max_stacks",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_ogryn_pickaxe_2h_p1_increase_power_on_kill_parent = {
			{
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.05,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.06,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.07,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.08,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_ogryn_pickaxe_2h_p1_increase_power_on_hit = {
	format_values = {
		power_level = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_pickaxe_2h_p1_increase_power_on_hit_parent",
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
				buff_template_name = "weapon_trait_bespoke_ogryn_pickaxe_2h_p1_increase_power_on_hit_parent",
				find_value_type = "buff_template",
				path = {
					"child_duration",
				},
			},
		},
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_pickaxe_2h_p1_increase_power_on_hit_child",
				find_value_type = "buff_template",
				path = {
					"max_stacks",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_ogryn_pickaxe_2h_p1_increase_power_on_hit_parent = {
			{
				stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.035,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.04,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.045,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.05,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_ogryn_pickaxe_2h_p1_chained_hits_increases_melee_cleave = {
	format_values = {
		cleave = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_pickaxe_2h_p1_chained_hits_increases_melee_cleave_parent",
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
				buff_template_name = "weapon_trait_bespoke_ogryn_pickaxe_2h_p1_chained_hits_increases_melee_cleave_child",
				find_value_type = "buff_template",
				path = {
					"max_stacks",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_ogryn_pickaxe_2h_p1_chained_hits_increases_melee_cleave_parent = {
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
templates.weapon_trait_bespoke_ogryn_pickaxe_2h_p1_increase_power_on_weapon_special_hit = {
	format_values = {
		power_level = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_pickaxe_2h_p1_increase_power_on_weapon_special_hit_parent",
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
				buff_template_name = "weapon_trait_bespoke_ogryn_pickaxe_2h_p1_increase_power_on_weapon_special_hit_parent",
				find_value_type = "buff_template",
				path = {
					"child_duration",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_ogryn_pickaxe_2h_p1_increase_power_on_weapon_special_hit_parent = {
			{
				stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.12,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.16,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.2,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.24,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_ogryn_pickaxe_2h_p1_targets_receive_rending_debuff = {
	format_values = {
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_pickaxe_2h_p1_targets_receive_rending_debuff",
				find_value_type = "trait_override",
				path = {
					"target_buff_data",
					"num_stacks_on_proc",
				},
			},
		},
		rending = {
			format_type = "percentage",
			prefix = "+",
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
		weapon_trait_bespoke_ogryn_pickaxe_2h_p1_targets_receive_rending_debuff = {
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
templates.weapon_trait_bespoke_ogryn_pickaxe_2h_p1_toughness_on_hit_based_on_charge_time = {
	format_values = {
		toughness = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_pickaxe_2h_p1_toughness_on_hit_based_on_charge_time",
				find_value_type = "trait_override",
				path = {
					"toughness_fixed_percentage",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_ogryn_pickaxe_2h_p1_toughness_on_hit_based_on_charge_time = {
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
templates.weapon_trait_bespoke_ogryn_pickaxe_2h_p1_targets_receive_increased_damage_debuff_on_weapon_special = {
	format_values = {
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_pickaxe_2h_p1_targets_receive_increased_damage_debuff_on_weapon_special",
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
				buff_template_name = "increase_damage_taken",
				find_value_type = "buff_template",
				path = {
					"stat_buffs",
					stat_buffs.damage_taken_modifier,
				},
			},
		},
		max_stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "increase_damage_taken",
				find_value_type = "buff_template",
				path = {
					"max_stacks",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_ogryn_pickaxe_2h_p1_targets_receive_increased_damage_debuff_on_weapon_special = {
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

return templates
