-- chunkname: @scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_shotgun_p4.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local templates = {}

table.make_unique(templates)

local stat_buffs = BuffSettings.stat_buffs

templates.weapon_trait_bespoke_shotgun_p4_increase_power_on_close_kill = {
	format_values = {
		power_level = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_shotgun_p4_increase_power_on_close_kill_parent",
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
				buff_template_name = "weapon_trait_bespoke_shotgun_p4_increase_power_on_close_kill_parent",
				find_value_type = "trait_override",
				path = {
					"child_duration",
				},
			},
		},
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_shotgun_p4_increase_power_on_close_kill_child",
				find_value_type = "buff_template",
				path = {
					"max_stacks",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_shotgun_p4_increase_power_on_close_kill_parent = {
			{
				child_duration = 3.5,
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.05,
				},
			},
			{
				child_duration = 3.5,
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.055,
				},
			},
			{
				child_duration = 3.5,
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.06,
				},
			},
			{
				child_duration = 3.5,
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.065,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_shotgun_p4_increase_close_damage_on_close_kill = {
	format_values = {
		close_damage = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_shotgun_p4_increase_close_damage_on_close_kill_parent",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.damage_near,
				},
			},
		},
		time = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_shotgun_p4_increase_close_damage_on_close_kill_parent",
				find_value_type = "trait_override",
				path = {
					"child_duration",
				},
			},
		},
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_shotgun_p4_increase_close_damage_on_close_kill_child",
				find_value_type = "buff_template",
				path = {
					"max_stacks",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_shotgun_p4_increase_close_damage_on_close_kill_parent = {
			{
				child_duration = 3.5,
				stat_buffs = {
					[stat_buffs.damage_near] = 0.07,
				},
			},
			{
				child_duration = 3.5,
				stat_buffs = {
					[stat_buffs.damage_near] = 0.08,
				},
			},
			{
				child_duration = 3.5,
				stat_buffs = {
					[stat_buffs.damage_near] = 0.09,
				},
			},
			{
				child_duration = 3.5,
				stat_buffs = {
					[stat_buffs.damage_near] = 0.1,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_shotgun_p4_count_as_dodge_vs_ranged_on_close_kill = {
	format_values = {
		time = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_shotgun_p4_count_as_dodge_vs_ranged_on_close_kill",
				find_value_type = "trait_override",
				path = {
					"active_duration",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_shotgun_p4_count_as_dodge_vs_ranged_on_close_kill = {
			{
				active_duration = 0.7,
			},
			{
				active_duration = 0.8,
			},
			{
				active_duration = 0.9,
			},
			{
				active_duration = 1,
			},
		},
	},
}
templates.weapon_trait_bespoke_shotgun_p4_suppression_on_close_kill = {
	format_values = {
		range = {
			format_type = "string",
			find_value = {
				find_value_type = "rarity_value",
				trait_value = {
					"5m",
					"6m",
					"7m",
					"8m",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_shotgun_p4_suppression_on_close_kill = {
			{
				suppression_settings = {
					distance = 12,
					instant_aggro = true,
					suppression_falloff = false,
					suppression_value = 15,
				},
			},
			{
				suppression_settings = {
					distance = 12,
					instant_aggro = true,
					suppression_falloff = false,
					suppression_value = 20,
				},
			},
			{
				suppression_settings = {
					distance = 12,
					instant_aggro = true,
					suppression_falloff = false,
					suppression_value = 25,
				},
			},
			{
				suppression_settings = {
					distance = 12,
					instant_aggro = true,
					suppression_falloff = false,
					suppression_value = 30,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_shotgun_p4_power_bonus_on_hitting_single_enemy_with_all = {
	format_values = {
		power_level = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_shotgun_p4_power_bonus_on_hitting_single_enemy_with_all",
				find_value_type = "trait_override",
				path = {
					"proc_stat_buffs",
					stat_buffs.power_level_modifier,
				},
			},
		},
		time = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_shotgun_p4_power_bonus_on_hitting_single_enemy_with_all",
				find_value_type = "buff_template",
				path = {
					"active_duration",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_shotgun_p4_power_bonus_on_hitting_single_enemy_with_all = {
			{
				proc_stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.14,
				},
			},
			{
				proc_stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.16,
				},
			},
			{
				proc_stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.18,
				},
			},
			{
				proc_stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.2,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_shotgun_p4_bleed_on_crit = {
	format_values = {
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_shotgun_p4_bleed_on_crit",
				find_value_type = "trait_override",
				path = {
					"target_buff_data",
					"num_stacks_on_proc",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_shotgun_p4_bleed_on_crit = {
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
		},
	},
}
templates.weapon_trait_bespoke_shotgun_p4_crit_chance_on_hitting_multiple_with_one_shot = {
	format_values = {
		crit_chance = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_shotgun_p4_crit_chance_on_hitting_multiple_with_one_shot_parent",
				find_value_type = "trait_override",
				path = {
					"conditional_stat_buffs",
					stat_buffs.ranged_critical_strike_chance,
				},
			},
		},
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_shotgun_p4_crit_chance_on_hitting_multiple_with_one_shot_child",
				find_value_type = "buff_template",
				path = {
					"max_stacks",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_shotgun_p4_crit_chance_on_hitting_multiple_with_one_shot_parent = {
			{
				conditional_stat_buffs = {
					[stat_buffs.ranged_critical_strike_chance] = 0.06,
				},
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.ranged_critical_strike_chance] = 0.08,
				},
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.ranged_critical_strike_chance] = 0.1,
				},
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.ranged_critical_strike_chance] = 0.12,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_shotgun_p4_stagger_count_bonus_damage = {
	format_values = {
		damage = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_shotgun_p4_stagger_count_bonus_damage",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.stagger_count_damage,
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_shotgun_p4_stagger_count_bonus_damage = {
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
templates.weapon_trait_bespoke_shotgun_p4_cleave_on_crit = {
	format_values = {
		stagger = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_shotgun_p4_cleave_on_crit",
				find_value_type = "trait_override",
				path = {
					"conditional_stat_buffs",
					stat_buffs.ranged_impact_modifier,
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_shotgun_p4_cleave_on_crit = {
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
templates.weapon_trait_bespoke_shotgun_p4_toughness_on_continuous_fire = {
	format_values = {
		toughness = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_shotgun_p4_toughness_on_continuous_fire",
				find_value_type = "trait_override",
				path = {
					"toughness_fixed_percentage",
				},
			},
		},
		ammo = {
			format_type = "string",
			value = "10%",
		},
		stacks = {
			format_type = "string",
			value = "5",
		},
	},
	buffs = {
		weapon_trait_bespoke_shotgun_p4_toughness_on_continuous_fire = {
			{
				toughness_fixed_percentage = 0.01,
			},
			{
				toughness_fixed_percentage = 0.02,
			},
			{
				toughness_fixed_percentage = 0.03,
			},
			{
				toughness_fixed_percentage = 0.04,
			},
		},
	},
}
templates.weapon_trait_bespoke_shotgun_p4_reload_speed_on_slide = {
	format_values = {
		reload_speed = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_shotgun_p4_reload_speed_on_slide_parent",
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
				buff_template_name = "weapon_trait_bespoke_shotgun_p4_reload_speed_on_slide_parent",
				find_value_type = "trait_override",
				path = {
					"child_duration",
				},
			},
		},
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_shotgun_p4_reload_speed_on_slide_child",
				find_value_type = "buff_template",
				path = {
					"max_stacks",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_shotgun_p4_reload_speed_on_slide_parent = {
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
templates.weapon_trait_bespoke_shotgun_p4_hipfire_while_sprinting = {
	format_values = {
		weapon_spread = {
			format_type = "percentage",
			prefix = "",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_shotgun_p4_hipfire_while_sprinting",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.spread_modifier,
				},
			},
		},
		damage_near = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_shotgun_p4_hipfire_while_sprinting",
				find_value_type = "trait_override",
				path = {
					"conditional_stat_buffs",
					stat_buffs.damage_near,
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_shotgun_p4_hipfire_while_sprinting = {
			{
				stat_buffs = {
					[stat_buffs.spread_modifier] = -0.1,
				},
				conditional_stat_buffs = {
					[stat_buffs.damage_near] = 0.06,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.spread_modifier] = -0.1,
				},
				conditional_stat_buffs = {
					[stat_buffs.damage_near] = 0.09,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.spread_modifier] = -0.1,
				},
				conditional_stat_buffs = {
					[stat_buffs.damage_near] = 0.12,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.spread_modifier] = -0.1,
				},
				conditional_stat_buffs = {
					[stat_buffs.damage_near] = 0.15,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_shotgun_p4_toughness_on_close_range_kills = {
	format_values = {
		toughness = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_shotgun_p4_toughness_on_close_range_kills",
				find_value_type = "trait_override",
				path = {
					"toughness_fixed_percentage",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_shotgun_p4_toughness_on_close_range_kills = {
			{
				toughness_fixed_percentage = 0.045,
			},
			{
				toughness_fixed_percentage = 0.05,
			},
			{
				toughness_fixed_percentage = 0.055,
			},
			{
				toughness_fixed_percentage = 0.06,
			},
		},
	},
}
templates.weapon_trait_bespoke_shotgun_p4_stagger_bonus_damage = {
	format_values = {
		vs_stagger = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_shotgun_p4_stagger_bonus_damage",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.damage_vs_staggered,
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_shotgun_p4_stagger_bonus_damage = {
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
templates.weapon_trait_bespoke_shotgun_p4_damage_bonus_vs_electrocuted = {
	format_values = {
		damage = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_shotgun_p4_damage_bonus_vs_electrocuted",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.damage_vs_electrocuted,
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_shotgun_p4_damage_bonus_vs_electrocuted = {
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
templates.weapon_trait_bespoke_shotgun_p4_recoil_reduction_and_suppression_increase_on_close_kills = {
	format_values = {
		recoil_reduction = {
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_shotgun_p4_recoil_reduction_and_suppression_increase_on_close_kills",
				find_value_type = "trait_override",
				path = {
					"proc_stat_buffs",
					stat_buffs.recoil_modifier,
				},
			},
		},
		suppression = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_shotgun_p4_recoil_reduction_and_suppression_increase_on_close_kills",
				find_value_type = "trait_override",
				path = {
					"proc_stat_buffs",
					stat_buffs.suppression_dealt,
				},
			},
		},
		damage = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_shotgun_p4_recoil_reduction_and_suppression_increase_on_close_kills",
				find_value_type = "trait_override",
				path = {
					"proc_stat_buffs",
					stat_buffs.damage_vs_suppressed,
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_shotgun_p4_recoil_reduction_and_suppression_increase_on_close_kills = {
			{
				proc_stat_buffs = {
					[stat_buffs.recoil_modifier] = -0.28,
					[stat_buffs.suppression_dealt] = 0.28,
					[stat_buffs.damage_vs_suppressed] = 0.14,
				},
			},
			{
				proc_stat_buffs = {
					[stat_buffs.recoil_modifier] = -0.32,
					[stat_buffs.suppression_dealt] = 0.32,
					[stat_buffs.damage_vs_suppressed] = 0.16,
				},
			},
			{
				proc_stat_buffs = {
					[stat_buffs.recoil_modifier] = -0.36,
					[stat_buffs.suppression_dealt] = 0.36,
					[stat_buffs.damage_vs_suppressed] = 0.18,
				},
			},
			{
				proc_stat_buffs = {
					[stat_buffs.recoil_modifier] = -0.4,
					[stat_buffs.suppression_dealt] = 0.4,
					[stat_buffs.damage_vs_suppressed] = 0.2,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_shotgun_p4_followup_shots_ranged_weakspot_damage = {
	format_values = {
		damage = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_shotgun_p4_followup_shots_ranged_weakspot_damage",
				find_value_type = "trait_override",
				path = {
					"conditional_stat_buffs",
					stat_buffs.ranged_weakspot_damage,
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_shotgun_p4_followup_shots_ranged_weakspot_damage = {
			{
				conditional_stat_buffs = {
					[stat_buffs.ranged_weakspot_damage] = 0.35,
				},
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.ranged_weakspot_damage] = 0.4,
				},
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.ranged_weakspot_damage] = 0.45,
				},
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.ranged_weakspot_damage] = 0.5,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_shotgun_p4_followup_shots_ranged_damage = {
	format_values = {
		damage = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_shotgun_p4_followup_shots_ranged_damage",
				find_value_type = "trait_override",
				path = {
					"conditional_stat_buffs",
					stat_buffs.ranged_damage,
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_shotgun_p4_followup_shots_ranged_damage = {
			{
				conditional_stat_buffs = {
					[stat_buffs.ranged_damage] = 0.14,
				},
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.ranged_damage] = 0.16,
				},
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.ranged_damage] = 0.18,
				},
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.ranged_damage] = 0.2,
				},
			},
		},
	},
}

return templates
