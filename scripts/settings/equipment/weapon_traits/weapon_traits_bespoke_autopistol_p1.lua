-- chunkname: @scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_autopistol_p1.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local templates = {}

table.make_unique(templates)

local stat_buffs = BuffSettings.stat_buffs

templates.weapon_trait_bespoke_autopistol_p1_stacking_crit_bonus_on_continuous_fire = {
	format_values = {
		crit_chance = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_autopistol_p1_stacking_crit_bonus_on_continuous_fire",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.critical_strike_chance,
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
		weapon_trait_bespoke_autopistol_p1_stacking_crit_bonus_on_continuous_fire = {
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
			{
				stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.045,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.05,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_autopistol_p1_toughness_on_continuous_fire = {
	format_values = {
		toughness = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_autopistol_p1_toughness_on_continuous_fire",
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
		weapon_trait_bespoke_autopistol_p1_toughness_on_continuous_fire = {
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
templates.weapon_trait_bespoke_autopistol_p1_power_bonus_on_continuous_fire = {
	format_values = {
		power_level = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_autopistol_p1_power_bonus_on_continuous_fire",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.power_level_modifier,
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
		weapon_trait_bespoke_autopistol_p1_power_bonus_on_continuous_fire = {
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
templates.weapon_trait_bespoke_autopistol_p1_reload_speed_on_slide = {
	format_values = {
		reload_speed = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_autopistol_p1_reload_speed_on_slide_parent",
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
				buff_template_name = "weapon_trait_bespoke_autopistol_p1_reload_speed_on_slide_parent",
				find_value_type = "trait_override",
				path = {
					"child_duration",
				},
			},
		},
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_autopistol_p1_reload_speed_on_slide_child",
				find_value_type = "buff_template",
				path = {
					"max_stacks",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_autopistol_p1_reload_speed_on_slide_parent = {
			{
				child_duration = 2,
				stat_buffs = {
					[stat_buffs.reload_speed] = 0.07,
				},
			},
			{
				child_duration = 2,
				stat_buffs = {
					[stat_buffs.reload_speed] = 0.08,
				},
			},
			{
				child_duration = 2,
				stat_buffs = {
					[stat_buffs.reload_speed] = 0.09,
				},
			},
			{
				child_duration = 2,
				stat_buffs = {
					[stat_buffs.reload_speed] = 0.1,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_autopistol_p1_suppression_on_close_kill = {
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
		weapon_trait_bespoke_autopistol_p1_suppression_on_close_kill = {
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
templates.weapon_trait_bespoke_autopistol_p1_allow_flanking_and_increased_damage_when_flanking = {
	format_values = {
		damage = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_autopistol_p1_allow_flanking_and_increased_damage_when_flanking",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.flanking_damage,
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_autopistol_p1_allow_flanking_and_increased_damage_when_flanking = {
			{
				stat_buffs = {
					[stat_buffs.flanking_damage] = 0.325,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.flanking_damage] = 0.35,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.flanking_damage] = 0.375,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.flanking_damage] = 0.4,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_autopistol_p1_followup_shots_ranged_damage = {
	format_values = {
		damage = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_autopistol_p1_followup_shots_ranged_damage",
				find_value_type = "trait_override",
				path = {
					"conditional_stat_buffs",
					stat_buffs.ranged_damage,
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_autopistol_p1_followup_shots_ranged_damage = {
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
templates.weapon_trait_bespoke_autopistol_p1_recoil_reduction_and_suppression_increase_on_close_kills = {
	format_values = {
		recoil_reduction = {
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_autopistol_p1_recoil_reduction_and_suppression_increase_on_close_kills",
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
				buff_template_name = "weapon_trait_bespoke_autopistol_p1_recoil_reduction_and_suppression_increase_on_close_kills",
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
				buff_template_name = "weapon_trait_bespoke_autopistol_p1_recoil_reduction_and_suppression_increase_on_close_kills",
				find_value_type = "trait_override",
				path = {
					"proc_stat_buffs",
					stat_buffs.damage_vs_suppressed,
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_autopistol_p1_recoil_reduction_and_suppression_increase_on_close_kills = {
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
templates.weapon_trait_bespoke_autopistol_p1_stacking_power_bonus_on_staggering_enemies = {
	format_values = {
		power_level = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_autopistol_p1_stacking_power_bonus_on_staggering_enemies_parent",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.power_level_modifier,
				},
			},
		},
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_autopistol_p1_stacking_power_bonus_on_staggering_enemies_parent",
				find_value_type = "trait_override",
				path = {
					"max_stacks",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_autopistol_p1_stacking_power_bonus_on_staggering_enemies_parent = {
			{
				max_stacks = 5,
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.0425,
				},
			},
			{
				max_stacks = 5,
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.045,
				},
			},
			{
				max_stacks = 5,
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.0475,
				},
			},
			{
				max_stacks = 5,
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.05,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_autopistol_p1_hipfire_while_sprinting = {
	format_values = {
		weapon_spread = {
			format_type = "percentage",
			prefix = "-",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_autopistol_p1_hipfire_while_sprinting",
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
				buff_template_name = "weapon_trait_bespoke_autopistol_p1_hipfire_while_sprinting",
				find_value_type = "trait_override",
				path = {
					"conditional_stat_buffs",
					stat_buffs.damage_near,
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_autopistol_p1_hipfire_while_sprinting = {
			{
				stat_buffs = {
					[stat_buffs.spread_modifier] = -0.3,
				},
				conditional_stat_buffs = {
					[stat_buffs.damage_near] = 0.06,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.spread_modifier] = -0.3,
				},
				conditional_stat_buffs = {
					[stat_buffs.damage_near] = 0.09,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.spread_modifier] = -0.3,
				},
				conditional_stat_buffs = {
					[stat_buffs.damage_near] = 0.12,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.spread_modifier] = -0.3,
				},
				conditional_stat_buffs = {
					[stat_buffs.damage_near] = 0.15,
				},
			},
		},
	},
}

return templates
