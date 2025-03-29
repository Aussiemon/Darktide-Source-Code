-- chunkname: @scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_ogryn_combatblade_p1.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local templates = {}

table.make_unique(templates)

local stat_buffs = BuffSettings.stat_buffs

templates.weapon_trait_bespoke_ogryn_combatblade_p1_crit_chance_on_push = {
	format_values = {
		crit_chance = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_combatblade_p1_crit_chance_on_push",
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
				buff_template_name = "weapon_trait_bespoke_ogryn_combatblade_p1_crit_chance_on_push",
				find_value_type = "buff_template",
				path = {
					"active_duration",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_ogryn_combatblade_p1_crit_chance_on_push = {
			{
				proc_stat_buffs = {
					[stat_buffs.melee_critical_strike_chance] = 0.075,
				},
			},
			{
				proc_stat_buffs = {
					[stat_buffs.melee_critical_strike_chance] = 0.1,
				},
			},
			{
				proc_stat_buffs = {
					[stat_buffs.melee_critical_strike_chance] = 0.125,
				},
			},
			{
				proc_stat_buffs = {
					[stat_buffs.melee_critical_strike_chance] = 0.15,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_ogryn_combatblade_p1_increase_power_on_kill = {
	format_values = {
		power_level = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_combatblade_p1_increase_power_on_kill_parent",
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
				buff_template_name = "weapon_trait_bespoke_ogryn_combatblade_p1_increase_power_on_kill_parent",
				find_value_type = "buff_template",
				path = {
					"child_duration",
				},
			},
		},
		stacks = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_combatblade_p1_increase_power_on_kill_child",
				find_value_type = "buff_template",
				path = {
					"max_stacks",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_ogryn_combatblade_p1_increase_power_on_kill_parent = {
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
templates.weapon_trait_bespoke_ogryn_combatblade_p1_increased_attack_cleave_on_multiple_hits = {
	format_values = {
		cleave = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_combatblade_p1_increased_attack_cleave_on_multiple_hits",
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
				buff_template_name = "weapon_trait_bespoke_ogryn_combatblade_p1_increased_attack_cleave_on_multiple_hits",
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
				buff_template_name = "weapon_trait_bespoke_ogryn_combatblade_p1_increased_attack_cleave_on_multiple_hits",
				find_value_type = "buff_template",
				path = {
					"active_duration",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_ogryn_combatblade_p1_increased_attack_cleave_on_multiple_hits = {
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
templates.weapon_trait_bespoke_ogryn_combatblade_p1_increased_power_on_weapon_special_follow_up_hits = {
	format_values = {
		power = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_combatblade_p1_increased_power_on_weapon_special_follow_up_hits",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.power_level_modifier,
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_ogryn_combatblade_p1_increased_power_on_weapon_special_follow_up_hits = {
			{
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.1,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.15,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.2,
				},
			},
			{
				stat_buffs = {
					[stat_buffs.power_level_modifier] = 0.25,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_ogryn_combatblade_p1_pass_past_armor_on_heavy_attack = {
	format_values = {
		damage = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_combatblade_p1_pass_past_armor_on_heavy_attack",
				find_value_type = "trait_override",
				path = {
					"stat_buffs",
					stat_buffs.melee_fully_charged_damage,
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_ogryn_combatblade_p1_pass_past_armor_on_heavy_attack = {
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
templates.weapon_trait_bespoke_ogryn_combatblade_p1_infinite_melee_cleave_on_crit = {
	format_values = {
		hit_mass = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_combatblade_p1_infinite_melee_cleave_on_crit",
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
				buff_template_name = "weapon_trait_bespoke_ogryn_combatblade_p1_infinite_melee_cleave_on_crit",
				find_value_type = "buff_template",
				path = {
					"active_duration",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_ogryn_combatblade_p1_infinite_melee_cleave_on_crit = {
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
templates.weapon_trait_bespoke_ogryn_combatblade_p1_toughness_recovery_on_chained_attacks = {
	format_values = {
		toughness = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_combatblade_p1_toughness_recovery_on_chained_attacks",
				find_value_type = "trait_override",
				path = {
					"toughness_fixed_percentage",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_ogryn_combatblade_p1_toughness_recovery_on_chained_attacks = {
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
templates.weapon_trait_bespoke_ogryn_combatblade_p1_toughness_recovery_on_multiple_hits = {
	format_values = {
		toughness = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_combatblade_p1_toughness_recovery_on_multiple_hits",
				find_value_type = "trait_override",
				path = {
					"buff_data",
					"replenish_percentage",
				},
			},
		},
		multiple_hit = {
			format_type = "number",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_combatblade_p1_toughness_recovery_on_multiple_hits",
				find_value_type = "trait_override",
				path = {
					"buff_data",
					"required_num_hits",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_ogryn_combatblade_p1_toughness_recovery_on_multiple_hits = {
			{
				buff_data = {
					replenish_percentage = 0.12,
					required_num_hits = 3,
				},
			},
			{
				buff_data = {
					replenish_percentage = 0.13,
					required_num_hits = 3,
				},
			},
			{
				buff_data = {
					replenish_percentage = 0.14,
					required_num_hits = 3,
				},
			},
			{
				buff_data = {
					replenish_percentage = 0.15,
					required_num_hits = 3,
				},
			},
		},
	},
}
templates.weapon_trait_bespoke_ogryn_combatblade_p1_windup_increases_power = {
	format_values = {
		power_level = {
			format_type = "percentage",
			prefix = "+",
			find_value = {
				buff_template_name = "weapon_trait_bespoke_ogryn_combatblade_p1_windup_increases_power_parent",
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
				buff_template_name = "weapon_trait_bespoke_ogryn_combatblade_p1_windup_increases_power_child",
				find_value_type = "buff_template",
				path = {
					"max_stacks",
				},
			},
		},
	},
	buffs = {
		weapon_trait_bespoke_ogryn_combatblade_p1_windup_increases_power_parent = {
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

return templates
