-- chunkname: @scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_transonic_sword_transonic_knife_p1.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local templates = {}

table.make_unique(templates)

local stat_buffs = BuffSettings.stat_buffs

templates.weapon_trait_bespoke_transonic_sword_transonic_knife_p1_chained_hits_increases_crit_chance = {
	format_values = {
		crit_chance = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_transonic_sword_transonic_knife_p1_chained_hits_increases_crit_chance_parent",
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
				buff_template_name = "weapon_trait_bespoke_transonic_sword_transonic_knife_p1_chained_hits_increases_crit_chance_child",
				find_value_type = "buff_template",
				path = {
					"max_stacks",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_transonic_sword_transonic_knife_p1_chained_hits_increases_crit_chance_parent = {
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
templates.weapon_trait_bespoke_transonic_sword_transonic_knife_p1_dodge_grants_critical_strike_chance = {
	format_values = {
		crit_chance = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_transonic_sword_transonic_knife_p1_dodge_grants_critical_strike_chance",
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
				buff_template_name = "weapon_trait_bespoke_transonic_sword_transonic_knife_p1_dodge_grants_critical_strike_chance",
				find_value_type = "buff_template",
				path = {
					"active_duration",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_transonic_sword_transonic_knife_p1_dodge_grants_critical_strike_chance = {
			{
				proc_stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.1,
				},
			},
			{
				proc_stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.12,
				},
			},
			{
				proc_stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.14,
				},
			},
			{
				proc_stat_buffs = {
					[stat_buffs.critical_strike_chance] = 0.16,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_transonic_sword_transonic_knife_p1_dodge_grants_finesse_bonus = {
	format_values = {
		damage = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_transonic_sword_transonic_knife_p1_dodge_grants_finesse_bonus",
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
				buff_template_name = "weapon_trait_bespoke_transonic_sword_transonic_knife_p1_dodge_grants_finesse_bonus",
				find_value_type = "trait_override",
				path = {
					"active_duration",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_transonic_sword_transonic_knife_p1_dodge_grants_finesse_bonus = {
			{
				active_duration = 2,
				proc_stat_buffs = {
					[stat_buffs.finesse_modifier_bonus] = 0.3,
				},
			},
			{
				active_duration = 2,
				proc_stat_buffs = {
					[stat_buffs.finesse_modifier_bonus] = 0.35,
				},
			},
			{
				active_duration = 2,
				proc_stat_buffs = {
					[stat_buffs.finesse_modifier_bonus] = 0.4,
				},
			},
			{
				active_duration = 2,
				proc_stat_buffs = {
					[stat_buffs.finesse_modifier_bonus] = 0.45,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_transonic_sword_transonic_knife_p1_elite_kills_grants_stackable_melee_power = {
	format_values = {
		power_level = {
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_transonic_sword_transonic_knife_p1_elite_kills_grants_stackable_melee_power_parent",
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
				buff_template_name = "weapon_trait_bespoke_transonic_sword_transonic_knife_p1_elite_kills_grants_stackable_melee_power_parent",
				find_value_type = "buff_template",
				path = {
					"child_duration",
				},
			},
		},
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_transonic_sword_transonic_knife_p1_elite_kills_grants_stackable_melee_power_child",
				find_value_type = "buff_template",
				path = {
					"max_stacks",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_transonic_sword_transonic_knife_p1_elite_kills_grants_stackable_melee_power_parent = {
			{
				stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.04,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.06,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.08,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.1,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_transonic_sword_transonic_knife_p1_increased_attack_cleave_on_multiple_hits = {
	format_values = {
		cleave = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_transonic_sword_transonic_knife_p1_increased_attack_cleave_on_multiple_hits",
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
				buff_template_name = "weapon_trait_bespoke_transonic_sword_transonic_knife_p1_increased_attack_cleave_on_multiple_hits",
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
				buff_template_name = "weapon_trait_bespoke_transonic_sword_transonic_knife_p1_increased_attack_cleave_on_multiple_hits",
				find_value_type = "buff_template",
				path = {
					"active_duration",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_transonic_sword_transonic_knife_p1_increased_attack_cleave_on_multiple_hits = {
			{
				stat_buffs = {
					[stat_buffs.max_hit_mass_attack_modifier] = 1.2,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.max_hit_mass_attack_modifier] = 1.3,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.max_hit_mass_attack_modifier] = 1.4,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.max_hit_mass_attack_modifier] = 1.5,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_transonic_sword_transonic_knife_p1_increased_melee_damage_on_multiple_hits = {
	format_values = {
		damage = {
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_transonic_sword_transonic_knife_p1_increased_melee_damage_on_multiple_hits",
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
				buff_template_name = "weapon_trait_bespoke_transonic_sword_transonic_knife_p1_increased_melee_damage_on_multiple_hits",
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
				buff_template_name = "weapon_trait_bespoke_transonic_sword_transonic_knife_p1_increased_melee_damage_on_multiple_hits",
				find_value_type = "trait_override",
				path = {
					"active_duration",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_transonic_sword_transonic_knife_p1_increased_melee_damage_on_multiple_hits = {
			{
				active_duration = 3.5,
				stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.09,
				},
			},
			{
				active_duration = 3.5,
				stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.12,
				},
			},
			{
				active_duration = 3.5,
				stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.15,
				},
			},
			{
				active_duration = 3.5,
				stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.18,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_transonic_sword_transonic_knife_p1_pass_past_armor_on_crit = {
	format_values = {
		crit_damage = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_transonic_sword_transonic_knife_p1_pass_past_armor_on_crit",
				find_value_type = "trait_override",
				path = {
					"conditional_stat_buffs",
					stat_buffs.melee_critical_strike_damage,
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_transonic_sword_transonic_knife_p1_pass_past_armor_on_crit = {
			{
				conditional_stat_buffs = {
					[stat_buffs.melee_critical_strike_damage] = 0.025,
				},
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.melee_critical_strike_damage] = 0.05,
				},
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.melee_critical_strike_damage] = 0.075,
				},
			},
			{
				conditional_stat_buffs = {
					[stat_buffs.melee_critical_strike_damage] = 0.1,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_transonic_sword_transonic_knife_p1_rending_on_multiple_hits = {
	format_values = {
		rending = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_transonic_sword_transonic_knife_p1_rending_on_multiple_hits_parent",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.melee_rending_multiplier,
				},
			},
		},
		time = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_transonic_sword_transonic_knife_p1_rending_on_multiple_hits_parent",
				find_value_type = "trait_override",
				path = {
					"child_duration",
				},
			},
		},
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_transonic_sword_transonic_knife_p1_rending_on_multiple_hits_child",
				find_value_type = "buff_template",
				path = {
					"max_stacks",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_transonic_sword_transonic_knife_p1_rending_on_multiple_hits_parent = {
			{
				child_duration = 2.5,
				buff_data = {
					required_num_hits = 2,
				},
				stat_buffs = {
					[stat_buffs.melee_rending_multiplier] = 0.04,
				},
			},
			{
				child_duration = 3,
				buff_data = {
					required_num_hits = 2,
				},
				stat_buffs = {
					[stat_buffs.melee_rending_multiplier] = 0.05,
				},
			},
			{
				child_duration = 3.5,
				buff_data = {
					required_num_hits = 2,
				},
				stat_buffs = {
					[stat_buffs.melee_rending_multiplier] = 0.06,
				},
			},
			{
				child_duration = 4,
				buff_data = {
					required_num_hits = 2,
				},
				stat_buffs = {
					[stat_buffs.melee_rending_multiplier] = 0.07,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_transonic_sword_transonic_knife_p1_increased_power_on_weapon_special_follow_up_hits = {
	format_values = {
		power = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_transonic_sword_transonic_knife_p1_increased_power_on_weapon_special_follow_up_hits",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.melee_power_level_modifier,
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_transonic_sword_transonic_knife_p1_increased_power_on_weapon_special_follow_up_hits = {
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
			{
				stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.25,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.melee_power_level_modifier] = 0.3,
				},
			},
		},
	},
}

return templates
