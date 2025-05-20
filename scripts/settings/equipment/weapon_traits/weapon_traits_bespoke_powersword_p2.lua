-- chunkname: @scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_powersword_p2.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local ExplosionTemplates = require("scripts/settings/damage/explosion_templates")
local templates = {}

table.make_unique(templates)

local stat_buffs = BuffSettings.stat_buffs

templates.weapon_trait_bespoke_powersword_p2_power_bonus_scaled_on_heat = {
	format_values = {
		power = {
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powersword_p2_power_bonus_scaled_on_heat",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.power_level_modifier,
				},
			},
			value_manipulation = function (value)
				return value * 5
			end,
		},
	},
	buffs = {
		weapon_trait_bespoke_powersword_p2_power_bonus_scaled_on_heat = {
			{
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.015,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.02,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.03,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.04,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_powersword_p2_reduce_fixed_overheat_amount_parent = {
	format_values = {
		amount = {
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powersword_p2_reduce_fixed_overheat_amount_parent",
				find_value_type = "trait_override",
				path = {
					"overheat_reduction",
				},
			},
		},
		duration = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powersword_p2_reduce_fixed_overheat_amount_parent",
				find_value_type = "trait_override",
				path = {
					"duration",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_powersword_p2_reduce_fixed_overheat_amount_parent = {
			{
				duration = 3,
				overheat_reduction = 0.04,
			},
			{
				duration = 3,
				overheat_reduction = 0.06,
			},
			{
				duration = 3,
				overheat_reduction = 0.08,
			},
			{
				duration = 3,
				overheat_reduction = 0.1,
			},
		},
	},
}
templates.weapon_trait_bespoke_powersword_p2_chained_weakspot_hits_increase_finesse_and_reduce_overheat = {
	format_values = {
		buildup_amount = {
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powersword_p2_chained_weakspot_hits_increase_finesse_and_reduce_overheat_parent",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.overheat_amount,
				},
			},
		},
		damage = {
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powersword_p2_chained_weakspot_hits_increase_finesse_and_reduce_overheat_parent",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.finesse_modifier_bonus,
				},
			},
		},
		stacks = {
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powersword_p2_chained_weakspot_hits_increase_finesse_and_reduce_overheat_child",
				find_value_type = "buff_template",
				path = {
					"max_stacks",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_powersword_p2_chained_weakspot_hits_increase_finesse_and_reduce_overheat_parent = {
			{
				stat_buffs = {
					finesse_modifier_bonus = 0.01,
					overheat_amount = 0.97,
				},
			},
			{
				stat_buffs = {
					finesse_modifier_bonus = 0.02,
					overheat_amount = 0.96,
				},
			},
			{
				stat_buffs = {
					finesse_modifier_bonus = 0.03,
					overheat_amount = 0.95,
				},
			},
			{
				stat_buffs = {
					finesse_modifier_bonus = 0.04,
					overheat_amount = 0.94,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_powersword_p2_increased_melee_damage_on_multiple_hits = {
	format_values = {
		damage = {
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powersword_p2_increased_melee_damage_on_multiple_hits",
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
				buff_template_name = "weapon_trait_bespoke_powersword_p2_increased_melee_damage_on_multiple_hits",
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
				buff_template_name = "weapon_trait_bespoke_powersword_p2_increased_melee_damage_on_multiple_hits",
				find_value_type = "trait_override",
				path = {
					"active_duration",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_powersword_p2_increased_melee_damage_on_multiple_hits = {
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
templates.weapon_trait_bespoke_powersword_p2_chained_hits_increases_melee_cleave = {
	format_values = {
		cleave = {
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powersword_p2_chained_hits_increases_melee_cleave_parent",
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
				buff_template_name = "weapon_trait_bespoke_powersword_p2_chained_hits_increases_melee_cleave_child",
				find_value_type = "buff_template",
				path = {
					"max_stacks",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_powersword_p2_chained_hits_increases_melee_cleave_parent = {
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
templates.weapon_trait_bespoke_powersword_p2_infinite_melee_cleave_on_crit = {
	format_values = {
		hit_mass = {
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powersword_p2_infinite_melee_cleave_on_crit",
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
				buff_template_name = "weapon_trait_bespoke_powersword_p2_infinite_melee_cleave_on_crit",
				find_value_type = "buff_template",
				path = {
					"active_duration",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_powersword_p2_infinite_melee_cleave_on_crit = {
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
templates.weapon_trait_bespoke_bespoke_powersword_p2_regain_toughness_on_multiple_hits_by_weapon_special = {
	format_values = {
		toughness = {
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_bespoke_powersword_p2_regain_toughness_on_multiple_hits_by_weapon_special",
				find_value_type = "trait_override",
				path = {
					"toughness_fixed_percentage",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_bespoke_powersword_p2_regain_toughness_on_multiple_hits_by_weapon_special = {
			{
				toughness_fixed_percentage = 0.1,
			},
			{
				toughness_fixed_percentage = 0.12,
			},
			{
				toughness_fixed_percentage = 0.14,
			},
			{
				toughness_fixed_percentage = 0.16,
			},
		},
	},
}
templates.weapon_trait_bespoke_powersword_p2_slower_heat_buildup_on_perfect_block = {
	format_values = {
		heat_reduction = {
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powersword_p2_slower_heat_buildup_on_perfect_block",
				find_value_type = "trait_override",
				path = {
					"proc_stat_buffs",
					stat_buffs.overheat_over_time_amount,
				},
			},
		},
		heat_dissipation = {
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powersword_p2_slower_heat_buildup_on_perfect_block",
				find_value_type = "trait_override",
				path = {
					"proc_stat_buffs",
					stat_buffs.overheat_dissipation_multiplier,
				},
			},
		},
		time = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powersword_p2_slower_heat_buildup_on_perfect_block",
				find_value_type = "trait_override",
				path = {
					"active_duration",
				},
			},
		},
		interval = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powersword_p2_slower_heat_buildup_on_perfect_block",
				find_value_type = "trait_override",
				path = {
					"cooldown_duration",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_powersword_p2_slower_heat_buildup_on_perfect_block = {
			{
				active_duration = 5,
				cooldown_duration = 0,
				proc_stat_buffs = {
					[stat_buffs.overheat_over_time_amount] = 0.84,
					[stat_buffs.overheat_dissipation_multiplier] = 1.03,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 0,
				proc_stat_buffs = {
					[stat_buffs.overheat_over_time_amount] = 0.82,
					[stat_buffs.overheat_dissipation_multiplier] = 1.04,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 0,
				proc_stat_buffs = {
					[stat_buffs.overheat_over_time_amount] = 0.8,
					[stat_buffs.overheat_dissipation_multiplier] = 1.05,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 0,
				proc_stat_buffs = {
					[stat_buffs.overheat_over_time_amount] = 0.78,
					[stat_buffs.overheat_dissipation_multiplier] = 1.06,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_powersword_p2_attack_speed_on_perfect_block = {
	format_values = {
		attack_speed = {
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powersword_p2_attack_speed_on_perfect_block",
				find_value_type = "trait_override",
				path = {
					"proc_stat_buffs",
					stat_buffs.melee_attack_speed,
				},
			},
		},
		duration = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powersword_p2_attack_speed_on_perfect_block",
				find_value_type = "trait_override",
				path = {
					"active_duration",
				},
			},
		},
		interval = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powersword_p2_attack_speed_on_perfect_block",
				find_value_type = "trait_override",
				path = {
					"cooldown_duration",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_powersword_p2_attack_speed_on_perfect_block = {
			{
				active_duration = 5,
				cooldown_duration = 0,
				proc_stat_buffs = {
					[stat_buffs.melee_attack_speed] = 0.06,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 0,
				proc_stat_buffs = {
					[stat_buffs.melee_attack_speed] = 0.08,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 0,
				proc_stat_buffs = {
					[stat_buffs.melee_attack_speed] = 0.1,
				},
			},
			{
				active_duration = 5,
				cooldown_duration = 0,
				proc_stat_buffs = {
					[stat_buffs.melee_attack_speed] = 0.12,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_powersword_p2_explosion_on_overheat_lockout = {
	format_values = {
		attack_speed = {
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powersword_p2_explosion_on_overheat_lockout",
				find_value_type = "trait_override",
				path = {
					"overheat_reduction",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_powersword_p2_explosion_on_overheat_lockout = {
			{
				overheat_reduction = 0.1,
				proc_data = {
					explosion_template = ExplosionTemplates.trait_buff_powersword_2h_lockout_proc_explosion_1,
				},
			},
			{
				overheat_reduction = 0.15,
				proc_data = {
					explosion_template = ExplosionTemplates.trait_buff_powersword_2h_lockout_proc_explosion_2,
				},
			},
			{
				overheat_reduction = 0.2,
				proc_data = {
					explosion_template = ExplosionTemplates.trait_buff_powersword_2h_lockout_proc_explosion_3,
				},
			},
			{
				overheat_reduction = 0.25,
				proc_data = {
					explosion_template = ExplosionTemplates.trait_buff_powersword_2h_lockout_proc_explosion_4,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_powersword_p2_stacking_finesse_on_one_hit_kill = {
	format_values = {
		finesse = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powersword_p2_stacking_finesse_on_one_hit_kill_parent",
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
				buff_template_name = "weapon_trait_bespoke_powersword_p2_stacking_finesse_on_one_hit_kill_parent",
				find_value_type = "trait_override",
				path = {
					"max_stacks",
				},
			},
		},
		time = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powersword_p2_stacking_finesse_on_one_hit_kill_parent",
				find_value_type = "buff_template",
				path = {
					"child_duration",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_powersword_p2_stacking_finesse_on_one_hit_kill_parent = {
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

return templates
