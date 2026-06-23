-- chunkname: @scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_powersword_p3.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local templates = {}

table.make_unique(templates)

local stat_buffs = BuffSettings.stat_buffs

templates.weapon_trait_bespoke_powersword_p3_targets_receive_rending_debuff_on_weapon_special_attacks = {
	format_values = {
		rend = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powersword_p3_targets_receive_rending_debuff_on_weapon_special_attacks",
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
		weapon_trait_bespoke_powersword_p3_targets_receive_rending_debuff_on_weapon_special_attacks = {
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
templates.weapon_trait_bespoke_powersword_p3_elite_kills_grants_stackable_melee_power = {
	format_values = {
		power_level = {
			format_type = "percentage",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powersword_p3_elite_kills_grants_stackable_melee_power_parent",
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
				buff_template_name = "weapon_trait_bespoke_powersword_p3_elite_kills_grants_stackable_melee_power_parent",
				find_value_type = "buff_template",
				path = {
					"child_duration",
				},
			},
		},
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powersword_p3_elite_kills_grants_stackable_melee_power_child",
				find_value_type = "buff_template",
				path = {
					"max_stacks",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_powersword_p3_elite_kills_grants_stackable_melee_power_parent = {
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
templates.weapon_trait_bespoke_powersword_p3_guaranteed_melee_crit_on_activated_kill = {
	format_values = {
		crit_chance = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powersword_p3_guaranteed_melee_crit_on_activated_kill",
				find_value_type = "trait_override",
				path = {
					"buff_data",
					"num_stacks_on_proc",
				},
			},
			value_manipulation = function (value)
				return math.abs(value) * 5
			end,
		},
	},
	buffs = {
		weapon_trait_bespoke_powersword_p3_guaranteed_melee_crit_on_activated_kill = {
			{
				buff_data = {
					num_stacks_on_proc = 2,
				},
			},
			{
				buff_data = {
					num_stacks_on_proc = 4,
				},
			},
			{
				buff_data = {
					num_stacks_on_proc = 6,
				},
			},
			{
				buff_data = {
					num_stacks_on_proc = 8,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_powersword_p3_increased_crit_chance_on_weakspot_kill = {
	format_values = {
		crit_chance = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powersword_p3_increased_crit_chance_on_weakspot_kill",
				find_value_type = "trait_override",
				path = {
					"proc_stat_buffs",
					stat_buffs.melee_critical_strike_chance,
				},
			},
		},
		time = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powersword_p3_increased_crit_chance_on_weakspot_kill",
				find_value_type = "buff_template",
				path = {
					"active_duration",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_powersword_p3_increased_crit_chance_on_weakspot_kill = {
			{
				proc_stat_buffs = {
					[stat_buffs.melee_critical_strike_chance] = 0.05,
				},
			},
			{
				proc_stat_buffs = {
					[stat_buffs.melee_critical_strike_chance] = 0.1,
				},
			},
			{
				proc_stat_buffs = {
					[stat_buffs.melee_critical_strike_chance] = 0.15,
				},
			},
			{
				proc_stat_buffs = {
					[stat_buffs.melee_critical_strike_chance] = 0.2,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_powersword_p3_pass_past_armor_on_weapon_special = {
	format_values = {
		heavy_damage = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powersword_p3_pass_past_armor_on_weapon_special",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.melee_heavy_damage,
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_powersword_p3_pass_past_armor_on_weapon_special = {
			{
				stat_buffs = {
					[stat_buffs.melee_heavy_damage] = 0.04,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.melee_heavy_damage] = 0.06,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.melee_heavy_damage] = 0.08,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.melee_heavy_damage] = 0.1,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_powersword_p3_infinite_melee_cleave_on_crit = {
	format_values = {
		hit_mass = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powersword_p3_infinite_melee_cleave_on_crit",
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
				buff_template_name = "weapon_trait_bespoke_powersword_p3_infinite_melee_cleave_on_crit",
				find_value_type = "buff_template",
				path = {
					"active_duration",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_powersword_p3_infinite_melee_cleave_on_crit = {
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
templates.weapon_trait_bespoke_powersword_p3_stacking_finesse_on_one_hit_kill = {
	format_values = {
		finesse = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powersword_p3_stacking_finesse_on_one_hit_kill_parent",
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
				buff_template_name = "weapon_trait_bespoke_powersword_p3_stacking_finesse_on_one_hit_kill_parent",
				find_value_type = "trait_override",
				path = {
					"max_stacks",
				},
			},
		},
		time = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powersword_p3_stacking_finesse_on_one_hit_kill_parent",
				find_value_type = "buff_template",
				path = {
					"child_duration",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_powersword_p3_stacking_finesse_on_one_hit_kill_parent = {
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
templates.weapon_trait_bespoke_powersword_p3_refund_charge_on_weapon_special_weakspot_kill = {
	format_values = {
		time = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_powersword_p3_refund_charge_on_weapon_special_weakspot_kill",
				find_value_type = "trait_override",
				path = {
					"cooldown_duration",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_powersword_p3_refund_charge_on_weapon_special_weakspot_kill = {
			{
				cooldown_duration = 6,
			},
			{
				cooldown_duration = 5,
			},
			{
				cooldown_duration = 4,
			},
			{
				cooldown_duration = 3,
			},
		},
	},
}

return templates
