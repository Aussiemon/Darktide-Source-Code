-- chunkname: @scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_combatsword_p3.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local templates = {}

table.make_unique(templates)

local stat_buffs = BuffSettings.stat_buffs

templates.weapon_trait_bespoke_combatsword_p3_chained_hits_increases_crit_chance = {
	format_values = {
		crit_chance = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_combatsword_p3_chained_hits_increases_crit_chance_parent",
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
				buff_template_name = "weapon_trait_bespoke_combatsword_p3_chained_hits_increases_crit_chance_child",
				find_value_type = "buff_template",
				path = {
					"max_stacks",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_combatsword_p3_chained_hits_increases_crit_chance_parent = {
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
templates.weapon_trait_bespoke_combatsword_p3_stacking_rending_on_weakspot = {
	format_values = {
		rending = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_combatsword_p3_stacking_rending_on_weakspot_parent",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.rending_multiplier,
				},
			},
		},
		time = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_combatsword_p3_stacking_rending_on_weakspot_parent",
				find_value_type = "buff_template",
				path = {
					"child_duration",
				},
			},
		},
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_combatsword_p3_stacking_rending_on_weakspot_parent",
				find_value_type = "trait_override",
				path = {
					"max_stacks",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_combatsword_p3_stacking_rending_on_weakspot_parent = {
			{
				max_stacks = 5,
				stat_buffs = {
					[stat_buffs.rending_multiplier] = 0.12,
				},
			},
			{
				max_stacks = 5,
				stat_buffs = {
					[stat_buffs.rending_multiplier] = 0.16,
				},
			},
			{
				max_stacks = 5,
				stat_buffs = {
					[stat_buffs.rending_multiplier] = 0.2,
				},
			},
			{
				max_stacks = 5,
				stat_buffs = {
					[stat_buffs.rending_multiplier] = 0.24,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_combatsword_p3_dodge_grants_finesse_bonus = {
	format_values = {
		damage = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_combatsword_p3_dodge_grants_finesse_bonus",
				find_value_type = "trait_override",
				path = {
					"proc_stat_buffs",
					stat_buffs.finesse_modifier_bonus,
				},
			},
		},
		time = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_combatsword_p3_dodge_grants_finesse_bonus",
				find_value_type = "trait_override",
				path = {
					"active_duration",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_combatsword_p3_dodge_grants_finesse_bonus = {
			{
				active_duration = 2,
				proc_stat_buffs = {
					[stat_buffs.finesse_modifier_bonus] = 0.45,
				},
			},
			{
				active_duration = 2,
				proc_stat_buffs = {
					[stat_buffs.finesse_modifier_bonus] = 0.5,
				},
			},
			{
				active_duration = 2,
				proc_stat_buffs = {
					[stat_buffs.finesse_modifier_bonus] = 0.55,
				},
			},
			{
				active_duration = 2,
				proc_stat_buffs = {
					[stat_buffs.finesse_modifier_bonus] = 0.6,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_combatsword_p3_dodge_grants_critical_strike_chance = {
	format_values = {
		crit_chance = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_combatsword_p3_dodge_grants_critical_strike_chance",
				find_value_type = "trait_override",
				path = {
					"proc_stat_buffs",
					stat_buffs.critical_strike_chance,
				},
			},
		},
		time = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_combatsword_p3_dodge_grants_critical_strike_chance",
				find_value_type = "buff_template",
				path = {
					"active_duration",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_combatsword_p3_dodge_grants_critical_strike_chance = {
			{
				proc_stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.125,
				},
			},
			{
				proc_stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.15,
				},
			},
			{
				proc_stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.175,
				},
			},
			{
				proc_stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.2,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_combatsword_p3_increased_melee_damage_on_multiple_hits = {
	format_values = {
		damage = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_combatsword_p3_increased_melee_damage_on_multiple_hits",
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
				buff_template_name = "weapon_trait_bespoke_combatsword_p3_increased_melee_damage_on_multiple_hits",
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
				buff_template_name = "weapon_trait_bespoke_combatsword_p3_increased_melee_damage_on_multiple_hits",
				find_value_type = "trait_override",
				path = {
					"active_duration",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_combatsword_p3_increased_melee_damage_on_multiple_hits = {
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
templates.weapon_trait_bespoke_combatsword_p3_windup_increases_power = {
	format_values = {
		power_level = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_combatsword_p3_windup_increases_power_parent",
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
				buff_template_name = "weapon_trait_bespoke_combatsword_p3_windup_increases_power_child",
				find_value_type = "buff_template",
				path = {
					"max_stacks",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_combatsword_p3_windup_increases_power_parent = {
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
templates.weapon_trait_bespoke_combatsword_p3_consecutive_melee_hits_same_target_increases_melee_power = {
	format_values = {
		power_level = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_combatsword_p3_consecutive_melee_hits_same_target_increases_melee_power_parent",
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
				buff_template_name = "weapon_trait_bespoke_combatsword_p3_consecutive_melee_hits_same_target_increases_melee_power_parent",
				find_value_type = "trait_override",
				path = {
					"child_duration",
				},
			},
		},
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_combatsword_p3_consecutive_melee_hits_same_target_increases_melee_power_child",
				find_value_type = "buff_template",
				path = {
					"max_stacks",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_combatsword_p3_consecutive_melee_hits_same_target_increases_melee_power_parent = {
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
templates.weapon_trait_bespoke_combatsword_p3_weakspot_hit_resets_dodge_count = {
	format_values = {
		melee_weakspot_damage = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_combatsword_p3_weakspot_hit_resets_dodge_count",
				find_value_type = "trait_override",
				path = {
					"conditional_stat_buffs",
					stat_buffs.melee_weakspot_damage,
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_combatsword_p3_weakspot_hit_resets_dodge_count = {
			{
				conditional_stat_buffs = {
					[stat_buffs.melee_weakspot_damage] = 0.025,
				},
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.melee_weakspot_damage] = 0.05,
				},
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.melee_weakspot_damage] = 0.075,
				},
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.melee_weakspot_damage] = 0.1,
				},
			},
		},
	},
}

return templates
