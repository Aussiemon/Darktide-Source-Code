-- chunkname: @scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_ogryn_hammer_2h_p1.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local stat_buffs = BuffSettings.stat_buffs
local templates = {}

table.make_unique(templates)

templates.weapon_trait_bespoke_ogryn_hammer_2h_p1_stacking_increase_impact_on_hit = {
	format_values = {
		impact = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_hammer_2h_p1_stacking_increase_impact_on_hit_parent",
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
				buff_template_name = "weapon_trait_bespoke_ogryn_hammer_2h_p1_stacking_increase_impact_on_hit_parent",
				find_value_type = "trait_override",
				path = {
					"child_duration",
				},
			},
		},
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_hammer_2h_p1_stacking_increase_impact_on_hit_child",
				find_value_type = "buff_template",
				path = {
					"max_stacks",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_ogryn_hammer_2h_p1_stacking_increase_impact_on_hit_parent = {
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
templates.weapon_trait_bespoke_ogryn_hammer_2h_p1_stagger_bonus_damage = {
	format_values = {
		vs_stagger = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_hammer_2h_p1_stagger_bonus_damage",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.damage_vs_staggered,
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_ogryn_hammer_2h_p1_stagger_bonus_damage = {
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
templates.weapon_trait_bespoke_ogryn_hammer_2h_p1_power_bonus_scaled_on_stamina = {
	format_values = {
		power_level = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_hammer_2h_p1_power_bonus_scaled_on_stamina",
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
		weapon_trait_bespoke_ogryn_hammer_2h_p1_power_bonus_scaled_on_stamina = {
			{
				conditional_stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.03,
				},
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.04,
				},
			},
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
		},
	},
}
templates.weapon_trait_bespoke_ogryn_hammer_2h_p1_power_bonus_on_first_attack = {
	format_values = {
		power_level = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_hammer_2h_p1_power_bonus_on_first_attack",
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
				buff_template_name = "weapon_trait_bespoke_ogryn_hammer_2h_p1_power_bonus_on_first_attack",
				find_value_type = "trait_override",
				path = {
					"no_power_duration",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_ogryn_hammer_2h_p1_power_bonus_on_first_attack = {
			{
				no_power_duration = 2,
				conditional_switch_stat_buffs = {
					{
						[stat_buffs.melee_power_level_modifier] = 0.175,
					},
				},
			},
			{
				no_power_duration = 2,
				conditional_switch_stat_buffs = {
					{
						[stat_buffs.melee_power_level_modifier] = 0.2,
					},
				},
			},
			{
				no_power_duration = 2,
				conditional_switch_stat_buffs = {
					{
						[stat_buffs.melee_power_level_modifier] = 0.225,
					},
				},
			},
			{
				no_power_duration = 2,
				conditional_switch_stat_buffs = {
					{
						[stat_buffs.melee_power_level_modifier] = 0.25,
					},
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_ogryn_hammer_2h_p1_toughness_on_hit_based_on_charge_time = {
	format_values = {
		toughness = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_hammer_2h_p1_toughness_on_hit_based_on_charge_time",
				find_value_type = "trait_override",
				path = {
					"toughness_fixed_percentage",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_ogryn_hammer_2h_p1_toughness_on_hit_based_on_charge_time = {
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
templates.weapon_trait_bespoke_ogryn_hammer_2h_p1_hit_mass_consumption_reduction_on_kill = {
	format_values = {
		hit_mass = {
			format_type = "percentage",
			prefix = "-",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_hammer_2h_p1_hit_mass_consumption_reduction_on_kill",
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
				buff_template_name = "weapon_trait_bespoke_ogryn_hammer_2h_p1_hit_mass_consumption_reduction_on_kill",
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
		weapon_trait_bespoke_ogryn_hammer_2h_p1_hit_mass_consumption_reduction_on_kill = {
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
templates.weapon_trait_bespoke_ogryn_hammer_2h_p1_pass_past_armor_on_heavy_attack = {
	format_values = {
		damage = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_hammer_2h_p1_pass_past_armor_on_heavy_attack",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.melee_fully_charged_damage,
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_ogryn_hammer_2h_p1_pass_past_armor_on_heavy_attack = {
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
templates.weapon_trait_bespoke_ogryn_hammer_2h_p1_increased_weakspot_damage_on_push = {
	format_values = {
		damage = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_hammer_2h_p1_increased_weakspot_damage_on_push",
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
				buff_template_name = "weapon_trait_bespoke_ogryn_hammer_2h_p1_increased_weakspot_damage_on_push",
				find_value_type = "buff_template",
				path = {
					"active_duration",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_ogryn_hammer_2h_p1_increased_weakspot_damage_on_push = {
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

return templates
